IniRead, SavedVolume, config.ini, Settings, SavedVolume

INCR := 20
GI1 := 10
GI2 := GI1+INCR
GI3 := GI2+INCR
GI4 := GI3+INCR
GI5 := GI4+INCR
GI6 := GI5+INCR
GI7 := GI6+INCR
GI8 := GI7+INCR
GI9 := GI8+INCR

Gui, Font, s9,
Gui, Add, Text, c%fgcolor% x%GI1% y0 gApp1, [1]
Gui, Add, Text, c%fgcolor% x%GI2% y0 gApp2, [2]
Gui, Add, Text, c%fgcolor% x%GI3% y0 gApp3, [3]
Gui, Add, Text, c%fgcolor% x%GI4% y0 gApp4, [4]
Gui, Add, Text, c%fgcolor% x%GI5% y0 gApp5, [5]
Gui, Add, Text, c%fgcolor% x%GI6% y0 gApp6, [6]
Gui, Add, Text, c%fgcolor% x%GI7% y0 gApp7, [7]
Gui, Add, Text, c%fgcolor% x%GI8% y0 gApp8, [8]
Gui, Add, Text, c%fgcolor% x%GI9% y0 gApp9, [9]

Gui, Add, Text, c%fgcolor% x1740 y0 gMediaPause, | | ; FIX x1740
Gui, Font, s12,
Gui, Add, Text, c%fgcolor% x1750 y-3 gMediaNext, > ; FIX x1750
Gui, Add, Text, c%fgcolor% x1727 y-3 gMediaPrev, < ; FIX x1727
Gui, Font, s9,
Gui, Add, Slider, vMySlider gmodsnd x1770 y-2, %SavedVolume%  ; FIX x1770
return



App1:
App2:
App3:
App4:
App5:
App6:
App7:
App8:
App9:
return

modsnd:
Gui, Submit, Nohide
SoundSet, MySlider
IniWrite, %MySlider%, config.ini, Settings, SavedVolume
return

MediaPause:
send, {Media_Play_Pause}
return
MediaNext:
send, {Media_Next}
return
MediaPrev:
send, {Media_Prev}
return