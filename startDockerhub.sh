#!/bin/sh
# Ubuntu 20.04LTS headless noVNC
# Connect to http://localhost:6083/
REPO=mgkahn/
IMAGE=mgk

URL=http://localhost:6083

if [ -z "$SUDO_UID" ]
then
  # not in sudo
  USER_ID=`id -u`
  USER_NAME=`id -n -u`
else
  # in a sudo script
  USER_ID=${SUDO_UID}
  USER_NAME=${SUDO_USER}
fi


# Stores Desktop into Docker volume
# Creates desktop folder on both Ubuntu and host for file exchange

docker volume create test_vol_3

docker run --rm --detach \
  --publish 6083:80 \
  --volume "${PWD}":/workspace:rw \
  --volume test_vol_3:/home/${USER_NAME} \
  --volume "${HOME}"/Desktop/test_desktop:/home/${USER_NAME}/Desktop/test_desktop \
  --env USERNAME=${USER_NAME} --env USERID=${USER_ID} \
  --env PASSWORD="nurs6293" \
  --name ${IMAGE} \
  --net testnet \
   ${REPO}${IMAGE}

sleep 5

if [ -z "$SUDO_UID" ]
then
     open -a firefox http://localhost:6083 \
  || xdg-open http://localhost:6083 \
  || echo "Point your web browser at http://localhost:6083"
else
     su ${USER_NAME} -c 'open -a firefox http://localhost:6083' \
  || su ${USER_NAME} -c 'xdg-open http://localhost:6083' \
  || echo "Point your web browser at http://localhost:6083"
fi
