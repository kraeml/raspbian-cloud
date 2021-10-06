#!/bin/bash
#===============================================================================
# TX-Pi setup script.
#
# See <https://www.tx-pi.de/en/installation/> or
# <https://www.tx-pi.de/de/installation/> (German) for detailed installation
# instructions.
#
# In short:
# * Copy a supported Raspbian lite version onto SD card
# * Either plug-in your display and a keyboard or enable SSH via /boot/ssh.
#   Don't forget to change your password!
#   Optionally, add your WLAN configuration via /boot/wpa_supplicant.conf, see
#   <https://www.raspberrypi.org/documentation/configuration/wireless/headless.md>
#   for details
# * Insert the SD card into your Pi and boot it
# * Log into your Pi and download the script via
#   wget https://tx-pi.de/tx-pi-setup.sh
# * Run the script
#   sudo bash ./tx-pi-setup.sh
#   You can also specify your touch screen device, i.e.
#   sudo bash ./tx-pi-setup.sh LCD35
#   to support the popular Waveshare LCD 3.5" type "A" display.
#   See <https://www.tx-pi.de/en/installation/> for details
# * After running the script, the Pi will boot into the fischertechnik community
#   firmware.
#===============================================================================
set -ue
# Schema: YY.<release-number-within-the-year>.minor(.dev)?
# See <https://calver.org/> for details
TX_PI_VERSION='20.1.1'

DEBUG=false
#ToDo not working in pi-gen set to false.
ENABLE_SPLASH=false

ENABLE_NETREQ=false

function msg {
    echo -e "\033[93m$1\033[0m"
}

function header {
    echo -e "\033[0;32m--- $1 ---\033[0m"
}


function error {
    echo -e "\033[0;31m$1\033[0m"
}

#-- Handle Stretch (9.x) vs. Buster (10.x)
DEBIAN_VERSION=$( cat /etc/debian_version )
IS_STRETCH=false
IS_BUSTER=false

if [ "${DEBIAN_VERSION:0:1}" = "9" ]; then
    IS_STRETCH=true
    ENABLE_NETREQ=true
elif [ "${DEBIAN_VERSION:0:2}" = "10" ]; then
    IS_BUSTER=true
elif [ "${DEBIAN_VERSION:0:1}" = "8" ]; then
    error "Debian Jessie is not supported anymore"
    exit 2
else
    error "Unknown Raspbian version: '${DEBIAN_VERSION}'"
    exit 2
fi

if [ "$IS_STRETCH" = true ]; then
    header "Setting up TX-Pi on Stretch lite"
elif [ "$IS_BUSTER" = true ]; then
    header "Setting up TX-Pi on Buster lite"
fi

GITBASE="https://raw.githubusercontent.com/ftCommunity/ftcommunity-TXT/master/"
GITROOT=$GITBASE"board/fischertechnik/TXT/rootfs"
SVNBASE="https://github.com/ftCommunity/ftcommunity-TXT.git/trunk/"
SVNROOT=$SVNBASE"board/fischertechnik/TXT/rootfs"
TSVNBASE="https://github.com/harbaum/TouchUI.git/trunk/"
LOCALGIT="https://github.com/ftCommunity/tx-pi/raw/master/setup"

FTDDIRECT="ftduino_direct-1.0.8"

# TX-Pi app store
TXPIAPPS_URL="https://github.com/ftCommunity/tx-pi-apps/raw/master/packages/"

# TX-Pi config
TXPICONFIG_DIR="/opt/ftc/apps/system/txpiconfig"


# default lcd is 3.2 inch
LCD=LCD32
ORIENTATION=90
# check if user gave a parameter
if [ "$#" -gt 0 ]; then
    # todo: Allow for other types as well
    LCD=$1
    if [ "$1" == "LCD35" ]; then
        header "Setup for Waveshare 3.5 inch (A) screen"
    elif [ "$1" == "LCD35B" ]; then
        header "Setup for Waveshare 3.5 inch (B) IPS screen"
    elif [ "$1" == "LCD35BV2" ]; then
        header "Setup for Waveshare 3.5 inch (B) IPS rev. 2 screen"
    elif [ "$1" == "NODISP" ]; then
        header "Setup without display driver installation"
    else
        error "Unknown parameter \"$1\""
        error "Allowed parameters:"
        error "LCD35    - create 3.5\" setup (instead of 3.2\")"
        error "LCD35B   - create 3.5\" IPS setup"
        error "LCD35BV2 - create 3.5\" IPS rev. 2 setup"
        error "NODISP   - do not install a display driver (Install manually first!)"
        exit 2
    fi
else
   header "Setup for Waveshare 3.2 inch screen"
fi

source tx-pi-setup-hostname.sh

source tx-pi-setup-sources.sh

source tx-pi-setup-package-installation.sh

source tx-pi-setup-display-setup.sh

source tx-pi-setup-i2c-setup.sh

source tx-pi-setup-wlan-setup.sh

source tx-pi-setup-usbmount-config.sh

# ToDo not complete tx-pi setup
## create file indicating that this is a tx-pi setup
#touch /etc/tx-pi

## TX-Pi version information
#echo "${TX_PI_VERSION}" > /etc/tx-pi-ver.txt

source tx-pi-setup-locales.sh

source tx-pi-setup-bluetooth-tools.sh

source tx-pi-setup-OpenCV.sh

source tx-pi-setup-user-setup.sh

source tx-pi-setup-X-server.sh

source tx-pi-setup-Splash-screen.sh

source tx-pi-setup-framebuffer-install.sh

source tx-pi-setup-disable-screensaver.sh

source tx-pi-setup-vnc-install.sh

source tx-pi-setup-locale-network-timezone.sh

source tx-pi-setup-ftc-firmware.sh
