#!/bin/bash -e

on_chroot << EOF

echo 'Installing Ansible'
pip3 install ansible
#ToDo install ansible packages via galaxy
EOF
