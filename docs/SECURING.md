# Securing Papers

Papers follows Delaunay's GitHub security pattern with checks appropriate to a
manuscript repository. The maintainer owns live GitHub settings; committed
policy files document the expected configuration and validate workflow changes.

## Repository controls

- Enable secret scanning, secret push protection, Dependabot alerts/security
  updates, and private vulnerability reporting.
- Set default Actions token permissions to read. Permit Actions-created PR
  approvals for the trusted shared Dependabot workflow using
  [workflow-permissions.json](../.github/settings/workflow-permissions.json);
  jobs elevate only the permissions they need.
- Permit only the explicit action patterns in
  [actions-selected.json](../.github/settings/actions-selected.json), with verified
  publishers and GitHub-owned actions not broadly allowed. Require full commit SHA pins.
- Apply [main-ruleset.json](../.github/settings/main-ruleset.json) to the default
  branch. It requires a PR, one approval, resolved review threads, current
  required checks, and blocks deletion and force pushes. It also requires
  CODEOWNER approval for the paths assigned in
  [CODEOWNERS](../.github/CODEOWNERS).
- Allow GitHub native auto-merge and automatic deletion of merged PR branches using
  [repository.json](../.github/settings/repository.json). Maintainers opt in
  each ready PR; all required checks and reviews still gate the merge.
- Retain the repository-administrator bypass used by Delaunay. Ordinary
  development still uses PRs and waits for checks and review.

## Human review of control files

The hosted `require_code_owner_review` rule and the CODEOWNERS file on `main`
require `@acgetchell` to approve changes to either root CodeRabbit configuration
filename and to GitHub controls by default. This includes CODEOWNERS itself,
committed settings snapshots, Dependabot configuration, and the Dependabot
approval workflow. Exact routine workflow and setup-action paths have empty
owners in CODEOWNERS, so the verified shared Dependabot approval can satisfy
their normal one-approval requirement. Unknown GitHub paths remain owned.

These path exceptions apply to every author. Ordinary workflow PRs still need
manual review: CodeRabbit automatic approval remains disabled for `.github/**`,
and the shared approval job only accepts verified Dependabot updates. Updates
to the approval workflow itself still require human ownership review, even
when proposed by Dependabot. No application gets a ruleset bypass.

GitHub uses the base branch's ownership file, so changing or deleting the
ownership mapping in a PR does not remove its required review. The exceptions
take effect after the CODEOWNERS change merges into `main`; affected Dependabot
PRs must then be current with `main` and pass the required checks. The hosted
rule is managed by a repository administrator, independently of PR-controlled
CodeRabbit approval settings.

Paper files have no CODEOWNER entry. Their existing one-approval requirement
can still be satisfied by CodeRabbit, subject to its low merge-risk policy and
all required checks. No blanket human approval is required for ordinary papers.

