import assert from "node:assert/strict";
import { execFileSync } from "node:child_process";
import {
  existsSync,
  mkdirSync,
  mkdtempSync,
  readFileSync,
  rmSync,
  writeFileSync
} from "node:fs";
import { devNull, tmpdir } from "node:os";
import { dirname, join } from "node:path";
import test from "node:test";

const ownedPaths = [
  "docs/config.toml",
  "docs/layouts/partials/hooks/body-end.html"
];
const gitEnvironment = {
  ...process.env,
  GIT_CONFIG_GLOBAL: process.platform === "win32" ? "NUL" : devNull,
  GIT_CONFIG_NOSYSTEM: "1"
};
const workflow = readFileSync(
  new URL("../workflows/upmerge.yaml", import.meta.url),
  "utf8"
).replaceAll("\r\n", "\n");

function step(name) {
  const found = workflow
    .split(/^      - name: /m)
    .find((value) => value.startsWith(`${name}\n`));
  assert.ok(found, `Missing workflow step: ${name}`);
  return found;
}

function runStep(name, cwd, env = {}, prefix = "") {
  const script = step(name).match(/^        run: \|\n((?:          [^\n]*\n|\n)+)/m);
  assert.ok(script, `Missing run block: ${name}`);
  return execFileSync(
    "bash",
    [
      "--noprofile",
      "--norc",
      "-e",
      "-o",
      "pipefail",
      "-c",
      `${prefix}\n${script[1].replace(/^          /gm, "")}`
    ],
    {
      cwd,
      encoding: "utf8",
      stdio: ["pipe", "pipe", "pipe"],
      env: { ...gitEnvironment, ...env }
    }
  );
}

function git(cwd, ...args) {
  return execFileSync(
    "git",
    [
      "-c",
      "user.name=Upmerge Fixture",
      "-c",
      "user.email=fixture@example.com",
      "-c",
      "commit.gpgsign=false",
      ...args
    ],
    {
      cwd,
      encoding: "utf8",
      stdio: ["pipe", "pipe", "pipe"],
      env: gitEnvironment
    }
  ).trim();
}

function writeFiles(cwd, files) {
  for (const [path, content] of Object.entries(files)) {
    const target = join(cwd, path);
    if (content === null) {
      rmSync(target, { force: true });
    } else {
      mkdirSync(dirname(target), { recursive: true });
      writeFileSync(target, content);
    }
  }
}

function fixture(t, initial = {}) {
  const root = mkdtempSync(join(tmpdir(), "docs-upmerge-"));
  t.after(() => rmSync(root, { recursive: true, force: true }));
  const origin = join(root, "origin");
  const target = join(root, "target");
  const output = join(root, "output");
  mkdirSync(origin);
  git(origin, "init", "--quiet", "--initial-branch=edge");
  git(origin, "config", "core.autocrlf", "false");
  writeFiles(origin, {
    "shared.txt": "first\nmiddle\nlast\n",
    "deleted.txt": "delete from source\n",
    ...Object.fromEntries(ownedPaths.map((path) => [path, "original\n"])),
    ...initial
  });
  git(origin, "add", "--all");
  git(origin, "commit", "--quiet", "--message=initial");
  git(origin, "branch", "release");

  return {
    origin,
    target,
    output,
    change(branch, files) {
      git(origin, "checkout", "--quiet", branch);
      writeFiles(origin, files);
      git(origin, "add", "--all");
      git(origin, "commit", "--quiet", `--message=Update ${branch}`);
      return git(origin, "rev-parse", "HEAD");
    },
    prepare(source = git(origin, "rev-parse", "release"), prefix = "") {
      git(root, "clone", "--quiet", "--no-local", "--branch=edge", origin, target);
      git(target, "config", "core.autocrlf", "false");
      runStep(
        "Upmerge docs",
        target,
        { GITHUB_SHA: source, GITHUB_OUTPUT: output },
        prefix
      );
      const outputs = Object.fromEntries(
        readFileSync(output, "utf8")
          .trim()
          .split("\n")
          .map((line) => line.split("="))
      );
      return {
        base: outputs["base-sha"],
        conflict: outputs.conflict === "true",
        hasChanges: outputs["has-changes"] === "true",
        tree: git(target, "write-tree")
      };
    },
    content(path) {
      return readFileSync(join(target, path), "utf8");
    }
  };
}

