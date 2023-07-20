#!/bin/bash

set -e

this=`dirname $0`

# Read configuration
file=${this}/config/grub
config=`cat "${file}"`

# Read config parameters
target=`echo "${config}" | grep --ignore-case 'target' | awk '{print $2}'`

# Install Grub to target
sudo grub-install "${target}"

# Update Grub configuration
sudo update-grub
