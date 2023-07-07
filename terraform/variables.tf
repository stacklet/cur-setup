variable "s3_region" {
  type    = string
  default = "us-east-1"
}
variable "stacklet_saas_account_id" {
  type = string
  default = null
}
variable "customer_prefix" {
  type = string
}

variable "clouds" {
  type    = list(string)
  default = ["aws"]
}

variable "resource_group_location" {
  type = string
}
