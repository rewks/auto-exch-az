resource "azurerm_public_ip" "exch_lab_pip_dc" {
    name = "${var.resource_prefix}-pip"
    resource_group_name = var.resource_group_name
    location = var.lab_location
    allocation_method = "Dynamic"

    tags = {
        environment = "test"
    }
}

resource "azurerm_network_interface" "exch_lab_nic_dc" {
    name = "${var.resource_prefix}-nic"
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

resource "random_password" "DA_password" {
    length = 16
    special = false
    min_lower = 1
    min_upper = 1
    min_numeric = 1
}

resource "azurerm_windows_virtual_machine" "exch_lab_vm_dc" {
    name = "${var.resource_prefix}-vm"
    resource_group_name = var.resource_group_name
    location = var.lab_location
    size = "Standard_D1_v2"
    admin_username = var.admin_username
    admin_password = random_password.DA_password.result
    network_interface_ids = [azurerm_network_interface.exch_lab_nic_dc.id]
    computer_name = "DC01"
    timezone = "UTC"

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
        disk_size_gb = 128
        name = "osdisk-owa-lab-DC"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2022-datacenter"
        version = "latest"
    }

    tags = {
        environment = "test"
    }
}