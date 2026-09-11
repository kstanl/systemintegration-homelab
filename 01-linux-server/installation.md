# Ubuntu Server Virtual Machine - Initial Assessment

## Objective

The objective of this project is to build and administer an Ubuntu Server virtual machine using KVM/QEMU and libvirt.

Before creating a new virtual machine, I inspected my existing virtualization environment to determine whether an existing Ubuntu Server VM could be reused.

The existing VM was found to have sufficient CPU, memory, storage, and network resources for the Linux server administration project.

---

## 1. Environment

The current lab environment consists of:

| Component | Configuration |
|---|---|
| Host operating system | Ubuntu Linux |
| CPU | AMD Ryzen 7 7730U |
| CPU cores / threads | 8 cores / 16 threads |
| Hardware virtualization | AMD-V |
| Hypervisor | KVM/QEMU |
| Virtualization management | libvirt |
| Guest operating system | Ubuntu Server |
| Server name | `srv-linux01` |
| Virtual CPUs | 4 |
| Memory | 4 GiB |
| Virtual disk | 50 GiB qcow2 |
| Virtual network | libvirt `default` network |
| Network adapter | VirtIO |

---

## 2. CPU Virtualization Check

Before working with the virtual machine, I verified that the host processor supports hardware virtualization.

### Command

```bash
lscpu | grep Virtualization
```

### Result

```text
Virtualization: AMD-V
```

### Explanation

AMD-V is AMD's hardware virtualization technology.

Hardware virtualization allows a hypervisor such as KVM to execute virtual machines efficiently using virtualization capabilities provided directly by the processor.

The presence of `AMD-V` confirmed that the host system supports hardware-assisted virtualization.

A more detailed inspection using:

```bash
lscpu
```

showed that the system uses an:

```text
AMD Ryzen 7 7730U with Radeon Graphics
```

with:

```text
8 physical cores
16 logical CPUs
```

This provides sufficient CPU resources for running several virtual machines as the homelab expands.

---

## 3. Existing Virtual Machine Assessment

Before creating another Ubuntu Server VM, I inspected the existing libvirt environment.

### Command

```bash
virsh -c qemu:///system list --all
```

### Result

The environment contained an existing virtual machine:

```text
Id   Name           State
-------------------------------
-    kstan-server   shut off
```

The VM was powered off but remained registered with libvirt.

Rather than immediately creating another VM, I decided to inspect its configuration and determine whether it could be reused.

---

## 4. Inspecting VM Resources

I inspected the VM configuration using:

```bash
virsh -c qemu:///system dominfo kstan-server
```

### Important Results

```text
Name:           kstan-server
OS Type:        hvm
State:          shut off
CPU(s):         4
Max memory:     4194304 KiB
Used memory:    4194304 KiB
Persistent:     yes
Autostart:      disable
Security model: apparmor
```

### Interpretation

The VM is configured with:

- 4 virtual CPUs
- 4 GiB RAM
- Persistent libvirt configuration
- AppArmor security
- Autostart disabled

A persistent VM remains defined in libvirt even after it has been shut down.

The VM resources are sufficient for the Linux server administration exercises planned for this project.

---

## 5. Virtual Disk Inspection

The storage devices attached to the VM were inspected using:

```bash
virsh -c qemu:///system domblklist kstan-server
```

### Result

```text
Target   Source
------------------------------------------------------
vda      /var/lib/libvirt/images/kstan-server.qcow2
hda      -
```

The primary virtual disk is:

```text
/var/lib/libvirt/images/kstan-server.qcow2
```

The virtual disk is presented to the guest as:

```text
vda
```

The `hda` entry currently has no media attached.

---

## 6. Inspecting the qcow2 Disk

To examine the virtual disk itself, I used:

```bash
sudo qemu-img info /var/lib/libvirt/images/kstan-server.qcow2
```

### Important Results

```text
file format: qcow2
virtual size: 50 GiB
disk size: 3.59 GiB
cluster_size: 65536
corrupt: false
```

### Disk Configuration

| Property | Value |
|---|---|
| Image file | `kstan-server.qcow2` |
| Format | qcow2 |
| Virtual capacity | 50 GiB |
| Current host storage usage | 3.59 GiB |
| Cluster size | 65,536 bytes |
| Corruption reported | No |

### Understanding Virtual Size vs Disk Size

The virtual disk has a capacity of:

```text
50 GiB
```

However, the qcow2 image currently consumes approximately:

```text
3.59 GiB
```

of physical storage on the host.

The virtual size represents the disk capacity presented to the virtual machine, while the current disk size represents approximately how much host storage the image currently occupies.

This demonstrates one of the useful characteristics of qcow2 storage: the image does not need to consume its entire virtual capacity immediately and can grow as data is written to it.

