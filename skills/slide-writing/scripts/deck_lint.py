#!/usr/bin/env python3
"""Lint a neutral-academic HTML slide deck for structural and house-style risks."""

from __future__ import annotations

import argparse
import json
import re
import sys
from html.parser import HTMLParser
from pathlib import Path
from typing import Any


REQUIRED_CHROME = {
    "scroll-progress",
    "brand-chip",
    "top-tag",
    "nav-hint",
    "page-indicator",
}

TEMPLATE_IDS = {"problem", "model", "evidence", "feasibility", "conclusion"}
TEMPLATE_TAGS = {
    "§1 · The problem",
    "§2 · The model",
    "§3 · Evidence",
    "§4 · Feasibility",
    "§5 · Conclusion",
}


class DeckLintError(Exception):
    pass


def class_set(attrs: dict[str, str]) -> set[str]:
    return {item for item in re.split(r"\s+", attrs.get("class", "").strip()) if item}


def is_local_src(src: str) -> bool:
    return bool(src) and not re.match(r"^(?:https?:|data:|mailto:|#)", src)


class DeckParser(HTMLParser):
    def __init__(self) -> None:
        super().__init__(convert_charrefs=False)
        self.all_classes: set[str] = set()
        self.ids: list[str] = []
        self.img_srcs: list[dict[str, Any]] = []
        self.sections: list[dict[str, Any]] = []
        self.masthead_seen = False
        self.script_text: list[str] = []
        self.inline_styles: list[dict[str, Any]] = []
        self.title_color_styles: list[dict[str, Any]] = []

        self._section_stack: list[dict[str, Any]] = []
        self._title_stack: list[dict[str, Any]] = []
        self._script_depth = 0

    def handle_starttag(self, tag: str, attrs_list: list[tuple[str, str | None]]) -> None:
        self._handle_tag(tag, attrs_list, is_endless=False)

    def handle_startendtag(self, tag: str, attrs_list: list[tuple[str, str | None]]) -> None:
        self._handle_tag(tag, attrs_list, is_endless=True)

    def handle_endtag(self, tag: str) -> None:
        if tag == "section" and self._section_stack:
            self._section_stack.pop()
        if tag in {"h1", "h2"} and self._title_stack:
            self._title_stack.pop()
        if tag == "script" and self._script_depth:
            self._script_depth -= 1

    def handle_data(self, data: str) -> None:
        if self._script_depth:
            self.script_text.append(data)

    def _handle_tag(
        self,
        tag: str,
        attrs_list: list[tuple[str, str | None]],
        is_endless: bool,
    ) -> None:
        attrs = {key: value or "" for key, value in attrs_list}
        classes = class_set(attrs)
        line, column = self.getpos()
        self.all_classes.update(classes)

        if "id" in attrs:
            self.ids.append(attrs["id"])

        if attrs.get("style"):
            self.inline_styles.append(
                {"tag": tag, "style": attrs["style"], "line": line, "column": column}
            )

        if tag == "header" and "masthead" in classes:
            self.masthead_seen = True

        current_section = self._section_stack[-1] if self._section_stack else None
        if tag == "section" and "spread" in classes:
            current_section = {
                "id": attrs.get("id"),
                "data_tag": attrs.get("data-tag"),
                "line": line,
                "has_fig": False,
                "has_text": False,
                "titles": [],
            }
            self.sections.append(current_section)
            if not is_endless:
                self._section_stack.append(current_section)

        if tag == "h1" and "mast-title" in classes:
            title = {"em_count": 0, "line": line, "label": "masthead title"}
            if not is_endless:
                self._title_stack.append(title)

        if current_section:
            if "spread-fig" in classes:
                current_section["has_fig"] = True
            if "spread-text" in classes:
                current_section["has_text"] = True
            if tag == "h2" and "run-title" in classes:
                title = {
                    "em_count": 0,
                    "line": line,
                    "label": current_section.get("id") or "run title",
                }
                current_section["titles"].append(title)
                if not is_endless:
                    self._title_stack.append(title)

        if (
            self._title_stack
            and tag not in {"h1", "h2"}
            and re.search(
                r"(^|;)\s*color\s*:\s*(?!inherit\b|currentColor\b)[^;]+",
                attrs.get("style", ""),
            )
        ):
            self.title_color_styles.append(
                {
                    "label": self._title_stack[-1].get("label", "title"),
                    "style": attrs.get("style", ""),
                    "line": line,
                }
            )

        if tag == "em" and self._title_stack:
            self._title_stack[-1]["em_count"] += 1

        if tag == "img" and attrs.get("src"):
            self.img_srcs.append({"src": attrs["src"], "line": line})

        if tag == "script" and not is_endless:
            self._script_depth += 1


def build_issue(
    level: str,
    code: str,
    message: str,
    *,
    line: int | None = None,
    context: str | None = None,
) -> dict[str, Any]:
    issue: dict[str, Any] = {"level": level, "code": code, "message": message}
    if line is not None:
        issue["line"] = line
    if context:
        issue["context"] = context
    return issue


