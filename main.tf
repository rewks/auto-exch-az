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

resource "random_id" "resource_group_id" {
    byte_length = 8
}

resource "azurerm_resource_group" "rg_owa" {
    name = "rg-OWA-lab-${random_id.resource_group_id.hex}"
    location = "UK South"

    tags = {
        environment = "test"
    }
}

