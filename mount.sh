#!/bin/bash

set -e

this=`dirname $0`

# Read configuration
file=${this}/config/mount
config=`cat "${file}"`

# Read config parameters
device=`echo "${config}" | grep --ignore-case 'device' | awk '{print $2}'`
directory=`echo "${config}" | grep --ignore-case 'directory' | awk '{print $2}'`

# Mount target filesystem
mount | grep "${directory}" &> /dev/null || \
	sudo mount --rw --options defaults,noatime \
		--source ${device} --target ${directory} $@
