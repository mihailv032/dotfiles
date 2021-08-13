#!/bin/bash
scrot ~/.config/i3/lockscreen/lockscreen.png
convert ~/.config/i3/lockscreen/lockscreen.png -paint 3 ~/.config/i3/lockscreen/lockscreen.png 
[[ -f ~/.config/i3/lockscreen/lock.png ]] && convert ~/.config/i3/lockscreen/lockscreen.png  ~/.config/i3/lockscreen/lock.png -gravity center -composite -matte ~/.config/i3/lockscreen/lockscreen.png 

i3lock -u -e -i ~/.config/i3/lockscreen/lockscreen.png 

rm ~/.config/i3/lockscreen/lockscreen.png
