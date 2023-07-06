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

# Change system root and execute the setup
sudo chroot "${target}" "/scripts/setup.sh"
