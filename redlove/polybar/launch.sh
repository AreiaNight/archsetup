#!/usr/bin/env bash

DIR="$HOME/.config/polybar"

pkill polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar -q bar-main -c "$DIR"/config.ini &