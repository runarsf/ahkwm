/**
 * Advanced Window Snap (Extended
 * Snaps the Active Window to one of nine different window positions.
 *
 * @Editing author Jarrett Urech
 * @Original author Andrew Moore <andrew+github@awmoore.com>
 * @version 2.1
 *
**/

/**
 * SnapActiveWindow resizes and moves (snaps) the active window to a given position.
 * @param {string} winPlaceVertical   The vertical placement of the active window.
 *                                    Expecting "bottom" or "middle", otherwise assumes
 *                                    "top" placement.
 * @param {string} winPlaceHorizontal The horizontal placement of the active window.
 *                                    Expecting "left" or "right", otherwise assumes
 *                                    window should span the "full" width of the monitor.
 * @param {string} winSizeHeight      The height of the active window in relation to
 *                                    the active monitor's height. Expecting "half" size,
 *                                    otherwise will resize window to a "third".
 */

#NoEnv
#MaxThreads 1


SnapActiveWindow(winPlaceVertical, winPlaceHorizontal, winSizeHeight, activeMon := 0) {
    WinGet activeWin, ID, A
	SysGet, MonitorCount, MonitorCount
	
    if (!activeMon) {
		activeMon := GetMonitorIndexFromWindow(activeWin)
	} else if (activeMon > MonitorCount) {
		activeMon := 1
	}
	
    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMon%
	
    if (winSizeHeight == "half") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)/2
    } else if (winSizeHeight == "third") {
        height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)/3
    } else {
		height := (MonitorWorkAreaBottom - MonitorWorkAreaTop)
	}

    if (winPlaceHorizontal == "left") {
        posX  := MonitorWorkAreaLeft
        width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2
    } else if (winPlaceHorizontal == "right") {
        posX  := MonitorWorkAreaLeft + (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2
        width := (MonitorWorkAreaRight - MonitorWorkAreaLeft)/2
    } else {
        posX  := MonitorWorkAreaLeft
        width := MonitorWorkAreaRight - MonitorWorkAreaLeft
    }

    if (winPlaceVertical == "bottom") {
        posY := MonitorWorkAreaBottom - height
    } else if (winPlaceVertical == "middle") {
        posY := MonitorWorkAreaTop + height
    } else {
        posY := MonitorWorkAreaTop
    }
	
	; Rounding
	posX := floor(posX)
	posY := floor(posY)
	width := floor(width)
	height := floor(height)
	
	; Borders (Windows 10)
	SysGet, BorderX, 32
	SysGet, BorderY, 33
	if (BorderX) {
		posX := posX - BorderX
		width := width + (BorderX * 2)
	}
	if (BorderY) {
		height := height + BorderY
	}
	
	; If window is already there move to same spot on next monitor
	WinGetPos, curPosX, curPosY, curWidth, curHeight, A
	if ((posX = curPosX) && (posY = curPosY) && (width = curWidth) && (height = curHeight)) {
		activeMon := activeMon + 1
		SnapActiveWindow(winPlaceVertical, winPlaceHorizontal, winSizeHeight, activeMon)
	} else {
		WinMove,A,,%posX%,%posY%,%width%,%height%
	}
}

/**
 * GetMonitorIndexFromWindow retrieves the HWND (unique ID) of a given window.
 * @param {Uint} windowHandle
 * @author shinywong
 * @link http://www.autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355
 */
GetMonitorIndexFromWindow(windowHandle) {
    ; Starts with 1.
    monitorIndex := 1

    VarSetCapacity(monitorInfo, 40)
    NumPut(40, monitorInfo)

    if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
        && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) {
        monitorLeft   := NumGet(monitorInfo,  4, "Int")
        monitorTop    := NumGet(monitorInfo,  8, "Int")
        monitorRight  := NumGet(monitorInfo, 12, "Int")
        monitorBottom := NumGet(monitorInfo, 16, "Int")
        workLeft      := NumGet(monitorInfo, 20, "Int")
        workTop       := NumGet(monitorInfo, 24, "Int")
        workRight     := NumGet(monitorInfo, 28, "Int")
        workBottom    := NumGet(monitorInfo, 32, "Int")
        isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

        SysGet, monitorCount, MonitorCount

        Loop, %monitorCount% {
            SysGet, tempMon, Monitor, %A_Index%

            ; Compare location to determine the monitor index.
            if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
                and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom)) {
                monitorIndex := A_Index
                break
            }
        }
    }
	
    return %monitorIndex%
}

