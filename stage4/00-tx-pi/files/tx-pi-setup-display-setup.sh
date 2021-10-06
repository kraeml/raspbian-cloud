#!/bin/bash

# ---------------------- display setup ----------------------
header "Install screen driver"

if [ ${LCD} == "NODISP" ]; then
    header "  --> Skipped by user request <--"
else
    cd /root
    wget -N https://www.waveshare.com/w/upload/0/00/LCD-show-170703.tar.gz
    tar xvfz LCD-show-170703.tar.gz
    if [ ${LCD} == "LCD35BV2" ]; then
        # Support for Waveshare 3.5" "B" rev. 2.0
        # This display is not supported by the LCD-show-170703 driver but by
        # the Waveshare GH repository.
        # We won't switch to the GH repository soon since it causes more problems
        # than blessing (2019-04)
        cp ./LCD-show/LCD35B-show ./LCD-show/$LCD-show
        wget https://github.com/waveshare/LCD-show/raw/master/waveshare35b-v2-overlay.dtb -P ./LCD-show/
        sed -i "s/waveshare35b/waveshare35b-v2/g" ./LCD-show/$LCD-show
    fi
    # supress automatic reboot after installation
    sed -i "s/sudo reboot/#sudo reboot/g" LCD-show/$LCD-show
    sed -i "s/\"reboot now\"/\"not rebooting yet\"/g" LCD-show/$LCD-show
    cd LCD-show
    ./$LCD-show $ORIENTATION
    # Clean up
    cd ..
    rm -f ./LCD-show-170703.tar.gz
    if [ "$DEBUG" = false ]; then
        rm -rf ./LCD-show
    fi
    if [ $LCD == "LCD35BV2" ]; then
        # Support for Waveshare 3.5" "B" rev. 2.0
        sed -i "s/waveshare35b/waveshare35b-v2/g" /boot/config.txt
    fi
fi

# Driver installation changes "console=serial0,115200" to "console=ttyAMA0,115200"
# Revert it here since /dev/ttyAMA0 is Bluetooth (Pi3, Pi3B+ ...)
sed -i "s/=ttyAMA0,/=serial0,/g" /boot/cmdline.txt
cmd_line=$( cat /boot/cmdline.txt )
# Driver installation removes "fsck.repair=yes"; revert it
if [[ $cmd_line != *"fsck.repair=yes"* ]]; then
    cmd_line="$cmd_line fsck.repair=yes"
fi
cat > /boot/cmdline.txt <<EOF
${cmd_line}
EOF
