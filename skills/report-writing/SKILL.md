---
name: report-writing
description: Use when setting up or writing a research documentation/report site — scaffolds a fresh site (Makefile, build script, GitHub Pages workflow, HTML templates) or refreshes templates in an existing setup. Output is a single-page index with download cards, rendered markdown prose, and PDF viewers, all sharing the same neutral-academic stylesheet (ink + terracotta on warm paper). The build pipeline is a single Python script driven by a doc registry; the visual identity is fixed; the contents are yours.
---

# Report Writing — Neutral Academic House Style

## Overview

Stand up a documentation site for any research repo using a shared neutral-academic stylesheet, HTML templates, Makefile, and build script. The visual identity — near-black ink, terracotta accent, warm-paper background, Source Serif 4 throughout, JetBrains Mono for eyebrows / code — is fixed. The pipeline is a single Python script (`tools/build_site.py`) driven by a doc registry. The contents you put inside that style are flexible.

## Two operational modes

| Situation | Use | Result |
|---|---|---|
| Target repo has no site setup yet | `scripts/scaffold.py` | Writes `Makefile`, `tools/build_site.py`, `.github/templates/*`, `.github/workflows/deploy-pages.yml`. Idempotent — re-runs skip existing files; if `Makefile` exists, the site Makefile is written as `Makefile.site`. |
| Target repo already has the site, templates drifted | `scripts/refresh_templates.py` | Overwrites the four files under `.github/templates/`. The build script and Makefile are untouched. |

Both scripts default to the current working directory. Pass a path to scaffold elsewhere. Pass `--force` to scaffold over existing files.

## When to use this skill

- Standing up a docs site for a research repo (project notes, schemas, design docs, deliverables, lab manuals).
- Wrapping markdown notes as a browsable site.
- Embedding a paper / report PDF behind a styled viewer page so collaborators can read it without downloading.
- Anywhere you would otherwise hand-roll a one-off HTML page for project documentation.

## When NOT to use

- Conference posters / marketing pages — those need a separate design pass.
- In-document figures, slide decks, or paper styling — use Typst or LaTeX.
- Reports with no HTML surface (pure PDFs, plain markdown notes).
- A single-deck talk — use [[slide-writing]] instead.

## Workflow

### 1. Scaffold or refresh

From the target repo root:

```bash
# Fresh setup (or top-up — idempotent).
python3 /path/to/skills/report-writing/scripts/scaffold.py

# Already set up; just refresh templates after the bundle changes.
python3 /path/to/skills/report-writing/scripts/refresh_templates.py
```

The scaffold writes:

```
Makefile                              # or Makefile.site if Makefile already exists
tools/build_site.py                   # the build script
.github/templates/index.html          # landing template
.github/templates/markdown.html       # prose viewer template
.github/templates/viewer.html         # PDF viewer template
.github/templates/styles.css          # ink + terracotta stylesheet
.github/workflows/deploy-pages.yml    # CI to publish on push
```

### 2. Customize the build config

Open `tools/build_site.py` and edit the `─── CONFIG ───` block:

- `SITE_TITLE`, `SITE_DESCRIPTION` — page `<title>` and meta description.
- `SITE_SLUG`, `SITE_KIND` — the mono-uppercase wordmark + the sub-label after it (e.g., `SITE_SLUG="QFT-2026"`, `SITE_KIND="lecture notes"`).
- `SOURCE_URL` — the link behind the "Source" nav item and the prose page footer.
- `HERO_EYEBROW`, `HERO_TITLE`, `HERO_SUBTITLE` — the three lines of the index hero. `HERO_TITLE` may include `<em>...</em>` for italic emphasis.
- `SITE_COPYRIGHT` — left-side footer text.
- `GITHUB_BASE` — public URL prefix for "View source" links on rendered markdown pages.
- `DEFAULT_GROUP`, `GROUP_TABS` — the tab row across the hero. A "group" is whatever you want to slice docs by — version, audience, year, project phase. Use a single tab if you don't need a group axis.
- `SECTION_META` — the section order / titles / one-line descriptions within a group.
- `DOC_REGISTRY` — one entry per document. Three kinds:
  - `typst` → compiles `.typ` to PDF, wraps in `viewer.html`.
  - `markdown` → renders `.md` to HTML, wraps in `markdown.html`.
  - `download` → copies the file into `_site/<slug>` for direct download.

### 3. Adjust the CI publish branch

