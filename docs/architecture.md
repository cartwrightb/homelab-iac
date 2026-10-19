# Architecture

## Scope and status

The intended platform manages Proxmox infrastructure through repeatable image
builds, provisioning and guest configuration. Kubernetes resources and
workloads are managed in the separate `homelab-platform` repository using
FluxCD.

The [first milestone](milestone-disposable-vm.md) adds prepared configurations,
not a deployed or tested system. No live
environment or `homelab-platform` configuration has been inspected for this
foundation work.

## Lifecycle and ownership

```text
Packer -> VM template -> Terraform -> provisioned guests -> Ansible
                                                           |
                                              agreed bootstrap boundary
                                                           |
                                          homelab-platform / FluxCD
```

| Component | Intended responsibility | Boundary to establish |
| --- | --- | --- |
| Packer | Reusable machine images | Image content, identity and template handoff |
| Terraform | Declared Proxmox resources | Provider, resource ownership and state |
| Ansible | Guest configuration and agreed bootstrap | What belongs in images versus configuration |
| homelab-platform / FluxCD | Kubernetes resources and workloads | Kubernetes installation, node joining and Flux bootstrap |

Give each resource or setting one owner. Agree handoffs before implementing
them; do not assume Terraform outputs or inventory generation need automation
before a concrete workflow demonstrates the need.

## Repository organization

The first implementation introduces:

- `terraform/environments/homelab/`: one initial root configuration and state
  boundary owning only one disposable guest, excluding build01/template.
- `ansible/`: playbooks and sanitized example inventory; roles when justified.
- Packer and `.github/workflows/` remain deferred until their workflows/toolchain
  can be introduced and validated with a concrete need.

Avoid introducing shared modules or multiple Terraform state boundaries until
reuse, lifecycle differences or risk justify the extra coordination.

## Public and private information

Public files describe logical roles and sanitized examples. Actual addresses,
hostnames, inventories, credentials and state stay private. Record public-safe
design decisions here; keep environment-specific operational details outside
the repository. See [security](security.md).

## Open decisions

Before live provisioning, agree:

- Existing `homelab-platform` behavior and the bootstrap ownership boundary.
- Terraform provider and version policy, state storage, locking and recovery.
- Credential delivery and private configuration locations.
- Initial guest operating system, image content and template versioning.
- The first resource scope and its validation and recovery procedure.

Before implementation, inspect relevant existing configuration and document
consequential choices using [decision records](decisions/README.md).

For this milestone, the controller is manually created, Terraform and Ansible
run separately, Packer is deferred and local state stays outside the repository.
See ADRs 0001-0003 for accepted boundaries and the provisional provider choice.
Remaining private values and compatibility evidence are in the milestone guide;
these decisions do not resolve Kubernetes/Flux bootstrap ownership.
