variable "lab_location" {
    description = "Azure location to deploy lab in"
    type = string
}

variable "resource_prefix" {
    description = "Prefix for resource names"
    type = string
}

variable "resource_group_name" {
    description = "Name of the resource group created for the lab"
    type = string
}

variable "subnet_id" {
  description = "ID of subnet created for the lab"
  type = string
}

variable "domain_controller_ip" {
    description = "IP to designate to the domain controller"
    type = string
    default = "10.50.0.10"
}

variable "admin_username" {
    description = "Username for the Domain Admin account"
    type = string
}