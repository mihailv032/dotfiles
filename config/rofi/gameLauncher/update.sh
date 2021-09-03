#!/usr/bin/bash

#updates all the game entries and all the banners so it might take some time for the script to execute

cd $(dirname $(realpath $0))

scriptDir=$(dirname $(realpath $0))

STEAM_ROOT=$HOME/.local/share/Steam
ENTRIES=$HOME/.local/share/applications/steam
BANNER=./iconBanner/

# Fetch all Steam library folders.
steam-libraries() {
    echo "$STEAM_ROOT"
    # Additional library folders are recorded in libraryfolders.vdf
    libraryfolders=$STEAM_ROOT/steamapps/libraryfolders.vdf
    if [ -e "$libraryfolders" ]; then
        awk -F\" '/^[[:space:]]*"[[:digit:]]+"/ {print $4}' "$libraryfolders"
    fi
}

#create en etnry for update
updEntry() {
cat <<EOF
[Desktop Entry]
Name=Update
Exec=$scriptDir/gl-wrapper.sh update
Icon=$scriptDir/update.jpg
Terminal=false
Type=Application
Categories=SteamLibrary;
EOF
}

#creates an entry for steam account switch
changeAC() {
cat <<EOF
[Desktop Entry]
Name=Steam
Exec=$scriptDir/ac.sh
Icon=$scriptDir/steam.jpg
Terminal=false
Type=Application
Categories=SteamLibrary;
EOF
}

#gets the width only of the widest monitor
get-display-width() {
    xrandr | grep -e " connected " \
           | grep -oP "[[:digit:]]+(?=x[[:digit:]]+)" \
           | sort -nr | head -n 1
}
WIDTH="$(get-display-width)"
HEIGHT=460 # This should match height in game-splash-menu.sh the rasiFile funciton description

####Start of the main part of the program

#dir where all the entries will be stored
mkdir -p "$ENTRIES" 
mkdir -p "$BANNER"

for library in $(steam-libraries); do
# All installed Steam games correspond with an appmanifest_<appid>.acf file
    for manifest in "$library"/steamapps/appmanifest_*.acf; do
  		appid=$(basename "$manifest" | tr -dc "[0-9]")

		./update-banner.sh -w $WIDTH -h $HEIGHT -a $appid -f
		./update-entries.sh -a $appid -m $manifest 
	done
done
updEntry > $HOME/.local/share/applications/steam/update.desktop
changeAC > $HOME/.local/share/applications/steam/steam.desktop
