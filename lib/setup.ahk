Class Setup {
	nums(varchar, section, min, max) {
		IniRead, %varchar%, config.ini, %section%, %varchar%
		if %varchar% < %min%
			IniWrite, %min%, config.ini, %section%, %varchar%
		if %varchar% > %max%
			IniWrite, %max%, config.ini, %section%, %varchar%
		else
			return
		IniRead, %varchar%, config.ini, %section%, %varchar%
	}
}
Setup.nums("winOnTop", "Settings", "0", "1")
Setup.nums("winMaxMin", "Settings", "0", "1")
Setup.nums("winMove", "Settings", "0", "1")
Setup.nums("winResize", "Settings", "0", "2")