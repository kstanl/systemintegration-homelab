# Subnetting and Network Segmentation

## Objective

Understand how a larger IPv4 network can be divided into smaller subnets and calculate the usable address ranges.

## What Is Subnetting?

Subnetting divides one IP network into smaller networks.

For example:

```text
192.168.50.0/24
```

A `/24` network contains 256 total addresses:

```text
Network address:     192.168.50.0
First usable host:   192.168.50.1
Last usable host:    192.168.50.254
Broadcast address:   192.168.50.255
Usable hosts:        254
Subnet mask:         255.255.255.0
```

## Company Example

Assume a company has four departments:

```text
IT
Sales
HR
Servers
```

The company has been assigned:

```text
192.168.50.0/24
```

Instead of placing all devices in one network, the administrator wants one equal subnet for each department.

The `/24` network must therefore be divided into four equal networks.

## Calculate the Subnets

A `/24` contains:

```text
256 addresses
```

We need four subnets:

```text
256 ÷ 4 = 64 addresses per subnet
```

Each subnet therefore contains 64 total addresses.

Four equal subdivisions of a `/24` require a `/26` prefix:

```text
CIDR:        /26
Subnet mask: 255.255.255.192
```

A `/26` provides:

```text
64 total addresses
62 usable host addresses
```

Two addresses cannot normally be assigned to hosts:

```text
1 network address
1 broadcast address
```

Therefore:

```text
64 - 2 = 62 usable hosts
```

## Find the Network Addresses

Because each subnet contains 64 addresses, count in blocks of 64:

```text
0
0 + 64   = 64
64 + 64  = 128
128 + 64 = 192
```

The four network addresses are therefore:

```text
192.168.50.0/26
192.168.50.64/26
192.168.50.128/26
192.168.50.192/26
```

## Subnet 1 - IT

The first subnet starts at `.0`.

The second subnet starts at `.64`.

The address immediately before `.64` is `.63`, so `.63` is the broadcast address.

```text
Network:       192.168.50.0/26
First usable:  192.168.50.1
Last usable:   192.168.50.62
Broadcast:     192.168.50.63
```

## Subnet 2 - Sales

The second subnet starts at `.64`.

The third subnet starts at `.128`.

The address immediately before `.128` is `.127`.

```text
Network:       192.168.50.64/26
First usable:  192.168.50.65
Last usable:   192.168.50.126
Broadcast:     192.168.50.127
```

## Subnet 3 - HR

The third subnet starts at `.128`.

The fourth subnet starts at `.192`.

The address immediately before `.192` is `.191`.

```text
Network:       192.168.50.128/26
First usable:  192.168.50.129
Last usable:   192.168.50.190
Broadcast:     192.168.50.191
```

## Subnet 4 - Servers

The fourth subnet starts at `.192`.

The original `/24` network ends at `.255`.

```text
Network:       192.168.50.192/26
First usable:  192.168.50.193
Last usable:   192.168.50.254
Broadcast:     192.168.50.255
```

## Final Network Design

| Department | Network | First Host | Last Host | Broadcast |
|---|---|---|---|---|
| IT | `192.168.50.0/26` | `192.168.50.1` | `192.168.50.62` | `192.168.50.63` |
| Sales | `192.168.50.64/26` | `192.168.50.65` | `192.168.50.126` | `192.168.50.127` |
| HR | `192.168.50.128/26` | `192.168.50.129` | `192.168.50.190` | `192.168.50.191` |
| Servers | `192.168.50.192/26` | `192.168.50.193` | `192.168.50.254` | `192.168.50.255` |

## Calculation Method

For a `/26`, remember:

```text
Block size = 64

0 → 64 → 128 → 192 → 256
```

For each subnet:

```text
Network address = first address
First host      = network address + 1
Broadcast       = address before the next network
Last host       = broadcast address - 1
```

## Why Segment a Network?

Network segmentation can help:

- Separate different departments or device types.
- Reduce the size of broadcast domains.
- Organize IP address allocation.
- Apply different security rules between networks.
- Make network administration and troubleshooting easier.

Communication between different IP subnets normally requires a router or Layer 3 device.

## Key Lesson

Subnetting is easier when the block size is known.

For this exercise:

```text
192.168.50.0/24
        ↓
Divide into 4 equal networks
        ↓
256 ÷ 4 = 64 addresses
        ↓
/26
        ↓
0 → 64 → 128 → 192
```

This creates four `/26` networks with 62 usable host addresses in each subnet.
