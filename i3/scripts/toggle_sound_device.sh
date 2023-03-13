#!/usr/bin/bash

SPEAKERS=analog-output-lineout
HEADPHONES=analog-output-headphones

# Get active sink
sink=$(
    pactl list sinks |
    pcregrep -M "State: RUNNING\n\tName: .*" |
    tail -n 1 |
    sed "s/Name: //" |
    xargs
)

# Get current active device
active_device=$(
    pactl list sinks |
    grep "Active Port: analog-output-" |
    sed "s/Active Port: //" |
    xargs
)

# Toggle device (port)
if [[ "$active_device" == "$SPEAKERS" ]]; then
    pactl set-sink-port $sink $HEADPHONES
else
    pactl set-sink-port $sink $SPEAKERS
fi

exit 0
