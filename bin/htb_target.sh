#!/bin/sh

ip_target=$(cat ~/.config/bin/target | awk '{print $1}')
name_target=$(cat ~/.config/bin/target | awk '{print $2}')

	if [ $ip_target ] && [ $name_target ]; then
	echo "%{F#A3E6B2}什%{F#A3E6B2} $ip_target - $name_target"
	elif [ $(cat ~/.config/bin/target | wc -w) -eq 1 ]; then
	echo "%{F#A3E6B2}什%{F#A3E6B2} $ip_target"
	else
	echo "%{F#d3c6aa}ﲅ %{u-}%{F#d3c6aa} No target"
	fi

