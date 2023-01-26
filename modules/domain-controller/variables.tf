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

variable "domain_controller_ip" {
    description = "IP to designate to the domain controller"
    type = string
}

variable "domain_controller_name" {
    description = "Hostname of the domain controller"
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

locals {
    dc_fqdn = join(".", [var.domain_controller_name, var.domain_name])
    netbios_name = split(".", var.domain_name)[0]
    auto_logon_data = "<AutoLogon><Password><Value>${var.admin_password}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.admin_username}</Username></AutoLogon>"
    first_logon_data = file("${path.module}/files/FirstLogonCommands.xml")
    custom_data = base64encode(join(" ", ["Param($RemoteHostName = \"${local.dc_fqdn}\", $ComputerName = \"${var.domain_controller_name}\")", file("${path.module}/files/winrm.ps1")]))

    password_command     = "$password = ConvertTo-SecureString ${var.admin_password} -AsPlainText -Force"
    install_ad_command   = "Install-WindowsFeature -name AD-Domain-Services -IncludeManagementTools"
    configure_ad_command = "Install-ADDSForest -DomainName ${var.domain_name} -DomainNetBIOSName ${local.netbios_name} -SafeModeAdministratorPassword $password -CreateDNSDelegation:$false -InstallDNS:$true -Force:$true"
    exit_code_hack       = "exit 0"
    powershell_command   = "${local.password_command}; ${local.install_ad_command}; ${local.configure_ad_command}; ${local.exit_code_hack}"
}