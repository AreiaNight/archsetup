#!/usr/bin/env sh

## Add this to your wm startup file.

# Terminate already running bar instances
killall -q polybar

## Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

## Launch
polybar -q aphrodite-bar -c ~/.config/polybar/config.ini &
polybar -q aphrodite-bar2 -c ~/.config/polybar/config.ini &
polybar -q aphrodite-bar2B -c ~/.config/polybar/config.ini &
polybar -q aphrodite-bar3 -c ~/.config/polybar/config.ini &
polybar -q aphrodite-wp -c ~/.config/polybar/config.ini &
