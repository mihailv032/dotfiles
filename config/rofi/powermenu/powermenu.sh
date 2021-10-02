
case "$1" in
	off) systemctl poweroff ;;
	sleep) systemctl reboot ;;
	lock) ;;
	timer) shutdown -P 100 ;;
	logout);;
	reboot) systemctl reboot ;;
	run )rofi -show drun -m -4 -theme ~/.config/rofi/powermenu/cfg -drun-categories powermenu ;;
esac
