#!/bin/bash

set -e

this=`dirname $0`

# Read configuration
file=${this}/config/genisoimage
config=`cat "${file}"`

# Read config parameters
directory=`echo "${config}" | grep --ignore-case 'directory' | awk '{print $2}'`

echo -e "Make sure the 'live-boot' APT package is installed on the target " \
        "filesystem, otherwise the Linux Kernel does not mount the squashfs.\n"

# Create temporary directories
mkdir --parents /tmp/livecd/{isolinux,live}

# Compress the target filesystem into a squashfs
fs=/tmp/livecd/live/filesystem.squashfs
test -f ${fs} && echo -e "${fs} already exists, not recreating\n" ||
	sudo mksquashfs ${directory} ${fs} -noappend

# Prepare ISO files
cp ${directory}/boot/vmlinuz-* /tmp/livecd/live/vmlinuz
cp ${directory}/boot/initrd.img-* /tmp/livecd/live/initrd.img
cp ${directory}/usr/lib/ISOLINUX/isolinux.bin /tmp/livecd/isolinux
cp ${directory}/usr/lib/syslinux/modules/bios/*.c32 /tmp/livecd/isolinux

# Create a basic boot menu configuration
echo "\
UI menu.c32
PROMPT 0
TIMEOUT 100
DEFAULT linux

LABEL linux
	LINUX /live/vmlinuz
	APPEND boot=live config live-media-path=/live --
	INITRD /live/initrd.img
" > /tmp/livecd/isolinux/isolinux.cfg

# Create the ISO file
genisoimage -r -input-charset iso8859-1 -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -o linux.iso /tmp/livecd
