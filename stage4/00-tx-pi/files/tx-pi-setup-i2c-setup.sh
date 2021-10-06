#!/bin/bash


## Not working in pi-gen
##-- Support for the TX-Pi HAT
## Enable I2c
#header "Enable I2C"
#raspi-config nonint do_i2c 0 dtparam=i2c_arm=on
#sed -i "s/dtparam=i2c_arm=on/dtparam=i2c_arm=on\ndtparam=i2c_vc=on/g" /boot/config.txt
## Disable RTC
#sed -i "s/exit 0/\# ack pending RTC wakeup\n\/usr\/sbin\/i2cset -y 0 0x68 0x0f 0x00\n\nexit 0/g" /etc/rc.local
## Power control via GPIO4
#echo "dtoverlay=gpio-poweroff,gpiopin=4,active_low=1" >> /boot/config.txt
