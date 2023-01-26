# Cost and Usage Report (CUR) setup for Stacklet customers

This repository provides automation for setting up a CUR in your organizational account in such a way that the Stacklet platform, running in a different account, can access and use the CUR data.

More background information, along with instructions for accomplishing the same thing via the AWS console, can be found in the Stacklet documentation.

## Overview

The terraform in this repository is meant to be applied in your organization's payer account, independent of any account in which the Stacklet platform is running, and must be applied by a role that has permissions to create a new CUR in the AWS billing console.

It does the following:

* Creates an S3 bucket named `<customer-prefix>-stacklet-shared-cur` in your organization's account
* Creates an hourly CUR, with resource IDs, in parquet format, which is written to the S3 bucket
* Grants limited read permissions to the S3 bucket, by the `<customer-prefix>-cur-read` role in the Stacklet platform SAAS account

This setup ensures that the CUR is in the format required by Stacklet, and that the Stacklet platform SAAS account can read CUR data in the correct S3 bucket.

## Inputs

The terraform accepts three inputs:

* `customer_prefix` - (required) The customer prefix
* `stacklet_saas_account_id` - (required) The account ID where the Stacklet platform for this customer is deployed
* `s3_region` - (optional) AWS region where the s3 bucket is created (default: us-east-1)

If you need help identifying the correct values for `customer_prefix` and `stacklet_saas_account_id`, please contact Stacklet customer service.

## Running the Terraform

Make sure you update the `export`s below with real values.

```bash
cd terraform/
terraform init
export TF_VAR_stacklet_saas_account_id=<saas-account-id>
export TF_VAR_customer_prefix=<customer-prefix>
export TF_VAR_s3_region=us-east-1
terraform plan
terraform apply
 ```
