#! /bin/bash

# Move jaybrid to /usr/local/bin is done in system build

mkdir -p /builder/jaybird-4
curl -L -o /builder/jaybird-4/jaybird.zip -L ${JAYURL}
cd /builder/jaybird-4
unzip /builder/jaybird-4/jaybird.zip