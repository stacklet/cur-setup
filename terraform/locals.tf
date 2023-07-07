resource "random_string" "storage_account_suffix" {
  special = false
  length  = 24
  lower   = true
  upper   = false
}

locals {
  use_aws   = contains(var.clouds, "aws")
  use_azure = contains(var.clouds, "azure")

  buckets = {
    "aws" : local.use_aws ? aws_s3_bucket.cur_bucket[0].bucket : null
    "azure" : {
      "storage_account" : local.use_azure ? azurerm_storage_account.cost[0].name : null
      "storage_container" : local.use_azure ? azurerm_storage_container.cost[0].id : null
      "subscription_id" : local.use_azure ? data.azurerm_subscription.current[0].subscription_id : null
    }
  }
  s3_bucket_name       = "${var.customer_prefix}-stacklet-shared-cur"
  storage_account_name = substr("stackletcost${random_string.storage_account_suffix.id}", 0, 23)
}
