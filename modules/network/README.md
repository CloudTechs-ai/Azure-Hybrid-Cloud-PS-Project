# network module

Builds the hybrid connectivity core for this project:

- **Virtual WAN + Virtual Hub** (`hub.tf`) — central routing point spokes and
  the VPN gateway attach to.
- **Point-to-site VPN gateway** (`vpn.tf`), authenticated via Entra ID (Azure
  AD) — lets you connect from your own laptop using the Azure VPN Client.
- **Two spoke VNets** (`spokes.tf`): an app spoke for general workloads, and a
  data spoke with a dedicated subnet reserved for private endpoints, kept
  separate from workload subnet traffic.
- **Hub-to-spoke connections** (`connections.tf`).
- **Outputs** (`outputs.tf`) for future governance/monitoring modules.

## Why point-to-site VPN instead of site-to-site

A real hybrid deployment usually connects an on-prem datacenter to Azure via
site-to-site VPN or ExpressRoute, which requires a physical on-prem device
(VPN appliance or router) to terminate the tunnel. Since this project has no
physical on-prem hardware behind it, it uses a **point-to-site VPN** instead:

- Testable from a personal laptop using the Azure VPN Client — no hardware
  required.
- Authenticated via Entra ID rather than certificates, which is the
  lower-friction option for a single-user demo.
- Still exercises the same hub-and-spoke routing, NSG segmentation, and
  private endpoint patterns a site-to-site design would.

**Tradeoff to flag if asked:** point-to-site is designed for individual
client access, not for connecting an entire on-prem network. A production
hybrid design serving multiple on-prem users/systems would use site-to-site
VPN or ExpressRoute instead. This project substitutes P2S purely so the
network is independently testable without physical hardware — the routing
architecture (hub, spokes, connections) is otherwise the same shape you'd
use with a real site-to-site link.

## Variables

See `variables.tf` for the full list. Notably:

- `aad_tenant_id` (required) — your Entra ID tenant ID, used for VPN client
  auth.
- `suffix` — short unique string (e.g. initials) used in resource naming.
- Address space variables all have defaults but should be checked against
  each other for overlaps if you change them.

## Outputs

Exposed for consumption by future modules (governance, monitoring) — see
`outputs.tf`.
