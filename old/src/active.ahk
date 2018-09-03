Class Active {
	
	norm(prog, loc) {
		IfWinNotExist %prog%
			run, %loc%
		WinWait %prog%
		WinActivate %prog%
		IfWinExist %prog%
			WinActivate %prog%
		return
	}
	
	browser(prog, loc) {
		IfWinActive %prog%
			send, ^{tab}
		IfWinNotExist %prog%
			run, %loc%
		WinWait %prog%
		WinActivate %prog%
		IfWinExist %prog%
			WinActivate %prog%
		return
	}
	
	explorer() {
		IfWinNotExist, ahk_class CabinetWClass
			run, explorer.exe
		GroupAdd, explort, ahk_class CabinetWClass
		if WinActive("ahk_exe explorer.exe")
			GroupActivate, explort, r
		else
			WinActivate ahk_class CabinetWClass
		return
	}
	
}