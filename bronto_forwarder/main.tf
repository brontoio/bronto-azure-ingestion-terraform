#
# Resource Group
#
resource "azurerm_resource_group" "this" {
  count    = var.resource_group.create ? 1 : 0
  name     = var.resource_group.name
  location = var.location
}

#
# Eventhub
#
module "eventhub" {
  count               = var.eventhub.create ? 1 : 0
  source              = "./modules/eventhub"
  location            = var.location
  resource_group_name = var.resource_group.create ? azurerm_resource_group.this[0].name : var.resource_group.name   # this is to enforce the dependency between the resource group and event hub when the resource group gets created
  eventhub            = var.eventhub
}

#
# Function App
#
module "forwarder" {
  source              = "./modules/forwarder"
  forwarder           = var.forwarder
  location            = var.location
  resource_group_name = var.resource_group.create ? azurerm_resource_group.this[0].name : var.resource_group.name
  eventhub            = {
    name           = var.eventhub.create ? module.eventhub[0].name : var.eventhub.name   # this is to enforce the dependency between eventhub and the forwarder when the Event Hub gets created
    namespace_name = var.eventhub.namespace.name
  }
}
