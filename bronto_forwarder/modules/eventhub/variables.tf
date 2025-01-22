variable "location" {
  description = "The resources location"
}

variable "resource_group_name" {
  description = "Name of the group where resources are created"
}

variable "eventhub" {
  description = "Event Hub Configuration"
  type        = object({
    name: string
    namespace: object({
      name: string
      sku: string
    })
    retention_days: number
    partition_count: optional(number, 1)
  })
}