dynamicPickup(initial:=0) {
	; Pickup the initial keypress
	pressed%initial% := true
	
	; Disable Additional Presses
	loop 9
		Hotkey, ^#Numpad%A_Index%, dynamicPickup, Off
	
	; Pickup Areas
	while (GetKeyState("Control") || GetKeyState("LWin") || GetKeyState("RWin")) {
		if (GetKeyState("Numpad1"))
			pressed1 := true
		if (GetKeyState("Numpad2"))
			pressed2 := true
		if (GetKeyState("Numpad3"))
			pressed3 := true
		if (GetKeyState("Numpad4"))
			pressed4 := true
		if (GetKeyState("Numpad5"))
			pressed5 := true
		if (GetKeyState("Numpad6"))
			pressed6 := true
		if (GetKeyState("Numpad7"))
			pressed7 := true
		if (GetKeyState("Numpad8"))
			pressed8 := true
		if (GetKeyState("Numpad9"))
			pressed9 := true
	}
	
	; Calc Window Height
	height:=0
	if ((pressed1 || pressed2 || pressed3) && (pressed7 || pressed8 || pressed9)) {
		height := 3
	} else {
		if (pressed1 || pressed2 || pressed3)
			height := height + 1
		if (pressed4 || pressed5 || pressed6)
			height := height + 1
		if (pressed7 || pressed8 || pressed9)
			height := height + 1
	}
		
	
	; Calc Window Width
	width:=0
	if ((pressed1 || pressed4 || pressed7) && (pressed3 || pressed6 || pressed9)) {
		width := 3
	} else {
		if (pressed1 || pressed4 || pressed7)
			width := width + 1
		if (pressed2 || pressed5 || pressed8)
			width := width + 1
		if (pressed3 || pressed6 || pressed9)
			width := width + 1
	}
	
	; Calc Anchor Point (matches numpad for zones) (order matters here)
	anchor := 0
	if (pressed3 && (height = 1))
		anchor := 9
	if (pressed2 && (height = 1))
		anchor := 8
	if (pressed1 && (height = 1))
		anchor := 7
	if (pressed6 && (height < 3))
		anchor := 6
	if ((pressed5 || (pressed2 && pressed6)) && (height < 3))
		anchor := 5
	if ((pressed4 || (pressed1 && (pressed5 || pressed6))) && (height < 3))
		anchor := 4
	if (pressed9)
		anchor := 3
	if (pressed8 || (pressed9 && (pressed5 || pressed2)))
		anchor := 2
	if (pressed7 || ((pressed4 || pressed1) && (pressed8 || pressed9)))
		anchor := 1
		
	; Set This window up!
	SnapActiveWindowAdvanced(anchor, width, height)
	
	; Enable Hotkeys
	loop 9
		Hotkey, ^#Numpad%A_Index%, dynamicPickup, On
}

