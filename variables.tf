variable "virtual_network_range" {
    description = "IP range of the lab virtual network"
    type = list
    default = ["10.50.0.0/24"]
}

variable "lab_location" {
    description = "Azure location to deploy lab in"
    type = string
    default = "UK South"
}