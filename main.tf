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
    name = "${var.resource_prefix}-rg"
    location = var.lab_location

    tags = {
        environment = "test"
    }
}

resource "random_password" "DA_password" {
    length = 16
    special = false
    min_lower = 1
    min_upper = 1
    min_numeric = 1
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
    domain_controller_ip = var.domain_controller_ip
}

module "domain-controller" {
    source = "./modules/domain-controller"
    lab_location = var.lab_location
    resource_prefix = var.resource_prefix
    resource_group_name = azurerm_resource_group.exch_lab_rg.name
    subnet_id = module.network.subnet_id
    domain_controller_ip = var.domain_controller_ip
    domain_controller_name = var.domain_controller_name
    domain_name = var.domain_name
    admin_username = var.admin_username
    admin_password = random_password.DA_password.result
}

module "exchange-server" {
    source = "./modules/exchange-server"
    lab_location = var.lab_location
    resource_prefix = var.resource_prefix
    resource_group_name = azurerm_resource_group.exch_lab_rg.name
    subnet_id = module.network.subnet_id
    exchange_server_ip = var.exchange_server_ip
    exchange_server_name = var.exchange_server_name
    domain_name = var.domain_name
    admin_username = var.admin_username
    admin_password = random_password.DA_password.result
}