#!/bin/bash

# Install vnc server
if [ "$IS_BUSTER" = true ]; then
    # VNC support in Buster is broken / may deliver distorted output
    # Remove libvncserver1 if any
    apt-get -y remove libvncserver1 x11vnc-data libvncclient1
fi
apt-get -y install x11vnc
cat <<EOF > /etc/systemd/system/x11vnc.service
[Unit]
Description=X11 VNC service
After=network.target

[Service]
ExecStart=/bin/su ftc -c "/usr/bin/x11vnc -forever"
ExecStop=/bin/su ftc -c "/usr/bin/killall x11vnc"

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable x11vnc
