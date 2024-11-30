#!/bin/sh

ip_target=$(cat ~/.config/bin/target | awk '{print $1}')
name_target=$(cat ~/.config/bin/target | awk '{print $2}')

	if [ $ip_target ] && [ $name_target ]; then
	echo "%{F#f1f173} 󰋔%{F#f1f173} $ip_target - $name_target"
	elif [ $(cat ~/.config/bin/target | wc -w) -eq 1 ]; then
	echo "%{F#f1f173} 󰋔%{F#f1f173} $ip_target"
	else
	echo "%{F#f1f173}   No target%{u-}%{F#f1f173}"
	#No target
	fi

