#!/usr/bin/bash

SINK=alsa_output.pci-0000_00_1f.3.analog-stereo
SPEAKERS=analog-output-lineout
HEADPHONES=analog-output-headphones

# Get current active device
active_device=$(
    pactl list sinks |
    grep "Active Port: analog-output-" |
    sed "s/Active Port: //" |
    xargs
)

# Toggle device (port)
if [[ "$active_device" == "$SPEAKERS" ]]; then
    pactl set-sink-port $SINK $HEADPHONES
else
    pactl set-sink-port $SINK $SPEAKERS
fi

exit 0
