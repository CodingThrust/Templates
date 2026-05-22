---
name: slide-writing
description: Use when building a scroll-snapped, two-column slide deck in a neutral-academic house style — research-style and formal — for research talks, project briefings, group-meeting decks, anywhere a one-figure-plus-commentary rhythm beats bulleted Keynote slides. Forces a two-phase workflow — agree on the logic flow first, then design each page — so the deck has a thesis before it has visuals. The output is a single self-contained HTML file (CSS, JS, fonts via CDN) with arrow-key navigation, page indicators, and a section component library (masthead, spec list, stats grid, data table, conclusion 2x2, voice-quote wall, tool stack, key-links). The visual identity is fixed; the contents are yours.
---

# Slide Writing — Neutral Academic House Style

## Overview

Build a neutral-academic slide deck — **research-style, formal**. Each page is one scroll-snapped `<section class="spread">` with a 2-column grid — **figure left, commentary right**. Global chrome is a quiet hairline scroll-progress bar, a small mono section tag, an `nn / nn` page indicator, and arrow-key navigation — all set on a warm-paper background. The visual identity (near-black ink `#1a1a1a`, terracotta accent `#a55b3a` used sparingly, Source Serif 4 + JetBrains Mono, warm paper `#f8f7f4`, no decorative noise) is fixed. The component library — masthead, numbered spec list, stats grid, data table, rail-pull, rail-callout, conclusion grid, voice-quote wall, tool stack, key-links — is also fixed. **What's variable is what you put inside it.**

The bundled template uses an editorial two-column pattern, in a restrained ink-on-paper palette typeset in Source Serif 4.

## When to use

- A research talk, design brief, or internal report that needs to read as deliberate — not as default-Keynote bullets.
- Any deck where one figure + one commentary paragraph per page is a better unit than a bulleted slide.
- An artifact that should match the visual style of [[report-writing]] outputs without being a documentation site.

## When NOT to use

- Quick stand-up updates, status PDFs, or anything that wants to be a one-page handout. Use markdown.
- External investor decks, marketing pages — those need a separate design pass with a real designer in the loop.
- In-document figures or paper styling — use Typst.
- A site of many documents — use [[report-writing]].
- A long-form report you only want as a styled HTML page — use [[topic-report]] then [[report-writing]].

## The two-phase workflow — **do not skip phase 1**

```
┌──────────────────────────┐    ┌──────────────────────────┐    ┌──────────────────────────┐
│ Phase 1                  │    │ Phase 2                  │    │ Phase 3                  │
│ Logic flow               │ →  │ Page design              │ →  │ Assemble & verify        │
│                          │    │                          │    │                          │
│ topic · audience ·       │    │ per section:             │    │ scaffold template ·      │
│ key claims → ordered     │    │ pick pattern · write     │    │ paste content in ·       │
│ section list + figure    │    │ figure spec + commentary │    │ open in browser ·        │
│ ideas, signed off.       │    │ confirm before next.     │    │ walk arrow keys.         │
└──────────────────────────┘    └──────────────────────────┘    └──────────────────────────┘
```

Skipping phase 1 produces decks that look polished but argue nothing. Treat the sign-off as a gate.

---

### Phase 1 — Logic flow (talk before draw)

1. **Capture intake** in three lines. Ask the user (or read from the brief / `slides.md`):
   - **Topic.** One sentence. The narrower, the better.
   - **Audience.** Who is in the room? What do they already know?
   - **Key claim.** One sentence the audience should be able to repeat afterwards.

2. **Propose a section outline.** 5–8 sections is the sweet spot; 12 is the ceiling. For each section write **three things** on one line:

   ```
   §N · <section name> — <main claim, 1 sentence> — <figure idea, ≤ 8 words>
   ```

   Example:
   ```
   §1 · Problem — the pipeline breaks in three places — diagram with three red boxes
   §2 · Model — two coupled cycles, one gate — wide timeline figure
   §3 · Evidence — time inputs collapse — before/after table with accent total
   §4 · Feasibility — mostly correct, honestly imperfect — vertical stack of three big numbers
   §5 · Conclusion — copy the pattern, replace the topic — 2x2 audience grid + voice-quote wall
   ```

