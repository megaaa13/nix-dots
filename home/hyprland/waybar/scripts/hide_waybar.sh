#!/usr/bin/env bash

# Get the PID of the waybar process
PID=$(pgrep waybar)

# If the PID is not empty, send the SIGUSR1 signal to the waybar process
if [ -n "$PID" ]; then
    kill -SIGUSR1 $PID
fi

# If the PID is empty, start the waybar process
if [ -z "$PID" ]; then
    waybar
fi

# Exit the script
exit 0