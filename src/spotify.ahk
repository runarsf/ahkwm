#SingleInstance Force
#Persistent
#InstallKeybdHook
; menu, tray, Icon, %A_ScriptDir%\icons\Spotify.ico

; Volume Up/Down (u and d only examples here)
NumpadDot & NumpadSub::send, {Media_Next}
NumpadDot & NumpadDiv::send, {Media_Prev}
NumpadDot & NumpadMult::send, {Media_Play_Pause}
NumpadDot & NumLock::send, {Media_Stop}
NumpadDot & Numpad9::Spotify_HotkeySend("^{Up}")
NumpadDot & Numpad6::Spotify_HotkeySend("^{Down}")

; Global variable to cache the Spotify Window ID once it's been found
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