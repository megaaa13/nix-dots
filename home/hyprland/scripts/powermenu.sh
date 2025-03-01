#!/usr/bin/env bash

# Current Theme
dir="themes"
theme='powermenu'

# Options
printf -v shutdown "\Uf0425"
printf -v reboot "\Uf0709"
printf -v lock "\Uf033e"
printf -v suspend "\Uf186"
printf -v logout "\Uf2f5"
printf -v yes "\Uf00c"
printf -v no "\Uf0156"

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-theme ~/.config/rofi/themes/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
	rofi -theme-str 'window {location: center; anchor: center; fullscreen: false; width: 350px;}' \
		-theme-str 'mainbox {children: [ "message", "listview" ];}' \
		-theme-str 'listview {columns: 2; lines: 1;}' \
		-theme-str 'element-text {horizontal-align: 0.5;}' \
		-theme-str 'textbox {horizontal-align: 0.5;}' \
		-dmenu \
		-p 'Confirmation' \
		-mesg "${1} ?" \
		-theme ~/.config/rofi/themes/${theme}.rasi
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd $1
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit $1)"
	if [[ "${selected}" == "${yes}" ]]; then
		if [[ $1 == 'Shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == 'Reboot' ]]; then
			systemctl reboot
		elif [[ $1 == 'Suspend' ]]; then
			playerctl pause
			systemctl suspend
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"

if [[ "${chosen}" == "${shutdown}" ]]; then
    run_cmd Shutdown
elif [[ "${chosen}" == "${reboot}" ]]; then
    run_cmd Reboot
elif [[ "${chosen}" == "${lock}" ]]; then
    loginctl lock-session
elif [[ "${chosen}" == "${suspend}" ]]; then
    run_cmd Suspend
fi