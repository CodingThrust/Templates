# Skills

Reusable agent skills for everyday research workflows — literature synthesis, repo hygiene, code review, and PR maintenance. Each skill is a folder with `SKILL.md` (the body), optional `references/` (loaded on demand), and an `agents/openai.yaml` UI metadata stub.

These skills are organization-neutral so they apply to any research codebase.

## Skill inventory

### Research workflow

| Skill | What it does | When to invoke |
|---|---|---|
| [`topic-report`](topic-report/SKILL.md) | Turn `(topic, sources[])` into a single cited markdown report via a three-pass workflow (extract → synthesize → write). Every claim ends up traceable to a specific source. | You have a list of papers / URLs / PDFs and want a literature-style write-up with citations. |
| [`report-writing`](report-writing/SKILL.md) | Scaffold a research documentation site — landing page, markdown prose pages, PDF viewers — all sharing one neutral-academic stylesheet (ink + terracotta on warm paper). Single Python script + Makefile + GitHub Pages workflow. | You want a single-page site that lists your notes, drafts, and PDFs under one consistent look. |
| [`slide-writing`](slide-writing/SKILL.md) | Compose a scroll-snapped, two-column slide deck (figure left, commentary right) in the same neutral-academic palette. Forces a logic-flow-first workflow, then page-by-page design. | A research talk or project briefing where one-figure-plus-commentary beats bulleted slides. |

### Software practice

| Skill | What it does | When to invoke |
|---|---|---|
| [`repo-hygiene-audit`](repo-hygiene-audit/SKILL.md) | Audit a repository as a beginner-friendly scorecard: README, license, tests, CI, Git history, branch / issue / PR discipline. Read-only. | A new student joined a project, or you want a health check before publishing a repo. |
| [`review-implementation`](review-implementation/SKILL.md) | Dispatch a fresh-context subagent to review the current diff for DRY / KISS / cohesion, public-API ergonomics, and test quality before you commit. | You just finished an implementation; tests pass; you want a second opinion. |
| [`fix-pr`](fix-pr/SKILL.md) | Triage and address review comments, failing CI checks, and coverage gaps on the current branch's PR — in priority order, no unrelated bundling. | Reviewers left comments or CI failed on your PR. |
| [`issue-to-pr`](issue-to-pr/SKILL.md) | Turn a GitHub issue into a plan-only PR: brainstorm the approach, write `docs/plans/issue-<n>-<slug>.md`, open the PR. Implementation goes in a follow-up commit. | An issue is triaged and you want a reviewable plan in Git before writing code. |

The two writing skills (`report-writing`, `slide-writing`) share a single visual identity — ink `#1a1a1a` + terracotta `#a55b3a` on warm paper `#f8f7f4`, Source Serif 4 throughout, JetBrains Mono for eyebrows / code. Change the palette by editing the `:root` block in `styles.css` (report-writing) or `template.html` (slide-writing).

## Installing

These skills follow the standard `SKILL.md` layout — they can be installed into either Claude Code or Codex.

### Option A — Claude Code plugin (recommended)

The repo ships a `.claude-plugin/marketplace.json`, so all skills can be pulled in at once:

```
/plugin marketplace add CodingThrust/Templates
/plugin install research-convensions@research-convensions
```

After install, restart Claude Code; every skill under `skills/` becomes available by name (e.g. `topic-report`, `slide-writing`).

### Option B — Manual symlink (Claude Code, per-project)

Symlink or copy individual skill folders into the project's `.claude/skills/` directory.

```bash
# from inside your project repo
mkdir -p .claude/skills
ln -s ~/Documents/Templates/skills/topic-report     .claude/skills/topic-report
ln -s ~/Documents/Templates/skills/report-writing   .claude/skills/report-writing
ln -s ~/Documents/Templates/skills/slide-writing    .claude/skills/slide-writing
ln -s ~/Documents/Templates/skills/repo-hygiene-audit .claude/skills/repo-hygiene-audit
```

### Option C — Codex (global)

```bash
mkdir -p ~/.agents/skills
ln -s ~/Documents/Templates/skills/topic-report ~/.agents/skills/topic-report
# … repeat for any skill you want available globally
```

Restart Claude Code / Codex after linking so it picks up the new skill.

## Layout convention

```
skills/<name>/
├── SKILL.md              # body — required; starts with YAML frontmatter (name, description)
├── agents/openai.yaml    # UI metadata stub (display name, short description, default prompt)
└── references/           # optional; loaded only when the skill body links to a file inside
    └── <topic>.md
```

Keep `SKILL.md` itself concise. Put rubrics, templates, and worked examples in `references/` so they only enter the agent context when actually needed.
