#!/bin/sh
# Ubuntu 22.04LTS headless noVNC
# Connect to http://localhost:6080/
# $1 = IMAGE NAME

IMAGE=$1
VOLUME=ui_vol
NETWORK=n6293_net
PORT=6080

URL=http://localhost:${PORT}

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

docker volume create ${VOLUME}

## Only create network if it isn't present
## FROM https://stackoverflow.com/questions/48643466/docker-create-network-should-ignore-existing-network
## FOR WINDOWS/Powershell
#
# $networkName = "fb_net"
#
# if (docker network ls | select-string $networkName -Quiet )
# {
#     Write-Host "$networkName already created"
# } else {
#     docker network create $networkName
# }

## FOR LINUX.
docker network inspect ${NETWORK} --format {{.Id}} 2>/dev/null || docker network create --driver bridge ${NETWORK}


docker run --rm --detach \
  --publish ${PORT}:80 \
  --volume "${PWD}":/workspace:rw \
  --volume ${VOLUME}:/home/${USER_NAME}:rw \
  --volume  /var/run/docker.sock:/var/run/docker.sock \
  --env USERNAME=${USER_NAME} --env USERID=${USER_ID} \
  --env PASSWORD="nurs6293" \
  --network ${NETWORK} \
  --name ${IMAGE} \
  ${IMAGE}

echo "Sleeping for 10 seconds for start-up"
sleep 10

if [ -z "$SUDO_UID" ]
then
     open -a 'Google Chrome' http://localhost:${PORT} \
  || xdg-open http://localhost:${PORT} \
  || echo "Point your web browser at http://localhost:${PORT}"
else
     su ${USER_NAME} -c 'open -a 'Google Chrome' http://localhost:${PORT}' \
  || su ${USER_NAME} -c 'xdg-open http://localhost:${PORT}' \
  || echo "Point your web browser at http://localhost:${PORT}"
fi