test("clean squash preparation preserves both branches, not unsigned source ancestry", (t) => {
  const f = fixture(t);
  const base = f.change("edge", {
    "shared.txt": "edge\nmiddle\nlast\n",
    "edge-only.txt": "keep edge\n"
  });
  const source = f.change("release", {
    "shared.txt": "first\nmiddle\nsource\n",
    "source-only.txt": "add source\n",
    "deleted.txt": null
  });
  const result = f.prepare(source);
  assert.equal(result.conflict, false);
  assert.equal(result.hasChanges, true);
  assert.equal(result.base, base);
  assert.equal(f.content("shared.txt"), "edge\nmiddle\nsource\n");
  assert.equal(f.content("edge-only.txt"), "keep edge\n");
  assert.equal(f.content("source-only.txt"), "add source\n");
  assert.equal(existsSync(join(f.target, "deleted.txt")), false);
  assert.equal(git(f.target, "rev-parse", "HEAD"), base);
  assert.equal(git(f.origin, "rev-parse", "release"), source);
  assert.equal(git(f.origin, "rev-parse", "edge"), base);
  assert.equal(git(f.origin, "log", "-1", "--format=%G?", source), "N");
  assert.equal(existsSync(join(f.target, ".git", "MERGE_HEAD")), false);

  // Model the action committing the prepared workspace, not a signed API call.
  git(f.target, "commit", "--quiet", "--message=fixture");
  assert.equal(git(f.target, "rev-list", "--count", `${base}..HEAD`), "1");
  assert.equal(git(f.target, "show", "-s", "--format=%P", "HEAD"), base);
  assert.equal(git(f.target, "show", "-s", "--format=%T", "HEAD"), result.tree);
  assert.throws(
    () => git(f.target, "merge-base", "--is-ancestor", source, "HEAD"),
    (error) => error.status === 1
  );
});

test("content conflicts stage an explicit source snapshot without conflict markers", (t) => {
  const f = fixture(t);
  const base = f.change("edge", {
    "shared.txt": "edge\n",
    "edge-only.txt": "manual reconciliation needed\n",
    ...Object.fromEntries(ownedPaths.map((path) => [path, "edge settings\n"]))
  });
  const source = f.change("release", {
    "shared.txt": "source\n",
    "source-only.txt": "source addition\n",
    ...Object.fromEntries(ownedPaths.map((path) => [path, "release settings\n"]))
  });
  const result = f.prepare(source);
  assert.equal(result.conflict, true);
  assert.equal(result.hasChanges, true);
  assert.equal(f.content("shared.txt"), "source\n");
  assert.equal(f.content("source-only.txt"), "source addition\n");
  assert.equal(existsSync(join(f.target, "edge-only.txt")), false);
  for (const path of ownedPaths) {
    assert.equal(f.content(path), "edge settings\n");
  }
  assert.equal(git(f.target, "rev-parse", "HEAD"), base);
  assert.equal(git(f.origin, "rev-parse", "release"), source);
  assert.equal(git(f.target, "ls-files", "--unmerged"), "");
  assert.equal(existsSync(join(f.target, ".git", "MERGE_HEAD")), false);
  assert.equal(
    git(f.target, "diff", "--name-only", source, result.tree),
    ownedPaths.join("\n")
  );
});

test("only edge-owned conflicts preserve the combined tree without a draft fallback", (t) => {
  const f = fixture(t);
  f.change("edge", {
    "edge-only.txt": "keep edge\n",
    [ownedPaths[0]]: "edge settings\n",
    [ownedPaths[1]]: null
  });
  f.change("release", {
    "source-only.txt": "add source\n",
    ...Object.fromEntries(ownedPaths.map((path) => [path, "release settings\n"]))
  });
  assert.equal(f.prepare().conflict, false);
  assert.equal(f.content("edge-only.txt"), "keep edge\n");
  assert.equal(f.content("source-only.txt"), "add source\n");
  assert.equal(f.content(ownedPaths[0]), "edge settings\n");
  assert.equal(existsSync(join(f.target, ownedPaths[1])), false);
});

