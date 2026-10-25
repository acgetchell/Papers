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

### Merge requirements

The stable `Changed paper builds` result is a required merge check, including
for native auto-merge. It fails on selection or compilation failure. When no
paper is affected it passes without compiling; the remaining required reviews,
CI, and security checks still apply.

The CodeQL Actions and Python analysis jobs are required. Hosted code-scanning
protection also blocks CodeQL error-level alerts and high or critical security
alerts; a successful analysis job alone does not mean its findings are accepted.

The hosted ruleset requires CODEOWNER approval for `.coderabbit.yaml`,
`.coderabbit.yml`, and GitHub controls, including CODEOWNERS, settings snapshots,
and the Dependabot approval workflow. Exact routine workflow and setup-action
paths are exempted in [CODEOWNERS](.github/CODEOWNERS), allowing verified
Dependabot approvals to satisfy the normal one-approval rule. Ordinary workflow
PRs still need manual review because CodeRabbit automatic approval is disabled
for `.github/**` and the shared approval job only accepts verified Dependabot PRs.
Paper files have no human ownership requirement, so eligible paper PRs can still
receive CodeRabbit approval and use native auto-merge. GitHub evaluates ownership
from the base branch; a PR cannot remove its own required owner by editing the file.

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
Gitleaks, OSV, and zizmor use the lightweight `security` dependency group and
the shared verified binary installer. Their CI setup does not install Cargo
tools or paper dependencies. Full tooling and paper jobs keep their existing
setup profile.

Workflows use read-only permissions by default and pinned external actions.
Dependabot proposes Actions updates. The pinned shared approval workflow
verifies Dependabot identity, signed commits, exact changed-file policy, and
the current head before approving and enabling native auto-merge. Required
checks and resolved threads still apply. Routine dependency-update paths accept
that approval; changes to owned policy files still require human CODEOWNER review.

Hosted uv updates are paused because Dependabot rejects the inherited Python
3.15 baseline. Use `just update-python-dependencies` and `just ci` for Python
maintenance, and the shared adoption commands for shared-package upgrades.
Keep the dependency graph, security alerts, and OSV scans enabled. Graph-update
jobs may still report the same upstream limitation. Restore uv updates after
[Python 3.15 support](https://github.com/dependabot/dependabot-core/issues/16524)
is available; do not lower the inherited baseline to accommodate the updater.

CodeRabbit is configured for automatic PR and incremental review,
including drafts, and approves eligible low merge-risk PRs after its findings
are addressed and the latest commit is reviewed. Automatic approval is disabled
for PRs changing `.github/**`; the hosted CODEOWNER rule also protects approval
configuration independently of CodeRabbit's settings.
GitHub native auto-merge can be enabled per ready PR; it
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
