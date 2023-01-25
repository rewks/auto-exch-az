output "DC01_IP" {
    value = module.domain-controller.dc_ip
}

output "DA_User" {
    value = var.admin_username
}

output "DA_Pass" {
    value = module.domain-controller.da_password
}