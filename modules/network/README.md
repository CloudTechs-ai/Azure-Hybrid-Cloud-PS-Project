# network module

Builds the Virtual WAN hub, a point-to-site VPN gateway (Entra ID authenticated),
two spoke VNets (app, data), NSGs on the app and data workload subnets,
hub-to-spoke connections, and a dedicated private-endpoint subnet in the data spoke
for future private endpoints.

Point-to-site was chosen over site-to-site because there's no physical on-prem
device for this project — this is worth stating explicitly in an interview.