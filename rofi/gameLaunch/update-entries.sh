#!/usr/bin/env bash

# Generates .desktop entries for all installed Steam games with box art for
# the icons to be used with a specifically configured Rofi launcher

SCRIPT_DIR=$(dirname $(realpath $0))

STEAM_ROOT=$HOME/.local/share/Steam
APP_PATH=$HOME/.local/share/applications/steam

# Generate the contents of a .desktop file for a Steam game.
# Expects appid, title, and box art file to be given as arguments
desktop-entry() {
cat <<EOF
[Desktop Entry]
Name=$2
Exec=$SCRIPT_DIR/game-splash-menu.sh $1
Icon=$3
Terminal=false
Type=Application
Categories=SteamLibrary;
EOF
}

update-game-entries() {

    local OPTIND=1
    local quiet appid 

    while getopts 'a:m:q' arg
    do
        case ${arg} in
            a) appid=${OPTARG};;
	    m) manifest=${OPTARG};;
            q) quiet=1;;
            *)
                echo "Usage: $0 [-a] [-m] [-q]"
		echo "  -m manifest"
                echo "  -a appid"
                echo "  -q: Quiet; Turn off diagnostic output"
                exit
        esac
    done

    entry=$APP_PATH/${appid}.desktop
    title=$(awk -F\" '/"name"/ {print $4}' "$manifest" | tr -d "™®")
    boxart=$STEAM_ROOT/appcache/librarycache/${appid}_library_600x900.jpg	
    # Filter out non-game entries (e.g. Proton versions or soundtracks) by
    # checking for boxart and other criteria
    if [ ! -f "$boxart" ]; then
	echo "$appid"
	exit 1
    fi
    if echo "$title" | grep -qe "Soundtrack"; then
	exit 1
    fi
    # Don't update existing entries unless doing a full refresh
    if [ -z $update ] && [ -f "$entry" ]; then
        [ -z $quiet ] && echo "Not updating $entry"
        exit 1
    fi

        
    [ -z $quiet ] && echo -e "Generating $entry\t($title)"
    desktop-entry "$appid" "$title" "$boxart" > "$entry"
}

update-game-entries $@
