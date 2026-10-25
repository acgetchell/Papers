# Delaunay validation manuscript

This directory holds the active TeX source, paper-local bibliography, retained
reviewer PDF, and pinned scientific figure inputs migrated from
[Delaunay](https://github.com/acgetchell/delaunay).

## Source identity

- Scientific input revision:
  [`e365c531ea157469c0f8767153e75d0ac6db920e`](https://github.com/acgetchell/delaunay/tree/e365c531ea157469c0f8767153e75d0ac6db920e).
- Crate version at that revision: `0.8.2`; the revision is 17 commits after
  the `v0.8.2` release commit
  [`1892b823c4600b56f9720517ed34dad4b155fb0f`](https://github.com/acgetchell/delaunay/tree/1892b823c4600b56f9720517ed34dad4b155fb0f).
  It is not the released `v0.8.2` source tree.
- [Original manuscript](https://github.com/acgetchell/delaunay/blob/e365c531ea157469c0f8767153e75d0ac6db920e/papers/validation.tex),
  [bibliography](https://github.com/acgetchell/delaunay/blob/e365c531ea157469c0f8767153e75d0ac6db920e/papers/validation.bib),
  and [reviewer copy](https://github.com/acgetchell/delaunay/blob/e365c531ea157469c0f8767153e75d0ac6db920e/papers/validation.pdf).
- [Figure notebook](https://github.com/acgetchell/delaunay/blob/e365c531ea157469c0f8767153e75d0ac6db920e/notebooks/01_validation.ipynb)
  and [renderer](https://github.com/acgetchell/delaunay/blob/e365c531ea157469c0f8767153e75d0ac6db920e/tooling/python/notebook_validation_rendering.py)
  remain owned by Delaunay.
- The [provenance manifest](inputs.toml) records the exact upstream figure paths,
  SHA-256 hashes, and initial manuscript/BibTeX/PDF hashes. The six PNG images in
  `figures/` are exact snapshots of the canonical Delaunay Git blobs.
- The [upstream license](LICENSE.delaunay) is retained with these inputs.

The migration preserves manuscript prose, author TODOs, citations, and
attribution. Its only TeX edits change the six figure paths to local snapshots.
The bibliography and retained reviewer PDF are copied byte-for-byte. The
original PDF-normalization identity remains `papers/validation.tex`.

## Reproduction

Run these commands from anywhere within this repository after
[setup](../docs/BUILDING.md#prerequisites):

```sh
just paper-artifact-check
```

Output is written to `target/papers/delaunay-validation/validation.pdf`.
The tracked [reviewer copy](validation.pdf) is not replaced by build or check
commands. See [BUILDING](../docs/BUILDING.md) for deliberate input updates and
reviewer refreshes.

The historical
[v0.8.0 reviewer artifact guide](https://github.com/acgetchell/delaunay/blob/ee0b1992071552ecf8669418ea74444a699343a9/papers/ARTIFACT.md)
and its release evidence retain their original Delaunay ownership and links.
