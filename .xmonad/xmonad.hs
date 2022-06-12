
----------------------------------------Imports------------------------------------

import XMonad
import System.Exit
import System.IO
import System.Process

import qualified XMonad.StackSet as W --
import qualified Data.Map        as M
import Data.Monoid
import Data.Maybe (fromJust)
import Data.Semigroup

import XMonad.Hooks.ManageDocks (avoidStruts, docksEventHook, manageDocks, docks )
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.DynamicProperty
import XMonad.Hooks.StatusBar --xmobar
import XMonad.Hooks.StatusBar.PP --log to xmobar
import XMonad.Hooks.EwmhDesktops --
import XMonad.Hooks.UrgencyHook --notification

import XMonad.Util.NamedScratchpad --scractchpad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.Run (safeSpawn, spawnPipe) -- runProcessWithInput
import XMonad.Util.NamedWindows --notification
import XMonad.Util.SpawnOnce --for startup
--import XMonad.Util.ClickableWorkspaces 

import XMonad.Layout.Reflect --to spawn windows on the right side 
import XMonad.Layout.Spacing --(spacingRaw,Spacing,Border,SpacingModifier,SpacingModifier,spacing) --gaps
import XMonad.Layout.Gaps
--import XMonad.Layout.LayoutBuilder
--import XMonad.Layout.Tabbed
import XMonad.Layout.Spiral
--import XMonad.Layout.MultiToggle
--import XMonad.Layout.MultiToggle.Instances
import XMonad.Layout.ToggleLayouts --toggle fullscreen
import XMonad.Layout.NoBorders (noBorders) --full screen no borders 
import XMonad.Layout.ShowWName --
--import XMonad.Layout.IndependentScreens
import qualified XMonad.Layout.Magnifier as Mag --magnifier

import XMonad.Actions.DynamicWorkspaceGroups
--import XMonad.Actions.Warp
import XMonad.Actions.UpdatePointer --for pointer to follow focus

import XMonad.Prompt

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

--toggleStrustKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)


myWorkspaces = [
                 "M-Main","P-Main","L-Main",
                 "L-Programming","M-Programming","P-Programming",
                 "L-Gayming","M-Gayming","P-Gayming",
                 "M-G5","M-G4","M-G3",
                 "Filimi",
                 "Y",
                 "Procee",
                 "P-G3","L-G3",
                 "P-G4","L-G4",
                 "P-G5","L-G5" ]


------------------------------------Key bindings--------------------------------

myKeys conf@(XConfig {XMonad.modMask = modm}) = M.fromList $
-- main keys
    [
       ((modm .|. shiftMask    ,xK_q       ), io (exitWith ExitSuccess))
      ,((modm                  ,xK_q       ), spawn "xmonad --recompile; xmonad --restart")
      ,((modm .|. mod1Mask     ,xK_l       ), spawn "xscreensaver-command -lock")--doesnt work
      ,((modm                  ,xK_w       ), kill)
    ]
    ++
-- Workspaces
    [
      ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_a, xK_s, xK_d] [2,0,1]
        , (f, m) <- [(W.view, 0), (W.shift, mod1Mask)]
    ]
    ++
    [
     ((m .|. modm, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_F4, xK_F1, xK_F2] [2,0,1]
        , (f, m) <- [(W.greedyView, 0), (W.shift, mod1Mask)]

    ]
    ++
    [
      ((m .|. modm, k), windows $ f i)
        | (i, k) <- zip myWorkspaces [xK_i,xK_o,xK_u,xK_b,xK_n,xK_m,xK_z,xK_x,xK_c,xK_F5,xK_F4,xK_F6,xK_f,xK_y,xK_p]
        , (f, m) <- [(W.greedyView, 0), (W.shift, mod1Mask)]
    ]
    ++
-- workspace groups
    [
      ((modm    ,xK_1), viewWSGroup "Main"),
      ((modm    ,xK_2), viewWSGroup "Prog"),
      ((modm    ,xK_3), viewWSGroup "Games"),
      ((modm    ,xK_F3), viewWSGroup "G3"),
      ((modm    ,xK_F2), viewWSGroup "G4"),
      ((modm    ,xK_F1), viewWSGroup "G5")
    ]
    ++
--media keys (xev to find keycodes)
    [
      ((0     , 0x1008FF11       ), spawn "pactl set-sink-volume @DEFAULT_SINK@ -1.5%"),
      ((0     , 0x1008FF13       ), spawn "pactl set-sink-volume @DEFAULT_SINK@ +1.5%"),
      ((0     , 0x1008FF12       ), spawn "amixer set Master toggle"),--mute
      ((0     , 0x1008FF17       ), spawn "~/.xmonad/scr/monitor.sh"),--audio next
      ((0     , 0x1008FF16       ), spawn "~/.xmonad/scr/sound.sh "), --audio prev
      ((0     , 0x1008FF14       ), spawn "~/.xmonad/scr/picom")      --pause/play
    ]
    ++
--focus keys
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
    ,((modm .|. shiftMask                ,xK_Tab ), setLayout $ XMonad.layoutHook conf)

    ,((mod1Mask .|. controlMask          ,xK_f), sendMessage (Toggle "Full"))

    ,((modm .|. mod1Mask                 ,xK_t ), withFocused $ windows . W.sink)

    ,((modm .|. controlMask              ,xK_bracketleft ), sendMessage Mag.MagnifyMore)
    ,((modm .|. controlMask              ,xK_p ), sendMessage Mag.MagnifyLess)
    ]
    ++
