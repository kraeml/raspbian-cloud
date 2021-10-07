#!/bin/bash -e

# Install overlays for tft GPIO displays
install -m 755 -g root -o root  LCD-show/waveshare*.dtb ${ROOTFS_DIR}/boot/overlays/
cp -a ${ROOTFS_DIR}/boot/overlays/waveshare35b-v2-overlay.dtb  ${ROOTFS_DIR}/boot/overlays/waveshare35b-v2.dtbo

# Waveshare35b V2: lite orientiation 270
mkdir -p ${ROOTFS_DIR}/usr/share/X11/xorg.conf.d

# Not needed same md5sum
#cp -rf LCD-show/etc/rc.local ${ROOTFS_DIR}//etc/rc.local
cp -rf LCD-show/usr/share/X11/xorg.conf.d/99-fbturbo.conf  ${ROOTFS_DIR}/usr/share/X11/xorg.conf.d/99-fbturbo.conf
cp -rf LCD-show/etc/X11/xorg.conf.d/99-calibration.conf-35b  ${ROOTFS_DIR}/usr/share/X11/xorg.conf.d/99-calibration.conf

# ToDo do only someline in config.txt
#cp LCD-show/boot/config-35b-v2.txt ${ROOTFS_DIR}/boot/config.txt
sed -i -E 's;^#(hdmi_force_hotplug.*);\1;g' ${ROOTFS_DIR}/boot/config.txt
sed -i -E 's;^#(hdmi_mode.*);\1;g' ${ROOTFS_DIR}/boot/config.txt
sed -i -E 's;^#(hdmi_drive.*);\1;g' ${ROOTFS_DIR}/boot/config.txt
sed -i -E 's;^#(hdmi_group)=.*;\1=2;g' ${ROOTFS_DIR}/boot/config.txt
sed -i -E 's;^#(dtparam=i2c_arm=on);\1;g' ${ROOTFS_DIR}/boot/config.txt
sed -i -E 's;^#(dtparam=spi=on);\1;g' ${ROOTFS_DIR}/boot/config.txt
echo "dtoverlay=waveshare35b-v2:rotate=180" >> ${ROOTFS_DIR}/boot/config.txt
echo "hdmi_mode=87" >> ${ROOTFS_DIR}/boot/config.txt
echo "hdmi_cvt 480 320 60 6 0 0 0" >> ${ROOTFS_DIR}/boot/config.txt
echo "display_rotate=3" >> ${ROOTFS_DIR}/boot/config.txt

# ToDo append "quiet splash fbcon=map:10 fbcon=font:ProFont6x11"
#cp LCD-show/cmdline.txt ${ROOTFS_DIR}/boot/
sed -i -E 's;^(console=.*$);\1 quiet splash fbcon=map:10 fbcon=font:ProFont6x11;g' ${ROOTFS_DIR}/boot/cmdline.txt

# May not do
#cp LCD-show/inittab ${ROOTFS_DIR}/etc/

on_chroot << EOF
  # raspi-config nonint do_i2c 0
  # raspi-config nonint do_spi 0
  # raspi-config nonint do_serial 0
EOF
