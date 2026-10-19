# Fedora controller and disposable VM milestone

## Implementation status

Repository configuration is prepared, not live-validated. No tooling installation,
credential use, Proxmox access or provisioning is authorized by these files.
Production homelab guests/services are excluded. The operator reports PVE 8.4.16;
this has not been independently queried.

Read the decisions for [ownership](decisions/0001-disposable-vm-workflow.md),
[provider compatibility](decisions/0002-proxmox-provider.md) and
[state](decisions/0003-private-local-state.md). The provider pin is a candidate,
not a verified-compatible release. No dependency lockfile has been generated yet.

## Prepared components

- `terraform/environments/homelab/`: one disposable full clone, 2 vCPU/2 GiB RAM,
  explicit private network/storage inputs and native cloud-init. Inherits the
  prepared template's disk and firmware. Does not manage existing host resources.
- `ansible/control-node.yml`: baseline packages on manually bootstrapped build01,
  over SSH; Ansible itself must already be available on the invoking controller.
- `ansible/disposable.yml`: one console-identified Fedora guest, enforcing SELinux
  and running firewalld prerequisites, nginx/static page on **127.0.0.1 only**.
  No inbound HTTP firewall opening and no automatic reboot.
- Example backend, Terraform inputs and inventory are deliberately non-runnable.
  There is no default Ansible inventory. Use an absolute private inventory path.

The playbooks use only ansible-core built-ins. No collection installation is
needed by this configuration. An exact supported ansible-core/Python combination
and Fedora release must still be selected before installation; the dnf module
requires Fedora's matching Python DNF bindings. Using system Python for the guest
does not establish control-node compatibility. Package `state: present` converges
presence; it does not reproduce exact package versions or perform upgrades.

## Outstanding private decisions and prerequisites

| Item | Required evidence before execution |
| --- | --- |
| Fedora releases/toolchain | Supported controller/guest releases; exact Terraform/ansible-core/lint versions and trusted installation sources |
| Provider | Schema validation, real lockfile, release/advisory review, then separately approved PVE 8.4.16 lifecycle test |
| Target placement | Approved node, dedicated pool, unused VM ID, CPU model, storage supporting disks/cloud-init, bridge/VLAN |
| Networking | Reserved unused IPv4/CIDR, gateway/DNS, no production IP/MAC reuse; SSH reachability and firewall policy |
| Template | Image URL/release/checksum/signature, owner/version/VM ID, prepared disk size/firmware, clean identity and functioning agent |
| API access | Separate PVE account/token, exact PVE 8.4 user/token ACLs, verified TLS trust, private token storage/rotation |
| Guest access | Dedicated SSH account/key, trusted host fingerprints, reviewed sudo policy and credential recovery |
| State recovery | Absolute canonical paths, encrypted storage, off-VM encrypted backup method/destination/retention and external key custody |

Do not publish the filled-in table. Keep the approved private execution record
outside the repository. Public examples must remain fictional/placeholders.

## Stages and approval gates

1. Complete credential-free static validation and independent implementation
   review. Tool/provider installation requires separate approval. Commit/push/PR
   actions also require separate approval; none are implied by repository edits.
2. Obtain target-specific approval to create build01 and prepare a source template,
   accounts/keys/TLS trust and ACLs. Follow the [bootstrap runbook](runbooks/fedora-bootstrap.md).
3. Complete the [state backup/restore prerequisite](runbooks/local-state.md).
4. Obtain approval for credentialed read-only discovery, effective-permission
   review and plan. A plan or Ansible check is a live operation when contacting
   hosts/services. Do not test write denial by modifying production.
5. Review the exact new-resource plan and obtain apply approval. Then separately
   approve guest configuration and runtime validation. Follow the
   [lifecycle runbook](runbooks/disposable-vm.md).
6. Review a destroy plan, obtain teardown approval and verify cleanup. Keep
   build01/template outside this state. Template cleanup is a separate operation.

Acknowledgement variables in the configurations are operator error checks, not
authorization. Ansible host aliases and Terraform tags cannot isolate production;
reviewed ACLs, private inventory/identity and explicit scope remain essential.

## Validation record

Local preparation checks passed: Ruby parsing of all three YAML files (including
duplicate-key inspection), Ansible INI parsing, all 39 relative Markdown link
targets, whitespace/final-newline checks across 29 repository files, tracked diff
whitespace checks and dummy private-state/input/plan/inventory ignore checks.
Examples were inspected for placeholders; no real credentials or target values
were introduced. This is manual content review, not proof from a secret scanner.

Independent Reviewer inspected all six tracked modifications and nineteen new
files, reproduced the YAML/link/whitespace checks and reported no actionable
correctness/security findings. Mentor explained the ownership, template,
privilege, state-recovery and provider-validation trade-offs. Both remained
read-only. Favorable review does not establish runtime correctness or approve
execution/integration.

Terraform CLI, ansible-playbook and ansible-lint were unavailable during initial
preparation. Consequently fmt, provider initialization/schema validation,
playbook syntax/lint, dependency lock generation and all runtime checks remain
outstanding. No CI workflow is introduced before its commands/toolchain can be
validated. Future public CI must be credential-free and independent of homelab
connectivity; never attach build01 as an untrusted PR runner.
