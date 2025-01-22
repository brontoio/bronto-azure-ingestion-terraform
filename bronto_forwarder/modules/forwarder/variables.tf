variable "location" {
  description = "The resources location"
}

variable "resource_group_name" {
  description = "Name of the group where resources are created"
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
    pkg_url: optional(string, "https://releases.bronto.io/integrations/azure/forwarders/eventhub/latest/brontoForwarder.zip")
    bronto_config: object({
      ingestion_endpoint: string
      ingestion_key: string
      default_collection: string
    })
  })
}

variable "eventhub" {
  type = object({
    name: string
    namespace_name: string
  })
}

