# 0002: Proxmox provider and credential boundary

Date: 2026-10-19
Status: proposed

## Context

The operator reports Proxmox VE 8.4.16 on both hosts. No API, host or credential
has been accessed. We need full clone and native cloud-init configuration without
granting Terraform a Proxmox node shell.

## Alternatives

An older bpg release may have received more attention on PVE 8, but age alone is
not compatibility evidence and would omit later fixes. Telmate would introduce a
different schema and compatibility assessment; bpg is the approved provider.
Upgrading Proxmox is outside this milestone and is not a prerequisite we assume.

## Decision

Pin bpg/proxmox **0.117.0 provisionally** for reproducible schema review. This is
the latest release observed on 2026-10-19, not a claim of verified compatibility.
Its versioned documentation states that PVE 8.x works with limitations and is not
a testing priority. Full clones and native initialization are documented;
exact behavior on **8.4.16 is unverified**. No release can honestly be labelled
tested-compatible with our workflow from the evidence collected so far.

Use a same-node clone, explicit destination storage and native initialization
for username, public key, static IPv4 and DNS. Do not set CPU architecture,
upload snippets/images, invoke root-ticket authentication or configure node SSH.
Use API-token environment authentication with TLS verification enforced.

Create a dedicated PVE automation identity and privilege-separated token only
after approval. Review user and token ACLs independently. Derive permissions for
clone/template read, destination allocation/configuration/power/agent reads,
pool assignment and storage/network access for PVE 8.4. Do not copy upstream's
large example role or assume PVE 9 privilege names apply to PVE 8.4. Do not grant
Administrator, node sudo or global write permissions to make a 403 disappear.
Exact privileges/paths remain a reviewed private prerequisite, not guessed code.

## Consequences and validation

Before live use: select an exact Terraform CLI version within the declared range,
review release notes/advisories, authorize tool/provider installation, generate
and review `.terraform.lock.hcl`, run fmt/validate, and obtain independent review
of any resulting fixes. The lockfile is currently absent because no Terraform
CLI is installed and software installation is not authorized. Do not invent
checksums. Lockfile completion is a blocker before first live plan.

Then, with separate approval, validate API authentication/TLS, effective ACLs,
target/source identity and the disposable clone -> initialize -> configure ->
no-change plan -> destroy cycle. Verify token write scope excludes production
without attempting a production mutation. If the candidate fails, stop, record
the failure and reassess the pin; do not broaden permissions or upgrade hosts
automatically. A successful plan alone does not prove create/delete compatibility.

Sources reviewed (versioned where possible):

- [0.117.0 release](https://github.com/bpg/terraform-provider-proxmox/releases/tag/v0.117.0)
- [0.117.0 provider requirements and authentication](https://github.com/bpg/terraform-provider-proxmox/blob/v0.117.0/docs/index.md)
- [0.117.0 VM schema and cloning notes](https://github.com/bpg/terraform-provider-proxmox/blob/v0.117.0/docs/resources/virtual_environment_vm.md)

These are documentation evidence; no provider binary/schema or live workflow has
been executed locally.
