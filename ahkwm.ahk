#SingleInstance, Force       ; Only allow one running instance at a time
#Persistent                  ; Run script until ExitApp
#HotkeyInterval 1000         ; Display warning dialog after limit
#MaxHotkeysPerInterval 100   ; Display warning dialog after limit
#NoTrayIcon                  ; Disable tray icon
#UseHook                     ; Forces the use of the hook to implement all or some keyboard hotkeys
;SetBatchLines -1             ; Set how fast the script will run (affects CPU)
;SetWorkingDir, %A_ScriptDir% ; Changes the script's current working directory
;SetCapsLockState, AlwaysOff  ; Set CapsLock state
;CoordMode, Pixel, Screen     ; Sets coordinate mode for various commands to be relative to the screen

/*
 * NOTE: To modify the .ini file manually, exit the script first.
 */

SplitPath, A_ScriptFullPath, SYS_ScriptNameExt, SYS_ScriptDir, SYS_ScriptExt, SYS_ScriptNameNoExt, SYS_ScriptDrive

OnExit, SYS_ExitHandler

Gosub, CFG_LoadSettings
Gosub, CFG_ApplySettings
Gosub, TRY_TrayInit

/*
 * Hotkeys
 */
#If CFG_EmptyRecycleBin
#Delete::FUN_EmptyRecycleBin()
#If
#If CFG_SuperMove
#LButton::FUN_SuperMove()
#If
#If CFG_SuperResize
#RButton::FUN_SuperResize()
#If
#If CFG_FullscreenToggle
#f::FUN_FullscreenToggle()
#If
#If CFG_AlwaysOnTop
#Space::FUN_AlwaysOnTop()
#If
#If CFG_OpacityControl
#WheelUp::FUN_IncreaseOpacity()
#WheelDown::FUN_DecreaseOpacity()
#If
#If CFG_VolumeControl and FUN_MouseIsOver("ahk_class Shell_TrayWnd")
WheelUp::Send {Volume_Up}
WheelDown::Send {Volume_Down}
#If
#If CFG_TaskManager and WinActive("ahk_class Shell_TrayWnd") or WinActive("ahk_class Shell_SecondaryTrayWnd") and WinActive("ahk_exe explorer.exe")
~MButton Up::FUN_TaskManager()
#If
#If CFG_AudioDevices and WinActive("ahk_class Shell_TrayWnd") or WinActive("ahk_class Shell_SecondaryTrayWnd") and WinActive("ahk_exe explorer.exe")
~+MButton Up::FUN_AudioDevices()
#If
#If CFG_CapsKeys
CapsLock & Space::Send {Media_Play_Pause}
CapsLock & Left::Send {Media_Prev}
CapsLock & Right::Send {Media_Next}
CapsLock & Enter::Send {Volume_Mute}
CapsLock & Up::Send {Volume_Up}
CapsLock & Down::Send {Volume_Down}
CapsLock & w::Spotify_HotkeySend("^{Up}")
CapsLock & s::Spotify_HotkeySend("^{Down}")
CapsLock & ,::<
CapsLock & .::>
#If

