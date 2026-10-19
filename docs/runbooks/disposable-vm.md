# Disposable guest lifecycle

## Scope

Prepared procedure, not a tested or authorized live workflow. Target exactly one
new disposable guest; exclude build01, the source template and all production
VMs/services. All commands below require their applicable approvals and tools.
Do not execute the runbook merely because it is committed.

## Preflight

Complete the [milestone prerequisites](../milestone-disposable-vm.md),
[bootstrap/template contract](fedora-bootstrap.md) and
[state recovery prerequisites](local-state.md). Review the provisional provider
pin and lockfile, effective token ACLs, trusted API TLS, unused destination ID,
reserved IP and exact source/destination identities privately. Read-only API
queries and credentialed plans need approval too.

Keep `PROXMOX_VE_ENDPOINT` and `PROXMOX_VE_API_TOKEN` in a scoped private process
environment. Use the approved secret manager/injection method, not command-line
token literals or shell-history exports. Ensure password/ticket/node-SSH/root-ticket
environment settings cannot override the intended authentication. Disable Terraform
debug/trace logging and avoid outputting the environment. Do not weaken TLS checks.

Use the default workspace, explicit private backend and `TF_DATA_DIR` as described
in the state runbook for **all** commands. Fill a private tfvars copy and confirm
the template contract only after evidence exists. This boolean is not approval.

## Plan and provision

From the repository root, after approved credentialed planning:

```sh
terraform -chdir=terraform/environments/homelab plan \
  -var-file=/REPLACE_PRIVATE_DIRECTORY/disposable.tfvars \
  -out=/REPLACE_PRIVATE_DIRECTORY/create.tfplan
terraform -chdir=terraform/environments/homelab show \
  /REPLACE_PRIVATE_DIRECTORY/create.tfplan
```

Inspect privately: exactly `proxmox_virtual_environment_vm.disposable` is added,
with the correct ID/node/pool/source/storage/network/key/account; no production
updates/deletions, migration, node commands or unexpected inherited devices.
Review implicit clone disk creation and storage capacity, not just resource count.
Confirm template identity/disk/firmware assumptions and the planned agent behavior.
Saved plans contain private values; do not share their full output publicly.

Describe expected VM/disk creation and recovery, then obtain approval to apply
that saved plan. If scope changes, regenerate/review/reapprove it. Apply only the
reviewed file, then back up the resulting state:

```sh
terraform -chdir=terraform/environments/homelab apply \
  /REPLACE_PRIVATE_DIRECTORY/create.tfplan
```

On timeout/failure, inspect tasks and state under approved access. A failed apply
can leave a VM/disks. Do not blindly retry, force-unlock or manually delete a
resource. No broad `-target`, import or state manipulation is a normal recovery step.

## Private inventory and Ansible

Read `ansible_handoff` privately using `terraform output -json ansible_handoff`
with the same root/data/backend context. It describes the **intended** IP/user,
not proof the guest actually received them. Compare with Proxmox console and guest
identity. Copy the example inventory outside the checkout, insert the intended
address/user, key path and dedicated known_hosts path. Record `/etc/machine-id`
from trusted console as `expected_machine_id`; verify SSH fingerprints through
that console before adding them. `ssh-keyscan` alone is not identity verification.

Review actual cloud-init account/sudo policy. Interactive `--ask-become-pass` is
the proposed default; configure its sudo password privately through approved
bootstrap access if needed, never in inventory or Terraform/cloud-init input.
SSH keys authorize login, not sudo. Do not assume a locked cloud-image account
can supply a sudo password or that broad NOPASSWD rules are acceptable.

After approval for guest configuration, from `ansible/`:

```sh
ansible-playbook -i /REPLACE_PRIVATE_DIRECTORY/hosts.yml disposable.yml \
  --limit iac-disposable-01 --ask-become-pass \
  -e disposable_configuration_confirmed=true
```

The playbook checks console-approved machine identity, waits for cloud-init,
requires Fedora/enforcing SELinux/running firewalld, and installs/configures nginx.
HTTP listens only on 127.0.0.1; the URI check executes inside the guest. No external
HTTP reachability is promised or required. Package repositories are contacted
during installation. No credentials or private keys are written through Terraform.

Ansible check mode still contacts the guest, runs the identity read and gathers
facts; it requires live approval. First-install check mode may be incomplete
when nginx is absent; it is not a substitute for a real authorized run.

## Acceptance and teardown

- Repeat Ansible after the first successful run: expect zero changes. Verify the
  page, loopback listener, SELinux and firewall. Inspect warnings rather than
  hiding them. Compare machine ID/SSH fingerprints with trusted records.
- Obtain approval for one test-guest reboot, verify guest-agent/SSH/cloud-init
  recovery, page response and enabled service. No production reboot belongs here.
- Run a separately authorized Terraform plan: expect no changes. Document actual
  provider 0.117.0/PVE 8.4.16 results and any drift before claiming compatibility.
- To remove the guest, generate and privately inspect a saved destroy plan:

  ```sh
  terraform -chdir=terraform/environments/homelab plan -destroy \
    -var-file=/REPLACE_PRIVATE_DIRECTORY/disposable.tfvars \
    -out=/REPLACE_PRIVATE_DIRECTORY/destroy.tfplan
  terraform -chdir=terraform/environments/homelab show \
    /REPLACE_PRIVATE_DIRECTORY/destroy.tfplan
  ```

  Confirm only the disposable guest/disks are removed. Describe the target,
  effects and checks, obtain teardown approval, then apply that exact saved plan.
  Verify Proxmox cleanup and empty guest ownership in state; retain a private
  final state backup. Controller/template must remain present. Clean stale
  inventory/known_hosts entries only for the confirmed destroyed guest.
- A later approved recreate test should produce a fresh machine ID and SSH keys;
  reverify them rather than disabling host-key checks. Destroy/recreate is a
  suitable recovery for a data-free test guest, never an automatic production fix.

This sequence validates provisioning, configuration, convergence, persistence
and cleanup separately. None has been executed during repository preparation.
