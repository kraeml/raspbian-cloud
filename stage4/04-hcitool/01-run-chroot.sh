#!/bin/bash -e

echo 'Install tx-pi hcitool'

LOCALGIT="https://github.com/ftCommunity/tx-pi/raw/master/setup"

# fetch bluez hcitool with extended lescan patch
echo "wget -N ${LOCALGIT}/hcitool-xlescan.tgz"
wget -N ${LOCALGIT}/hcitool-xlescan.tgz
tar xvfz hcitool-xlescan.tgz -C /usr/bin
rm -f hcitool-xlescan.tgz
