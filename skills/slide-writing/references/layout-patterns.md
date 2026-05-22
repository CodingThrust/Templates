# Layout Patterns — Neutral Academic Deck

How to compose a deck section using the bundled `template.html`. Pick the pattern that fits the slide's job; copy the HTML snippet; fill in content. Patterns share the global chrome (scroll-progress bar, top-tag, page-indicator, arrow-key nav) and the two-column `.spread` skeleton.

## The page skeleton

Every non-masthead slide is a `<section class="spread">` with `id` + `data-tag`. The **title spans the full row** above the two columns; below it, the **figure** sits in the wide left column (`.spread-fig`) and the **commentary** in the right (`.spread-text`). The `data-tag` is what the top-of-page chrome shows when this slide is in view — there is no in-page `run-eyebrow`, the chrome carries the section label.

```html
<section class="spread" id="some-id" data-tag="§N · short label">
  <h2 class="run-title">The <em>claim</em> in one sentence.</h2>
  <div class="spread-fig">
    <div class="figbox">
      <div class="figbox-head"><strong>Fig. N · Title</strong><span>short context</span></div>
      <!-- figure (SVG, IMG, table, stack of stats, conclusion grid) -->
      <p class="figbox-cap">A short caption — refer to the figure, don't restate it.</p>
    </div>
  </div>
  <div class="spread-text">
    <p class="run-lead">One-sentence lead.</p>
    <!-- the right-column pattern (spec list, stats, rail-pull, table, …) -->
  </div>
</section>
```

The italic `<em>` inside `.run-title` carries the typographic accent — use it once per title for the operative word. It inherits the title color. The title is a direct child of `<section class="spread">`, not nested inside `.spread-fig` or `.spread-text` — the grid rule `grid-column: 1 / -1` lets it span the full row above the figure + rail.

**Why title-spans-the-row.** The title is the slide's claim; making it span the whole row gives it visual primacy and removes the awkward column-cap from when it lived inside one of the two columns. The figure below reads as the evidence; the right rail flows from a lead into specs / stats / pull. The earlier in-rail title duplicated the `data-tag` chrome and made the figure feel like the headline. The eyebrow is gone; the top-of-page chrome (always visible) carries the section number + topic.

---

## Pattern: masthead (cover)

The cover is deliberately quiet — a brand mark on the left, a title + sub + one byline on the right. No figure box, no authors block, no contribution paragraph. Save the elevator pitch for §1 and the links for §5; the masthead announces, it doesn't summarize.

```html
<header class="masthead" id="masthead">
  <div class="mast-meta">
    <span><span class="dot"></span>Context line — venue · org · series</span>
    <span>Date or sub-context</span>
  </div>
  <div class="spread">
    <div class="spread-fig">
      <div class="mast-mark">
        <!-- Optional: drop a project mark / hero figure here, or leave blank. -->
      </div>
    </div>
    <div class="spread-text">
      <div class="mast-eyebrow">A research design brief</div>
      <h1 class="mast-title">Deck Title,<br/>with one <em>italic</em> word.</h1>
      <p class="mast-sub">A short italic sub-title.</p>
      <div class="mast-byline"><strong>Author Name</strong> · Affiliation · 2026</div>
    </div>
  </div>
</header>
```

- One masthead per deck. Don't repeat the masthead pattern downstream — use `.spread` instead.
- The `.mast-mark` area is intentionally empty in the template — drop a project mark / hero figure there if you have one, or leave the column blank for a typographic-only cover.
- If a recap diagram is genuinely needed up front, put it on slide §1 — not the cover.
- One italic word in the title. Do not color it differently. The byline is one mono line; the names go in `<strong>`.

---

## Pattern: numbered spec list (`ol.spec`)

When the slide names three or four parallel items — failure modes, design constraints, principles. The `01 / 02 / 03` counter is auto-generated.

```html
<ol class="spec">
  <li>
    <strong>The item.</strong>
    One-sentence explanation.
    <div class="tag">→ keyword</div>
  </li>
  <!-- … -->
</ol>
```

- Three items is the sweet spot. Five maximum.
- `strong` at the front is the noun phrase; the sentence following adds nuance.
- `.tag` is optional — use it to label which problem this maps back to.

---

## Pattern: stats grid (`.stats`)

For four headline numbers. Use `.cols-3` for three, `.cols-1` for one. The numeral is set in Source Serif 4 at `clamp(28px, 2.8vw, 40px)`; wrap the punch number in `<em>` to color it `--accent-deep`.

```html
<div class="stats">
  <div class="stat"><div class="k">13<sup>wk</sup></div><div class="lbl">Course length</div></div>
  <div class="stat"><div class="k"><em>56%</em></div><div class="lbl">Use AI <em>daily</em></div></div>
  <!-- … -->
</div>
```

- `<sup>` carries unit / suffix (`wk`, `min`, `%`).
- `<em>` inside `.lbl` is the secondary emphasis word, set in `--ink` (not italic — see CSS reset).
- Don't write decimals if integers will do.

---

## Pattern: data table (`table.data`)

For tabular comparisons with totals. Headers and `tr.group` rows are mono uppercase; numeric cells (`.num`) use JetBrains Mono with tabular numerals; the `tfoot` carries the bottom rule and bold totals.

```html
<table class="data">
  <thead><tr><th>Header</th><th>Before</th><th>After</th></tr></thead>
  <tbody>
    <tr class="group"><td colspan="3">Section label</td></tr>
    <tr><td>Row</td><td class="num">3 h</td><td class="num">0 h</td></tr>
  </tbody>
  <tfoot>
    <tr><td>Total</td><td class="num">4 h</td><td class="num" style="color:var(--accent-deep);">50 min</td></tr>
  </tfoot>
</table>
```

