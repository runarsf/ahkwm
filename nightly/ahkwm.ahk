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
#Delete::FUN_EmptyRecycleBin()
#LButton::FUN_SuperMove()
#RButton::FUN_SuperResize()
#f::FUN_FullscreenToggle()
#Space::FUN_AlwaysOnTop()
#WheelUp::FUN_IncreaseOpacity()
#WheelDown::FUN_DecreaseOpacity()
#If WinActive("ahk_class Shell_TrayWnd") or WinActive("ahk_class Shell_SecondaryTrayWnd") and WinActive("ahk_exe explorer.exe")
WheelUp::FUN_IncreaseVolume()
WheelDown::FUN_DecreaseVolume()
~+MButton Up::FUN_AudioDevices()
~MButton Up::FUN_TaskManager()
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
			Menu, AutoHotkey, Standard
			Menu, Tray, Add, AutoHotkey, :AutoHotkey
			Menu, Tray, Add
		}

		;Menu, Feedback, Add, GitHub, TRY_TrayEvent
		;Menu, Feedback, Add, Mail, TRY_TrayEvent
		; license, check if file exist, or open website
		;Menu, Tray, Add, Feedback, :Feedback

		Menu, Features, Add, Focus Follow Mouse, TRY_TrayEvent
		Menu, Features, Add, Disable CapsLock, TRY_TrayEvent
		Menu, Features, Add, Super Move, TRY_TrayEvent
		Menu, Features, Add, Super Resize, TRY_TrayEvent
		Menu, Features, Add, Super Del Empty Recycle Bin, TRY_TrayEvent
		Menu, Features, Add, Shift MButton Taskbar Audio Devices, TRY_TrayEvent
		Menu, Features, Add, MButton Taskbar Task Manager, TRY_TrayEvent
		Menu, Features, Add, Super F Fullscreen Toggle, TRY_TrayEvent
		Menu, Features, Add, Super Space Always On Top, TRY_TrayEvent
		Menu, Features, Add, Super Wheel Opacity Control, TRY_TrayEvent
		Menu, Tray, Add, Features, :Features
		Menu, Options, Add, Set FFM Speed, TRY_TrayEvent
		Menu, Options, Add, Set Resize Method, TRY_TrayEvent
		Menu, Tray, Add, Options, :Options
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
		if ( A_ThisMenuItem = "Super Del Empty Recycle Bin" )
		{
			CFG_EmptyRecycleBin := !CFG_EmptyRecycleBin
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Shift MButton Taskbar Audio Devices" )
		{
			CFG_AudioDevices := !CFG_AudioDevices
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "MButton Taskbar Task Manager" )
		{
			CFG_TaskManager := !CFG_TaskManager
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Super F Fullscreen Toggle" )
		{
			CFG_FullscreenToggle := !CFG_FullscreenToggle
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Super Space Always On Top" )
		{
			CFG_AlwaysOnTop := !CFG_AlwaysOnTop
			Gosub, CFG_ApplySettings
		}
		if ( A_ThisMenuItem = "Super Wheel Opacity Control" )
		{
			CFG_OpacityControl := !CFG_OpacityControl
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
			Menu, Features, Check, Super Del Empty Recycle Bin
		else
			Menu, Features, UnCheck, Super Del Empty Recycle Bin
		
		if ( CFG_AudioDevices )
			Menu, Features, Check, Shift MButton Taskbar Audio Devices
		else
			Menu, Features, UnCheck, Shift MButton Taskbar Audio Devices
		
		if ( CFG_TaskManager )
			Menu, Features, Check, MButton Taskbar Task Manager
		else
			Menu, Features, UnCheck, MButton Taskbar Task Manager
		
		if ( CFG_FullscreenToggle )
			Menu, Features, Check, Super F Fullscreen Toggle
		else
			Menu, Features, UnCheck, Super F Fullscreen Toggle
		
		if ( CFG_AlwaysOnTop )
			Menu, Features, Check, Super Space Always On Top
		else
			Menu, Features, UnCheck, Super Space Always On Top
		
		if ( CFG_OpacityControl )
			Menu, Features, Check, Super Wheel Opacity Control
		else
			Menu, Features, UnCheck, Super Wheel Opacity Control
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

		if ( CFG_SuperMove )
			Hotkey, #LButton, On
		else
			Hotkey, #LButton, Off
	
		if ( CFG_SuperResize )
			Hotkey, #RButton, On
		else
			Hotkey, #RButton, Off

		if ( CFG_EmptyRecycleBin )
			Hotkey, #Delete, On
		else
			Hotkey, #Delete, Off
		
		/*
		if ( CFG_AudioDevices )
			Hotkey, ~+MButton Up, On
		else
			Hotkey, ~+MButton Up, Off
		
		if ( CFG_TaskManager )
			Hotkey, ~MButton Up, On
		else
			Hotkey, ~MButton Up, Off
		*/
		
		if ( CFG_FullscreenToggle )
			Hotkey, #f, On
		else
			Hotkey, #f, Off
		
		if ( CFG_AlwaysOnTop )
			Hotkey, #Space, On
		else
			Hotkey, #Space, Off
		
		if ( CFG_OpacityControl )
		{
			Hotkey, #WheelUp, On
			Hotkey, #WheelDown, On
		}
		else
		{
			Hotkey, #WheelUp, Off
			Hotkey, #WheelDown, Off
		}
		
		/*
		if ( CFG_VolumeControl )
		{
			Hotkey, WheelUp, On
			Hotkey, WheelDown, On
		}
		else
		{
			Hotkey, WheelUp, Off
			Hotkey, WheelDown, Off
		}
		*/
	Return

	/*
	 * [FUN] Custom functions
	 */

	/*
	FUN_FocusHandler:
		MouseGetPos,,, WinUMID
		WinActivate, ahk_id %WinUMID%
	Return
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
	
	FUN_IncreaseVolume()
	{
		MouseGetPos,,, Win
		if (WinExist("ahk_class Shell_TrayWnd ahk_id " . Win))
			Send {Volume_Up}
	}
	
	FUN_DecreaseVolume()
	{
		MouseGetPos,,, Win
		if (WinExist("ahk_class Shell_TrayWnd ahk_id " . Win))
			Send {Volume_Down}
	}