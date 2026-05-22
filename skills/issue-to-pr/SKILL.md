---
name: issue-to-pr
description: Use when you have a GitHub issue and want to open a PR carrying an implementation plan — guides fetching the issue, brainstorming an approach with the user, writing a plan file, and pushing a plan-only PR ready for implementation (manual or automated).
---

# Issue to PR

Convert a GitHub issue into an actionable PR whose only content is an implementation plan. The implementation itself happens in a follow-up commit (by you, a teammate, or an automated agent triggered by the PR body).

## When to use

- An issue has been triaged and you want to capture an approach before writing code.
- Your repo runs an automated executor that watches PRs for a trigger token in the body.
- You want a reviewable plan that lives in Git history, not just a Slack thread.

## When NOT to use

- Trivial one-line fixes — go straight to a PR.
- Spike / experimental work that doesn't yet warrant an issue.
- Work where the plan is the implementation (e.g., a docs PR) — write the docs.

## Workflow

1. Receive issue number or URL.
2. Fetch the issue with `gh`.
3. Brainstorm with the user (clarify intent, explore approaches, agree on scope).
4. Write a plan file.
5. Create a branch, commit the plan, push, and open a PR.

## Step 1: Parse input

Accept any of these forms:

- `123` → issue #123 in the current repo
- `https://github.com/<owner>/<repo>/issues/123` → issue #123
- `<owner>/<repo>#123` → issue #123 in a specific repo

## Step 2: Fetch the issue

```bash
gh issue view <number> --json title,body,labels,assignees
```

Summarize for the user: title, current state, what the issue is asking for, any open questions.

## Step 3: Brainstorm

**REQUIRED:** invoke a brainstorming skill (`superpowers:brainstorming` if available) before writing the plan. Otherwise have an explicit discussion with the user.

The goal is to:

- Confirm user intent (the issue may be ambiguous).
- Surface multiple approaches and their tradeoffs.
- Lock down the scope of this PR (what is in, what is deferred).

Do not skip brainstorming. Do not write a plan without prior discussion.

## Step 4: Write the plan file

Save to `docs/plans/issue-<number>-<slug>.md` (adjust the path to whatever the repo uses):

```markdown
# <Title from brainstorming>

Issue: #<number>

## Context

<Brief problem statement — what's broken or missing.>

## Approach

<The chosen approach from brainstorming and why it was chosen over the alternatives.>

## Tasks

1. <Specific, ordered implementation task>
2. <Another task>
3. ...

## Acceptance Criteria

- <Observable criterion from the issue or brainstorming>
- <Another>

## Out of scope

- <Anything explicitly deferred>
```

Keep tasks small and ordered. Each task should be a clear unit a reviewer can check off.

## Step 5: Create the branch and PR

```bash
NUMBER=<issue-number>
SLUG=<short-kebab-slug>
TITLE=<title>

git checkout -b "issue-${NUMBER}-${SLUG}"
git add "docs/plans/issue-${NUMBER}-${SLUG}.md"
git commit -m "Add plan for #${NUMBER}: ${TITLE}"
git push -u origin "issue-${NUMBER}-${SLUG}"

gh pr create --title "Fix #${NUMBER}: ${TITLE}" --body "$(cat <<EOF
[action]

## Summary

<1-3 sentence summary from brainstorming.>

Closes #${NUMBER}
EOF
)"
```

**Important:**

- Commit **only** the plan file. No implementation code in this commit.
- If your repo uses an automation trigger (e.g., `[action]`, `/claude implement`), put it as the **first line** of the PR body. Many trigger-watchers only parse the first line.
- The branch name pattern `issue-<n>-<slug>` matches the convention from `CONVENTIONS.md`.

## Trigger token note

Different teams use different automation triggers. Check the repo's `CLAUDE.md` or `.github/workflows/` to confirm what (if anything) parses the PR body. Common patterns: `[action]`, `/agent run`, `claude: implement`. If no automation is configured, you can drop the trigger line — the PR is still useful as a reviewable plan.

## Common mistakes

| Mistake | Fix |
|---|---|
| Skipping brainstorming | Always brainstorm before planning. The issue text is rarely complete. |
| Trigger token not on line 1 | If your automation expects it first, putting it elsewhere silently does nothing. |
| Committing code along with the plan | Plan-only PR. Implementation goes in a follow-up commit. |
| Generic plan | Use specifics from the brainstorming. "Refactor X" is not a plan; "Extract function foo from bar.rs lines 40-90" is. |
| Wrong issue ref in PR body | `Closes #<n>` only auto-closes if the PR's base is the default branch. |
