# 0001: Bootstrap controller and disposable VM ownership

Date: 2026-10-19
Status: accepted

## Context

The first practical milestone needs a controller before it can run automation.
Existing production guests and services must remain untouched. There is no tested
provisioning workflow yet. The user approved these boundaries in principle.

## Alternatives

- Manage the controller in the experiment's state: creates a recovery dependency
  and permits accidental destruction of the runner holding the state.
- Introduce Packer and a reusable module immediately: adds another lifecycle before
  a single guest has been demonstrated.
- Couple guest configuration to Terraform provisioners: makes SSH/configuration
  failures part of infrastructure lifecycle recovery.

## Decision

Manually create headless Fedora Server build01 with 2 vCPU, 4 GiB RAM and 40 GiB
disk. Keep it outside this Terraform root. Use a dedicated automation account and
SSH keys, with sudo policy explicitly reviewed before use. The control-node
playbook maintains baseline packages over SSH after manual bootstrap; it does not
install Terraform or Ansible, create accounts or grant sudo.

Terraform owns one full-cloned disposable guest, including its cloned disks and
cloud-init disk. Ansible owns its demonstration service. Cloud-init establishes
initial access and networking, not ongoing service configuration. There are no
Terraform provisioners. Packer is deferred; the operator temporarily owns template
preparation and immutable version records through the bootstrap runbook.

No Kubernetes or Flux operations belong to this milestone. Existing platform
bootstrap remains uninspected and must be understood before future integration.

## Consequences and validation

Manual bootstrap and template preparation must be recoverable from outside the
controller. Same-node cloning avoids cross-node migration behavior. The guest
inherits the template's prepared disk rather than resizing it during cloning.
The guest's proposed 20 GiB disk therefore belongs to the template contract;
its final size/release remain to be agreed. HTTP binds only to loopback for this
increment, avoiding an unapproved network exposure rule. Service verification
runs inside the guest over Ansible SSH.

Configuration acknowledgements and identity checks reduce operator mistakes;
they are not authorization boundaries. SSH/become can execute arbitrary code on
an incorrectly selected host. Live approval and inventory review remain required.
Implementation and live validation status are recorded in the milestone guide.
