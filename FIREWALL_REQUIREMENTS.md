# Firewall Requirements for dotnet new install Aspire.ProjectTemplates

This document provides information about the network connections required for the `dotnet new install Aspire.ProjectTemplates::9.3.0` command to function correctly. This information can be used to configure firewall rules appropriately.

## Required Domains

The following domains need to be accessible for the command to work properly:

| Domain | Purpose | Port |
|--------|---------|------|
| api.nuget.org | Primary NuGet API endpoint | 443 (HTTPS) |
| nugetapiprod.trafficmanager.net | CNAME for api.nuget.org | 443 (HTTPS) |
| apiprod-mscdn.azureedge.net | Azure CDN for NuGet packages | 443 (HTTPS) |
| apiprod-mscdn.afd.azureedge.net | Azure Front Door for NuGet packages | 443 (HTTPS) |
| azureedge-t-prod.trafficmanager.net | Azure CDN traffic manager | 443 (HTTPS) |
| shed.dual-low.s-part-0013.t-0009.t-msedge.net | Microsoft Edge CDN network | 443 (HTTPS) |
| s-part-0013.t-0009.t-msedge.net | Microsoft Edge CDN network | 443 (HTTPS) |
| nuget.org | NuGet website | 443 (HTTPS) |

## IP Addresses

The resolved IP addresses for these domains at the time of testing:

| Domain | IP Address |
|--------|------------|
| api.nuget.org (and its CNAMEs) | 13.107.246.41 |
| nuget.org | 52.159.113.5 |

Note that IP addresses may change over time, so it's recommended to allow access based on domain names rather than specific IP addresses.

## Required Endpoints

The `dotnet new install` command needs to access the following specific URLs:

1. `https://api.nuget.org/v3/index.json` - NuGet API v3 endpoint
2. Additional package-specific URLs on the above domains that are determined at runtime

## DNS Resolution

DNS resolution to the following domains is required:
- api.nuget.org
- nuget.org
- All the CNAME records listed in the domains section

## Firewall Configuration Recommendations

To ensure the `dotnet new install Aspire.ProjectTemplates::9.3.0` command works properly, configure your firewall to allow:

1. **DNS resolution** (typically UDP port 53) for all listed domains
2. **HTTPS traffic (TCP port 443)** to all listed domains and their resolved IP addresses
3. **HTTP traffic (TCP port 80)** may be needed for redirects, though most traffic will be HTTPS

## Testing Methodology

This information was gathered by:

1. Using network capture tools (tcpdump) to monitor DNS and HTTP(S) traffic during command execution
2. Using system call tracing (strace) to monitor connection attempts
3. Resolving the domains directly to identify the full chain of CNAME records
4. Testing direct HTTP access to the NuGet API endpoints

## Troubleshooting

If the command fails with exit code 106 ("no NuGet feeds are configured or they are invalid"), check:

1. Network connectivity to api.nuget.org
2. That your firewall allows HTTPS connections to the domains listed above
3. That SSL/TLS inspection isn't interfering with connections to these domains
4. That NuGet.config is properly configured with the NuGet.org feed

## Additional Notes

- The NuGet client uses HTTPS connections to securely download packages
- Some environments may require a proxy server for external connections
- For increased security, you can use a more restrictive approach by allowing only the specific IP addresses rather than entire domains, but this may require updates if IP addresses change