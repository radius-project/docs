import assert from "node:assert/strict";
import childProcess from "node:child_process";
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
import { prepareUpmerge, verifyUpmerge } from "./upmerge.mjs";

const ownedPaths = [
  "docs/config.toml",
  "docs/layouts/partials/hooks/body-end.html"
];
const gitEnvironment = {
  ...process.env,
  GIT_CONFIG_GLOBAL: process.platform === "win32" ? "NUL" : devNull,
  GIT_CONFIG_NOSYSTEM: "1"
};

function git(cwd, ...args) {
  return childProcess
    .execFileSync(
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
    )
    .trim();
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
  // Isolate the helper's real Git processes from the developer's global config.
  const spawn = childProcess.spawnSync;
  t.mock.method(childProcess, "spawnSync", (command, args, options) =>
    spawn(command, args, { ...options, env: gitEnvironment })
  );
  const root = mkdtempSync(join(tmpdir(), "docs-upmerge-"));
  t.after(() => rmSync(root, { recursive: true, force: true }));
  const origin = join(root, "origin");
  const target = join(root, "target");
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
    change(branch, files) {
      git(origin, "checkout", "--quiet", branch);
      writeFiles(origin, files);
      git(origin, "add", "--all");
      git(origin, "commit", "--quiet", `--message=Update ${branch}`);
      return git(origin, "rev-parse", "HEAD");
    },
    prepare(source = git(origin, "rev-parse", "release")) {
      git(root, "clone", "--quiet", "--no-local", "--branch=edge", origin, target);
      git(target, "config", "core.autocrlf", "false");
      return prepareUpmerge({ cwd: target, source });
    },
    content(path) {
      return readFileSync(join(target, path), "utf8");
    }
  };
}

test("clean merge preserves both branches without importing unsigned ancestry", (t) => {
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
  assert.equal(result.source, source);
  assert.equal(f.content("shared.txt"), "edge\nmiddle\nsource\n");
  assert.equal(f.content("edge-only.txt"), "keep edge\n");
  assert.equal(f.content("source-only.txt"), "add source\n");
  assert.equal(existsSync(join(f.target, "deleted.txt")), false);
  assert.equal(git(f.target, "rev-parse", "HEAD"), base);
  assert.equal(git(f.origin, "rev-parse", "release"), source);
  assert.equal(git(f.origin, "rev-parse", "edge"), base);
  assert.equal(git(f.target, "write-tree"), result.tree);
  assert.equal(git(f.origin, "log", "-1", "--format=%G?", source), "N");

  // Model the action's single-parent commit without claiming a local signature.
  const head = git(
    f.target,
    "commit-tree",
    result.tree,
    "-p",
    base,
    "-m",
    "fixture"
  );
  assert.equal(git(f.target, "rev-list", "--count", `${base}..${head}`), "1");
  assert.equal(git(f.target, "show", "-s", "--format=%P", head), base);
  assert.equal(git(f.target, "show", "-s", "--format=%T", head), result.tree);
  assert.throws(
    () => git(f.target, "merge-base", "--is-ancestor", source, head),
    (error) => error.status === 1
  );
  assert.equal(existsSync(join(f.target, ".git", "MERGE_HEAD")), false);
});

test("content conflicts prepare an explicit source snapshot, not conflict markers", (t) => {
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
  assert.deepEqual(result.conflicts, ["shared.txt"]);
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
  assert.equal(git(f.target, "write-tree"), result.tree);
  assert.equal(
    git(f.target, "diff", "--name-only", source, result.tree),
    ownedPaths.join("\n")
  );
});

test("only edge-owned conflicts are resolved without discarding a clean merged tree", (t) => {
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
  const result = f.prepare();
  assert.equal(result.conflict, false);
  assert.equal(f.content("edge-only.txt"), "keep edge\n");
  assert.equal(f.content("source-only.txt"), "add source\n");
  assert.equal(f.content(ownedPaths[0]), "edge settings\n");
  assert.equal(existsSync(join(f.target, ownedPaths[1])), false);
});

