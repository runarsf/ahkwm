# ahkwm
<sup>[AutoHotkey](https://autohotkey.com/download/) v1.1.28.00 or higher required to run.
### An elegant way of combining AutoHotkey scripts.

## Installation Steps
1. Install [AutoHotKey](https://autohotkey.com/download/)
2. [Download](https://github.com/runarsf/ahkwm/archive/master.zip) the repo as a zip file or clone it with Git(Hub).
3. Extract the zip file into a directory you will remember.
4. Run the **ahkwm.ahk** file.
5. (Optional) To have the program run when you start up your computer, make a **shortcut** to the **host.ahk** file in your computer's startup folder. 
    * The Windows 7 Startup Folder can be accessed by opening **Start** > **All Programs**, then right-clicking on **Startup** and selecting **Open**.
    * For Windows 8 and up, the Startup Folder can be accessed by holding down the <kbd>Win</kbd> key and clicking <kbd>R</kbd>, then type `shell:startup` in the run box and press <kbd>Enter</kbd>.

## Adding *plugins*
* Drop the **plugin.ahk** file into the **user** folder.

## Adding source scripts
1. Drop the **source.ahk** file into the **src** folder.
2. Add `#Include, src\<src>.ahk` under the source section in **ahkwm.ahk**.
3. If multiple libraries have the same hotkeys, this might cause a problem, consider changing the import order.

## Updating the **setup.ahk** file
* Add a line on the bottom of the **setup.ahk** file with the corresponding variable value (case sensitive).
	* Integer
		1. Setup.nums("variable", "section", "lowest value:int", "highest value:int")

## Hotkeys
Hotkey | Function
------ | --------
<kbd>Win</kbd> + <kbd>Space</kbd> | Make active window **always on top**.

## Preinstalled library hotkeys
Library | Hotkey | Function
------- | ------ | --------
osu! | <kbd>NumpadDot</kbd> | **Left mouse button**.
osu! | <kbd>Shift</kbd> + <kbd>Apps</kbd> | Opens the **osu! GUI**.
osu! | <kbd>Apps</kbd> | Sends `!r <mod>`, the mod can be set in the osu! Gui.
osu! | <kbd>Numpad9</kbd> | Rebount to <kbd>Esc</kbd> when in osu!
osu! | <kbd>z</kbd> | Rebount to <kbd>Numpad2</kbd> when in osu!
osu! | <kbd>x</kbd> | Rebount to <kbd>Numpad1</kbd> when in osu!
spotify | <kbd>NumpadDot</kbd> + <kbd>NumpadMult</kbd> | Pause/Play media.
spotify | <kbd>NumpadDot</kbd> + <kbd>NumpadSub</kbd> | Next media.
spotify | <kbd>NumpadDot</kbd> + <kbd>NumpadDiv</kbd> | Previous media.
spotify | <kbd>NumpadDot</kbd> + <kbd>Numlock</kbd> | Stop media.
spotify | <kbd>NumpadDot</kbd> + <kbd>Numpad9</kbd> | Increase Spotify desktop sound.
spotify | <kbd>NumpadDot</kbd> + <kbd>Numpad6</kbd> | Decrease Spotify desktop sound.

Anything else? Feel free to contact me <sub>*(Discord: Rufus#5599)*</sub> or [submit an issue](https://github.com/runarsf/ahkwm/issues/new) on the GitHub repo!

<sub>ahkwm v2018.09</sub>