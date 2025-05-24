# Network Capture Data

This directory contains data captured during network analysis of the `dotnet new install Aspire.ProjectTemplates::9.3.0` command. These files were used to identify the required firewall rules documented in the main FIREWALL_REQUIREMENTS.md file.

## Files in this Directory

### Raw Capture Files
- `dotnet-network.pcap` - Raw packet capture from tcpdump
- `dotnet-network-detailed.pcap` - More detailed packet capture with additional flags

### Processed Data Files
- `dotnet-dns-domains.txt` - DNS domains resolved during command execution
- `dotnet-dns-domains-detailed.txt` - More comprehensive list of DNS domains
- `dotnet-http-connections.txt` - HTTP connections observed
- `dotnet-tcp-connections.txt` - TCP connection attempts
- `dotnet-connect-attempts.txt` - Connection attempts detected via strace
- `dotnet-dns-lookups.txt` - DNS lookup system calls detected via strace
- `dotnet-resolved-domains.txt` - Results of manually resolving key domains
- `dotnet-resolved-ips.txt` - IP addresses resolved from key domains
- `dotnet-curl-output.txt` - Output from curl when accessing the NuGet API endpoint

### Analysis Reports
- `dotnet-network-capture.txt` - Processed output from tcpdump
- `dotnet-network-capture-detailed.txt` - More detailed processed output
- `dotnet-strace-output.txt` - System call trace output
- `dotnet-strace-with-config.txt` - System call trace with NuGet.config present
- `dotnet-firewall-summary.md` - Initial summary of findings
- `dotnet-firewall-summary-detailed.md` - More detailed summary

## Usage

These files are provided for reference purposes. For actionable information, refer to the main FIREWALL_REQUIREMENTS.md file in the repository root.