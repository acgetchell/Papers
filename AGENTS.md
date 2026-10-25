# Working in Papers

Read [CONTRIBUTING.md](CONTRIBUTING.md) before changing tooling and
[docs/BUILDING.md](docs/BUILDING.md) before changing paper builds or inputs.

- Preserve author-owned manuscript prose, claims, captions, attribution, and
  existing TODOs. Mechanical TeX, bibliography, figure-path, and build changes
  are allowed; substantive publication prose belongs to the author.
- Keep each manuscript in its own root directory, with versions of the same
  paper together. Preserve stored manuscripts and their inputs; active builds
  cover only explicitly configured manuscripts.
- Use one root Python environment, `pyproject.toml`, `uv.lock`, and Just entry
  point. Reuse the exact published `research-repo-tools` package for common
  tooling. Do not introduce per-paper environments or generic fetching systems.
- Inherit Python and Python tool versions from the published shared package.
  Local selectors and metadata are checked mirrors, not independent pins. Use
  the shared adoption workflow when changing that package's baseline.
- Keep scientific experiments, rendering code, notebooks, and canonical figures
  in their software repository. Compile only the checked, pinned local inputs.
- Check/build commands must preserve tracked files. Refresh reviewer PDFs only
  through `just paper-refresh` when that refresh is explicitly requested.
- Use patch editing for manual source changes. Preserve unrelated user edits.
- Run `just check` during development and `just ci` for final tooling validation.
  Paper CI compiles changed standalone LaTeX manuscripts and shared-input
  consumers, then removes generated output even on failure. Manual dispatch
  builds all available TeX sources. Pilot changes also require
  `just paper-artifact-check` and visual inspection of the rebuilt PDF.
- Do not run CodeRabbit or send repository content to external review services
  without the maintainer's explicit request.
- Git mutations require maintainer authorization. Follow established branch
  names, otherwise use `<type>/<short-kebab-description>` without agent prefixes.
- Keep README focused on navigation and quickstart; CONTRIBUTING owns contributor
  checks; BUILDING owns reproduction and deliberate input updates. Sort command
  definitions and reference tables lexicographically.
