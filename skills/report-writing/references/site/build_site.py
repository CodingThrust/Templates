#!/usr/bin/env python3
"""Build the documentation site into ``_site/``.

Drop-in single-script site builder for research documentation sites. Adding a
document means adding one entry to ``DOC_REGISTRY`` below; nothing scans the
filesystem implicitly.

Three document kinds are supported:

- ``typst``    — compile to PDF, wrap in ``viewer.html``.
- ``markdown`` — render to HTML, wrap in ``markdown.html``.
- ``download`` — copy the file as-is for direct download from the index.

External commands invoked:
- ``typst compile`` for Typst sources (must be on PATH; only required if any
  ``Doc`` has ``kind="typst"``).

Dependencies (CI installs via ``pip install markdown pymdown-extensions``):
- ``markdown``           — GFM-style rendering.
- ``pymdown-extensions`` — fenced code, tables, ToC, magic links.
"""

from __future__ import annotations

import json
import shutil
import subprocess
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Literal

import markdown


# ─── Paths ────────────────────────────────────────────────────────────────────

REPO = Path(__file__).resolve().parent.parent
SITE = REPO / "_site"
PDF_DIR = SITE / "pdfs"
TEMPLATES = REPO / ".github" / "templates"


# ─── CONFIG: edit this block for your repo ───────────────────────────────────

# Site-wide chrome. SOURCE_URL appears in both the header nav and the prose
# page footers. Keep SITE_SLUG short — it shows in mono-uppercase as the wordmark.
SITE_TITLE       = "Project Docs"
SITE_DESCRIPTION = "Documentation, notes, and reports."
SITE_SLUG        = "PROJECT"            # wordmark (mono, uppercase, letter-spaced)
SITE_KIND        = "docs"               # sub-text next to the wordmark
SOURCE_URL       = "https://github.com/<org>/<repo>"
SITE_COPYRIGHT   = "© Your Group"
HERO_EYEBROW     = "Open documentation"
HERO_TITLE       = "Title of the project, in <em>one line</em>."
HERO_SUBTITLE    = (
    "Two-sentence framing. What this site covers, "
    "who it is for, and the most useful entry point."
)

# Public URL prefix used to build "View source on GitHub" links in rendered
# markdown pages. Set to the branch + path you publish from.
GITHUB_BASE = "https://github.com/<org>/<repo>/blob/main"

# Default tab shown when the index page loads. Must match one of the
# group keys you use in ``DOC_REGISTRY``. A "group" is whatever you want to
# slice docs by — version, audience, project phase, release year, etc.
DEFAULT_GROUP = "main"

# Group tabs shown at the top of the index. Each entry is rendered as a chip;
# set ``label`` for the visible text. Use a single entry if you don't need tabs.
GROUP_TABS = [
    {"id": "main", "label": "main"},
]

# Section metadata. The order here is the display order within each group tab;
# a section with no entries for the active group is skipped at render time.
SECTION_META = [
    {"id": "docs", "title": "Documents", "desc": "Project documentation."},
]


@dataclass(frozen=True)
class Doc:
    slug: str         # typst/markdown: output basename (no extension; viewer at <slug>.html).
                      # download: relative output path inside _site/ (e.g. "v1/foo.json").
    kind: Literal["typst", "markdown", "download"]
    source: str       # path inside the repo, relative to repo root.
    title: str        # card + page title.
    desc: str         # one-line card description.
    tag: str          # short type pill on the card (PDF, MD, JSON, PY, …).
    section: str      # must match one of SECTION_META ids.
    group: str        # selects which tab the card lives under; matches a GROUP_TABS id.


DOC_REGISTRY: list[Doc] = [
    # Seed entry — render the README as the project's first document.
    # Replace / extend with your own docs.
    Doc("readme", "markdown", "README.md",
        "Project README",
        "Project overview, setup, and usage.",
        "MD", "docs", "main"),
]

# ─── End of CONFIG ───────────────────────────────────────────────────────────


MD_EXTENSIONS = [
    "fenced_code",
    "tables",
    "sane_lists",
    "toc",
    "pymdownx.tilde",
    "pymdownx.superfences",
    "pymdownx.magiclink",
]


def fresh_site() -> None:
    if SITE.exists():
        shutil.rmtree(SITE)
    PDF_DIR.mkdir(parents=True)


def copy_static() -> None:
    shutil.copy(TEMPLATES / "styles.css", SITE / "styles.css")
    # If you add a favicon or logo, drop it under .github/templates/ and list
    # it here so copy_static brings it into _site/.
    for asset in ():
        src = TEMPLATES / asset
        if src.exists():
            shutil.copy(src, SITE / asset)


def compile_typst(doc: Doc) -> Path:
    out = PDF_DIR / f"{doc.slug}.pdf"
    src = REPO / doc.source
    print(f"  · typst   {doc.source}  →  pdfs/{out.name}")
    subprocess.run(
        ["typst", "compile", "--root", str(REPO), str(src), str(out)],
        check=True,
    )
    return out


def _site_chrome(template: str) -> str:
    """Fill the site-wide chrome placeholders shared across page templates."""
    return (
        template
        .replace("{{SITE_TITLE}}",     SITE_TITLE)
        .replace("{{SITE_SLUG}}",      SITE_SLUG)
        .replace("{{SITE_KIND}}",      SITE_KIND)
        .replace("{{SITE_COPYRIGHT}}", SITE_COPYRIGHT)
    )


