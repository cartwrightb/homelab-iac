# 0003: Single-runner private local Terraform state

Date: 2026-10-19
Status: accepted

## Context

The user approved local state outside the repository for the initial experiment,
with a documented private backup and recovery procedure. State, plans, backend
metadata and inventories may contain private infrastructure details.

## Alternatives

A remote backend offers central access and potentially shared locking, but needs
its own access controls, recovery and operational ownership. Creating such a
service now expands this small milestone. Git and shared copied state files are
unsuitable substitutes for a backend.

## Decision

Use one canonical state on build01's encrypted filesystem, outside the checkout,
with directory mode 0700, files 0600 and umask 077. Use only Terraform's default
workspace and one runner. Set both local backend paths explicitly, and place
`TF_DATA_DIR`, plans and private inputs outside the checkout too. The checked-in
backend paths are intentionally unusable placeholders to discourage fallback to
repository-local state; they do not enforce filesystem isolation.

Terraform's local backend uses OS locking for the same state file. Never bypass
locking or run from independent state copies. An encrypted, versioned backup
outside build01 and outside the checkout is mandatory before first apply.
Destination, retention, encryption method and recovery-key custody must be
recorded privately before execution. Reassess a remote backend before adding
other runners, shared automation or persistent managed workloads.

## Consequences and validation

build01 shares the hypervisor failure domain with the guest. Recovery instructions,
repository revision, public key recovery/reissuance procedure and backup decryption
must remain available from another trusted machine. Do not snapshot/revert only
the controller and assume its state matches newer infrastructure.

Follow the [state recovery runbook](../runbooks/local-state.md). Restoring state
does not roll back infrastructure. The first backup/restore exercise and actual
locking behavior remain untested. No backup product or destination has been
silently selected.

Source: [Terraform local backend](https://developer.hashicorp.com/terraform/language/backend/local).
