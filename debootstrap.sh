#!/bin/bash

set -e

this=`dirname $0`

# Read configuration
file=${this}/config/debootstrap
config=`cat "${file}"`

# Read config parameters
suite=`echo "${config}" | grep --ignore-case 'suite' | awk '{print $2}'`
target=`echo "${config}" | grep --ignore-case 'target' | awk '{print $2}'`
mirror=`echo "${config}" | grep --ignore-case 'mirror' | awk '{print $2}'`

# Make sure target filesystem is mounted
${this}/mount.sh

# Start bootstrapping
sudo debootstrap --merged-usr --keep-debootstrap-dir $@ \
	"${suite}" "${target}" "${mirror}"

# Create /var/tmp which is sometimes missing
sudo mkdir --parents ${target}/var/tmp

# Now make changes to the system in chroot
${this}/chroot.sh setup
