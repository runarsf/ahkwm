#EscapeChar `

!CapsLock::
GetKeyState, capsstate, CapsLock, T
if capsstate = U
	SetCapsLockState AlwaysOn
else
	SetCapsLockState AlwaysOff
return

CapsLock & r::MouseClick,WheelUp,,,10,0,D,R
CapsLock & f::MouseClick,WheelDown,,,10,0,D,R
CapsLock & t::PgUp
CapsLock & g::PgDn
CapsLock & q::MouseClick, left ; when you press q, mouse will left click
CapsLock & e::MouseClick, right ; when you press e, mouse will right click
CapsLock & w::MouseMove, 0, -55, 5, R ; when you press w, mouse will move up 25 pixels
CapsLock & s::MouseMove, 0, 55, 5, R ; when you press s, mouse will move down 25 pixels
CapsLock & a::MouseMove, -55, 0, 5, R ; when you press a, mouse will move left 25 pixels
CapsLock & d::MouseMove, 55, 0, 5, R ; when you press d, mouse will move right 25 pixels

CapsLock & v::block("autohotkey")

block(lang) {
	oclip := %Clipboard%
	Clipboard := "```````"
	send, %Clipboard%
	send, %lang%
	send, {Enter}
	Clipboard := oclip
	send, %Clipboard%
	Clipboard := "```````"
	send, %Clipboard%{Space}
	Clipboard := oclip
	send, {Enter}
}