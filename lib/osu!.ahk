SetTitleMatchMode 2

Class Osu {
	
	key(key) {
		sendInput, {%key% Down}
		sleep, 25
		sendInput, {%key% Up}
		sleep, 100
	}
	
	mod(key) {
		sendInput, {F1 Down}
		sleep, 25
		sendInput, {F1 Up}
		sleep, 50
		sendInput, {%key% Down}
		sleep, 25
		sendInput, {%key% Up}
		sleep, 50
		sendInput, {2 Down}
		sleep, 25
		sendInput, {2 Up}
	}
	
	add_set(collection, collectionSelected) {
		Osu.key("F3")
		sleep, 100
		Osu.key("1")
		sleep, 100
		
		ImageSearch, aX, aY, 0, 0, A_ScreenWidth, A_ScreenHeight, img\%collection%
		
		if aX <= 0
		{
			ImageSearch, aX, aY, 0, 0, A_ScreenWidth, A_ScreenHeight, img\%collectionSelected%
			if aX <= 0
			{
				Tippy("Collection not found.")
			}
		}
		if aX >= 1
		{
			MouseClick, Left, aX+765, aY+15
			Osu.key("2")
			return
		}
	}
	
	add_single(collection, collectionSelected) {
		Osu.key("F3")
		sleep, 100
		Osu.key("1")
		sleep, 100
		
		ImageSearch, aX, aY, 0, 0, A_ScreenWidth, A_ScreenHeight, img\%collection%
		
		if aX <= 0
		{
			ImageSearch, aX, aY, 0, 0, A_ScreenWidth, A_ScreenHeight, img\%collectionSelected%
			if aX <= 0
			{
				Tippy("Collection not found.")
			}
		}
		if aX >= 1
		{
			MouseClick, Left, aX+820, aY+15
			Osu.key("2")
			return
		}
	}
	
}

ButtonOK:
Gui, Submit, Nohide
IniWrite, %ShortcutGuiE%, config.ini, osu!, osumods
IniWrite, %ShortcutGui2%, config.ini, osu!, ovar
IniWrite, %osubinds%, config.ini, osu!, osubinds
reload
7GuiClose:
7GuiEscape:
Gui, Destroy
return

#IfWinActive, ahk_exe osu!.exe

+AppsKey::
ShortcutGui:
IniRead, mods, config.ini, osu!, osumods
IniRead, ovar, config.ini, osu!, ovar
IniRead, osubinds, config.ini, osu!, osubinds
Gui, +AlwaysOnTop +ToolWindow +LastFound +Caption
Gui, Color, 2f343f, 434852
WinSet, Transparent, 230
Gui, Font, s10 cWhite,
Gui, Add, Edit, r1 w150 vShortcutGuiE, %mods%
Gui, Add, Edit, r1 w150 vShortcutGui2, %ovar%
Gui, Add, Checkbox, x170 y12 vosubinds, Custom osu! binds

if osubinds = 1
	Control, Check,, Button1
else
	Control, UnCheck,, Button1

Gui, Show,, osu!gui
Gui, Add, Button, Default, OK
GuiControl, Hide, OK
return

,::Lbutton
.::RButton
AppsKey::otxt()
!AppsKey::over()

over() {
	IniRead, ovar, config.ini, osu!, ovar
	sleep, 100
	SendInput, %ovar%
	sleep, 100
	;Osu.key("Enter")
	sleep, 100
	return
}

otxt() {
	IniRead, mods, config.ini, osu!, osumods
	sleep, 100
	SendInput, {!}r %mods%
	sleep, 100
	Osu.key("Enter")
	sleep, 100
	return
}


NumpadIns::Numpad0
NumpadEnd::Numpad1
NumpadDown::Numpad2
NumpadPgDn::Numpad3
NumpadLeft::Numpad4
NumpadClear::Numpad5
NumpadRight::Numpad6
NumpadHome::Numpad7
NumpadUp::Numpad8
NumpadPgUp::Numpad9

Numpad3::Numpad2
NumpadDot::LButton
Numpad9::Escape
return

#IfWinActive