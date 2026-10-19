# Bootstrap build01 and the Fedora source template

## Scope and authorization

This procedure is prepared, not executed. Creating VMs, changing accounts/ACLs,
installing tools and contacting hosts each need the applicable separate approval.
Identify the two new VM IDs and target storage/network privately first. Existing
production VMs, templates and services are excluded. Abort on a target mismatch.

## Controller bootstrap

1. Select a supported Fedora Server release and trusted download source. Verify
   the ISO signature and checksum. Record version/checksum privately.
2. Through the Proxmox console, manually create **build01**, headless, with
   **2 vCPU / 4 GiB RAM / 40 GiB disk**, approved firmware/CPU/network/storage.
   Select a minimal installation with console recovery; no desktop is needed.
3. Agree disk encryption, unlock/key custody and reboot recovery. Install the OS,
   establish DNS/time and the private management address, retain enforcing SELinux
   and firewalld, and allow SSH only from approved management sources. Verify
   reachability from a trusted client before tightening access.
4. Create the dedicated non-root automation account and install its approved
   public key through trusted console/admin access. Privately record machine ID and host-key
   fingerprints and install verified entries in a dedicated known_hosts file.
   Never globally disable host-key checking or forward the SSH agent to guests.
5. Review sudo before granting it: Ansible package/file/service modules execute
   arbitrary privileged Python, so a short command allowlist is not meaningful
   confinement. Prefer an explicitly approved password-prompted administrative
   grant for this interactive workflow, supplied with `--ask-become-pass`; any
   passwordless grant must be separately accepted as root-equivalent. Review
   cloud-image default sudo rules too. Keep an independent console admin route.
6. Approve exact supported Terraform, ansible-core and lint versions, Python
   compatibility and signed/trusted installation sources. Do not pipe an
   unreviewed installer into a shell. Install only after approval and record
   versions. No tool installation command is automated by this repository yet.
7. Clone the public repository and select the reviewed revision. Place private
   inventory/inputs/state/working directories outside the checkout. With approved
   host identity/machine ID and package installation scope, the control-node playbook can
   maintain baseline Git/Python/SSH-client packages. It does not create accounts,
   edit sudoers, install Terraform/Ansible or change firewall policy.

From `ansible/`, after authorization and tool availability:

```sh
ansible-playbook -i /REPLACE_PRIVATE_DIRECTORY/hosts.yml control-node.yml \
  --limit build01 --ask-become-pass \
  -e build_configuration_confirmed=true
```

If the same build01 invokes this playbook over SSH to itself, its public key and
verified host key must still be established. No local connection bypass is assumed.
Confirm actual machine sizing, headless boot, SSH, enforcing SELinux, firewall,
time/DNS and reboot/unlock recovery. Keep credentials out of terminal recordings.

## Source template contract

Prefer a new, versioned Fedora Cloud image/template on the **same target node**.
Use the [official downloads and signature/checksum procedure](https://fedoraproject.org/cloud/download/).
Do not reuse or modify an existing production template to satisfy this contract.

Under separately approved preparation scope:

- Record the selected image release, source, verified digest/signature, architecture,
  firmware, CPU requirements and template ID. Agree the guest disk size (proposed
  20 GiB); Terraform inherits it and does not resize it in this increment.
- Ensure cloud-init, Python 3 with DNF bindings, qemu-guest-agent, SELinux tooling
  and firewalld are installed and enabled appropriately. Verify the guest agent
  actually works before enabling Terraform's agent wait.
- Ensure one intended NIC and the expected boot disk/cloud-init interface. Remove
  custom cloud-init snippets, extra disks/NICs, passthrough, hooks, inherited
  production MAC/IP settings, credentials, authorized keys and sudo surprises.
- Verify native Proxmox cloud-init creates the intended user/key/network on the
  chosen Fedora release. It may create passwordless sudo: explicitly review and
  remediate via trusted bootstrap access before running privileged Ansible.
- Prepare first-boot regeneration of machine ID, SSH host keys and cloud-init
  instance state using the chosen release's documented image-cleaning procedure.
  Do not prescribe unverified destructive cleaning commands on a real host.
  Shut down before converting the new preparation VM into an immutable template.
- During authorized disposable testing, compare identities across sequential
  destroy/recreate cycles: machine IDs and host keys must differ. Keep evidence
  privately; reverify known_hosts entries through console before each new guest.

This template remains manually owned until a later Packer milestone. Record how
to rebuild it; do not mutate it in place after validation. Missing contract
evidence blocks `template_contract_confirmed=true`.

## API identity and rollback

Create the PVE API account/token separately from the Linux guest account. Agree
privilege-separated user/token ACLs for PVE 8.4, template clone/read, destination
VM/pool, storage and necessary network/audit reads. Review production exclusion
and token revocation. Trust the API certificate/CA on build01. Terraform needs no
node SSH, root password, node sudo or root-ticket feature.

Recovery: retain console access; stop on SSH/sudo/identity surprises. Revocation
affects the new token/key, not existing identities. Removing new bootstrap VMs or
templates requires reviewed targets and explicit approval. Never delete a template
while its dependent test workflow is still being assessed. Controller loss is
handled through the [state recovery procedure](local-state.md), not a blind VM revert.
