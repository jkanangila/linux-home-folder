#!/bin/bash

# Directory containing your wallpapers
WALLPAPER_DIR="/home/jkanangila/Pictures/Wallpapers"

# Pick a random image file (supports jpg, jpeg, png)
RANDOM_WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf -n 1)

# Check if a wallpaper was found
if [ -n "$RANDOM_WALLPAPER" ]; then
  # Unload previous wallpapers, preload the new one, and set it for eDP-1
  hyprctl hyprpaper unload all
  hyprctl hyprpaper preload "$RANDOM_WALLPAPER"
  hyprctl hyprpaper wallpaper "eDP-1, $RANDOM_WALLPAPER, cover"
  echo "Set wallpaper to: $RANDOM_WALLPAPER"
else
  echo "No wallpapers found in $WALLPAPER_DIR"
fi
