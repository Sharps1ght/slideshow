#!/usr/bin/env bash

# IF YOU SEE SOME RANDOM ECHOS, JUST KNOW I USED IT FOR DEBUGGING
# FEEL FREE TO REMOVE THEM ALL OF YOU WISH AS WELL AS OTHER COMMENTS
# IF YOU WANT TO CHANGE ANYTHING, YOU MIGHT FIND THEM HELPFUL

# Directory where wallpapers are pulled from (must be set manually)
wallpaperDir="$HOME/Pictures/Wallpapers/"
# Check which wallpapers are currently in use
monitors=$(hyprctl monitors | grep Monitor | awk '{print $2}')
# Amount of seconds that need to pass for wallpaper to be changed on ONE monitor (also set manually)
# Multiply by amount of monitors you have to find out how much time will pass before  a wallpaper will be swapped on THE monitor
timer=30

# Killing any existing swaybg processes for no overlaps and memory saving
pkill swaybg
# Initial wallpapers setup
for display in $monitors; do
	wallpaper=$(find "$wallpaperDir" -type f | shuf -n 1)
	hyprctl dispatch exec "swaybg -o $display -m fill -i $wallpaper"
done
sleep $timer
# Infinite wallpapers loop
while true; do
  # Loop through each display/monitor
	for display in $monitors; do
  # Select a picture
	wallpaper=$(find "$wallpaperDir" -type f ! -name $(basename $(ps -C swaybg -o args= | grep $display | awk '{print $7}')) | shuf -n 1)
	# Spawn a process
  hyprctl dispatch exec "swaybg -o $display -m fill -i $wallpaper"
	# I am bad, so it first spawns a new process first
  # Then it kill the old one to have seamless-ish transition
  # I know this is NOT the way, but it works
  sleep $(( $timer - ($timer - 1) ))
	ps -eo pid,cmd | grep swaybg | grep $display | sort -n | head -n1 | awk '{print $1}' | xargs -r kill
	sleep $timer
	done
done
