
----------------------------------------Imports------------------------------------

import XMonad
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M
import Data.Monoid

--import XMonad.Hooks.ManageDocks --to show the workspaceo on xmobar
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.EwmhDesktops

import XMonad.Util.NamedScratchpad
--import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Run
import XMonad.Util.SpawnOnce --for startup
--import XMonad.Util.ClickableWorkspaces 

import XMonad.Layout.Reflect --to spawn windows on the right side 
import XMonad.Layout.Spacing --gaps
--import XMonad.Layout.MultiToggle
--import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.ToggleLayouts --toggle fullscreen
import XMonad.Layout.NoBorders -- ???
import qualified XMonad.Layout.Magnifier as Mag


-- toggleStrustKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)
myPP = xmobarPP { ppCurrent = xmobarColor "#429942" "" . wrap "|" "|" }
--mybar = "xmobar ~/.config/xmobar/xb1"

main = do
  hdmi <- spawnPipe "xmobar -x 1 ~/.config/xmobar/xb3"
  dvi <- spawnPipe "xmobar -x 2 ~/.config/xmobar/xb3"
  (xmonad (ewmhFullscreen (ewmh (xmobarProp (cfg)))))

cfg = def {
        terminal           = "alacritty",
        focusFollowsMouse  = False, -- Whether focus follows the mouse pointer.
        clickJustFocuses   = False,-- Whether clicking on a window to focus also passes the click to the window
        borderWidth        = 2,
        modMask            = mod4Mask,
        --workspaces eg = ["web", "irc", "code" ] ++ map show [4..9]
        workspaces         = myWorkspaces,
        normalBorderColor  = "#dddddd",
        focusedBorderColor = "#960a00",

      -- key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

        --hooks, layouts
        layoutHook         = spacingRaw True (Border 3 3 5 10) True (Border 3 3 5 5) True $ reflectHoriz $ myLayout,
        manageHook         = myManageHook <+> namedScratchpadManageHook myScratchpads,
        handleEventHook    = myEventHook,
        logHook            = myLogHook,
        startupHook        = myStartupHook}

myWorkspaces    = ["Main","Ftoroi","Tretii","T2","M2","F2","6","8","9"]

------------------------------------Key bindings--------------------------------

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
-- main keys
    [
     ((modm .|. shiftMask    ,xK_q       ), io (exitWith ExitSuccess))
    ,((modm                  ,xK_q       ), spawn "xmonad --recompile; xmonad --restart")
    ,((modm .|. mod1Mask     ,xK_l       ), spawn "xscreensaver-command -lock")--doesnt work

    ,((modm .|. controlMask  ,xK_1       ), spawn "xrandr --output HDMI-0 --off --output DVI-D-0 --off")
    ,((modm .|. controlMask  ,xK_2       ), spawn "xrandr --output DVI-D-0 --mode 1920x1080 --pos 4497x180 --rotate normal --output HDMI-0 --mode 1920x1080 --pos 0x246 --rotate normal --output DP-0 --primary --mode 2560x1440 --pos 1937x0 --rotate normal")

    ,((modm .|. controlMask  ,xK_KP_Up ), spawn "pacmd set-default-sink alsa_output.pci-0000_00_1f.3.analog-stereo ")
    ,((modm .|. controlMask  ,xK_KP_Home   ), spawn "pacmd set-default-sink alsa_output.usb-Kingston_HyperX_Virtual_Surround_Sound_00000000-00.analog-stereo")
    ]
    ++
-- focus keys
    [
      ((modm                             ,xK_j     ), windows W.focusUp),
      ((modm                             ,xK_k     ), windows W.focusDown  ),

      ((modm                             ,xK_l     ), windows W.focusMaster  ),
      ((modm .|. mod1Mask                ,xK_l     ), windows W.swapMaster),

      ((modm .|. mod1Mask                ,xK_j     ), windows W.swapUp  ),
      ((modm .|. mod1Mask                ,xK_k     ), windows W.swapDown)
    ]
    ++
--Layouts
    [
     ((modm                              ,xK_Tab ), sendMessage NextLayout)

    ,((mod1Mask .|. controlMask          ,xK_f), sendMessage (Toggle "Full"))

    ,((modm .|. shiftMask                ,xK_Tab ), setLayout $ XMonad.layoutHook conf)
    ,((modm .|. mod1Mask                 ,xK_t ), withFocused $ windows . W.sink)

    ,((modm .|. controlMask              ,xK_bracketleft ), sendMessage Mag.MagnifyMore)
    ,((modm .|. controlMask              ,xK_p ), sendMessage Mag.MagnifyLess)
    ]
    ++
-- Workspaces
    [
    --mod-shift move window to workspace N
      ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip myWorkspaces [xK_i,xK_o,xK_u,xK_p,xK_f,xK_n,xK_m]
        , (f, m) <- [(W.view, 0), (W.shift, mod1Mask)]
    ]
    ++
    [
      ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_s, xK_d, xK_a] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, mod1Mask)]
    ]
    ++
