output "dc_ip" {
    description = "Public IP for the domain controller"
    value = data.azurerm_public_ip.dc_ip.ip_address
}