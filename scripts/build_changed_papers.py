"""Select affected manuscripts and compile them with the shared pinned toolchain."""

import argparse
import html
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

from research_repo_tools.paper_dates import read_source_date
from research_repo_tools.paper_pdf import check_pdf
from research_repo_tools.process import ExecutableNotFoundError, format_exception_diagnostics, run_command, run_command_live, run_git_bytes
from research_repo_tools.selection import select_files

ROOT = Path(__file__).resolve().parents[1]
BUILD_INPUTS = frozenset(
    {
        ".github/actions/setup-just/action.yml",
        ".github/workflows/papers.yml",
        ".python-version",
        "pyproject.toml",
        "rust-toolchain.toml",
        "scripts/build-paper.sh",
        "scripts/build_changed_papers.py",
        "scripts/check_paper_inputs.py",
        "scripts/ci-paper-setup.sh",
        "scripts/ci-paper-warmup.sh",
        "tooling/papers.toml",
        "uv.lock",
    }
)
UNRESOLVED = re.compile(
    r"LaTeX Warning: (?:Citation|Reference).*undefined|There were undefined (?:references|citations)|There were multiply-defined labels",
    re.IGNORECASE,
)
LAYOUT = re.compile(r"(?m)^(?:Over|Under)full \\[hv]box[^\n]*(?:\n(?!(?:Over|Under)full \\[hv]box)[^\n]+)*")


def report_advisories(source: str, category: str, diagnostics: list[str]) -> None:
    """Keep full diagnostics in logs and bounded, escaped details in CI summaries."""
    status = f"{category}: {len(diagnostics)} advisory diagnostic(s)"
    print(f"{source!r}: {status}")
    details = "\n\n".join(diagnostics)
    for line in details.splitlines():
        # Tool output must not become a GitHub Actions workflow command.
        print(f"    {line}")
    summary = os.environ.get("GITHUB_STEP_SUMMARY")
    if summary:
        excerpt = "\n".join(details.splitlines()[:100])[:8000]
        if excerpt != details:
            excerpt += "\n[Summary truncated; full diagnostics are in the build log.]"
        with Path(summary).open("a", encoding="utf-8") as stream:
            stream.write(f"<h3>{html.escape(source)}: {html.escape(category)}</h3>\n\n{status}\n\n")
            if excerpt:
                stream.write(f"<pre>{html.escape(excerpt)}</pre>\n\n")


def lint_legacy_source(root: Path, source: str) -> None:
    """Report legacy ChkTeX findings without hiding operational failures."""
    environment = {**os.environ, "PATH": os.pathsep.join(("/Library/TeX/texbin", os.environ.get("PATH", "")))}
    result = run_command(
        "chktex",
        ["-q", "-f", "%f:%l:%c: %k %n: %m\n", Path(source).name],
        cwd=(root / source).parent,
        env=environment,
        errors="replace",
        timeout=60,
        check=False,
    )
    report_advisories(source, "ChkTeX", result.stdout.splitlines())
    # ChkTeX documents 2/3 as manuscript warnings/errors; legacy findings are
    # advisory. Exit 1, signals, and unexpected statuses are tool failures.
    if result.returncode not in (0, 2, 3):
        result.check_returncode()
    # ChkTeX can exit zero when it could not open an input; those messages go
    # to stderr rather than its formatted manuscript diagnostics on stdout.
    if result.stderr.strip():
        raise ValueError(f"ChkTeX could not fully check {source}: {result.stderr.strip()}")


def manuscript_sources(root: Path) -> tuple[str, ...]:
    """Use the shared safe inventory; fragments are inputs rather than documents."""
    return tuple(
        name
        for name in select_files(root, include=("*.tex",), exclude=("target/**", ".venv/**"))
        if re.search(r"(?m)^\s*\\documentclass(?:\[[^]]*\])?\{", (root / name).read_text(encoding="utf-8"))
    )


def bibliography_inputs(root: Path, source: str) -> set[str]:
    """Resolve the repository's existing explicit BibTeX references."""
    inputs: set[str] = set()
    path = root / source
    for group in re.findall(r"\\bibliography\{([^}]+)\}", path.read_text(encoding="utf-8")):
        for name in group.split(","):
            bibliography = path.parent / name.strip()
            if bibliography.suffix != ".bib":
                bibliography = bibliography.with_suffix(".bib")
            resolved = bibliography.resolve()
            if not resolved.is_relative_to(root.resolve()):
                raise ValueError(f"Bibliography is outside the repository: {source}")
            inputs.add(resolved.relative_to(root.resolve()).as_posix())
    return inputs


def affected_sources(root: Path, changed: set[str]) -> tuple[str, ...]:
    """Select paper families and consumers of shared bibliographies."""
    sources = manuscript_sources(root)
    if changed & BUILD_INPUTS:
        return sources
    return tuple(
        source for source in sources if any(name.startswith(Path(source).parts[0] + "/") for name in changed) or changed & bibliography_inputs(root, source)
    )


