#!/usr/bin/env bash

cd $(dirname $(realpath $0))

case "$1" in
	update) ./update.sh ;;
    run) rofi -show drun -theme games -drun-categories SteamLibrary \
                   -cache-dir ~/.cache/rofi-game-launcher

              # Emulate most recently used history by resetting the count
              # to 0 for each application
              sed -i -e 's/^1/0/' ~/.cache/rofi-game-launcher/rofi3.druncache
        ;;
    *)      echo "Usage: $0 {update,run}"
esac
