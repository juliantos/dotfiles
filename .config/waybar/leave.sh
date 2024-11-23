#!/usr/bin/env bash

choice=$(printf "Lock\nLogout\nSuspend\nReboot\nShutdown" | rofi -dmenu -theme solarized)
if [[ $choice == "Lock" ]]; then
    playerctl stop
    swaylock -f -c 000000
elif [[ $choice == "Logout" ]]; then
    sway exit
elif [[ $choice == "Suspend" ]]; then
    systemctl suspend
elif [[ $choice == "Reboot" ]]; then
    systemctl reboot
elif [[ $choice == "Shutdown" ]]; then
    systemctl poweroff
fi
