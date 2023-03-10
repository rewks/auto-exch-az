resource "azurerm_public_ip" "exch_lab_pip_dc" {
    name = "${var.resource_prefix}-pip-dc"
    resource_group_name = var.resource_group_name
    location = var.lab_location
    allocation_method = "Static"

    tags = {
        environment = "test"
    }
}

resource "azurerm_network_interface" "exch_lab_nic_dc" {
    name = "${var.resource_prefix}-nic-dc"
    resource_group_name = var.resource_group_name
    location = var.lab_location

    ip_configuration {
        name = "nic1"
        subnet_id = var.subnet_id
        private_ip_address_allocation = "Static"
        private_ip_address = var.domain_controller_ip
        public_ip_address_id = azurerm_public_ip.exch_lab_pip_dc.id
    }

    tags = {
        environment = "test"
    }
}

resource "azurerm_windows_virtual_machine" "exch_lab_vm_dc" {
    name = "${var.resource_prefix}-vm-dc"
    resource_group_name = var.resource_group_name
    location = var.lab_location
    size = "Standard_D2as_v4"
    admin_username = var.admin_username
    admin_password = var.admin_password
    network_interface_ids = [azurerm_network_interface.exch_lab_nic_dc.id]
    computer_name = var.domain_controller_name
    timezone = "UTC"
    custom_data = local.custom_data

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb = 128
        name = "${var.resource_prefix}-osdisk-dc"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2022-datacenter"
        version = "latest"
    }

    additional_unattend_content {
        setting = "AutoLogon"
        content = local.auto_logon_data
    }

    additional_unattend_content {
        setting = "FirstLogonCommands"
        content = local.first_logon_data
    }

    tags = {
        environment = "test"
    }
}

resource "azurerm_virtual_machine_extension" "exch_lab_dc_ext" {
    name = "create-ad-forest"
    virtual_machine_id = azurerm_windows_virtual_machine.exch_lab_vm_dc.id
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