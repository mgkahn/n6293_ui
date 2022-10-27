#!/bin/bash

# Check for sh files in /builder that should be sourced
# to customize the Docker image

for stsrc in /builder/*.sh; do
  if [ -r $stsrc ]; then
  	chmod +x $stsrc
    source $stsrc
  fi
done