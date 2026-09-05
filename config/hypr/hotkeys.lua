


---------------------------------------------------------

-- - - - - - - - - - - - SYSTEM - - - - - - - - - - - - -

---------------------------------------------------------

hl.bind(mainMod .. " + W", hl.dsp.window.close())
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-------------------------------------------------------

-- - - - - - - - - - - - APPS - - - - - - - - - - - - -

-------------------------------------------------------
     
hl.bind(mainMod .. " + 4",         hl.dsp.exec_cmd("firefox"))
hl.bind("ALT + E",                 hl.dsp.exec_cmd("emacs"))
hl.bind("ALT + T",                 hl.dsp.exec_cmd("steam"))
hl.bind("ALT + G",                 hl.dsp.exec_cmd("pavucontrol"))
hl.bind("ALT + C",                 hl.dsp.exec_cmd("hyprpicker -a"))
hl.bind("ALT + Q",                 hl.dsp.exec_cmd("qutebrowser"))
hl.bind("CTRL + ALT + D",          hl.dsp.exec_cmd("discord"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp -d)" - | wl-copy'))
hl.bind("SUPER + Print",           hl.dsp.exec_cmd('grim -g "$(slurp -d -o)" - | wl-copy'))
hl.bind(mainMod .. " + E",         hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd("alacritty -t yazi -e yazi"))
hl.bind(mainMod .. " + R",         hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + RETURN",    hl.dsp.exec_cmd(terminal))

-------------------------------------------------------

-- - - - - - - - - - - - MOVEMENT - - - - - - - - - - -

-------------------------------------------------------

-- Windows
hl.bind(mainMod .. " + H",       hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L",       hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + J",       hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K",       hl.dsp.focus({ direction = "up" }))

hl.bind(mainMod .. " + ALT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + ALT + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + ALT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + ALT + K", hl.dsp.window.move({ direction = "up" }))

-- Monitors
hl.bind(mainMod .. " + A",       hl.dsp.focus({monitor=leftMonitor}))
hl.bind(mainMod .. " + S",       hl.dsp.focus({monitor=middleMonitor})) --monitor variables are defined in monitors.lua
hl.bind(mainMod .. " + D",       hl.dsp.focus({monitor=rightMonitor}))

hl.bind(mainMod .. " + ALT + A", hl.dsp.window.move({monitor=leftMonitor,follow=false}))
hl.bind(mainMod .. " + ALT + S", hl.dsp.window.move({monitor=middleMonitor,follow=false})) --monitor variables are defined in monitors.lua
hl.bind(mainMod .. " + ALT + D", hl.dsp.window.move({monitor=rightMonitor,follow=false}))

-- Wokspaces
local workspaces = {"U","Z","B","I","X","N","O","C","M","Y","F"}
local monitors   = {leftMonitor,middleMonitor,rightMonitor}

for i,w in pairs(workspaces) do
    hl.bind(mainMod .. " + " .. w,           hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + ALT + " .. w,     hl.dsp.window.move({ workspace = i, follow=false }))
    hl.workspace_rule({ workspace = i, monitor =monitors[math.floor((i-1)/3)+1] })
end


-- Scratchpad
hl.bind(mainMod .. " + P",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + ALT + P",   hl.dsp.window.move({ workspace = "special:magic", follow=false}))


-------------------------------------------------------

-- - - - - - - - - - Layout - - - - - - - - - - - - - -

-------------------------------------------------------

--hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + TAB", hl.dsp.layout("togglesplit"))    -- dwindle only
hl.bind("CTRL + ALT + F ",   hl.dsp.window.fullscreen({ action = "toggle" }))
hl.bind(mainMod .. " + V",   hl.dsp.window.float({ action = "toggle" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-------------------------------------------------------

-- - - - - - - - - - Media Keys - - - - - - - - - - - -

-------------------------------------------------------
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pamixer -i 5"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pamixer -d 5"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pamixer -t"),   { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("~/.config/de-scripts/sound.sh"),   { locked = true })

