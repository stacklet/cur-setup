# Cost and Usage Report (CUR) setup for Stacklet customers

> [!WARNING]
> This repository is deprecated and no longer maintained. Use the dedicated
> module for your cloud instead:
>
> * AWS: [terraform-aws-stacklet-cur-setup](https://github.com/stacklet/terraform-aws-stacklet-cur-setup)
> * Azure: [terraform-azure-stacklet-cost-setup](https://github.com/stacklet/terraform-azure-stacklet-cost-setup)

This repository configured cost reporting in your cloud account, so that the
Stacklet platform running elsewhere could read it. That automation now lives in
the two repositories above, one per cloud. Each is a reusable Terraform module
with its own documentation, and each carries fixes that this repository never
received.

The Terraform here remains only as a record of what existing users deployed. Do
not start a new setup from it.

## Migrating

Follow the README of the repository for your cloud. Neither module is a drop-in
replacement for what is here.

* The Azure module requires a new `stacklet_principal_id` input, and it declares
  no provider block. Its README covers both changes under "Migrating to 1.0.0".
* The AWS module drops the `s3_region` input and takes the region from the
  `aws` provider that the caller configures. Set a region on that provider, or
  in the environment, since the module no longer defaults to `us-east-1`.
* Each module covers a single cloud, so the `clouds` input has no equivalent.
  Apply the module for the cloud you need.

Contact Stacklet customer service for help identifying `customer_prefix` or any
other Stacklet-supplied value.
