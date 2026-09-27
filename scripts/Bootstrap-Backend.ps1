<#
.SYNOPSIS
    One-time setup: creates the resource group, storage account, and container
    that will hold Terraform's remote state.

.DESCRIPTION
    Run this once, before `terraform init`. Uses the Az PowerShell module
    (not the Azure CLI) so it demonstrates native PowerShell administration.

.PARAMETER Suffix
    A short, unique string (e.g. your initials) used to make the storage
    account name globally unique. Storage account names must be lowercase,
    3-24 characters, letters and numbers only.

.EXAMPLE
    ./Bootstrap-Backend.ps1 -Suffix cjt01
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidatePattern('^[a-z0-9]+$')]
    [string]$Suffix,

    [string]$Location = "eastus"
)

$ErrorActionPreference = "Stop"

# Confirm we're logged in; if not, prompt interactively.
$context = Get-AzContext
if (-not $context) {
    Write-Host "No active Azure context found. Launching login..." -ForegroundColor Yellow
    Connect-AzAccount
}
else {
    Write-Host "Using existing session for subscription: $($context.Subscription.Name)" -ForegroundColor Cyan
}

$rgName = "rg-tfstate-$Suffix"
$saName = "sttfstate$Suffix"
$containerName = "tfstate"

Write-Host "Creating resource group: $rgName" -ForegroundColor Cyan
$resourceGroup = Get-AzResourceGroup -Name $rgName -ErrorAction SilentlyContinue
if (-not $resourceGroup) {
    New-AzResourceGroup -Name $rgName -Location $Location | Out-Null
}
else {
    Write-Host "  Resource group already exists, skipping." -ForegroundColor Yellow
}

Write-Host "Creating storage account: $saName" -ForegroundColor Cyan
$storageAccount = Get-AzStorageAccount -ResourceGroupName $rgName -Name $saName -ErrorAction SilentlyContinue
if (-not $storageAccount) {
    $storageAccount = New-AzStorageAccount `
        -ResourceGroupName $rgName `
        -Name $saName `
        -Location $Location `
        -SkuName "Standard_LRS" `
        -Kind "StorageV2" `
        -MinimumTlsVersion "TLS1_2" `
        -AllowBlobPublicAccess $false
}
else {
    Write-Host "  Storage account already exists, skipping." -ForegroundColor Yellow
}

Write-Host "Creating blob container: $containerName" -ForegroundColor Cyan
$ctx = $storageAccount.Context
$container = Get-AzStorageContainer -Name $containerName -Context $ctx -ErrorAction SilentlyContinue
if (-not $container) {
    New-AzStorageContainer -Name $containerName -Context $ctx -Permission Off | Out-Null
}
else {
    Write-Host "  Container already exists, skipping." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Backend storage account ready. Put these values into environments/dev/backend.tf:" -ForegroundColor Green
Write-Host ""
Write-Host "  resource_group_name  = `"$rgName`""
Write-Host "  storage_account_name = `"$saName`""
Write-Host "  container_name       = `"$containerName`""
Write-Host "  key                  = `"dev.terraform.tfstate`""
Write-Host ""
