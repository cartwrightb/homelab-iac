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
