data "azurerm_subnet" "subnet-1" {
    name                    = "${var.ade_owner}-ADE-Example-Subnet-1"
    virtual_network_name    = azurerm_virtual_network.vnet.name 
    resource_group_name     = azurerm_resource_group.ade_example.name 

    depends_on = [ azurerm_virtual_network.vnet ]
}

data "azurerm_subnet" "subnet-2" {
    name                    = "${var.ade_owner}-ADE-Example-Subnet-2"
    virtual_network_name    = azurerm_virtual_network.vnet.name 
    resource_group_name     = azurerm_resource_group.ade_example.name 

    depends_on = [ azurerm_virtual_network.vnet ]
}

resource "azurerm_windows_virtual_machine" "vm-1" {

    name                = "${var.ade_owner}-ADE-Example-VM"
    computer_name       = "ADE-Example-VM"
    resource_group_name = azurerm_resource_group.ade_example.name
    location            = var.ade_location

    size                = "Standard_B2ms"

    admin_username      = "adminuser"
    admin_password      = "Pa55W0rd!1234"

    network_interface_ids = [ azurerm_network_interface.nic-1.id]

    os_disk {
      caching = "ReadWrite"
      storage_account_type = "StandardSSD_LRS"
    }

    source_image_reference {
      publisher = "MicrosoftWindowsServer"
      offer     = "WindowsServer"
      sku       = "2016-Datacenter"
      version   = "latest"
    }
}

resource "azurerm_public_ip" "ip-1" {
    name = "${var.ade_owner}-ADE-Example-IP-1"
    resource_group_name = azurerm_resource_group.ade_example.name
    location            = var.ade_location

    allocation_method = "Static"
}

resource "azurerm_network_interface" "nic-1" {
    name                = "${var.ade_owner}-ADE-Example-NIC-1"
    resource_group_name = azurerm_resource_group.ade_example.name
    location            = var.ade_location

    ip_configuration {
      name = "external"
      subnet_id = data.azurerm_subnet.subnet-1.id
      private_ip_address_allocation = "Dynamic"

      public_ip_address_id = azurerm_public_ip.ip-1.id
    }
}

resource "azurerm_virtual_machine_extension" "vme" {
  name                 = "AzureDiskEncryption"
  virtual_machine_id = azurerm_windows_virtual_machine.vm-1.id
  publisher            = "Microsoft.Azure.Security"
  type                 = "AzureDiskEncryption"
  type_handler_version = "2.2" 

  settings = <<SETTINGS
    {
        "EncryptionOperation": "EnableEncryption",
        "KeyVaultURL": "${azurerm_key_vault.kv.vault_uri}",
        "KeyVaultResourceId": "${azurerm_key_vault.kv.id}",
        "KeyEncryptionKeyURL": "${azurerm_key_vault_key.key.id}",
        "KekVaultResourceId": "${azurerm_key_vault.kv.id}",
        "VolumeType": "All" 
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
        "AADClientID": "${data.azurerm_client_config.current.client_id}" 
    }
PROTECTED_SETTINGS

  auto_upgrade_minor_version = true
}
