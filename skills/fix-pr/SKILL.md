---
name: fix-pr
description: Use when a pull request on the current branch has review comments, failing CI checks, or coverage gaps to address — guides a triaged cleanup pass that fixes feedback in priority order without bundling unrelated changes.
---

# Fix PR

Workflow for cleaning up the current branch's open PR after review or CI feedback. The goal is a focused fix pass — no unrelated cleanups, no silent rewrites, regressions tightened where behavior changes.

## When to use

- A PR you opened has new review comments.
- CI checks are failing on the latest push.
- A coverage report flagged uncovered lines on the PR diff.
- A reviewer asked for specific changes in an issue comment thread.

## When NOT to use

- For drafting an initial implementation (use a planning or implementation skill).
- For unrelated cleanup work — open a separate PR.
- When the PR's intent itself is wrong — discuss the design before fixing comments line-by-line.

## Step 1: Gather PR state

Confirm an open PR exists for the current branch and collect feedback surfaces:

```bash
git branch --show-current
gh pr view --json number,title,url,baseRefName,headRefName,headRefOid
gh pr view --comments
gh pr checks
```

Pull every inline review comment, PR conversation comment, linked-issue comment referenced by reviewers, CI failure log, and coverage-tool comment (Codecov, Coveralls, etc.). If the user points to another feedback source (Slack, email, design doc), include that too.

If there is no open PR for the current branch, stop and report.

## Step 2: Triage findings

Address feedback in this priority order:

1. **Failing checks** — build, lint, type-check, tests, format.
2. **Correctness review comments** — bugs, wrong logic, missing handling.
3. **Missing regression coverage** — tests for the behavior the PR changes.
4. **Style / cleanup comments** — naming, structure, doc strings.

Do not bundle unrelated cleanups into the same pass. If you spot something off-topic, note it for a follow-up PR.

## Step 3: Reproduce locally

Run the project's canonical local gate first:

```bash
# Examples — use whichever the repo provides:
make check       # if a Makefile is present
cargo test       # Rust
uv run pytest    # Python
julia --project -e 'using Pkg; Pkg.test()'  # Julia
npm test         # Node
```

Read the repo's `CLAUDE.md` / `README.md` / `Makefile` for the exact command. If a feature flag is involved (e.g., a CUDA-only path), run only the variants the local environment supports — note skipped variants in the final report.

## Step 4: Fix review comments

For each valid comment:

- Read the referenced code in full — not just the diff hunk.
- Implement the minimal fix.
- Add or tighten a regression test when the change is behavioral.
- Rerun the narrowest relevant tests first, then the broader gate.

If a comment is technically wrong, do not silently apply it. Record the reasoning for declining, post a reply on the PR if appropriate, and do not rewrite unrelated code while addressing it.

## Step 5: Close coverage gaps

Prefer targeted regression tests over broad smoke tests. For each uncovered line on the diff:

- Add a test that exercises that branch with realistic inputs.
- Assert observable behavior (return values, side effects, error messages), not just types or shapes.
- Include at least one adversarial / edge-case test where reasonable.

## Step 6: Verify and commit

Before committing:

```bash
make check     # or the project's canonical gate
```

Confirm all previously failing checks now pass locally. Commit with a message that states what class of feedback was addressed (e.g., `Address review: fix off-by-one in foo and add regression`). Push, then verify the PR's checks turn green.

If the user did not ask for a commit, leave the worktree changes in place and report what was changed and what still needs decision.

## Common mistakes

| Mistake | Fix |
|---|---|
| Bundling unrelated cleanups | Stop. Stash. Open a separate PR for the cleanup. |
| Silently applying a wrong review comment | Reply on the PR with the reasoning instead. |
| Skipping the local gate before committing | Always rerun `make check` (or the project equivalent) after the last edit. |
| Adding a smoke test instead of a regression | The test should fail without your fix and pass with it. |
| Force-pushing without checking the PR is still attached | After `git push --force-with-lease`, recheck `gh pr view` to confirm the PR points at the right SHA. |
