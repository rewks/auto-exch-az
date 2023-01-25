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

resource "azurerm_resource_group" "exch_lab_rg" {
    name = "${var.exchlab}-rg"
    location = var.lab_location

    tags = {
        environment = "test"
    }
}

module "network" {
    source = "./modules/network"
    lab_location = var.lab_location
    resource_prefix = var.resource_prefix
    resource_group_name = azurerm_resource_group.exch_lab_rg.name
    whitelisted_ips = var.whitelisted_ips
    allowed_ports = var.allowed_ports
    virtual_network_range = var.virtual_network_range
    subnet_range = var.subnet_range
}

resource "azurerm_storage_account" "sa_owa" {
    name = "saowalab"
    resource_group_name = azurerm_resource_group.rg_owa.name
    location = azurerm_resource_group.rg_owa.location
    account_tier = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "test"
    }
}

resource "azurerm_public_ip" "pip_owa_domain_controller" {
    name = "pip-owa-lab-DC"
    resource_group_name = azurerm_resource_group.rg_owa.name
    location = azurerm_resource_group.rg_owa.location
    allocation_method = "Dynamic"

    tags = {
        environment = "test"
    }
}

resource "azurerm_network_interface" "nic_owa_domain_controller" {
    name = "nic-owa-lab-DC"
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
    name = "vm-owa-lab-DC"
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
        name = "osdisk-owa-lab-DC"
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