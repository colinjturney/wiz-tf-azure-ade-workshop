data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
    name                    = "${var.ade_owner}-ADE-KV"
    location                = var.ade_location
    resource_group_name     = azurerm_resource_group.ade_example.name
    tenant_id               = data.azurerm_client_config.current.tenant_id

    sku_name                        = "standard"
    purge_protection_enabled        = true
    enabled_for_disk_encryption     = true
    public_network_access_enabled   = true
    enable_rbac_authorization       = true

    network_acls {
      bypass = "AzureServices"
      default_action = "Deny"
      virtual_network_subnet_ids = [ data.azurerm_subnet.subnet-1.id, data.azurerm_subnet.subnet-2.id ]
      ip_rules = [ var.ade_ingress_prefix ]
    }
}

resource "azurerm_key_vault_key" "key" {
    name         = "${var.ade_owner}-ADE-Example-VM-Encryption-Key-2"
    key_vault_id = azurerm_key_vault.kv.id
    key_type     = "RSA"
    key_size     = 2048
    key_opts = [
        "encrypt",
        "decrypt",
        "wrapKey",
        "unwrapKey"
    ]

    depends_on = [ azurerm_role_assignment.user ]
}


resource "azurerm_role_assignment" "user" {
  scope                = azurerm_key_vault.kv.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id

}