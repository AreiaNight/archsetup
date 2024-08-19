#!/bin/sh

echo -e " %{F#d3c6aa} %{F#d3c6aa}$(/usr/sbin/ifconfig ens33 | grep "inet " | awk '{print $2}')%{u-}"
