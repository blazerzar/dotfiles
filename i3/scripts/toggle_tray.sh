#!/usr/bin/bash

running_instance=$(ps cax | grep stalonetray)

# Check if tray is open and toggle it
if [[ -z $running_instance ]]; then
    # Open tray
    stalonetray &
else
    # Close tray
    killall stalonetray
fi

exit 0
