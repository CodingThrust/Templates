---
name: topic-report
description: Use when given a topic and a list of sources (URLs, arxiv IDs, DOIs, PDFs, local notes) and asked to collect what each source says about the topic and synthesize them into a single cited report. Drives a three-pass workflow — per-source extraction, cross-source synthesis, structured write-up — and grounds every claim in a specific source.
---

# Topic Report

## Overview

Turn `(topic, sources[])` into a single cited markdown report. The skill enforces a three-pass workflow so that nothing in the report is hallucinated and every claim is traceable to a specific source.

The output is plain markdown by default — drop it into a research log, a paper's related-work section, or a `.knowledge/` directory in your project repo to extend a reference library.

## When to use

- The user supplies (or you assemble) a list of papers, URLs, internal notes, or PDFs and asks for a synthesized take on a specific question.
- You need a literature-style write-up that cites where each claim came from.
- You are extending `.knowledge/` with a new topic note and want one place to land all the per-source extractions plus a synthesis on top.

## When NOT to use

- Single source → just read it and answer directly.
- Open-ended exploration with no sources yet → run a literature-discovery flow first (e.g., `sci-brain:survey`, or a hand-curated arXiv/Scholar sweep), then come back here once you have a source list.
- Pure styling / publishing of an already-written report → use your project's site / paper template instead.
- You only need to download/cache a paper → use a dedicated reference-fetch skill (e.g., `zlp-harness:download-ref`) and stop there.

## Inputs

The canonical input form is a **`sources.md`** file that bundles the topic statement, a filter rule, and the source list in one place. The user prepares this file ahead of invocation; the skill reads it as the first step.

### `sources.md` format

```markdown
# Topic
<One or two sentences. The narrower the better.
"How do recent graph-neural-network methods scale on heterophilic node-classification benchmarks?"
beats "graph neural networks".>

# Filter
<The rule that decides what counts as relevant content inside each source.
Apply this filter during pass-1 extraction — anything failing the filter goes in the per-source note as
"not in scope: <reason>", not in the body of the extraction.

Examples:
- "Only include results published 2023 or later."
- "Only include experimental results on benchmark X; ignore purely theoretical sections."
- "Only include claims tied to a public dataset or open-source code release."
- "Only include results that report runtime/memory, not only accuracy.">

# Recency
<Optional. Default `within: 1 month`. Affects source *discovery* (web search and arxiv queries),
not extraction. Format: `within: <N> <unit>` (e.g., `within: 1 month`, `within: 2 weeks`,
`since: 2026-01-01`, or `all` to disable). Discovered candidates older than the window are excluded
from the pick-list unless the user explicitly adds them.>

# History
<Optional. Default `.knowledge/topic-report-history.md` if `.knowledge/` exists in the cwd, otherwise
`.topic-report-history.md`. Path to the dedup ledger — the skill consults it during source discovery
and updates it after the report is written. See "History & deduplication" below.>

# Output
<Optional. Path for the report; default is `report.md` in cwd.>

# Audience
<Optional. internal | exec | whitepaper | investor. Default: internal.>

# Sources
- <source>
- <source>
- ...
```

Sources can be any mix of:

- Web URLs (blog post, vendor page, news article, GitHub README)
- arxiv IDs (`arxiv:2312.03982`)
- DOIs (`doi:10.1038/s41586-024-08465-y`)
- Local file paths (PDFs, markdown notes, code files)
- Local KB cite-keys already in `.knowledge/references.bib` (`[Smith2024]`)

Each source can have an optional per-source note after `—`:

```markdown
- arxiv:2312.03982 — Smith et al., main benchmark paper
- https://example.com/blog/some-result — industry write-up; cross-check
- [Doe2024] — follow-up paper, KB already has rendering
```

### If `sources.md` is missing or partial

- No `sources.md` and no inline list → ask the user where the source list is.
- Inline list given but no filter → ask for the filter rule, or confirm "everything topic-relevant" as the default filter.
- Filter present but ambiguous → echo your interpretation back to the user in one sentence and proceed only after confirmation.

