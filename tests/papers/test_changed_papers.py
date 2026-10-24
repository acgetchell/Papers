"""Regression evidence for changed-paper selection and failed-build cleanup."""

import importlib.util
import subprocess
import sys
from pathlib import Path
from types import SimpleNamespace

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


@pytest.mark.parametrize(
    ("selection", "expected"),
    [
        (None, "No paper sources were selected"),
        ("[]", "No paper sources were selected"),
        ("{}", "Selected paper sources must be a JSON list of paths"),
        ("null", "Selected paper sources must be a JSON list of paths"),
        ('"paper.tex"', "Selected paper sources must be a JSON list of paths"),
        ('["paper.tex", 1]', "Selected paper sources must be a JSON list of paths"),
    ],
)
def test_build_rejects_invalid_selection_before_compilation(
    selection: str | None, expected: str, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]
) -> None:
    monkeypatch.setattr(sys, "argv", ["build_changed_papers.py", "build"])
    if selection is None:
        monkeypatch.delenv("PAPER_SOURCES_JSON", raising=False)
    else:
        monkeypatch.setenv("PAPER_SOURCES_JSON", selection)
    monkeypatch.setattr(papers, "build_source", lambda root, source: pytest.fail("Rejected selections must not start compilation"))

    assert papers.main() == 1
    captured = capsys.readouterr()
    assert captured.out == ""
    assert captured.err == expected + "\n"


def test_build_all_rejects_empty_inventory(monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]) -> None:
    monkeypatch.setattr(sys, "argv", ["build_changed_papers.py", "build", "--all"])
    monkeypatch.setattr(papers, "manuscript_sources", lambda root: ())
    monkeypatch.setattr(papers, "build_source", lambda root, source: pytest.fail("An empty inventory must not start compilation"))

    assert papers.main() == 1
    captured = capsys.readouterr()
    assert captured.out == ""
    assert captured.err == "No paper sources were selected\n"


def test_build_accepts_nonempty_selection(monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]) -> None:
    selected: list[str] = []
    monkeypatch.setattr(sys, "argv", ["build_changed_papers.py", "build"])
    monkeypatch.setenv("PAPER_SOURCES_JSON", '["paper.tex"]')
    monkeypatch.setattr(papers, "build_source", lambda root, source: selected.append(source))

    assert papers.main() == 0
    assert selected == ["paper.tex"]
    captured = capsys.readouterr()
    assert captured.out == captured.err == ""


def test_failed_typesetting_cleans_output_and_preserves_source(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    source = tmp_path / "legacy/paper.tex"
    source.parent.mkdir()
    payload = b"\\documentclass{article}\n\\date{July 6, 2026}\n\\begin{document}Test\\end{document}\n"
    source.write_bytes(payload)
    monkeypatch.setattr(papers, "manuscript_sources", lambda root: ("legacy/paper.tex",))
    monkeypatch.setattr(papers, "run_command", lambda *args, **kwargs: subprocess.CompletedProcess(args, 0, "", ""))
    summary = tmp_path / "summary.md"
    monkeypatch.setenv("GITHUB_STEP_SUMMARY", str(summary))

    def fail_compiler(binary: str, arguments: list[str], *, cwd: Path, env: dict[str, str], timeout: int) -> int:
        output = Path(arguments[arguments.index("--outdir") + 1])
        (output / "paper.aux").write_bytes(b"incomplete build")
        (output / "paper.log").write_text("Overfull \\hbox (3pt too wide) at lines 4--5\n", encoding="utf-8")
        raise subprocess.CalledProcessError(1, [binary, *arguments])

    monkeypatch.setattr(papers, "run_command_live", fail_compiler)
    with pytest.raises(subprocess.CalledProcessError):
        papers.build_source(tmp_path, "legacy/paper.tex")
    assert source.read_bytes() == payload
    assert not any(path.is_file() for path in (tmp_path / "target/papers").rglob("*"))
    assert "Overfull \\hbox (3pt too wide) at lines 4--5" in summary.read_text(encoding="utf-8")


@pytest.mark.parametrize("lint_exit", [0, 2, 3])
def test_legacy_findings_and_layout_warnings_are_advisory_and_cleaned(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str], lint_exit: int
) -> None:
    source = tmp_path / "legacy/paper.tex"
    source.parent.mkdir()
    payload = b"\\documentclass{article}\n\\date{July 6, 2026}\n"
    source.write_bytes(payload)
    monkeypatch.setattr(papers, "manuscript_sources", lambda root: ("legacy/paper.tex",))
    summary = tmp_path / "summary.md"
    monkeypatch.setenv("GITHUB_STEP_SUMMARY", str(summary))

    def lint(binary: str, arguments: list[str], **kwargs: object) -> subprocess.CompletedProcess[str]:
        assert binary == "chktex"
        assert arguments[-1] == source.name
        assert kwargs["cwd"] == source.parent
        return subprocess.CompletedProcess([binary, *arguments], lint_exit, "paper.tex:2:1: Warning 13: bad spacing\n::error::<script>\n", "")

    def compile_paper(binary: str, arguments: list[str], **kwargs: object) -> None:
        output = Path(arguments[arguments.index("--outdir") + 1])
        (output / "paper.log").write_text(
            "Overfull \\hbox (3pt too wide) in paragraph at lines\n4--5\n\n"
            "Underfull \\vbox (badness 10000) while \\output is active\n"
            "Overfull \\vbox (2pt too high) detected at line 10\n\n"
            "Underfull \\hbox (badness 1000) at lines 11--12\n\n",
            encoding="utf-8",
        )
        (output / "paper.pdf").write_bytes(b"generated PDF")

    monkeypatch.setattr(papers, "run_command", lint)
    monkeypatch.setattr(papers, "run_command_live", compile_paper)
    monkeypatch.setattr(papers, "check_pdf", lambda path: SimpleNamespace(page_count=2))

    papers.build_source(tmp_path, "legacy/paper.tex")

    captured = capsys.readouterr()
    assert "Built legacy/paper.tex: 2 pages" in captured.out
    assert "LaTeX layout: 4 advisory diagnostic(s)" in captured.out
    assert "\n::error::" not in captured.out
    assert captured.err == ""
    report = summary.read_text(encoding="utf-8")
    assert "ChkTeX: 2 advisory diagnostic(s)" in report
    assert "&lt;script&gt;" in report
    assert "<script>" not in report
    assert "4--5" in report
    assert source.read_bytes() == payload
    assert not any(path.is_file() for path in (tmp_path / "target/papers").rglob("*"))


