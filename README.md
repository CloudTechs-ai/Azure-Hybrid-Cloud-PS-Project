# Azure hybrid cloud architecture project

Hub-and-spoke hybrid architecture built with Terraform, demonstrating Virtual WAN,
private endpoints, governance, identity, monitoring, backup, and CI/CD via Azure DevOps.

## Layout

```
.
├── environments/
│   └── dev/                # Root module you actually run terraform against
│       ├── main.tf         # Calls the modules below
│       ├── variables.tf
│       ├── outputs.tf
│       ├── providers.tf    # Provider + required_providers block
│       ├── backend.tf      # Remote state config (fill in after bootstrap)
│       └── terraform.tfvars.example
├── modules/
│   ├── network/            # Virtual WAN, hub, spokes, private endpoints
│   ├── governance/          # Azure Policy, RBAC, Defender for Cloud
│   ├── identity/            # Conditional Access, PIM (via azuread provider)
│   ├── monitoring/          # Log Analytics, alerts, diagnostic settings
│   └── backup/              # Recovery Services vault + backup policy
├── scripts/
│   └── Bootstrap-Backend.ps1 # One-time: creates the storage account for tfstate (Az module)
└── README.md
```

## Prerequisites

- PowerShell 7+ (`pwsh`)
- The `Az` PowerShell module: `Install-Module -Name Az -Scope CurrentUser -Repository PSGallery -Force`
- Terraform CLI

## Order of operations

1. Run `./scripts/Bootstrap-Backend.ps1 -Suffix <your-initials>` once to create the remote state storage account. It uses native `Az` PowerShell cmdlets, not the Azure CLI.
2. Fill in `environments/dev/backend.tf` with the values it prints out.
3. `cd environments/dev && terraform init`
4. `terraform plan` → review → `terraform apply`

## Why remote state from day one

Local state (`terraform.tfstate` on disk) is fine for a five-minute test, but it's not
how this is done in production, and an interviewer will ask. Remote state in a storage
account gives you locking (no two people applying at once) and a shared source of truth
for you and your teammate.
