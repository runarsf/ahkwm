barstate := 0
submenu := 1



if wmPreloadBar = 1
	Gosub, gui_bar
else
	return
return

gui_bar:
if barstate = 0
{
	barstate := 1
	Gui, +AlwaysOnTop +ToolWindow +LastFound +Caption -DPIScale
	Gui, Color, %bgcolor%, %bgcolor%
	
	Gui, Font, s12
	Gui, Add, Text, %fgcolor% x1909 y-2 gSubmenu, = ; FIX x1909
	Gui, Font, s9
	
	Gui, Show, w0 h0 y0 x0, BarGui ; Add option to change screen
	WinSet, Style, -0xC00000, A
	WinMove, A,, 0, %1080p%, %A_ScreenWidth%, 15 ; FIX %1080p%, %A_ScreenWidth%
	
	#Include lib\nums.ahk
	
	return
}
else if barstate = 1
{
	Gui, Submit, NoHide
	Gui, Destroy
	barstate := 0
	return
}
return


/* 
	*	LABELS
*/

Submenu:
if submenu = 0
{
	Gui 2: Submit, NoHide
	Gui 2: Destroy
	submenu := 1
	return
}
else if submenu = 1 
{
	Gui 2: +AlwaysOnTop +ToolWindow +LastFound +Caption +LabelGui -DPIScale
	Gui 2: Color, %bgcolor%, %bgcolor%
	Gui 2: Font, s9, Consolas
	
	Gui 2: Add, Text, x4 y3 gExitApp, ExitApp
	Gui 2: Add, Text, x4 y20 gTrayReload, Reload
	Gui 2: Add, Text, x4 y37 gTrayEdit, Edit
	Gui 2: Add, Text, x4 y54 gTraySettings, Settings
	Gui 2: Add, Text, x4 y71 gExplore, Explore
	Gui 2: Add, Text, x4 y88 gtogglebar, togglebar
	
	Gui 2: Show, w200 h150 x1720 y886, Submenu
	WinSet, Style, -0xC00000, Submenu
	submenu := 0
	return
}
return

togglebar:
Gui 2: Submit, NoHide
Gui 2: Destroy
submenu := 1
Gui, Submit, NoHide
Gui, Destroy
barstate := 1
return

Explore:
run, %A_ScriptDir%
gosub, 2GuiEscape
return

GuiEscape:
2GuiEscape:
Gui 2: Submit, NoHide
Gui 2: Destroy
submenu := 1
return