def render_viewer(doc: Doc) -> None:
    template = _site_chrome((TEMPLATES / "viewer.html").read_text())
    html = (
        template
        .replace("{{TITLE}}", doc.title)
        .replace("{{TAG}}", doc.tag)
        .replace("{{FILENAME}}", doc.slug)
    )
    (SITE / f"{doc.slug}.html").write_text(html)


def render_markdown(doc: Doc) -> None:
    src = REPO / doc.source
    print(f"  · md      {doc.source}  →  {doc.slug}.html")
    body = markdown.markdown(src.read_text(), extensions=MD_EXTENSIONS)
    template = _site_chrome((TEMPLATES / "markdown.html").read_text())
    source_url = f"{GITHUB_BASE}/{doc.source}"
    html = (
        template
        .replace("{{TITLE}}",      doc.title)
        .replace("{{SOURCE_URL}}", source_url)
        .replace("{{CONTENT}}",    body)
    )
    (SITE / f"{doc.slug}.html").write_text(html)


def copy_download(doc: Doc) -> int:
    dst = SITE / doc.slug
    dst.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy(REPO / doc.source, dst)
    size = dst.stat().st_size
    print(f"  · dl      {doc.source}  →  {doc.slug}  ({_fmt_size(size)})")
    return size


def _fmt_size(n: int) -> str:
    if n < 1024:
        return f"{n} B"
    if n < 1024 * 1024:
        return f"{n / 1024:.1f} KB"
    return f"{n / (1024 * 1024):.1f} MB"


def card_payload(doc: Doc, size: int | None) -> dict:
    """One card descriptor — shape consumed by the index page's JS."""
    if doc.kind == "download":
        return {
            "href": doc.slug,
            "title": doc.title,
            "desc": doc.desc,
            "kind": doc.tag,
            "download": True,
            "size": _fmt_size(size) if size is not None else None,
        }
    return {
        "href": f"{doc.slug}.html",
        "title": doc.title,
        "desc": doc.desc,
        "kind": doc.tag,
        "download": False,
        "size": None,
    }


def render_index(card_sizes: dict[str, int]) -> None:
    """Produce _site/index.html with all docs grouped first by group then section."""
    group_ids = {tab["id"] for tab in GROUP_TABS}
    groups: dict[str, dict[str, list[dict]]] = {
        tab["id"]: {s["id"]: [] for s in SECTION_META} for tab in GROUP_TABS
    }
    for doc in DOC_REGISTRY:
        if doc.section not in {s["id"] for s in SECTION_META}:
            raise ValueError(f"Doc {doc.slug!r} references unknown section {doc.section!r}.")
        if doc.group not in group_ids:
            raise ValueError(f"Doc {doc.slug!r} references unknown group {doc.group!r}.")
        groups[doc.group][doc.section].append(card_payload(doc, card_sizes.get(doc.slug)))

    payload = {
        "sectionMeta": SECTION_META,
        "groups": groups,
        "default": DEFAULT_GROUP,
    }
    tabs_html = "\n        ".join(
        f'<button class="chip tab" role="tab" data-group="{tab["id"]}"'
        f' aria-selected="{"true" if tab["id"] == DEFAULT_GROUP else "false"}">'
        f'<span class="chip-dot"></span>{tab["label"]}</button>'
        for tab in GROUP_TABS
    )
    template = (TEMPLATES / "index.html").read_text()
    html = (
        template
        .replace("{{DATA_JSON}}",       json.dumps(payload))
        .replace("{{HERO_TABS}}",       tabs_html)
        .replace("{{SITE_TITLE}}",      SITE_TITLE)
        .replace("{{SITE_DESCRIPTION}}",SITE_DESCRIPTION)
        .replace("{{SITE_SLUG}}",       SITE_SLUG)
        .replace("{{SITE_KIND}}",       SITE_KIND)
        .replace("{{SOURCE_URL}}",      SOURCE_URL)
        .replace("{{SITE_COPYRIGHT}}",  SITE_COPYRIGHT)
        .replace("{{HERO_EYEBROW}}",    HERO_EYEBROW)
        .replace("{{HERO_TITLE}}",      HERO_TITLE)
        .replace("{{HERO_SUBTITLE}}",   HERO_SUBTITLE)
    )
    (SITE / "index.html").write_text(html)


def build() -> None:
    fresh_site()
    copy_static()

    print("Building documents…")
    sizes: dict[str, int] = {}
    for doc in DOC_REGISTRY:
        if doc.kind == "typst":
            compile_typst(doc)
            render_viewer(doc)
        elif doc.kind == "markdown":
            render_markdown(doc)
        elif doc.kind == "download":
            sizes[doc.slug] = copy_download(doc)
        else:
            raise ValueError(f"Unknown kind {doc.kind!r} on {doc.slug!r}.")

    print("Rendering index…")
    render_index(sizes)

    print(f"\n✅ Site built at {SITE.relative_to(REPO)}/")
    print("   Serve locally with: make serve")


if __name__ == "__main__":
    sys.exit(build() or 0)
