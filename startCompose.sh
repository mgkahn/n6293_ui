#! /bin/bash
# exit when any command fails
set -e

USER_ID=`id -u` USER_NAME=`id -n -u` docker-compose pull
USER_ID=`id -u` USER_NAME=`id -n -u` docker-compose up  \
  --abort-on-container-exit \
  --exit-code-from ui & 
sleep 5   
open http://localhost:6080 \
  || xdg-open http://localhost:6080 \
  || echo "Point your web browser at http://localhost:6080"
