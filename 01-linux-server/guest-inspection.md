# Ubuntu Server Guest Inspection

## Objective

The objective of this stage was to inspect the Ubuntu Server guest from inside the virtual machine before making configuration changes.

The inspection focused on:

- Hostname
- Virtualization environment
- Network configuration
- Routing
- Storage layout
- Filesystem usage
- SSH service status

---

## 1. Hostname Inspection

The current hostname was checked using:

```bash
hostname
```

### Result

```text
kstan-server
```

Additional system information was inspected using:

```bash
hostnamectl
```

Important results included:

```text
Static hostname: kstan-server
Virtualization: kvm
Operating System: Ubuntu 26.04.1 LTS
Kernel: Linux 7.0.0-31-generic
Architecture: x86-64
Hardware Vendor: QEMU
```

This confirmed that the guest operating system hostname is still:

```text
kstan-server
```

while the libvirt virtual machine has already been renamed to:

```text
srv-linux01
```

The libvirt domain name and the operating system hostname are separate configuration items.

The guest hostname will be changed in a later step.

---

## 2. Network Interface Inspection

The network configuration was inspected using:

```bash
ip addr
```

The primary network interface is:

```text
ens3
```

Its MAC address is:

```text
52:54:00:50:82:76
```

Its current IPv4 address is:

```text
192.168.122.41/24
```

The address is dynamically assigned.

The interface was reported as:

```text
UP
LOWER_UP
```

which indicates that the interface is enabled and its lower network layer is operational.

---

## 3. Routing Inspection

The routing table was inspected using:

```bash
ip route
```

### Result

```text
default via 192.168.122.1 dev ens3 proto dhcp src 192.168.122.41 metric 100
192.168.122.0/24 dev ens3 proto kernel scope link src 192.168.122.41 metric 100
192.168.122.1 dev ens3 proto dhcp scope link src 192.168.122.41 metric 100
```

The default gateway is:

```text
192.168.122.1
```

The server belongs to the network:

```text
192.168.122.0/24
```

Traffic destined outside the local subnet is sent through the default gateway.

---

## 4. Block Device Inspection

The available block devices were inspected using:

```bash
lsblk
```

The main virtual disk is:

```text
vda
```

with a total virtual capacity of:

```text
50G
```

The partition structure is:

```text
vda
├─vda1    1M
├─vda2    2G   /boot
└─vda3   48G
  └─ubuntu--vg-ubuntu--lv   24G   /
```

The VM therefore uses LVM for its root filesystem.

The main 48 GiB partition is used by the LVM volume group, but the root logical volume currently has a size of only approximately:

```text
24G
```

This indicates that not all available LVM capacity is currently assigned to the root logical volume.

Further inspection of the volume group and logical volumes will be performed before making any storage changes.

---

## 5. Filesystem Usage

Filesystem usage was checked using:

```bash
df -h
```

The root filesystem is:

```text
/dev/mapper/ubuntu--vg-ubuntu--lv
```

with approximately:

```text
24G total
6.9G used
16G available
31% used
```

The `/boot` filesystem is located on:

```text
/dev/vda2
```

with approximately:

```text
2.0G total
98M used
```

This confirmed that the 50 GiB virtual disk is not fully allocated to the root filesystem.

---

## 6. SSH Service Inspection

The SSH service was checked using:

```bash
systemctl status ssh --no-pager
```

The SSH service was active:

```text
Active: active (running)
```

The logs showed successful public-key authentication for the user:

```text
kstan
```

using an ED25519 SSH key.

Example log entry:

```text
Accepted publickey for kstan from 192.168.122.1
```

This confirms that remote administration using SSH public-key authentication is functioning.

---

## 7. Command Syntax Troubleshooting

During the inspection I initially entered:

```bash
systemctl status ssh -- no-pager
```

This produced:

```text
Unit no-pager.service could not be found.
```

The problem was caused by the space between:

```text
--
```

and:

```text
no-pager
```

The correct option is:

```bash
systemctl status ssh --no-pager
```

This demonstrates that incorrect command-line option syntax can cause a program to interpret an option as a separate argument or service name.

---

## 8. Current Guest State

| Component | Current State |
|---|---|
| Guest hostname | `kstan-server` |
| Guest OS | Ubuntu 26.04.1 LTS |
| Kernel | Linux 7.0.0-31-generic |
| Architecture | x86-64 |
| Virtualization | KVM |
| Virtual hardware | QEMU |
| Network interface | `ens3` |
| IPv4 address | `192.168.122.41/24` |
| Default gateway | `192.168.122.1` |
| Disk | 50 GiB |
| Root logical volume | 24 GiB |
| Root filesystem usage | 31% |
| SSH | Active |
| SSH public-key login | Working |

---

## 9. Next Steps

The next configuration tasks are:

1. Change the guest hostname from `kstan-server` to `srv-linux01`
2. Verify hostname resolution
3. Inspect LVM free space
4. Decide whether to extend the root logical volume
5. Inspect the current network configuration files
6. Prepare for static IP configuration