The filter is load-bearing — it determines what shows up in every per-source note, so getting it right up front saves redoing pass 1.

## Workflow

The skill is rigid: three passes, no shortcuts. Each pass produces a concrete artifact before the next begins.

### Pass 1 — Per-source extraction

For each source, produce a short structured note. Do not synthesize yet; do not compare sources yet. The goal is a faithful, citable extraction of what *this one source* says about the topic, **filtered by the rule from `sources.md`**.

Use `references/source-extraction.md` for the per-source template and source-type-specific fetch tactics (PDF vs URL vs arxiv vs DOI vs local).

Apply the filter rule **inside** each extraction, not after. Content that fails the filter is recorded once as `not in scope: <reason>` and not included in the bullets — this keeps later passes from accidentally pulling filtered material back in.

Keep notes either in memory (small jobs, ≤5 sources) or as scratch files under `.scratch/topic-report/<slug>/<n>-<cite-key>.md` (larger jobs). Scratch files are gitignored.

If a source cannot be fetched (paywall, 404, format we can't read), record it as `unreachable` with the reason. Do not silently drop sources — the synthesis must know what was attempted and what was missed.

### Pass 2 — Cross-source synthesis

Read the per-source extractions side by side and produce:

- **Sub-themes** — 3–7 buckets that the findings naturally cluster into. Name them in the topic's vocabulary, not generic ("contrastive pretraining objectives" not "techniques").
- **Convergence vs. divergence** — for each sub-theme, where do sources agree, where do they disagree, and where do they cite different numbers for the same thing?
- **Gaps** — what does the topic statement ask that *no* source in the list answers?

Capture this as a one-page synthesis outline before writing the report. It's the load-bearing step — if the outline is muddled, the report will be too.

### Pass 3 — Write the report

Use `references/report-template.md` for section structure and citation conventions. Headline rule: every non-trivial claim in the prose must end with a `[CiteKey]` anchor that resolves to a row in the Sources table. Claims with no anchor are flagged.

## Source-handling tactics (quick reference)

Full per-source-type playbook lives in `references/source-extraction.md`. Defaults:

| Source type | First-line fetch | Fallback |
|---|---|---|
| Web URL | `WebFetch` with a topic-shaped prompt | `curl` to a local file, then `Read` |
| arxiv ID | If `.knowledge/.raw/arxiv/<id>.pdf` exists, `Read` it | Otherwise download via `download-ref` (or `curl https://arxiv.org/pdf/<id>.pdf`) |
| DOI | Resolve via Semantic Scholar / Crossref → arxiv if available | Otherwise WebFetch the publisher page (often paywalled — fall back to abstract) |
| Local PDF | `Read` directly (Read supports PDFs ≤10 pages without `pages`) | For larger PDFs, pass `pages: "1-10"` and iterate |
| Local markdown | `Read` | — |
| BibTeX cite-key in `.knowledge/` | `Read` the matching `<id>_<slug>.md` rendering | Fall back to the bib entry's abstract |

Always record the canonical citation (authors, year, venue/URL) for the Sources table — fetching the content is only half the job.

## History & deduplication

The skill maintains a **history ledger** so a sequence of runs on the same topic doesn't keep re-suggesting the same sources. Path defaults to `.knowledge/topic-report-history.md` (or `.topic-report-history.md` if `.knowledge/` doesn't exist), overridable via `# History` in `sources.md`.

### Ledger format

One markdown table, append-only. The skill reads it before source-discovery and appends to it after the report is written.

```markdown
# topic-report history

| Date | Topic slug | Source | Cite key | Bucket | Used in |
|---|---|---|---|---|---|
| 2026-05-21 | heterophilic-gnn-survey | arxiv:2401.12345 | Smith2024 | method | sources.md → report.md |
| 2026-05-21 | heterophilic-gnn-survey | doi:10.1145/3589334.3645678 | Doe2024 | benchmark | sources.md → report.md |
| 2026-05-21 | heterophilic-gnn-survey | https://example.com/blog/gnn-scaling | Lab-blog2024 | engineering | sources.md → report.md |
```

