#!/bin/bash -e

on_chroot << EOF

echo 'Installing Ansible'
pip3 install ansible \
  paho-mqtt \
  tweepy \
  psutil

su --login --command 'git clone -b master https://kraeml@gitlab.com/kraeml/raspberry-edu-devops.git ~/.raspberry-edu-devops || (cd ~/.raspberry-edu-devops; git pull)' ${FIRST_USER_NAME}
su --login --command 'cd ~/.raspberry-edu-devops/; mkdir roles || true; ansible-galaxy install --force --role-file=requirements.yml' ${FIRST_USER_NAME}
#su --login --command 'ansible-playbook --inventory ~/.raspberry-edu-devops/hosts --limit lokal ~/.raspberry-edu-devops/site.yml' ${FIRST_USER_NAME}
#TODO not running because wrong hostname
#su --login --command 'ansible-playbook --inventory ~/.raspberry-edu-devops/hosts --limit $(hostname) ~/.raspberry-edu-devops/site.yml' ${FIRST_USER_NAME}
EOF