The output also reported:

```text
corrupt: false
```

so `qemu-img` did not report the image as corrupted.

---

## 7. Virtual Network Inspection

I inspected the network interface attached to the VM using:

```bash
virsh -c qemu:///system domiflist kstan-server
```

### Result

```text
Interface   Type      Source    Model    MAC
-------------------------------------------------------------
-           network   default   virtio   52:54:00:50:82:76
```

### Interpretation

The VM is connected to the libvirt network named:

```text
default
```

The virtual network adapter uses:

```text
virtio
```

and has the MAC address:

```text
52:54:00:50:82:76
```

VirtIO provides paravirtualized devices designed for efficient communication between virtual machines and the KVM/QEMU virtualization environment.

---

## 8. Checking the libvirt Network

I checked the available libvirt virtual networks using:

```bash
virsh -c qemu:///system net-list --all
```

### Result

```text
Name      State    Autostart   Persistent
--------------------------------------------
default   active   yes         yes
```

The `default` network is:

- Active
- Configured to start automatically
- Persistent

The existing VM is connected to this network.

Further investigation of IP addressing, DHCP, DNS, NAT, and guest connectivity will be performed during the networking stage of the project.

---

## 9. Storage Pool Inspection

I inspected the available libvirt storage pools using:

```bash
virsh -c qemu:///system pool-list --all
```

### Result

```text
Name        State    Autostart
---------------------------------
boot        active   yes
default     active   yes
linux-lab   active   yes
```

All three storage pools were active and configured for autostart.

I then inspected the `linux-lab` pool:

```bash
virsh -c qemu:///system pool-info linux-lab
```

### Result

```text
State:          running
Persistent:     yes
Autostart:      yes
Capacity:       936.79 GiB
Allocation:     48.36 GiB
Available:      888.43 GiB
```

The storage pool has sufficient free capacity for the current homelab and future virtual machines.

---

## 10. Existing Ubuntu Server Installation Media

The Ubuntu Server ISO currently available in the lab was checked using:

```bash
ls -lh ~/linux-lab/vms
```

The following installation image is available:

```text
ubuntu-26.04.1-live-server-amd64.iso
```

Its file size is approximately:

```text
2.8 GiB
```

This ISO can be used if a new Ubuntu Server installation is required later.

---

## 11. VM Reuse and Naming Decision

After inspecting the existing VM, I determined that creating another Linux server VM was unnecessary.

The existing VM already provides:

- 4 virtual CPUs
- 4 GiB RAM
- 50 GiB virtual storage
- qcow2 disk format
- VirtIO networking
- Connection to the active libvirt `default` network
- Persistent libvirt configuration

These resources are sufficient for the Linux server administration project.

### Renaming the Virtual Machine

The existing virtual machine was originally named:

```text
kstan-server
```

To introduce a clearer and more scalable naming convention for the homelab, I renamed it to:

```text
srv-linux01
```

The following command was used:

```bash
sudo virsh -c qemu:///system domrename kstan-server srv-linux01
```

The new name follows this naming convention:

- `srv` = server
- `linux` = Linux platform
- `01` = first Linux server in the lab

The new VM name was verified using:

```bash
virsh -c qemu:///system list --all
```

The virtual machine is now identified as:

```text
srv-linux01
```

### Important Storage Observation

Renaming the virtual machine does not automatically rename its existing virtual disk image.

The VM is now named:

```text
srv-linux01
```

while its qcow2 disk image currently remains:

```text
/var/lib/libvirt/images/kstan-server.qcow2
```

I will leave the disk image unchanged for now to avoid unnecessarily modifying a working storage configuration. Storage naming and organization can be reviewed later as part of the virtualization project.
---

## 12. What I Learned

During this stage I learned how to inspect an existing KVM/libvirt virtual machine before making infrastructure changes.

Commands used included:

```bash
lscpu
virsh list --all
virsh dominfo
virsh domblklist
virsh domiflist
virsh net-list --all
virsh pool-list --all
virsh pool-info
qemu-img info
```

More importantly, I learned that an administrator should inspect existing infrastructure before creating or modifying resources.

The assessment showed how CPU, memory, virtual storage, network interfaces, virtual networks, and storage pools are represented and managed in a KVM/QEMU and libvirt environment.

---

## 13. Current Project Status

**Initial virtualization assessment: Complete**

The next stage will be:

1. Start the Linux server VM
2. Verify that Ubuntu Server boots correctly
3. Identify its IP address
4. Test network connectivity
5. Inspect the guest operating system
6. Configure the server hostname
7. Configure and test SSH
8. Begin Linux server administration exercises

These steps will be documented as they are performed.
