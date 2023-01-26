output "exch_ip" {
    description = "Public IP for the exchange server"
    value = azurerm_public_ip.exch_lab_pip_exch.ip_address
}