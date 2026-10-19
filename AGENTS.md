# Engineering guidance

## Purpose

Build a maintainable Infrastructure as Code platform for a Proxmox homelab
using Terraform, Packer and Ansible, integrated with the existing
`homelab-platform` Kubernetes and FluxCD repository.

This is a learning project for an experienced infrastructure engineer
developing Platform Engineering, SRE and AI-assisted development practices.

## Learning-first workflow

- Inspect relevant code and documentation before proposing changes.
- For significant engineering changes, the implementing agent must explain the technical
  decisions, alternatives considered, trade-offs and validation results.
- Distinguish tested results from assumptions and unverified behavior.
- Significant engineering changes must subsequently receive an independent review by a
  separate reviewer or agent before integration. The reviewer must challenge
  assumptions, identify risks and report remaining uncertainties.
- Significant changes include infrastructure lifecycle behavior, Terraform
  state or backend configuration, credential handling, bootstrap ownership
  and CI security boundaries, including documentation that defines those policies.
- Routine documentation changes may use proportionate checks, such as content,
  link and whitespace review; independent review is not required for those edits.
- Address review findings or explicitly document unresolved findings and
  their implications. Report review and validation limitations honestly.
- Explain engineering reasoning at a level useful to an experienced
  infrastructure engineer learning these tools and practices.

## Working approach

- Prefer straightforward configurations and incremental improvements.
- Keep changes focused and reviewable; preserve unrelated user changes.
- Avoid speculative scaffolding. Introduce implementation directories,
  Terraform modules, Ansible roles and CI workflows when actual work needs them.
- Introduce abstractions when a concrete need justifies them.

## Authorization and infrastructure safety

- Obtain explicit approval before modifying live infrastructure.
- Repository changes do not authorize infrastructure execution.
- Treat Terraform apply or destroy, Packer builds against Proxmox, Ansible
  execution against real hosts and cluster mutations as live operations.
- Before requesting approval, describe the target, expected effects and
  validation or recovery approach.
- Do not assume check or dry-run modes are free of side effects. Obtain
  authorization before validation that contacts live services or uses credentials.
- Do not install software without authorization.

## Git workflow

- Implement changes on a descriptive local feature branch, not directly on main.
- Use pull requests for review and integration when GitHub actions are authorized.
- Do not push, open or merge pull requests, force-push or change GitHub
  settings without explicit authorization for those actions.
- Do not treat approval to edit files as approval to commit them.

## Public repository security

- Never commit credentials, tokens, private keys, Terraform state, saved plans
  or sensitive infrastructure details.
- Use sanitized examples and clear placeholders in public files.
- Keep real inventories, variable values and backend credentials outside
  tracked files; prefer storage outside the checkout.
- Do not print secrets in logs, command output or documentation.
- Treat ignore rules as a safeguard, not proof that a file is safe.
- Review tracked and untracked changes for sensitive information before committing.
- Commit Terraform dependency lock files for root configurations.
- Agree state storage, locking and secret delivery before live provisioning.

## Ownership boundaries

- Packer owns reusable machine images.
- Terraform owns declared infrastructure resources.
- Ansible owns agreed guest configuration and bootstrap tasks.
- `homelab-platform` owns Kubernetes resources managed through GitOps.
- These are intended boundaries; verify the existing workflow before implementation.
- Document ownership before adding overlapping behavior; do not infer the
  existing Kubernetes installation or Flux bootstrap process.

## Validation and documentation

- Run checks appropriate to the scope and risk of each change.
- Prefer local, static checks before interacting with live systems.
- Keep public CI independent of homelab connectivity and credentials.
- Never expose infrastructure credentials to untrusted pull requests.
- Report what was checked, what passed and what remains unverified.
- Update documentation alongside behavior changes.
- Record consequential decisions in short architecture decision records.
- Add operational runbooks as real workflows are introduced.
