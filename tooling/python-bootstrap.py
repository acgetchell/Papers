# /// script
# requires-python = ">=3.8"
# dependencies = []
# ///
"""Start an exact shared release before the consumer's interpreter can run it.

Keep this standard-library-only bootstrap compatible with older uv-supported
Python. Release metadata selects a bootstrap interpreter; the installed package
then owns all support policy and adoption. No consumer or Git files are edited here.
"""

import argparse
import json
import re
import subprocess
import sys
import urllib.request
from pathlib import Path


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("version", help="exact published research-repo-tools version")
    mode = parser.add_mutually_exclusive_group(required=True)
    mode.add_argument("--dry-run", action="store_true")
    mode.add_argument("--apply", action="store_true")
    parser.add_argument("--metadata-file", type=Path, help="saved exact PyPI JSON metadata for offline bootstrap or local artifact evaluation")
    args = parser.parse_args(argv)
    try:
        if not re.fullmatch(r"[0-9][0-9A-Za-z.+!-]*", args.version):
            raise ValueError("bootstrap requires an exact package version, not a range or URL")
        if args.metadata_file:
            document = json.loads(args.metadata_file.read_bytes())
        else:
            url = "https://pypi.org/pypi/research-repo-tools/" + args.version + "/json"
            with urllib.request.urlopen(url, timeout=30) as response:
                document = json.load(response)
        info = document.get("info") if isinstance(document, dict) else None
        if not isinstance(info, dict) or info.get("name") != "research-repo-tools" or info.get("version") != args.version:
            raise ValueError("release metadata must identify the exact requested research-repo-tools version")
        requirement = info.get("requires_python")
        if not isinstance(requirement, str) or not requirement.strip():
            raise ValueError("release metadata must declare Requires-Python for bootstrap")
        # The explicit request overrides an obsolete Python on PATH/UV_PYTHON.
        # uv verifies the installed distribution's own requirement independently.
        return subprocess.run(
            [
                "uvx",
                "--no-config",
                "--isolated",
                "--managed-python",
                "--python",
                requirement,
                "--from",
                "research-repo-tools==" + args.version,
                "research-repo-tools",
                "--root",
                str(Path.cwd()),
                "toolchain",
                "adopt",
                "--dry-run" if args.dry_run else "--apply",
            ],
            check=False,
            timeout=7200,
        ).returncode
    except (OSError, ValueError, subprocess.TimeoutExpired) as error:
        print("Python adoption bootstrap: " + str(error), file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
