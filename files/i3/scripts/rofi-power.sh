#!/bin/bash
# ~/.config/i3/scripts/power-menu.sh
options="🔒 Lock\n💤 Suspend\n🔄 Reboot\n⚡ Shutdown"
chosen=$(echo -e "$options" | rofi -dmenu -p "Power")

case $chosen in
    "🔒 Lock") i3lock --color 000000 ;;
    "💤 Suspend") i3lock -c 000000 & sleep 1 && systemctl suspend ;;
    "🔄 Reboot") systemctl reboot ;;
    "⚡ Shutdown") systemctl poweroff ;;
esac