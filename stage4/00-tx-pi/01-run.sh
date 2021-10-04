#!/bin/bash -e

install -m 744 files/tx-pi-setup.sh ${ROOTFS_DIR}/tmp

on_chroot << EOF
echo 'Install tx-pi'
# /tmp/tx-pi-setup.sh NODISP
EOF
