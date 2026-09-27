# Identity module

Creates one user-assigned managed identity per module invocation for future Azure-hosted
workloads. The environment root modules invoke it once per environment. Conditional
Access and PIM remain separate tenant-level governance work and are not changed by this
module.