--Scratchpads
    [
      ((modm .|. mod1Mask, xK_v), namedScratchpadAction myScratchpads "terminal")
    ]
    ++
-- Launching apps
    [
      ((modm        ,xK_Return  ), spawn $ XMonad.terminal conf),
      ((modm        ,xK_4       ), spawn "chromium"),
      ((modm        ,xK_e       ), spawn "thunar"),

      ((mod1Mask    ,xK_t       ), spawn "steam"),
      ((mod1Mask    ,xK_g       ), spawn "pavucontrol"),
      ((mod1Mask    ,xK_c       ), spawn "gcolor2"),
      ((mod1Mask    ,xK_e       ), spawn "emacs"),
      ((mod1Mask    ,xK_p       ), spawn "code"),
      ((mod1Mask    ,xK_o       ), spawn "fluent-reader"),
      ((mod1Mask    ,xK_l       ), spawn "lutris"),
      ((mod1Mask    ,xK_q       ), spawn "qutebrowser"),

      ((mod1Mask    ,xK_KP_End  ), spawn "alacritty -e htop"),
      ((mod1Mask    ,xK_KP_Down ), spawn "alacritty -e mocp"),
      ((mod1Mask    ,xK_KP_Left ), spawn "alacritty -e vim ~/.xmonad/xmonad.hs"),
      ((mod1Mask    ,xK_KP_Begin), spawn "alacritty -e vim ~/.config/xmobar/xb0"),
      ((mod1Mask    ,xK_KP_Right), spawn "alacritty -e vim ~/.config/xmobar/xmobarrc"),
      
      ((mod4Mask .|. shiftMask   ,xK_F4), spawn "mocp -G"),
      ((mod4Mask .|. shiftMask   ,xK_6 ), spawn "mocp -f"),

      ((modm     .|. shiftMask   ,xK_s ), spawn "flameshot gui"),
      ((mod1Mask .|. controlMask ,xK_d ), spawn "discord"      ) 
--gdu
--deluge
--
    ]
    ++
--misc
    [
       ((modm                       ,xK_r      ), spawn"rofi -modi drun,run -show drun -m -4 -show-icons")
      ,((mod1Mask                   ,xK_Tab    ), spawn"rofi -show window -show-icons -theme ~/.config/rofi/powermenu -m -4")
      ,((controlMask                ,xK_Escape ), spawn"rofi -modi drun,run -show drun -m -4 -theme ~/.config/rofi/powermenu/games -show-icons -drun-categories powermenu")
      ,((modm .|. shiftMask         ,xK_r      ), spawn "~/.config/rofi/gameLauncher/gl-wrapper.sh run")
      ,((modm .|. mod1Mask          ,xK_r      ), refresh)

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

-------------------------Show WM Name--------------------------------

myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=50"
    , swn_fade              = 0.5
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }

--------------------------- notificatinos -----------------------------

data LibNotifyUrgencyHook = LibNotifyUrgencyHook deriving (Read, Show)

instance UrgencyHook LibNotifyUrgencyHook where
    urgencyHook LibNotifyUrgencyHook w = do
        name     <- getName w
        Just idx <- fmap (W.findTag w) $ gets windowset

        safeSpawn "notify-send" [show name, "workspace " ++ idx]

--------------------------------Layouts-----------------------------------

myLayout = reflectHoriz $ toggleLayouts monocle $ avoidStruts $ spir ||| tiled ||| magnifier ||| Mirror tiled ||| full ||| monocle
  where
     tiled     = gaps [(U,7),(R,10),(L,15),(D,5) ] $ Tall 1 (3/100) (4/7) 
     full      = noBorders Full
     monocle   = gaps [(U,30),(R,0),(L,0),(D,0) ] $ noBorders Full
     magnifier = Mag.magnifier ( Tall 1 (3/100) (1/2) )
     spir      = gaps [(U,7),(R,17),(L,10),(D,5) ] $ spiral (5/7) 
     
--------------------------------- Window rules -----------------------------

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
--	, className =? "vlc"			--> doFloat
    , resource  =? "desktop_window" --> doIgnore 
    , resource  =? "kdesktop"       --> doIgnore ]

----------------------------------- Startup hook ------------------------

myEventHook :: Event -> X All
myEventHook = dynamicPropertyChange "WM_NAME" (title =? "alacritty" --> floating)
        where floating = customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)

-------------------------------------------------------------------------

