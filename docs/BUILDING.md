# Building papers

All commands run through the root Justfile and the single root Python
environment and lockfile. The Delaunay validation manuscript is the initial
reproducible pilot. All nine available standalone TeX sources can also be built.
Stored PDF-only papers remain reference documents because their source is not
present here.

## Prerequisites

Complete the [root setup](../README.md#quickstart). Paper tools are a separate
opt-in configuration in `tooling/papers.toml`, sharing the root Rust and Python
selectors. That configuration pins Tectonic and tex-fmt. Install ChkTeX using a
TeX distribution or system package manager.

- macOS: Xcode Command Line Tools and
  `brew install freetype graphite2 icu4c libpng pkgconf zlib`. Existing
  MacTeX/BasicTeX tools are discovered at `/Library/TeX/texbin`.
- Linux: a native C/C++ build toolchain, pkg-config, and development packages for
  fontconfig, FreeType, Graphite2/HarfBuzz, ICU, libpng, OpenSSL, and zlib.
- Windows MSVC: Visual Studio C++ Build Tools, a Windows SDK, Git for Windows
  with POSIX `sh` on PATH, and the corresponding vcpkg libraries. Set
  `TECTONIC_DEP_BACKEND=vcpkg`, `VCPKG_ROOT`, and `VCPKGRS_TRIPLET`.

CI typesetting uses macOS. Linux and Windows native paper builds are not
currently CI acceptance targets.

```sh
just paper-setup
just paper-artifact-check
```

Setup discovers installed native libraries through the shared tooling before
installing the declared Cargo tools. Tectonic may download its TeX bundle on
the first build; that is a typesetting dependency, not scientific input. Figure
inputs are always the checked local snapshots; builds never fetch them or run
scientific experiments.

## Commands

| Command | Effect |
| --- | --- |
| `just paper-artifact-check` | Run paper checks and compare the result with the retained reviewer PDF |
| `just paper-build` | Verify pinned figures, compile into `target/papers/delaunay-validation/`, normalize metadata, and reject unresolved references |
| `just paper-build-all` | Compile every standalone TeX source and clean each generated build directory |
| `just paper-build-selected SOURCE...` | Compile selected root-relative TeX sources and clean their output even on failure |
| `just paper-check` | Check TeX formatting/lint, compile, and check required PDF text and structure |
| `just paper-clean` | Remove only generated paper build output |
| `just paper-inputs-check` | Verify the pinned commit metadata, complete figure inventory, and SHA-256 hashes |
| `just paper-pdf-check` | Check the existing generated PDF without compiling |
| `just paper-refresh` | Run checks and deliberately replace the tracked reviewer PDF |
| `just paper-setup` | Install optional typesetting tools using the root environment |
| `just paper-tex-fmt` | Format the active TeX source |
| `just paper-tex-fmt-check` | Check active TeX formatting without edits |
| `just paper-tex-lint` | Lint the active TeX source with ChkTeX |

The source's explicit date supplies `SOURCE_DATE_EPOCH`. Shared PDF normalization
retains the original stable identity `papers/validation.tex` across the migration.
It normalizes volatile XMP identifiers and timestamps and PDF trailer IDs.
`paper-artifact-check` checks per-page text and geometry against the retained
reviewer copy. Inspect rendering separately before any deliberate refresh.

## Changed-paper CI

The Papers workflow runs on PRs and pushes to `main`. Selection uses exact Git
event revisions and the shared safe file inventory. A change anywhere within a
paper directory rebuilds that paper's standalone source variants. Changes to
explicit shared bibliographies also rebuild their consumers. Changes to the
paper toolchain or build scripts rebuild all standalone TeX sources.

Manual workflow dispatch builds all available sources. PDF-only directories
have no source to compile. No scientific notebook is executed. The pilot keeps
its shared explicit date, normalization, and reviewer comparison. Legacy sources
with empty dates, `\\today`, or no date retain that author-owned source and use
the source commit timestamp for `SOURCE_DATE_EPOCH` during compile checks.

All compiler writes go under `target/papers/`. The changed-paper command removes
each generated directory through a `finally` block, and the workflow runs
`just paper-clean` under `if: always()` as a final cleanup. Generated PDFs, logs,
and auxiliary files are not uploaded or committed. The granular pilot commands
retain local output temporarily for visual inspection; run `just paper-clean`
afterward.

## Updating pinned inputs

The [manuscript notes](../delaunay-validation/README.md) link to the exact
scientific source revision and provenance manifest. The copied figure files are
immutable build inputs from Delaunay; its notebook, renderer, scientific
contracts, and documentation assets remain canonical in that repository.

To update them deliberately:

1. Choose and record a full Delaunay commit SHA, its Cargo version, and the
   associated release tag and tag commit. Note when the revision is after a
   release; never describe an unreleased revision as that release's evidence.
2. Verify the chosen revision and scientific figures in Delaunay using that
   repository's own validation procedure. Do not run experiments from Papers.
3. Copy only the six required `docs/assets/validation/*.png` Git blobs from that
   revision into this manuscript's `figures/`. Update `inputs.toml` with each
   exact upstream path and SHA-256 digest and the source revision. Retain
   Delaunay's license and attribution. Review the changed images and metadata.
4. Run `just ci` and `just paper-artifact-check`. Inspect any changed text,
   geometry, references, and rendering. A deliberate manuscript revision may
   correctly fail comparison with the older reviewer copy; resolve the
   discrepancy before requesting a refresh.
5. When the reviewer refresh is authorized, run `just paper-refresh`, inspect
   that PDF, and rerun `just paper-artifact-check`. Commit source, input
   provenance, figure snapshots, and approved reviewer changes together.

No command automatically selects a newer software revision or updates hashes.
Initial manuscript/BibTeX/reviewer hashes in the manifest record migration
provenance; only the scientific figure hashes are immutable build constraints.

## Delaunay migration order

First verify this local build and the manual Papers CI build. Only then update
Delaunay's active manuscript links and remove its superseded paper sources,
paper-only tools, recipes, tests, and CI. Preserve its root Python environment,
scientific notebooks, canonical figures, historical v0.8.0 artifact guide,
immutable release records, and version-specific links. Historical evidence
continues to belong to the repository and revision that produced it.
