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
		--source ${device} --target ${directory}

sudo mkdir --parents ${directory}/{dev,proc,run,sys,tmp}

# Bind-mount system runtime directories
for i in dev dev/pts dev/shm proc run sys tmp; do
	target="${directory}/$i"

	mount | grep "${target}" &> /dev/null || \
		sudo mount --bind /$i --target "${target}"
done
