#!/usr/bin/env python3
"""Scaffold a neutral-academic documentation site into the current repository.

Usage:
    python3 path/to/skills/report-writing/scripts/scaffold.py [--force] [target_dir]

By default, the target is the current working directory. The scaffold is
idempotent: existing files are kept and reported as "skip"; new files are
written and reported as "write". Pass ``--force`` to overwrite existing files.

What this creates (relative to target_dir):

    .github/templates/index.html         (HTML index page)
    .github/templates/markdown.html      (HTML prose viewer)
    .github/templates/viewer.html        (HTML PDF viewer)
    .github/templates/styles.css         (ink + terracotta stylesheet)
    .github/workflows/deploy-pages.yml   (GitHub Pages CI workflow)
    tools/build_site.py                  (single-script site builder)
    Makefile                             (or Makefile.site if Makefile exists)

After scaffolding, the suggested next steps are printed.
"""

from __future__ import annotations

import argparse
import shutil
import sys
from pathlib import Path


SCRIPT_DIR = Path(__file__).resolve().parent
SKILL_ROOT = SCRIPT_DIR.parent
REFERENCES = SKILL_ROOT / "references"
TEMPLATES_SRC = REFERENCES / "templates"
SITE_SRC = REFERENCES / "site"


# (source path relative to SKILL_ROOT, destination path relative to target_dir,
#  fall-back destination if the primary destination already exists, or None to
#  always skip when present)
FILES: list[tuple[Path, str, str | None]] = [
    (TEMPLATES_SRC / "index.html",    ".github/templates/index.html",       None),
    (TEMPLATES_SRC / "markdown.html", ".github/templates/markdown.html",    None),
    (TEMPLATES_SRC / "viewer.html",   ".github/templates/viewer.html",      None),
    (TEMPLATES_SRC / "styles.css",    ".github/templates/styles.css",       None),
    (SITE_SRC / "deploy-pages.yml",   ".github/workflows/deploy-pages.yml", None),
    (SITE_SRC / "build_site.py",      "tools/build_site.py",                None),
    (SITE_SRC / "Makefile",           "Makefile",                           "Makefile.site"),
]


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("target_dir", nargs="?", default=".",
                        help="Target repository directory (default: cwd)")
    parser.add_argument("--force", action="store_true",
                        help="Overwrite existing files instead of skipping them.")
    args = parser.parse_args()

    target = Path(args.target_dir).resolve()
    if not target.is_dir():
        print(f"error: {target} is not a directory", file=sys.stderr)
        return 2

    print(f"Scaffolding documentation site into {target}")
    print()

    write_count = skip_count = fallback_count = 0
    for src, dst_rel, fallback_rel in FILES:
        dst = target / dst_rel
        dst.parent.mkdir(parents=True, exist_ok=True)

        if dst.exists() and not args.force:
            if fallback_rel:
                fb = target / fallback_rel
                if fb.exists():
                    print(f"  skip   {dst_rel}  (and fallback {fallback_rel} exists)")
                    skip_count += 1
                else:
                    shutil.copy(src, fb)
                    print(f"  write  {fallback_rel}  (primary {dst_rel} exists)")
                    fallback_count += 1
            else:
                print(f"  skip   {dst_rel}")
                skip_count += 1
        else:
            shutil.copy(src, dst)
            verb = "force" if dst.exists() and args.force else "write"
            print(f"  {verb}  {dst_rel}")
            write_count += 1

    print()
    print(f"Summary: {write_count} written, {fallback_count} fallback, {skip_count} skipped")
    if fallback_count and not args.force:
        print()
        print("A Makefile already existed. The site targets were written to Makefile.site;")
        print("either add `include Makefile.site` near the top of your existing Makefile,")
        print("or run `python3 path/to/scaffold.py --force` to overwrite the Makefile.")

    print()
    print("Next steps:")
    print("  1. Edit tools/build_site.py — set SITE_TITLE, SITE_SLUG, SOURCE_URL, GITHUB_BASE,")
    print("     GROUP_TABS, SECTION_META, and DOC_REGISTRY.")
    print("  2. Adjust .github/workflows/deploy-pages.yml — set the publish branch (main / dev).")
    print("  3. Run: make install-deps && make build && make serve")
    print()
    return 0


if __name__ == "__main__":
    sys.exit(main())