SnapActiveWindowAdvanced(anchor, widthUnit, heightUnit, snapGrid := 3,activeMon := 0) {
	; SnapGrid units are the width/height of the active monitor evenly split into the snapgrid number
	; Width and Height is multiples of snapGrid units
	; The anchor points are arranged in order from left to right, top to bottom
	
    WinGet activeWin, ID, A
	SysGet, MonitorCount, MonitorCount
	
    if (!activeMon) {
		activeMon := GetMonitorIndexFromWindow(activeWin)
	} else if (activeMon > MonitorCount) {
		activeMon := 1
	}
	
    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMon%
	
	; Snap Units
	unitX := (MonitorWorkAreaRight - MonitorWorkAreaLeft) / snapGrid
	unitY := (MonitorWorkAreaBottom - MonitorWorkAreaTop) / snapGrid
	
	; Resolve Anchor
	posX := MonitorWorkAreaLeft + (unitX * Mod(anchor - 1, snapGrid))
	posY := MonitorWorkAreaTop + (unitY * floor((anchor - 1) / snapGrid) - 1)

	; Calculate size as a percentage of the screen
	width := (MonitorWorkAreaLeft + (unitX * (Mod(anchor - 1, snapGrid) + widthUnit))) - posX
	if ((posX + width) > (MonitorWorkAreaRight - 50))
		width := MonitorWorkAreaRight - (posX - 1)
	
	height := (MonitorWorkAreaTop + (unitY * (floor((anchor - 1) / snapGrid) + heightUnit) - 1)) - posY
	if ((posY + height) > (MonitorWorkAreaBottom - 50))
		height := MonitorWorkAreaBottom - (posY - 1)
	
	; Clover Special Case [START] (http://en.ejie.me)
	; If the internal windows explorer window is selected then switch to clover wrapper
	IfWinActive, ahk_class CabinetWClass ahk_exe explorer.exe
	{
		WinGetPos, expX, expY,,, A
		WinGet, id, list,,, Program Manager
		Loop, %id% {
			this_id := id%A_Index%
			WinGetPos, clovX, clovY,,, ahk_id %this_id%
			if (((expX - 8) = clovX) && ((expY - 18) = clovY)) {
				WinActivate, ahk_id %this_id%
				break
			}
		}
	}
	; Adjust limits to accomodate the wrapper dimensions
	IfWinActive, ahk_class Clover_WidgetWin_0 ahk_exe clover.exe
	{
		posX := posX + 2
		width := width - 4
		height := height - 3
	}
	; Clover Special Case [END]
	
	; Borders (Windows 10)
	SysGet, BorderX, 32
	SysGet, BorderY, 33
	if (BorderX) {
		posX := (posX + 1) - BorderX
		width := (width - 2) + (BorderX * 2)
	}
	if (BorderY) {
		height := height + BorderY
	}
	
	; Rounding
	posX := floor(posX)
	posY := floor(posY)
	width := floor(width)
	height := floor(height)
	
	; If window is already there move to same spot on next monitor
	WinGetPos, curPosX, curPosY, curWidth, curHeight, A
	if ((posX = curPosX) && (posY = curPosY) && (width = curWidth) && (height = curHeight)) {
		activeMon := activeMon + 1
		SnapActiveWindowAdvanced(anchor, widthUnit, heightUnit, snapGrid, activeMon)
	} else {
		WinRestore, A
		WinMove,A,,%posX%,%posY%,%width%,%height%
	}
}

; Dynamic Snapping
loop 9
	Hotkey, ^#Numpad%A_Index%, dynamicPickup, On
return

; Dynamic Hook Function
dynamicPickup:
	dynamicPickup(SubStr(A_ThisHotkey,0))
return

; Directional Arrow Hotkeys
#!Up::SnapActiveWindow("top","full","half")
#!Down::SnapActiveWindow("bottom","full","half")

; Numberpad Hotkeys (Landscape)
#!Numpad7::SnapActiveWindow("top","left","half")
#!Numpad8::SnapActiveWindow("top","full","half")
#!Numpad9::SnapActiveWindow("top","right","half")
#!Numpad1::SnapActiveWindow("bottom","left","half")
#!Numpad2::SnapActiveWindow("bottom","full","half")
#!Numpad3::SnapActiveWindow("bottom","right","half")
#!Numpad4::SnapActiveWindow("top","left","full")
#!Numpad6::SnapActiveWindow("top","right","full")

; Numberpad Hotkeys (Portrait)
^#!Numpad8::SnapActiveWindow("top","full","third")
^#!Numpad5::SnapActiveWindow("middle","full","third")
^#!Numpad2::SnapActiveWindow("bottom","full","third")
^#!Numpad7::SnapActiveWindow("top","left","third")
^#!Numpad4::SnapActiveWindow("middle","left","third")
^#!Numpad1::SnapActiveWindow("bottom","left","third")
^#!Numpad9::SnapActiveWindow("top","right","third")
^#!Numpad6::SnapActiveWindow("middle","right","third")
^#!Numpad3::SnapActiveWindow("bottom","right","third")