# Layout Patterns

How to compose a report page using the bundled templates and `styles.css`. Match these patterns; the content inside each pattern is yours to write.

## Three page types

| Template | Page role | Key placeholders | Width |
|---|---|---|---|
| `index.html` | Landing or directory page. Hero + section-grouped doc cards. | `{{DATA_JSON}}`, `{{HERO_*}}`, `{{SITE_*}}` | 820px |
| `markdown.html` | Long-form prose rendered from markdown. | `{{TITLE}}`, `{{CONTENT}}`, `{{SOURCE_URL}}`, `{{SITE_*}}` | 760px |
| `viewer.html` | Styled PDF viewer with download. | `{{TITLE}}`, `{{TAG}}`, `{{FILENAME}}`, `{{SITE_*}}` | full viewport |

All three load `styles.css` as a sibling of the HTML file. The header and footer markup is identical across the three so the wordmark appears on every page.

## Pattern: header

Sticky, blurred, identical across all pages. Mono-uppercase wordmark on the left, nav on the right. No image logo — the wordmark is text.

```html
<header>
  <div class="header-content">
    <a class="brand" href="index.html">
      <span class="brand-name">PROJECT<span class="sub">docs</span></span>
    </a>
    <nav class="header-nav">
      <a href="index.html" class="nav-link active">Documents</a>
      <a href="https://github.com/<org>/<repo>" class="nav-link external" target="_blank" rel="noopener">Source</a>
    </nav>
  </div>
</header>
```

- `PROJECT` is the value of `SITE_SLUG` in `build_site.py` — kept short (≤12 characters) so it stays on one line at narrow widths.
- `docs` is the value of `SITE_KIND` — the sub-label appearing after the wordmark.
- External nav links auto-render a `↗` glyph via the `.external` class.

## Pattern: hero (index only)

```html
<section class="hero">
  <div class="hero-eyebrow">Open documentation</div>
  <h1>Title of the project, in <em>one line</em>.</h1>
  <p class="hero-subtitle">Two-sentence framing: what this site covers and who it is for.</p>
  <div class="hero-meta" role="tablist" aria-label="Group">
    <button class="chip tab" role="tab" data-group="main" aria-selected="true">
      <span class="chip-dot"></span>main
    </button>
  </div>
</section>
```

- **Eyebrow** — short JetBrains-Mono uppercase label, prefaced by an 18px ink rule. One or two words.
- **h1** — Source Serif 4, sentence case, ends with a period. Aim for ≤ 12 words. Wrap italic emphasis in `<em>...</em>`.
- **Subtitle** — serif, `max-width: 60ch`. Optional, but keep it under three lines.
- **Chips** — used as a tablist for grouping (version, audience, project phase). Selected state uses `aria-selected="true"`.

If you don't need a group axis, set `GROUP_TABS` to a single entry and the chip row shows just one tab.

## Pattern: section with doc-card grid

```html
<section id="main-docs">
  <div class="section-head">
    <span class="section-title">Documents</span>
  </div>
  <p class="section-desc">Project documentation, in display order.</p>
  <div class="doc-grid">
    <a class="doc-card" href="reports/q1-summary.html">
      <span class="doc-kind">MD</span>
      <span class="doc-body">
        <span class="doc-title">Q1 summary</span>
        <span class="doc-desc">Status, results, and open questions.</span>
      </span>
      <span class="doc-arrow" aria-hidden="true"><!-- arrow svg --></span>
    </a>
  </div>
</section>
```

- **`.doc-kind`** — 2–4 character monospaced tag, uppercase. Examples: `MD`, `PDF`, `JSON`, `TYP`, `ZIP`, `CSV`.
- **`.doc-title`** — exact filename or short title. Source Serif 4, weight 500.
- **`.doc-desc`** — one sentence, serif, no trailing period if it's a fragment.
- **`.doc-arrow`** — use the **download** arrow (pointing down) for `download` cards; use the **right arrow** for navigational cards. See `index.html` for the inline SVGs.

`index.html` builds these cards from a `DATA` object — see "Data shape for index.html" below.

## Pattern: prose page

`markdown.html` renders `{{CONTENT}}` inside `<article class="prose">`. The `.prose` rules in `styles.css` style headings, paragraphs, lists, code blocks, blockquotes, and tables automatically — write standard markdown, let CSS do the rest.

House conventions for prose reports:

