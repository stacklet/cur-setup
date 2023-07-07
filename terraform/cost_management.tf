data "azurerm_subscription" "current" {
  count = contains(var.clouds, "azure") ? 1 : 0
}

resource "azurerm_resource_group" "current" {
  count    = contains(var.clouds, "azure") ? 1 : 0
  name     = substr("Stacklet-${var.customer_prefix}-cost", 0, 23)
  location = var.resource_group_location
}

resource "azurerm_storage_account" "cost" {
  count               = contains(var.clouds, "azure") ? 1 : 0
  name                = local.storage_account_name
  resource_group_name = azurerm_resource_group.current[0].name

  location                 = azurerm_resource_group.current[0].location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "cost" {
  count                = contains(var.clouds, "azure") ? 1 : 0
  name                 = "cur"
  storage_account_name = azurerm_storage_account.cost[0].name
}

resource "azurerm_subscription_cost_management_export" "cost" {
  count                        = contains(var.clouds, "azure") ? 1 : 0
  name                         = local.storage_account_name
  subscription_id              = data.azurerm_subscription.current[0].id
  recurrence_type              = "Daily"
  recurrence_period_start_date = timestamp()
  recurrence_period_end_date   = timeadd(timestamp(), "87600h")

  export_data_storage_location {
    container_id     = azurerm_storage_container.cost[0].resource_manager_id
    root_folder_path = "/cur"
  }

  export_data_options {
    type       = "ActualCost"
    time_frame = "MonthToDate"
  }
}
