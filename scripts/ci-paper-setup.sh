#!/usr/bin/env bash
# Native prerequisites belong only to the manually dispatched paper build.
set -euo pipefail

brew install freetype graphite2 icu4c libpng pkgconf zlib
export PATH="/Library/TeX/texbin:$PATH"
echo "/Library/TeX/texbin" >>"$GITHUB_PATH"
if ! command -v chktex >/dev/null; then
	if ! command -v tlmgr >/dev/null; then
		brew install --cask basictex
	fi
	texlive_repository="https://ctan.math.illinois.edu/systems/texlive/tlnet"
	tlmgr_path="$(command -v tlmgr)"
	sudo "$tlmgr_path" --repository "$texlive_repository" update --self
	sudo "$tlmgr_path" --repository "$texlive_repository" install chktex
fi
just paper-setup
