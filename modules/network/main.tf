resource "azurerm_virtual_network" "exch_lab_vn" {
    name = "${var.resource_prefix}-vn"
    address_space = var.virtual_network_range
    dns_servers = [var.domain_controller_ip, "8.8.8.8"]
    resource_group_name = var.resource_group_name
    location = var.lab_location

    tags = {
        environment = "test"
    }
}

resource "azurerm_subnet" "exch_lab_sn" {
    name = "${var.resource_prefix}-sn"
    address_prefixes = var.subnet_range
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.exch_lab_vn.name
}

resource "azurerm_network_security_group" "exch_lab_sg" {
    name = "${var.resource_prefix}-sg"
    resource_group_name = var.resource_group_name
    location = var.lab_location

    tags = {
        environment = "test"
    }
}

resource "azurerm_network_security_rule" "exch_lab_sr" {
    name = "${var.resource_prefix}-sr"
    resource_group_name = var.resource_group_name
    network_security_group_name = azurerm_network_security_group.exch_lab_sg.name

    priority = 200
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefixes = var.whitelisted_ips
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_ranges = var.allowed_ports
}