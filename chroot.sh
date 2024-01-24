#!/bin/bash

set -e

this=`dirname $0`
script="$1"

# Read configuration
file=${this}/config/chroot
config=`cat "${file}"`

# Read config parameters
target=`echo "${config}" | grep --ignore-case 'target' | awk '{print $2}'`

# Do not continue if target script is not provided
test "${script}" || sh -c 'echo "Please provide a script name to run" && false'

# Copy scripts and configuration to target filesystem
sudo mkdir --parents "${target}/scripts"
sudo cp --preserve=mode --recursive ${this}/* "${target}/scripts/"

# Store the used Git reference of this repository on the target filesystem
git status && \
	git rev-parse HEAD | sudo tee "${target}/scripts/ref" &> /dev/null || true

# Make sure system runtime directories exist
sudo mkdir --parents ${target}/{dev,proc,run,sys,tmp}

# Bind-mount system runtime directories
for i in dev dev/pts dev/shm proc run sys tmp; do
	directory="${target}/$i"

	mount | grep "${directory}" &> /dev/null || \
		sudo mount --bind /$i --target "${directory}"
done

# Copy resolv.conf to the new filesystem
sudo cp --force /etc/resolv.conf "${target}/etc/resolv.conf"

# Change system root and execute the setup
sudo chroot "${target}" "/scripts/${script}.sh" $@
