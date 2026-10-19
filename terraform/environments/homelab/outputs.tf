output "ansible_handoff" {
  description = "Private intended address and identity. Verify against the actual guest before inventory use."
  sensitive   = true
  value = {
    vm_id        = proxmox_virtual_environment_vm.disposable.vm_id
    node_name    = var.node_name
    ansible_host = split("/", var.ipv4_address)[0]
    ansible_user = var.automation_user
  }
}
