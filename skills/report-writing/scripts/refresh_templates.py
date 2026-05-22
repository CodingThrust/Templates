#!/usr/bin/env python3
"""Refresh the brand templates in an already-scaffolded repo.

Usage:
    python3 path/to/skills/report-writing/scripts/refresh_templates.py [target_dir]

Overwrites the four brand-template files under ``.github/templates/`` of the
target repo with the current bundled versions:

    index.html, markdown.html, viewer.html, styles.css

The build script, Makefile, and GitHub workflow are NOT touched — use
``scaffold.py`` for those (it skips files that already exist).
"""

from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
SKILL_ROOT = SCRIPT_DIR.parent
TEMPLATES_SRC = SKILL_ROOT / "references" / "templates"

TEMPLATE_FILES = (
    "index.html",
    "markdown.html",
    "viewer.html",
    "styles.css",
)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("target_dir", nargs="?", default=".",
                        help="Target repository directory (default: cwd)")
    args = parser.parse_args()

    target = Path(args.target_dir).resolve()
    if not target.is_dir():
        print(f"error: {target} is not a directory", file=sys.stderr)
        return 2

    dst_dir = target / ".github" / "templates"
    if not dst_dir.is_dir():
        print(f"error: {dst_dir} does not exist — run scaffold.py first", file=sys.stderr)
        return 2

    print(f"Refreshing templates in {dst_dir}")
    print()
    for name in TEMPLATE_FILES:
        src = TEMPLATES_SRC / name
        dst = dst_dir / name
        if not src.exists():
            print(f"  warn   bundled {name} missing — skipping")
            continue
        shutil.copy(src, dst)
        print(f"  write  .github/templates/{name}")
    print()
    print("Done. Rebuild with: make build")
    return 0


if __name__ == "__main__":
    sys.exit(main())
