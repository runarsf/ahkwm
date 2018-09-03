#SingleInstance Force
#Persistent
DetectHiddenWindows, On
SetTitleMatchMode 2
SetWorkingDir %A_ScriptDir%
#EscapeChar ¤

IniRead, wmOnTop, config.ini, Settings, wmOnTop,
IniRead, wmMaxiMin, config.ini, Settings, wmMaxiMin,
IniRead, wmWinMove, config.ini, Settings, wmWinMove,
IniRead, wmResize, config.ini, Settings, wmResize,
IniRead, wmNoBorder, config.ini, Settings, wmNoBorder,

border := 1

~LWin Up::return

; Always on top
#space::
if wmOnTop = 1
{
	Winset, AlwaysOnTop, Toggle, A
	mousegetpos, x, y, possum
	WinGet, ExStyle, ExStyle, ahk_id %possum%
	if (ExStyle & 0x8)
		ExStyle = AlwaysOnTop
	else
		ExStyle = Not AlwaysOnTop
	ToolTip, %exstyle%
	sleep, 1000
	ToolTip
	return
} else {
	return
}
return

; Restore/Maximize with hotkey
#x::
if wmMaxiMin = 1
{
	WinGet, active_id, ID, A
	WinGet, checkmax, MinMax, A
	If(checkmax == 1) {
		WinGet, active_id, ID, A
		WinRestore, ahk_id %active_id%
	} else {
		WinGetClass, class, ahk_id %active_id%
		if class not in ahk_class WorkerW,Shell_TrayWnd, Button, SysListView32,Progman,#32768 
			WinMaximize, ahk_id %active_id%
	}
	return
} else {
	return
}
return

; Super key to resize windows
#RButton::
if wmResize = 0
	return
else if wmResize = 1
{
	WinGetPos,,, W, H, A
	MouseMove, W, H
	loop {
		if (!GetKeyState("RButton","P")) {
			MouseGetPos, xpos, ypos 
			while (!GetKeyState("RButton","P")) {
				WinMove, A,,,, %xpos%, %ypos%
				break
			}
			break
		}
	}
	WinGetPos,,, W, H, A
	MouseMove, W/2, H/2
	return
}
else if wmResize = 2
{
	WinGetPos, , , W, H, A
	H -= 5
	W -= 5
	MouseMove, W, H
	MouseClick,Left,,,,,D
	Loop {
		if (!GetKeyState("RButton","P")) {
			MouseClick,Left,,,,,U
			Break
		}
	}
	WinGetPos, , ,W,H,A
	MouseMove, W/2, H/2
	return
} else {
	return
}
return

; Super key to move windows
#LButton::
if wmWinMove = 1
{
	CoordMode, Mouse, Relative
	MouseGetPos, cur_win_x, cur_win_y, window_id
	WinGet, window_minmax, MinMax, ahk_id %window_id%
	
	if window_minmax <> 0
	{
		return
	}
	
	CoordMode, Mouse, Screen
	SetWinDelay, 0
	
	loop
	{
		if !GetKeyState("LButton", "P")
		{
			break
		}
		MouseGetPos, cur_x, cur_y
		WinMove, ahk_id %window_id%,, (cur_x - cur_win_x), (cur_y - cur_win_y)
	}
	return
} else {
	return
}
return

; Remove window border
#b::
if wmNoBorder = 1
{
	if border = 0
	{
		WinSet, Style, Toggle -0xC00000, A
		border := 1
		return
	}
	else if border = 1
	{
		WinSet, Style, Toggle +0xC00000, A
		border := 0
		return
	}
} else {
	return
}
return

; Middle-mouse button on taskbar to open taskmanager
#If WinActive("ahk_class Shell_TrayWnd") and WinActive("ahk_exe explorer.exe")
~MButton Up::
run, taskmgr.exe
WinWait, ahk_class TaskManagerWindow
WinActivate, ahk_class TaskManagerWindow
return
#IfWinNotActive, ahk_class Shell_TrayWnd
MButton::Mbutton
return
#IfWinActive

; Empty recycle bin
#Del::
FileRecycleEmpty
MsgBox, Recycle bin emptied
return

; Restart VoiceMeeter Banana
^+!r::
process, close, voicemeeterpro.exe
sleep, 500
run, C:\Program Files (x86)\VB\Voicemeeter\voicemeeterpro.exe
return