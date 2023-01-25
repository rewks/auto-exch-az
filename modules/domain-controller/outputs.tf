output "dc_ip" {
    description = "Public IP for the domain controller"
    value = azurerm_public_ip.exch_lab_pip_dc.ip_address
}