#!/bin/bash -eux

# Install overlays for tft GPIO displays
install -m 755 -g root -o root  LCD-show/waveshare*.dtb ${ROOTFS_DIR}/boot/overlays/
cp -a ${ROOTFS_DIR}/boot/overlays/waveshare35b-v2-overlay.dtb  ${ROOTFS_DIR}/boot/overlays/waveshare35b-v2.dtbo

# Waveshare35b V2: lite orientiation 90
mkdir -p ${ROOTFS_DIR}/usr/share/X11/xorg.conf.d

cp -rf LCD-show/usr/share/X11/xorg.conf.d/99-fbturbo.conf  ${ROOTFS_DIR}/usr/share/X11/xorg.conf.d/99-fbturbo.conf

# Change only someline in config.txt
sed -i -E 's;^#(hdmi_force_hotplug.*);\1;g' ${ROOTFS_DIR}/boot/config.txt
#sed -i -E 's;^#(hdmi_mode.*);\1;g' ${ROOTFS_DIR}/boot/config.txt
#sed -i -E 's;^#(hdmi_drive.*);\1;g' ${ROOTFS_DIR}/boot/config.txt
#sed -i -E 's;^#(hdmi_group)=.*;\1=2;g' ${ROOTFS_DIR}/boot/config.txt
sed -i -E 's;^#(dtparam=i2c_arm=on);\1;g' ${ROOTFS_DIR}/boot/config.txt
sed -i -E 's;^#(dtparam=spi=on);\1;g' ${ROOTFS_DIR}/boot/config.txt
echo "dtoverlay=waveshare35b-v2:rotate=180" >> ${ROOTFS_DIR}/boot/config.txt
#echo "hdmi_mode=87" >> ${ROOTFS_DIR}/boot/config.txt
#echo "hdmi_cvt 480 320 60 6 0 0 0" >> ${ROOTFS_DIR}/boot/config.txt
#echo "display_rotate=1" >> ${ROOTFS_DIR}/boot/config.txt

# May not do in systemd
#cp LCD-show/inittab ${ROOTFS_DIR}/etc/

on_chroot << EOF
  # Will done via cloudinit
  # raspi-config nonint do_i2c 0
  # raspi-config nonint do_spi 0
  # raspi-config nonint do_serial 0

  cp -rf /usr/share/X11/xorg.conf.d/10-evdev.conf /usr/share/X11/xorg.conf.d/45-evdev.conf

  cat > /usr/share/X11/xorg.conf.d/99-calibration.conf <<END
Section "InputClass"
    Identifier      "calibration"
    MatchProduct    "ADS7846 Touchscreen"
    Option  "Calibration"   "3696 229 3945 197"
    Option  "SwapAxes"      "0"
EndSection
END
EOF
