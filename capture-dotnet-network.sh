#!/bin/bash

# Script to capture network connections made by the dotnet new install command
# This helps determine what firewall rules are needed for the command to work

echo "Starting network capture for dotnet new install Aspire.ProjectTemplates::9.3.0"
echo "========================================================================"

# Create output directory
mkdir -p network-capture
OUTPUT_FILE="network-capture/dotnet-network-capture.txt"
DNS_DOMAINS_FILE="network-capture/dotnet-dns-domains.txt"
HTTP_CONNECTIONS_FILE="network-capture/dotnet-http-connections.txt"
SUMMARY_FILE="network-capture/dotnet-firewall-summary.md"

# Start tcpdump in the background to capture all network traffic
echo "Starting tcpdump to capture network traffic..."
sudo tcpdump -i any -n -v host not localhost and not 127.0.0.1 -w network-capture/dotnet-network.pcap &
TCPDUMP_PID=$!

# Give tcpdump a moment to start
sleep 2

echo "Running dotnet new install command..."
echo "========================================================================"
# Run the dotnet command
dotnet new install Aspire.ProjectTemplates::9.3.0 --force
DOTNET_EXIT_CODE=$?
echo "========================================================================"
echo "dotnet command completed with exit code: $DOTNET_EXIT_CODE"

# Give tcpdump a moment to capture all traffic
sleep 3

# Stop tcpdump
echo "Stopping tcpdump..."
sudo kill $TCPDUMP_PID

# Process the capture file to extract useful information
echo "Processing capture file..."
sudo tcpdump -r network-capture/dotnet-network.pcap -v > "$OUTPUT_FILE"

# Extract DNS requests to identify domains
echo "Extracting DNS domains..."
grep -E "A\?" "$OUTPUT_FILE" | grep -oE "[a-zA-Z0-9.-]+\.(com|org|net|io|dev|microsoft|nuget|visualstudio|api|aspnetcdn|dotnetfoundation)[a-zA-Z0-9./-]*" | sort | uniq > "$DNS_DOMAINS_FILE"

# Extract HTTP connections
echo "Extracting HTTP connections..."
grep -E "GET|POST|PUT|DELETE" "$OUTPUT_FILE" | grep -oE "https?://[a-zA-Z0-9.-]+\.[a-zA-Z]+[a-zA-Z0-9./-]*" | sort | uniq > "$HTTP_CONNECTIONS_FILE"

# Create summary report
echo "Creating summary report..."
cat > "$SUMMARY_FILE" << EOL
# Network Connections for dotnet new install Aspire.ProjectTemplates::9.3.0

This report shows the domains and connections that need to be allowed through a firewall for the \`dotnet new install Aspire.ProjectTemplates::9.3.0\` command to function properly.

## DNS Domains

The following domains were resolved during the operation:

\`\`\`
$(cat "$DNS_DOMAINS_FILE")
\`\`\`

## HTTP Connections

The following HTTP endpoints were accessed:

\`\`\`
$(cat "$HTTP_CONNECTIONS_FILE")
\`\`\`

## Firewall Rules Summary

To allow the \`dotnet new install Aspire.ProjectTemplates::9.3.0\` command to function properly, ensure the following domains are accessible:

$(cat "$DNS_DOMAINS_FILE" | while read domain; do echo "- $domain"; done)

EOL

echo "========================================================================"
echo "Network capture complete. Results available in the network-capture directory."
echo "Summary report: $SUMMARY_FILE"
echo "Raw capture: $OUTPUT_FILE"
echo "DNS domains: $DNS_DOMAINS_FILE"
echo "HTTP connections: $HTTP_CONNECTIONS_FILE"