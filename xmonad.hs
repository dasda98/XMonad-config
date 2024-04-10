-------------------------------------------------------------------------------
-- IMPORTS
-------------------------------------------------------------------------------

import XMonad
import System.IO

import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce (spawnOnce)

import XMonad.Layout.Spacing

import XMonad.Hooks.EwmhDesktops

import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
-------------------------------------------------------------------------------


-- Default applications
myTerminal = "kitty"
myLauncher = "~/.config/rofi/launchers/type-2/launcher.sh" 
myXMobar = "xmobar -x 1 ~/.config/xmonad/xmobar/xmobar.hs"

-- Settings
myModMask = mod4Mask
myBorderWidth = 2

-- Gaps around and between windows
myLayout = spacingRaw 
    True -- Only for >1 window  
    (Border 10 0 10 0) -- Sizeof screen edge gaps
    True -- Enable screen edge gaps
    (Border 0 10 0 10) -- Sizeof window gaps
    True -- Enable window gaps

-- Hooks
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "~/.fehbg"
    spawnOnce "setxkbmap pl"

main :: IO()
main = do
    xmonad
        . ewmhFullscreen
        . ewmh
        . withEasySB (statusBarProp myXMobar (pure def)) defToggleStrutsKey
        $ myConfig 

myConfig = def
    {
        terminal = myTerminal,
        modMask = myModMask,
        borderWidth = myBorderWidth,
        -- Hooks
        layoutHook = myLayout $ Tall 1 (1/300) (1/2) ||| Full,
        startupHook = myStartupHook 
    }
    `additionalKeysP`
    [ 
        ("M-p", spawn myLauncher)
    ]
