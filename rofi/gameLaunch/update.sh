#!/usr/bin/bash

#updates all the game entries and all the banners so it might take some time for the script to execute

cd $(dirname $(realpath $0))

#!!only gets the width of the widest monitor
get-display-width() {
    xrandr | grep -e " connected " \
           | grep -oP "[[:digit:]]+(?=x[[:digit:]]+)" \
           | sort -nr | head -n 1
}

HEIGHT=460 # This should match height in game-splash-menu.rasi
WIDTH=$(get-display-width)

STEAM_ROOT=$HOME/.local/share/Steam
ENTRIES=$HOME/.local/share/applications/steam

# Fetch all Steam library folders.
steam-libraries() {
    echo "$STEAM_ROOT"
    # Additional library folders are recorded in libraryfolders.vdf
    libraryfolders=$STEAM_ROOT/steamapps/libraryfolders.vdf
    if [ -e "$libraryfolders" ]; then
        awk -F\" '/^[[:space:]]*"[[:digit:]]+"/ {print $4}' "$libraryfolders"
    fi
}

####!!!Start of the main part of the program

#dir where all the entries will be stored
mkdir -p "$ENTRIES" 

for library in $(steam-libraries); do
# All installed Steam games correspond with an appmanifest_<appid>.acf file
    for manifest in "$library"/steamapps/appmanifest_*.acf; do
  	appid=$(basename "$manifest" | tr -dc "[0-9]")

	./update-game-banner.sh -a $appid -w $(get-display-width) -h $HEIGHT -b 5
#	./update-entries.sh -a $appid -m $manifest
	done
done

#2560 (main monitors width)
#./update-game-entries.sh -q

