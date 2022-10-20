#!/bin/bash
touch /dev/shm/octodetect_state
udevd --daemon &> /dev/null

if [[ -n "$OCTOPRINT_APIKEY" ]]; then
  tail -f '/dev/shm/octodetect_state' 2> /dev/null
else
while true
do
  echo "OCTOPRINT_APIKEY has not been provided in service variables. Set it to enable automatic detection and connection of your printer"
  sleep 120
done
fi
