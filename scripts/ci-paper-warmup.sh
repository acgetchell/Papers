#!/usr/bin/env bash
# Retry only typesetting-bundle acquisition, never scientific input generation.
set -euo pipefail

warmup_dir="$RUNNER_TEMP/tectonic-warmup"
mkdir -p "$warmup_dir"
printf '%s\n' '\documentclass{article}' '\begin{document}' \
	'Tectonic bundle cache warmup.' '\end{document}' >"$warmup_dir/warmup.tex"

for attempt in 1 2 3 4; do
	if uv run --locked --no-sync research-repo-tools --root . --config tooling/papers.toml \
		toolchain run -- tectonic --outdir "$warmup_dir" "$warmup_dir/warmup.tex"; then
		exit 0
	fi
	if [[ "$attempt" -eq 4 ]]; then
		echo "::error::Unable to warm Tectonic's bundle cache after $attempt attempts."
		exit 1
	fi
	sleep "$((attempt * 15))"
done
