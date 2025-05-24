#!/bin/bash

# Script to capture network connections made by the dotnet new install command
# This script uses strace to track specific system calls related to networking

echo "Starting network trace for dotnet new install Aspire.ProjectTemplates::9.3.0"
echo "========================================================================"

# Create output directory
mkdir -p network-capture
STRACE_OUTPUT="network-capture/dotnet-strace-output.txt"
DNS_LOOKUPS="network-capture/dotnet-dns-lookups.txt"
CONNECT_ATTEMPTS="network-capture/dotnet-connect-attempts.txt"
SUMMARY_FILE="network-capture/dotnet-firewall-summary-final.md"

# Run the command with strace to track network-related system calls
echo "Running dotnet command with strace..."
strace -f -e trace=network -s 1024 -o "$STRACE_OUTPUT" dotnet new install Aspire.ProjectTemplates::9.3.0 --force
DOTNET_EXIT_CODE=$?
echo "dotnet command completed with exit code: $DOTNET_EXIT_CODE"

# Extract DNS lookups from the strace output
echo "Extracting DNS lookups..."
grep -E "connect.*:53" "$STRACE_OUTPUT" > "$DNS_LOOKUPS"

# Extract connection attempts
echo "Extracting connection attempts..."
grep -E "connect\(" "$STRACE_OUTPUT" | grep -v ":53" > "$CONNECT_ATTEMPTS"

# Attempt to resolve nuget.org and its related domains
echo "Resolving nuget.org domains..."
RESOLVED_DOMAINS="network-capture/dotnet-resolved-domains.txt"
for domain in api.nuget.org nuget.org; do
  echo "Resolving $domain:" >> "$RESOLVED_DOMAINS"
  dig +short $domain >> "$RESOLVED_DOMAINS"
  host $domain >> "$RESOLVED_DOMAINS"
  echo "---" >> "$RESOLVED_DOMAINS"
done

# Try to access nuget.org with curl to see what headers and URLs are needed
echo "Testing access to nuget.org..."
CURL_OUTPUT="network-capture/dotnet-curl-output.txt"
curl -v https://api.nuget.org/v3/index.json > "$CURL_OUTPUT" 2>&1

# Create a NuGet.config file to see what domains are accessed when configured
echo "Creating and testing NuGet.config..."
mkdir -p /tmp/nuget-test
cat > /tmp/nuget-test/NuGet.config << EOL
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
  </packageSources>
</configuration>
EOL

# Run with the NuGet.config
cd /tmp/nuget-test
strace -f -e trace=network -s 1024 -o "dotnet-strace-with-config.txt" dotnet new install Aspire.ProjectTemplates::9.3.0 --force
cp dotnet-strace-with-config.txt /home/runner/work/infinite-canvas/infinite-canvas/network-capture/

# Create summary report
echo "Creating summary report..."
cat > "$SUMMARY_FILE" << EOL
# Firewall Rules for dotnet new install Aspire.ProjectTemplates::9.3.0

This report summarizes the network connections required for the \`dotnet new install Aspire.ProjectTemplates::9.3.0\` command.

## Summary

The \`dotnet new install\` command requires connectivity to NuGet package feeds. By default, it uses api.nuget.org.

## Required Domains

The following domains need to be accessible:

1. **api.nuget.org** - Primary NuGet API endpoint
2. **nugetapiprod.trafficmanager.net** - CNAME for api.nuget.org
3. **apiprod-mscdn.azureedge.net** - CDN for NuGet packages
4. **apiprod-mscdn.afd.azureedge.net** - Azure Front Door for NuGet packages
5. **azureedge-t-prod.trafficmanager.net** - Azure CDN traffic manager
6. **s-part-0013.t-0009.t-msedge.net** - Microsoft Edge CDN network

## Required Endpoints

1. **https://api.nuget.org/v3/index.json** - NuGet API v3 endpoint
2. **HTTPS connections to all domains listed above** - Port 443

## Firewall Configuration Recommendations

To allow \`dotnet new install\` to work properly, configure your firewall to allow:

1. **DNS resolution** for all listed domains
2. **HTTPS traffic (TCP port 443)** to all listed domains and their resolved IP addresses
3. **HTTP traffic (TCP port 80)** for redirects, though most traffic will be HTTPS

## Test Results

A test HTTP request to api.nuget.org shows the following:

\`\`\`
$(head -20 "$CURL_OUTPUT")
\`\`\`

## Detailed Connection Attempts

DNS lookups:
\`\`\`
$(head -10 "$DNS_LOOKUPS")
\`\`\`

Connection attempts:
\`\`\`
$(head -10 "$CONNECT_ATTEMPTS")
\`\`\`

EOL

echo "========================================================================"
echo "Network capture complete. Results available in the network-capture directory."
echo "Summary report: $SUMMARY_FILE"