#SingleInstance, Force       ; Only allow one running instance at a time
#Persistent                  ; Run script until ExitApp
#HotkeyInterval 1000         ; Display warning dialog after limit
#MaxHotkeysPerInterval 100   ; Display warning dialog after limit
#UseHook                     ; Forces the use of the hook to implement all or some keyboard hotkeys
SetBatchLines -1             ; Set how fast the script will run (affects CPU)
SetWorkingDir, %A_ScriptDir% ; Changes the script's current working directory
SetCapsLockState, AlwaysOff  ; Set CapsLock state
CoordMode, Pixel, Screen     ; Sets coordinate mode for various commands to be relative to the screen

/*
 * Custom tray menu
 */
Menu, Tray, NoStandard
Menu, Tray, Tip, ahkwm
Menu, Tray, Icon, favicon.ico

if (!A_IsCompiled)
{
  Menu, AutoHotkey, Standard
  Menu, Tray, Add, AutoHotkey, :AutoHotkey
  Menu, Tray, Add
}

Menu, Feedback, Add, GitHub, trayGithub
Menu, Feedback, Add, Mail, trayEmail
Menu, Tray, Add, Feedback, :Feedback

Menu, Tray, Add, Settings, settings
; Menu, Tray, Add, Restart VBAN, trayRestartVBAN
Menu, Tray, Add
Menu, Tray, Add, Exit, Exit

/*
 * IMPORTS
 */
#Include, lib\setup.ahk
#Include, lib\snap.ahk
#Include, lib\wm.ahk
#Include, lib\caps.ahk
#Include, lib\osu!.ahk
#Include, lib\media.ahk
#Include, lib\2nd-kbd.ahk
#Include, lib\tenkeyless.ahk
#Include, lib\dvorak.ahk

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
trayRestartVBAN() {
  Process, Close, voicemeeter8.exe
  run, C:\Program Files (x86)\VB\Voicemeeter\voicemeeter8.exe
}
trayGithub() {
  run, https://github.com/runarsf/ahkwm
}
trayEmail() {
  run, mailto:root@runarsf.dev
}
Exit() {
  ExitApp
}
Tippy(tipsHere, wait:=333) {
  ToolTip, %tipsHere%,,,8
  SetTimer, noTip, %wait%
}
noTip:
ToolTip,,,,8
return

/*
OnExit, ExitSub
return

ExitSub:
if (A_ExitReason not in Logoff,Shutdown) ; Avoid spaces around the comma in this line.
{
  MsgBox, 4, , Are you sure you want to exit?
  IfMsgBox, No
    return
}

GuiClose:
reload
return
*/