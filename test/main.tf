variable "location" {
  type    = string
  default = "westeurope"
}

resource "random_id" "test" {
  byte_length = 4
}

resource "azurerm_resource_group" "test" {
  name     = format("test-%s", random_id.test.hex)
  location = var.location
}

module "service_principal" {
  source = "../"

  name = format("test-%s", random_id.test.hex)

  end_date = "1W"

  role = "Contributor"

  scopes = [azurerm_resource_group.test.id]
}

data "azuread_application" "test" {
  name = module.service_principal.name
}

module "test_assertions" {
  source = "innovationnorway/assertions/test"
  equals = [
    {
      name = "has identifier URIs"
      got  = length(data.azuread_application.test.identifier_uris)
      want = 1
    }
  ]
}
