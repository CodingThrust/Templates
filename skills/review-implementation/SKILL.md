---
name: review-implementation
description: Use when a code change is finished but not yet committed — dispatches a fresh-context subagent to review the diff for design principles (DRY/KISS/HC-LC), test quality, and (where applicable) public-API ergonomics, then consolidates findings and applies the clear fixes automatically.
---

# Review Implementation

Dispatches a quality-review subagent with **fresh context** (no implementation history bias) to check the diff for design, test, and API quality before the commit lands.

## Why fresh context

The agent that just wrote the code has a strong bias toward declaring it correct. A reviewer with no memory of how the code came to be will notice over-engineering, missing edge-case tests, and unclear error messages that the author has stopped seeing.

## When to use

- You finished implementing a model, rule, feature, bugfix, or refactor.
- Tests pass locally and the diff is ready to commit.
- Before pushing to a shared branch or opening a PR.

## When NOT to use

- Mid-implementation while design is still in flux — the reviewer will flag scaffolding you intend to remove.
- For tiny mechanical changes (one-line fixes, dependency bumps) — overkill.
- After review feedback has already been addressed (use `fix-pr` instead).

## Step 1: Detect what changed

```bash
BASE_SHA=$(git merge-base main HEAD)   # or master / dev — adjust per repo
HEAD_SHA=$(git rev-parse HEAD)
git diff --stat $BASE_SHA..$HEAD_SHA
git diff --name-only $BASE_SHA..$HEAD_SHA
```

### Detect linked issue (optional)

```bash
PR_NUM=$(gh pr view --json number -q .number 2>/dev/null)
if [ -n "$PR_NUM" ]; then
  ISSUE_NUM=$(gh pr view "$PR_NUM" --json body -q .body | grep -oE '#[0-9]+' | head -1 | tr -d '#')
fi
if [ -n "$ISSUE_NUM" ]; then
  ISSUE_BODY=$(gh issue view "$ISSUE_NUM" --json title,body -q '"# " + .title + "\n\n" + .body')
fi
```

If an issue is found, pass it as `{ISSUE_CONTEXT}` to the subagent. If not, set to "No linked issue."

## Step 2: Dispatch the reviewer

Dispatch with the `Agent` tool. Prefer `subagent_type="superpowers:code-reviewer"` if available; otherwise use `general-purpose` with the prompt template below.

Fill in the placeholders and pass as the agent prompt:

---

### Reviewer prompt template

> First, read the repo's `CLAUDE.md` and any language-specific style rules under `.claude/rules/` (e.g., `rust.md`, `julia.md`, `python.md`) to understand the project's conventions. Use these as your review baseline.
>
> You are reviewing code changes for quality in the `{REPO_NAME}` codebase ({ONE_LINE_REPO_PURPOSE}). You have NO context about prior implementation work — review the code fresh.
>
> **What changed:** {DIFF_SUMMARY}
>
> **Changed files:** {CHANGED_FILES}
>
> **Plan / task context:** {PLAN_STEP}
>
> **Linked issue:** {ISSUE_CONTEXT}
>
> **Git range:** Base: {BASE_SHA} / Head: {HEAD_SHA}
>
> Start by running:
> ```bash
> git diff --stat {BASE_SHA}..{HEAD_SHA}
> git diff {BASE_SHA}..{HEAD_SHA}
> ```
> Then read the changed files in full.
>
> **Review criteria:**
>
> 1. **DRY** — Duplicated logic that should be extracted?
> 2. **KISS** — Unnecessarily complex? Over-engineered abstractions, convoluted control flow?
> 3. **HC/LC** (High Cohesion / Low Coupling) — Single responsibility per function/module? "God" functions (>50 lines doing multiple things)?
>
> **Public-API ergonomics** (only if a public surface changed — CLI flags, library entrypoints, MCP/HTTP tools, exported functions):
>
> 4. **Error messages** — Actionable? Bad: `"invalid parameter"`. Good: `"input JSON must include 'num_qubits' field"`.
> 5. **Discoverability** — Documented parameters, examples, sensible defaults?
> 6. **Consistency** — Similar operations expressed similarly (parameter names, output formats)?
> 7. **Least surprise** — Output matches expectations? No silent failures?
> 8. **Feedback** — The operation confirms what it did?
>
> **Test quality:**
>
> 9. **Naive test detection** — Flag tests that:
>    - Only check types/shapes, not values (e.g., `assert is_ok(result)` without checking the result).
>    - Mirror the implementation (recomputing the same formula proves nothing).
>    - Lack adversarial cases (only happy path; no malformed inputs, edge cases, error paths).
>    - Use trivial instances only (n=1 may pass with off-by-one bugs; need n≥3).
>    - Have too few assertions (1-2 asserts on non-trivial code is insufficient).
>
> **Output format:**
>
> ```
> ## Code Quality Review
>
> ### Design Principles
> - DRY: OK / ISSUE — [description with file:line]
> - KISS: OK / ISSUE — [description with file:line]
> - HC/LC: OK / ISSUE — [description with file:line]
>
> ### Public-API ergonomics (if applicable)
> - Error messages: OK / ISSUE — [description]
> - Discoverability: OK / ISSUE — [description]
> - Consistency: OK / ISSUE — [description]
> - Least surprise: OK / ISSUE — [description]
> - Feedback: OK / ISSUE — [description]
>
> ### Test Quality
> - Naive test detection: OK / ISSUE
>   - [specific tests flagged with reason and file:line]
>
> ### Issues
>
> #### Critical (Must Fix)
> [Bugs, correctness issues, data loss risks]
>
> #### Important (Should Fix)
> [Architecture problems, missing tests, poor error handling]
>
> #### Minor (Nice to Have)
> [Code style, optimization opportunities]
>
> ### Summary
> - [action items with severity]
> ```

---

## Step 3: Collect and address findings

When the subagent returns:

1. **Parse the report** — pull out ISSUE items.
2. **Fix automatically** — clear, unambiguous issues at Important+ severity.
3. **Surface for user decision** — ambiguous issues, Minor items, and anything where the right fix isn't obvious.

Do not silently disagree with a finding. If you think the reviewer is wrong, write that down and ask the user.

## Step 4: Present a consolidated report

```
## Review: <description of changes>

### Build Status
- <project's test command>: PASS / FAIL
- <project's lint command>: PASS / FAIL

### Code Quality
- DRY: OK / ...
- KISS: OK / ...
- HC/LC: OK / ...

### Public-API ergonomics (if applicable)
...

### Test Quality
...

### Fixes Applied
- [list of issues auto-fixed, with file:line]

### Remaining Items (needs user decision)
- [list of issues to discuss]
```

After the user approves any remaining items, you can commit.

## Common mistakes

| Mistake | Fix |
|---|---|
| Skipping the fresh-context dispatch and "reviewing yourself" | You wrote the code; your judgment is biased. Dispatch the subagent. |
| Filling the prompt template with placeholders left unfilled | Always substitute `{BASE_SHA}`, `{HEAD_SHA}`, etc. before sending. |
| Auto-fixing Minor items and burying them | Minor items go to the user. Only apply unambiguous Important+ fixes silently. |
| Hardcoding `main` as the base | Some repos publish from `dev` or `master`. Compute `merge-base` against the real default branch. |
| Reviewing while implementation is still in flux | Wait until tests pass locally. The reviewer will flag scaffolding you intend to remove. |
