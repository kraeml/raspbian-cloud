#!/bin/bash -e

# install -d -m 744 files/ ${ROOTFS_DIR}/tmp

on_chroot << EOF
echo 'Install tx-pi OpenCV'
pip3 install zbarlight
EOF
