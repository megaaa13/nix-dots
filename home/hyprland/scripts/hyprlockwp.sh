#/usr/bin/env bash

currentoutput="$(hyprctl activeworkspace| head -1 | awk '{print $NF}' | rev | cut -c 2- | rev)"

cat ~/.cache/swww/$1