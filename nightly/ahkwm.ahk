#SingleInstance, Force       ; Only allow one running instance at a time
#Persistent                  ; Run script until ExitApp
#HotkeyInterval 1000         ; Display warning dialog after limit
#MaxHotkeysPerInterval 100   ; Display warning dialog after limit
#NoTrayIcon                  ; Disable tray icon
;#UseHook                     ; Forces the use of the hook to implement all or some keyboard hotkeys
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

Return

	SYS_ExitHandler:
		;Gosub, CFG_SaveSettings
	ExitApp

	/*
	 * [TRY] Tray
	 */

	TRY_TrayInit:
		Menu, Tray, NoStandard
		Menu, Tray, Tip, ahkwm nightly
		Menu, Tray, Icon, favicon.ico

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
		Menu, Features, Add, Set FFM Speed, TRY_TrayEvent
		Menu, Features, Add, Disable CapsLock, TRY_TrayEvent
		Menu, Features, Add, Super Move, TRY_TrayEvent
		Menu, Features, Add, Super Resize, TRY_TrayEvent
		Menu, Tray, Add, Features, :Features
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
			Gosub, CFG_SaveSettings
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
				Gui FFMSpeed:Cancel
				Gosub, CFG_ApplySettings
				Gosub, CFG_SaveSettings
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
	Return

	/*
	 * [CFG] Config
	 */

	CFG_LoadSettings:
		CFG_IniFile = %A_ScriptDir%\%SYS_ScriptNameNoExt%.ini
		IniRead, CFG_FocusFollowMouse, %CFG_IniFile%, Features, CFG_FocusFollowMouse, 0
		IniRead, CFG_FocusFollowMouseSpeed, %CFG_IniFile%, Features, CFG_FocusFollowMouseSpeed, 200
		IniRead, CFG_DisableCapsLock, %CFG_IniFile%, Features, CFG_DisableCapsLock, 0
		IniRead, CFG_SuperMove, %CFG_IniFile%, Features, CFG_SuperMove, 1
		IniRead, CFG_SuperResize, %CFG_IniFile%, Features, CFG_SuperResize, 1
	Return

	CFG_SaveSettings:
		CFG_IniFile = %A_ScriptDir%\%SYS_ScriptNameNoExt%.ini
		IniWrite, %CFG_FocusFollowMouse%, %CFG_IniFile%, Features, CFG_FocusFollowMouse
		IniWrite, %CFG_FocusFollowMouseSpeed%, %CFG_IniFile%, Features, CFG_FocusFollowMouseSpeed
		IniWrite, %CFG_DisableCapsLock%, %CFG_IniFile%, Features, CFG_DisableCapsLock
		IniWrite, %CFG_SuperMove%, %CFG_IniFile%, Features, CFG_SuperMove
		IniWrite, %CFG_SuperResize%, %CFG_IniFile%, Features, CFG_SuperResize
	Return

	CFG_ApplySettings:
		if ( CFG_FocusFollowMouse )
			SetTimer, FUN_FocusHandler, %CFG_FocusFollowMouseSpeed%
		else
			SetTimer, FUN_FocusHandler, Off
		if ( CFG_DisableCapsLock )
			Gosub, FUN_DisableCapsLock
		else
			Gosub, FUN_EnableCapsLock
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

	FUN_DisableCapsLock:
		SetCapsLockState, AlwaysOff
	Return

	FUN_EnableCapsLock:
		SetCapsLockState, Off
	Return

	#LButton::
	if winMove = 1
	{
		if WinActive("ahk_class WorkerW") 
		{
			return
		}
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
		return
	}