def changed_sources(root: Path, event_name: str, event: dict[str, object]) -> tuple[str, ...]:
    """Select from GitHub's event revisions without interpolating them into a shell."""
    if event_name == "workflow_dispatch":
        return manuscript_sources(root)
    if event_name == "pull_request":
        pull_request = event["pull_request"]
        if not isinstance(pull_request, dict):
            raise ValueError("Missing pull request revisions")
        base, head = pull_request["base"]["sha"], pull_request["head"]["sha"]
        operator = "..."
    elif event_name == "push":
        base, head = event["before"], event["after"]
        operator = ".."
    else:
        raise ValueError(f"Unsupported paper-build event: {event_name}")
    if not all(isinstance(value, str) and re.fullmatch(r"[0-9a-f]{40}", value) for value in (base, head)):
        raise ValueError("Build revisions must be full Git commit SHAs")
    if base == "0" * 40:
        return manuscript_sources(root)
    result = run_git_bytes(["--no-pager", "diff", "--name-only", "--no-renames", "-z", f"{base}{operator}{head}", "--"], cwd=root)
    changed = {os.fsdecode(name) for name in result.stdout.split(b"\0") if name}
    return affected_sources(root, changed)


def source_epoch(root: Path, source: str) -> int:
    """Use explicit shared dates, or the recorded source commit for legacy TeX."""
    try:
        return read_source_date(root / source).source_date_epoch
    except ValueError:
        # Older records use empty dates, no date, or \\today. Preserve that source.
        dates = re.findall(r"(?m)^\s*\\date\{([^}]*)\}", (root / source).read_text(encoding="utf-8"))
        if len(dates) > 1 or any(value.strip() not in ("", r"\today") for value in dates):
            raise
        result = run_git_bytes(["--no-pager", "log", "-1", "--format=%ct", "--", source], cwd=root).stdout.strip()
        if not result:
            result = run_git_bytes(["--no-pager", "log", "-1", "--format=%ct", "HEAD"], cwd=root).stdout.strip()
        return int(result)


def build_source(root: Path, source: str) -> None:
    """Compile a known manuscript and remove its generated outputs on every exit."""
    if source not in manuscript_sources(root):
        raise ValueError(f"Unknown standalone manuscript: {source}")
    pilot = source == "delaunay-validation/validation.tex"
    output = root / "target/papers" / ("delaunay-validation" if pilot else "changed/" + str(Path(source).with_suffix("")))
    if output.is_symlink() or output.is_junction() or any(parent.is_symlink() or parent.is_junction() for parent in output.parents if parent != root.parent):
        raise ValueError("Paper output must not contain a symlink")
    try:
        shutil.rmtree(output, ignore_errors=True)
        if pilot:
            run_command_live("just", ["paper-artifact-check"], cwd=root, timeout=900)
            return
        lint_legacy_source(root, source)
        output.mkdir(parents=True)
        environment = {**os.environ, "SOURCE_DATE_EPOCH": str(source_epoch(root, source))}
        run_command_live(
            "uv",
            [
                "run",
                "--locked",
                "--no-sync",
                "--no-python-downloads",
                "research-repo-tools",
                "--root",
                str(root),
                "--config",
                str(root / "tooling/papers.toml"),
                "toolchain",
                "run",
                "--",
                "tectonic",
                "--untrusted",
                "--keep-logs",
                "--outdir",
                str(output),
                source,
            ],
            cwd=root,
            env=environment,
            timeout=900,
        )
        log = output / (Path(source).stem + ".log")
        diagnostics = log.read_text(encoding="utf-8", errors="replace")
        bibliography_log = output / (Path(source).stem + ".blg")
        bibliography_diagnostics = bibliography_log.read_text(encoding="utf-8", errors="replace") if bibliography_log.exists() else ""
        bibliography_failed = re.search(r"There (?:was|were) \d+ error message|I (?:was expecting|couldn't open)", bibliography_diagnostics)
        if UNRESOLVED.search(diagnostics) or bibliography_failed:
            for line in diagnostics.splitlines():
                if "Warning:" in line or "undefined" in line:
                    print(line, file=sys.stderr)
            if bibliography_diagnostics:
                print(bibliography_diagnostics, file=sys.stderr)
            raise ValueError(f"Bibliography errors, unresolved references, or duplicate labels in {source}")
        inspection = check_pdf(output / (Path(source).stem + ".pdf"))
        print(f"Built {source}: {inspection.page_count} pages; removing generated output.")
    finally:
        try:
            log = output / (Path(source).stem + ".log")
            if log.is_file():
                report_advisories(source, "LaTeX layout", LAYOUT.findall(log.read_text(encoding="utf-8", errors="replace")))
        finally:
            if output.exists():
                shutil.rmtree(output)


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    commands.add_parser("changed", help="print affected source paths as a JSON list")
    build = commands.add_parser("build", help="compile selected sources, cleaning output even after failure")
    build.add_argument("--all", action="store_true", help="build every standalone TeX manuscript")
    build.add_argument("sources", nargs="*")
    args = parser.parse_args()
    try:
        if args.command == "changed":
            event = json.loads(Path(os.environ["GITHUB_EVENT_PATH"]).read_text(encoding="utf-8"))
            print(json.dumps(changed_sources(ROOT, os.environ["GITHUB_EVENT_NAME"], event)))
        else:
            sources = list(manuscript_sources(ROOT)) if args.all else args.sources or json.loads(os.environ.get("PAPER_SOURCES_JSON", "[]"))
            if not isinstance(sources, list) or any(not isinstance(source, str) for source in sources):
                raise ValueError("Selected paper sources must be a JSON list of paths")
            if not sources:
                raise ValueError("No paper sources were selected")
            for source in sources:
                build_source(ROOT, source)
    except (ExecutableNotFoundError, OSError, ValueError, KeyError, TypeError, subprocess.SubprocessError) as error:
        print(format_exception_diagnostics(error), file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
