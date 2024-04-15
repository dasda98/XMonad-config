Config { overrideRedirect = False
       , font       = "xft:Ubuntu Nerd Font 14"
       , bgColor    = "#91233d"
       , fgColor    = "#f8f8f2"
       , position   = Static { xpos = 256, ypos = 15, width = 2048, height = 20 }
       , commands   = [ Run Weather "EPKK"
                        [ "--template", " <tempC>󰔄"
                        , "-L", "0"
                        , "-H", "25"
                        , "--low"   , "lightblue"
                        , "--normal", "#f8f8f2"
                        , "--high"  , "red"
                        ] 36000
                    , Run Cpu
                        [ "--template", " <total>%"
                        , "-L", "3"
                        , "-H", "50"
                        , "--high"  , "red"
                        , "--normal", "white"
                        ] 10
                    , Run Memory ["--template", " <usedratio>%"] 10
                    , Run Date " %a %Y-%m-%d |  <fc=#8be9fd>%H:%M</fc>" "date" 10
                    , Run Com "/home/jw/.config/xmonad/scripts/gpu_temp.sh" [] "gputemp" 10
                    , Run XMonadLog
                    ]
       , sepChar  = "%"
       , alignSep = "}{"
       , template = " %date% } %XMonadLog% { %cpu% | %memory% | %gputemp% | %EPKK% "
       }
