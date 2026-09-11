# Ubuntu Server Installation

## Objective

Install an Ubuntu Server virtual machine using KVM/QEMU and libvirt.

## Environment

- Host OS: Ubuntu Linux
- Hypervisor: KVM/QEMU
- Virtualization management: libvirt
- Guest OS: Ubuntu Server
- Planned hostname: srv-linux01

## Pre-Installation Checks

Before creating the virtual machine, I will verify that virtualization and libvirt are working correctly.

### Check CPU virtualization support

```bash
lscpu | grep Virtualization
