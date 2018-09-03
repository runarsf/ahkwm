#SingleInstance, Force
#Persistent
#EscapeChar ¤
SetWorkingDir, %A_ScriptDir%
CoordMode, ToolTip, Screen
Menu, Tray, Icon, %A_ScriptDir%\icon.ico
; Tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Exit, ExitApp
Menu, Tray, Add, Reload, TrayReload
Menu, Tray, Add, Explore, TrayExplore
Menu, Tray, Add, Edit, TrayEdit
Menu, Tray, Add, Settings, TraySettings
Menu, Tray, Add

; Variables
bgcolor := 000000
fgcolor := FFFFFF
1080p := 1080-15

#Include, lib\setup.ahk

; Imports
#Include, lib\active.ahk
;#Include, pkg\wm.ahk
#Include, pkg\2nd-kbd.ahk
;#Include, pkg\snap.ahk
#Include, pkg\osu!.ahk
#Include, pkg\spotify.ahk
#Include, pkg\youtube.ahk
return

; Persistent keybinds and functions
SetNumlockState AlwaysOn
SetCapslockState AlwaysOff
#l::DllCall("LockWorkStation")
#q::!F4
#r::run %appdata%\Microsoft\Windows\Start Menu\Programs\System Tools\run.lnk

TrayReload:
Gui, Submit, Nohide
reload
return
TrayExplore:
run, %A_ScriptDir%
return
TrayEdit:
edit %A_ScriptName%
return
TraySettings:
Gui 5: +AlwaysOnTop +ToolWindow +LastFound +Caption +LabelGui +OwnDialogs
Gui 5: Color, 252525, 303030
Gui 5: Font, s12 cWhite, Source Code Pro
FileRead, config, %A_ScriptDir%\config.ini
Gui 5: Add, Edit, r35 w450 vFileEdit, %config%

Gui 5: Font, s10, Consolas
Gui 5: Add, Button, gSaveButton, Save
Gui 5: Show,, Settings
return
SaveButton:
Gui 5: Submit, NoHide
FileDelete, config.ini
FileAppend, %FileEdit%, config.ini
5GuiClose:
Gui 5: Destroy
reload
return

ExitApp:
Gui, Submit, Nohide
Gui 2: Submit, Nohide
Gui, Destroy
Gui 2: Destroy
IniWrite, %MySlider%, config.ini, Settings, SavedVolume
ExitApp
return