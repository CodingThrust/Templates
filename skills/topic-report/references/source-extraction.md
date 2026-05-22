# Per-Source Extraction

The output of pass 1. One note per source. Don't synthesize; don't compare. Just extract what *this source* says about the topic, **passed through the filter rule from `sources.md`**.

## Per-source note template

```markdown
## [<CiteKey>] <Short title>

- **Type:** paper | preprint | vendor page | blog | repo README | internal note | dataset
- **Citation:** <authors, year, venue/URL — what would appear in a Sources table>
- **Fetched via:** <how you got the content — WebFetch, Read PDF, KB rendering, …>
- **Relevance to topic:** high | medium | low | unreachable | not in scope
- **Filter applied:** <one-line restatement of the filter rule from sources.md>

### What this source says about the topic (post-filter)

<2–6 bullets. Each bullet is one claim, method, or number from the source — in your own words,
tied to the topic, and consistent with the filter. No general source summary; nothing the filter rules out.>

### Quoted numbers / specifics

<Any concrete numbers, parameter values, dates, code identifiers, etc. Quote with units. e.g.,
- "92.3% top-1 accuracy on dataset X (Table 1, p. 4)"
- "Training: 4×A100, 36 GPU-hours, batch size 256 (Section 4.2)">

### Filtered-out content

<One short paragraph or bullet list of material in the source that touches the topic but was excluded
by the filter rule. This is not the same as "irrelevant" — it's relevant-but-filtered. Recording it
here prevents the synthesis pass from sneaking it back in, and helps the user audit whether the
filter is too aggressive.>

### Caveats

<Anything the synthesis pass needs to know: scope limits, conflicting evidence inside the source, n=1 anecdote, marketing claim vs. peer-reviewed result, etc.>
```

For `unreachable` sources, fill only the first two blocks and add a one-line reason ("paywall", "404", "PDF >50pp and the relevant section is unknown", etc.).

For `not in scope` sources (the filter excludes the whole source — e.g., the filter says "2023+" and the paper is from 2019), record only the metadata block and a one-line reason. Still keep them in the Sources table downstream so the reader sees what was considered.

## Source-type fetch tactics

### Web URLs

- First choice: `WebFetch` with a topic-shaped prompt:
  > `WebFetch(url=..., prompt="Extract everything this page says about <topic>. Quote specific numbers and section headings. Ignore unrelated content.")`
- The prompt is doing real work — a generic "summarize" prompt wastes the source.
- If `WebFetch` returns a thin or off-target answer, `curl -L <url> -o /tmp/page.html` and `Read` the file. Some pages render content client-side and need a follow-up pass.
- For PDFs served at a URL, prefer downloading to a local file and using `Read` with PDF support over WebFetch.

### arxiv IDs

- Check `.knowledge/.raw/arxiv/<id>.pdf` first. If present, `Read` it directly.
- Check `.knowledge/<id>_<slug>.md` — the KB may already have a full-text rendering with frontmatter. That's the cheapest extraction path.
- Otherwise, download with `download-ref` if available, or:
  ```bash
  curl -L -o /tmp/arxiv-<id>.pdf https://arxiv.org/pdf/<id>.pdf
  ```
- For PDFs over 10 pages, `Read` with `pages: "1-10"` and iterate. Start with the abstract, intro, and conclusions before reading methods/appendices.

### DOIs

- Try arxiv first — many papers have a preprint with the same content. Resolve `doi: → arxiv-id` via Semantic Scholar (`https://api.semanticscholar.org/graph/v1/paper/DOI:<doi>?fields=externalIds,title,abstract`).
- If no arxiv mirror, `WebFetch` the DOI's resolved URL. Often paywalled — fall back to extracting just the abstract and recording the source as `medium` relevance with a caveat.

### Local PDFs

- `Read` directly with PDF support. For >10 pages, pass `pages: "1-10"` (max 20 pages per call).
- For figure-heavy papers, check `.knowledge/.figures/<source>__<id>/_index.json` if the KB has extracted the images.

### Local markdown / code / internal notes

- `Read` directly. If the file is huge, `grep` for topic keywords first and read the matching sections.
- For mirrors of external wikis / notebooks (e.g., a synced Notion / Confluence / Feishu page under `.knowledge/`), the source of truth is the upstream system — note that in the caveats so the report can date-stamp the claim.

### Existing KB cite-keys

- If the source is given as `[FooBar2024]` and lives in `.knowledge/references.bib`, `grep` for the cite key in `.knowledge/`. Prefer the rendered `<id>_<slug>.md` over re-downloading.
- Reuse the cite key verbatim — do not rename it.

## How long should a per-source note be?

Aim for one screenful (≈30 lines). A 30-page paper that has one paragraph relevant to the topic gets a short note; a 4-page focused paper might get a longer one. Length tracks relevance, not source length.

If a source is in the input list but turns out to have nothing relevant, record it as `low` relevance with a one-line "out of scope: <why>" and move on. Don't pad.
