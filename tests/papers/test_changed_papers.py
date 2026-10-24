"""Regression evidence for changed-paper selection and failed-build cleanup."""

import importlib.util
import subprocess
from pathlib import Path

import pytest

ROOT = Path(__file__).resolve().parents[2]
spec = importlib.util.spec_from_file_location("changed_papers", ROOT / "scripts/build_changed_papers.py")
assert spec is not None and spec.loader is not None
papers = importlib.util.module_from_spec(spec)
spec.loader.exec_module(papers)


def test_shared_bibliography_selects_each_consumer() -> None:
    selected = set(papers.affected_sources(ROOT, {"newtonian-derivation-cdt/newtonian-derivation-cdt-v2.bib"}))
    assert selected == {
        "newtonian-derivation-cdt/newtonian-derivation-cdt.tex",
        "newtonian-derivation-cdt/newtonian-derivation-cdt-v2.tex",
        "newtonian-derivation-cdt/orals-backup.tex",
        "weyl-metric-calculations/weyl-metric-calculations.tex",
    }


def test_figure_change_selects_its_paper() -> None:
    assert papers.affected_sources(ROOT, {"efficient-cdt/Parallel_Transport.pdf"}) == ("efficient-cdt/EfficientCDT.tex",)


def test_documentation_only_change_selects_no_papers() -> None:
    assert papers.affected_sources(ROOT, {"CONTRIBUTING.md", "SECURITY.md"}) == ()


def test_toolchain_change_selects_all_standalone_sources() -> None:
    selected = papers.affected_sources(ROOT, {"tooling/papers.toml"})
    assert set(selected) == set(papers.manuscript_sources(ROOT))
    assert len(selected) == 9


def test_manual_dispatch_selects_all_sources() -> None:
    assert papers.changed_sources(ROOT, "workflow_dispatch", {}) == papers.manuscript_sources(ROOT)


def test_untrusted_revision_cannot_be_passed_to_git() -> None:
    with pytest.raises(ValueError, match="full Git commit SHAs"):
        papers.changed_sources(ROOT, "push", {"before": "--output=/tmp/attack", "after": "a" * 40})


def test_invalid_explicit_date_does_not_fall_back_to_legacy_timestamp(tmp_path: Path) -> None:
    (tmp_path / "paper.tex").write_bytes(b"\\documentclass{article}\n\\date{February 30, 2026}\n")
    with pytest.raises(ValueError, match="invalid paper calendar date"):
        papers.source_epoch(tmp_path, "paper.tex")


def test_failed_typesetting_cleans_output_and_preserves_source(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    source = tmp_path / "legacy/paper.tex"
    source.parent.mkdir()
    payload = b"\\documentclass{article}\n\\date{July 6, 2026}\n\\begin{document}Test\\end{document}\n"
    source.write_bytes(payload)
    monkeypatch.setattr(papers, "manuscript_sources", lambda root: ("legacy/paper.tex",))

    def fail_compiler(binary: str, arguments: list[str], *, cwd: Path, env: dict[str, str], timeout: int) -> int:
        output = Path(arguments[arguments.index("--outdir") + 1])
        (output / "paper.aux").write_bytes(b"incomplete build")
        raise subprocess.CalledProcessError(1, [binary, *arguments])

    monkeypatch.setattr(papers, "run_command_live", fail_compiler)
    with pytest.raises(subprocess.CalledProcessError):
        papers.build_source(tmp_path, "legacy/paper.tex")
    assert source.read_bytes() == payload
    assert not any(path.is_file() for path in (tmp_path / "target/papers").rglob("*"))
