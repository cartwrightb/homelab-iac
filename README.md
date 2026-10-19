# homelab-iac

Infrastructure as Code for a Proxmox homelab, using Terraform, Packer and
Ansible, with Kubernetes workloads managed through the separate
`homelab-platform` repository and FluxCD.

The aim is to develop a maintainable engineering platform while learning
Platform Engineering, SRE practices and AI-assisted development.

## Current status

The first practical milestone has prepared Terraform and Ansible configurations
for a manually bootstrapped Fedora controller and one disposable Proxmox guest.
The workflow is not live-tested. Provider compatibility, tool installation,
dependency locking and private environment prerequisites remain outstanding.
See the [milestone guide](docs/milestone-disposable-vm.md) before using any commands.

## Intended architecture

```text
Packer       -> reusable VM templates
Terraform    -> infrastructure provisioned from those templates
Ansible      -> guest configuration and agreed bootstrap tasks
homelab-platform / FluxCD -> Kubernetes resources and workloads
```

These are proposed ownership boundaries. The existing `homelab-platform`
workflow has not been inspected; Kubernetes installation and Flux bootstrap
ownership remain open decisions. See [architecture](docs/architecture.md).

## Repository layout

| Path | Purpose |
| --- | --- |
| `AGENTS.md` | Engineering, learning, review and authorization rules |
| `.gitignore` | Safeguards for local configuration, secrets and generated files |
| `docs/` | Architecture, development, security, decisions and runbook guidance |
| `terraform/environments/homelab/` | One disposable guest root; provisional provider pin and private local state |
| `ansible/` | Separate control-node baseline and disposable guest playbooks; placeholder inventory |

Packer, shared modules/roles and CI workflows remain deferred. Add them when a
concrete need and validated toolchain justify them.

## Development workflow

Use a descriptive feature branch and focused changes. For significant
engineering changes, explain decisions, alternatives, trade-offs and validation results,
then obtain an independent review before integration through a pull request.
Routine documentation changes may use proportionate content, link and
whitespace checks without independent review. Policy changes affecting
engineering or security boundaries still require independent review.

Local repository changes do not authorize live infrastructure operations.
Pushing, opening or merging a pull request requires authorization for that
action. See [development](docs/development.md) and [agent guidance](AGENTS.md).

## Security and state

Keep credentials, sensitive infrastructure details, real inventories,
Terraform state and saved plans out of this public repository. Use sanitized
examples. Ignore rules are a safeguard, not a substitute for reviewing files.

The first experiment uses one private local state outside the checkout, with
OS locking and a mandatory encrypted off-VM backup/recovery procedure. Exact
paths, credentials and recovery custody must be agreed before live provisioning.
See [security](docs/security.md) and the [state runbook](docs/runbooks/local-state.md).

## Documentation

- [Architecture and open decisions](docs/architecture.md)
- [Development and validation](docs/development.md)
- [Security and private configuration](docs/security.md)
- [Architecture decision records](docs/decisions/README.md)
- [Operational runbooks](docs/runbooks/README.md)

## Next milestones

1. Resolve the [milestone prerequisites](docs/milestone-disposable-vm.md), authorize
   tooling installation and complete native static validation/dependency locking.
2. Bootstrap build01 and a new source template only after live approval.
3. Validate the disposable lifecycle in separately approved stages.
4. Inspect the existing platform workflow before future Kubernetes integration.
