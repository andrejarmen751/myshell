#!/bin/bash
meter=0
max=1
old_user=none
while [ $meter -lt 1 ]; do
	sleep 1
	meter=$((meter + 1))
	real_user=$(who -a)
	if [ "$meter" -eq "$max" ]; then
		if [ "$real_user" != "$old_user" ]; then
			echo "\nUsers:\n $real_user"
			old_user="$real_user"
		fi
		meter=$((0))
		sleep 2400
	fi
done
