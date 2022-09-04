#!/bin/bash

FIRST_NOTIFY=1
BAT=$(upower -e | grep -P -o 'BAT\d' | sed -n 1p)
while true
do
  #on_ac_power
  CHARGING=$(echo $?)
  CHARGING=$(cat /sys/class/power_supply/$BAT/status)
  if [ $CHARGING == "Charging" ]; then
	  CHARGING=1
  else
	  CHARGING=0
  fi

  #battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
  battery_level=$(upower -i /org/freedesktop/UPower/devices/battery_$BAT | grep -P -o '[0-9]+(?=%)' | sed -n 1p)
  
  # test notify-send
  if [ $FIRST_NOTIFY -eq 1 ]; then
	  echo "Battery guard started.."
	  notify-send "Battery guard started..."
	  NOTIFY_ENABLED=$(echo $?)
	  FIRST_NOTIFY=0
  fi

   if [ $battery_level -ge 80 ] && [ $CHARGING -eq 1 ]; then
	   if [ $NOTIFY_ENABLED -eq 0 ];then
	      notify-send "Battery Full - Unplug the charger !!!" "Level: ${battery_level}%"
	   fi
      paplay /usr/share/sounds/freedesktop/stereo/bell.oga
    elif [ $battery_level -le 56 ] && [ $CHARGING -ne 1 ]; then
	   if [ $NOTIFY_ENABLED -eq 0 ];then
      		notify-send --urgency=CRITICAL "Battery Low" "Level: ${battery_level}%"
	   fi
      paplay /usr/share/sounds/freedesktop/stereo/bell.oga
  fi
 sleep 20
done
