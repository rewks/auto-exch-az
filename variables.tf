variable "lab_location" {
    description = "Azure location to deploy lab in"
    type = string
    default = "UK South"
}

variable "resource_prefix" {
    description = "Prefix for resource names"
    type = string
    default = "exchlab"
}

variable "whitelisted_ips" {
    description = "External IPs to be allowed to connect to lab machines"
    type = list
    default = ["*"]
}

variable "allowed_ports" {
    description = "Ports that external IPs can connect to"
    type = list
    default = ["443", "3389"]
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
    default = "10.50.0.10"
}

variable "domain_controller_name" {
    description = "Hostname of the domain controller"
    type = string
    default = "DC01"
}

variable "domain_name" {
    description = "The domain name"
    type = string
    default = "rewks.local"
}

variable "admin_username" {
    description = "Username for the Domain Admin account"
    type = string
    default = "LabAdmin"
}