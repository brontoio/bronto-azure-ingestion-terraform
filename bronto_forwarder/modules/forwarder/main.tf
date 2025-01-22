resource "azurerm_eventhub_authorization_rule" "this" {
  name                = "${var.eventhub.name}-${var.forwarder.name}-ro"
  namespace_name      = var.eventhub.namespace_name
  eventhub_name       = var.eventhub.name
  resource_group_name = var.resource_group_name
  listen              = true
  send                = false
  manage              = false
}

resource "azurerm_storage_account" "this" {
  name                     = var.forwarder.storage_account.name
  resource_group_name      = var.resource_group_name
  account_replication_type = var.forwarder.storage_account.replication_type
  account_tier             = var.forwarder.storage_account.tier
  location                 = var.location
}

resource "azurerm_service_plan" "this" {
  name                = var.forwarder.name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = var.forwarder.service_plan_type
}

resource "azurerm_log_analytics_workspace" "this" {
  name                = var.forwarder.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 90
}

resource "azurerm_application_insights" "this" {
  name                = var.forwarder.name
  resource_group_name = var.resource_group_name
  location            = var.location
  workspace_id        = azurerm_log_analytics_workspace.this.id
  application_type    = "web"
}

resource "azurerm_linux_function_app" "eventhub-forwarder" {
  name                        = var.forwarder.name
  resource_group_name         = var.resource_group_name
  location                    = var.location
  storage_account_name        = var.forwarder.storage_account.name
  storage_account_access_key  = azurerm_storage_account.this.primary_access_key
  service_plan_id             = azurerm_service_plan.this.id
  functions_extension_version = "~4"
  site_config {
    application_insights_key               = azurerm_application_insights.this.instrumentation_key
    application_insights_connection_string = azurerm_application_insights.this.connection_string
    application_stack {
      python_version = "3.11"
    }
  }
  app_settings = {
    BRONTO_API_KEY            = var.forwarder.bronto_config.ingestion_key
    BRONTO_INGESTION_ENDPOINT = var.forwarder.bronto_config.ingestion_endpoint
    FORWARDER_NAME            = var.forwarder.name
    EVENTHUB_CONNECT_STRING   = azurerm_eventhub_authorization_rule.this.primary_connection_string
    EVENTHUB_NAME             = var.eventhub.name
    WEBSITE_RUN_FROM_PACKAGE  = var.forwarder.pkg_url
    BRONTO_COLLECTION         = var.forwarder.bronto_config.default_collection
  }
  lifecycle {
    ignore_changes = [
      tags["hidden-link: /app-insights-conn-string"],
      tags["hidden-link: /app-insights-instrumentation-key"],
      tags["hidden-link: /app-insights-resource-id"]
    ]
  }
}