for (const conflict of [false, true]) {
  test(`edge-owned overrides and deletions survive (conflict=${conflict})`, (t) => {
    const f = fixture(t);
    f.change("edge", {
      [ownedPaths[0]]: "edge settings\n",
      [ownedPaths[1]]: null,
      ...(conflict ? { "shared.txt": "edge\n" } : {})
    });
    f.change("release", {
      [ownedPaths[0]]: null,
      [ownedPaths[1]]: "release settings\n",
      "source-only.txt": "add source\n",
      ...(conflict ? { "shared.txt": "source\n" } : {})
    });
    assert.equal(f.prepare().conflict, conflict);
    assert.equal(f.content(ownedPaths[0]), "edge settings\n");
    assert.equal(existsSync(join(f.target, ownedPaths[1])), false);
  });
}

for (const sourceAddsOwnedFiles of [false, true]) {
  test(`edge-owned files absent from edge stay absent (source adds=${sourceAddsOwnedFiles})`, (t) => {
    const f = fixture(t, Object.fromEntries(ownedPaths.map((path) => [path, null])));
    f.change("release", {
      "source-only.txt": "source\n",
      ...(sourceAddsOwnedFiles
        ? Object.fromEntries(ownedPaths.map((path) => [path, "release settings\n"]))
        : {})
    });
    assert.equal(f.prepare().hasChanges, true);
    for (const path of ownedPaths) {
      assert.equal(existsSync(join(f.target, path)), false);
    }
  });
}

for (const scenario of [
  "identical",
  "ancestor",
  "already applied",
  "edge-owned only"
]) {
  test(`${scenario} source produces no PR changes`, (t) => {
    const f = fixture(t);
    if (scenario === "ancestor") {
      f.change("edge", { "shared.txt": "newer edge\n", "edge-only.txt": "keep\n" });
    } else if (scenario === "already applied") {
      f.change("edge", { "source-only.txt": "same content\n" });
      f.change("release", { "source-only.txt": "same content\n" });
    } else if (scenario === "edge-owned only") {
      f.change("release", {
        ...Object.fromEntries(ownedPaths.map((path) => [path, "release settings\n"]))
      });
    }
    const base = git(f.origin, "rev-parse", "edge");
    const result = f.prepare();
    assert.equal(result.hasChanges, false);
    assert.equal(result.conflict, false);
    assert.equal(result.tree, git(f.target, "rev-parse", `${base}^{tree}`));
    assert.equal(git(f.target, "status", "--porcelain"), "");
  });
}

test("a missing source fails instead of creating a draft or reporting no changes", (t) => {
  const f = fixture(t);
  assert.throws(
    () => f.prepare("f".repeat(40)),
    /not our ref|couldn't find remote ref/
  );
  assert.equal(existsSync(f.output), false);
});

test("unrelated histories fail instead of being treated as content conflicts", (t) => {
  const f = fixture(t);
  git(f.origin, "checkout", "--quiet", "--orphan=unrelated");
  git(f.origin, "add", "--all");
  git(f.origin, "commit", "--quiet", "--message=unrelated");
  assert.throws(
    () => f.prepare(git(f.origin, "rev-parse", "HEAD")),
    /unrelated histories/
  );
  assert.equal(existsSync(f.output), false);
});

