data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = var.sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = var.secret_permissions
  }

  dynamic "access_policy" {
    for_each = var.additional_access_policies
    content {
      tenant_id = access_policy.value.tenant_id
      object_id = access_policy.value.object_id
      secret_permissions = access_policy.value.secret_permissions
    }
  }

  tags = var.tags
}

resource "random_password" "secrets" {
  for_each = var.secrets
  length   = each.value.length
  special  = each.value.special
}

resource "azurerm_key_vault_secret" "secrets" {
  for_each     = var.secrets
  name         = each.key
  value        = random_password.secrets[each.key].result
  key_vault_id = azurerm_key_vault.main.id
}