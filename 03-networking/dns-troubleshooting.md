# DNS Troubleshooting

## Objective

Test DNS resolution, intentionally configure an incorrect DNS server, diagnose the failure, and restore name resolution.

## Network

- Linux server: `192.168.122.102`
- DNS server / DC01: `192.168.122.20`
- Interface: `ens3`
- Internal domain: `ad.kstanlab.test`

## Verify DNS Configuration

The DNS configuration was checked with:

```bash
resolvectl status ens3
```

The Linux server was using DC01 as its DNS server:

```text
DNS Servers: 192.168.122.20
```

## Test Name Resolution

External DNS resolution was tested:

```bash
resolvectl query google.com
```

Internal DNS resolution was tested:

```bash
resolvectl query dc01.ad.kstanlab.test
```

The internal hostname correctly resolved to:

```text
192.168.122.20
```

Direct IP connectivity also worked:

```bash
ping 192.168.122.20
```

## Introduce a DNS Fault

An incorrect DNS server was configured intentionally:

```bash
sudo resolvectl dns ens3 192.168.122.99
```

The configuration was verified:

```bash
resolvectl status ens3
```

Result:

```text
DNS Servers: 192.168.122.99
```

## Diagnose the Problem

Direct IP connectivity to DC01 still worked:

```bash
ping 192.168.122.20
```

However, hostname resolution failed:

```bash
ping dc01.ad.kstanlab.test
```

Result:

```text
Temporary failure in name resolution
```

External DNS resolution also failed:

```bash
resolvectl query google.com
```

This demonstrated that basic network connectivity was working while DNS resolution was not.

## Fix

The correct DNS server was restored:

```bash
sudo resolvectl dns ens3 192.168.122.20
```

The configuration was verified:

```bash
resolvectl status ens3
```

Internal and external DNS were tested again:

```bash
resolvectl query dc01.ad.kstanlab.test
resolvectl query google.com
```

Both queries succeeded.

## Key Lesson

If a system can reach another device by IP address but cannot reach it by hostname, check DNS.

A useful troubleshooting sequence is:

```text
Check IP connectivity
        ↓
Check hostname resolution
        ↓
Check configured DNS server
        ↓
Test DNS queries
        ↓
Correct DNS configuration
        ↓
Verify resolution
```

IP connectivity and DNS resolution are separate parts of network troubleshooting.
