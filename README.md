# Cost and Usage Report (CUR) setup for Stacklet customers

This repository provides automation for setting up a CUR in your organizational account in such a way that the Stacklet platform, running in a different account, can access and use the CUR data.

More background information, along with instructions for accomplishing the same thing via the AWS console, can be found in the Stacklet documentation.

## AWS

### Overview

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
* `clouds` - (required) List of clouds to set up, requires ["AWS"]

If you need help identifying the correct values for `customer_prefix` and `stacklet_saas_account_id`, please contact Stacklet customer service.

## Azure

### Overview

The terraform in this repository is meant to be applied in each subscription, independent of any account in which the STacklet platform is running, and must be applied by a user or service principal that has permissions to create Cost Management exports, storage accounts, and resource groups. Stacklet utilizes credentials provided in Stacklet to read from the created Storage Account. 

It does the following:

* Creates a Resource Group to contain all created resources
* Creates a Storage Account to store cost management exports
* Creates a Cost Management export job to push data into the Storage Account

This setup ensures that the Cost Management export is in the format required by Stacklet.

### Inputs

The terraform accepts three inputs:

* `customer_prefix` - (required) The customer prefix
* `clouds` - (required) List of clouds to set up, requires ["Azure"]
* `resource_group_location` - (required) Resource Group Location

If you need help identifying the correct value for `customer_prefix`, please contact Stacklet customer service.

## Running the Terraform

Make sure you update the `export`s below with real values.

```bash
cd terraform/
terraform init
terraform plan
terraform apply
 ```
