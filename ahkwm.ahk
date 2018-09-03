#SingleInstance, Force
#Persistent
SetWorkingDir, %A_ScriptDir%
CoordMode, Pixel, Screen
Menu, Tray, Icon, cmd.ico
Menu, Tray, Add ; divider
Menu, Tray, Add, Settings, Settings

#Include, setup.ahk ; config setup


settings() {
	global cfgEdit
	FileRead, cfgContent, config.ini
	Gui 1: +AlwaysOnTop +ToolWindow +LastFound +Resize
	Gui 1: Color, 252525, 303030
	Gui 1: Font, s12 cWhite, Consolas
	Gui 1: Add, Edit, r35 w450 vcfgEdit, %cfgContent%
	Gui 1: Font, s12, Consolas
	Gui 1: Add, Button, h18 gSaveButton, Save
	Gui 1: Show,, Settings
}
SaveButton() {
	global cfgEdit
	Gui 1: Submit, Nohide
	FileDelete, config.ini
	FileAppend, %cfgEdit%, config.ini
	reload
}