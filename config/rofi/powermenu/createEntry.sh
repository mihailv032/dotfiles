currentdir=$(dirname $(realpath $0))
entrypath=$HOME/.local/share/applications/powermenu

mkdir -p $HOME/.local/share/applications/powermenu

entry() {
cat <<EOF 
[Desktop Entry]
Name=$1
Exec=$2
Icon=$currentdir/$1.jpg
Terminal=false
Type=Application
Categories=powermenu;
EOF
}

entry Poweroff "systemctl poweroff" > $entrypath/poweroff.desktop
entry Reboot "systemctl reboot" > $entrypath/reboot.desktop
entry Sleep "systemctl suspend" > $entrypath/sleep.desktop
entry Logout > $entrypath/logout.desktop
entry Timer "shutdown -P 100" > $entrypath/timer.desktop
entry Lock > $entrypath/lock.desktop

