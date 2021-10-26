#!/bin/bash -e

echo 'Install tx-pi X Sever-launcher-start'

# X server/launcher start
cat <<EOF > /etc/systemd/system/launcher.service
[Unit]
Description=Start Launcher

[Service]
ExecStart=/bin/su ftc -c "PYTHONPATH=/opt/ftc startx /opt/ftc/launcher.py"
ExecStop=/usr/bin/killall xinit

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable launcher


# Configure X.Org to use /dev/fb1
cat <<EOF > "/usr/share/X11/xorg.conf.d/99-fbdev.conf"
Section "Device"
    Identifier      "FBDEV"
    Driver          "fbdev"
    Option          "fbdev" "/dev/fb1"
    Option          "SwapbuffersWait" "true"
EndSection
EOF


# Splash screen
# a simple boot splash
wget -N https://github.com/ftCommunity/tx-pi/raw/master/setup/splash.png -O /etc/splash.png
apt-get install -y --no-install-recommends libjpeg-dev
wget -N https://github.com/godspeed1989/fbv/archive/master.zip
unzip -x master.zip
cd fbv-master/
FRAMEBUFFER=/dev/fb1 ./configure
make
make install
cd ..
rm -rf master.zip fbv-master
enable_default_dependencies="yes"
cmd_line=$( cat /boot/cmdline.txt )
# These params are needed to show the splash screen and to omit any text output on the LCD
# Append them to the cmdline.txt without changing other params
for param in "logo.nologo" "vt.global_cursor_default=0" "plymouth.ignore-serial-consoles" "splash" "quiet"
do
    if [[ $cmd_line != *"$param"* ]]; then
        cmd_line="$cmd_line $param"
    fi
done
cat <<EOF > /boot/cmdline.txt
${cmd_line}
EOF
    # create a service to start fbv at startup
    cat <<EOF > /etc/systemd/system/splash.service
[Unit]
DefaultDependencies=${enable_default_dependencies}
After=local-fs.target

[Service]
StandardInput=tty
StandardOutput=tty
Type=oneshot
ExecStart=/bin/sh -c "echo 'q' | fbv -e /etc/splash.png"

[Install]
WantedBy=sysinit.target
EOF

systemctl daemon-reload
systemctl disable getty@tty1
systemctl enable splash


# allow any user to start xs
sed -i 's,^\(allowed_users=\).*,\1'\anybody',' /etc/X11/Xwrapper.config

# install framebuffer copy tool
wget -N https://github.com/ftCommunity/tx-pi/raw/master/setup/fbc.tgz
tar xvfz fbc.tgz
cd fbc
make
cp fbc /usr/bin/
cd ..
rm -rf fbc.tgz fbc

# Hide cursor and disable screensaver
cat <<EOF > /etc/X11/xinit/xserverrc
#!/bin/sh
for f in /dev/input/by-id/*-mouse; do

    ## Check if the glob gets expanded to existing files.
    ## If not, f here will be exactly the pattern above
    ## and the exists test will evaluate to false.
    if [ -e "\$f" ]; then
        CUROPT=
        # run framebuffer copy tool in background
        /usr/bin/fbc &
        sh -c 'sleep 2; unclutter -display :0 -idle 1 -root' &
    else
        CUROPT=-nocursor
    fi

    ## This is all we needed to know, so we can break after the first iteration
    break
done

exec /usr/bin/X -s 0 dpms \$CUROPT -nolisten tcp "\$@"
EOF

# Install vnc server
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

cat <<EOF > /etc/systemd/system/novnc.service
[Unit]
Description=NoVNC service
After=network.target
PartOf=x11vnc.service
Requires=x11vnc.service
[Service]
ExecStart=/bin/su ftc -c "/usr/share/novnc/utils/launch.sh --listen 6080 --vnc localhost:5900"
ExecStop=/bin/su ftc -c "/usr/bin/killall launch.sh"
[Install]
WantedBy=multi-user.target
EOF


systemctl daemon-reload
systemctl enable x11vnc
systemctl enable novnc
