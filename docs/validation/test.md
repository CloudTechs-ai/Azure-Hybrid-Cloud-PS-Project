# Test Environment Validation

## Purpose

This document records validation of the test environment's Azure Virtual WAN
point-to-site (P2S) VPN control plane. The test environment is deployed from
`environments/test` and uses its own Azure remote state:

- Resource group: `rg-hybridcloud-test`
- Virtual WAN: `vwan-hybridcloud`
- Virtual hub: `vhub-hybridcloud`
- User VPN gateway: `p2svpngw-hybridcloud`
- VPN server configuration: `vpnserverconfig-hybridcloud`
- P2S client pool: `172.16.0.0/24`

## Terraform Validation

From `environments/test`, authenticate with Azure CLI and use the Entra-authenticated
backend:

```powershell
$env:ARM_USE_AZUREAD = "true"
$env:ARM_USE_CLI = "true"
terraform init -input=false -reconfigure
terraform validate
terraform plan -input=false -lock-timeout=5m
```

Observed result:

```text
No changes. Your infrastructure matches the configuration.
```

The plan acquired and released the remote state lock and reported no additions,
changes, or deletions.

## P2S Control-Plane Test

1. In Azure Portal, open resource group `rg-hybridcloud-test`.
2. Open `vwan-hybridcloud` and then `vhub-hybridcloud`.
3. Open **User VPN (Point to site)**.
4. Confirm the gateway is attached and the user VPN gateway is
   `p2svpngw-hybridcloud`.
5. Download the virtual hub User VPN profile.
6. Install Azure VPN Client on the Windows laptop.
7. Import `AzureVPN\azurevpnconfig.xml` from the downloaded profile.
8. Connect using Microsoft Entra ID.
9. Refresh the portal quickly and review **Point-to-site Sessions** and
   **Connected Clients**.

## Evidence Collected

The Azure VPN Client log confirmed:

- Microsoft Entra authentication succeeded for the test account.
- The VPN server resolved and the socket connection succeeded.
- The client received address `172.16.0.130`.
- The client received routes for:
  - `10.0.0.0/23` (hub)
  - `10.1.0.0/24` (app spoke)
  - `10.2.0.0/24` (data spoke)
  - `172.16.0.0/25` and `172.16.0.128/25` (VPN pool)
- Azure VPN Client reached `Connected` and reported `Connected Count: 1`.
- Azure Portal showed the P2S gateway attached.

## Result

**P2S control-plane validation: passed.**

This proves the Entra-authenticated client can negotiate with the P2S gateway,
receive a VPN address, and receive the expected private routes.

## Current Limitation

A packet-level traffic test was not completed because the subscription could not
create a suitable Azure VM target in East US. The temporary VM/NIC configuration
was removed and the orphaned NIC was deleted. The test environment now has no
temporary compute target, and Terraform reports no changes.

The absence of a VM does not invalidate the P2S control-plane result; it only
prevents confirming traffic to an Azure-side workload.

## Future End-to-End Validation

When a supported VM SKU or quota is available:

1. Add a small private VM to the test app subnet.
2. Use an RSA SSH public key; Azure rejected the earlier Ed25519 key for this
   subscription/provider path.
3. Connect the laptop to the P2S VPN.
4. Record the VM private IP.
5. Test the private IP with SSH or another application protocol.
6. Use Network Watcher **Connection troubleshoot**, **IP flow verify**,
   **Next hop**, and **Effective routes**.
7. Confirm the expected route and NSG behavior.
8. Remove the temporary VM after testing to control cost.