#!/usr/bin/env python3
"""Search, summarize, and extract slide layout patterns from layout-patterns.md."""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


SCRIPT_DIR = Path(__file__).resolve().parent
DEFAULT_PATTERNS = SCRIPT_DIR.parent / "references" / "layout-patterns.md"

ALIASES = {
    "metric": ["stats", "number", "numeral"],
    "metrics": ["stats", "numbers", "numerals"],
    "number": ["stats", "metric"],
    "numbers": ["stats", "metrics"],
    "quote": ["voice", "blockquote", "pull"],
    "quotes": ["voice", "blockquote", "pull"],
    "comparison": ["table", "before", "after"],
    "compare": ["table", "before", "after"],
    "closing": ["conclusion", "links", "ribbon"],
    "cta": ["conclusion", "links", "ribbon"],
}


class PatternToolError(Exception):
    pass


def slugify(value: str) -> str:
    cleaned = re.sub(r"`[^`]+`", "", value)
    cleaned = re.sub(r"\([^)]*\)", "", cleaned)
    cleaned = re.sub(r"[^a-zA-Z0-9]+", "-", cleaned.lower()).strip("-")
    return cleaned or "pattern"


def display_title(heading: str) -> str:
    title = heading.removeprefix("Pattern:").strip()
    return re.sub(r"\s*\([^)]*\)\s*", "", title).strip()


def load_patterns(path: str | Path = DEFAULT_PATTERNS) -> list[dict[str, Any]]:
    text = Path(path).read_text(encoding="utf-8")
    matches = list(re.finditer(r"^##\s+(Pattern:\s+.+)$", text, re.MULTILINE))
    patterns: list[dict[str, Any]] = []
    for index, match in enumerate(matches):
        start = match.end()
        end = matches[index + 1].start() if index + 1 < len(matches) else len(text)
        heading = match.group(1).strip()
        title = display_title(heading)
        body = text[start:end].strip()
        patterns.append(
            {
                "pattern_id": slugify(title),
                "heading": heading,
                "title": title,
                "body": body,
            }
        )
    return patterns


def query_tokens(query: str) -> list[str]:
    tokens: list[str] = []
    for token in re.findall(r"[a-zA-Z0-9]+", query.lower()):
        if token not in tokens:
            tokens.append(token)
        for alias in ALIASES.get(token, []):
            if alias not in tokens:
                tokens.append(alias)
    return tokens


def score_pattern(pattern: dict[str, Any], tokens: list[str]) -> int:
    title = pattern["title"].lower()
    pattern_id = pattern["pattern_id"].lower()
    body = pattern["body"].lower()
    score = 0
    for token in tokens:
        if token == pattern_id:
            score += 20
        if token in pattern_id:
            score += 8
        if token in title:
            score += 6
        score += min(body.count(token), 4)
    return score


def search_patterns(
    patterns: list[dict[str, Any]], query: str, limit: int = 3
) -> list[dict[str, Any]]:
    tokens = query_tokens(query)
    ranked: list[dict[str, Any]] = []
    for pattern in patterns:
        score = score_pattern(pattern, tokens)
        if score <= 0:
            continue
        ranked.append(
            {
                "pattern_id": pattern["pattern_id"],
                "title": pattern["title"],
                "score": score,
            }
        )
    ranked.sort(key=lambda item: (-item["score"], item["pattern_id"]))
    return ranked[: max(limit, 0)]


def find_pattern(patterns: list[dict[str, Any]], selector: str) -> dict[str, Any]:
    normalized = slugify(selector)
    matches = [
        pattern
        for pattern in patterns
        if pattern["pattern_id"] == normalized
        or pattern["pattern_id"] == selector
        or pattern["title"].lower() == selector.lower()
    ]
    if len(matches) == 1:
        return matches[0]
    if not matches:
        raise PatternToolError(f"pattern not found: {selector}")
    ids = ", ".join(pattern["pattern_id"] for pattern in matches)
    raise PatternToolError(f"pattern selector is ambiguous: {selector}; use one of {ids}")


def summarize_pattern(patterns: list[dict[str, Any]], selector: str) -> dict[str, Any]:
    pattern = find_pattern(patterns, selector)
    bullets = [
        line.strip("- ").strip()
        for line in pattern["body"].splitlines()
        if line.strip().startswith("- ")
    ]
    return {
        "pattern_id": pattern["pattern_id"],
        "title": pattern["title"],
        "first_guidelines": bullets[:4],
    }


def extract_pattern(patterns: list[dict[str, Any]], selector: str) -> dict[str, Any]:
    pattern = find_pattern(patterns, selector)
    return {
        "pattern_id": pattern["pattern_id"],
        "title": pattern["title"],
        "body": pattern["body"],
    }


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--patterns",
        default=str(DEFAULT_PATTERNS),
        help="Path to layout-patterns.md",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    search = subparsers.add_parser("search", help="Search patterns by slide job")
    search.add_argument("--query", required=True)
    search.add_argument("--limit", type=int, default=3)

    summarize = subparsers.add_parser("summarize", help="Summarize one pattern")
    summarize.add_argument("--pattern", required=True)

    extract = subparsers.add_parser("extract", help="Print one full pattern section")
    extract.add_argument("--pattern", required=True)
    return parser.parse_args(argv)


def run_cli(argv: list[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])
    patterns = load_patterns(args.patterns)
    if args.command == "search":
        result: Any = search_patterns(patterns, args.query, args.limit)
    elif args.command == "summarize":
        result = summarize_pattern(patterns, args.pattern)
    elif args.command == "extract":
        result = extract_pattern(patterns, args.pattern)
    else:
        raise PatternToolError(f"unknown command: {args.command}")
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(run_cli())
    except PatternToolError as error:
        print(f"pattern-tool error: {error}", file=sys.stderr)
        raise SystemExit(1) from error
