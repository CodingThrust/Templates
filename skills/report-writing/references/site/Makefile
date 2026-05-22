.PHONY: all build serve serve-only clean watch help install-deps

# Output directory for the rendered site.
SITE_DIR := _site

# Python interpreter for the build script. CI installs deps via `make install-deps`.
PY := python3

all: build

# Build the site (PDFs from Typst sources + HTML viewers + rendered markdown + index).
build:
	@$(PY) tools/build_site.py

# Install Python deps used by the build script.
# CI runs this; for local dev, `pip install markdown pymdown-extensions` also works.
install-deps:
	@$(PY) -m pip install --quiet --user markdown pymdown-extensions

# Serve locally on http://localhost:8000 (rebuilds first).
serve: build
	@echo "🌐 Serving $(SITE_DIR)/ at http://localhost:8000"
	@echo "   Press Ctrl+C to stop"
	@cd $(SITE_DIR) && $(PY) -m http.server 8000

# Serve without rebuilding (useful after manual edits inside _site/).
serve-only:
	@echo "🌐 Serving $(SITE_DIR)/ at http://localhost:8000"
	@echo "   Press Ctrl+C to stop"
	@cd $(SITE_DIR) && $(PY) -m http.server 8000

# Remove build artifacts.
clean:
	@echo "🧹 Removing $(SITE_DIR)/"
	@rm -rf $(SITE_DIR)

# Rebuild whenever a source file changes (requires `entr`).
watch:
	@echo "👀 Watching for changes (requires entr)…"
	@while true; do \
		find . \( -path ./$(SITE_DIR) -o -path ./.git \) -prune -o \
			\( -name '*.typ' -o -name '*.md' -o -name '*.css' -o -name '*.html' -o -name '*.py' \) -print \
		| entr -d $(MAKE) build; \
	done

help:
	@echo "Documentation site — local development"
	@echo ""
	@echo "  make build         Build the site into $(SITE_DIR)/"
	@echo "  make serve         Build and serve at http://localhost:8000"
	@echo "  make serve-only    Serve without rebuilding"
	@echo "  make watch         Rebuild on file changes (requires entr)"
	@echo "  make clean         Remove $(SITE_DIR)/"
	@echo "  make install-deps  Install Python deps for the build script"
	@echo ""
	@echo "Requirements:"
	@echo "  - typst        (compiles Typst design docs to PDF)"
	@echo "  - python3      (build script + local server)"
	@echo "  - markdown + pymdown-extensions  (pip; see install-deps)"
	@echo "  - entr         (optional; for 'make watch')"
