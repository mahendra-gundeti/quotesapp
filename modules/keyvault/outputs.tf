output "key_vault_id" {
  value       = azurerm_key_vault.main.id
  description = "ID of the Key Vault"
}

output "key_vault_name" {
  value       = azurerm_key_vault.main.name
  description = "Name of the Key Vault"
}

output "key_vault_uri" {
  value       = azurerm_key_vault.main.vault_uri
  description = "URI of the Key Vault"
}

output "secret_names" {
  value       = keys(azurerm_key_vault_secret.secrets)
  description = "Names of the secrets stored in Key Vault"
}

output "secret_values" {
  value       = { for k, v in azurerm_key_vault_secret.secrets : k => v.value }
  description = "Secret values from Key Vault"
  sensitive   = true
}