`.github/workflows/deploy-pages.yml` triggers on `branches: ["main"]`. Switch to `dev`, `master`, or your publishing branch as needed. Enable GitHub Pages → Source: GitHub Actions in the repo settings.

### 4. Build and verify

```bash
make install-deps   # one-time: pip install markdown pymdown-extensions
make build          # writes _site/
make serve          # builds + serves on http://localhost:8000
```

Open the served site in a browser and confirm:

- The wordmark in the header reads cleanly in mono-uppercase, no logo image.
- The header is sticky with backdrop blur on scroll.
- Each `.doc-card` hovers correctly (border tints terracotta, arrow slides in).
- Prose pages show ink/terracotta h1/h2 borders, code blocks, and tables.
- PDF viewer pages fill the viewport and the download button resolves.

## Make targets

| Target | What it does |
|---|---|
| `make build` | Build the site into `_site/` |
| `make serve` | Build, then serve at `http://localhost:8000` |
| `make serve-only` | Serve without rebuilding |
| `make watch` | Rebuild on file changes (requires `entr`) |
| `make clean` | Remove `_site/` |
| `make install-deps` | Install `markdown` + `pymdown-extensions` |
| `make help` | Print the target list |

## Bundled assets

All under `references/`:

| Path | Purpose |
|---|---|
| `templates/index.html` | Hero + group tabs + section-grouped doc-card grid |
| `templates/markdown.html` | Long-form prose page rendered from markdown |
| `templates/viewer.html` | Full-viewport PDF viewer with site header |
| `templates/styles.css` | The neutral-academic stylesheet (ink + terracotta) |
| `site/Makefile` | Build/serve/clean/watch targets |
| `site/build_site.py` | Single-script site builder with a CONFIG block |
| `site/deploy-pages.yml` | GitHub Pages CI workflow |
| `style-tokens.md` | Distilled color, type, spacing, motion tokens |
| `layout-patterns.md` | Component-level patterns (hero, sections, doc-card, prose, viewer, footer) plus the `DATA` shape for `index.html` |

## House rules

- **Use the source's own figures — do not synthesize.** When a markdown page introduces a paper, project, or repo, the figures already exist there: in `paper/figs/`, in a README, in `docs/assets/`, in prior slides. Find them first; only then think about generating anything new. Copy them into `docs/figs/` (the build script copies `docs/figs/ → _site/figs/` automatically) and reference with `![alt](figs/name.png)`. Convert PDFs if needed (`pdf2svg foo.pdf foo.svg`, or `pdftocairo -png -r 180 -singlefile foo.pdf foo`). Synthesised diagrams as a substitute for real figures read as a worse copy — only fall back to synthesising one when the concept you need to illustrate genuinely doesn't appear in any source.
- Reuse existing tokens and classes. Add a new token to `styles.css` only if a new accent is genuinely needed — and add it as a `--name` custom property, not a hardcoded hex.
- Page widths are fixed: 820px for index, 760px for prose, full viewport for the viewer. Don't widen for tables — let them scroll.
- The wordmark is text, not an image. Keep `SITE_SLUG` short (≤12 characters) so it stays on one line at narrow widths.
- The footer has two cells: `SITE_COPYRIGHT` on the left, build/deploy attribution on the right. Keep the two-cell structure.
- External links carry `target="_blank" rel="noopener"`. The `.external` class auto-renders an `↗` glyph.

## Common mistakes

| Mistake | Fix |
|---|---|
| Synthesised an SVG / diagram for a page that introduces a paper or repo | Stop. Find the source figure (in `figs/`, `docs/assets/`, the README) and embed that. Copy it into `docs/figs/`, reference as `![alt](figs/name.png)`. Convert PDFs with `pdf2svg` or `pdftocairo` if necessary. Hand-drawn copies of real figures undermine the report's credibility. |
| Editing `_site/` directly instead of the source files | `_site/` is generated; re-run `make build`. |
| Hand-rolling card markup that drifts from `.doc-card` | Reuse `.doc-card`. Match the icon convention (download vs. right arrow). |
| Forgetting `make install-deps` on a fresh checkout | The build will `ImportError` on `markdown`. Run `make install-deps`. |
| Adding a typst doc without `typst` installed | `make build` aborts. Install Typst or change the `kind` to `markdown`. |
| Embedding PDFs inline in a prose page | Use `viewer.html` for PDFs; link to it from the index. |
| Leaving `GITHUB_BASE` as the placeholder | Rendered prose pages get broken "View source" links. |
| Pushing without enabling Pages → GitHub Actions | The workflow runs but no site appears. |
