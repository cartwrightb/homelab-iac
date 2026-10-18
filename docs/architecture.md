# Architecture

## Scope and status

The intended platform manages Proxmox infrastructure through repeatable image
builds, provisioning and guest configuration. Kubernetes resources and
workloads are managed in the separate `homelab-platform` repository using
FluxCD.

This document describes intent, not a deployed or tested system. No live
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

Start with documentation. Add tool directories as implementation begins:

- `terraform/environments/homelab/`: one initial root configuration and state
  boundary, subject to the agreed resource scope.
- `packer/`: image definitions and the minimal supporting scripts they need.
- `ansible/`: playbooks and sanitized example inventory; roles when justified.
- `.github/workflows/`: static checks once there are meaningful inputs to check.

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
