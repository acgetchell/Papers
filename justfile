set positional-arguments

rrt := "uv run --locked --no-sync --no-python-downloads research-repo-tools"
managed := rrt + " toolchain run --"
paper_rrt := rrt + " --root . --config tooling/papers.toml"
paper_managed := paper_rrt + " toolchain run --"
paper_source := "delaunay-validation/validation.tex"

# Generate the changelog from authorized commits with the shared tooling.
changelog:
    {{ managed }} research-repo-tools changelog generate

# Check active tooling, documentation, workflow policy, and pinned inputs.
check: lock-check justfile-check python-check toml-check markdown-check shell-check workflow-check workflow-allowlist-check paper-inputs-check typos-check

# Final tooling validation; paper compilation is a separate manual gate.
ci: check test

# Show the available commands when invoked without a recipe.
[default]
[private]
default: help

# Format active tooling and documentation explicitly.
fix:
    {{ rrt }} python fix
    just --fmt --unstable
    {{ managed }} taplo fmt pyproject.toml rust-toolchain.toml tooling/papers.toml delaunay-validation/inputs.toml typos.toml
    {{ managed }} rumdl fmt AGENTS.md CONTRIBUTING.md README.md SECURITY.md docs/BUILDING.md docs/SECURING.md delaunay-validation/README.md
    uv run --locked --no-sync shfmt -w scripts/*.sh

# List recipes and parameters in lexicographic order.
help:
    @just --justfile {{ quote(justfile()) }} --alias-style right --list

# Validate Just syntax and formatting without writing files.
justfile-check:
    just --fmt --check --unstable

# Verify that the committed lock agrees with the root manifest.
lock-check:
    uv lock --check --offline

# Check active Markdown; legacy manuscripts are outside this scope.
markdown-check:
    {{ managed }} rumdl check AGENTS.md CONTRIBUTING.md README.md SECURITY.md docs/BUILDING.md docs/SECURING.md delaunay-validation/README.md

# Build and compare with the retained reviewer PDF without refreshing it.
paper-artifact-check: paper-check
    {{ paper_rrt }} papers check --paper validation --reference delaunay-validation/validation.pdf

# Build the pilot manuscript from its checked local scientific inputs.
paper-build: paper-inputs-check
    {{ paper_rrt }} toolchain check
    bash scripts/build-paper.sh

# Compile selected standalone manuscripts and clean their generated output.
paper-build-all:
    uv run --locked --no-sync --no-python-downloads python scripts/build_changed_papers.py build --all

# Compile selected standalone manuscripts and clean their generated output.
paper-build-selected *sources:
    uv run --locked --no-sync --no-python-downloads python scripts/build_changed_papers.py build "$@"

# Check TeX, compile, and validate required PDF content without tracked writes.
paper-check: paper-tex-fmt-check paper-tex-lint paper-build && paper-pdf-check

# Remove only generated paper build output.
paper-clean:
    rm -rf target/papers

# Check the pinned scientific input inventory and SHA-256 hashes.
paper-inputs-check:
    uv run --locked --no-sync --no-python-downloads python scripts/check_paper_inputs.py

# Check the existing generated PDF without compiling it.
paper-pdf-check:
    {{ paper_rrt }} papers check --paper validation

# Deliberately refresh the tracked reviewer PDF after all paper checks pass.
paper-refresh: paper-check
    {{ paper_rrt }} papers normalize --paper validation --output delaunay-validation/validation.pdf

# Install optional TeX tools after provisioning documented native prerequisites.
paper-setup: setup
    #!/usr/bin/env bash
    set -euo pipefail
    export PATH="/Library/TeX/texbin:$PATH"
    uv sync --locked --managed-python --group dev --group papers
    native_environment="$({{ paper_rrt }} tectonic discover --format shell)"
    eval "$native_environment"
    {{ paper_rrt }} validation require chktex
    {{ paper_rrt }} toolchain sync

# Format only the configured active manuscript.
paper-tex-fmt:
    {{ paper_managed }} tex-fmt {{ paper_source }}

# Check active manuscript formatting without edits.
paper-tex-fmt-check:
    {{ paper_managed }} tex-fmt --check {{ paper_source }}

# Lint active TeX using the existing system ChkTeX installation.
paper-tex-lint:
    #!/usr/bin/env bash
    set -euo pipefail
    export PATH="/Library/TeX/texbin:$PATH"
    {{ paper_rrt }} validation require chktex
    # Match the source repository: 24 conflicts with tex-fmt's figure labels.
    chktex -q -n 1 -n 8 -n 24 -n 46 {{ paper_source }}

# Check the complete Python inventory with inherited Ruff and ty versions.
python-check:
    {{ rrt }} python check

# Scan dependencies and reachable Git history using the shared managed scanners.
security: security-osv security-secrets

# Scan the root lockfile with the managed shared OSV command.
security-osv:
    {{ rrt }} security osv uv.lock

# Scan reachable Git history and current inputs with managed Gitleaks.
security-secrets *args:
    {{ rrt }} security secrets "$@"

# Audit workflow security with explicit offline or required-online settings.
security-workflows *args:
    {{ rrt }} zizmor check "$@"

# Install the declared base tools and synchronize the root environment.
setup:
    uv run --locked --managed-python --only-group tooling research-repo-tools setup

# Check shell syntax, formatting, and ShellCheck diagnostics.
shell-check:
    bash -n scripts/build-paper.sh scripts/ci-paper-setup.sh scripts/ci-paper-warmup.sh
    uv run --locked --no-sync shfmt -d scripts/*.sh
    uv run --locked --no-sync shellcheck scripts/*.sh

# Preview a shared-package upgrade and its inherited Python mirrors.
shared-python-plan version:
    uv run --no-config --no-project --isolated --managed-python --script tooling/python-bootstrap.py "$1" --dry-run

# Deliberately adopt a published shared-package release and its Python baseline.
shared-python-update version:
    uv run --no-config --no-project --isolated --managed-python --script tooling/python-bootstrap.py "$1" --apply

# Discover existing native TeX libraries through the shared implementation.
tectonic +args:
    {{ paper_rrt }} tectonic "$@"

# Run manuscript policy and integration tests in the root environment.
test:
    uv run --locked --no-sync --no-python-downloads --group papers pytest tests/papers

# Check active TOML declarations with managed Taplo.
toml-check:
    {{ managed }} taplo fmt --check pyproject.toml rust-toolchain.toml tooling/papers.toml delaunay-validation/inputs.toml typos.toml

# Check all declared base tool versions without installation.
tools-check:
    {{ rrt }} toolchain check

# Export verified managed tool paths for GitHub Actions.
tools-export:
    {{ rrt }} toolchain export

# Check spelling in active tooling and guidance, excluding stored manuscripts.
typos-check:
    {{ managed }} typos AGENTS.md CONTRIBUTING.md README.md SECURITY.md docs/BUILDING.md docs/SECURING.md delaunay-validation/README.md scripts tests

# Deliberately update Python declarations and the shared root lockfile.
update-python-dependencies:
    {{ rrt }} deps update-python --all-projects

# Deliberately upgrade declared native tools and their pins.
update-tools:
    {{ rrt }} toolchain upgrade

# Require every external action to match the committed selected-actions policy.
workflow-allowlist-check:
    {{ rrt }} actions allowlist --policy .github/settings/actions-selected.json .github/workflows

# Validate workflow syntax, YAML policy, and pinned-action security.
workflow-check:
    uv run --locked --no-sync actionlint
    uv run --locked --no-sync yamllint .github .coderabbit.yaml .yamllint.yml
    {{ rrt }} zizmor check --offline
