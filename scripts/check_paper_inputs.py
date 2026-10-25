"""Verify the Delaunay pilot's frozen figure inputs without fetching or rendering."""

import hashlib
import re
import sys
import tomllib
from pathlib import Path, PurePosixPath

PAPER = Path(__file__).resolve().parents[1] / "delaunay-validation"
FIGURES = frozenset(
    {
        "validation_hierarchy.png",
        "validation_level_1_element_validity.png",
        "validation_level_2_combinatorial_consistency.png",
        "validation_level_3_intrinsic_pl_topology.png",
        "validation_level_4_valid_realization.png",
        "validation_level_5_geometric_predicates.png",
    }
)


def check_inputs(paper: Path) -> None:
    """Reject missing, altered, unrecorded, or incorrectly referenced figures."""
    manifest = tomllib.loads((paper / "inputs.toml").read_text(encoding="utf-8"))
    source = manifest["source"]
    if manifest["schema"] != 1 or source["repository"] != "https://github.com/acgetchell/delaunay":
        raise ValueError("Expected the Delaunay pilot provenance schema")
    if not re.fullmatch(r"[0-9a-f]{40}", source["commit"]):
        raise ValueError("Scientific source must name a full Git commit SHA")
    recorded: set[str] = set()
    for entry in manifest["figures"]:
        name = PurePosixPath(entry["path"]).name
        if name not in FIGURES or entry["path"] != f"figures/{name}" or name in recorded:
            raise ValueError(f"Invalid or duplicate figure path: {entry['path']}")
        if entry["upstream"] != f"docs/assets/validation/{name}":
            raise ValueError(f"Unexpected canonical source path: {entry['upstream']}")
        path = paper / "figures" / name
        if path.is_symlink() or not path.is_file():
            raise ValueError(f"Missing regular figure input: {name}")
        if not re.fullmatch(r"[0-9a-f]{64}", entry["sha256"]) or hashlib.sha256(path.read_bytes()).hexdigest() != entry["sha256"]:
            raise ValueError(f"Figure SHA-256 mismatch: {name}")
        recorded.add(name)
    if recorded != FIGURES or {path.name for path in (paper / "figures").iterdir()} != FIGURES:
        raise ValueError("Figure inventory must contain exactly the six recorded Delaunay inputs")
    tex = (paper / "validation.tex").read_text(encoding="utf-8")
    references = re.findall(r"\\includegraphics(?:\[[^]]*\])?\s*\{([^}]+)\}", tex)
    if set(references) != {f"figures/{name}" for name in FIGURES}:
        raise ValueError("TeX must reference the six local pinned figures")


def main() -> int:
    """Report an input error without changing the checkout."""
    try:
        check_inputs(PAPER)
    except (OSError, ValueError, KeyError, TypeError) as error:
        print(f"Paper input check failed: {error}", file=sys.stderr)
        return 1
    print("Verified six pinned Delaunay figure inputs; no downloads or experiments.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
