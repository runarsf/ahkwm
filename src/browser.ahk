#IfWinActive, ahk_exe chrome.exe
F1::Send, {Control Down}l{Control Up}			; open search field
F2::Send, {Control Down}l{Control Up}o{Space}	; open search field > omnitab
#IfWinActive