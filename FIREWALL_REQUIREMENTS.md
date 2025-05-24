# Firewall Requirements for dotnet new install Aspire.ProjectTemplates

This document provides information about the network connections required for the `dotnet new install Aspire.ProjectTemplates::9.3.0` command to function correctly. This information can be used to configure firewall rules appropriately.

## Summary

The `dotnet new install Aspire.ProjectTemplates::9.3.0` command attempts to download the Aspire project templates from NuGet package sources. By default, it uses api.nuget.org, but can be configured to use other sources through NuGet.config.

## Command Variants

The command can be executed in different ways, all requiring the same network access:

```bash
# Standard installation
dotnet new install Aspire.ProjectTemplates::9.3.0

# Force reinstallation of the template
dotnet new install Aspire.ProjectTemplates::9.3.0 --force

# With diagnostic output
dotnet new install Aspire.ProjectTemplates::9.3.0 -d

# Install from a specific NuGet source
dotnet new install Aspire.ProjectTemplates::9.3.0 --nuget-source https://api.nuget.org/v3/index.json
```

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

### Specific Port Requirements

| Service | Protocol | Port | Direction | Purpose |
|---------|----------|------|-----------|---------|
| DNS | UDP | 53 | Outbound | Domain name resolution |
| HTTP | TCP | 80 | Outbound | Redirects and fallbacks |
| HTTPS | TCP | 443 | Outbound | Package downloads and API access |

## Example NuGet.config

A proper NuGet.config file is needed for the command to work. You can place this in the current directory or in your user profile:

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
  </packageSources>
</configuration>
```

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
- The scripts used to gather this information are included in this repository: `capture-dotnet-network.sh`, `capture-dotnet-network-detailed.sh`, and `capture-dotnet-network-strace.sh`
- Full capture data is available in the `network-capture` directory