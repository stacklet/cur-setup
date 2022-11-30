# Cost and Usage Report (CUR) setup for Stacklet customers

This repo provides automation for setting up a CUR in a customer account in such a way that the Stacklet platform, running in a different account, can access and use the CUR data.

More background information, along with instructions for accomplishing the same thing via the AWS console, can be found in the [Cost and Usage Report wiki page](https://stacklet.atlassian.net/wiki/spaces/ENG/pages/1207042052/Cost+and+Usage+Report+CUR).

## Overview

The terraform in this repo is meant to be applied in the customers's payer account (NOT the account in which the Stacklet platform is running), and must be applied by a role that has permissions to create a new CUR in the AwS billing console.

It does the following:

* Creates an S3 bucket named `<customer-prefix>-stacklet-shared-cur` in the customer account
* Creates an hourly CUR, with resource IDs, in parquet format, which is written to the S3 bucket
* Creates a `stacklet-shared-cur-access` role in the customer account, which can be assumed by a `<customer-prefix>-cur-read` role in the Stacklet platform SAAS account for that customer
* Grants limited permissions to the assumable role on the S3 bucket

This setup ensures that the CUR is in the format required by Stacklet, and that the Stacklet platform SAAS account has access to the CUR data in the customer's S3 bucket.

## Inputs

The terraform expects two inputs:

* The customer prefix
* The account ID where the Stacklet platform for this customer is deployed

Both of these can be found in the `manifest.json` file for the customer, in https://github.com/stacklet/imp-manifests.

## Running the Terraform

Make sure you update the `export`s below with real values.

```bash
cd terraform/
terraform init
export TF_VAR_stacklet_saas_account_id=<saas-account-id>
export TF_VAR_customer_prefix=<customer-prefix>
terraform plan
terraform apply
 ```