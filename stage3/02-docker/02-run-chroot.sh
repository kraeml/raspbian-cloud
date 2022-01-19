#!/bin/bash -eux

mkdir -p /home/"${FIRST_USER_NAME}"/containers/mosquitto/{config,data,log} || true

cat > /home/"${FIRST_USER_NAME}"/containers/mosquitto/config/mosquitto.conf <<EOF
listener 1883
listener 9001
protocol websockets
persistence true
persistence_location /mosquitto/data/
log_dest file /mosquitto/log/mosquitto.log
allow_anonymous true
EOF
cat > /home/"${FIRST_USER_NAME}"/containers/mosquitto/docker-compose.yml <<EOF
version: '3.7'

services:
  mosquitto:
    image: eclipse-mosquitto
    container_name: mosquitto
    restart: always
    ports:
      - "1883:1883"
      - "9001:9001"
    volumes:
      - ./containers/mosquitto/config:/mosquitto/config
      - ./containers/mosquitto/data:/mosquitto/data
      - ./containers/mosquitto/log:/mosquitto/log
      - /etc/localtime:/etc/localtime:ro
    user: "$(getent passwd ${FIRST_USER_NAME} | cut -d ':' -f3,4)"
EOF
cd /home/"${FIRST_USER_NAME}"/containers/mosquitto/
# docker-compose pull
chown --recursive "${FIRST_USER_NAME}":"${FIRST_USER_NAME}" /home/"${FIRST_USER_NAME}"/containers/
