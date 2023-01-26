resource "azurerm_public_ip" "exch_lab_pip_exch" {
    name = "${var.resource_prefix}-pip-exch"
    resource_group_name = var.resource_group_name
    location = var.lab_location
    allocation_method = "Dynamic"

    tags = {
        environment = "test"
    }
}

resource "azurerm_network_interface" "exch_lab_nic_exch" {
    name = "${var.resource_prefix}-nic-exch"
    resource_group_name = var.resource_group_name
    location = var.lab_location

    ip_configuration {
        name = "nic1"
        subnet_id = var.subnet_id
        private_ip_address_allocation = "Static"
        private_ip_address = var.exchange_server_ip
        public_ip_address_id = azurerm_public_ip.exch_lab_pip_exch.id
    }

    tags = {
        environment = "test"
    }
}

resource "azurerm_storage_account" "exch_lab_sa" {
    name = "exchstorage"
    resource_group_name = var.resource_group_name
    location = var.lab_location
    account_tier = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "test"
    }
}

resource "random_password" "exch_password" {
    length = 16
    special = false
    min_lower = 1
    min_upper = 1
    min_numeric = 1
}

resource "azurerm_windows_virtual_machine" "exch_lab_vm_exch" {
    name = "${var.resource_prefix}-vm-exch"
    resource_group_name = var.resource_group_name
    location = var.lab_location
    size = "Standard_D4_v3"
    admin_username = var.exchange_username
    admin_password = random_password.exch_password.result
    network_interface_ids = [azurerm_network_interface.exch_lab_nic_exch.id]
    computer_name = var.exchange_server_name
    timezone = "UTC"
    custom_data = local.custom_data

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb = 128
        name = "${var.resource_prefix}-osdisk-exch"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2022-datacenter"
        version = "latest"
    }

    additional_unattend_content {
        setting = "AutoLogon"
        content = "<AutoLogon><Password><Value>${random_password.exch_password.result}</Value></Password><Enabled>true</Enabled><LogonCount>1</LogonCount><Username>${var.exchange_username}</Username></AutoLogon>"
    }

    additional_unattend_content {
        setting = "FirstLogonCommands"
        content = local.first_logon_data
    }

    tags = {
        environment = "test"
    }
}

resource "azurerm_virtual_machine_extension" "exch_lab_exch_ext" {
    name = "join-domain"
    virtual_machine_id = azurerm_windows_virtual_machine.exch_lab_vm_exch.id
    publisher = "Microsoft.Compute"
    type = "CustomScriptExtension"
    type_handler_version = "1.9"
    auto_upgrade_minor_version = true
    settings = <<SETTINGS
    {
        "commandToExecute": "powershell.exe -Command \"${local.powershell_command}\""
    }
    SETTINGS
}

data "azurerm_public_ip" "exch_ip" {
    name = azurerm_public_ip.exch_lab_pip_exch.name
    resource_group_name = var.resource_group_name
}