Return

	SYS_ExitHandler:
		Gosub, CFG_SaveSettings
	ExitApp

	/*
	 * [TRY] Tray
	 */

	TRY_TrayInit:
		Menu, Tray, NoStandard
		Menu, Tray, Tip, ahkwm nightly
		Menu, Tray, Icon, favicon.ico,, 1

		if ( !A_IsCompiled )
		{
			Menu, AutoHotkey, Add, Open Folder, TRY_TrayEvent
			Menu, AutoHotkey, Standard
			Menu, Tray, Add, AutoHotkey, :AutoHotkey
		}
		Menu, Shortcuts, Add, Desktop, TRY_TrayEvent
		Menu, Shortcuts, Add, Startup, TRY_TrayEvent
		Menu, Shortcuts, Add, AppData, TRY_TrayEvent
		Menu, Tray, Add, Shortcuts, :Shortcuts
		Menu, Tray, Add

		;Menu, Feedback, Add, GitHub, TRY_TrayEvent
		;Menu, Feedback, Add, Mail, TRY_TrayEvent
		; license, check if file exist, or open website
		;Menu, Tray, Add, Feedback, :Feedback

		Menu, Features, Add, Focus Follow Mouse, TRY_TrayEvent
		Menu, Features, Add, Disable CapsLock, TRY_TrayEvent
		Menu, Features, Add, Super Move, TRY_TrayEvent
		Menu, Features, Add, Super Resize, TRY_TrayEvent
		Menu, Features, Add, Empty Recycle Bin, TRY_TrayEvent
		Menu, Features, Add, Audio Devices, TRY_TrayEvent
		Menu, Features, Add, Task Manager, TRY_TrayEvent
		Menu, Features, Add, Fullscreen Toggle, TRY_TrayEvent
		Menu, Features, Add, Always On Top, TRY_TrayEvent
		Menu, Features, Add, Opacity Control, TRY_TrayEvent
		Menu, Features, Add, Volume Control, TRY_TrayEvent
		Menu, Features, Add, Caps Keys, TRY_TrayEvent
		Menu, Tray, Add, Features, :Features
		Menu, Options, Add, Set FFM Speed, TRY_TrayEvent
		Menu, Options, Add, Set Resize Method, TRY_TrayEvent
		Menu, Tray, Add, Options, :Options
		Menu, Tray, Add, Help, FUN_HelpGui
		Menu, Tray, Add
	
		Menu, Tray, Add, Reload, TRY_TrayEvent
		Menu, Tray, Add, Exit, TRY_TrayEvent
		
		Gosub, TRY_TrayUpdate
		
		if ( A_IconHidden )
			Menu, Tray, Icon
	Return

	TRY_TrayEvent:
		; if ( !TRY_TrayEvent )
		;	TRY_TrayEvent = %A_ThisMenuItem%
		if ( A_ThisMenuItem = "Open Folder" )
			Run, explore %A_ScriptDir%
		if ( A_ThisMenuItem = "Desktop" )
			Run, explore shell:desktop
		if ( A_ThisMenuItem = "Startup" )
			Run, explore shell:startup
		if ( A_ThisMenuItem = "AppData" )
			Run, explore %AppData%
		if ( A_ThisMenuItem = "Focus Follow Mouse" )
		{
			CFG_FocusFollowMouse := !CFG_FocusFollowMouse
			Gosub, CFG_ApplySettings
			;Gosub, CFG_SaveSettings
		}
		if ( A_ThisMenuItem = "Set FFM Speed" )
		{
			Gui, FFMSpeed:New,, Focus Follow Mouse Speed
			;Gui, FFMSpeed+AlwaysOnTop +ToolWindow +LastFound +Caption +Border +E0x8000000
			Gui, FFMSpeed:Color, 2f343f, 434852
			WinSet, Transparent, 230
			Gui, FFMSpeed:Font, s10 cWhite
			Gui, FFMSpeed:Add, Slider, gUpdateFFMSpeed w400 vCFG_FocusFollowMouseSpeed Range1-3000 TickInterval1, %CFG_FocusFollowMouseSpeed%
			Gui, FFMSpeed:Add, Text, vFFMSpeed, %CFG_FocusFollowMouseSpeed%ms
			Gui, Show

			; NOTE: Can't reach end of sub because of the Returns, can be moved out.
			UpdateFFMSpeed:
				GuiControl,, FFMSpeed, %CFG_FocusFollowMouseSpeed%ms
			Return	
			FFMSpeedGuiClose:
				Gui FFMSpeed:Submit
				Gui FFMSpeed:Cancel
				Gosub, CFG_ApplySettings
				;Gosub, CFG_SaveSettings
			Return
		}
		if ( A_ThisMenuItem = "Set Resize Method" )
		{
			Gui, ResizeMethod:New,, Super Resize Method
			Gui, ResizeMethod:Color, 2f343f, 434852
			WinSet, Transparent, 230
			Gui, ResizeMethod:Font, s10 cWhite
			Gui, ResizeMethod:Add, DropDownList, vCFG_SuperResizeMethod, 1|2
			GuiControl, Choose, CFG_SuperResizeMethod, %CFG_SuperResizeMethod%
			Gui, Show
			Return

			ResizeMethodGuiClose:
				Gui ResizeMethod:Submit
				Gui ResizeMethod:Cancel
				Gosub, CFG_ApplySettings
			Return
		}
		if ( A_ThisMenuItem = "Disable CapsLock" )
		{
			CFG_DisableCapsLock := !CFG_DisableCapsLock
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Super Move" )
		{
			CFG_SuperMove := !CFG_SuperMove
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Super Resize" )
		{
			CFG_SuperResize := !CFG_SuperResize
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Empty Recycle Bin" )
		{
			CFG_EmptyRecycleBin := !CFG_EmptyRecycleBin
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Audio Devices" )
		{
			CFG_AudioDevices := !CFG_AudioDevices
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Task Manager" )
		{
			CFG_TaskManager := !CFG_TaskManager
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Fullscreen Toggle" )
		{
			CFG_FullscreenToggle := !CFG_FullscreenToggle
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Always On Top" )
		{
			CFG_AlwaysOnTop := !CFG_AlwaysOnTop
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Opacity Control" )
		{
			CFG_OpacityControl := !CFG_OpacityControl
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Volume Control" )
		{
			CFG_VolumeControl := !CFG_VolumeControl
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Caps Keys" )
		{
			CFG_CapsKeys := !CFG_CapsKeys
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Reload" )
			Reload
		if ( A_ThisMenuItem = "Exit" )
			ExitApp

		;TRY_TrayEvent =

		Gosub, TRY_TrayUpdate
	Return
		
	TRY_TrayUpdate:
		if ( CFG_FocusFollowMouse )
			Menu, Features, Check, Focus Follow Mouse
		else
			Menu, Features, UnCheck, Focus Follow Mouse

		if ( CFG_DisableCapsLock )
			Menu, Features, Check, Disable CapsLock
		else
			Menu, Features, UnCheck, Disable CapsLock

		if ( CFG_SuperMove )
			Menu, Features, Check, Super Move
		else
			Menu, Features, UnCheck, Super Move

		if ( CFG_SuperResize )
			Menu, Features, Check, Super Resize
		else
			Menu, Features, UnCheck, Super Resize
		
		if ( CFG_EmptyRecycleBin )
			Menu, Features, Check, Empty Recycle Bin
		else
			Menu, Features, UnCheck, Empty Recycle Bin
		
		if ( CFG_AudioDevices )
			Menu, Features, Check, Audio Devices
		else
			Menu, Features, UnCheck, Audio Devices
		
		if ( CFG_TaskManager )
			Menu, Features, Check, Task Manager
		else
			Menu, Features, UnCheck, Task Manager
		
		if ( CFG_FullscreenToggle )
			Menu, Features, Check, Fullscreen Toggle
		else
			Menu, Features, UnCheck, Fullscreen Toggle
		
		if ( CFG_AlwaysOnTop )
			Menu, Features, Check, Always On Top
		else
			Menu, Features, UnCheck, Always On Top
		
		if ( CFG_OpacityControl )
			Menu, Features, Check, Opacity Control
		else
			Menu, Features, UnCheck, Opacity Control
		
		if ( CFG_VolumeControl )
			Menu, Features, Check, Volume Control
		else
			Menu, Features, UnCheck, Volume Control
		
		if ( CFG_CapsKeys )
			Menu, Features, Check, Caps Keys
		else
			Menu, Features, UnCheck, Caps Keys
	Return

	/*
	 * [CFG] Config
	 */

	CFG_LoadSettings:
		CFG_IniFile = %A_ScriptDir%\%SYS_ScriptNameNoExt%.ini
		IniRead, CFG_FocusFollowMouse, %CFG_IniFile%, Features, CFG_FocusFollowMouse, 0
		IniRead, CFG_DisableCapsLock, %CFG_IniFile%, Features, CFG_DisableCapsLock, 0
		IniRead, CFG_SuperMove, %CFG_IniFile%, Features, CFG_SuperMove, 1
		IniRead, CFG_SuperResize, %CFG_IniFile%, Features, CFG_SuperResize, 1
		IniRead, CFG_EmptyRecycleBin, %CFG_IniFile%, Features, CFG_EmptyRecycleBin, 1
		IniRead, CFG_AudioDevices, %CFG_IniFile%, Features, CFG_AudioDevices, 1
		IniRead, CFG_TaskManager, %CFG_IniFile%, Features, CFG_TaskManager, 1
		IniRead, CFG_FullscreenToggle, %CFG_IniFile%, Features, CFG_FullscreenToggle, 1
		IniRead, CFG_AlwaysOnTop, %CFG_IniFile%, Features, CFG_AlwaysOnTop, 1
		IniRead, CFG_OpacityControl, %CFG_IniFile%, Features, CFG_OpacityControl, 0
		IniRead, CFG_VolumeControl, %CFG_IniFile%, Features, CFG_VolumeControl, 0
		IniRead, CFG_CapsKeys, %CFG_IniFile%, Features, CFG_CapsKeys, 1
		IniRead, CFG_FocusFollowMouseSpeed, %CFG_IniFile%, Options, CFG_FocusFollowMouseSpeed, 200
		IniRead, CFG_SuperResizeMethod, %CFG_IniFile%, Options, CFG_SuperResizeMethod, 2
	Return

	CFG_SaveSettings:
		CFG_IniFile = %A_ScriptDir%\%SYS_ScriptNameNoExt%.ini
		IniWrite, %CFG_FocusFollowMouse%, %CFG_IniFile%, Features, CFG_FocusFollowMouse
		IniWrite, %CFG_DisableCapsLock%, %CFG_IniFile%, Features, CFG_DisableCapsLock
		IniWrite, %CFG_SuperMove%, %CFG_IniFile%, Features, CFG_SuperMove
		IniWrite, %CFG_SuperResize%, %CFG_IniFile%, Features, CFG_SuperResize
		IniWrite, %CFG_EmptyRecycleBin%, %CFG_IniFile%, Features, CFG_EmptyRecycleBin
		IniWrite, %CFG_AudioDevices%, %CFG_IniFile%, Features, CFG_AudioDevices
		IniWrite, %CFG_TaskManager%, %CFG_IniFile%, Features, CFG_TaskManager
		IniWrite, %CFG_FullscreenToggle%, %CFG_IniFile%, Features, CFG_FullscreenToggle
		IniWrite, %CFG_AlwaysOnTop%, %CFG_IniFile%, Features, CFG_AlwaysOnTop
		IniWrite, %CFG_OpacityControl%, %CFG_IniFile%, Features, CFG_OpacityControl
		IniWrite, %CFG_VolumeControl%, %CFG_IniFile%, Features, CFG_VolumeControl
		IniWrite, %CFG_CapsKeys%, %CFG_IniFile%, Features, CFG_CapsKeys
		IniWrite, %CFG_FocusFollowMouseSpeed%, %CFG_IniFile%, Options, CFG_FocusFollowMouseSpeed
		IniWrite, %CFG_SuperResizeMethod%, %CFG_IniFile%, Options, CFG_SuperResizeMethod
	Return

	CFG_ApplySettings:
		if ( CFG_FocusFollowMouse )
			SetTimer, FUN_FocusHandler, %CFG_FocusFollowMouseSpeed%
		else
			SetTimer, FUN_FocusHandler, Off

		if ( CFG_DisableCapsLock )
			SetCapsLockState, AlwaysOff
		else
			SetCapsLockState, Off
	Return

	/*
	 * [FUN] Custom functions
	 */

	FUN_FocusHandler:
		CoordMode, Mouse, Screen
		MouseGetPos, XWN_MouseX, XWN_MouseY, XWN_WinID
		If ( !XWN_WinID )
			Return

		If ( (XWN_MouseX != XWN_MouseOldX) or (XWN_MouseY != XWN_MouseOldY) )
		{
			IfWinNotActive, ahk_id %XWN_WinID%
				XWN_FocusRequest = 1
			Else
				XWN_FocusRequest = 0

			XWN_MouseOldX := XWN_MouseX
			XWN_MouseOldY := XWN_MouseY
			XWN_MouseMovedTickCount := A_TickCount
		}
		Else
			If ( XWN_FocusRequest and (A_TickCount - XWN_MouseMovedTickCount > 500) )
			{
				WinGetClass, XWN_WinClass, ahk_id %XWN_WinID%
				If ( XWN_WinClass = "Progman" )
					Return

				; checks wheter the selected window is a popup menu
				; (WS_POPUP) and !(WS_DLGFRAME | WS_SYSMENU | WS_THICKFRAME)
				WinGet, XWN_WinStyle, Style, ahk_id %XWN_WinID%
				If ( (XWN_WinStyle & 0x80000000) and !(XWN_WinStyle & 0x4C0000) )
					Return

				IfWinNotActive, ahk_id %XWN_WinID%
					WinActivate, ahk_id %XWN_WinID%

				XWN_FocusRequest = 0
			}
	Return
	
	FUN_HelpGui()
	{
		global
		Gui, Help:New,, Help
		;Gui, FFMSpeed+AlwaysOnTop +ToolWindow +LastFound +Caption +Border +E0x8000000
		Gui, Help:Color, 2f343f, 434852
		WinSet, Transparent, 230
		Gui, Help:Font, s12 cWhite, Monospace
		;Gui, Help:Add, Text,, Hotkeys
		Gui, Help:Font, s10
		Gui, Help:Add, Link,, [<a href="https://www.autohotkey.com/docs/KeyList.htm">Key List</a>]
		Gui, Help:Add, ListView, w700 r25, Hotkey|Action|Option|Location|Value
		LV_Add(,                   , "Focus Follow Mouse"           , "CFG_FocusFollowMouse"     ,          , CFG_FocusFollowMouse ? "enabled" : "disabled")
		LV_Add(,                   , "Disable CapsLock"             , "CFG_DisableCapsLock"      ,          , CFG_DisableCapsLock ? "enabled" : "disabled" )
		LV_Add(, "#LButton"        , "Move Active Window"           , "CFG_SuperMove"            ,          , CFG_SuperMove ? "enabled" : "disabled"       )
		LV_Add(, "#RButton"        , "Resize Active Window"         , "CFG_SuperResize"          ,          , CFG_SuperResize ? "enabled" : "disabled"     )
		LV_Add(, "#Delete"         , "Empty Recycle Bin"            , "CFG_EmptyRecycleBin"      ,          , CFG_EmptyRecycleBin ? "enabled" : "disabled" )
		LV_Add(, "~+MButton Up"    , "Open Audio Devices"           , "CFG_AudioDevices"         , "Taskbar", CFG_AudioDevices ? "enabled" : "disabled"    )
		LV_Add(, "~MButton Up"     , "Open Task Manager"            , "CFG_TaskManager"          , "Taskbar", CFG_TaskManager ? "enabled" : "disabled"     )
		LV_Add(, "#f"              , "Toggle Fullscreen"            , "CFG_FullscreenToggle"     ,          , CFG_FullscreenToggle ? "enabled" : "disabled")
		LV_Add(, "#Space"          , "Toggle Always On Top"         , "CFG_AlwaysOnTop"          ,          , CFG_AlwaysOnTop ? "enabled" : "disabled"     )
		LV_Add(, "#WheelUp"        , "Increase Opacity"             , "CFG_OpacityControl"       ,          , CFG_OpacityControl ? "enabled" : "disabled"  )
		LV_Add(, "#WheelDown"      , "Decrease Opacity"             , "CFG_OpacityControl"       ,          , CFG_OpacityControl ? "enabled" : "disabled"  )
		LV_Add(, "WheelUp"         , "Increase Volume"              , "CFG_VolumeControl"        , "Taskbar", CFG_VolumeControl ? "enabled" : "disabled"   )
		LV_Add(, "WheelDown"       , "Decrease Volume"              , "CFG_VolumeControl"        , "Taskbar", CFG_VolumeControl ? "enabled" : "disabled"   )
		LV_Add(,                   , "Focus Follow Mouse Speed (ms)", "CFG_FocusFollowMouseSpeed",          , CFG_FocusFollowMouseSpeed . "ms"             )
		LV_Add(,                   , "Resize Active Window Method"  , "CFG_SuperResizeMethod"    ,          , CFG_SuperResizeMethod                        )
		LV_Add(, "CapsLock & Space", "Media Play/Pause"             , "CFG_CapsKeys"             ,          , CFG_CapsKeys ? "enabled" : "disabled"        )
		LV_Add(, "CapsLock & Left" , "Media Previous"               , "CFG_CapsKeys"             ,          , CFG_CapsKeys ? "enabled" : "disabled"        )
		LV_Add(, "CapsLock & Right", "Media Next"                   , "CFG_CapsKeys"             ,          , CFG_CapsKeys ? "enabled" : "disabled"        )
		LV_Add(, "CapsLock & Enter", "Volume Mute"                  , "CFG_CapsKeys"             ,          , CFG_CapsKeys ? "enabled" : "disabled"        )
		LV_Add(, "CapsLock & Up"   , "Increase Volume"              , "CFG_CapsKeys"             ,          , CFG_CapsKeys ? "enabled" : "disabled"        )
		LV_Add(, "CapsLock & Down" , "Decrease Volume"              , "CFG_CapsKeys"             ,          , CFG_CapsKeys ? "enabled" : "disabled"        )
		LV_Add(, "CapsLock & w"    , "Increase Spotify Volume"      , "CFG_CapsKeys"             ,          , CFG_CapsKeys ? "enabled" : "disabled"        )
		LV_Add(, "CapsLock & s"    , "Decrease Spotify Volume"      , "CFG_CapsKeys"             ,          , CFG_CapsKeys ? "enabled" : "disabled"        )
		LV_Add(, "CapsLock & ,"    , "<"                            , "CFG_CapsKeys"             ,          , CFG_CapsKeys ? "enabled" : "disabled"        )
		LV_Add(, "CapsLock & ."    , ">"                            , "CFG_CapsKeys"             ,          , CFG_CapsKeys ? "enabled" : "disabled"        )
		LV_ModifyCol(, AutoHdr)
		Gui, Show
		Return

		HelpGuiClose:
			Gui Help:Submit
			Gui Help:Cancel
		Return
	}

	FUN_SuperMove()
	{
		if WinActive("ahk_class WorkerW") 
			Return
		CoordMode, Mouse, Relative
		MouseGetPos, cur_win_x, cur_win_y, window_id
		WinGet, window_minmax, MinMax, ahk_id %window_id%

		if window_minmax <> 0
			return

		CoordMode, Mouse, Screen
		SetWinDelay, 0

		loop
		{
			if !GetKeyState("LButton", "P")
				break
			MouseGetPos, cur_x, cur_y
			WinMove, ahk_id %window_id%,, (cur_x - cur_win_x), (cur_y - cur_win_y)
		}
		Return
	}
	
	FUN_SuperResize()
	{
		global
		if ( CFG_SuperResizeMethod = 1 )
		{
			WinGetPos,,, W, H, A
			MouseMove, W, H
			loop
			{
				if (!GetKeyState("RButton", "P"))
				{
					MouseGetPos, xpos, ypos 
					while (!GetKeyState("RButton", "P"))
					{
						WinMove, A,,,, %xpos%, %ypos%
						break
					}
					break
				}
			}
			WinGetPos,,, W, H, A
			MouseMove, W/2, H/2
		}
		else if ( CFG_SuperResizeMethod = 2 )
		{
			WinGetPos, , , W, H, A
			H -= 5
			W -= 5
			MouseMove, W, H
			MouseClick,Left,,,,,D
			loop
			{
				if (!GetKeyState("RButton", "P"))
				{
					MouseClick,Left,,,,,U
					Break
				}
			}
			WinGetPos, , ,W,H,A
			MouseMove, W/2, H/2
		}
	}
	
	FUN_EmptyRecycleBin()
	{
		MsgBox, 4, Recycle Bin, Are you sure you want to permanently delete all files in the recycle bin?
		IfMsgBox, Yes
		{
			FileRecycleEmpty
			MsgBox,, Recycle Bin, Recycle bin emptied
		}
	}
	
	FUN_TaskManager()
	{
		run, taskmgr.exe
		WinWait, ahk_class TaskManagerWindow
		WinActivate, ahk_class TaskManagerWindow
	}
	
	FUN_AudioDevices()
	{
		run, control mmsys.cpl sounds
		WinWait, ahk_class #32770
		WinActivate, ahk_class #32770
	}
	
	FUN_FullscreenToggle()
	{
		WinGet, active_id, ID, A
		WinGet, checkmax, MinMax, A
		if (checkmax == 1)
		{
			WinGet, active_id, ID, A
			WinRestore, ahk_id %active_id%
		}
		else
		{
			WinGetClass, class, ahk_id %active_id%
			if class not in ahk_class WorkerW,Shell_TrayWnd, Button, SysListView32,Progman,#32768 
				WinMaximize, ahk_id %active_id%
		}
	}
	
	FUN_AlwaysOnTop()
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
	}
	
	FUN_IncreaseOpacity()
	{
		WinGet, active_id, ID, A
		WinGet, transpAmnt, Transparent, ahk_id %active_id%
		if (transpAmnt >= 245)
			newTransp := 255
		else if (transpAmnt == "")
			newTransp := Off
		else
			newTransp := transpAmnt + 10
		WinSet, Transparent, %newTransp%, ahk_id %active_id%
	}
	
	FUN_DecreaseOpacity()
	{
		WinGet, active_id, ID, A
		WinGet, transpAmnt, Transparent, ahk_id %active_id%
		if (transpAmnt == "")
			newTransp := 245
		else if (transpAmnt <= 10)
			newTransp := 10
		else
			newTransp := transpAmnt - 10
		WinSet, Transparent, %newTransp%, ahk_id %active_id%
	}
	
	FUN_MouseIsOver(WinTitle)
	{
		MouseGetPos,,, Win
		return WinExist(WinTitle . " ahk_id " . Win)
	}
	
	global cached_spotify_window := Get_Spotify_Id()
	; FUNCTION: Send a hotkey string to Spotify 
	Spotify_HotkeySend(hotkeyString) {
		DetectHiddenWindows, On
		winId := Get_Spotify_Id()
		ControlFocus, , ahk_id %winId%
		ControlSend, , %hotkeyString%, ahk_id %winId%
		DetectHiddenWindows, Off
		return
	} 
	; FUNCTION: Get the ID of the Spotify window (using cache)
	Get_Spotify_Id() {
		if (Is_Spotify(cached_spotify_window)) {
			return cached_spotify_window
		}
		
		WinGet, windows, List, ahk_exe Spotify.exe
		Loop, %windows% {
			winId := windows%A_Index%
			if (Is_Spotify(winId)) {
				cached_spotify_window = %winId%
				return winId
			}
		}
	}
	; FUNCTION: Check if the given ID is a Spotify window
	Is_Spotify(winId) {
		WinGetClass, class, ahk_id %winId%
		if (class == "Chrome_WidgetWin_0") {
			WinGetTitle, title, ahk_id %winId%
			return (title != "")
		}
		return false
	}