for (const contentConflict of [false, true]) {
  test(`edge-owned deletions and source deletions are preserved (conflict=${contentConflict})`, (t) => {
    const f = fixture(t);
    f.change("edge", {
      [ownedPaths[0]]: "edge settings\n",
      [ownedPaths[1]]: null,
      ...(contentConflict ? { "shared.txt": "edge\n" } : {})
    });
    f.change("release", {
      [ownedPaths[0]]: null,
      [ownedPaths[1]]: "release settings\n",
      "source-only.txt": "add source\n",
      ...(contentConflict ? { "shared.txt": "source\n" } : {})
    });
    const result = f.prepare();
    assert.equal(result.conflict, contentConflict);
    assert.equal(f.content(ownedPaths[0]), "edge settings\n");
    assert.equal(existsSync(join(f.target, ownedPaths[1])), false);
  });
}

test("edge-owned paths absent from both trees do not fail", (t) => {
  const f = fixture(t, Object.fromEntries(ownedPaths.map((path) => [path, null])));
  f.change("release", { "source-only.txt": "source\n" });
  assert.equal(f.prepare().hasChanges, true);
});

test("source-only edge-owned files remain absent on edge", (t) => {
  const f = fixture(t, Object.fromEntries(ownedPaths.map((path) => [path, null])));
  f.change("release", {
    "source-only.txt": "source\n",
    ...Object.fromEntries(ownedPaths.map((path) => [path, "release settings\n"]))
  });
  const result = f.prepare();
  assert.equal(result.conflict, false);
  assert.equal(result.hasChanges, true);
  for (const path of ownedPaths) {
    assert.equal(existsSync(join(f.target, path)), false);
  }
});

test("identical source is a no-op", (t) => {
  const f = fixture(t);
  const result = f.prepare();
  assert.equal(result.hasChanges, false);
  assert.equal(result.conflict, false);
  assert.equal(git(f.target, "status", "--porcelain"), "");
});

test("an ancestor source is a no-op, preserving newer edge content", (t) => {
  const f = fixture(t);
  const base = f.change("edge", {
    "shared.txt": "newer edge\n",
    "edge-only.txt": "keep edge\n"
  });
  const result = f.prepare();
  assert.equal(result.hasChanges, false);
  assert.equal(result.conflict, false);
  assert.equal(result.tree, git(f.target, "rev-parse", `${base}^{tree}`));
  assert.equal(f.content("shared.txt"), "newer edge\n");
});

test("an independently applied source diff is a no-op", (t) => {
  const f = fixture(t);
  f.change("edge", { "source-only.txt": "same content\n" });
  f.change("release", { "source-only.txt": "same content\n" });
  assert.equal(f.prepare().hasChanges, false);
});

test("changes confined to edge-owned files are a no-op", (t) => {
  const f = fixture(t);
  f.change("release", {
    ...Object.fromEntries(ownedPaths.map((path) => [path, "release settings\n"]))
  });
  assert.equal(f.prepare().hasChanges, false);
  assert.equal(git(f.target, "status", "--porcelain"), "");
});

test("a failed source fetch fails rather than producing a draft or no-op", (t) => {
  const f = fixture(t);
  assert.throws(() => f.prepare("f".repeat(40)), /git fetch .* failed/);
});

test("unrelated histories fail instead of becoming content conflicts", (t) => {
  const f = fixture(t);
  git(f.origin, "checkout", "--quiet", "--orphan=unrelated");
  git(f.origin, "add", "--all");
  git(f.origin, "commit", "--quiet", "--message=unrelated");
  const source = git(f.origin, "rev-parse", "HEAD");
  assert.throws(() => f.prepare(source), /git merge-tree .* failed/);
});

test("dirty worktrees and a checkout not rooted at edge are rejected", (t) => {
  const f = fixture(t);
  const source = f.change("release", { "source-only.txt": "source\n" });
  f.prepare(source);
  assert.throws(
    () => prepareUpmerge({ cwd: f.target, source }),
    /requires a clean edge checkout/
  );
  git(f.target, "read-tree", "--reset", "-u", "HEAD");
  git(f.target, "checkout", "--quiet", "--detach", source);
  assert.throws(
    () => prepareUpmerge({ cwd: f.target, source }),
    /must start at edge/
  );
});

