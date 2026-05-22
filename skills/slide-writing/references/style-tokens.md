# Deck Style Tokens — Neutral Academic

Canonical values copied from `references/template.html` (the `:root` block). Use these tokens verbatim. The deck is **research-style and formal**: warm-paper background, restrained chrome, ink + terracotta used sparingly. Titles use a single color; italic title emphasis inherits `--ink`. The paper surface has no decorative noise and no radial gradients.

## Color palette

Anchored on near-black ink `#1a1a1a`, terracotta accent `#a55b3a` (used sparingly), and a deeper terracotta `#8a4527` for non-title accents (numerals, voice tags).

| Token | Value | Use |
|---|---|---|
| `--paper` | `#ffffff` | Figure-box fill (transparent in the template; reserved for callouts and stat cards) |
| `--paper-2` | `#f1eee6` | Keycap backgrounds, deeper insets (rare) |
| `--paper-bg` | `#f8f7f4` | Page background — flat warm paper, no gradient, no noise |
| `--rule` | `#1a1a1a` | Section dividers (alias for `--ink`) |
| `--ink` | `#1a1a1a` | All primary ink: rules, titles, dark cards |
| `--ink-2` | `#3a3a3a` | Sub-title, lead body |
| `--ink-3` | `#828282` | Captions, meta labels, chrome text |
| `--text` | `#1c1c1c` | Body copy on light surfaces |
| `--text-soft` | `#555555` | Subdued body, table cells, masthead sub |
| `--accent` | `#a55b3a` | Rail-pull bar (default); used sparingly |
| `--accent-soft` | `#ecdbcd` | Soft fills (rare in the deck) |
| `--accent-deep` | `#8a4527` | "deep" rail-pull, accent numerals, quote tags; not title emphasis |
| `--warning` | `#b45309` | "cost" voice-quote category |
| `--success` | `#15803d` | Pass status (rare in the deck) |
| `--hairline` | `#c4bfb3` | Figure-box top/bottom rules, spread border-top, voice-card edges |
| `--hairline-2` | `#d9d6cf` | Secondary borders |

The deck is intentionally flat off-white with hairline dividers, like a printed conference handout — no halo gradients, no noise, no shadows on chrome elements.

## Typography

| Token | Stack | Used for |
|---|---|---|
| `--font-display / serif` | Source Serif 4 (variable: opsz 8–60, ital, weight 300–700), Iowan Old Style, Georgia | Masthead title, run titles, big stat numerals, italic accents, body copy, voice quotes |
| `--font-mono` | JetBrains Mono | Brand-chip wordmark, eyebrows, page indicator, section tags, table headers, ribbon, key links |

Source Serif 4 carries both display and body; italic emphasis (`run-title em`, `mast-title em`, `stat .k em`) does the editorial work. Title emphasis is same-color italic; numbers may still use `--accent-deep`. There is no separate sans-serif heading font.

### Type scale

| Use | Family | Size | Weight | Style |
|---|---|---|---|---|
| Masthead title | Source Serif 4 (opsz 48) | `clamp(36px, 4.2vw, 56px)` | 460 | Same-color italic accent (weight 460, matched) |
| Masthead sub | Source Serif 4 (opsz 28) | `clamp(16px, 1.6vw, 19px)` | 380 normal | Body-style, not italic; max-width 56ch |
| Run title | Source Serif 4 (opsz 48) | `clamp(30px, 3.2vw, 46px)` | 420 | Same-color italic accent |
| Run lead | Source Serif 4 | 18 px | 400 | — |
| Run body | Source Serif 4 | 16 px | 400 | — |
| Stat numerals | Source Serif 4 (opsz 60) | `clamp(28px, 2.8vw, 40px)` | 380 | Italic + `--accent-deep` for the punch number |
| Big stat (feasibility) | Source Serif 4 | 54 px | 380 | — |
| Eyebrow | JetBrains Mono | 11–12 px | 400 | Uppercase, letter-spacing .22–.28em |
| Caption | Source Serif 4 | 13.5 px | 400 | — |
| Page indicator | JetBrains Mono | 11 px | 400 | Uppercase, letter-spacing .22em |

