SendMode, Input
#InstallKeybdHook
#UseHook On

lm := "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\2nd-keyboard.lnk"
if(!WinExist("ahk_exe LuaMacros.exe"))
  MsgBox, 4, alert, LuaMacros instance not detected¤, do you want to run one?
IfMsgBox, Yes
  run, %lm%
IfMsgBox, No
  return
WinActivate, ahk_exe LuaMacros.exe

;-------------2ND KEYBOARD USING LUAMACROS-----------------

wincount := 0

~F24::
FileRead, key, D:\Home\git\2nd-keyboard\support files\keypressed.txt
sleep, 150
tippy(key)

if(key = "escape")
  WinActivate, ahk_class Shell_TrayWnd

else if WinActive("ahk_exe osu!.exe")
{
  if(key = "numMult")
  {
    Osu.add_set("fav.png", "favL.png")
    return
  }
  else if(key = "num1")
  {
    Osu.add_single("fc.png", "fcL.png")
    return
  }
  else if(key = "num2")
  {
    Osu.add_single("hddt.png", "hddtL.png")
    return
  }
  else if(key = "num3")
  {
    Osu.add_set("tech.png", "techL.png")
    return
  }
  else if(key = "a")
    Osu.mod("a")
  else if(key = "s")
    Osu.mod("s")
  else if(key = "d")
    Osu.mod("d")
  else if(key = "f")
    Osu.mod("f")
  else if(key = "g")
    Osu.mod("g")
  else if(key = "q")
    Osu.mod("q")
  else if(key = "w")
    Osu.mod("w")
  else if(key = "e")
    Osu.mod("e")
  else if(key = "v")
    Osu.mod("v")
  else if(key = "c")
    Osu.mod("c")
  else if(key = "x")
    Osu.mod("x")
  else if(key = "z")
    Osu.mod("z")
  else if(key = "r")
    Osu.mod("1")
  else
    return
}
else if WinActive("ahk_exe Photoshop.exe")
{
  if(key = "a")
    Osu.mod("a")
  else
    return
}

else if(key = "l")
  DllCall("LockWorkStation")
else if(key = "b")
  run, "C:\Users\rufus\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\rufusPy.bat"
else if(key = "o")
  run, "C:\Users\rufus\AppData\Local\osu!\osu!.exe"
else if(key = "p")
  Active.norm("ahk_exe Photoshop.exe", "C:\Program Files\Adobe\Adobe Photoshop CC 2018\Photoshop.exe")
else if(key = "u")
{
  run, control appwiz.cpl
}
else if(key = "space")
{
  MsgBox,, asd, %Win1%
  WinActivate, Win1
}
else if(key = "alt")
{	
  wincount += 1
  if(wincount >= 2)
  {
    wincount := 0
    tippy("1")
    WinGetActiveTitle, Win1
    return
  }
  else
  {
    tippy("2")
    WinGetActiveTitle, Win2
    return
  }
}
else if(key = "n")
  Active.broswer("ahk_exe notepad++.exe", "C:\Program Files\Notepad++\notepad++.exe")
else if(key = "l")
  SendInput, ( ͡° ͜ʖ ͡°)
else if(key = "F1")
  TaskbarMove("Top")
else if(key = "F2")
  TaskbarMove("Bottom")
else if(key = "F11")
  Active.norm("ahk_exe procexp64.exe", "D:\Home\Documents\Tools\ProcessExplorer\procexp64.exe")
else if(key = "F12")
  Active.norm("ahk_exe AutoHotkeyGUI", "C:\Program Files\AutoHotkey\WindowSpy.ahk")
else if(key = "insert")
  edit, %A_ScriptName%
else if(key = "backspace")
{
  If KeyIsPressed
    return
  KeyIsPressed := true
  SetTimer, WaitForRelease, 500
  return
  ~Backspace Up::
  SetTimer, WaitForRelease, Off
  KeyIsPressed := false
  return
  WaitForRelease:
  SetTimer, WaitForRelease, Off
  SendInput, {Alt Down}{F4}{Alt Up}
  return
}
else if(key = "q")
{
  Process, Close, DiscordCanary.exe
  sleep, 350
  run, "C:\Users\rufus\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord Canary.lnk"
}
else if(key = "e")
  Active.explorer()
else if(key = "s")
  Active.norm("ahk_exe Spotify.exe", "C:\Users\rufus\AppData\Roaming\Spotify\Spotify.exe")
else if(key = "d")
  Active.norm("ahk_exe DiscordCanary.exe", "C:\Users\rufus\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord Canary.lnk")
else if(key = "x")
  SendInput, lmao xd lol rofl ialmaorn pwnd roflmao iamallama XD lawl Cx
else if(key = "c")
  Active.browser("ahk_exe chrome.exe", "chrome.exe")
else if(key = "r")
  Active.norm("ahk_exe OORegEdt.exe", "D:\Home\Documents\Tools\ooRegEdit\OORegEdt.exe")
else if(key = "f")
  Active.broswer("ahk_exe firefox.exe", "firefox.exe")
else if(key = "g")
  Active.norm("ahk_exe GitHubDesktop.exe", "C:\Users\rufus\AppData\Local\GitHubDesktop\GitHubDesktop.exe")

else if(key = "0")
  run, "D:\Home"
else if(key = "1")
  run, "shell:startup"
else if(key = "2")
  run, "C:\Users\%A_UserName%\AppData\Local"
else if(key = "3")
  run, "C:\Users\%A_UserName%\AppData\LocalLow"
else if(key = "4")
  run, "C:\Users\%A_UserName%\AppData\Roaming"

return




TaskbarMove(p_pos) {
  label:="TaskbarMove_" p_pos
  
  WinExist("ahk_class Shell_TrayWnd")
  SysGet, s, Monitor
  
  if (IsLabel(label)) {
    Goto, %label%
  }
  return
  
  TaskbarMove_Top:
  TaskbarMove_Bottom:
  WinMove(sLeft, s%p_pos%, sRight, 0)
  return
}

WinMove(p_x, p_y, p_w="", p_h="", p_hwnd="") {
  WM_ENTERSIZEMOVE:=0x0231
  WM_EXITSIZEMOVE :=0x0232
  
  if (p_hwnd!="") {
    WinExist("ahk_id " p_hwnd)
  }
  
  SendMessage, WM_ENTERSIZEMOVE
  ;//Tooltip WinMove(%p_x%`, %p_y%`, %p_w%`, %p_h%)
  WinMove, , , p_x, p_y, p_w, p_h
  SendMessage, WM_EXITSIZEMOVE
}
Return