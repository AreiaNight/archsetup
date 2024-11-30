#!/bin/sh

echo -e "  %{F#f1f173} %{F#f1f173}$(/usr/sbin/ifconfig ens33 | grep "inet " | awk '{print $2}')%{u-}"