-- Launching apps
    [
      ((modm        ,xK_Return  ), spawn $ XMonad.terminal conf),
      ((modm        ,xK_t       ), spawn "steam"),
      ((modm        ,xK_4       ), spawn "chromium"),
      ((modm        ,xK_e       ), spawn "thunar"),
      ((modm        ,xK_g       ), spawn "pavucontrol"),
      ((modm        ,xK_c       ), spawn "gcolor2"),

      ((mod1Mask    ,xK_e       ), spawn "emacs"),
      ((mod1Mask    ,xK_p       ), spawn "code"),
      ((mod1Mask    ,xK_o       ), spawn "fluent-reader"),
      ((mod1Mask    ,xK_l       ), spawn "lutris"),
	  ((mod1Mask	,xK_q		), spawn "qutebrowser"),

      ((mod1Mask    ,xK_KP_End  ), spawn "alacritty -e htop"),
      ((mod1Mask    ,xK_KP_Down ), spawn "alacritty -e mocp"),
      ((mod1Mask    ,xK_KP_Left ), spawn "alacritty -e vim ~/.xmonad/xmonad.hs"),
      ((mod1Mask    ,xK_KP_Begin), spawn "alacritty -e vim ~/.config/xmobar/xb1"),
      ((mod1Mask    ,xK_KP_Right), spawn "alacritty -e vim ~/.config/picom/picom.conf"),

      ((modm .|. shiftMask, xK_s), spawn "flameshot gui"),
      ((mod1Mask .|. controlMask, xK_d), spawn "discord") 
    ]
    ++
--Scratchpads
    [
      ((modm .|. mod1Mask, xK_x), namedScratchpadAction myScratchpads "terminal")
    ]
    ++
--misc
    [
      ((modm                       ,xK_w      ), kill)
    --rofi
     ,((modm                       ,xK_r      ), spawn"rofi -modi drun,run -show drun -m -4 -show-icons")
     ,((controlMask .|. shiftMask  ,xK_Escape ), spawn"rofi -modi drun,run -show drun -m -4 -show-icons -drun-categories powermenu")
     ,((modm .|. shiftMask         ,xK_r      ), spawn "~/.config/rofi/gameLauncher/gl-wrapper.sh run")

    -- Resize viewed windows to the correct size
--     ,((modm,               xK_n     ), refresh)

     ,((modm .|. shiftMask,    xK_h     ), sendMessage Expand)
     ,((modm .|. shiftMask,    xK_l     ), sendMessage Shrink)

    -- Increment/decrement the number of windows in the master area
    , ((modm              , xK_comma ), sendMessage (IncMasterN 1))
    , ((modm              , xK_period), sendMessage (IncMasterN (-1)))

    -- Toggle the status bar gap
    -- Use this binding with avoidStruts from Hooks.ManageDocks.
    -- See also the statusBar function from Hooks.DynamicLog.
    -- , ((modm              , xK_b     ), sendMessage ToggleStruts)
    ]

------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modm}) = M.fromList $
    -- mod-button1, Set the window to floating mode and move by dragging
    [ 
	  ((modm, button1), (\w -> focus w >> mouseMoveWindow w
                                       >> windows W.shiftMaster))

    -- mod-button2, Raise the window to the top of the stack
    , ((modm, button2), (\w -> focus w >> windows W.shiftMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modm, button3), (\w -> focus w >> mouseResizeWindow w
                                       >> windows W.shiftMaster))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]
--------------------------------Layouts-----------------------------------


myLayout = toggleLayouts Full (tiled ||| Mag.magnifier (Tall 1 (3/100) (1/2)) ||| Mirror tiled ||| Full )
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = Tall nmaster delta ratio

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 4/7

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

---------------------------------Window rules-----------------------------

-- To find the property name associated with a program, use
-- > xprop | grep WM_CLASS
myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
--	, className =? "vlc"			--> doFloat
    , resource  =? "desktop_window" --> doIgnore 
    , resource  =? "kdesktop"       --> doIgnore ]

--------------------------------------------------------------------------
-- Event handling

-- * EwmhDesktops users should change this to ewmhDesktopsEventHook
--
-- Defines a custom handler function for X Events. The function should
-- return (All True) if the default handler is to be run afterwards. To
-- combine event hooks use mappend or mconcat from Data.Monoid.
--
myEventHook = mempty

------------------------------------------------------------------------
-- Status bars and logging

-- Perform an arbitrary action on each internal state change or X event.
-- See the 'XMonad.Hooks.DynamicLog' extension for examples.
--
myLogHook = return ()

------------------------------------------------------------------------
-- Startup hook

myStartupHook = do
	spawnOnce "nitrogen --restore &"
	spawnOnce "picom &"

------------------------------------------------------------------------

myScratchpads = [
		NS "terminal" execTerm findTerm manageTerm
	   ,NS "pavu"	  execPavu findPavu managePavu
	   ,NS "moc"	  execMoc  findMoc manageMoc
	]
  where
  execTerm = "st" ++ " -n scratchpad" 
  findTerm	= resource =? "scratchpad"
  manageTerm = customFloating $ W.RationalRect l t w h
		where
		h = 0.5
		w = 0.5
		t = 0.0
		l = 0.25
  execPavu = "pavucontrol"
  findPavu	= resource =? "scratchpad"
  managePavu = customFloating $ W.RationalRect l t w h
		where
		h = 0.5
		w = 0.5
		t = 0.0
		l = 0.25
  execMoc = "st" ++ " -n mocp"
  findMoc	= resource =? "scratchpad"
  manageMoc = customFloating $ W.RationalRect l t w h
		where
		h = 0.5
		w = 0.5
		t = 0.0
		l = 0.25

------------------------------------------------------------------------

-- | Finally, a copy of the default bindings in simple textual tabular format.
help :: String
help = unlines ["The default modifier key is 'alt'. Default keybindings:",

   "-- Mouse bindings: default actions bound to mouse events",
    "mod-button1  Set the window to floating mode and move by dragging",
    "mod-button2  Raise the window to the top of the stack",
    "mod-button3  Set the window to floating mode and resize by dragging"]
