output "DC01 IP: " {
    value = module.domain-controller.dc_ip
}

output "DA User: " {
    value = var.admin_username
}

output "DA Pass: " {
    value = module.domain-controller.da_password
}