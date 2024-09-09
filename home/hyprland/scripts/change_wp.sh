#!/usr/bin/env bash

# Define all supported image formats
supported_formats=("jpeg" "png" "gif" "pnm" "tga" "tiff" "webp" "bmp" "farbfeld" "jpg")

TMP="$(mktemp)"
filename=$(ls -1 ~/Pictures/wallpapers | grep \\.jpg | while read A ; do  echo -en "$A\x00icon\x1f~/Pictures/wallpapers/$A\n"; done | rofi -dmenu -theme ~/.config/rofi/themes/wallpaper.rasi)
# ranger ~/Pictures/wallpapers --choosefile="$TMP"

# filename="$(cat $TMP)"

if [[ -z "$filename" ]]; then
  # notify-send "Wallpaper" "Error: No file given"
  exit 1
fi

currentoutput="$(hyprctl activeworkspace| head -1 | awk '{print $NF}' | rev | cut -c 2- | rev)"

# Get the file extension (lowercase)
file_extension="${filename##*.}"
file_extension=$(tr [:upper:] [:lower:] <<< "$file_extension")

if [[ " ${supported_formats[@]} " =~ " $file_extension " ]]; then
  swww img ~/Pictures/wallpapers/$filename -o $currentoutput --transition-type fade --transition-fps 60 --transition-bezier 1,.08,.39,.79
  wal -nteq -i ~/Pictures/wallpapers/$filename
else
  notify-send "Wallpaper" "$filename seems to not be a image file."
fi

rm -f $TMP
