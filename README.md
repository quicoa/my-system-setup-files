# System setup files

This repository contains a set of shell scripts that somewhat automate the
setup of Debian-based operating systems. I use these scripts primarily for
myself to bootstrap, set up, configure and install Debian-based systems, either
from scratch or from an existing ISO.

The scripts are not very flexible, but with some understanding of GNU+Linux they
are fairly easy to tweak. The configuration files located in [config](config)
must be changed before starting any bootstrap, configuring or installing, as
they contain parameters like the definition of the target and where to find the
working directories.

## Execution

Mount the target filesystem and mount-bind runtime directories
([config/mount](config/mount)):

```sh
./mount.sh
```

Debootstrap to the target directory ([config/debootstrap](config/debootstrap)):

```sh
./debootstrap.sh
```

Or clone a filesystem from an existing ISO ([config/clone](config/clone)):

```sh
./clone.sh
```

Start configuring the target system in chroot ([config/setup](config/setup)):

```sh
./chroot.sh setup
```

Re-run APT installer, if, for example, setup has finished but APT packages are
still incomplete (config/apt\*):

```sh
./chroot.sh apt
```

Disable unnecessary systemd services:
```sh
./chroot.sh service
```

Install Grub if installed on physical partition ([config/grub](config/grub)):

```sh
./chroot.sh grub
```

Create a squashfs file from the target filesystem
([config/mksqfs](config/mksqfs)):

```sh
./mksqfs.sh
```

Unmount the target filesystem ([config/mount](config/mount)):
```sh
./unmount.sh
```

