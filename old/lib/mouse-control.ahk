SetBatchLines -1
#UseHook
Increment = 1 ; number of pixels to move mouse....gets multiplied depending on keypress length
MouseDelay = 0

Left::
Right::
Up::
Down::
xVal=
yVal=
If GetKeyState("CapsLock","T")
	{
		IncrementValue := Increment ; Set the Increment value (we change it)
		; Infinite loop....breaks when key not pressed anymore
		Loop, 
		{
		If (A_Index > IncrementValue * 15) and (IncrementValue < Increment * 5) ; Increase the Increment value depending on how long we held down the key
			IncrementValue := IncrementValue * 2
		If GetKeyState("Down", "P")
			yVal := IncrementValue
		Else If GetKeyState("Up", "P")
			yVal := -IncrementValue
		If !yVal
			yVal := 0
		If GetKeyState("Left", "P")
			xVal := -IncrementValue
		Else If GetKeyState("Right", "P")
			xVal := IncrementValue
		If !xVal
			xVal := 0
		If GetKeyState(A_ThisHotKey, "P") ; Make sure we are still pressing the key
			MouseMove, %xVal%, %yVal%,%MouseDelay%,R
		Else ; we're not pressing the key...break the loop
			Break
		}
	}
Else
	Send % "{" . A_ThisHotKey . "}"
return