@pytest.mark.parametrize(
    ("failure", "exception", "message"),
    [
        ("stderr", ValueError, "Unable to open the TeX file"),
        ("exit", subprocess.CalledProcessError, "non-zero exit status 1"),
        ("missing", papers.ExecutableNotFoundError, "chktex missing"),
    ],
)
def test_linter_operational_failures_stop_builds(
    tmp_path: Path, monkeypatch: pytest.MonkeyPatch, failure: str, exception: type[Exception], message: str
) -> None:
    monkeypatch.setattr(papers, "manuscript_sources", lambda root: ("legacy/paper.tex",))
    monkeypatch.delenv("GITHUB_STEP_SUMMARY", raising=False)
    monkeypatch.setattr(papers, "run_command_live", lambda *args, **kwargs: pytest.fail("A failed linter must stop compilation"))

    def fail_lint(*args: object, **kwargs: object) -> subprocess.CompletedProcess[str]:
        if failure == "missing":
            raise papers.ExecutableNotFoundError("chktex missing")
        if failure == "exit":
            return subprocess.CompletedProcess(["chktex"], 1, "", "configuration failed")
        return subprocess.CompletedProcess(["chktex"], 0, "", "Unable to open the TeX file")

    monkeypatch.setattr(papers, "run_command", fail_lint)
    with pytest.raises(exception, match=message):
        papers.build_source(tmp_path, "legacy/paper.tex")


def test_advisory_summary_is_bounded_and_full_details_stay_in_logs(tmp_path: Path, monkeypatch: pytest.MonkeyPatch, capsys: pytest.CaptureFixture[str]) -> None:
    summary = tmp_path / "summary.md"
    monkeypatch.setenv("GITHUB_STEP_SUMMARY", str(summary))
    diagnostics = [f"Warning {number}: " + "x" * 200 for number in range(200)]

    papers.report_advisories("paper<1>.tex", "ChkTeX", diagnostics)

    report = summary.read_text(encoding="utf-8")
    assert "paper&lt;1&gt;.tex" in report
    assert "200 advisory diagnostic(s)" in report
    assert "Summary truncated" in report
    assert "Warning 199:" not in report
    assert "Warning 199:" in capsys.readouterr().out
    assert len(report) < 17000


def test_pilot_layout_is_reported_without_extra_legacy_lint(tmp_path: Path, monkeypatch: pytest.MonkeyPatch) -> None:
    source = "delaunay-validation/validation.tex"
    output = tmp_path / "target/papers/delaunay-validation"
    summary = tmp_path / "summary.md"
    monkeypatch.setenv("GITHUB_STEP_SUMMARY", str(summary))
    monkeypatch.setattr(papers, "manuscript_sources", lambda root: (source,))
    monkeypatch.setattr(papers, "lint_legacy_source", lambda *args: pytest.fail("The pilot uses its existing strict ChkTeX recipe"))

    def build_pilot(binary: str, arguments: list[str], **kwargs: object) -> None:
        assert (binary, arguments) == ("just", ["paper-artifact-check"])
        output.mkdir(parents=True)
        (output / "validation.log").write_text("Overfull \\hbox (1pt too wide) at line 7\n", encoding="utf-8")

    monkeypatch.setattr(papers, "run_command_live", build_pilot)
    papers.build_source(tmp_path, source)

    assert "LaTeX layout: 1 advisory diagnostic(s)" in summary.read_text(encoding="utf-8")
    assert not output.exists()
