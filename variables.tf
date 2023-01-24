variable "whitelisted_ips" {
    description = "External IPs to be allowed to connect to lab machines via RDP and HTTPS"
    type = list
    default = ["*"]
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

variable "lab_location" {
    description = "Azure location to deploy lab in"
    type = string
    default = "UK South"
}