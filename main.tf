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

resource "azurerm_storage_account" "sa_owa" {
    name = "sa-OWA-lab-${random_id.deployment_id.hex}"
    resource_group_name = azurerm_resource_group.rg_owa.name
    location = azurerm_resource_group.rg_owa.location
    access_tier = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "test"
    }
}

