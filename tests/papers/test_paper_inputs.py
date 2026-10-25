"""Consumer regressions for frozen scientific inputs and migration boundaries."""

import importlib.util
import re
import shutil
import sys
from importlib.resources import files
from pathlib import Path

import pytest
import yaml
from research_repo_tools.config import load
from research_repo_tools.paper_dates import read_source_date
from research_repo_tools.process import run_command
from research_repo_tools.toolchain_config import load as load_toolchain

ROOT = Path(__file__).resolve().parents[2]
PAPER = ROOT / "delaunay-validation"
spec = importlib.util.spec_from_file_location("check_paper_inputs", ROOT / "scripts/check_paper_inputs.py")
assert spec is not None and spec.loader is not None
inputs = importlib.util.module_from_spec(spec)
spec.loader.exec_module(inputs)


@pytest.fixture
def copied_paper(tmp_path: Path) -> Path:
    """Supply isolated real input files for corruption regressions."""
    return Path(shutil.copytree(PAPER, tmp_path / "paper"))


def test_pinned_inputs_are_complete() -> None:
    inputs.check_inputs(PAPER)


def test_python_bootstrap_is_the_published_shared_template() -> None:
    expected = files("research_repo_tools").joinpath("templates/python-bootstrap.py").read_bytes()
    assert (ROOT / "tooling/python-bootstrap.py").read_bytes() == expected


def test_corrupted_figure_fails_without_repair(copied_paper: Path) -> None:
    path = copied_paper / "figures/validation_hierarchy.png"
    payload = path.read_bytes() + b"corruption"
    path.write_bytes(payload)
    with pytest.raises(ValueError, match="SHA-256 mismatch"):
        inputs.check_inputs(copied_paper)
    assert path.read_bytes() == payload


def test_missing_figure_fails(copied_paper: Path) -> None:
    (copied_paper / "figures/validation_hierarchy.png").unlink()
    with pytest.raises(ValueError, match="Missing regular figure"):
        inputs.check_inputs(copied_paper)


def test_unrecorded_input_fails(copied_paper: Path) -> None:
    (copied_paper / "figures/newer-science.png").write_bytes(b"unrecorded")
    with pytest.raises(ValueError, match="exactly the six recorded"):
        inputs.check_inputs(copied_paper)


def test_path_outside_pinned_inputs_fails(copied_paper: Path) -> None:
    path = copied_paper / "validation.tex"
    path.write_bytes(path.read_bytes().replace(b"figures/validation_hierarchy.png", b"../newer-checkout/validation_hierarchy.png"))
    with pytest.raises(ValueError, match="six local pinned figures"):
        inputs.check_inputs(copied_paper)


def test_duplicate_manifest_entry_fails(copied_paper: Path) -> None:
    path = copied_paper / "inputs.toml"
    payload = path.read_bytes()
    path.write_bytes(payload + b"\n[[figures]]" + payload.split(b"[[figures]]")[1])
    with pytest.raises(ValueError, match="duplicate figure"):
        inputs.check_inputs(copied_paper)


def test_optional_paper_tools_share_root_selectors() -> None:
    base = load_toolchain(load(root=ROOT))
    paper = load_toolchain(load(ROOT / "tooling/papers.toml", root=ROOT))
    assert paper.root == base.root == ROOT
    assert paper.python_request == base.python_request
    assert paper.rust == base.rust
    assert {tool.package for tool in paper.cargo} == {"tectonic", "tex-fmt"}
    assert not {tool.package for tool in base.cargo} & {"tectonic", "tex-fmt"}
    assert read_source_date(PAPER / "validation.tex").raw == "July 6, 2026"


def test_paper_ci_builds_changed_sources_and_always_cleans() -> None:
    workflow = yaml.safe_load((ROOT / ".github/workflows/papers.yml").read_text(encoding="utf-8"))
    assert set(workflow[True]) == {"workflow_dispatch", "pull_request", "push"}
    steps = workflow["jobs"]["compile"]["steps"]
    assert any(step.get("run") == "just paper-build-selected" for step in steps)
    assert any(step.get("run") == "just paper-clean" and step.get("if") == "always()" for step in steps)
    assert not any("upload-artifact" in step.get("uses", "") for step in steps)


def test_paper_check_runs_from_manuscript_directory_without_tracked_writes() -> None:
    before = {path: path.read_bytes() for path in PAPER.rglob("*") if path.is_file()}
    result = run_command(
        sys.executable,
        [str(ROOT / "scripts/check_paper_inputs.py")],
        cwd=PAPER,
        timeout=30,
    )
    assert result.returncode == 0
    assert {path: path.read_bytes() for path in before} == before
    assert not (PAPER / ".venv").exists()


def test_bibliography_keys_cover_explicit_citations() -> None:
    tex = (PAPER / "validation.tex").read_text(encoding="utf-8")
    bib = (PAPER / "validation.bib").read_text(encoding="utf-8")
    cited = {key.strip() for group in re.findall(r"\\(?:no)?cite\w*(?:\[[^]]*\])*\{([^}]+)\}", tex) for key in group.split(",")}
    entries = re.findall(r"@\w+\s*\{\s*([^,\s]+)", bib)
    assert entries
    assert len(entries) == len(set(entries))
    # The source deliberately uses \\nocite{*} to print its full bibliography.
    assert cited - {"*"} <= set(entries)
