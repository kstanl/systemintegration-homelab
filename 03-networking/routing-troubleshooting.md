# Routing Troubleshooting

## Objective

Test Linux routing, intentionally remove the default route, diagnose the failure, and restore connectivity.

## Network

- Linux server: `192.168.122.102`
- DC01: `192.168.122.20`
- Gateway: `192.168.122.1`
- Interface: `ens3`

## Check Routing

```bash
ip route
ip route get 192.168.122.20
ip route get 8.8.8.8
```

DC01 was reached directly because it is on the local subnet.

Internet traffic used the default gateway:

```text
8.8.8.8 via 192.168.122.1 dev ens3
```

`tracepath 8.8.8.8` was also used to inspect the network path.

## Introduce a Routing Fault

The default route was intentionally removed:

```bash
sudo ip route del default
```

Local connectivity still worked:

```bash
ping -c 2 192.168.122.20
ping -c 2 192.168.122.1
```

Internet connectivity failed:

```bash
ping -c 2 8.8.8.8
```

Result:

```text
Network is unreachable
```

The routing table confirmed the problem:

```bash
ip route get 8.8.8.8
```

Result:

```text
RTNETLINK answers: Network is unreachable
```

## Fix

The default route was restored:

```bash
sudo ip route add default via 192.168.122.1 dev ens3
```

Verification:

```bash
ip route show default
ping -c 2 8.8.8.8
```

Internet connectivity worked again.

## Key Lesson

A system can communicate with devices on its local subnet even when its default route is missing.

When local connectivity works but remote networks fail, check the routing table and default gateway.