myStartupHook :: X ()
myStartupHook = do
    addRawWSGroup "Main"  [ (S 2, "L-Main"        ), (S 1,"P-Main"        ), (S 0, "M-Main"  )      ]
    addRawWSGroup "Prog"  [ (S 2, "L-Programming" ), (S 1,"P-Programming" ), (S 0,"M-Programming")  ] 
    addRawWSGroup "Games" [ (S 2, "L-Gayming"     ), (S 1,"P-Gayming"     ), (S 0,"M-Gayming")      ] 
    addRawWSGroup "G3"    [ (S 2, "L-G3"          ), (S 1,"P-G3"          ), (S 0,"M-G3")           ] 
    addRawWSGroup "G4"    [ (S 2, "L-G4"          ), (S 1,"P-G4"          ), (S 0,"M-G4")           ] 
    addRawWSGroup "G5"    [ (S 2, "L-G5"          ), (S 1,"P-G5"          ), (S 0,"M-G5")           ] 
    spawnOnce "copyq &"
    spawnOnce "dunst &"
    spawnOnce "~/.xmonad/.fehbg"
    spawnOnce "picom &"
    spawnOnce "exec /usr/bin/trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 10 --transparent true --alpha 0 --tint 0x111111 --height 22 --monitor 2 &"

-------------------------------Prompt Config-----------------------------

xpconfig = def
  { font = "xft:Source Code Pro:pixelsize=18"
    , borderColor = "#1e2320"
    , fgColor = "#dddddd"
    , fgHLight = "#ffffff"
    , bgColor = "#1e2320"
    , bgHLight = "#5f5f5f"
    , height = 36
    , position = CenteredAt 0.45 0.2
  }

--------------------------Scratchpads------------------------------------

myScratchpads = [
        NS "terminal" execTerm findTerm manageTerm
       ,NS "moc"      execMoc  findMoc manageMoc
	]
  where
  execTerm = "st" ++ " -n scratchpad" 
  findTerm	= resource =? "scratchpad"
  manageTerm = customFloating $ W.RationalRect (1/6) (1/6) (2/3) (2/3)
  execMoc = "st" ++ " -n mocp"
  findMoc	= resource =? "scratchpad"
  manageMoc = customFloating $ W.RationalRect l t w h
		where
		h = 0.5
		w = 0.5
		t = 0.0
		l = 0.25

-------------------------------------- Main -------------------------------

main :: IO ()
main = do
  xmproc1 <- spawnPipe "xmobar -x 1 $HOME/.config/xmobar/xb3"
  xmproc2 <- spawnPipe "xmobar -x 2 $HOME/.config/xmobar/xmobarrc"
  xmproc0 <- spawnPipe "xmobar -x 0 $HOME/.config/xmobar/xb0"
  xmonad $ docks $ ewmhFullscreen . ewmh $ withUrgencyHook LibNotifyUrgencyHook $ ewmh def {
        terminal           = "alacritty -t Terminal -e fish",
        focusFollowsMouse  = False, -- Whether focus follows the mouse pointer.
        clickJustFocuses   = False,-- Whether clicking on a window to focus also passes the click to the window
        borderWidth        = 0,
        modMask            = mod4Mask,
        workspaces         = myWorkspaces,
        normalBorderColor  = "#dddddd",
        focusedBorderColor = "#960a00",

      --key bindings
        keys               = myKeys,
        mouseBindings      = myMouseBindings,

        --hooks, layouts
        layoutHook         = showWName' myShowWNameTheme $ spacingRaw True (Border 0 0 0 0) True (Border 5 5 5 5) True $ myLayout,
        manageHook         = manageDocks <+> myManageHook,
        handleEventHook    = myEventHook,
        startupHook        = myStartupHook,
        logHook            = dynamicLogWithPP xmobarPP 
                          { 
                              ppOutput = \x -> hPutStrLn xmproc0 x -- xmobar on monitor 1
                                            >> hPutStrLn xmproc1 x -- xmobar on monitor 2
                                            >> hPutStrLn xmproc2 x -- xmobar on monitor 3
                            , ppCurrent = xmobarColor "#c792ea" "" . wrap "<box type=Bottom width=2 mt=2 color=#c792ea>[ " " ]</box>" -- Current workspace
                            , ppVisible = xmobarColor "#c792ea" "" . wrap "[ " " ]" . clickable              -- Visible but not current workspace
                            , ppHidden = xmobarColor "#82AAFF" "" . clickable -- Hidden workspaces
--              , ppHiddenNoWindows = xmobarColor "#82AAFF" ""  . clickable     -- Hidden workspaces (no windows)
                            , ppTitle = xmobarColor "#b3afc2" "" . shorten 60               -- Title of active window
                            , ppSep =  "<fc=#666666> <fn=1>|</fn> </fc>"                    -- Separator character
                            , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"            -- Urgent workspace
                            , ppExtras  = [windowCount]                                     -- # of windows current workspace
                            , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]                    -- order of things in xmobar
                           } >> updatePointer(0.25,0.25) (0.25,0.25)

    }

