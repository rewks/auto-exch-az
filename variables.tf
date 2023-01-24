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

variable "lab_location" {
    description = "Azure location to deploy lab in"
    type = string
    default = "UK South"
}

variable "admin_password" {
    description = "Password for the Domain Admin account"
    sensitive = true
    type = string

    validation {
        condition = length(var.admin_password) >= 8
        error_message = "Password must be 8+ characters"
    }

    validation {
        condition = can(regex("[A-Z]", var.admin_password))
        error_message = "Password must contain at least 1 upper case letter"
    }

    validation {
        condition = can(regex("[a-z]", var.admin_password))
        error_message = "Password must contain at least 1 lower case letter"
    }

    validation {
        condition = can(regex("\\d", var.admin_password))
        error_message = "Password must contain at least 1 numeric character"
    }
}