# Linux Storage and Filesystems

## Objective

Add a second virtual disk to `srv-linux01` and configure persistent storage.

## Implementation

A 10 GB QCOW2 virtual disk was attached to the VM as `/dev/vdb`.

The disk was partitioned with GPT:

```text
/dev/vdb
└── /dev/vdb1
```

An ext4 filesystem was created:

```bash
sudo mkfs.ext4 -L data /dev/vdb1
```

The filesystem was mounted at:

```text
/srv/data
```

## Persistent Mount

The filesystem UUID was added to `/etc/fstab`:

```text
UUID=ebc4c555-3eab-44d0-b7e3-48a6a94accc8 /srv/data ext4 defaults 0 2
```

The configuration was tested with:

```bash
sudo umount /srv/data
sudo mount -a
```

After rebooting the server, the persistent mount was verified:

```bash
findmnt /srv/data
```

Result:

```text
TARGET    SOURCE    FSTYPE OPTIONS
/srv/data /dev/vdb1 ext4   rw,relatime
```

## Key Skills

- Virtual disk administration
- GPT partitioning
- ext4 filesystem creation
- Linux mount points
- Persistent mounts with `/etc/fstab`
- Storage verification