for (const [label, replacement, expected] of [
  [
    "Git failure",
    { status: 128, stdout: "", stderr: "object database failure" },
    /object database failure/
  ],
  [
    "exit one without conflict records",
    { status: 1, stdout: `${"a".repeat(40)}\0`, stderr: "" },
    /Unexpected git merge-tree output/
  ],
  [
    "malformed merge output",
    { status: 0, stdout: "invalid tree\0", stderr: "" },
    /Unexpected git merge-tree output/
  ],
  [
    "process IO failure",
    { error: new Error("spawn EIO") },
    /spawn EIO/
  ]
]) {
  test(`${label} is not reported as a conflict or no-op`, (t) => {
    const f = fixture(t);
    const spawn = childProcess.spawnSync;
    t.mock.method(childProcess, "spawnSync", (command, args, options) =>
      args[0] === "merge-tree" ? replacement : spawn(command, args, options)
    );
    assert.throws(() => f.prepare(), expected);
  });
}

test("an index write failure propagates", (t) => {
  const f = fixture(t);
  const spawn = childProcess.spawnSync;
  t.mock.method(childProcess, "spawnSync", (command, args, options) => {
    if (args[0] === "read-tree") {
      writeFileSync(join(f.target, ".git", "index.lock"), "locked");
    }
    return spawn(command, args, options);
  });
  assert.throws(() => f.prepare(), /git read-tree .* failed/);
});

function verificationFixture() {
  const input = {
    owner: "radius-project",
    repo: "docs",
    pullNumber: 1,
    branch: "upmerge/123-1",
    base: "a".repeat(40),
    head: "b".repeat(40),
    tree: "c".repeat(40),
    conflict: false,
    signoff:
      "Signed-off-by: release[bot] <123+release[bot]@users.noreply.github.com>"
  };
  const pull = {
    state: "open",
    base: {
      ref: "edge",
      sha: input.base,
      repo: { full_name: "radius-project/docs" }
    },
    head: {
      ref: input.branch,
      sha: input.head,
      repo: { full_name: "radius-project/docs" }
    },
    draft: false,
    commits: 1,
    html_url: "https://github.com/radius-project/docs/pull/1"
  };
  const commit = {
    sha: input.head,
    parents: [{ sha: input.base }],
    tree: { sha: input.tree },
    verification: { verified: true, reason: "valid" },
    message: `Upmerge to edge\n\n${input.signoff}\n`
  };
  const calls = [];
  input.github = {
    rest: {
      pulls: {
        async get(args) {
          calls.push(["pull", args]);
          return { data: pull };
        }
      },
      git: {
        async getCommit(args) {
          calls.push(["commit", args]);
          return { data: commit };
        }
      }
    }
  };
  return { input, pull, commit, calls };
}

for (const draft of [false, true]) {
  test(`verification reads the actual GitHub PR and commit (draft=${draft})`, async () => {
    const f = verificationFixture();
    f.input.conflict = draft;
    f.pull.draft = draft;
    assert.equal(await verifyUpmerge(f.input), f.pull.html_url);
    assert.deepEqual(f.calls, [
      ["pull", { owner: "radius-project", repo: "docs", pull_number: 1 }],
      ["commit", { owner: "radius-project", repo: "docs", commit_sha: f.input.head }]
    ]);
  });
}

