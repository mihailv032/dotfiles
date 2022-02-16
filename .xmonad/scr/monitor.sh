x="`xrandr --listmonitors`"

if [ "`echo "$x" | grep Monitor`" == 'Monitors: 3' ]; then
	xrandr --output HDMI-0 --off --output DVI-D-0 --off
	killall trayer
	exec /usr/bin/trayer --edge top --align left --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 0 --tint 0x111111 --height 22 --monitor 2 &

	x="`pgrep xmobar`"
	if [ ${#x} >7 ]; then
		read -a txt <<< $x
		kill ${txt[0]}
		x="`pgrep xmobar`"
		read -a txt <<< $x
		kill ${txt[0]}
	fi

	feh --bg-fill --randomize ~/Pictures/Anime;
else 
	killall trayer
	xrandr --output DVI-D-0 --mode 1920x1080 --pos 4497x180 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 0x246 --rotate normal --output DP-0 --primary --mode 2560x1440 --pos 1937x0 --rotate normal
	exec /usr/bin/trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 0 --tint 0x111111 --height 22 --monitor 2 &
	feh --bg-fill --randomize ~/Pictures/Anime;
fi
