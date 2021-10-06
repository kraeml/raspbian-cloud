#!/bin/bash

# install bluetooth tools required for e.g. bnep
apt-get -y install --no-install-recommends bluez-tools

# fetch bluez hcitool with extended lescan patch
cd /root
wget -N $LOCALGIT/hcitool-xlescan.tgz
tar xvfz hcitool-xlescan.tgz -C /usr/bin
rm -f hcitool-xlescan.tgz
