variable "node_name" {
  type        = string
  description = "Approved node containing the source template and disposable guest."
}

variable "pool_id" {
  type        = string
  description = "Existing, dedicated disposable resource pool; not created here."
}

variable "vm_id" {
  type        = number
  description = "Explicit unused cluster-wide disposable VM ID."
  validation {
    condition     = var.vm_id >= 100 && var.vm_id <= 999999999 && floor(var.vm_id) == var.vm_id
    error_message = "Use an integer VM ID in the Proxmox range."
  }
}

variable "template_vm_id" {
  type        = number
  description = "Approved clean Fedora cloud-init template, on node_name."
  validation {
    condition     = var.template_vm_id >= 100 && var.template_vm_id <= 999999999 && floor(var.template_vm_id) == var.template_vm_id
    error_message = "Use an integer template ID in the Proxmox range."
  }
}

variable "template_contract_confirmed" {
  type        = bool
  default     = false
  description = "Confirm the documented template preflight. Does not authorize live operations."
}

variable "datastore_id" {
  type        = string
  description = "Approved existing storage supporting clone disks and cloud-init."
}

variable "cpu_type" {
  type        = string
  description = "CPU model verified for the selected Fedora release and Proxmox host."
}

variable "bridge" {
  type        = string
  description = "Approved existing test bridge; Terraform does not manage it."
}

variable "vlan_id" {
  type        = number
  default     = null
  description = "Approved VLAN tag; null only when untagged networking is intended."
  validation {
    condition     = var.vlan_id == null ? true : (var.vlan_id >= 1 && var.vlan_id <= 4094 && floor(var.vlan_id) == var.vlan_id)
    error_message = "Use null or an integer VLAN tag from 1 to 4094."
  }
}

variable "ipv4_address" {
  type        = string
  description = "Reserved, unused static IPv4 address in CIDR notation."
  validation {
    condition     = can(cidrnetmask(var.ipv4_address))
    error_message = "Supply an IPv4 CIDR address."
  }
}

variable "ipv4_gateway" {
  type        = string
  description = "Approved IPv4 gateway."
}

variable "dns_servers" {
  type        = list(string)
  description = "Approved DNS resolver addresses."
  validation {
    condition     = length(var.dns_servers) > 0
    error_message = "Supply at least one approved resolver."
  }
}

variable "automation_user" {
  type        = string
  description = "Dedicated guest automation account with separately reviewed sudo policy."
  validation {
    condition     = can(regex("^[a-z_][a-z0-9_-]*$", var.automation_user)) && var.automation_user != "root"
    error_message = "Supply a non-root Linux account name."
  }
}

variable "ssh_public_key" {
  type        = string
  description = "Dedicated SSH public key only; never generate or supply a private key in Terraform."
  validation {
    condition     = can(regex("^ssh-ed25519 [A-Za-z0-9+/]+={0,3}( .*)?$", trimspace(var.ssh_public_key)))
    error_message = "Supply an OpenSSH Ed25519 public key, not private key material."
  }
}
