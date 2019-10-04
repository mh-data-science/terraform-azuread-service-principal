# Azure AD Service Principal

> ⚠️ **Warning**: This module will happily expose service principal credentials. All arguments including the service principal password will be persisted into Terraform state, into any plan files, and in some cases in the console output while running `terraform plan` and `terraform apply`. Read more about [sensitive data in state](https://www.terraform.io/docs/state/sensitive-data.html).

Create a service principal and configure it's access to Azure resources.

## Example Usage

### Basic example

```hcl
module "service_principal" {
  source   = "innovationnorway/service-principal/azuread"
  name     = "example"
  end_date = "2Y"
}

output "service_principal" {
  value = module.service_principal
}
```

### Configure access to Azure resources

```hcl
data "azurerm_subscriptions" "my" {}

locals {
  subscriptions = ({ 
    for s in data.azurerm_subscriptions.my.subscriptions : 
    s.display_name => format("/subscriptions/%s", s.subscription_id)
  })
}

module "service_principal" {
  source = "innovationnorway/service-principal/azuread"
  name   = "example"
  role   = "Contributor"
  scopes = [local.subscriptions["example"]]
}
```

### Create a password that never expires

```hcl
module "service_principal" {
  source   = "innovationnorway/service-principal/azuread"
  name     = "example"
  end_date = "2299-12-30"
}
```

### Use file-based authentication (SDK)

```hcl
module "service_principal" {
  source = "innovationnorway/service-principal/azuread"
  name   = "example"
  role   = "Contributor"
}

resource "local_file" "sdk_auth_file" {
  content  = module.service_principal.sdk_auth
  filename = pathexpand("~/azureauth.json")
}
```

## Arguments

| Name | Type | Description |
| --- | --- | --- |
| `name` | `string` | The name of the service principal. |
| `password` | `string` | A password for the service principal. If missing, Terraform will generate a password. |
| `end_date` | `string` | The date after which the password expire. This can either be relative duration or RFC3339 date. Default: `1Y`. |
| `role` | `string` | The name of a role for the service principal. |
| `scopes` | `list` | List of scopes the `role` assignment applies to. |
