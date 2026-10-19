# Development and validation

## Change workflow

1. Inspect relevant files and state the intended scope.
2. Create a descriptive local feature branch.
3. Implement a focused increment and update relevant documentation.
4. For significant engineering changes, explain decisions, alternatives and trade-offs.
5. Run appropriate authorized checks and report results and limitations.
6. For significant engineering changes, obtain independent review from a
   separate reviewer or agent. Challenge assumptions, identify risks and
   record remaining uncertainties. Routine documentation changes may use
   proportionate content, link and whitespace checks without independent
   review. Policy changes affecting engineering or security boundaries still
   require independent review; see the examples in [AGENTS.md](../AGENTS.md).
7. Resolve findings or make unresolved implications explicit.
8. When authorized, commit, push and open a pull request for integration.

Approval to edit local files does not authorize committing, pushing, opening
or merging a pull request, installing tools or executing against live systems.

## Project agent workflow

The main agent coordinates and edits. Project definitions live in
[reviewer.toml](../.codex/agents/reviewer.toml) and
[mentor.toml](../.codex/agents/mentor.toml). Each standalone TOML file supplies
`name`, `description` and `developer_instructions`; model and reasoning settings
inherit from the parent. No global configuration change is required.

For significant changes, the main agent automatically invokes Reviewer after
implementation and permitted checks, resolves findings, and requests focused
re-review when fixes materially affect behavior. Reviewer independently examines
the complete change, including new files. Mentor explains consequential decisions,
alternatives and concepts during design or after implementation stabilizes.
Routine edits do not require either role. Significance and exceptions are defined
in [AGENTS.md](../AGENTS.md).

These internal handoffs need no message copying by the user. Both roles return
results without editing. Their read-only instructions are behavioral constraints,
not separate sandboxes: they inherit parent permissions and share its filesystem.
The main agent remains responsible for implementation, decisions and reporting.

Neither delegation nor favorable review authorizes live infrastructure access,
credential use, installation, commits, pushes, PR creation or merges. Existing
approval requirements apply to every agent, including check/dry-run commands that
contact live services or use credentials. Before requesting live approval, describe
the target, expected effects and validation or recovery approach. Engineering
Reviewer is distinct from Codex's automatic permission reviewer; this workflow
does not change permission settings or automatic approval policy.

### Verify delegation

1. Start a fresh session in this trusted repository so definitions can be
   discovered. Inspect the actual spawn interface or available role list. Naming
   a task `reviewer` does not prove custom-role selection.
2. Ask the main agent to spawn named `reviewer` and `mentor` roles for a harmless
   exercise: read their definitions and summarize responsibilities and approval
   boundaries. Request no edits, credentials or external access.
3. Wait for both results. Record actual identifiers, role-selection evidence,
   assignments, completion status and summaries. Inspect subagent activity/threads
   in the app, or `/subagents` in supported CLI versions.
4. Distinguish TOML parsing, named-role discovery/selection, successful spawning
   and completion. A role-like task label or main-agent summary alone proves
   neither custom-role loading nor delegation.
5. If named roles are unavailable, disclose the limitation and use separate
   generic subagents with the exact project role instructions. Label this fallback
   delegation, not a successful named-role test. If spawning fails, report failure
   and leave required independent review outstanding.

Final reports must include actual subagent activity, findings and resolutions,
consequential decision explanations, failures and remaining uncertainties.
Definitions follow the [official custom-agent format](https://learn.chatgpt.com/docs/agent-configuration/subagents);
runtime discovery must still be verified for the installed client.

## Foundation checks

These checks inspect local repository metadata and files:

```sh
git status --short --branch
git diff
git diff --check
git diff --cached
git diff --cached --check
git ls-files --others --exclude-standard
```

`git diff` reviews unstaged changes to tracked files; `git diff --check`
checks that state for whitespace errors. `git diff --cached` reviews staged
changes against HEAD; `git diff --cached --check` checks staged whitespace.
Run both sets when changes exist in both states.

Neither diff includes untracked file contents. List those files with
`git ls-files --others --exclude-standard`, then inspect their contents
separately or add only the intended files to the index before reviewing the
complete staged diff. Review all intended content for secrets and unintended
changes before committing, and check status for remaining unstaged changes.

Check relative Markdown links and exercise ignore patterns with
`git check-ignore --no-index` using dummy paths; no real secret files are needed.

There is no automated test or CI suite yet. Whitespace checks and manual
review cannot prove that files contain no sensitive information.

### First milestone static validation

With already approved/available tools, run from the repository root:

```sh
terraform fmt -check -recursive terraform
```

Provider-aware validation requires a separately approved Terraform/provider
installation. Use an isolated private `TF_DATA_DIR` with no credentials and
`terraform -chdir=terraform/environments/homelab init -backend=false`, then
`terraform -chdir=terraform/environments/homelab validate`. This init downloads
executable provider software. It must generate a genuine dependency lockfile;
review it and include it in the eventual approved commit. Do not fabricate one.
Do not reuse this validation data directory for live runs; initialize a separate
one against the private backend. Never use `plan` as an offline validation check.

From `ansible/`, after approved Ansible/lint availability, use only the sanitized
example inventory for syntax validation (no credentialed inventory plugins):

```sh
ansible-playbook -i inventories/example/hosts.yml control-node.yml --syntax-check
ansible-playbook -i inventories/example/hosts.yml disposable.yml --syntax-check
ansible-lint control-node.yml disposable.yml
```

Run linters with network/offline behavior reviewed and configured as appropriate;
dependency auto-install is not authorized implicitly. YAML parsing alone does
not validate Ansible modules, Jinja expressions, privilege escalation or runtime
behavior. Record unavailable checks explicitly; do not describe parsing as a
passed Terraform/Ansible validation. See the [milestone status](milestone-disposable-vm.md).

## Future validation

As tool configuration arrives, add appropriate formatting, validation and
lint checks. Inspect command behavior before execution: some validation
commands initialize plugins, download dependencies or contact live services.
Use already available tools for approved static checks; seek authorization
before installation or live access.

Keep public pull request checks independent of homelab access and credentials.
Select tooling and version pins when implementing the relevant checks.

Static validation does not establish that an image builds, a VM provisions
or a playbook succeeds on a real host. Report live integration validation
separately, with explicit authorization and its actual target and results.