Body line-height is `1.55–1.62`. Title line-height is `0.98–1.05`. Negative letter-spacing (`-0.018em` to `-0.04em`) on titles and stat numerals.

## Shape

- **Border-radius** on cards and stat boxes: `4 px`. Figure boxes are **not boxed** — they sit on the paper bg between two hairline rules. Buttons and chips: `0–4 px`. The deck is print-shaped — no rounded panels, no fills.
- **Hairlines**: `1 px` for spread borders, figure-box top/bottom, voice-card edges, and inner dividers; `1.5 px` at table head/foot.
- **Shadows**: none. The chrome (top-tag, page-indicator, brand-chip, nav-hint) sits flat on the paper with no border or box-shadow — only mono-uppercase typography distinguishes it from body content.

## Layout widths

| Surface | Max width | Padding |
|---|---|---|
| Document container | `1180 px` | `0 32px` |
| Masthead | `1180 px` | `88px 32px 56px` |
| `.spread` two-column | grid: `2fr 1fr`, gap `56 px` | `72px 0 64px` |
| Colophon | `1180 px` | `28px 32px 0` |

At `<= 980 px`, `.spread` collapses to a single column with `gap: 32px`; the brand chip, top tag, page indicator, and nav hint hide.

### Title placement (full-row, above the two columns)

The slide title (`<h2 class="run-title">`) is a **direct child of `<section class="spread">`** — a sibling of `.spread-fig` and `.spread-text`, not nested inside either. It spans the full grid row above the figure + commentary columns. There is no `.run-eyebrow` — the always-visible `top-tag` chrome (driven by `data-tag`) carries the section number + topic, so an in-slide eyebrow would duplicate it.

- `.spread > .run-title { grid-column: 1 / -1; margin: 0 0 32px; max-width: none; }` — spans both grid columns; takes its own row.
- `.spread-text > .run-lead:first-child { margin-top: 4px; }` — aligns the rail's first paragraph with the figbox top.

## Scroll-snap pages

- Each `.masthead` and `section.spread` is one **page**. The `margin-bottom: 100vh` + `min-height: 100vh` pattern gives a hard snap so the next page never peeks at the bottom of the current one.
- `html { scroll-behavior: smooth }` + arrow-key navigation (in template JS) jumps page-by-page. Don't drop scroll-snap — it's what makes this read as slides, not a long article.

## Motion

- Top-bar `.bar`: `width` transitions over `120 ms linear` as the user scrolls.
- `top-tag`: `opacity` transitions over `200 ms` — hidden on the masthead, visible on every other page.
- `nav-hint`: fades after first arrow-key interaction or 8 s timeout.
- No hover lifts on cards. The deck is read, not browsed.

## Status mapping (when a slide carries pass / warn / fail)

- Pass — `var(--success)` on `var(--accent-soft)` tint.
- Warn — `var(--warning)` on `var(--paper-2)`.
- Risk / cost — `var(--accent-deep)` or `var(--warning)` border with `var(--paper)` fill.

## Don't

- Don't reintroduce a second accent color. Ink + terracotta is the entire palette; voice / status uses warn/success.
- Don't put body copy in `--ink`. Use `--text` or `--text-soft`. Reserve ink for headings, rules, and emphasis.
- Don't use multiple colors inside a title. `mast-title em` and `run-title em` inherit the title color.
- Don't replace Source Serif 4 with a sans-serif for the run titles. The serif italic is the editorial signature.
- Don't widen `.spread` past the `2fr / 1fr` ratio. The asymmetry is what makes the figure read as primary and the commentary as the rail.
- Don't drop the page-indicator + top-tag chrome. The audience uses them to anchor where they are.
- Don't substitute an image logo for the wordmark in `.brand-chip`. The text wordmark keeps the chrome forkable.
