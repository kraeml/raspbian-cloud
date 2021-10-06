#!/bin/bash

# ----------------------- package installation ---------------------

header "Update Debian"
apt-get update
apt --fix-broken -y install
apt-get -y --allow-downgrades upgrade


# X11
apt-get -y install --no-install-recommends xserver-xorg xinit xserver-xorg-video-fbdev xserver-xorg-legacy unclutter
# python and pyqt
apt-get -y install --no-install-recommends python3 python3-pyqt4 python3-pip python3-numpy python3-dev cmake python3-pexpect
# python RPi GPIO access
apt-get -y install -y python3-rpi.gpio
# misc tools
apt-get -y install i2c-tools python3-smbus lighttpd git subversion ntpdate usbmount
# avrdude
apt-get -y install avrdude
# Install Beautiful Soup 4.x
apt-get install -y python3-bs4

# some additional python stuff
header "Install Python libs"
if [ "$IS_STRETCH" = true ]; then
    pip3 install -U semantic_version websockets setuptools \
        wheel  # Needed for zbar
else
    apt-get -y install --no-install-recommends python3-semantic-version \
        python3-websockets python3-setuptools python3-wheel
fi


# DHCP client
header "Setup DHCP client"
# Remove dhcpcd because it fails to start (isc-dhcp-client is available)
apt-get -y purge dhcpcd5
# Do not try too long to reach the DHCPD server (blocks booting)
sed -i "s/#timeout 60;/timeout 10;/g" /etc/dhcp/dhclient.conf
# By default, the client retries to contact the DHCP server after five min.
# Reduce this time to 20 sec.
sed -i "s/#retry 60;/retry 20;/g" /etc/dhcp/dhclient.conf


header "Disable wait for network"
raspi-config nonint do_boot_wait 1
