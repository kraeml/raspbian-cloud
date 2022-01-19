#!/bin/bash -eux

mkdir /home/"${FIRST_USER_NAME}"/bin/ || true
mkdir /home/"${FIRST_USER_NAME}"/notebooks/ || true
chown --recursive "${FIRST_USER_NAME}":"${FIRST_USER_NAME}" /home/"${FIRST_USER_NAME}"/notebooks/
chown --recursive "${FIRST_USER_NAME}":"${FIRST_USER_NAME}" /home/"${FIRST_USER_NAME}"/bin/
su - -c "cd /home/${FIRST_USER_NAME}/bin && virtualenv -p python3 jupyter-venv" "${FIRST_USER_NAME}"
su - -c "source /home/${FIRST_USER_NAME}/bin/jupyter-venv/bin/activate && pip install -U jupyterlab matplotlib opencv-python paho-mqtt" "${FIRST_USER_NAME}"

# Running in chroot, ignoring request: daemon-reload
# systemctl daemon-reload
# systemctl enable jupyter.service
