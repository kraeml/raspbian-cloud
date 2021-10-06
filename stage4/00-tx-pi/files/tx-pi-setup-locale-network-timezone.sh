#!/bin/bash

# allow user to modify locale and network settings
touch /etc/locale
chmod 666 /etc/locale


cat <<EOF > /etc/network/interfaces
# /etc/network/interfaces

auto lo
auto wlan0
auto eth0

iface eth0 inet dhcp
iface wlan0 inet dhcp
        wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
iface lo inet loopback
EOF
chmod 666 /etc/network/interfaces

# set timezone to Germany
ln -fs /usr/share/zoneinfo/Europe/Berlin /etc/localtime
dpkg-reconfigure -f noninteractive tzdata
