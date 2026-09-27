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
- Group Policy
- Windows Server DHCP
- Forward and reverse DNS
- Windows Server storage management
- Windows Server Backup and Restore
- Windows Server monitoring and Event Viewer
- Windows Server remote administration with PowerShell Remoting


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


### 4. Group Policy

[Group Policy](group-policy.md)

Covers:

- workstation security policy
- Windows Defender Firewall policy
- user restrictions
- OU-based GPO linking
- client-side policy verification

### 5. DHCP

[Windows Server DHCP](dhcp.md)

Covers:

- static IPv4 configuration for DC01
- DHCP Server installation and AD authorization
- IPv4 scope configuration
- DHCP options for gateway and DNS
- Windows 11 client lease testing
- APIPA and DHCP troubleshooting
- libvirt bridge troubleshooting

### 6. Storage

[Windows Server Storage](storage.md)

Covers:

- QCOW2 virtual data disk
- VirtIO disk attachment
- GPT partitioning
- NTFS volume configuration
- PowerShell storage verification
- basic storage troubleshooting

### 7. Backup and Restore

[Windows Server Backup and Restore](backup-and-restore.md)

Covers:

- Windows Server Backup installation
- dedicated backup volume
- file-level backup with `wbadmin`
- simulated file deletion
- GUI-based file recovery
- PowerShell recovery verification

### 8. Monitoring and Event Viewer

[Windows Server Monitoring and Event Viewer](monitoring-and-event-viewer.md)

Covers:

- Windows service monitoring
- Event Viewer System logs
- event filtering and Event IDs
- PowerShell event queries
- controlled service stop and recovery


### 9. Remote Administration

[Windows Server Remote Administration](remote-administration.md)

Covers:

- Windows Remote Management (WinRM)
- TCP port 5985 connectivity testing
- PowerShell Remoting
- remote service monitoring
- authentication and authorization troubleshooting

## Current Architecture

```text
                     ad.kstanlab.test

                           DC01
                    192.168.122.20
                  AD DS / DNS / DHCP / SMB
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
