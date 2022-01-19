#!/bin/bash -e

install -m 644 files/jupyter.service ${ROOTFS_DIR}/etc/systemd/system/
