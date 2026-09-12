# Initial Boot and Network Discovery

## Objective

The objective of this stage was to start the existing Ubuntu Server virtual machine and determine its initial network configuration before making any configuration changes.

## 1. Starting the Virtual Machine

The virtual machine was started and its state was verified using:

```bash
virsh -c qemu:///system list
```

### Result

```text
Id   Name          State
------------------------
1    srv-linux01   running
```

This confirmed that the virtual machine `srv-linux01` was running successfully.

## 2. Discovering the IP Address

The network address assigned to the VM was inspected using:

```bash
virsh -c qemu:///system domifaddr srv-linux01
```

### Result

```text
Name    MAC address         Protocol   Address
----------------------------------------------------
vnet0   52:54:00:50:82:76  ipv4       192.168.122.41/24
```

The VM currently has the IPv4 address:

```text
192.168.122.41/24
```

## 3. Checking the DHCP Lease

The DHCP leases for the libvirt `default` network were inspected using:

```bash
virsh -c qemu:///system net-dhcp-leases default
```

The VM was identified using its MAC address:

```text
52:54:00:50:82:76
```

The lease showed:

```text
IP address: 192.168.122.41/24
Hostname:   kstan-server
```

This indicates that the VM received its current IPv4 configuration through DHCP.

## 4. VM Name and Guest Hostname Observation

The virtual machine is registered in libvirt as:

```text
srv-linux01
```

However, the DHCP lease currently reports the hostname:

```text
kstan-server
```

This suggests that renaming the libvirt domain did not change the hostname configured inside the Ubuntu guest operating system.

The guest hostname will be verified from inside Ubuntu before it is changed.

## 5. Inspecting the Virtual Network Interface

The virtual network interface was inspected using:

```bash
virsh -c qemu:///system domiflist srv-linux01
```

### Result

```text
Interface   Type      Source    Model    MAC
---------------------------------------------
vnet0       network   default   virtio   52:54:00:50:82:76
```

The VM is therefore connected to:

- Interface: `vnet0`
- libvirt network: `default`
- Adapter model: `virtio`
- MAC address: `52:54:00:50:82:76`

## 6. Current Network State

At this stage the known network configuration is:

| Property | Value |
|---|---|
| VM name | `srv-linux01` |
| VM state | Running |
| Virtual interface | `vnet0` |
| Network | `default` |
| Adapter | VirtIO |
| MAC address | `52:54:00:50:82:76` |
| IPv4 address | `192.168.122.41/24` |
| Address assignment | DHCP |
| DHCP-reported hostname | `kstan-server` |

No network configuration has been changed yet.

## 7. Next Step

The next stage is to verify communication between the host and the server.

The following will be tested:

1. IP connectivity
2. Host routing to the VM
3. TCP port 22 availability
4. SSH access

After successful remote access, the network configuration will be inspected from inside the Ubuntu Server guest.


## 8. Testing IP Connectivity

After discovering the server's IP address, I tested connectivity from the Linux host to the virtual machine.

### Command

```bash
ping -c 4 192.168.122.41
```

### Result

```text
4 packets transmitted, 4 received, 0% packet loss
```

The response times were below 1 millisecond.

This confirmed that the host could successfully communicate with the Ubuntu Server VM over the libvirt virtual network.

---

## 9. Inspecting the Route to the VM

I checked which route the host uses to reach the virtual machine.

### Command

```bash
ip route get 192.168.122.41
```

### Result

```text
192.168.122.41 dev virbr0 src 192.168.122.1 uid 1000
```

This shows that traffic destined for the VM is sent through:

```text
virbr0
```

The host uses:

```text
192.168.122.1
```

as its source address on this virtual network.

`virbr0` is the Linux bridge associated with the libvirt `default` network.

The topology at this stage can therefore be represented as:

```text
Ubuntu Host
192.168.122.1
      |
    virbr0
      |
libvirt default network
      |
      v
srv-linux01
192.168.122.41
```

---

## 10. Testing the SSH Service Port

Before attempting an SSH login, I tested whether TCP port 22 was reachable.

### Command

```bash
nc -zv 192.168.122.41 22
```

### Result

```text
Connection to 192.168.122.41 22 port [tcp/ssh] succeeded!
```

This confirmed that:

- The server was reachable
- TCP port 22 was open
- An SSH service was accepting connections

Testing the service port separately helps distinguish a network connectivity problem from an SSH authentication or configuration problem.

---

## 11. Testing SSH Access

I then tested remote administration using SSH.

### Command

```bash
ssh kstan@192.168.122.41
```

The connection was successful and the Ubuntu Server login banner was displayed.

The server reported:

```text
Ubuntu 26.04.1 LTS
GNU/Linux 7.0.0-31-generic x86_64
```

The server's primary network interface was reported as:

```text
ens3
```

with the IPv4 address:

```text
192.168.122.41
```

After login, the shell prompt displayed:

```text
kstan@kstan-server:~$
```

This confirmed that the hostname configured inside the guest operating system is still:

```text
kstan-server
```

although the libvirt virtual machine itself has already been renamed to:

```text
srv-linux01
```

This demonstrates that the libvirt domain name and the guest operating system hostname are independent settings.

---

## 12. Connectivity Verification Summary

The initial network tests produced the following results:

| Test | Result |
|---|---|
| VM running | Yes |
| IPv4 address assigned | `192.168.122.41/24` |
| Host to guest ping | Successful |
| Packet loss | 0% |
| Host virtual interface | `virbr0` |
| Host virtual IP | `192.168.122.1` |
| SSH TCP port | 22 |
| TCP port 22 reachable | Yes |
| SSH login | Successful |
| Guest network interface | `ens3` |
| Guest hostname | `kstan-server` |

The host and Ubuntu Server VM can therefore communicate successfully over the libvirt `default` network.

---

## 13. Troubleshooting Observation

During testing, I initially entered an incorrect virtual machine name:

```bash
virsh -c qemu:///system domifaddr svr-linux01
```

which returned:

```text
error: failed to get domain 'svr-linux01'
```

The correct VM name is:

```text
srv-linux01
```

After correcting the spelling, the command worked successfully.

This demonstrates an important troubleshooting principle: command errors should first be checked for incorrect syntax, object names, and typing mistakes before assuming there is a problem with the underlying service.

---

## 14. Current Status

The Ubuntu Server VM is now:

- Running successfully
- Connected to the libvirt `default` network
- Receiving an IPv4 address through DHCP
- Reachable from the host
- Accepting SSH connections
- Remotely manageable through SSH

No guest network configuration has been modified yet.

The next stage is to inspect the operating system from inside the VM before making changes.
