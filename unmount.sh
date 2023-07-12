#!/bin/bash

set -e

this=`dirname $0`

# Read configuration
file=${this}/config/mount
config=`cat "${file}"`

# Read config parameters
directory=`echo "${config}" | grep --ignore-case 'directory' | awk '{print $2}'`

# Release system runtime directories
for i in dev/pts dev/shm dev proc run sys tmp; do
	target="${directory}/$i"

	sudo umount "${target}" || true
done

# Unmount filesystem
sudo umount "${directory}"
