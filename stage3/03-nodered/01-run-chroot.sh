#!/bin/bash -eux

mkdir /home/"${FIRST_USER_NAME}"/bin/ || true
curl -sL  https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered > /home/"${FIRST_USER_NAME}"/bin/update-nodejs-and-nodered
chown --recursive "${FIRST_USER_NAME}":"${FIRST_USER_NAME}" /home/"${FIRST_USER_NAME}"/bin/

chmod u+x /home/"${FIRST_USER_NAME}"/bin/update-nodejs-and-nodered
su -c "yes | /home/${FIRST_USER_NAME}/bin/update-nodejs-and-nodered" "${FIRST_USER_NAME}"

npm install --global node-red-admin

systemctl enable pigpiod.service
systemctl enable nodered.service

NODERED_PACKAGES="node-red-dashboard node-red-contrib-bigtimer \
                  node-red-contrib-looptimer \
                  node-red-contrib-solar-power-forecast \
                  node-red-node-openweathermap \
                  node-red-node-arduino node-red-node-pi-gpiod"
for i in $NODERED_PACKAGES
do
  su - -c "cd .node-red/ && npm install $i" "${FIRST_USER_NAME}"
done

su - -c 'cd .node-red/ && npm rebuild' "${FIRST_USER_NAME}"
