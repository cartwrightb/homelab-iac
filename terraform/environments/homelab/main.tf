# This root owns ONE disposable guest, never build01 or the source template.
resource "proxmox_virtual_environment_vm" "disposable" {
  name        = "iac-disposable-01"
  description = "Disposable Terraform and Ansible learning guest"
  tags        = ["terraform", "disposable"]
  node_name   = var.node_name
  pool_id     = var.pool_id
  vm_id       = var.vm_id
  on_boot     = false
  started     = true

  # Same-node full clone. Inherit the prepared template's disk and firmware.
  # No disk resize, image upload, migration, snippet or node SSH operation.
  clone {
    vm_id        = var.template_vm_id
    full         = true
    datastore_id = var.datastore_id
  }

  cpu {
    cores = 2
    type  = var.cpu_type
  }

  memory {
    dedicated = 2048
  }

  agent {
    enabled = true
    wait_for_ip {
      ipv4 = true
    }
  }

  network_device {
    bridge  = var.bridge
    vlan_id = var.vlan_id
  }

  initialization {
    datastore_id = var.datastore_id
    dns {
      servers = var.dns_servers
    }
    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
    }
    user_account {
      username = var.automation_user
      keys     = [trimspace(var.ssh_public_key)]
    }
  }

  lifecycle {
    precondition {
      condition     = var.template_contract_confirmed && var.vm_id != var.template_vm_id
      error_message = "Confirm the template contract and use a distinct, unused disposable VM ID. This is not live-operation approval."
    }
  }
}
