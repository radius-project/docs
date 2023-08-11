//PARAM
variable "resource_group_name" {
  type        = string
  description = "Name of the Azure resource group."
}

variable "location" {
  type        = string
  description = "Redis cache deployment region. Can be different from resource group location."
}

variable "redis_cache_name" {
  type        = string
  description = "Name of the Redis Cache."
}

variable "capacity" {
  type = int
  description = "Size of the Redis Cache to deploy. Valid values: for C (Basic/Standard) family (0, 1, 2, 3, 4, 5, 6), for P (Premium) family (1, 2, 3, 4)."
  default = 0
}

variable "family" {
  type        = string
  description = "The SKU family to use. Valid values: (C, P). (C = Basic/Standard, P = Premium)."
  default = "C"
}

variable "sku_name" {
  type        = string
  description = "The type of Redis cache to deploy. Valid values: (Basic, Standard, Premium)"
  default     = "Basic"
}
//PARAM

// TODO: MISSING CONTEXT VARIABLE

//RESOURCE
resource "azurerm_redis_cache" "cache" {
  name                = var.redis_cache_name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name
}
//RESOURCE


//OUTPUT
output "host" {
  value = azurerm_redis_cache.cache.hostname
}

output "port" {
  value = azurerm_redis_cache.cache.ssl_port
}

output "password" {
  value = azurerm_redis_cache.cache.primary_access_key
  sensitive = true
}
//OUTPUT