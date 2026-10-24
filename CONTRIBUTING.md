# Contributing

Use the root environment and [README setup](README.md#quickstart). Python 3.15,
uv, Rust, and managed tools follow the declarations in `.python-version`,
`pyproject.toml`, `rust-toolchain.toml`, and `tooling/papers.toml`. The published
shared package owns the Python minimum and development baseline; local Python
selectors, project metadata, and Ruff targets are validated mirrors. Ruff, ty,
and pytest also inherit their exact versions from that package.

## Validation

```sh
just check
just test
```

`check` validates the lock, Just, Python formatting/lint/types, TOML, Markdown,
shell scripts, spelling, workflow YAML, Actions security, and pinned manuscript inputs.
`test` runs the consumer integration tests under `tests/papers/`. Use `just ci`
once for final validation; it composes both gates. Ordinary tooling checks and
tooling CI do not install or invoke TeX tools, compile manuscripts, or execute notebooks.

Paper changes also require:

```sh
just paper-artifact-check
```

Inspect the rebuilt PDF visually. Structural comparison checks page text and
geometry; it does not prove identical rendering or scientific correctness.
The separate Papers workflow builds affected manuscripts on PRs and pushes to
`main`; manual dispatch builds every available standalone TeX source. The pilot
also receives the retained-artifact comparison. Every generated paper build
directory is removed on success or failure; the workflow uploads no LaTeX
artifacts and never refreshes tracked reviewer PDFs.
Selected legacy sources receive advisory ChkTeX checks. ChkTeX findings and
overfull/underfull box warnings appear in the build log and CI job summary;
layout warnings remain advisory for every paper. The pilot retains its existing
ChkTeX policy. Missing tools, failed checks, and compilation errors still fail
the build.

## Explicit writes

`just fix` formats active tooling and documentation. `just paper-tex-fmt`
formats only the configured active manuscript. `just paper-refresh` deliberately
replaces its reviewer PDF after the paper checks pass. These commands never
rewrite the older archived manuscripts. Reproduction and input updates are
documented in [BUILDING](docs/BUILDING.md).

Use `just update-python-dependencies` for deliberate dependency maintenance and
`just update-tools` for declared native-tool updates. Review the resulting pins
and lockfile. Do not edit generated locks or changelogs manually.

When upgrading `research-repo-tools`, preview `just shared-python-plan VERSION`
and apply `just shared-python-update VERSION`. The exported shared bootstrap
selects a compatible interpreter from the target release's published metadata,
then delegates adoption of the Python mirrors and tool versions to that release.
Do not choose or upgrade the Python baseline independently.

## Security

Run `just security` to compose the root lockfile and full-history/current-input
scans, or select `just security-osv` and `just security-secrets` individually.
They use the shared managed scanners. Use `just security-workflows --require-online`
for authenticated workflow-security auditing.
Workflows use read-only repository permissions and pinned external actions.
Dependabot proposes Python and Actions updates; maintainers review them before
merging. CodeRabbit is configured for automatic PR and incremental review,
including drafts, and approves after its findings are addressed and the latest
commit is reviewed. GitHub native auto-merge can be enabled per ready PR; it
waits for the required approval, resolved threads, CI/security checks, and
successful LaTeX compilation of affected papers. PRs with no affected papers
pass the paper gate without compilation. Other external review services require
a separate request.
See [SECURING](docs/SECURING.md) for live setting ownership, required checks,
and the administrator bypass inherited from Delaunay's policy.

## Changes

Preserve author-owned prose and attribution. Keep common tooling in
`research-repo-tools`; consumer tests should cover manuscript policy and input
integrity. Use conventional commit subjects and focused branches such as
`build/reproducible-paper-builds`. Keep Git changes scoped to the work the
maintainer authorized. Record validation in the change description, not a
parallel permanent validation log.
