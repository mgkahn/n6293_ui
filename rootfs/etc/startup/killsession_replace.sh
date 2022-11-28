#!/bin/bash

# Replace original warning message
sed -i -e "s/Local data will be lost/Desktop data and folders will be saved/" /usr/local/bin/killsession.py

# Add send SIGTERM signal to db container. Requires /var/run/docker.sock to be mounted"
sed -i -e "s^os.system^os.system(\"echo 'POST \/containers\/db\/kill?signal=SIGTERM HTTP\/1.0\\\r\\\n'|sudo nc -U \/var\/run\/docker.sock\")\n        os.system^" /usr/local/bin/killsession.py 
# Need sudo access to run nc
echo "%sudo ALL=(ALL) NOPASSWD: /usr/bin/nc" > /etc/sudoers.d/netcat