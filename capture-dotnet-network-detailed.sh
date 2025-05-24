#!/bin/bash

# Script to capture network connections made by the dotnet new install command with more detail
# This helps determine what firewall rules are needed for the command to work

echo "Starting detailed network capture for dotnet new install Aspire.ProjectTemplates::9.3.0"
echo "========================================================================"

# Create output directory
mkdir -p network-capture
OUTPUT_FILE="network-capture/dotnet-network-capture-detailed.txt"
DNS_DOMAINS_FILE="network-capture/dotnet-dns-domains-detailed.txt"
TCP_CONNECTIONS_FILE="network-capture/dotnet-tcp-connections.txt"
RESOLVED_IPS_FILE="network-capture/dotnet-resolved-ips.txt"
SUMMARY_FILE="network-capture/dotnet-firewall-summary-detailed.md"

# Clear existing captures
rm -f network-capture/dotnet-network-detailed.pcap

# Start tcpdump with more details in the background
echo "Starting tcpdump to capture network traffic..."
sudo tcpdump -i any -n -v -s 0 host not localhost and not 127.0.0.1 -w network-capture/dotnet-network-detailed.pcap &
TCPDUMP_PID=$!

# Start DNS monitoring
echo "Starting DNS monitoring..."
dig +short api.nuget.org > "$RESOLVED_IPS_FILE" 2>&1 &
DIG_PID=$!

# Give tcpdump a moment to start
sleep 2

echo "Running dotnet command with diagnostics..."
echo "========================================================================"
# Run the dotnet command with verbose logging
DOTNET_CLI_UI_LANGUAGE=en DOTNET_NOLOGO=true NUGET_SHOW_STACK=true NUGET_HTTP_CACHE_TIMEOUT=0 \
dotnet --info
DOTNET_CLI_UI_LANGUAGE=en DOTNET_NOLOGO=true NUGET_SHOW_STACK=true NUGET_HTTP_CACHE_TIMEOUT=0 \
dotnet new install Aspire.ProjectTemplates::9.3.0 --force -d
DOTNET_EXIT_CODE=$?
echo "========================================================================"
echo "dotnet command completed with exit code: $DOTNET_EXIT_CODE"

# Give tcpdump a moment to capture all traffic
sleep 3

# Stop monitoring
echo "Stopping tcpdump..."
sudo kill $TCPDUMP_PID 2>/dev/null
kill $DIG_PID 2>/dev/null

# Process the capture file to extract useful information
echo "Processing capture file..."
sudo tcpdump -r network-capture/dotnet-network-detailed.pcap -v > "$OUTPUT_FILE"

# Extract DNS requests
echo "Extracting DNS domains..."
cat "$OUTPUT_FILE" | grep -E "A\?|AAAA\?" | grep -oE "[a-zA-Z0-9.-]+\.(com|org|net|io|dev|microsoft|nuget|visualstudio)" | sort | uniq > "$DNS_DOMAINS_FILE"

# Add CNAME resolutions from DNS responses
cat "$OUTPUT_FILE" | grep -E "CNAME" | grep -oE "[a-zA-Z0-9.-]+\.(com|org|net|io|dev|microsoft|nuget|visualstudio|msedge|trafficmanager|azure|azureedge)[a-zA-Z0-9.-]*" | sort | uniq >> "$DNS_DOMAINS_FILE"
sort -u "$DNS_DOMAINS_FILE" -o "$DNS_DOMAINS_FILE"

# Extract TCP connections
echo "Extracting TCP connections..."
cat "$OUTPUT_FILE" | grep -E "Flags \[S\]" | awk '{print $3 " > " $5}' | sed 's/:.*//' | sort | uniq > "$TCP_CONNECTIONS_FILE"

# Create summary report
echo "Creating summary report..."
cat > "$SUMMARY_FILE" << EOL
# Network Connections for dotnet new install Aspire.ProjectTemplates::9.3.0

This report shows the domains, IPs, and connections that need to be allowed through a firewall for the \`dotnet new install Aspire.ProjectTemplates::9.3.0\` command to function properly.

## DNS Domains

The following domains were resolved or referenced during the operation:

\`\`\`
$(cat "$DNS_DOMAINS_FILE")
\`\`\`

## Resolved IP Addresses

\`\`\`
$(cat "$RESOLVED_IPS_FILE")
\`\`\`

## TCP Connection Attempts

The following TCP connections were attempted:

\`\`\`
$(cat "$TCP_CONNECTIONS_FILE")
\`\`\`

## Firewall Rules Summary

To allow the \`dotnet new install Aspire.ProjectTemplates::9.3.0\` command to function properly, firewall rules should allow traffic to:

1. DNS servers for resolving the above domains
2. The following domains and their resolved IP addresses:
$(cat "$DNS_DOMAINS_FILE" | while read domain; do echo "   - $domain"; done)

3. The following TCP connections:
$(cat "$TCP_CONNECTIONS_FILE" | while read conn; do echo "   - $conn"; done)

## Additional Information

The \`dotnet new install\` command attempts to download template packages from NuGet feeds. The default feed is api.nuget.org, but additional feeds can be configured in the NuGet.config file.

EOL

echo "========================================================================"
echo "Network capture complete. Results available in the network-capture directory."
echo "Summary report: $SUMMARY_FILE"
echo "Raw capture: $OUTPUT_FILE"
echo "DNS domains: $DNS_DOMAINS_FILE"
echo "TCP connections: $TCP_CONNECTIONS_FILE"