#!/bin/bash -e

echo 'Install tx-pi dhcp'
echo Set hostname to tx-pi will done with cloud-init

# Remove dhcpcd because it fails to start (isc-dhcp-client is available)
# ToDo
# apt-get -y purge dhcpcd5

# ToDo /etc/dhcp/dhclient.conf does not exist.
# Do not try too long to reach the DHCPD server (blocks booting)
#sed -i "s/#timeout 60;/timeout 10;/g" /etc/dhcp/dhclient.conf
# By default, the client retries to contact the DHCP server after five min.
# Reduce this time to 20 sec.
#sed -i "s/#retry 60;/retry 20;/g" /etc/dhcp/dhclient.conf
echo "Disable wait for network"
raspi-config nonint do_boot_wait 1