- Color the punch cell with `--accent-deep` inline. One per table; otherwise the eye loses the anchor.
- Multiple `<tbody>` blocks alternate with `tr.group` headings if the table has natural groups.

---

## Pattern: rail-pull quote

A one-line slogan or punch line, set in italic Source Serif 4 with a 3-px left border.

```html
<div class="rail-pull">The model is not the artifact. It is the coupling.</div>
<div class="rail-pull deep">Variant: navy border.</div>
<div class="rail-pull ink">Variant: deeper purple border.</div>
```

- One per slide. Two competes with the title.
- Keep it under 20 words. If it's longer, it's not a pull-quote — write it as run-body.

---

## Pattern: rail-callout box

A boxed callout with a label, optional big number, and sub copy. Use for sidebar instructions or single-number panels.

```html
<div class="rail-callout">
  <div class="lbl">After class</div>
  <div class="sub">
    ▢ Step 1<br/>
    ▢ Step 2<br/>
    ▢ Step 3
  </div>
</div>
```

With a big number:

```html
<div class="rail-callout">
  <div class="lbl">Headline</div>
  <div class="big"><em>96.3%</em></div>
  <div class="sub">supporting line.</div>
</div>
```

---

## Pattern: feasibility stack (vertical stat list inside a figbox)

When the slide's figure column carries three big numbers each with a sentence of context. Set the big numeral in `<em>` for accent color; use `<span class="denom">` for the grey denominator.

```html
<div class="figbox">
  <div class="figbox-head"><strong>Fig. N · Feasibility</strong><span>three measurements</span></div>
  <div class="feasibility-stack">
    <div class="fstat">
      <div class="lbl">Quality A</div>
      <div class="k"><em>12</em><span class="denom"> / 18</span></div>
      <p>One sentence of context.</p>
    </div>
    <!-- … -->
  </div>
</div>
```

- Always inside a `.figbox`. The container does the framing.
- Three or four rows. Beyond that, switch to `table.data`.

---

## Pattern: 2x2 conclusion grid (`.conclusion-grid`)

For the closing slide: four cards naming what each audience takes away. The fourth card is dark and carries the call to action.

```html
<div class="conclusion-grid">
  <div class="ccard">
    <div class="label">For the audience</div>
    <h4>A clear path, a fair check.</h4>
    <p>One sentence.</p>
  </div>
  <!-- repeat three more -->
  <div class="ccard dark">
    <div class="label">Try it</div>
    <h4><a href="#" style="color:inherit; text-decoration:none;">project URL</a></h4>
    <p>One CTA.</p>
  </div>
</div>
```

- Always exactly four cards.
- One card is `.dark` and carries the CTA. Don't put the CTA in a light card.
- `<em>` inside the heading carries the brand accent.

---

## Pattern: voice quote wall (`.voice-group`)

For survey / user-research / reviewer-quote slides. Each group has a swatch, a category label, and a count. The quote cards have a left border in the category color and a tag chip on top.

Categories:

| Class | Border color | Semantic role |
|---|---|---|
| `.qcard.accept` | `--accent` | Worked / positive |
| `.qcard.cost` | `--warning` | Honest cost / pain |
| `.qcard.trap` | `--accent-deep` | Named failure mode |
| `.qcard.ask` | `--ink` | Direct request |

```html
<div class="voice-head"><strong>Voices from the field</strong><span>positive · honest · asks</span></div>

<div class="voice-group cols-3">
  <div class="gh">
    <span class="swatch" style="background: var(--accent);"></span>
    <span>What worked</span>
    <span class="count">3 / 18</span>
  </div>
  <div class="quotes">
    <blockquote class="qcard accept">
      <span class="qtag">rhythm</span>
      "A quote, verbatim."
    </blockquote>
    <!-- 2 more quotes -->
  </div>
</div>
```

- `cols-3` for three quotes; `cols-2` for two. Don't mix grids inside one group.
- Always quote verbatim. Add `[…]` if you trim.
- The `.qtag` is a 1–2-word category — not a citation.

---

## Pattern: tool stack (2-col mono list)

For the "what we used" list on a methods slide.

```html
<div class="tool-stack">
  <div class="tool-title">Concrete tool stack</div>
  <div class="tool-grid">
    <div class="tool"><strong>What</strong><a href="#">tool name</a> — one-line role.</div>
    <!-- 5 more -->
  </div>
</div>
```

- Six entries fits in two columns. Eight is the ceiling.
- Each entry's `<strong>` is the *role*, not the name. The link is the name. The sentence is the function.

---

## Pattern: ribbon + key links (closing rail)

The last commentary column usually ends with a ribbon (mono uppercase slug) and a key-links block (uppercase mono with accent underlines).

```html
<span class="ribbon">One headline phrase.</span>
<p class="run-body" style="margin-top: 20px;">Caveats / scope.</p>
<div class="key-links">
  <div><span>Site</span><a href="#">project URL</a></div>
  <div><span>Repo</span><a href="#">code URL</a></div>
  <div><span>Paper</span><a href="#">preprint URL</a></div>
</div>
```

- Three key-links max. The deck closes; don't bury the CTA under a list of ten.

---

## Patterns the deck **does not** include (on purpose)

- **Bullets with circle markers.** Use `ol.spec` (numbered, structural) — bullets without structure read as ad-hoc notes.
- **Multi-column body prose.** The commentary column is one column. Two-column prose belongs in a paper, not a deck.
- **Heroes / banners.** The masthead is the cover; downstream slides anchor on the figure box, not on hero text.
- **Hover effects on content.** Reserve motion for the chrome (scroll bar, nav hint). Slides are *read*, not *browsed*.

If you need something not in this catalog, add a new pattern to this file *and* a CSS class in the template. Don't ad-hoc style inside a slide.
