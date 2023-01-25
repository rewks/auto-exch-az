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
}

variable "allowed_ports" {
    description = "Ports that external IPs can connect to"
    type = list
}

variable "virtual_network_range" {
    description = "IP range of the lab virtual network"
    type = list
}

variable "subnet_range" {
    description = "IP range of the lab subnet"
    type = list
}

variable "domain_controller_ip" {
    description = "IP to designate to the domain controller"
    type = string
}