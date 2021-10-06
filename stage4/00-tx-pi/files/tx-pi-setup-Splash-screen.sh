#!/bin/bash

# Splash screen
if [ "$ENABLE_SPLASH" = true ]; then
    # a simple boot splash
    wget -N $LOCALGIT/splash.png -O /etc/splash.png
    apt-get install -y --no-install-recommends libjpeg-dev
    cd /root
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
fi  # End ENABLE_SPLASH

# allow any user to start xs
sed -i 's,^\(allowed_users=\).*,\1'\anybody',' /etc/X11/Xwrapper.config
