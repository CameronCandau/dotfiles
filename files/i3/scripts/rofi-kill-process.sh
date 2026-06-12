#!/usr/bin/env sh
# kill a running process using rofi

# Sourced from: https://github.com/mahmoodsh36/scripts/blob/main/rofi_kill_process.sh

process_name=`ps -e | awk '{ print $4 }' | sort -u | rofi -dmenu -i -p "process"`
if [ ! -z $process_name ]; then
    for process in $(ps -e | grep " $process_name$" | awk '{ print $1 }');
    do
        if [ ! -z $process ]; then
            kill -9 $process
        fi
    done
    if [ -z "$(ps -e | grep " $process_name$")" ]; then
        notify-send "$process_name killed"
    fi
fi