for (const [command, status] of [
  ["merge", 1],
  ["merge", 128],
  ["ls-files", 128],
  ["ls-tree", 128],
  ["restore", 128],
  ["rm", 128],
  ["read-tree", 128],
  ["diff", 2]
]) {
  test(`git ${command} exit ${status} without a content result fails closed`, (t) => {
    const f = fixture(t);
    if (command === "read-tree") {
      f.change("edge", { "shared.txt": "edge\n" });
      f.change("release", { "shared.txt": "source\n" });
    } else if (command === "rm") {
      f.change("edge", { [ownedPaths[0]]: null });
      f.change("release", { [ownedPaths[0]]: "release settings\n" });
    }
    const prefix = `git() {
      if [[ "$1" == "${command}" ]]; then
        echo "fixture ${command} failure" >&2
        return ${status}
      fi
      command git "$@"
    }`;
    assert.throws(
      () => f.prepare(undefined, prefix),
      (error) =>
        error.status === status &&
        error.stderr.includes(`fixture ${command} failure`)
    );
    assert.equal(existsSync(f.output), false);
  });
}

test("a real index lock failure is not disguised as a conflict", (t) => {
  const f = fixture(t);
  f.change("release", { "source-only.txt": "source\n" });
  assert.throws(() => f.prepare(undefined, "touch .git/index.lock"), /index.lock/);
  assert.equal(existsSync(f.output), false);
});

for (const [number, verified, success] of [
  ["123", "true", true],
  ["", "true", false],
  ["123", "false", false],
  ["123", "", false],
  ["123", "TRUE", false]
]) {
  test(`action output gate: PR=${number || "missing"}, verified=${verified || "missing"}`, () => {
    const run = () =>
      runStep("Verify signed upmerge", process.cwd(), {
        PR_NUMBER: number,
        COMMITS_VERIFIED: verified
      });
    if (success) {
      assert.doesNotThrow(run);
    } else {
      assert.throws(run, (error) => error.status === 1);
    }
  });
}

test("workflow directly wires pinned CPR signing, DCO, no-op/draft handling, and verified outputs", () => {
  for (const permission of ["contents", "pull-requests", "workflows"]) {
    assert.ok(step("Get App Token").includes(`permission-${permission}: write`));
  }
  assert.match(step("Get App Token"), /repositories: docs/);
  assert.match(step("Checkout edge"), /ref: edge/);
  assert.match(step("Checkout edge"), /fetch-depth: 0/);
  assert.match(
    step("Checkout edge"),
    /token: \$\{\{ steps.app-token.outputs.token \}\}/
  );
  assert.match(
    step("Upmerge docs"),
    /git fetch --no-tags origin "\$\{GITHUB_SHA\}"/
  );
  assert.match(
    step("Upmerge docs"),
    /git merge --squash --no-commit "\$\{GITHUB_SHA\}"/
  );

  const publish = step("Create pull request");
  assert.match(
    publish,
    /peter-evans\/create-pull-request@5f6978faf089d4d20b00c7766989d076bb2fc7f1/
  );
  assert.match(publish, /token: \$\{\{ steps.app-token.outputs.token \}\}/);
  assert.match(publish, /sign-commits: true/);
  assert.match(
    publish,
    /Signed-off-by: \$\{\{ steps.bot-details.outputs.name \}\} <\$\{\{ steps.bot-details.outputs.email \}\}>/
  );
  assert.match(publish, /base: edge/);
  assert.match(
    publish,
    /branch: upmerge\/\$\{\{ github.run_id \}\}-\$\{\{ github.run_attempt \}\}/
  );
  assert.match(publish, /if: steps.prepare.outputs.has-changes == 'true'/);
  assert.match(
    publish,
    /draft: \$\{\{ steps.prepare.outputs.conflict == 'true' \}\}/
  );
  assert.match(publish, /not a resolved merge/);
  assert.doesNotMatch(publish, /^\s+(author|committer):/m);
  assert.doesNotMatch(
    workflow,
    /\bgit (commit|push)\b|\bgh pr\b|github-script|workflow-tooling|upmerge\.mjs/
  );

  const verify = step("Verify signed upmerge");
  assert.match(verify, /if: steps.prepare.outputs.has-changes == 'true'/);
  assert.match(
    verify,
    /PR_NUMBER: \$\{\{ steps.pull-request.outputs.pull-request-number \}\}/
  );
  assert.match(
    verify,
    /COMMITS_VERIFIED: \$\{\{ steps.pull-request.outputs.pull-request-commits-verified \}\}/
  );
});