3. **Show the outline. Wait for sign-off.** If the user redirects, redraft the outline before touching HTML. The outline is the deck's thesis — if it's wrong, every page is wrong.

4. **Once approved, write the outline into a `notes.md` (or `outline.md`) next to the deck file**, so phase 2 has a single source of truth. The outline doubles as the chapter map for the talk.

---

### Phase 2 — Page design (one section at a time)

For each section in the approved outline, do these steps in order:

1. **Pick a pattern** from `references/layout-patterns.md`. The decision is which job the slide is doing:

   If the pattern is not obvious, use the lightweight router instead of reading the whole catalog:
   ```bash
   python3 /path/to/skills/slide-writing/scripts/pattern_tool.py search --query "<slide job>" --limit 3
   python3 /path/to/skills/slide-writing/scripts/pattern_tool.py summarize --pattern <pattern-id>
   ```

   Use `extract --pattern <pattern-id>` only when you need the copyable HTML snippet.

   | Slide does this | Pattern |
   |---|---|
   | Names 3–4 parallel things (failures, principles, constraints) | `ol.spec` numbered list |
   | Headlines 3–4 numbers | `.stats` grid (`.cols-2` or `.cols-3`) |
   | Compares before/after across many rows | `table.data` with grouped rows |
   | Carries one punch line | `.rail-pull` |
   | Sidebar checklist or single big number | `.rail-callout` |
   | Stacks three big numerals each with a sentence | `.feasibility-stack` (inside the figbox) |
   | Closes with audience-shaped takeaways | `.conclusion-grid` (always 4 cards, one `.dark` with the CTA) |
   | Surfaces verbatim quotes | `.voice-group` (categories: accept / cost / trap / ask) |
   | Lists the tools we used | `.tool-stack` |
   | End-of-deck links | `.ribbon` + `.key-links` |

   Combine patterns when natural — e.g., a section may carry a numbered `ol.spec` *and* a `.rail-pull` at the bottom. Don't stack more than two patterns per `.spread-text` column — past that the eye loses the anchor.

