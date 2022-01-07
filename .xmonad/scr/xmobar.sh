x="`pgrep xmobar`"
if [ ${#x} >7 ]; then
	read -a txt <<< $x
	kill ${txt[0]}
	x="`pgrep xmobar`"
	read -a txt <<< $x
	kill ${txt[0]}
fi

