# Demo Environment (Local State)

This folder is a small, local-state entry point for reviewing the Terraform structure.
It reuses the shared network module and does not configure an Azure remote-state
backend. The demo disables the point-to-site VPN gateway to keep this example smaller.

`terraform init` and `terraform validate` can be run without Azure credentials. The
configuration describes Azure resources, however, so a real `terraform plan` may require
Azure authentication, a subscription, and permission to inspect the relevant resources.
A plan previews proposed changes; it does not deploy them.

## What This Demo Shows

- How the demo root module calls the shared network module
- How environment variables, tags, and outputs are wired
- How the hub-and-spoke network configuration is expressed in Terraform
- How the configuration can be initialized and validated with local state

This demo currently instantiates the network module only. Monitoring and diagnostic
settings are configured by the `dev`, `test`, and `prod` environment roots; they are not
part of this demo configuration.

## Why Local State?

The demo has no `backend` block, so Terraform uses its default local state file. This
avoids remote state setup and keeps the demo separate from the `dev`, `test`, and `prod`
backends. Local state does not prevent Azure deployment: running `terraform apply` here
can create real Azure resources if you are authenticated.

## Run the Demo

From the repository root:

```powershell
terraform -chdir=demo init -backend=false
terraform -chdir=demo validate
```

To preview proposed Azure resources, use a sandbox subscription, configure Azure
credentials and suitable permissions, then run:

```powershell
terraform -chdir=demo plan
```

Do not run `terraform apply` or `terraform destroy` against another person's subscription.
Only use a subscription you own or are explicitly authorized to manage, and review any
plan carefully before applying it.

## Production Environments

The real `dev`, `test`, and `prod` environments use separate Azure Storage remote-state
backends, state locking, OIDC authentication, and GitHub Actions workflows for quality
checks, manual plans, drift detection, and controlled apply/destroy operations.