#!/bin/bash

set -e

this=`dirname $0`

# Read configuration
file=${this}/config/mksqfs
config=`cat "${file}"`

# Read config parameters
directory=`echo "${config}" | grep --ignore-case 'directory' | awk '{print $2}'`
target=`echo "${config}" | grep --ignore-case 'target' | awk '{print $2}'`

# Make sure target filesystem is mounted
${this}/mount.sh

# Now compress everything into a squashfs file
sudo mksquashfs ${directory} ${target}
