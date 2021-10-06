#!/bin/bash

# ToDo Not needed anymore? Will change.

## Update Debian sources
#if [ "$IS_BUSTER" = true ]; then
#    cat <<EOF > /etc/apt/sources.list.d/tx-pi.list
## TX-Pi sources used to solve issues with newer packages provided by Buster
#deb http://raspbian.raspberrypi.org/raspbian/ jessie main contrib non-free rpi
#EOF

#    cat <<EOF > /etc/apt/preferences.d/tx-pi
## Added due to issues with the X11 VNC server
#Package: x11vnc x11vnc-data
#Pin: release n=jessie
#Pin-Priority: 1000

## Added due to issues with the Raspberry Pi OS kernel and the touch displays
#Package: raspberrypi-kernel
#Pin: version 1.20200512-2
#Pin-Priority: 1000
#
#EOF
#fi
