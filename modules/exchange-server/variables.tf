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

variable "exchange_server_ip" {
    description = "IP to designate to the exchange server"
    type = string
}

variable "exchange_server_name" {
    description = "Hostname of the exchange server"
    type = string
}

variable "domain_name" {
    description = "The domain name"
    type = string
}

variable "admin_username" {
    description = "Username for the Domain Admin account"
    type = string
}

variable "admin_password" {
    description = "Password for the Domain Admin account"
    type = string
    sensitive = true
}

variable "exchange_username" {
    description = "Local admin account on exchange server"
    type = string
    default = "ExchAdmin"
}

locals {
    first_logon_data = file("${path.module}/files/FirstLogonCommands.xml")
    custom_data = base64encode(join(" ", ["Param($RemoteHostName = \"${local.exch_fqdn}\", $ComputerName = \"${var.exchange_server_name}\")", file("${path.module}/files/winrm.ps1")]))

    wait_for_domain = "while (!(Test-Connection -ComputerName ${var.domain_name} -Count 1 -Quiet) -and ($retryCount++ -le 200)) { Start-Sleep 5 }"
    exit_code = "exit 0"
    powershell_command = "${local.wait_for_domain}; ${local.exit_code}"
}