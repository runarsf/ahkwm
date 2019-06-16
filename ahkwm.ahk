#SingleInstance, Force
#Persistent
;#HotkeyInterval 1000
;#MaxHotkeysPerInterval 100
SetBatchLines -1
#UseHook
SetWorkingDir, %A_ScriptDir%
SetCapsLockState, AlwaysOff
CoordMode, Pixel, Screen

Menu, Tray, NoStandard
Menu, Tray, Tip, ahkwm
Menu, Tray, Icon, cmd.ico

If ( !A_IsCompiled )
{
	Menu, AutoHotkey, Standard
	Menu, Tray, Add, AutoHotkey, :AutoHotkey
	Menu, Tray, Add
}

Menu, Tray, Add, Help, ExitSub
Menu, Tray, Default, Help

Menu, Feedback, Add, GitHub, github
Menu, Feedback, Add, Mail, email
Menu, Tray, Add, Feedback, :Feedback
Menu, Tray, Add

Menu, Tray, Add, Settings, Settings
Menu, Tray, Add, Revert All Effects, ExitSub
Menu, Tray, Add, Restart VBAN, rvban
Menu, Tray, Add
Menu, Tray, Add, Exit, ExitSub

;http://www.enovatic.org/products/niftywindows/features/

/*
	IMPORTS
*/
#Include, src\setup.ahk ; config setup
#Include, src\snap.ahk
#Include, src\wm.ahk
#Include, src\caps.ahk
#Include, src\osu!.ahk
#Include, src\media.ahk
#Include, src\2nd-kbd.ahk
#Include, src\tenkeyless.ahk
#Include, src\dvorak.ahk

global cfgEdit

settings() {
	if(WinExist("ahkwm - Settings")) {
		reload
	}
	else {
		FileRead, cfgContent, config.ini
		Gui 1: +AlwaysOnTop +ToolWindow +LastFound +Resize
		Gui 1: Color, 252525, 303030
		Gui 1: Font, s12 cWhite, Consolas
		Gui 1: Add, Edit, r35 w450 vcfgEdit, %cfgContent%
		Gui 1: Font, s12, Consolas
		Gui 1: Add, Button, gsaveButton h18, Save
		Gui 1: Show,, ahkwm - Settings
	}
}
saveButton() {
	Gui 1: Submit, Nohide
	FileDelete, config.ini
	FileAppend, %cfgEdit%, config.ini
	reload
}
rvban() {
	Process, Close, voicemeeter8.exe
	run, C:\Program Files (x86)\VB\Voicemeeter\voicemeeter8.exe
}
github() {
	run https://github.com/runarsf/ahkwm
}
email() {
	run mailto:runarsf@protonmail.com
}
Tippy(tipsHere, wait:=333)
{
	ToolTip, %tipsHere%,,,8
	SetTimer, noTip, %wait%
}
noTip:
ToolTip,,,,8
return

OnExit, ExitSub  
return

ExitSub:
if A_ExitReason not in Logoff,Shutdown  ; Avoid spaces around the comma in this line.
{
	MsgBox, 4, , Are you sure you want to exit?
	IfMsgBox, No
		return
}

GuiClose:
reload
