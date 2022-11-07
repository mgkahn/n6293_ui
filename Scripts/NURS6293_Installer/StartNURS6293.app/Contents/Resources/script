#! /bin/bash

# V4: Simplified YML commands for docker pull
# V5: Added full path for docker because doesn't pull user environment variables;  removes stdout, stderr redirection
# V6: Simplified YML commands for docker pull
# V7: Remove /usr/local/bin from docker command. Add -l to Platypus CLI script to ensure login shell for local $PATH

echo "Removing containers: ui/db"
docker container rm ui db

echo "Pulling new version(s) of Docker containers (if needed)"
echo 'version: "3.9"
services:
  db:
    image: mgkahn/db:latest
    container_name: db

  ui:
    image: mgkahn/ui:latest
    container_name: ui
'|USER_ID=`id -u` USER_NAME=`id -n -u` docker compose -f - pull
echo "Starting containers"
echo 'version: "3.9"
services:
  db:
    image: mgkahn/db:latest
    container_name: db
    environment:
      PREFIX: /usr/local/firebird
      VOLUME: /firebird
      DEBIAN_FRONTEND: noninteractive
      ISC_PASSWORD: nurs6293
      TZ: America/Denver
      NETWORK: 6293_net
    ports: 
      - 3050:3050
    volumes:
      - $PWD:/workspace
      - db_vol:/firebird
    networks:
        - n6293_net

  ui:
    image: mgkahn/ui:latest
    container_name: ui
    environment:
      DEBIAN_FRONTEND: noninteractive
      TZ: America/Denver
      LIBGL_ALWAYS_INDIRECT: 1
      USERNAME: $USER_NAME
      USERID: $USER_ID
      PASSWORD: nurs6293
      RESOLUTION: 1600x900
    networks:
      - n6293_net
    ports:
      - 6080:80
      - 5900:5900
    volumes:
      - $PWD:/workspace
      - ui_vol:/home/$USER_NAME
      - $HOME/Desktop/Transfer_Station:/home/$USER_NAME/Desktop/Transfer_Station

networks:
   n6293_net:
      driver: bridge 
volumes:
  ui_vol:
    driver: local
  db_vol:
    driver: local
'|USER_ID=`id -u` USER_NAME=`id -n -u` docker compose -f - up \
  --abort-on-container-exit \
  --exit-code-from ui &
echo "Sleeping 5 seconds to allow Ubuntu to start"
sleep 5   
open http://localhost:6080 \
  || xdg-open http://localhost:6080 \
  || echo "Point your web browser at http://localhost:6080"

