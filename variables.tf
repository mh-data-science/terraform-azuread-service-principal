variable "name" {
  type        = string
  default     = ""
  description = "The name of the service principal."
}

variable "password" {
  type        = string
  default     = ""
  description = "A password for the service principal."
}

variable "end_date" {
  type        = string
  default     = null
  description = "The password expiry date. This should be RFC3339 date string."
}

variable "years" {
  type        = number
  default     = 1
  description = "Number of years for which the password will be valid."
}

variable "role" {
  type        = string
  default     = ""
  description = "The name of a role for the service principal."
}

variable "scopes" {
  type        = list
  default     = []
  description = "List of scopes the role assignment applies to."
}

locals {
  scopes = length(var.scopes) > 0 ? var.scopes : [data.azurerm_subscription.main.id]
}
