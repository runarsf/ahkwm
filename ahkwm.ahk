﻿#SingleInstance, Force
#Persistent
SetWorkingDir, %A_ScriptDir%
CoordMode, Pixel, Screen
Menu, Tray, Icon, cmd.ico
Menu, Tray, Add ; divider
Menu, Tray, Add, Settings, Settings


/*
##########################
#					#
#		Source		#
#					#
##########################
*/
#Include, src\setup.ahk ; config setup
#Include, src\wm.ahk 
#Include, src\caps.ahk
#Include, src\osu!.ahk
#Include, src\spotify.ahk

global cfgEdit

settings() {
	global visible
	
	if(WinExist("Settings") || visible == 1) {
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
		Gui 1: Show,, Settings
		visible := 1
	}
}
saveButton() {
	Gui 1: Submit, Nohide
	FileDelete, config.ini
	FileAppend, %cfgEdit%, config.ini
	reload
}

Tippy(tipsHere, wait:=333)
{
	ToolTip, %tipsHere%,,,8
	SetTimer, noTip, %wait%
}
noTip:
ToolTip,,,,8
return

return
GuiClose:
reload