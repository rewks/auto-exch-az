output "da_password" {
    description = "Password for the domain admin account"
    value = random_password.DA_password.result
}