# ahkwm
<sup>[AutoHotkey](https://autohotkey.com/download/) v1.1.28.00 or higher required to run.

#### A neat way of managing your Windows environment through the art of [bodging](https://www.youtube.com/watch?v=lIFE7h3m40U) and [AHK](https://www.autohotkey.com/).

## Installation Steps
1. Install [AutoHotKey](https://autohotkey.com/download/)
2. [Download](https://github.com/runarsf/ahkwm/archive/master.zip) the repo as a zip file and extract it, or clone it with git.
3. Run the **ahkwm.ahk** file.
4. (Optional) To have the program run when you start up your computer, make a shortcut to the *ahkwm.ahk* file in your computer's startup folder.
    * The Windows 7 Startup Folder can be accessed by opening **Start** > **All Programs**, then right-clicking on **Startup** and selecting **Open**.
    * For Windows 8 and up, the Startup Folder can be accessed by holding down the <kbd>Win</kbd> key and clicking <kbd>R</kbd>, then type `shell:startup` in the run box and press <kbd>Enter</kbd>.

## Importing files
1. Drop the **.ahk** file into the **src** folder.
2. Add `#Include, src\<file>.ahk` under the import section in **ahkwm.ahk**.

## Adding .ini keys
* Add a line on the bottom of the **setup.ahk** file with the corresponding variable value (case sensitive).
	* Integer
		1. Setup.nums("variable", "section", "lowest value: int", "highest value: int")

## Hotkeys
Hotkey | Function
------ | --------
<kbd>Win</kbd> + <kbd>Space</kbd> | Make active window **always on top**.
<kbd>Win</kbd> + <kbd>f</kbd> | **Maximize** / **restore down** window.
<kbd>Win</kbd> + <kbd>LButton</kbd> | Move active window with cursor.
<kbd>Win</kbd> + <kbd>RButton</kbd> | Resize active window. Has two resize modes.
<kbd>MButton</kbd> on taskbar | Open task manager.
<kbd>Win</kbd> + <kbd>Del</kbd> | Empty recycle bin.

## Preinstalled library hotkeys
Library | Hotkey | Function
------- | ------ | --------
media | <kbd>NumpadDot</kbd> + <kbd>NumpadMult</kbd><br/><kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>k</kbd> | Pause/Play media.
media | <kbd>NumpadDot</kbd> + <kbd>NumpadSub</kbd><br/><kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>l</kbd> | Next media.
media | <kbd>NumpadDot</kbd> + <kbd>NumpadDiv</kbd><br/><kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>j</kbd> | Previous media.
media | <kbd>NumpadDot</kbd> + <kbd>Numlock</kbd> | Stop media.
media | <kbd>NumpadDot</kbd> + <kbd>Numpad9</kbd><br/><kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>w</kbd> | Increase Spotify desktop sound.
media | <kbd>NumpadDot</kbd> + <kbd>Numpad6</kbd><br/><kbd>Alt</kbd> + <kbd>Shift</kbd> + <kbd>s</kbd> | Decrease Spotify desktop sound.
osu! || Only affects hotkeys when in-game.
osu! | <kbd>NumpadDot</kbd> | **Left mouse button**.
osu! | <kbd>Shift</kbd> + <kbd>Apps</kbd> | Opens the **osu! GUI**.
osu! | <kbd>Apps</kbd> | Sends `!r <mod>`, the mod can be set in the osu! GUI.
osu! | <kbd>Numpad9</kbd> | Rebount to <kbd>Esc</kbd>.
osu! | <kbd>z</kbd> | Rebount to <kbd>Numpad2</kbd>.
osu! | <kbd>x</kbd> | Rebount to <kbd>Numpad1</kbd>.

<sub>ahkwm v2019.06</sub>
