# homelab-iac

Infrastructure as Code for a Proxmox homelab, using Terraform, Packer and
Ansible, with Kubernetes workloads managed through the separate
`homelab-platform` repository and FluxCD.

The aim is to develop a maintainable engineering platform while learning
Platform Engineering, SRE practices and AI-assisted development.

## Current status

This repository currently contains documentation and repository safeguards.
There are no infrastructure configurations, automated checks or tested
provisioning workflows yet.

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

Introduce `terraform/`, `packer/`, `ansible/` and `.github/workflows/` only
when actual implementation requires them. Add modules and roles when a
concrete need for them emerges.

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

State storage, locking and credential delivery must be agreed before live
provisioning. See [security](docs/security.md).

## Documentation

- [Architecture and open decisions](docs/architecture.md)
- [Development and validation](docs/development.md)
- [Security and private configuration](docs/security.md)
- [Architecture decision records](docs/decisions/README.md)
- [Operational runbooks](docs/runbooks/README.md)

## Next milestones

1. Inspect the existing platform workflow and agree ownership boundaries.
2. Agree state storage, credential delivery and a sanitized configuration model.
3. Introduce one small implementation increment with appropriate static checks.
4. Validate against live infrastructure only after explicit approval.