`@acgetchell` is currently the only human collaborator. GitHub does not permit
self-approval, so maintainer-authored control changes require deliberate manual
review and use of the existing administrator
bypass, or an additional trusted human code owner. Automation must not use
that bypass. See [GitHub's CODEOWNERS documentation](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-code-owners).

## Required checks

| Check | Provider |
| --- | --- |
| Analyze (actions) | GitHub Actions |
| Analyze (python) | GitHub Actions |
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

The hosted ruleset also requires CodeQL scanning results. It blocks error-level
alerts and high or critical security alerts, independently of the analysis jobs'
success status. CodeQL already runs for Actions and Python, so this adds
enforcement without another scanner. Review severity exceptions deliberately;
the rule applies to alerts introduced on changed lines in PRs. See
[GitHub's merge-protection documentation](https://docs.github.com/en/code-security/concepts/code-scanning/merge-protection).

## Security workflows

Gitleaks and OSV run on PRs, `main` pushes, weekly schedules, and manual dispatch
through `research-repo-tools`. Gitleaks scans full reachable history and current
inputs; OSV scans the root `uv.lock`. Validated JSON/SARIF security reports are
retained for seven days, including on findings. These are security reports, not
LaTeX build artifacts.

Scanner jobs select the composite setup action's `security` profile. It installs
the locked `security` Python group and uses `research-repo-tools toolchain
sync-binaries` to verify native scanner pins without Rust/Cargo builds, full
tooling, or paper dependencies. Just is provided by the inherited shared Python
tools. Tooling validation and paper compilation retain the default `full`
profile. Both profiles use the same root manifest, lockfile, and inherited
Python/tool versions.

The zizmor workflow uses the shared authenticated, required-online command and
uploads SARIF to code scanning. CodeQL covers Actions and Python; no Rust crate
or notebook workload is run in this repository. Workflow checking also enforces
the selected-actions policy through the shared allowlist command.

CodeRabbit automatically reviews PRs and subsequent pushes, including drafts.
Its `reviews.auto_approvals.enabled` setting requests changes for blocking
findings and approves after required threads are resolved, the latest commit
is reviewed, its pre-merge checks pass, and merge risk is at most `low`.
PRs changing `.github/**` are excluded from automatic approval and require
manual review, except verified Dependabot updates approved by the shared job.
The security-risk cap is not configured because the current
Essentials plan does not provide the required assessment; configuring it would
withhold approvals. See CodeRabbit's
[approval risk limits](https://docs.coderabbit.ai/pr-reviews/approval-risk-limits).
`reviews.auto_approvals.enabled` is the current name for the
`request_changes_workflow` setting used in the other research repositories.
`review_progress: false` retains the `CodeRabbit` commit status required by the
ruleset. A successful commit status reports review completion; the separate
approving review satisfies the required approval.
Its instructions preserve author-owned scientific prose and focus TeX feedback
on correctness and build plumbing. Review does not publish papers or refresh
their reviewer PDFs. [Blog publishing](https://github.com/acgetchell/Papers/issues/2)
has a separate scope and approval path.

## Dependency updates

Dependabot's weekly GitHub Actions updates and seven-day cooldown remain
enabled. Hosted uv version updates are paused until its updater supports the
inherited Python 3.15 baseline. Keep the dependency graph enabled: its separate
uv graph jobs may still fail until upstream support lands. OSV continues to
audit the actual root lockfile. Use `just update-python-dependencies` for
deliberate Python updates and the shared adoption flow for shared-package
upgrades, followed by `just ci`.

The Dependabot caller reuses the approval workflow at the exact
`research-repo-tools` v0.2.3 commit. It runs from trusted base-branch policy,
never checks out PR code, verifies signed Dependabot commits and current-head
identity, and accepts only explicitly listed dependency files. It then approves
and enables native squash auto-merge; CI, code scanning, thread resolution, and
human CODEOWNER requirements still gate the merge. The optional approval job is
not a required check because it intentionally skips ordinary PRs.

The hosted Actions allowlist includes the shared reusable workflow and its
pinned `dependabot/fetch-metadata` action. Default tokens remain read-only;
write permissions are limited to the approval job. Its bot approval cannot
replace `@acgetchell`'s owner approval for owned policy files. The caller is
active on `main`; Dependabot open, reopen, or push events use that trusted
base-branch policy. Rerunning an older job does not load a newly deployed caller.

## Applying settings

Enable native auto-merge and delete merged PR branches with the committed settings:

```sh
gh api --method PATCH repos/acgetchell/Papers \
  --input .github/settings/repository.json
```

Enabling this repository setting does not arm every PR. Maintainers enable
auto-merge separately on each ready PR in GitHub or with
`gh pr merge NUMBER --repo acgetchell/Papers --auto --merge`. Drafts remain
unmergeable. The shared workflow approves only verified Dependabot updates;
it never approves ordinary PRs or bypasses the ruleset.

After reviewing a policy change, repository administrators can apply the action
allowlist with the GitHub CLI:

```sh
gh api --method PUT repos/acgetchell/Papers/actions/permissions \
  -F enabled=true -f allowed_actions=selected -F sha_pinning_required=true
gh api --method PUT repos/acgetchell/Papers/actions/permissions/selected-actions \
  --input .github/settings/actions-selected.json
gh api --method PUT repos/acgetchell/Papers/actions/permissions/workflow \
  --input .github/settings/workflow-permissions.json
```

For the ruleset, read `gh api repos/acgetchell/Papers/rulesets`, then update the
existing `main` ruleset by its returned ID using the committed JSON. Use creation
only when it does not already exist; never create duplicate rulesets. Re-read
settings after applying them and verify that required names match real check
runs. Keep these controls separate from workflow YAML permissions and
`SECURITY.md`'s vulnerability-reporting policy.
