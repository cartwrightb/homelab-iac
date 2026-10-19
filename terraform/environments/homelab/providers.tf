# Supply PROXMOX_VE_ENDPOINT and PROXMOX_VE_API_TOKEN privately at runtime.
# Do not supply password, ticket or node SSH credentials. Trust the API CA first.
provider "proxmox" {
  insecure = false
}
