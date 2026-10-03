# Networking and Troubleshooting

This section documents practical networking and troubleshooting exercises in my Systemintegration homelab.

## Topics

- IP addressing and routing
- DNS resolution
- Network connectivity testing
- TCP port testing
- Service troubleshooting
- Windows and Linux network diagnostics

## Labs

### RDP Connectivity Troubleshooting

Investigated an RDP connectivity problem between Ubuntu Server and Windows Server 2022.

The troubleshooting process verified network connectivity, DNS, service ports, Windows services, firewall rules, and the RDP listener.

See:

[ RDP Connectivity Troubleshooting](rdp-connectivity-troubleshooting.md)


### Routing Troubleshooting

Investigated Linux routing by intentionally removing the default route, diagnosing loss of external connectivity, and restoring the route.

See:

[Routing Troubleshooting](routing-troubleshooting.md)



### DNS Troubleshooting

Investigated a DNS failure by intentionally configuring an incorrect DNS server while maintaining normal IP connectivity.

The exercise demonstrated how to distinguish DNS problems from general network connectivity problems.

See:

[DNS Troubleshooting](dns-troubleshooting.md)



### TCP/UDP Ports and Service Connectivity

Investigated TCP service connectivity using SSH, `ss`, Netcat, systemd services, and socket activation.

The exercise included intentionally disabling TCP port 22, diagnosing the failure, and restoring the service.

See:

[TCP/UDP Ports and Service Connectivity](service-connectivity-troubleshooting.md)
