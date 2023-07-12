#!/bin/bash

set -e

this=`dirname $0`

# Read configuration
file=${this}/config/clone
config=`cat "${file}"`

# Read config parameters
from=`echo "${config}" | grep --ignore-case 'source' | awk '{print $2}'`
to=`echo "${config}" | grep --ignore-case 'directory' | awk '{print $2}'`

# Make sure target filesystem is mounted
${this}/mount.sh

# Copy everything from source to target
sudo rsync --archive --no-D --acls --hard-links --xattrs ${from}/* ${to} \
	--exclude home --exclude dev --exclude proc --exclude sys --exclude tmp \
	--exclude run --exclude mnt --exclude media $@

# Now make changes to the system in chroot
${this}/chroot.sh
