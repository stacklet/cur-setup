resource "random_string" "storage_account_suffix" {
  special = false
  length  = 24
  lower   = true
  upper   = false
}

locals {
  buckets = {
    "aws" : contains(var.clouds, "aws") ? aws_s3_bucket.cur_bucket[0].bucket : null
    "azure" : contains(var.clouds, "azure") ? azurerm_storage_account.cost[0].name : null
  }
  s3_bucket_name       = "${var.customer_prefix}-stacklet-shared-cur"
  storage_account_name = substr("stackletcost${random_string.storage_account_suffix.id}", 0, 23)
}
