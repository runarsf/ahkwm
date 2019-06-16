﻿^space::
if (WinExist("ahk_id " GuiDvorak_ID)) {
	DvorakExit:
	GuiDvorak_ID := ""
	Gui, Dvorak:Destroy
	return
}

Gui, Dvorak:+AlwaysOnTop +ToolWindow +LastFound -Caption ; +E0x20 click through
GuiDvorak_ID := WinExist() ;store the ID of the lastfound window
Gui, Dvorak:Color, 494444, 434852
WinSet, Transparent, 240
Gui, Dvorak:Font, s10 cWhite,
Gui, Dvorak:Add, Picture, x0 y0, %A_ScriptDir%\src\dvorak\dvorak.png
Gui, Dvorak:Add, Picture, vDvorakHands x0 y0, %A_ScriptDir%\src\dvorak\dvorak_hands.png
Gui, Dvorak:Show,, dvorak layout
GuiControl, Hide, DvorakHands
Gui, Dvorak:Add, Button, Default gDvorakSwitch, OK
GuiControl, Hide, OK
return

DvorakSwitch:
if Toggle
	GuiControl, Show, DvorakHands
else
	GuiControl, Hide, DvorakHands
Toggle:=!Toggle
return


; Use Scroll Lock to swap keyboard layouts
; and do not let Control, Alt, or Win modifiers act on Dvorak
/*
Loop {
	If GetKeyState("ScrollLock", "T")
   and !GetKeyState("Control")
   and !GetKeyState("Alt")
   and !GetKeyState("LWin")
   and !GetKeyState("RWin") {
		Suspend, Off
	} else {
		Suspend, On
	}
	Sleep, 50
}

; QWERTY to Dvorak mapping
-::[
=::]

q::'
w::,
e::.
r::p
t::y
y::f
u::g
i::c
o::r
p::l
[::/
]::=

;a::a
s::o
d::e
f::u
g::i
h::d
j::h
k::t
l::n
`;::s
'::-

z::`;
x::q
c::j
v::k
b::x
n::b
;m::m
,::w
.::v
/::z
*/