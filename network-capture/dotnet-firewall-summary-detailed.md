# Network Connections for dotnet new install Aspire.ProjectTemplates::9.3.0

This report shows the domains, IPs, and connections that need to be allowed through a firewall for the `dotnet new install Aspire.ProjectTemplates::9.3.0` command to function properly.

## DNS Domains

The following domains were resolved or referenced during the operation:

```
api.nuget.org
api.nuget.org.
apiprod-mscdn.afd.azureedge.net.
apiprod-mscdn.azureedge.net.
azureedge-t-prod.trafficmanager.net.
fv-az1720-213.5vs45zvnpbiehoyyevf2d3pjfe.cx.internal.cloudapp.net
fv-az1720-213.5vs45zvnpbiehoyyevf2d3pjfe.cx.internal.cloudapp.net.54796
nugetapiprod.trafficmanager.net.
s-part-0013.t-0009.t-msedge.net.
shed.dual-low.s-part-0013.t-0009.t-msedge.net.
```

## Resolved IP Addresses

```
nugetapiprod.trafficmanager.net.
apiprod-mscdn.azureedge.net.
apiprod-mscdn.afd.azureedge.net.
azureedge-t-prod.trafficmanager.net.
shed.dual-low.s-part-0013.t-0009.t-msedge.net.
s-part-0013.t-0009.t-msedge.net.
13.107.246.41
```

## TCP Connection Attempts

The following TCP connections were attempted:

```
168.63.129.16.32526
168.63.129.16.http
```

## Firewall Rules Summary

To allow the `dotnet new install Aspire.ProjectTemplates::9.3.0` command to function properly, firewall rules should allow traffic to:

1. DNS servers for resolving the above domains
2. The following domains and their resolved IP addresses:
   - api.nuget.org
   - api.nuget.org.
   - apiprod-mscdn.afd.azureedge.net.
   - apiprod-mscdn.azureedge.net.
   - azureedge-t-prod.trafficmanager.net.
   - fv-az1720-213.5vs45zvnpbiehoyyevf2d3pjfe.cx.internal.cloudapp.net
   - fv-az1720-213.5vs45zvnpbiehoyyevf2d3pjfe.cx.internal.cloudapp.net.54796
   - nugetapiprod.trafficmanager.net.
   - s-part-0013.t-0009.t-msedge.net.
   - shed.dual-low.s-part-0013.t-0009.t-msedge.net.

3. The following TCP connections:
   - 168.63.129.16.32526
   - 168.63.129.16.http

## Additional Information

The `dotnet new install` command attempts to download template packages from NuGet feeds. The default feed is api.nuget.org, but additional feeds can be configured in the NuGet.config file.

