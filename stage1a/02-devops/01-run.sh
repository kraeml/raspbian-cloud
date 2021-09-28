#!/bin/bash -e

on_chroot << EOF

echo 'Installing Ansible'
pip3 install ansible

echo 'Get selenium'
pip3 install selenium \
  pyvirtualdisplay

echo 'Get gems'
gem install --no-document bundler inspec:'1.51.25'
EOF
