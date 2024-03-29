#!/bin/bash

set -e

this=`dirname $0`

# Read package list
file=${this}/config/apt-install
packages=`tr '\n' ' ' < "${file}"`

# Add support for 32-bit packages
sudo dpkg --add-architecture i386

# Read packages to be removed
file=${this}/config/apt-remove
packages=`tr '\n' ' ' < "${file}"`

test "${packages}" != "" && sudo apt remove --yes ${packages} || true

# Upgrade all packages
sudo apt update
sudo apt upgrade --yes

# Install packages
sudo apt install --install-recommends --yes ${packages} $@

# Perform an autoremove
sudo apt autoremove --yes

# Clean apt packages
sudo apt clean
