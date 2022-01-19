#!/bin/bash -eux

mkdir /home/"${FIRST_USER_NAME}"/bin/ || true
mkdir /home/"${FIRST_USER_NAME}"/workspace/ || true
chown --recursive "${FIRST_USER_NAME}":"${FIRST_USER_NAME}" /home/"${FIRST_USER_NAME}"/bin/
chown --recursive "${FIRST_USER_NAME}":"${FIRST_USER_NAME}" /home/"${FIRST_USER_NAME}"/workspace/
su - -c "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash" "${FIRST_USER_NAME}"
#echo /home/${FIRST_USER_NAME}/.nvm
#su - -c "export NVM_DIR=/home/${FIRST_USER_NAME}/.nvm; [ -s ${NVM_DIR}/nvm.sh ] && source ${NVM_DIR}/nvm.sh; nvm install 12" "${FIRST_USER_NAME}"

cd /home/"${FIRST_USER_NAME}"/bin
su - -c "git clone git://github.com/c9/core.git /home/"${FIRST_USER_NAME}"/bin/c9sdk" "${FIRST_USER_NAME}"
export NVM_DIR=/home/${FIRST_USER_NAME}/.nvm
su --login -c "cd /home/${FIRST_USER_NAME}/bin/c9sdk; [ -s ${NVM_DIR}/nvm.sh ] && \. ${NVM_DIR}/nvm.sh; nvm use 12; scripts/install-sdk.sh" "${FIRST_USER_NAME}"
