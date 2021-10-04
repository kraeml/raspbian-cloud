#!/bin/bash -e

on_chroot << EOF
echo 'Installing Docker'

if ! docker -v
then
	curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
	echo "deb [arch=armhf] https://download.docker.com/linux/raspbian buster stable" | tee /etc/apt/sources.list.d/docker.list
	apt-get update
	#echo 'TODO Install docker-compose on native RaspberryPi would be better'
	pip3 install docker-compose
	apt-get install --no-install-recommends docker-ce docker-ce-cli containerd.io
	echo install bash completion for Docker CLI
	curl -sSL -o /etc/bash_completion.d/docker \
		"https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker"
	#docker pull hello-world
	#docker pull nodered/node-red-docker:rpi
fi

usermod -aG docker ${FIRST_USER_NAME}
EOF
