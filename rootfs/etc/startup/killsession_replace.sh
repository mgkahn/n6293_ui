#!/bin/bash

# Replace original killsession.py with my version

# V1.0: Change KillSession dialog message
# .     Add SIGTERM to db container -- REQUIRES /var/run/docker.sock to be mounted to work

cp /etc/startup/killsession/killsession.py /usr/local/bin/killsession.py

# Need sudo access to run nc for SIGTERM
# echo "%sudo ALL=(ALL) NOPASSWD: /usr/bin/nc" > /etc/sudoers.d/netcat
cp /etc/startup/killsession/nc.sudoer /etc/sudoers.d/nc.sudoer