def lint_html(html: str, base_dir: str | Path | None = None, source_path: str | None = None) -> dict[str, Any]:
    parser = DeckParser()
    parser.feed(html)
    parser.close()

    base = Path(base_dir or ".").resolve()
    issues: list[dict[str, Any]] = []

    missing_chrome = sorted(REQUIRED_CHROME - parser.all_classes)
    for class_name in missing_chrome:
        issues.append(
            build_issue(
                "error",
                "missing_chrome",
                f"required chrome element .{class_name} is missing",
            )
        )

    if not parser.masthead_seen:
        issues.append(build_issue("error", "missing_masthead", "missing header.masthead"))

    if not parser.sections:
        issues.append(build_issue("error", "missing_spreads", "no section.spread pages found"))

    seen_ids: set[str] = set()
    for element_id in parser.ids:
        if element_id in seen_ids:
            issues.append(
                build_issue("error", "duplicate_id", f'duplicate id "{element_id}"')
            )
        seen_ids.add(element_id)

    for index, section in enumerate(parser.sections, start=1):
        label = section.get("id") or f"spread {index}"
        if not section.get("id"):
            issues.append(
                build_issue(
                    "error",
                    "missing_id",
                    f"{label} is missing an id",
                    line=section.get("line"),
                )
            )
        if not section.get("data_tag"):
            issues.append(
                build_issue(
                    "error",
                    "missing_data_tag",
                    f"{label} is missing data-tag",
                    line=section.get("line"),
                )
            )
        if section.get("id") in TEMPLATE_IDS or section.get("data_tag") in TEMPLATE_TAGS:
            issues.append(
                build_issue(
                    "warning",
                    "template_leftover",
                    f"{label} still looks like a bundled example section",
                    line=section.get("line"),
                )
            )
        if not section["has_fig"]:
            issues.append(
                build_issue(
                    "error",
                    "missing_spread_fig",
                    f"{label} is missing .spread-fig",
                    line=section.get("line"),
                )
            )
        if not section["has_text"]:
            issues.append(
                build_issue(
                    "error",
                    "missing_spread_text",
                    f"{label} is missing .spread-text",
                    line=section.get("line"),
                )
            )
        if not section["titles"]:
            issues.append(
                build_issue(
                    "error",
                    "missing_run_title",
                    f"{label} is missing h2.run-title",
                    line=section.get("line"),
                )
            )
        for title in section["titles"]:
            if title["em_count"] != 1:
                issues.append(
                    build_issue(
                        "error",
                        "title_em_count",
                        f"{label} title should contain exactly one <em>; found {title['em_count']}",
                        line=title.get("line"),
                    )
                )

    script = "\n".join(parser.script_text)
    if "keydown" not in script:
        issues.append(
            build_issue("error", "missing_navigation_script", "keyboard navigation script is missing")
        )
    if "pageIndicator" not in html:
        issues.append(
            build_issue("error", "missing_page_indicator_hook", "pageIndicator hook is missing")
        )

    for image in parser.img_srcs:
        src = image["src"]
        if is_local_src(src) and not (base / src).exists():
            issues.append(
                build_issue(
                    "error",
                    "missing_asset",
                    f'local image "{src}" does not exist relative to {base}',
                    line=image.get("line"),
                )
            )

    for item in parser.inline_styles:
        if re.search(r"#[0-9a-fA-F]{3,8}\b", item["style"]):
            issues.append(
                build_issue(
                    "warning",
                    "inline_hex_color",
                    "inline style contains a hex color; use a CSS token or class",
                    line=item.get("line"),
                    context=item["style"],
                )
            )

    for item in parser.title_color_styles:
        issues.append(
            build_issue(
                "error",
                "title_color_variation",
                f"{item['label']} contains inline color styling; title emphasis must inherit the title color",
                line=item.get("line"),
                context=item.get("style"),
            )
        )

    error_count = sum(1 for issue in issues if issue["level"] == "error")
    warning_count = sum(1 for issue in issues if issue["level"] == "warning")
    return {
        "file": source_path,
        "summary": {
            "slide_count": len(parser.sections),
            "error_count": error_count,
            "warning_count": warning_count,
        },
        "issues": issues,
    }


def print_usage() -> None:
    print("Usage:\n  python3 deck_lint.py --input <presentation.html>", file=sys.stderr)


def parse_args(argv: list[str]) -> argparse.Namespace:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--input", required=True, help="HTML deck to lint")
    return parser.parse_args(argv)


def run_cli(argv: list[str] | None = None) -> int:
    args = parse_args(argv or sys.argv[1:])
    input_path = Path(args.input).resolve()
    if not input_path.exists():
        raise DeckLintError(f"input does not exist: {input_path}")
    result = lint_html(
        input_path.read_text(encoding="utf-8"),
        input_path.parent,
        str(input_path),
    )
    print(json.dumps(result, ensure_ascii=False, indent=2))
    return 1 if result["summary"]["error_count"] else 0


if __name__ == "__main__":
    try:
        raise SystemExit(run_cli())
    except DeckLintError as error:
        print(f"deck-lint error: {error}", file=sys.stderr)
        raise SystemExit(1) from error
