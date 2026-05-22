# Git History Audit

Assess whether the repo history helps beginners understand how work moves from issue to branch to PR to merge.

## Read-Only Commands

```bash
git status --short
git branch -a -vv
git log --oneline --decorate --all -n 120
git log --all --format='%h%x09%an%x09%ad%x09%s' --date=short -n 300
git for-each-ref --format='%(refname:short)%09%(committerdate:short)%09%(upstream:short)%09%(upstream:track)%09%(subject)' refs/heads refs/remotes | sort
```

Optional, when `gh` is available:

```bash
gh pr list --state all --limit 30 --json number,title,state,headRefName,baseRefName,mergedAt,closedAt,author
gh issue list --state all --limit 30 --json number,title,state,labels,createdAt,closedAt,author
```

## What To Check

| Check | Pass | Warn | Fail |
|---|---|---|---|
| Issue traceability | Recent work references issue IDs or clear task IDs | Some work is traceable, some is not | Most work cannot be tied to a request |
| PR traceability | Merge commits or squash commits reference PR numbers | PR links are partial or inconsistent | No visible review path |
| Branch naming | Branch names describe issue, feature, fix, review, or experiment | Mixed names but mostly understandable | Names are vague or reused heavily |
| Branch freshness | Few stale branches; old branches are clearly archived | Several stale local or remote branches | Many obsolete branches hide active work |
| Deleted upstreams | Local branches tracking gone remotes are rare | Some gone upstreams remain | Many gone upstreams suggest cleanup debt |
| Commit messages | Messages describe behavior or rationale | Some messages are vague, such as `update` | History is mostly vague or noisy |
| Merge discipline | Main branch has reviewed or intentional merge history | Some direct or emergency commits | Main branch is a stream of unreviewed work |
| PR closure quality | Closed PRs appear superseded, rejected, or merged intentionally | Some closed PRs lack context | Many abandoned PRs with no visible reason |

## Beginner Red Flags

- Commits named only `update`, `fix`, `changes`, or `wip`.
- Branches like `test`, `new`, `tmp`, or repeated `fix-pr-*` without context.
- Many local branches behind `origin/main` by dozens or hundreds of commits.
- Branches tracking `[gone]` upstreams for a long time.
- Closed PRs with no replacement, no issue link, and no explanation.
- Issues with no labels, no templates, or no acceptance criteria.

## Recommended Fixes

Prefer non-destructive recommendations:

- Document branch naming in `CONTRIBUTING.md`.
- Add issue and PR templates.
- Clean stale branches after confirming they are merged or obsolete.
- Use squash-merge titles like `Fix #123: short behavior summary (#456)`.
- Require PRs for main branch changes when the repo has multiple contributors.
- Add labels for `bug`, `enhancement`, `docs`, `security`, and project-specific work types.

Do not recommend rewriting shared history unless the user explicitly asks.
