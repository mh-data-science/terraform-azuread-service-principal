output "display_name" {
  value       = azuread_service_principal.main.display_name
  description = "The display name of the Azure AD application."
}

output "application_id" {
  value       = azuread_application.main.id
  description = "The Application ID."
}

output "object_id" {
  value       = azuread_service_principal.main.id
  description = "The Object ID."
}

output "tenant_id" {
  value = data.azurerm_client_config.main.tenant_id
}

output "password" {
  value       = azuread_service_principal_password.main[0].value
  sensitive   = true
  description = "The password for the service principal."
}

output "sdk_auth" {
  value = jsonencode({
    appId       = azuread_application.main.application_id
    password    = azuread_service_principal_password.main[0].value
    name        = azuread_application.main.name
    displayName = azuread_service_principal.main.display_name
    tenant      = data.azurerm_client_config.main.tenant_id
  })
  sensitive   = true
  description = "Output JSON compatible with the Azure SDK auth file."
}
