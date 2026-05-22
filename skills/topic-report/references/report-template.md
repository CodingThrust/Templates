# Report Template

The output of pass 3. One markdown file. Structured so a reader can scan the TL;DR and Sources table, then dive into the sub-theme they care about.

## Skeleton

```markdown
# <Topic — phrased as the question being answered>

> **Scope.** <One paragraph: what's in, what's out, which audience, which date range of evidence.>
>
> **Filter.** <Verbatim restatement of the filter rule from `sources.md`. So a reader who disagrees with the framing knows what was excluded — and can ask for a re-run with a different filter without re-reading the sources.>

## TL;DR

- <3–6 bullets. Each bullet is a claim with a [CiteKey] anchor.>
- <Where sources disagree, say so in one bullet and cite both sides.>
- <End with one bullet on the biggest gap or open question.>

## Sources

| Key | Citation | Type | Relevance | Notes |
|---|---|---|---|---|
| [Smith2024] | Smith et al., *NeurIPS* (2024). [link](https://arxiv.org/abs/2401.12345) | paper | high | main benchmark result on dataset X |
| [Lab-blog2024] | Some Lab, "Engineering notes on scaling X" (2024). [link](https://example.com/blog/...) | blog | medium | informal write-up; cross-check numbers |
| [Doe2024] | Doe et al., *J. Some Field* (2024). [doi](https://doi.org/10.xxxx/yyyyy) | paper | unreachable | paywalled, no preprint — abstract only |

## Findings

### <Sub-theme 1, named in topic vocabulary>

<Synthesis prose, 1–3 short paragraphs. Every non-trivial claim ends with a [CiteKey] anchor.
Where sources agree, cite them all: "...has been demonstrated on the standard benchmark [Smith2024][Lab-blog2024]".
Where they disagree, name the disagreement explicitly: "accuracy is reported as 92.3% [Smith2024]
but only 88.7% under a stricter evaluation protocol [Doe2024]".>

### <Sub-theme 2>

<...>

### <Sub-theme N>

<...>

## Per-source notes

Condensed versions of the pass-1 extractions, one paragraph each, in the order they appear in the Sources table. Lets a reader who wants to verify a claim see what the source actually said without reopening it.

### [Smith2024]
<One paragraph: what the paper demonstrated, on what dataset / setup, with what numbers, relevant to which sub-themes.>

### [Lab-blog2024]
<...>

## Gaps and open questions

- <Question the topic statement asked that no source answered.>
- <Disagreement that wasn't resolved by any source in the list — flag it and name what evidence would resolve it.>
- <Sources that would plausibly answer the gap (named, even if not fetched here).>

## Method

<2–4 sentence note: how sources were assembled, which were unreachable and why, date the report was produced. This is the part that ages — readers six months later need to know the snapshot date.>
```

## Style notes

- Use the topic's own vocabulary in section names, not generic placeholders like "Approaches" or "Results".
- Prefer short paragraphs over bullets in `Findings` — synthesis reads better as prose.
- Use tables for things that are genuinely tabular (parameter comparisons, benchmark matrices). Don't reach for them just to look structured.
- Quote numbers with units and a citation. "Very strong results" is not a finding; "92.3% top-1 accuracy on dataset X [Smith2024]" is.
- Don't end sentences with parenthetical citations — anchor them at the end of the claim, before the punctuation.

## Audience adaptations

The skeleton is the same regardless of audience. What changes:

| Audience | TL;DR length | Findings depth | Per-source notes |
|---|---|---|---|
| Internal research note (default) | 4–6 bullets | full | full |
| Group-meeting brief | 3 bullets, plain English | 1 paragraph per sub-theme | drop, link out to Sources |
| Paper "related work" draft | 3–4 bullets | full + figures from sources | keep as appendix |
| Funding / proposal one-pager | 2–3 bullets, claim-first | 1 paragraph per sub-theme, no jargon | drop |

The Sources table and the Gaps section stay in every variant.

## Synthesis-section red flags

If you find yourself writing any of these, stop and redo pass 2:

- "Source A says X. Source B says Y. Source C says Z." → That's a list, not synthesis. Group by claim, not by source.
- "Many sources agree that..." without naming them → name them.
- A sub-theme with only one citing source → it's not a sub-theme yet; fold into another or move to Gaps.
- More than 7 sub-themes → too granular; cluster.
- Fewer than 3 sub-themes with 5+ sources → too coarse; split.
