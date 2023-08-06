#!/bin/bash

set -e

this=`dirname $0`

# Read configuration
file=${this}/config/setup
config=`cat "${file}"`

# Read config parameters
user=`echo "${config}" | grep --ignore-case 'user' | awk '{print $2}'`
passwd=`echo "${config}" | grep --ignore-case 'password' | awk '{print $2}'`

# Enable other package sources
sed -i -E 's/^deb ([a-z\:\.\/]+) (\w+) .*$/deb \1 \2 main contrib non-free non-free-firmware/g' \
	/etc/apt/sources.list

# Install sudo
apt install sudo

# Install packages
${this}/apt.sh

# Generate locales
sudo sed -i -E 's/^# (en_US.UTF-8 UTF-8)$/\1/g' /etc/locale.gen
sudo locale-gen

# Add new user
cat /etc/passwd | grep "^${user}:" &> /dev/null || \
	sudo adduser --disabled-password --gecos "" ${user}

# Set passwords
echo "root:${passwd}" | sudo chpasswd
echo "${user}:${passwd}" | sudo chpasswd

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
		sudo sh -c "echo 'd /tmp/${user}-cache 0755 ${user} ${user} - -' >> '${file}'"

# Update alternatives interactively to further customize the system
sudo update-alternatives --all

# Remove symbolic links to old kernels
sudo rm /initrd.img.old /vmlinuz.old || true

# Remove any existing initial ramdisks and create a fresh one
sudo update-initramfs -d -k all
sudo update-initramfs -c -k all

# Remove temporary files
sudo rm -rf /tmp/* /var/tmp/*
