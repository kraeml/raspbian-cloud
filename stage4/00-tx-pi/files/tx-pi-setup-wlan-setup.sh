#!/bin/bash

# Todo not working in pi-gen
##-- Enable WLAN iff it isn't enabled yet
#if [ "$(wpa_cli -i wlan0 get country)" == "FAIL" ]; then
#    msg "Enable WLAN"
#    rfkill unblock wifi
#    wpa_cli -i wlan0 set country DE
#    wpa_cli -i wlan0 save_config
#    ifconfig wlan0 up
#else
#    msg "WLAN already configured, don't touch it"
#fi
