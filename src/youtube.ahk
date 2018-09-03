#IfWinActive, ahk_exe firefox.exe
Space::
yt := "YouTube"
WinGetActiveTitle, act

IfInString, act, %yt%
{
	ImageSearch, aX, aY, 0, 0, A_ScreenWidth, A_ScreenHeight, img\yt.png
	if aX >= 1
	{
		;ControlSend, , {Space} , Firefox
		;MouseClick, Left, A_ScreenWidth, A_ScreenHeight
		SendInput, k
		return
	}
	else
	{
		SendEvent, {Space}
	}
	return
}
IfNotInString, act, %yt%
{
	SendEvent, {Space}
}
#IfWinActive