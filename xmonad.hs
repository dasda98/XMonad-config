-------------------------------------------------------------------------------
-- Imports
-------------------------------------------------------------------------------

import XMonad
import System.IO

import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Util.Loggers

import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.NoBorders (smartBorders)

import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
-------------------------------------------------------------------------------
-- Default applications
-------------------------------------------------------------------------------
myTerminal      = "kitty"
myLauncher      = "~/.config/rofi/launchers/type-2/launcher.sh" 
myXMobar        = "xmobar -x 1 ~/.config/xmonad/xmobar/xmobar.hs"
myScreenLock    = "xscreensaver-command -lock"
myScreenshot    = "scrot -s ~/Pictures/%Y-%m-%d_%T.png"
-------------------------------------------------------------------------------
-- Settings
-------------------------------------------------------------------------------
myModMask               = mod4Mask
myBorderWidth           = 1
myFocusedBorderColor    = "#035096"
-------------------------------------------------------------------------------
-- Workspaces
-------------------------------------------------------------------------------
--myWorkspaces = ["", " ", " ", " ", " ", " "] ++ map show [6..9]
myWorkspaces = ["\59285", "\62056", "\61729", "\984922", "\61878", "\61951"]
-------------------------------------------------------------------------------
-- Gaps around and between windows
-------------------------------------------------------------------------------
mySpacing = spacingRaw 
    True -- Only for >1 window  
    (Border 10 0 10 0) -- Sizeof screen edge gaps
    True -- Enable screen edge gaps
    (Border 0 10 0 10) -- Sizeof window gaps
    True -- Enable window gaps
-------------------------------------------------------------------------------
-- Hooks
-------------------------------------------------------------------------------
-------- Layouts
myLayoutHook = layoutTall ||| layoutSpiral ||| layoutFull
    where
        layoutTall      = Tall 1 (3/100) (1/2)
        layoutSpiral    = spiral (6/7)
        layoutFull      = Full

-------- Startups
myStartupHook :: X ()
myStartupHook = do
    spawnOnce "~/.fehbg"
    spawnOnce "~/.config/xmonad/scripts/keyboard_layout.sh"
    spawnOnce "picom"
    spawnOnce "xscreensaver --no-splash"

-------- Manages
myManageHook :: ManageHook
myManageHook = composeAll
    [
          className =?  "steam"     --> doFloat >> doShift (myWorkspaces !! 4)
        , className =?  "discord"   --> doShift (myWorkspaces !! 5)
        , className =?  "chromium"  --> doShift (myWorkspaces !! 1)
        , isFullscreen              --> doFullFloat
        , isDialog                  --> doCenterFloat
    ]

-------------------------------------------------------------------------------
-- XMobar
-------------------------------------------------------------------------------
myXmobarPP :: PP
myXmobarPP = def
    { ppSep                 = magenta " • "
    , ppTitleSanitize       = xmobarStrip
    , ppCurrent             = wrap " " "" . xmobarBorder "Bottom" "#8be9fd" 2
    , ppVisible             = wrap " " "" . xmobarBorder "Bottom" "#fadc0c" 2
    , ppHidden              = white . wrap " " ""
    , ppHiddenNoWindows     = lowWhite . wrap " " ""
    , ppUrgent              = red . wrap (yellow "!") (yellow "!")
    , ppOrder               = \[ws, _, _, _] -> [ws]
    , ppExtras              = [logTitles formatFocused formatUnfocused]
    }
  where
    formatFocused   = wrap (white    "") (white    "") . magenta . ppWindow
    formatUnfocused = wrap (lowWhite "") (lowWhite "") . blue    . ppWindow

    -- | Windows should have *some* title, which should not not exceed a
    -- sane length.
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff79c6" ""
    blue     = xmobarColor "#bd93f9" ""
    white    = xmobarColor "#f8f8f2" ""
    yellow   = xmobarColor "#f1fa8c" ""
    red      = xmobarColor "#ff5555" ""
    lowWhite = xmobarColor "#bbbbbb" ""
-------------------------------------------------------------------------------
-- Main
-------------------------------------------------------------------------------
main :: IO()
main = do
    xmonad
        . ewmhFullscreen
        . ewmh
        . withEasySB (statusBarProp myXMobar (pure myXmobarPP)) defToggleStrutsKey
        $ myConfig 
-------------------------------------------------------------------------------
-- Setup
-------------------------------------------------------------------------------
myConfig = def
    {
        terminal            = myTerminal,
        modMask             = myModMask,
        borderWidth         = myBorderWidth,
        focusedBorderColor  = myFocusedBorderColor,
        workspaces          = myWorkspaces,
        -- Hooks
        startupHook         = myStartupHook,
        manageHook          = myManageHook,
        layoutHook          = avoidStruts . mySpacing $ smartBorders myLayoutHook
    }
    `additionalKeysP`
    [ 
        ("M-p",         spawn myLauncher),
        ("M-S-z",       spawn myScreenLock),
        ("M-S-s",       unGrab *> spawn myScreenshot)
    ]
-------------------------------------------------------------------------------
