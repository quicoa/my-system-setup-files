#!/bin/bash

set -e

this=`dirname $0`

# Read configuration
file=${this}/config/setup
config=`cat "${file}"`

# Read config parameters
user=`echo "${config}" | grep --ignore-case 'user' | awk '{print $2}'`
passwd=`echo "${config}" | grep --ignore-case 'password' | awk '{print $2}'`

# Install packages
${this}/apt.sh

# Clean apt packages
sudo apt clean

# Generate locales
sudo sed -i -E 's/^# (en_US.UTF-8 UTF-8)$/\1/g' /etc/locale.gen
sudo locale-gen

# Add new user
cat /etc/passwd | grep "^${user}:" &> /dev/null || \
	sudo adduser --disabled-password ${user}

# Set passwords
echo -e "root:${passwd}\n" | sudo chpasswd
echo -e "${user}:${passwd}\n" | sudo chpasswd

# Add user to some user groups
for i in adm audio bluetooth cdrom dialout dip fax floppy fuse lpadmin netdev \
         plugdev powerdev sambashare scanner sudo tape users vboxusers video; do
	sudo usermod --append "${user}" --groups "$i" || true
done

# Setup systemd-tmpfiles
dir="/etc/tmpfiles.d"
file="${dir}/user-cache.conf"
sudo mkdir --parents "${dir}"
test -f "${file}" && \
	cat "${file}" | grep "${user}" &> /dev/null || \
		sudo sh -c "echo -c 'd /tmp/${user}-cache 0755 ${user} ${user} - -' >> '${file}'"
