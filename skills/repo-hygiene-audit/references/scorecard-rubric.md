# Scorecard Rubric

Use this rubric for a beginner-friendly audit. Prefer evidence over opinion.

## Required Areas

| Area | Pass | Warn | Fail |
|---|---|---|---|
| README | Explains purpose, install/setup, basic usage, and verification | Purpose is clear but setup or examples are incomplete | Missing, stale, or too vague to start |
| License | Public repos have a clear license | License unclear for private/internal reuse | Public repo has no license |
| Setup | Dependencies and bootstrap steps are documented | Steps exist but depend on tribal knowledge | No visible setup path |
| Tests | Test command and test files are visible | Tests exist but command is unclear or slow | No visible test strategy |
| CI | CI runs build/lint/test or equivalent | CI exists but misses key checks | No CI for collaborative repo |
| Formatting and linting | Tooling and commands are visible | Tooling exists but is undocumented | No visible style enforcement |
| Docs and examples | Docs/examples support common workflows | Docs exist but are stale or sparse | No docs beyond code |
| Project layout | Top-level files are understandable | Some clutter or ambiguous folders | Generated/private artifacts obscure source |
| Dependency hygiene | Lockfiles or version pins match ecosystem norms | Some dependency drift risk | Unpinned or unreproducible dependencies |
| Security basics | No obvious secrets; security policy or process exists when relevant | No policy but risk is low | Secrets, credentials, or sensitive files appear committed |
| Contribution path | Issues, PRs, or contribution docs explain collaboration | Ad hoc contribution flow | No visible way to propose changes |
| Release/versioning | Tags, changelog, release workflow, or version files are visible when needed | Versioning exists but is inconsistent | Users cannot tell what is released |

## Status Rules

Use `Pass` only when evidence is visible. Do not assume.

Use `Warn` when a beginner could proceed but would likely ask a maintainer.

Use `Fail` when a beginner would be blocked, misled, or likely to damage the repo.

Use `Not visible` when the repo may have a process outside local files.

## Verification

Run cheap commands only when obvious:

- `make help`, `make test`, `make check`
- `npm test`, `npm run lint`, `npm run build`
- `cargo test`, `cargo clippy`, `cargo fmt --check`
- `pytest`, `ruff check`, `mypy`

If a command is expensive, destructive, network-heavy, or undocumented, do not run it by default. Mark the command as a recommended check.

## Report Tone

Write for beginners. Explain why each issue matters in one sentence.

Avoid shaming language. Use direct wording:

- Good: "Add a documented test command so new contributors can verify changes."
- Bad: "The test setup is bad."
