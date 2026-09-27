# Monitoring module

Creates one Log Analytics workspace per environment. The current environment
configurations use a 30-day retention period. The environment root module supplies the
resource group, location, naming prefix, environment name, and common tags.

The module also discovers supported Azure Monitor diagnostic categories and routes logs
and metrics from the Virtual Hub, app/data spoke VNets, site-to-site VPN gateway, and
point-to-site VPN gateway to the workspace. Azure does not support diagnostic settings
on the Virtual WAN resource itself. Category discovery is resource-specific, so
unsupported log categories are not hard-coded.

The `prod` environment additionally sends subscription Activity Log categories to its
workspace. This captures control-plane operations affecting the Virtual WAN and other
subscription resources; it is not a substitute for resource diagnostic logs.