# Style Tokens — Neutral Academic

Canonical values copied from `references/templates/styles.css`. Use these tokens verbatim — do not introduce new colors, fonts, or radii unless the theme genuinely needs to change.

## Color palette

Ink + a single muted accent on warm paper. Near-black `#1a1a1a` for headings and the wordmark, terracotta `#a55b3a` as the only accent.

| Token | Value | Use |
|---|---|---|
| `--bg` | `#f8f7f4` | Page background — warm paper, no gradient |
| `--surface` | `#ffffff` | Cards, top-layer panels |
| `--surface-2` | `#f1eee6` | Inset panels, code blocks, table headers |
| `--surface-3` | `#e9e5dc` | Deeper inset surfaces |
| `--border` | `#d9d6cf` | Default hairline borders |
| `--border-strong` | `#c4bfb3` | Emphasized borders, dashed empty states |
| `--ink` | `#1a1a1a` | Primary heading text, wordmark |
| `--ink-muted` | `#3a3a3a` | Subheadings, hover-down state |
| `--text` | `#1c1c1c` | Body copy |
| `--text-muted` | `#555555` | Subdued copy, nav links |
| `--text-dim` | `#828282` | Captions, meta labels |
| `--text-inverse` | `#f8f7f4` | Text on accent / dark surfaces |
| `--accent` | `#a55b3a` | Primary accent (links, badges, focused chips) |
| `--accent-soft` | `#ecdbcd` | Underline color, soft fills |
| `--accent-glow` | `rgba(165, 91, 58, 0.14)` | Selected chip background, soft tints |
| `--accent-deep` | `#8a4527` | Hover state for accent surfaces |
| `--success` | `#15803d` | Status: pass |
| `--warning` | `#b45309` | Status: warn |

## Typography

| Token | Stack | Where it's used |
|---|---|---|
| `--font-display` | Source Serif 4 (variable: opsz 8–60, ital, weight 300–600), Iowan, Georgia | h1–h6, hero title, prose headings, section titles, doc-card titles |
| `--font-serif` | Source Serif 4, Iowan Old Style, Georgia | Body copy, prose |
| `--font-sans` | Inter, system | Nav links, buttons, small UI chrome only |
| `--font-mono` | JetBrains Mono, SF Mono | Wordmark, eyebrows, chips, tags, h4 prose labels |

Body base: `16.5px / 1.6`, serif. Headings: Source Serif 4, weight 500, line-height 1.2, letter-spacing `-0.01em`. Hero h1: `clamp(1.75rem, 3.6vw, 2.375rem)`. Wrap italic emphasis in `<em>` — Source Serif 4 includes a true italic variant, and the CSS preserves the same color so emphasis reads as type, not paint.

Prose body: `1.0625rem / 1.65`. Prose h1: `2rem` with bottom border. Prose h2: `1.4rem` with bottom border. Prose h3: `1.1rem`. Prose h4: JetBrains Mono `0.8125rem` uppercase with letter-spacing `0.12em`.

## Shape and depth

| Token | Value | Use |
|---|---|---|
| `--radius-sm` | `6px` | Buttons, chips, small surfaces |
| `--radius` | `10px` | Cards, panels, code blocks |
| `--radius-lg` | `16px` | Hero-scale surfaces (rare) |
| `--shadow-sm` | `0 1px 2px rgba(28, 24, 16, 0.04)` | Idle elevation |
| `--shadow` | `0 4px 12px rgba(45, 35, 20, 0.06)` | Hover-elevated cards |
| `--shadow-lg` | `0 16px 40px rgba(45, 35, 20, 0.08)` | Modal-scale surfaces |

Shadows are tinted warm, matching the paper background. Don't use cool-blue shadows.

## Layout widths

| Surface | Max width | Padding |
|---|---|---|
| Header content | `1080px` | `0.875rem 1.5rem` |
| Index hero / sections | `820px` | `3rem 1.5rem 5rem` |
| Prose page | `760px` | `3rem 1.5rem 5rem` |
| Footer | `1080px` | `3rem 1.5rem 3.5rem` |

The narrower prose width is intentional — keeps line length at ~70 characters. Tables that don't fit should scroll horizontally inside the prose column rather than widen the column.

## Motion

- Hover transitions: `0.15s ease` on color, border-color, background, transform.
- Hover lift: `transform: translateY(-1px)` on `.doc-card` and `.hero-meta .chip`.
- `.doc-card:hover` reveals `.doc-arrow` (`opacity 0 → 1`, `translateX(-6px → 0)`).

## Header behavior

- Sticky top with `backdrop-filter: saturate(180%) blur(16px)` and `rgba(248, 247, 244, 0.85)` background — matches the warm paper.
- The wordmark `.brand` is text — JetBrains Mono uppercase, weight 500, letter-spacing `0.14em`. No image, no logo file.

## Status mapping (for status-style reports)

If the report includes pass/warn/fail badges (e.g., audit scorecards), reuse:

- Pass — `var(--success)` (`#15803d`) on `var(--accent-soft)`-tinted background.
- Warn — `var(--warning)` (`#b45309`) on `var(--surface-2)`.
- Fail — `var(--ink)` on `var(--accent-glow)`, or a flat `#b91c1c` if you need true red (introduce as a new token).

## Don't

- Don't introduce a second accent color. The point of this palette is one ink + one accent on paper. Add a token to `styles.css` only if a new accent is genuinely required.
- Don't switch the body font to sans-serif. The serif body is part of the academic feel.
- Don't switch headings back to Inter. The signature is Source Serif 4 for both body and display, with italic emphasis carrying the highlight.
- Don't drop the near-black ink for headings — even when an outside palette tempts you.
- Don't replace the wordmark with an image. The text wordmark is intentionally forkable.
