#!/bin/sh

echo -e "  %{F#FDA5B8} %{F#FDA5B8}$(/usr/sbin/ifconfig ens33 | grep "inet " | awk '{print $2}')%{u-}"
