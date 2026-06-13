#!/usr/bin/env sh
# Kill a running process using rofi.

# Sourced from: https://github.com/mahmoodsh36/scripts/blob/main/rofi_kill_process.sh

process_name="$(ps -e -o comm= | sort -u | rofi -dmenu -i -p "process")"

if [ -n "$process_name" ]; then
    if pkill -x "$process_name"; then
        notify-send "$process_name killed"
    fi
fi