2. **Write the title, then design the figure column.** The title (`.run-title`) is a **direct child of `<section class="spread">`** and spans the full grid row above the two columns. Below it, the wide left column carries the **figure**. **Use the source's own figures — do not synthesize.** If the deck introduces a paper, project, or repo, the figures already exist there: in `paper/figs/`, in a README, in `docs/assets/`, in slides from a prior talk. Find them first; only then think about generating anything new. The author drew the figure once; redrawing it as inline SVG produces a worse copy that the audience will compare unfavourably to the original.

   - **Title** (`.run-title`, sibling of `.spread-fig` and `.spread-text`): the claim as a sentence with **one** italic word in `<em>`. End with a period. The `<em>` inherits the title color; do not use a second title color. The title spans the full row (`grid-column: 1 / -1`), so it can read full-width without wrapping into a narrow column.
   - **Figure**, in order of preference:
     - **Source image, copied in.** Pull the SVG/PNG/GIF from the source repo into `figures/` next to the deck and reference it as `<img src="figures/whatever.svg" />` inside a `.figbox`. SVGs scale; PNGs work; PDFs need converting (`pdf2svg foo.pdf foo.svg` or `pdftocairo -png -r 180 -singlefile foo.pdf foo`). Source GIFs (e.g. README animations) load directly from their raw URL.
     - **Tabular figure.** A `table.data`, a `.feasibility-stack`, or a `.conclusion-grid` — these are *the figure*; no SVG needed.
     - **Inline SVG diagram — last resort.** Only when no source figure exists and the slide genuinely needs one (e.g. a slide you wrote from scratch about a concept the source paper doesn't illustrate). The template's masthead-area is intentionally empty so a custom mark or diagram can sit there if needed.

   Wrap whatever you choose in a `.figbox` with `.figbox-head` (Fig N · title + short context) and `.figbox-cap` (the one-sentence "how to read this").

   **Do not add a `.run-eyebrow`.** The section number + topic is already in the always-visible `data-tag` top chrome; putting it inside the slide too is duplicate furniture.

3. **Write the commentary-right column.** The right rail starts at the figbox top edge — no title repeats here.
   - **Lead** (`.run-lead`): one sentence — the headline restated with the operative number or fact. ≤ 30 words.
   - **Body** (`.run-body`): zero to two short paragraphs of nuance. Don't recap the figure.
   - **Pattern block** (spec list / stats / rail-pull / etc.) — the chosen pattern lives here.

4. **Confirm before moving on.** Show the user the section in markdown form (title + lead + the pattern's content), or open the HTML and screenshot. Only after sign-off, move to the next section.

5. **House rules during page design:**
   - One italic word per title. Pick the operative word. Do not add color styling inside titles.
   - Body copy is `--text-soft`, not ink. Reserve ink for headings, rules, emphasis.
   - Three items in a spec list. Five if you must. Six → switch to a table.
   - Three quotes in a `voice-group cols-3` row, two in `cols-2`. Never mix.
   - Captions describe how to *read* the figure ("the dashed box is …"); they don't restate it.
   - Numbers and units sit in JetBrains Mono via `td.num` or `.k sup`; never in plain serif.

---

### Phase 3 — Assemble and verify

1. **Scaffold the deck file** into the target directory:
   ```bash
   python3 /path/to/skills/slide-writing/scripts/scaffold.py [--name presentation] [target_dir]
   ```
   This writes `presentation.html` (or `<name>.html`) into the target directory. Idempotent — passes `skip` over existing files; `--force` to overwrite.

2. **Replace the template's masthead and five example sections** with your real ones. Keep the chrome (the `<div class="scroll-progress">`, `.brand-chip`, `.top-tag`, `.nav-hint`, `.page-indicator`) and the bottom `<script>` exactly as-is. They are what makes it a *deck*, not a long article.

3. **Update `data-tag` on every `<section class="spread">`** — that string is what the top-tag chrome shows when the section is on screen. Pattern: `"§N · short label"`.

4. **Verify in a browser:**
   ```bash
   python3 /path/to/skills/slide-writing/scripts/deck_lint.py --input presentation.html
   python3 -m http.server   # in the directory containing presentation.html
   ```
   Fix any `deck_lint.py` errors before opening the deck. Warnings are not automatic blockers, but read them; they usually mean leftover template content or inline styling that should be cleaned up.

   Then in the browser:
   - Walk through with `→`, `←`, space, `PgUp`, `PgDn`, `Home`, `End`. Every page should snap; no peek of the next page at the bottom.
   - Watch the top-tag — it should update on each page change.
   - Confirm the page indicator shows `nn / nn` correctly.
   - At narrow viewport (`<= 980 px`), the two columns should collapse to one and the bottom chrome should hide.
   - Re-read titles: each one should carry exactly one italic word.

---

## What's in the bundle

| File | Purpose |
|---|---|
| `references/template.html` | The full deck template — chrome + masthead + 5 example `.spread` sections covering every pattern. Self-contained: CSS, JS, fonts via CDN. |
| `references/layout-patterns.md` | Section-by-section catalog: every pattern, its HTML snippet, when to use it, and the house rules. |
| `references/style-tokens.md` | The deck palette (ink + terracotta on warm paper), type scale, layout widths, and motion tokens. |
| `scripts/scaffold.py` | Idempotent scaffold — copies `template.html` (as `<name>.html`) to a target directory. |
| `scripts/pattern_tool.py` | Search / summarize / extract helper for `layout-patterns.md`, so agents can pick snippets without loading the full catalog. |
| `scripts/deck_lint.py` | Local preflight for deck structure, chrome, section tags, title accent counts, missing assets, and obvious template leftovers. |

## Editing an existing deck

Treat each `<section class="spread" id="...">` as the editable unit. For a local content change, replace only that section by `id` and preserve the fixed chrome (`.scroll-progress`, `.brand-chip`, `.top-tag`, `.nav-hint`, `.page-indicator`) and bottom `<script>`. For a small addition inside one slide, edit only the relevant `.spread-fig` or `.spread-text` block.

After editing, always run:

```bash
python3 /path/to/skills/slide-writing/scripts/deck_lint.py --input presentation.html
```

Only rebuild the whole deck when the approved outline or page count changes. If the deck structure changes, update every `data-tag` and re-check the page indicator in the browser.

## House rules

- **The chrome is non-negotiable.** Scroll progress bar, brand chip, top tag, page indicator, nav hint — keep them all. Audiences anchor on them.
- **Two columns, asymmetric.** `2fr / 1fr` is the ratio. Don't widen the commentary; if it overflows, the title or lead is too long.
- **One figure per slide.** A second figure means you've conflated two slides.
- **One italic word per title, one title color.** The emphasis is typographic, not a second color.
- **One accent — terracotta.** Don't introduce a second accent color mid-deck.
- **Body in `--text-soft`, ink reserved for headings.** Reading body copy in `--ink` is too heavy.
- **Numbers in JetBrains Mono.** Always. `td.num`, `.k sup`, page indicators, eyebrows. Never let a numeric break sit in the serif.
- **Don't add new patterns mid-deck.** If a slide can't be expressed with the catalog, edit the template and `layout-patterns.md` *first*, then use the new pattern.

## Common mistakes

| Mistake | Fix |
|---|---|
| Synthesized an inline SVG for a slide that introduces a paper / repo / project | Stop. Find the source figure (in `figs/`, `docs/assets/`, the README, prior slides) and embed that instead. Hand-drawn SVG copies of a real figure read worse than the real figure and undermine the deck's credibility. Only use inline SVG when no source figure exists. |
| Started drafting pages before getting outline sign-off | Stop. Go back to phase 1. The outline is the deck's thesis. |
| Title with two or more `<em>` words | Pick the operative word. The others go in run-lead, not the title. |
| Title with a colored `<em>` word | Remove the color. Title emphasis inherits the title color and changes only style/weight. |
| Bullet list in `.spread-text` | Use `ol.spec` (numbered). Plain bullets read as ad-hoc notes; numbered items read as a deliberate count. |
| Three figures stacked vertically in one `.figbox` | That's three slides. Split. |
| `data-tag` left as the template's default | The top-tag will lie about where the audience is. Always update. |
| Removed the `<script>` block to "simplify" | Now arrow-keys don't work. The script is what makes it a deck. |
| Substituted a sans-serif for Source Serif 4 on titles | The deck deliberately uses Source Serif 4 for both display and body, with italic emphasis carrying the highlight. Don't undo it. |
| Body copy set in `--ink` | Too heavy. Use `--text` or `--text-soft`. Ink is for headings, rules, accent. |
| Pasted a non-`.spread` block between two `.spread` sections | Breaks the page-indicator math. Every page is a `.masthead` or a `section.spread` — no other shapes at the top level. |
| Used `oklch()`, custom font sizes, or one-off hex colors inline | Don't ad-hoc style. Reuse tokens or add a class to the template. |
| Arrow keys, page indicator, or top-tag stopped working | Restore the fixed chrome and bottom script, then run `scripts/deck_lint.py --input presentation.html`. |
| Image renders broken | Keep image paths relative to the deck file and verify `deck_lint.py` does not report `missing_asset`. |
