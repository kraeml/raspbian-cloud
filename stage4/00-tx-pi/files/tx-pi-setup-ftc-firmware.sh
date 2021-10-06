#!/bin/bash

# set firmware version
cd /etc
wget -N $GITROOT/etc/fw-ver.txt

# set various udev rules to give ftc user access to
# hardware
cd /etc/udev/rules.d
wget -N $GITROOT/etc/udev/rules.d/40-fischertechnik_interfaces.rules
wget -N $GITROOT/etc/udev/rules.d/40-lego_interfaces.rules
wget -N $GITROOT/etc/udev/rules.d/60-i2c-tools.rules
wget -N $GITROOT/etc/udev/rules.d/99-USBasp.rules

# get /opt/ftc
header "Populating /opt/ftc ..."
cd /opt
rm -rf ftc
svn export $SVNROOT"/opt/ftc"
cd /opt/ftc
# just fetch a copy of ftrobopy to make some programs happy
wget -N https://raw.githubusercontent.com/ftrobopy/ftrobopy/master/ftrobopy.py

# adjust font sizes/styles from qtembedded to x11
STYLE=/opt/ftc/themes/default/style.qss
# remove all "bold"
sed -i 's/^\(\s*font:\)\s*bold/\1/' $STYLE
# and scale some fonts
for i in 24:23 28:24 32:24; do
    from=`echo $i | cut -d':' -f1`
    to=`echo $i | cut -d':' -f2`
    sed -i "s/^\(\s*font:\)\s*${from}px/\1 ${to}px/" $STYLE
done


# install libroboint
header "Installing libroboint"
rm -f /usr/local/lib/libroboint.so*
# install libusb-dev
apt-get install libusb-dev
cd /root
git clone https://gitlab.com/Humpelstilzchen/libroboint.git
cd libroboint
# python3 compatibility 'patch'
sed -i "s/python2/python3/g" ./CMakeLists.txt
cmake .
make
# install
make install
ldconfig
# install python
make python
# udev rules
cp udev/fischertechnik.rules /etc/udev/rules.d/
cd ..
# clean up
rm -rf libroboint


# and ftduino_direct
header "Installing ftduino_direct.py"
cd /root
wget -N https://github.com/PeterDHabermehl/ftduino_direct/raw/master/$FTDDIRECT.tar.gz
tar -xzvf $FTDDIRECT.tar.gz
cd $FTDDIRECT
python3 ./setup.py install
cd ..
rm -f $FTDDIRECT.tar.gz
rm -rf $FTDDIRECT
rm -f /opt/ftc/ftduino_direct.py

# remove useless ftgui
rm -rf /opt/ftc/apps/system/ftgui

# add power tool from touchui
cd /opt/ftc/apps/system
svn export $TSVNBASE"/touchui/apps/system/power"
# Move power button to home screen
sed -i "s/category: System/category: /g" /opt/ftc/apps/system/power/manifest


#
# - Add TX-Pi TS-Cal
#
header "Install TS Cal"
apt-get -y install --no-install-recommends xinput-calibrator
touch /usr/share/X11/xorg.conf.d/99-calibration.conf
chmod og+rw /usr/share/X11/xorg.conf.d/99-calibration.conf

# Remove legacy app
rm -rf /opt/ftc/apps/system/tscal

# Remove any installed TS-Cal
rm -rf /home/ftc/apps/ffe0d8c4-be33-4f62-b25d-2fa7923daaa2

cd /home/ftc/apps
wget "${TXPIAPPS_URL}tscal.zip"
unzip -o tscal.zip -d ffe0d8c4-be33-4f62-b25d-2fa7923daaa2
chown -R ftc:ftc ffe0d8c4-be33-4f62-b25d-2fa7923daaa2
chmod +x ffe0d8c4-be33-4f62-b25d-2fa7923daaa2/tscal.py
rm -f ./tscal.zip


