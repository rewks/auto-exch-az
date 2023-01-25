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

variable "whitelisted_ips" {
    description = "External IPs to be allowed to connect to lab machines"
    type = list
    default = ["*"]
}

variable "allowed_ports" {
    description = "Ports that external IPs can connect to"
    type = list
    default = ["443", "3389", "5985"]
}

variable "virtual_network_range" {
    description = "IP range of the lab virtual network"
    type = list
    default = ["10.50.0.0/24"]
}

variable "subnet_range" {
    description = "IP range of the lab subnet"
    type = list
    default = ["10.50.0.0/27"]
}

variable "domain_controller_ip" {
    description = "IP to designate to the domain controller"
    type = string
}