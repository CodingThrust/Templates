#!/usr/bin/env python3
"""Scaffold a neutral-academic scroll-snapped slide deck into a target directory.

Usage:
    python3 path/to/skills/slide-writing/scripts/scaffold.py [--force] [--name NAME] [target_dir]

By default, the target is the current working directory and the deck is named
``presentation.html``. The scaffold is idempotent: existing files are kept and
reported as ``skip``; new files are written and reported as ``write``. Pass
``--force`` to overwrite existing files.

What this creates (relative to target_dir):

    <NAME>.html         (the deck — masthead + 5 example sections covering every layout pattern)

The HTML is a single self-contained file: CSS, JS, fonts (Google Fonts CDN),
chrome (scroll progress, top section tag, page indicator, arrow-key nav), and
one masthead + five example .spread sections demonstrating every layout
pattern. Edit in place — keep the chrome and the .spread skeleton, replace the
content.
"""

from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
SKILL_ROOT = SCRIPT_DIR.parent
REFERENCES = SKILL_ROOT / "references"


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("target_dir", nargs="?", default=".",
                        help="Target directory (default: cwd)")
    parser.add_argument("--name", default="presentation",
                        help='Deck file basename without extension (default: "presentation")')
    parser.add_argument("--force", action="store_true",
                        help="Overwrite existing files instead of skipping them.")
    args = parser.parse_args()

    target = Path(args.target_dir).resolve()
    if not target.is_dir():
        print(f"error: {target} is not a directory", file=sys.stderr)
        return 2

    deck_name = f"{args.name}.html"
    files: list[tuple[Path, str]] = [
        (REFERENCES / "template.html", deck_name),
    ]

    print(f"Scaffolding slide deck into {target}")
    print()

    write_count = skip_count = 0
    for src, dst_rel in files:
        dst = target / dst_rel
        dst.parent.mkdir(parents=True, exist_ok=True)

        if dst.exists() and not args.force:
            print(f"  skip   {dst_rel}")
            skip_count += 1
        else:
            shutil.copy(src, dst)
            verb = "force" if dst.exists() and args.force else "write"
            print(f"  {verb}  {dst_rel}")
            write_count += 1

    print()
    print(f"Summary: {write_count} written, {skip_count} skipped")
    print()
    print("Next steps:")
    print(f"  1. Edit {deck_name} — replace masthead text, then work through the five example sections.")
    print( "  2. Open in a browser. Use ← / → / space / PgUp / PgDn / Home / End to navigate.")
    print( "  3. To preview locally:  python3 -m http.server  (then open the URL it prints).")
    print()
    return 0


if __name__ == "__main__":
    sys.exit(main())