#
# - Add TX-Pi config
#
header "Install TX-Pi config"
# Remove legacy apps and configurations
rm -rf /home/ftc/apps/430d692e-d285-4f05-82fd-a7b3ce9019e5
rm -rf /home/ftc/apps/e7b22a70-7366-4090-b251-5fead780c5a0
rm -f /etc/sudoers.d/sshvnc
# Remove any installed TX-Pi config
rm -rf ${TXPICONFIG_DIR}
mkdir -p "${TXPICONFIG_DIR}"
cd ${TXPICONFIG_DIR}
wget "${TXPIAPPS_URL}config/config.zip"
unzip ./config.zip
chown -R ftc:ftc ${TXPICONFIG_DIR}
chmod +x ${TXPICONFIG_DIR}/config.py
chown root:root ${TXPICONFIG_DIR}/scripts/*
chmod 744 ${TXPICONFIG_DIR}/scripts/*
rm -f ./config.zip

# add robolt support
# robolt udev rules have already been installed from the main repository
header "Install robolt"
cd /root
git clone https://github.com/ftCommunity/python-robolt.git
cd python-robolt
python3 ./setup.py install
cd ..
rm -rf python-robolt

# add wedo support
# wedo udev rules have already been installed from the main repository
header "Install WeDoMore"
cd /root
git clone https://github.com/gbin/WeDoMore.git
cd WeDoMore
python3 ./setup.py install
cd ..
rm -rf WeDoMore

# install the BT Control Set server
header "Install BT Control Set server"
apt-get -y install --no-install-recommends libbluetooth-dev
cd /root
git clone https://github.com/ftCommunity/ft_bt_remote_server.git
cd ft_bt_remote_server
make
make install
cd ..
rm -rf ft_bt_remote_server

if [ "$ENABLE_NETREQ" = true ]; then
    # install netreq
    apt-get -y install --no-install-recommends libnetfilter-queue-dev
    cd /root
    svn export $SVNBASE"/package/netreq"
    cd netreq
    make
    make install
    cd ..
    rm -rf netreq

    cat <<EOF > /etc/netreq_permissions
# netreq permissions
EOF
    chmod og+rw /etc/netreq_permissions

    cat <<EOF > /etc/systemd/system/netreq.service
[Unit]
Description=Network requester
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/netreq

[Install]
WantedBy=multi-user.target
EOF

    systemctl daemon-reload
    systemctl enable netreq
fi


lighttpd_mime_types="/usr/share/lighttpd/create-mime.conf.pl"
lighttpd_config="include \"/etc/lighttpd/conf-enabled/*.conf\""

if [ "$IS_STRETCH" = true ]; then
    lighttpd_mime_types="/usr/share/lighttpd/create-mime.assign.pl"
    lighttpd_config="include_shell \"/usr/share/lighttpd/include-conf-enabled.pl\""
fi

# adjust lighttpd config
cat <<EOF > /etc/lighttpd/lighttpd.conf
server.modules = (
        "mod_access",
        "mod_alias",
        "mod_redirect"
)

server.document-root        = "/var/www"
server.upload-dirs          = ( "/var/cache/lighttpd/uploads" )
server.errorlog             = "/var/log/lighttpd/error.log"
server.pid-file             = "/var/run/lighttpd.pid"
server.username             = "ftc"
server.groupname            = "ftc"
server.port                 = 80


index-file.names            = ( "index.php", "index.html", "index.lighttpd.html" )
url.access-deny             = ( "~", ".inc" )
static-file.exclude-extensions = ( ".php", ".pl", ".fcgi" )

# default listening port for IPv6 falls back to the IPv4 port

include_shell "/usr/share/lighttpd/use-ipv6.pl " + server.port
include_shell "${lighttpd_mime_types}"
${lighttpd_config}

server.modules += ( "mod_ssi" )
ssi.extension = ( ".html" )

server.modules += ( "mod_cgi" )

\$HTTP["url"] =~ "^/cgi-bin/" {
       cgi.assign = ( "" => "" )
}

cgi.assign      = (
       ".py"  => "/usr/bin/python3"
)
EOF

# fetch www pages
header "Populating /var/www ..."
cd /var
rm -rf www
svn export $SVNROOT"/var/www"
touch /var/www/tx-pi

# convert most "fischertechnik TXT" texts to "ftcommunity TX-Pi"
cd /var/www
for i in /var/www/*.html /var/www/*.py; do
    sed -i 's.<div class="outline"><font color="red">fischer</font><font color="#046ab4">technik</font>\&nbsp;<font color="#fcce04">TXT</font></div>.<div class="outline"><font color="red">ft</font><font color="#046ab4">community</font>\&nbsp;<font color="#fcce04">TX-Pi</font></div>.' $i
    sed -i 's.<title>fischertechnik TXT community firmware</title>.<title>ftcommunity TX-Pi</title>.' $i
done

# add VNC and TX-Pi homepage link to index page
sed -i 's#<center><a href="https://github.com/ftCommunity/ftcommunity-TXT" target="ft-community">community edition</a></center>#<center><a href="https://github.com/ftCommunity/ftcommunity-TXT" target="ft-community">ftcommunity</a> - <a href="https://www.tx-pi.de/" target="tx-pi">TX-Pi</a> - <a href="/remote">VNC</a></center>#' /var/www/index.html

# Fav icon
wget -N $LOCALGIT/favicon.ico

# Install novnc ...
cd /var/www
wget -N $LOCALGIT/novnc.tgz
tar xvfz novnc.tgz
rm novnc.tgz


# ... and websockify for novnc
cd /opt/ftc
wget -N $LOCALGIT/websockify.tgz
tar xvfz websockify.tgz
rm websockify.tgz

# make sure fbgrab is there to take screenshots
chown -R ftc:ftc /var/www

# fbgrab needs netpbm to generate png files
apt-get -y install netpbm

apt-get -y install --no-install-recommends fbcat
sed -i 's.fbgrab.fbgrab -d /dev/fb1.' /var/www/screenshot.py

# adjust file ownership for changed www user name
chown -R ftc:ftc /var/www
chown -R ftc:ftc /var/log/lighttpd
chown -R ftc:ftc /var/run/lighttpd
chown -R ftc:ftc /var/cache/lighttpd

# In Buster, systemd (tmpfiles.d) resets the permissions to www-data if the
# system reboots. This ensures that the permissions are kept alive.
if [ "$IS_STRETCH" = false ]; then
    sed -i "s/www-data/ftc/g" /usr/lib/tmpfiles.d/lighttpd.tmpfile.conf
fi



# disable the TXTs default touchscreen timeout as the waveshare isn't half
# as bad as the TXTs one
cat <<EOF > /home/ftc/.launcher.config
[view]
min_click_time = 0
EOF
chown ftc:ftc /home/ftc/.launcher.config

# remove cfw display configuration app since it does not work here...
rm -fr /opt/ftc/apps/system/display/


#-- Add useful TX-Pi stores
shop_repositories="/home/ftc/.repositories.xml"
if [ ! -f "$shop_repositories" ]; then
  cat <<EOF > $shop_repositories
<repositories>
  <repository name="TX-Pi Apps" repo="tx-pi-apps" user="ftCommunity"/>
  <repository name="Till&apos;s Apps" repo="cfw-apps" user="harbaum"/>
</repositories>
EOF
fi

# Clean up if necessary
apt -y autoremove

msg "rebooting ..."

sync
sleep 30
shutdown -r now
