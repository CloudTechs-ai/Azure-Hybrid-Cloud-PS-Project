# VPN Troubleshooting

This document records the troubleshooting performed while validating the test
environment's Azure Virtual WAN P2S VPN and preparing for end-to-end traffic tests.

## 1. Confirm the Correct Azure Resource

Use the test environment, not dev or prod:

- Resource group: `rg-hybridcloud-test`
- Virtual WAN: `vwan-hybridcloud`
- Virtual hub: `vhub-hybridcloud`
- User VPN gateway: `p2svpngw-hybridcloud`
- VPN server configuration: `vpnserverconfig-hybridcloud`

In the portal, **User VPN (Point to site)** should show the gateway attachment as
`Attached`.

## 2. Azure VPN Client Installation

The downloaded `AzVpnAppx_4.0.5.0_sideload` folder is the Azure VPN Client installer.
The `Install.ps1` wrapper calls `Add-AppDevPackage.ps1`.

Run PowerShell from the installer folder if the package is not installed:

```powershell
Set-Location "$HOME\Downloads\AzVpnAppx_4.0.5.0_sideload"
Set-ExecutionPolicy -Scope Process Bypass
.\Install.ps1 -SkipLoggingTelemetry
```

Then open **Azure VPN Client** from the Start menu.

## 3. VPN Profile Import

The portal download contains the client profile. Import the XML file inside the
extracted profile folder, not the whole folder or ZIP:

```text
vpnclientconfiguration\AzureVPN\azurevpnconfig.xml
```

The Azure VPN Client log confirmed the profile was imported successfully.

## 4. Authentication and Connection Checks

Azure VPN Client diagnostics confirmed:

- Internet access available
- Microsoft Entra endpoint reachable
- VPN server DNS resolution succeeded
- VPN server socket connection succeeded
- Microsoft Entra authentication succeeded
- The client received a VPN address and private routes

The relevant client log is:

```text
C:\Users\chris\AppData\Local\Packages\Microsoft.AzureVpn_8wekyb3d8bbwe\LocalState\LogFiles\AzureVpnClient.log
```

Useful log indicators include:

```text
AAD Authentication succeeded
Connection state is Connected
AssignedIP: 172.16.0.130
RouteList: 10.0.0.0/23, 10.1.0.0/24, 10.2.0.0/24
```

## 5. Portal Refresh Timing

The client connected briefly and Azure Portal initially showed zero connected clients.
Refreshing the **User VPN (Point to site)** page immediately after clicking Connect
showed the active session. Portal counters can lag or change quickly, so use both:

- Azure VPN Client connection state
- Azure Portal **Point-to-site Sessions** and **Connected Clients**

## 6. Disconnect Investigation

The log showed a successful connection followed by a disconnect. Important findings:

- Entra authentication was not the failure.
- The client received an address and routes.
- The VPN gateway was reachable and attached.
- The pipe errors occurred around the Azure VPN Client UI/background process and
after the connection had already succeeded.

For another disconnect, collect the log immediately after reproducing it and compare:

- `FailureReason`
- `FailureErrorCode`
- `ConnectionStatus`
- `AssignedIP`
- `RouteList`

## 7. Traffic-Test Limitation

The VPN needs an Azure-side private target in one of these routed ranges:

- Hub: `10.0.0.0/23`
- App spoke: `10.1.0.0/24`
- Data spoke: `10.2.0.0/24`

The deployed test environment currently has no VM or private endpoint target. Therefore,
only the P2S control plane has been proven. End-to-end packet flow remains pending.

## 8. Temporary VM Attempts

A private Ubuntu VM was prepared temporarily for traffic testing, but deployment was
blocked by subscription/SKU availability:

- `Standard_B1s`: East US capacity restriction
- `Standard_DS1_v2`: East US capacity restriction
- `Standard_D2s_v5`: `standardDSv5Family` quota was `0` and Azure reported the family
  unavailable for the subscription
- `Standard_D2s_v3`: Azure Portal reported `NotAvailableForSubscription`

The temporary compute module, VM configuration, SSH key value, and orphaned NIC were
removed. The test environment now reports:

```text
No changes. Your infrastructure matches the configuration.
```

## 9. Quota Request Attempt

An Azure CLI quota request was attempted for:

- Region: East US
- Resource family: `standardDSv5Family`
- Requested limit: 2 cores

The CLI returned:

```text
Code: ContactSupport
Message: Request failed.
```

The Azure Portal quota flow also identified the DSv5 family as unavailable for this
subscription/region. A future request should use **Subscriptions > Usage + quotas**
with Microsoft.Compute and East US, then choose **Contact Support** when Azure marks the
family unavailable. Request two general-purpose VM cores for a temporary private P2S
traffic-test VM.

The quota request itself has no cost. VM, disk, networking, and Log Analytics charges
apply only if resources are deployed and running.

## 10. Future End-to-End Test Procedure

After a supported VM or private endpoint is available:

1. Confirm the target has a private IP in the routed test ranges.
2. Connect the laptop with Azure VPN Client.
3. Run `route print` and confirm routes for `10.0.0.0/23`, `10.1.0.0/24`,
   and `10.2.0.0/24`.
4. Test the target's private IP with the appropriate protocol, such as SSH.
5. Run Network Watcher **Connection troubleshoot**.
6. Run **IP flow verify** to test NSG allow/deny behavior.
7. Check **Next hop** and **Effective routes**.
8. Confirm the session and traffic counters in Azure Portal.
9. Destroy only the temporary test target after validation.
10. Run `terraform plan` again to confirm no unintended changes remain.

## 11. Environment Approval Limitation

GitHub's required-reviewer protection rule for deployment environments is not available
to private repositories on GitHub Free, Pro, or Team; private repositories require an
Enterprise plan for that control. Main branch protection is also unavailable on this
repository's current plan. This repository currently uses a manual `confirmation` input
in `.github/workflows/terraform-apply.yml` as a compensating control:

- `APPLY` allows the job to continue.
- `CANCEL` skips the apply job.
- The workflow applies the exact reviewed plan artifact and does not generate a new plan.

The repository should not be presented as having independently approval-gated production
deployment. If the repository later moves to an Enterprise plan, or its visibility and
configuration change to support the required controls, configure branch protection and
environment-level approvals for `test` and especially `prod`. The partial `dev` environment
created during the initial configuration attempt was removed.