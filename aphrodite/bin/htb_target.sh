#!/bin/sh

ip_target=$(cat ~/.config/bin/target | awk '{print $1}')
name_target=$(cat ~/.config/bin/target | awk '{print $2}')

	if [ $ip_target ] && [ $name_target ]; then
	echo "%{F#EC758C} 󰋔%{F#EC758C} $ip_target - $name_target"
	elif [ $(cat ~/.config/bin/target | wc -w) -eq 1 ]; then
	echo "%{F#EC758C} 󰋔%{F#EC758C} $ip_target"
	else
	echo "%{F#FDA5B8}   No target%{u-}%{F#FDA5B8}"
	#No target
	fi

