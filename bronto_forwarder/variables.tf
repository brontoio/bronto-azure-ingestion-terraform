variable "location" {
  description = "The resources location"
}

variable "resource_group" {
  description = "Configuration of the group where resources are created"
  type        = object({
    name: string
    create: bool
  })
}

variable "eventhub" {
  description = "Event Hub Configuration"
  type        = object({
    create: bool
    name: string
    namespace: object({
      name: string
      sku: string
    })
    retention_days: optional(number)
    partition_count: optional(number, 1)
  })
  default = null
  validation {
    condition     = var.eventhub.create || var.eventhub.retention_days == null
    error_message = "retention_days must be specified when creating an Event Hub"
  }
}

variable "forwarder" {
  description = "Bronto forwarder Configuration"
  type        = object({
    name: string
    service_plan_type: string
    storage_account: object({
      name: string
      replication_type: string
      tier: optional(string, "Standard")
    })
    pkg_url: optional(string, "https://releases.bronto.io/integrations/azure/forwarders/eventhub/1.1.3-1/brontoForwarder.zip")
    bronto_config: object({
      ingestion_endpoint: string
      ingestion_key: string
      default_collection: string
    })
  })
}

