Class Setup {
	
	nums(varchar, section, min, max) {
		IniRead, %varchar%, config.ini, %section%, %varchar%,
		if %varchar% not between %min% and %max%
			IniWrite, %min%, config.ini, %section%, %varchar%
		if %varchar% > %max%
			IniWrite, %max%, config.ini, %section%, %varchar%
		else
			return
	}
	
	text(varchar, section, min, max) {
		IniRead, %varchar%, config.ini, %section%, %varchar%,
		if %varchar% not between %min% and %max%
			IniWrite, %min%, config.ini, %section%, %varchar%
		if %varchar% > %max%
			IniWrite, %max%, config.ini, %section%, %varchar%
		else
			return
	}
	
}
Setup.nums("wmOnTop", "Settings", "0", "1")
Setup.nums("wmMaxiMin", "Settings", "0", "1")
Setup.nums("wmWinMove", "Settings", "0", "1")
Setup.nums("wmResize", "Settings", "0", "2")
Setup.nums("SavedVolume", "Settings", "0", "100")
Setup.nums("wmNoBorder", "Settings", "0", "1")
Setup.nums("wmPreloadBar", "Settings", "0", "1")