---
name: repo-hygiene-audit
description: Use when auditing a software repository for beginner-level best-practice violations, repo health, Git history hygiene, issue and PR usage, branch discipline, tests, docs, coding style, CI, security basics, or maintainability signals.
---

# Repo Hygiene Audit

## Overview

Audit a repository as a beginner-friendly scorecard. Ground every judgment in visible evidence, and give concrete next steps instead of vague advice.

## Workflow

1. Inspect the repo root and project instructions first.
2. Read core files: README, license, package/build files, test layout, docs, CI, issue templates, PR templates, security policy, contribution docs, and gitignore.
3. Inspect Git history and branches with read-only commands.
4. Run only safe, cheap verification commands if they are obvious from the repo.
5. Produce the scorecard, then list the highest-leverage fixes.

Use these references as needed:

- `references/scorecard-rubric.md`: default checks and severity rules.
- `references/git-history-audit.md`: commit, branch, issue, and PR checks.

## Evidence Commands

Prefer read-only commands:

```bash
pwd
find . -maxdepth 3 -type f | sort | head -200
git status --short
git branch -a -vv
git log --oneline --decorate --all -n 120
git remote -v
find .github -maxdepth 3 -type f | sort
```

If GitHub CLI is configured, optionally enrich the local evidence:

```bash
gh pr list --state all --limit 30 --json number,title,state,headRefName,baseRefName,mergedAt,closedAt,author
gh issue list --state all --limit 30 --json number,title,state,labels,createdAt,closedAt,author
```

Do not rewrite history, delete branches, push, create issues, or edit files unless the user explicitly asks for remediation.

## Output Format

Start with a compact summary:

```markdown
Overall: Warn
Best signals: ...
Highest-risk gaps: ...
Recommended first fixes: ...
```

Then provide a scorecard:

| Area | Status | Evidence | Why it matters | Next step |
|---|---|---|---|---|
| README | Pass | `README.md` has setup and examples | New users can start | Keep current |

Use statuses exactly:

- `Pass`: visible evidence meets beginner expectations.
- `Warn`: usable, but confusing, incomplete, stale, or inconsistent.
- `Fail`: missing or likely to block contributors.
- `Not visible`: cannot be assessed from local evidence.

End with a short prioritized fix list. Keep it practical and ordered by value.

## Scoring Guidance

Do not over-penalize small or early repos. A beginner repo can still pass if it has clear setup, tests, and review flow.

Use `Fail` for gaps that block basic collaboration:

- No README or setup path.
- No obvious way to run tests.
- No license for a public/open-source repo.
- Git history has no issue/PR traceability.
- Secrets or generated heavy artifacts are committed.
- CI exists but cannot protect the main workflow.

Use `Warn` for teachable inconsistencies:

- Vague commits such as `update`.
- Stale local branches.
- Mixed branch naming.
- Missing issue or PR templates.
- Sparse docs or examples.
- Style commands exist but are not documented.
