#!/bin/bash -e

echo 'Install tx-pi usbmount and TX-PI version'
# Schema: YY.<release-number-within-the-year>.minor(.dev)?
# See <https://calver.org/> for details
#Could not set in chroot
TX_PI_VERSION='21.1.1'

# usbmount config
sed -i -E 's;(FS_MOUNTOPTIONS=");\1-fstype=vfat,uid=1001,gid=1001;g' /etc/usbmount/usbmount.conf

# create file indicating that this is a tx-pi setup
touch /etc/tx-pi

echo TX-Pi version information
echo Version: ${TX_PI_VERSION}
echo "${TX_PI_VERSION}" | tee /etc/tx-pi-ver.txt
