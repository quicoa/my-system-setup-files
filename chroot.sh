#!/bin/bash

set -e

this=`dirname $0`

# Read configuration
file=${this}/config/chroot
config=`cat "${file}"`

# Read config parameters
target=`echo "${config}" | grep --ignore-case 'target' | awk '{print $2}'`

# Copy scripts and configuration to target filesystem
sudo mkdir --parents "${target}/scripts"
sudo cp --preserve=mode --recursive ${this}/* "${target}/scripts/"

# Make sure system runtime directories exist
sudo mkdir --parents ${target}/{dev,proc,run,sys,tmp}

# Bind-mount system runtime directories
for i in dev dev/pts dev/shm proc run sys tmp; do
	directory="${target}/$i"

	mount | grep "${directory}" &> /dev/null || \
		sudo mount --bind /$i --target "${directory}"
done

# Change system root and execute the setup
sudo chroot "${target}" "/scripts/setup.sh" $@
