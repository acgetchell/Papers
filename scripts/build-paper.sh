#!/usr/bin/env bash
# Compile only the pilot manuscript; scientific inputs are already local.
set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

rrt() {
	uv run --locked --no-sync --no-python-downloads research-repo-tools \
		--root . --config tooling/papers.toml "$@"
}

source_path="delaunay-validation/validation.tex"
build_dir="target/papers/delaunay-validation"
rm -rf "$build_dir"
mkdir -p "$build_dir"
source_date_epoch="$(rrt papers source-date --paper validation)"
export SOURCE_DATE_EPOCH="$source_date_epoch"
rrt toolchain run -- tectonic --untrusted --keep-intermediates --keep-logs \
	--outdir "$build_dir" "$source_path"

test -s "$build_dir/validation.log"

if grep -Eiq 'LaTeX Warning: (Citation|Reference).*undefined|There were undefined (references|citations)|There were multiply-defined labels' \
	"$build_dir/validation.log"; then
	echo "Unresolved citations, references, or duplicate labels in the paper build." >&2
	exit 1
fi

rrt papers normalize --paper validation
