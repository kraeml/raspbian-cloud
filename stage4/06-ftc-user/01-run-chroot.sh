#!/bin/bash -eu

echo 'Install tx-pi ftc user'

# ----------------------- user setup ---------------------
# create ftc user
groupadd -f ftc
# groupadd -f gpio
useradd -g ftc -m ftc || true
usermod -a -G video,audio,tty,dialout,input,gpio,i2c,ftc ftc
echo "ftc:ftc" | chpasswd
mkdir -p /home/ftc/apps
chown -R ftc:ftc /home/ftc/apps

# special ftc permissions
cd /etc/sudoers.d
wget -N https://raw.githubusercontent.com/ftCommunity/ftcommunity-TXT/master/board/fischertechnik/TXT/rootfs/etc/sudoers.d/shutdown
chmod 0440 /etc/sudoers.d/shutdown
cat <<EOF > /etc/sudoers.d/bluetooth
## Permissions for ftc access to programs required
## for bluetooth setup

ftc     ALL = NOPASSWD: /usr/bin/hcitool, /etc/init.d/bluetooth, /usr/bin/pkill -SIGINT hcitool
EOF
chmod 0440 /etc/sudoers.d/bluetooth
cat <<EOF > /etc/sudoers.d/wifi
## Permissions for ftc access to programs required
## for wifi setup
ftc     ALL = NOPASSWD: /sbin/wpa_cli
EOF
chmod 0440 /etc/sudoers.d/wifi

cat <<EOF > /etc/sudoers.d/network
## Permissions for ftc access to programs required
## for network setup
ftc     ALL = NOPASSWD: /usr/bin/netreq, /etc/init.d/networking, /sbin/ifup, /sbin/ifdown
EOF
chmod 0440 /etc/sudoers.d/network

cat <<EOF > /etc/sudoers.d/ft_bt_remote_server
## Permissions for ftc access to programs required
## for BT Control Set server setup
ftc     ALL = NOPASSWD: /usr/bin/ft_bt_remote_start.sh, /usr/bin/ft_bt_remote_server, /usr/bin/pkill -SIGINT ft_bt_remote_server
EOF
chmod 0440 /etc/sudoers.d/ft_bt_remote_server

cat <<EOF > /etc/sudoers.d/txpiconfig
## Permissions for ftc access to programs required
## for the TX-Pi config app and the app store (install dependencies via apt-get)
ftc     ALL = NOPASSWD: /opt/ftc/apps/system/txpiconfig/scripts/hostname, /opt/ftc/apps/system/txpiconfig/scripts/camera, /opt/ftc/apps/system/txpiconfig/scripts/ssh, /opt/ftc/apps/system/txpiconfig/scripts/x11vnc, /opt/ftc/apps/system/txpiconfig/scripts/display, /opt/ftc/apps/system/txpiconfig/scripts/i2cbus, /usr/bin/apt-get
EOF
chmod 0440 /etc/sudoers.d/txpiconfig
