#!/bin/bash

set +e

this=`dirname $0`

sudo systemctl enable ssh.service

# Enable firewall
sudo systemctl enable ufw.service
sudo ufw enable

# Disable 'tuned' service as something in the service causes aggressive harddisk
# spindown which may wear down the disk faster.
sudo systemctl disable tuned.service

# Disable and mask Ubuntu system adjustments as these mess with grub.cfg and
# thus makes it hard to made your own Grub modifications.
sudo systemctl disale ubuntu-system-adjustments.service
sudo systemctl mask ubuntu-system-adjustments.service

# Disable Ubuntu Advantage (or Ubuntu Pro) crap as it has no added value to our
# system (disabling may fail on pure Debian systems, but that's okay).
sudo systemctl disable apt-news.service
sudo systemctl mask apt-news.service
sudo systemctl disable ua-reboot-cmds.service
sudo systemctl mask ua-reboot-cmds.service
sudo systemctl disable ua-timer.timer
sudo systemctl mask ua-timer.timer
sudo systemctl disable ubuntu-advantage.service
sudo systemctl mask ubuntu-advantage.service
sudo systemctl disable ubuntu-fan.service
sudo systemctl mask ubuntu-fan.service

# Disable brltty services as it sometimes messes with Arduino devices.
sudo systemctl disable brltty.service
sudo systemctl mask brltty.service
sudo systemctl disable brltty-udev.service
sudo systemctl mask brltty-udev.service
