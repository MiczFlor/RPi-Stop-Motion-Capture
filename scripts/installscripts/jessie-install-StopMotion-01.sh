#!/bin/bash
#
# see https://github.com/MiczFlor/RPi-Stop-Motion-Capture for details
#
# this script installs my personal settings on a fresh RPi install
# before running the script, the RPi needs to be set up, see INSTALL.md on github
# download the install script only to home dir and run
# Don't run as sudo. Simply type ./jessie-install-StopMotion-01.sh

# If you want to make this work with your wifi network, change the following files before you run this script:
# dhcpcd.conf.jessie-default.sample

# Install packages
sudo apt-get update
sudo apt-get install fswebcam libav-tools samba samba-common-bin lighttpd php5-common php5-cgi php5 git

# Get github code
cd /home/pi/
git clone https://github.com/MiczFlor/RPi-Stop-Motion-Capture.git

#####################################
# COPY CONFIG PRESETS TO LIVE FOLDERS
#####################################

# DHCP configuration settings
# -rw-rw-r-- 1 root netdev 1371 Nov 17 21:02 /etc/dhcpcd.conf
sudo cp /home/pi/RPi-Jukebox-RFID/misc/sampleconfigs/dhcpcd.conf.jessie-default.sample /etc/dhcpcd.conf
sudo chown root:netdev /etc/dhcpcd.conf
sudo chmod 664 /etc/dhcpcd.conf

# Samba configuration settings
# -rw-r--r-- 1 root root 9416 Nov 17 21:04 /etc/samba/smb.conf
sudo cp /home/pi/RPi-Jukebox-RFID/misc/sampleconfigs/smb.conf.jessie-default.sample /etc/samba/smb.conf
sudo chown root:root /etc/samba/smb.conf
sudo chmod 644 /etc/samba/smb.conf

# Web server configuration settings
# -rw-r--r-- 1 root root 1063 Nov 17 21:07 /etc/lighttpd/lighttpd.conf
sudo cp /home/pi/RPi-Jukebox-RFID/misc/sampleconfigs/lighttpd.conf.jessie-default.sample /etc/lighttpd/lighttpd.conf
sudo chown root:root /etc/lighttpd/lighttpd.conf
sudo chmod 644 /etc/lighttpd/lighttpd.conf

# SUDO users (adding web server here)
# -r--r----- 1 root root 703 Nov 17 21:08 /etc/sudoers
sudo cp /home/pi/RPi-Jukebox-RFID/misc/sampleconfigs/sudoers.jessie-default.sample /etc/sudoers
sudo chown root:root /etc/sudoers
sudo chmod 440 /etc/sudoers

# Starting web server
sudo lighty-enable-mod fastcgi-php
sudo service lighttpd force-reload

# start DHCP
sudo service dhcpcd start
sudo systemctl enable dhcpcd

############################
# Manual intervention needed
############################

# samba user
# you must use password 'raspberry' because this is 
# expected in the smb.conf file
sudo smbpasswd -a pi