- Start with a single h1 — same as the page `{{TITLE}}`. The CSS gives h1 a bottom border.
- Use h2 for top-level sections. h2 also gets a bottom border.
- Use h3 for subsections and h4 for fine-grained labels (h4 is mono-uppercase, like a tag).
- Code blocks: fenced markdown with a language hint (e.g., ` ```bash `) — the renderer ships these into `.prose pre code`.
- Tables: standard markdown tables. Don't widen the page for them; the column will scroll horizontally.
- Blockquotes: short pull quotes or callouts. Avoid stacked blockquotes.
- Images: `.prose img` has `max-width: 100%` and `border-radius: var(--radius-sm)` already.

The `.prose-nav` "All documents" back link appears above the article. Keep it.

## Pattern: viewer page

`viewer.html` wraps a PDF in a full-viewport iframe with the site header.

```html
<div class="viewer-title">
  <span class="viewer-tag">{{TAG}}</span>
  <span class="viewer-title-text">{{TITLE}}</span>
</div>
```

- **`{{TAG}}`** — short uppercase label (3–8 chars), e.g., `DRAFT`, `V0.2`, `REPORT`, `THESIS`.
- **`{{TITLE}}`** — full document title.
- **`{{FILENAME}}`** — stem of the file in `pdfs/<filename>.pdf`. The download button targets the same file.

The viewer locks `html, body { height: 100%; overflow: hidden }` so the PDF iframe fills the screen. Don't try to put additional content below the viewer; spin a separate prose page if you need commentary.

## Pattern: footer

```html
<footer>
  <div class="footer-row">
    <span>© Your Group · <a href="https://github.com/<org>/<repo>" target="_blank" rel="noopener">Source</a></span>
    <span>Built locally · Deployed via <a href="https://pages.github.com" target="_blank" rel="noopener">GitHub Pages</a></span>
  </div>
</footer>
```

Left cell: copyright + repo / source link. Right cell: build / deploy attribution. If the report isn't deployed via Pages, replace the right cell but keep the two-cell structure.

## Data shape for `index.html`

`{{DATA_JSON}}` is replaced at build time with a JSON object:

```json
{
  "default": "main",
  "sectionMeta": [
    {"id": "papers",  "title": "Papers", "desc": "Submitted manuscripts and preprints."},
    {"id": "notes",   "title": "Notes",  "desc": "Lab notebook entries and design notes."},
    {"id": "tools",   "title": "Tooling", "desc": ""}
  ],
  "groups": {
    "main": {
      "papers": [
        {"kind": "PDF", "title": "Heterophilic GNN scaling", "desc": "Submitted to NeurIPS.",
         "href": "papers/gnn-scaling.html", "download": false}
      ],
      "notes": [
        {"kind": "MD", "title": "Project Q1 plan", "desc": "Milestones and risks.",
         "href": "notes/q1-plan.html"}
      ],
      "tools": []
    },
    "archive": { "papers": [], "notes": [], "tools": [] }
  }
}
```

- `sectionMeta` controls section order, titles, and descriptions.
- Each `groups.<id>.<section-id>` is an array of doc descriptors. Empty arrays are hidden automatically.
- `download: true` switches the card to the download-arrow icon and sets the `<a download>` attribute.
- `size` is optional; when present, appended after `kind` in the meta line.
- If a group has no docs across all sections, the page renders the empty state automatically.

## Anti-patterns

- **Don't widen the prose column** to fit a wide table or code block. Use horizontal scroll, or extract the figure to a separate viewer page.
- **Don't introduce a sidebar or table of contents.** This style is intentionally single-column.
- **Don't reuse `.doc-card` for non-document things** (e.g., team members, links to chat). Add a new component if you need a card grid for another purpose.
- **Don't change the wordmark to an image.** It's typeset text on purpose — easier to fork per project.
- **Don't insert custom font-size overrides inline.** All sizes come from `styles.css`.
- **Don't drop the sticky header.** It carries the wordmark on long reports.

## Building the site

The bundled build script `references/site/build_site.py` (installed by `scripts/scaffold.py` into the target repo at `tools/build_site.py`) does exactly five things:

1. Walks `DOC_REGISTRY` in declaration order, grouping by group + section.
2. For each `markdown` doc: renders to HTML and substitutes into `markdown.html`.
3. For each `typst` doc: compiles to PDF (`_site/pdfs/<slug>.pdf`) and emits a `viewer.html` instance.
4. For each `download` doc: copies the file into `_site/<slug>` for direct download.
5. Builds the `DATA` payload and substitutes into `index.html`.

`styles.css` is copied to `_site/` once. Run with `make build` or `python3 tools/build_site.py`.

You don't have to keep the script — any build step (Make, shell, Node) that does substitution and copies will work. The five Make targets (`build`, `serve`, `serve-only`, `clean`, `watch`) are the conventional surface.