Source canonicalization for dedup:
- Strip URL query strings, trailing slashes, `http://` vs `https://`.
- arxiv: normalize to `arxiv:<id>` (no version suffix).
- DOI: normalize to `doi:<lowercase>`.
- Local paths: absolute path.

If a candidate's canonical form is already in the ledger, drop it from the pick-list and note "(seen YYYY-MM-DD in <topic-slug>)" alongside, so the user can still force-include it if they explicitly want a re-visit.

### When to dedupe

- **Source discovery (this skill, before presenting the pick-list)** — drop history hits from the candidate set by default. Show a "previously used" appendix the user can pull from if they want.
- **Inside a single sources.md** — also dedupe within the file itself (same arxiv ID listed twice, same paper given as both DOI and arxiv URL).
- **After report.md is written** — append every source actually used (including `unreachable` and `not in scope`) to the ledger with today's date.

### Ledger lifecycle

- Append-only. Don't rewrite past entries.
- Safe to share / commit if the topics aren't sensitive. The default `.knowledge/topic-report-history.md` is meant to be committed alongside the project's reference library.
- Periodically prune by topic-slug if the ledger grows past a few hundred entries (manual cleanup, not automated — keeps audit trail of what's been touched).

## Cite keys

Use the convention `[FirstAuthorYear]` (e.g., `[Smith2024]`, `[Doe2024]`). Disambiguate collisions with a lowercase letter: `[Smith2024a]`, `[Smith2024b]`. If the source is a non-paper (industry page, blog, internal memo, standards doc), use a short slug: `[Lab-blog2024]`, `[OpenAPI-spec]`. The Sources table is the source of truth — keep keys consistent across the prose and the table.

When the topic lives inside this repo's KB, prefer the existing cite keys from `.knowledge/references.bib` over inventing new ones.

## Quality bar

Before declaring the report done, verify:

- [ ] Every source from `sources.md` appears in the Sources table (including `unreachable` and `not in scope` ones).
- [ ] Every claim in the prose has a `[CiteKey]` anchor.
- [ ] No `[CiteKey]` appears in the prose that isn't in the Sources table.
- [ ] The filter rule from `sources.md` is restated verbatim in the report's Scope paragraph, so a reader knows what was excluded.
- [ ] No prose claim violates the filter (e.g., if the filter says "2023 or later", no 2021 result snuck into the body).
- [ ] The synthesis section actually compares sources — if it reads like sequential summaries, redo pass 2.
- [ ] Gaps and open questions are listed explicitly, not hidden inside prose.
- [ ] Quantitative numbers are quoted with units and source: "92.3% accuracy on the ogbn-arxiv test split [Smith2024]", not "very high accuracy".
- [ ] The history ledger has been appended with every source actually used (one row per source), and no candidate in the report was already in the ledger before this run unless the user explicitly opted into a re-visit.

## Common mistakes

| Mistake | Fix |
|---|---|
| Skipping pass 1 and writing the report straight from skimming | Always extract per-source first. Synthesis without extraction reliably hallucinates. |
| Silently dropping sources you couldn't fetch | Record them as `unreachable` with a reason. The user needs to know what's missing. |
| Inventing cite keys that drift between prose and table | Build the Sources table first, then write prose against its keys. |
| Generic sub-themes ("approaches", "results") | Use the topic's own vocabulary. Sub-themes should be findings, not chapter labels. |
| Burying disagreement in soft language | When sources disagree on a number or claim, say so explicitly with both numbers and both citations. |
| Pasting long source quotes verbatim | Extract claims, not paragraphs. The reader wants synthesis, not a clip file. |
| Hardcoding the output path | Confirm with the user; default to `report.md` in cwd unless they pointed elsewhere. |
