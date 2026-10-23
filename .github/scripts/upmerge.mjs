import childProcess from "node:child_process";

const edgeOwnedPaths = [
  "docs/config.toml",
  "docs/layouts/partials/hooks/body-end.html"
];
const objectId = /^[0-9a-f]{40}$/;

function git(cwd, args, allowedStatuses = [0]) {
  const result = childProcess.spawnSync("git", args, {
    cwd,
    encoding: "utf8"
  });
  if (result.error) {
    throw result.error;
  }
  if (!allowedStatuses.includes(result.status)) {
    throw new Error(
      `git ${args.join(" ")} failed (${result.status}): ${result.stderr || result.stdout}`
    );
  }
  return result;
}

function gitOutput(cwd, args) {
  return git(cwd, args).stdout.trim();
}

export function prepareUpmerge({ cwd, source }) {
  if (!objectId.test(source)) {
    throw new Error("The source must be the full workflow source commit SHA.");
  }
  if (gitOutput(cwd, ["status", "--porcelain", "--untracked-files=all"])) {
    throw new Error("Upmerge preparation requires a clean edge checkout.");
  }
  const base = gitOutput(cwd, ["rev-parse", "--verify", "refs/heads/edge^{commit}"]);
  if (gitOutput(cwd, ["rev-parse", "HEAD"]) !== base) {
    throw new Error("Upmerge preparation must start at edge.");
  }
  git(cwd, ["fetch", "--no-tags", "origin", source]);
  if (gitOutput(cwd, ["rev-parse", "--verify", "FETCH_HEAD^{commit}"]) !== source) {
    throw new Error("The fetched source does not match the workflow source.");
  }

  // merge-tree changes neither HEAD nor the index, even when content conflicts.
  const merged = git(
    cwd,
    [
      "merge-tree",
      "--write-tree",
      "--name-only",
      "--no-messages",
      "-z",
      base,
      source
    ],
    [0, 1]
  );
  const [mergedTree, ...conflictedPaths] = merged.stdout.split("\0");
  if (
    conflictedPaths.pop() !== "" ||
    !objectId.test(mergedTree) ||
    conflictedPaths.some((path) => path === "") ||
    (merged.status === 1) !== (conflictedPaths.length > 0) ||
    gitOutput(cwd, ["cat-file", "-t", mergedTree]) !== "tree"
  ) {
    throw new Error("Unexpected git merge-tree output; refusing an upmerge.");
  }

  const conflicts = conflictedPaths.filter(
    (path) =>
      !edgeOwnedPaths.some(
        (owned) => path === owned || path.startsWith(`${owned}/`)
      )
  );
  const conflict = conflicts.length > 0;
  const candidateTree = conflict
    ? gitOutput(cwd, ["rev-parse", `${source}^{tree}`])
    : mergedTree;
  // Materialize only the selected tree. No source parent or merge state is kept.
  git(cwd, ["read-tree", "--reset", "-u", candidateTree]);
  for (const path of edgeOwnedPaths) {
    if (
      gitOutput(cwd, ["ls-tree", "-z", base, "--", path]) ||
      gitOutput(cwd, ["ls-files", "-z", "--", path])
    ) {
      git(cwd, [
        "restore",
        `--source=${base}`,
        "--staged",
        "--worktree",
        "--",
        path
      ]);
    }
  }

  const tree = gitOutput(cwd, ["write-tree"]);
  const baseTree = gitOutput(cwd, ["rev-parse", `${base}^{tree}`]);
  if (gitOutput(cwd, ["rev-parse", "HEAD"]) !== base) {
    throw new Error("Upmerge preparation unexpectedly changed HEAD.");
  }
  return { base, source, tree, conflict, conflicts, hasChanges: tree !== baseTree };
}

export async function verifyUpmerge({
  github,
  owner,
  repo,
  pullNumber,
  head,
  branch,
  base,
  tree,
  conflict,
  signoff
}) {
  if (
    !Number.isSafeInteger(pullNumber) ||
    pullNumber <= 0 ||
    ![head, base, tree].every((sha) => objectId.test(sha)) ||
    !branch?.startsWith("upmerge/") ||
    !/^Signed-off-by: .+ <[^<>]+>$/.test(signoff)
  ) {
    throw new Error("Missing or invalid signed upmerge outputs.");
  }
  const { data: pull } = await github.rest.pulls.get({
    owner,
    repo,
    pull_number: pullNumber
  });
  if (
    pull.state !== "open" ||
    pull.base.repo?.full_name !== `${owner}/${repo}` ||
    pull.head.repo?.full_name !== `${owner}/${repo}` ||
    pull.base.ref !== "edge" ||
    pull.head.ref !== branch ||
    pull.head.sha !== head ||
    pull.draft !== conflict
  ) {
    throw new Error(
      "The upmerge PR does not match the expected branches or draft state."
    );
  }
  if (pull.base.sha !== base) {
    throw new Error(
      "Edge moved during the upmerge. Run a new upmerge from the updated base."
    );
  }
  if (pull.commits !== 1) {
    throw new Error(
      "The upmerge must introduce exactly one commit, not source history."
    );
  }

  const { data: commit } = await github.rest.git.getCommit({
    owner,
    repo,
    commit_sha: head
  });
  if (
    commit.sha !== head ||
    commit.parents.length !== 1 ||
    commit.parents[0].sha !== base
  ) {
    throw new Error(
      "The upmerge commit must have exactly one parent: the prepared edge base."
    );
  }
  if (commit.tree.sha !== tree) {
    throw new Error("The published upmerge tree differs from the prepared tree.");
  }
  if (
    commit.verification?.verified !== true ||
    commit.verification.reason !== "valid"
  ) {
    throw new Error(
      `The upmerge commit is not GitHub-verified: ${commit.verification?.reason ?? "missing verification"}.`
    );
  }
  if (!commit.message.split(/\r?\n/).includes(signoff)) {
    throw new Error("The upmerge commit is missing the App's DCO signoff.");
  }
  return pull.html_url;
}
