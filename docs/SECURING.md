# Securing Papers

Papers follows Delaunay's GitHub security pattern with checks appropriate to a
manuscript repository. The maintainer owns live GitHub settings; committed
policy files document the expected configuration and validate workflow changes.

## Repository controls

- Enable secret scanning, secret push protection, Dependabot alerts/security
  updates, and private vulnerability reporting.
- Set the default Actions token permissions to read and disable Actions-created
  pull request approvals. Jobs elevate only the permissions they need.
- Permit only the explicit action patterns in
  [actions-selected.json](../.github/settings/actions-selected.json), with verified
  publishers and GitHub-owned actions not broadly allowed. Require full commit SHA pins.
- Apply [main-ruleset.json](../.github/settings/main-ruleset.json) to the default
  branch. It requires a PR, one approval, resolved review threads, current
  required checks, and blocks deletion and force pushes.
- Allow GitHub native auto-merge using
  [repository.json](../.github/settings/repository.json). Maintainers opt in
  each ready PR; all required checks and reviews still gate the merge.
- Retain the repository-administrator bypass used by Delaunay. Ordinary
  development still uses PRs and waits for checks and review.

## Required checks

| Check | Provider |
| --- | --- |
| Changed paper builds | GitHub Actions |
| CodeRabbit | CodeRabbit GitHub App |
| GitHub Actions Security Analysis | GitHub Actions |
| Gitleaks secret scan | GitHub Actions |
| OSV dependency scan | GitHub Actions |
| Tooling validation | GitHub Actions |

The ruleset binds checks to their provider application IDs. Paper build
selection runs for every PR so the stable aggregate check succeeds for a
change with no affected TeX. A selection failure cannot become a successful
skipped build. When sources are selected, their LaTeX builds must succeed.
Changes to shared paper tooling, including the root Justfile, rebuild all
standalone sources. This required check applies to native auto-merge as well as
manual merging.

## Security workflows

Gitleaks and OSV run on PRs, `main` pushes, weekly schedules, and manual dispatch
through `research-repo-tools`. Gitleaks scans full reachable history and current
inputs; OSV scans the root `uv.lock`. Validated JSON/SARIF security reports are
retained for seven days, including on findings. These are security reports, not
LaTeX build artifacts.

The zizmor workflow uses the shared authenticated, required-online command and
uploads SARIF to code scanning. CodeQL covers Actions and Python; no Rust crate
or notebook workload is run in this repository. Workflow checking also enforces
the selected-actions policy through the shared allowlist command.

CodeRabbit automatically reviews PRs and subsequent pushes, including drafts.
Its `reviews.auto_approvals.enabled` setting requests changes for blocking
findings and approves after required threads are resolved, the latest commit
is reviewed, and its pre-merge checks pass. This is the current name for the
`request_changes_workflow` setting used in the other research repositories.
`review_progress: false` retains the `CodeRabbit` commit status required by the
ruleset. A successful commit status reports review completion; the separate
approving review satisfies the required approval.
Its instructions preserve author-owned scientific prose and focus TeX feedback
on correctness and build plumbing. Review does not publish papers or refresh
their reviewer PDFs. [Blog publishing](https://github.com/acgetchell/Papers/issues/2)
has a separate scope and approval path.

## Applying settings

Enable native auto-merge with the committed repository setting:

```sh
gh api --method PATCH repos/acgetchell/Papers \
  --input .github/settings/repository.json
```

Enabling this repository setting does not arm every PR. Maintainers enable
auto-merge separately on each ready PR in GitHub or with
`gh pr merge NUMBER --repo acgetchell/Papers --auto --merge`. Drafts remain
unmergeable. No workflow grants itself approval or bypasses the ruleset.

After reviewing a policy change, repository administrators can apply the action
allowlist with the GitHub CLI:

```sh
gh api --method PUT repos/acgetchell/Papers/actions/permissions \
  -F enabled=true -f allowed_actions=selected -F sha_pinning_required=true
gh api --method PUT repos/acgetchell/Papers/actions/permissions/selected-actions \
  --input .github/settings/actions-selected.json
gh api --method PUT repos/acgetchell/Papers/actions/permissions/workflow \
  -f default_workflow_permissions=read -F can_approve_pull_request_reviews=false
```

For the ruleset, read `gh api repos/acgetchell/Papers/rulesets`, then update the
existing `main` ruleset by its returned ID using the committed JSON. Use creation
only when it does not already exist; never create duplicate rulesets. Re-read
settings after applying them and verify that required names match real check
runs. Keep these controls separate from workflow YAML permissions and
`SECURITY.md`'s vulnerability-reporting policy.
