resource "azurerm_eventhub_namespace" "this" {
  name                = var.eventhub.namespace.name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.eventhub.namespace.sku
}

resource "azurerm_eventhub" "this" {
  name                = var.eventhub.name
  namespace_id        = azurerm_eventhub_namespace.this.id
  message_retention   = var.eventhub.retention_days
  partition_count     = var.eventhub.partition_count
}
