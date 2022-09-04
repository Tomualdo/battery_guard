#!/bin/bash
while true
do
  on_ac_power
  CHARGING=$(echo $?)
  battery_level=`acpi -b | grep -P -o '[0-9]+(?=%)'`
   if [ $battery_level -ge 80 ] && [ $CHARGING -eq 0 ]; then
      notify-send "Battery Full - Unplug the charger !!!" "Level: ${battery_level}%"
      paplay /usr/share/sounds/freedesktop/stereo/bell.oga
    elif [ $battery_level -le 28 ] && [ $CHARGING -ne 0 ]; then
      notify-send --urgency=CRITICAL "Battery Low" "Level: ${battery_level}%"
      paplay /usr/share/sounds/freedesktop/stereo/bell.oga
  fi
 sleep 20
done
