~LWin Up::return

CoordMode, ToolTip, Screen

; Always on top
#space::
if winOnTop = 1
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
if winMaxMin = 1
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
if winResize = 0
	return
else if winResize = 1
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
else if winResize = 2
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
if winMove = 1
{
	if WinActive("ahk_class WorkerW") {
		return
	}
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

; Middle-mouse button on taskbar to open taskmanager
#If WinActive("ahk_class Shell_TrayWnd") or WinActive("ahk_class Shell_SecondaryTrayWnd") and WinActive("ahk_exe explorer.exe")
~MButton Up::
run, taskmgr.exe
WinWait, ahk_class TaskManagerWindow
WinActivate, ahk_class TaskManagerWindow
return
#IfWinActive

#Del::
MsgBox, 4, Recycle Bin, Are you sure you want to permanently delete all files in the recycle bin?
IfMsgBox, Yes
{
	FileRecycleEmpty
	MsgBox,, Recycle Bin, Recycle bin emptied
	return
}
IfMsgBox, No
	return


!l::send, {LWin Down}{Space}{LWin Up}