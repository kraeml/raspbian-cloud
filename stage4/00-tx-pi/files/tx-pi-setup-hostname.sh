#!/bin/bash

## Not working in pi-gen
#if [ "$HOSTNAME" == "raspberrypi" ]; then
#    msg "Found default hostname, change it to 'tx-pi'"
#    raspi-config nonint do_hostname tx-pi
#    rm -f /etc/ssh/ssh_host_*
#    ssh-keygen -A
#fi