for (const [label, change, expected] of [
  [
    "missing PR",
    (f) => {
      f.input.pullNumber = 0;
    },
    /invalid signed upmerge outputs/
  ],
  [
    "wrong branch",
    (f) => {
      f.pull.head.ref = "release";
    },
    /expected branches/
  ],
  [
    "wrong head",
    (f) => {
      f.pull.head.sha = f.input.base;
    },
    /expected branches/
  ],
  [
    "wrong draft state",
    (f) => {
      f.pull.draft = true;
    },
    /draft state/
  ],
  [
    "moved edge",
    (f) => {
      f.pull.base.sha = f.input.head;
    },
    /Edge moved/
  ],
  [
    "imported history",
    (f) => {
      f.pull.commits = 2;
    },
    /exactly one commit/
  ],
  [
    "unsigned commit",
    (f) => {
      f.commit.verification = { verified: false, reason: "unsigned" };
    },
    /not GitHub-verified/
  ],
  [
    "invalid signature",
    (f) => {
      f.commit.verification.reason = "invalid";
    },
    /not GitHub-verified/
  ],
  [
    "missing verification",
    (f) => {
      delete f.commit.verification;
    },
    /not GitHub-verified/
  ],
  [
    "merge parent",
    (f) => {
      f.commit.parents.push({ sha: "d".repeat(40) });
    },
    /exactly one parent/
  ],
  [
    "source parent",
    (f) => {
      f.commit.parents[0].sha = "d".repeat(40);
    },
    /prepared edge base/
  ],
  [
    "wrong tree",
    (f) => {
      f.commit.tree.sha = "d".repeat(40);
    },
    /differs from the prepared tree/
  ],
  [
    "missing DCO",
    (f) => {
      f.commit.message = "Upmerge to edge";
    },
    /missing the App's DCO/
  ]
]) {
  test(`verification rejects ${label}`, async () => {
    const f = verificationFixture();
    change(f);
    await assert.rejects(verifyUpmerge(f.input), expected);
  });
}

test("GitHub API failures propagate instead of reporting success", async () => {
  const f = verificationFixture();
  f.input.github.rest.git.getCommit = async () => {
    throw new Error("GitHub unavailable");
  };
  await assert.rejects(verifyUpmerge(f.input), /GitHub unavailable/);
});

test("workflow wires App signing, DCO, source tooling, conflict handling, and verification", () => {
  const workflow = readFileSync(
    new URL("../workflows/upmerge.yaml", import.meta.url),
    "utf8"
  );
  const steps = workflow.split(/^      - name: /m).slice(1);
  const step = (name) => {
    const found = steps.find((value) => value.startsWith(`${name}\n`));
    assert.ok(found, `Missing workflow step: ${name}`);
    return found;
  };
  assert.match(step("Get App Token"), /permission-contents: write/);
  assert.match(step("Get App Token"), /permission-pull-requests: write/);
  assert.match(step("Get App Token"), /permission-workflows: write/);
  assert.match(step("Get App Token"), /repositories: docs/);
  assert.match(
    step("Checkout workflow tooling"),
    /ref: \$\{\{ github.workflow_sha \}\}/
  );
  assert.match(step("Checkout workflow tooling"), /path: workflow-tooling/);
  assert.match(step("Checkout edge"), /ref: edge/);
  assert.match(step("Checkout edge"), /path: upmerge/);
  assert.match(step("Checkout edge"), /fetch-depth: 0/);
  assert.match(
    step("Upmerge docs"),
    /workflow-tooling\/\.github\/scripts\/upmerge\.mjs/
  );
  assert.match(step("Upmerge docs"), /source: process\.env\.GITHUB_SHA/);
  for (const [output, property] of [
    ["base-sha", "base"],
    ["source-sha", "source"],
    ["tree-sha", "tree"],
    ["has-changes", "hasChanges"],
    ["conflict", "conflict"]
  ]) {
    assert.ok(
      step("Upmerge docs").includes(`core.setOutput("${output}", result.${property});`)
    );
  }
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
  assert.match(publish, /path: upmerge/);
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
    /\bgit (commit|push|merge|reset)\b|\bgh pr (create|merge)\b/
  );
  const verify = step("Verify signed upmerge");
  assert.match(verify, /if: steps.prepare.outputs.has-changes == 'true'/);
  assert.match(verify, /github-token: \$\{\{ steps.app-token.outputs.token \}\}/);
  assert.match(verify, /workflow-tooling\/\.github\/scripts\/upmerge\.mjs/);
  assert.match(verify, /await verifyUpmerge\(/);
  for (const expression of [
    "steps.pull-request.outputs.pull-request-number",
    "steps.pull-request.outputs.pull-request-head-sha",
    "steps.prepare.outputs.base-sha",
    "steps.prepare.outputs.tree-sha",
    "steps.prepare.outputs.conflict",
    "steps.bot-details.outputs.name",
    "steps.bot-details.outputs.email"
  ]) {
    assert.ok(verify.includes(`\${{ ${expression} }}`));
  }
});
