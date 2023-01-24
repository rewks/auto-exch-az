terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.40.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "random_id" "deployment_id" {
    byte_length = 8
}

resource "azurerm_resource_group" "rg_owa" {
    name = "rg-OWA-lab-${random_id.deployment_id.hex}"
    location = var.lab_location

    tags = {
        environment = "test"
    }
}

resource "azurerm_virtual_network" "vn_owa" {
    name = "vn-OWA-lab-${random_id.deployment_id.hex}"
    address_space = var.virtual_network_range
    dns_servers = [var.domain_controller_ip]
    resource_group_name = azurerm_resource_group.rg_owa.name
    location = azurerm_resource_group.rg_owa.location

    tags = {
        environment = "test"
    }
}

resource "azurerm_subnet" "sn_owa" {
    name = "sn-OWA-lab-${random_id.deployment_id.hex}"
    address_prefixes = var.subnet_range
    resource_group_name = azurerm_resource_group.rg_owa.name
    virtual_network_name = azurerm_virtual_network.vn_owa.name
}

resource "azurerm_network_security_group" "sg_owa" {
    name = "sg-OWA-lab-${random_id.deployment_id.hex}"
    resource_group_name = azurerm_resource_group.rg_owa.name
    location = azurerm_resource_group.rg_owa.location

    tags = {
        environment = "test"
    }
}

resource "azurerm_network_security_rule" "sr_owa" {
    name = "sr-OWA-lab-${random_id.deployment_id.hex}"
    resource_group_name = azurerm_resource_group.rg_owa.name
    network_security_group_name = azurerm_network_security_group.sg_owa.name

    priority = 200
    direction = "Inbound"
    access = "Allow"
    protocol = "Tcp"
    source_address_prefixes = var.whitelisted_ips
    source_port_range = "*"
    destination_address_prefix = "*"
    destination_port_ranges = var.allowed_ports
}

resource "azurerm_storage_account" "sa_owa" {
    name = "sa-OWA-lab-${random_id.deployment_id.hex}"
    resource_group_name = azurerm_resource_group.rg_owa.name
    location = azurerm_resource_group.rg_owa.location
    account_tier = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "test"
    }
}

resource "azurerm_public_ip" "pip_owa_domain_controller" {
    name = "pip-OWA-lab-DC-${random_id.deployment_id.hex}"
    resource_group_name = azurerm_resource_group.rg_owa.name
    location = azurerm_resource_group.rg_owa.location
    allocation_method = "Dynamic"

    tags = {
        environment = "test"
    }
}

resource "azurerm_network_interface" "nic_owa_domain_controller" {
    name = "nic-OWA-lab-DC-${random_id.deployment_id.hex}"
    resource_group_name = azurerm_resource_group.rg_owa.name
    location = azurerm_resource_group.rg_owa.location

    ip_configuration {
        name = "nic1"
        subnet_id = azurerm_subnet.sn_owa.id
        private_ip_address_allocation = "Static"
        private_ip_address = var.domain_controller_ip
        public_ip_address_id = azurerm_public_ip.pip_owa_domain_controller.id
    }

    tags = {
        environment = "test"
    }
}

resource "azurerm_windows_virtual_machine" "vm_owa_domain_controller" {
    name = "vm-OWA-lab-DC-${random_id.deployment_id.hex}"
    resource_group_name = azurerm_resource_group.rg_owa.name
    location = azurerm_resource_group.rg_owa.location
    size = "Standard_D1_v2"
    admin_username = "LabAdmin"
    admin_password = var.admin_password
    network_interface_ids = [azurerm_network_interface.nic_owa_domain_controller.id]
    computer_name = "DC01"
    timezone = "UTC"

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb = 128
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2022-datacenter"
        version = "latest"
    }

    tags = {
        environment = "test"
    }
}