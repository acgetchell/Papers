# Papers

Active manuscripts and reproducible paper production for the Rust research
projects. The default branch is `main`.

## Manuscripts

| Manuscript | Source and build inputs | Reviewer copy |
| --- | --- | --- |
| Delaunay validation | [Project notes](delaunay-validation/README.md) | [PDF](delaunay-validation/validation.pdf) |

Each paper has a directory at the repository root. Versions and related drafts
of the same paper stay together. The stored manuscripts below are outside the
automatic formatting scope; their existing filenames, prose, and PDF
bytes are preserved. Legacy TeX received mechanical encoding and bibliography
fixes so the existing sources compile with the pinned toolchain.

| Stored manuscript | Directory |
| --- | --- |
| Agent-based modeling | [agent-based-modeling](agent-based-modeling/) |
| CDT Newtonian limit, including the DataScience copy | [cdt-newtonian-limit](cdt-newtonian-limit/) |
| CDT survey | [cdt-survey](cdt-survey/) |
| Efficient CDT, with its existing figures | [efficient-cdt](efficient-cdt/) |
| Higgs search | [higgs](higgs/) |
| LIGO | [ligo](ligo/) |
| Local and global flatness | [local-global-flatness](local-global-flatness/) |
| Newtonian derivation, versions and oral-exam draft | [newtonian-derivation-cdt](newtonian-derivation-cdt/) |
| Orion's Arm wormholes | [orions-arm-wormholes](orions-arm-wormholes/) |
| Traversable wormholes | [traversable-wormholes](traversable-wormholes/) |
| Weyl metric, figures, and symbolic calculations | [weyl-metric-calculations](weyl-metric-calculations/) |

The [original catalog](docs/legacy-catalog.txt) is retained verbatim as a
historical note. Unassigned exported bibliography/style assets live under
`shared/bibliography/`. The existing Newtonian bibliographies each have one
owner and are referenced relatively by the other manuscripts that use them.
Available standalone LaTeX sources are compiled when their paper or a shared
input changes. PDF-only records have no LaTeX source to build in this repository.

## Quickstart

Install the uv version declared in [pyproject.toml](pyproject.toml), then
bootstrap the shared tooling from the repository root:

```sh
uv run --locked --managed-python --only-group tooling research-repo-tools setup
just
```

Setup installs the declared tools and a user-level Just command. Open a new
terminal if setup changes PATH. No environment activation is needed.

For manuscript production, provision the [native prerequisites](docs/BUILDING.md#prerequisites),
then run:

```sh
just paper-setup
just paper-artifact-check
```

The build writes to `target/papers/` and preserves the retained reviewer copy.
See [reproduction and input updates](docs/BUILDING.md) and
[contributor checks](CONTRIBUTING.md). Scientific notebooks and canonical
figures remain in their software repositories.

PRs receive CodeRabbit review, tooling and security checks, and affected-paper
LaTeX builds. Build output is removed afterward. The full paper build remains
available through manual dispatch. See [repository protections](docs/SECURING.md)
and the separate [blog publishing issue](https://github.com/acgetchell/Papers/issues/2).
