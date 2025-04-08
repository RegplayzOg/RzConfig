#!/bin/bash

# Get the current default audio sink
SINK=$(pactl get-default-sink)

case "$1" in
  up)
    pactl set-sink-volume "$SINK" +5%
    ;;
  down)
    pactl set-sink-volume "$SINK" -5%
    ;;
  mute)
    pactl set-sink-mute "$SINK" toggle
    ;;
  *)
    echo "Usage: $0 {up|down|mute}"
    exit 1
    ;;
esac
