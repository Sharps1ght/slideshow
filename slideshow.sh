#!/usr/bin/env bash

# IF YOU SEE SOME RANDOM ECHOS, JUST KNOW I USED IT FOR DEBUGGING
# FEEL FREE TO REMOVE THEM ALL OF YOU WISH AS WELL AS OTHER COMMENTS
# IF YOU WANT TO CHANGE ANYTHING, YOU MIGHT FIND THEM HELPFUL

# Directory where wallpapers are pulled from (must be set manually)
wallpaperDir="$HOME/.config/hypr/Wallpapers/"
# Check which wallpapers are currently in use
currentWall=$(hyprctl hyprpaper listactive)
# List all monitors connected
monitors=$(hyprctl monitors | grep Monitor | awk '{print $2}')
# Amount of seconds that need to pass for wallpaper to be changed on ONE monitor (also set manually)
# Multiply by amount of monitors you have to find out how much time will pass before  a wallpaper will be swapped on THE monitor
timer=10

# Start an infinite loop
while true; do
	# Go through all of the connected monitors
	for display in $monitors; do
		# Call out the selected monitor
		# echo "Changing $display..."
  		# Call out currently active wallpaper on selected monitor
    	# echo "$(hyprctl hyprpaper listactive | grep $display | basename $(awk '{print $3}')) is on $display"
		# Pick a random wallpaper from directory (not fool-proof, theoretically can select ANY file)
		wallpaper=$(find "$wallpaperDir" -type f ! -name "$(basename "$(hyprctl hyprpaper listactive | grep $display)")" | shuf -n 1)
		# Call out the selected wallpaper
		# echo "Picked $(basename $wallpaper)"
		# Apply selected wallpaper to selected monitor
		hyprctl hyprpaper reload "$display","$wallpaper"
		# Result
		# echo "$display is set to $(basename $wallpaper)"
		# Timer
		sleep $timer
	done
	# Dunno why but unload all of the wallpapers
	# It won't remove any currently active wallpapers from the monitors
	hyprctl hyprpaper unload all
done
