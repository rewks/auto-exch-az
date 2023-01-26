output "exch_ip" {
    description = "Public IP for the exchange server"
    value = data.azurerm_public_ip.exch_ip.ip_address
}