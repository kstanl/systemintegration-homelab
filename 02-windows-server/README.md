# Windows Server and Active Directory Lab

This section documents the Windows infrastructure in my System Integration Homelab.

## Environment

The lab contains:

- `DC01` - Windows Server 2022 domain controller
- `CLIENT01` - Windows 11 Pro domain client
- Active Directory Domain Services
- DNS
- Active Directory users and security groups
- NTFS and SMB file sharing
- AGDLP-based permission management

Domain:

`ad.kstanlab.test`

## Documentation

### 1. Windows Server Installation

[Windows Server 2022 Installation](installation.md)

Covers:

- KVM/QEMU virtual machine deployment
- VirtIO storage and network drivers
- Windows Server installation
- network configuration
- Windows Update
- baseline verification

### 2. Active Directory

[Active Directory Domain Services](active-directory.md)

Covers:

- AD DS installation
- forest and domain creation
- DNS
- Organizational Units
- domain users
- security groups
- AGDLP group nesting
- Windows 11 domain join
- domain authentication

### 3. File Sharing

[SMB File Sharing and Permissions](file-sharing.md)

Covers:

- NTFS permissions
- SMB share permissions
- Active Directory group-based authorization
- client access testing
- create, write, and delete verification

## Current Architecture

```text
                     ad.kstanlab.test

                           DC01
                    192.168.122.20
                  AD DS / DNS / SMB
                         │
             ┌───────────┴───────────┐
             │                       │
       Active Directory          \\DC01\IT
             │                       │
             └───────────┬───────────┘
                         │
                      CLIENT01
                    Windows 11 Pro
                         │
                KSTANLAB\anna.zollinger
