AirKey - maps gestures to hotkeys, also provides a basic mouse interface. 

Video-Tutorial, introduction and more at http://bit.ly/1eT6TI8

In the 'bin'-folder you find a precompiled executable, which can be hidden by pressing h. To bring it back press CTRL, ALT and L. Keybindings can be modified in the file "AirKey.xml" by setting the "attr"-objects. You also find comments in there, should be pretty self explanatory. Virtual Key Codes can be found in VirtKeyCodes.txt.

For mouse-control move your finger towards the screen (zone starts 10 mm behind the Leap, configurable), clicking is implemented using the thumb (spread out = default, click after moving thumb towards hand). To right-click, also extend another finger (ie http://i115.photobucket.com/albums/n313/TheRockOns/rock-1.jpg) and do the trigger-motion.
If you move your finger horizontally, it's a click, if you move it downwards (arc-like motion), the mouse button is kept pressed. You can configure it to behave the other way round (click by extention).

If you want to modify the code, use Visual Studio Express 2012 (free, from Microsoft). 

Current troubles: 

-) No GUI (there is one written by "Sharp", can be found at http://www.irishacts.com/misc/airkey-gui.exe)


Feedback welcome, either here in the Discussion or at forums.leapmotion.com

CHANGELOG - for more information on each change visit http://bit.ly/1eT6TI8 (!RECOMMENDED!)

v0.9:
-) More robust hand detection algorithm
-) More robust clicking detection, now also work with hand pointint to the side. Trigger distance can be set using triggerSensitivity
-) Click-and-hold trigger added - if you keep your thumb extended, it triggers click-and-hold (not releasing the key, for dragging, selecting multiple items etc)
-) Fixed screen size calculation bug in touch mode

v0.8:
-) Changes in the way the pointing finger is stored, should be more robust.
-) Touchscreen mode - by entering s you start the screen calibration, which then works like a touchscreen. Details can be found  in the thread.
-) Start menu not movable any more.
-) Hand detection7gestures only in the center of the field of view of the Leap (InteractionBox).

v0.7:
-) Bugfixes
-) Possibility to drag window
-) Added menu to choose config files if Sharp's GUI is not used (or someone wants to change them quickly)
-) Added the possibility to execute one of three batch (.bat)-files in the AirKey directory using a gesture (VirtKeyCodes 256-258).

v0.6b:
-) Bugfixes
-) Possibility to disable timeout gesture, and to toggle tracking in console

v0.6:
-) Double Click - enter 512 as a mouse-keycode, don't mix with keepPressed/release.
-) Pause tracking with a new gesture - "time-out".
-) Huge bugfixes, especially while using two hands simultaneously. 

v0.5b:
-) Bugfix

v0.5:
-) Mouse Wheel now works
-) The middle click now does what it's supposed to. 
-) Modifier keys in combination with the mouseclicks now work.
-) Improvements (hopefully) in gesture-behavior in multihand-mode.

v0.4:
-) Clap and fistbump gestures
-) Real hand detection
-) Easier right click (just use any finger)
-) Multifinger gestures in mouse mode
-) Bugfixes (win+shift+arrows work now, bug in normal trigger mode fixed)

v0.3:
-) Multifinger support! If you perform gestures with more than 3 fingers outstretched (= your whole hand), you can assign different hotkeys to the gestures.
-) Thumb-Trigger mode reversable.
-) ScreenTap and KeyTap enabled in Mouse Mode, which different actions possible.
-) Customizable delay after each command. If you get multiple executions of the same gesture, try increasing it.
-) 2 commands in the program: Reloading the config-file (ie after modification), and hiding the console window on command.

v0.2:
-) Support for lefthanded users (set "Lefthanded" in the config file to true)

-) Mouseclick/Mousepress distinction by moving the thumb downwards/just horizontally added.

-) Change in the keepPressed-syntax: You don't need setting "release" anymore. A key which has "keepPressed" enabled will be kept pressed until the same gesture is executed again. In general, keeping a keyboard key pressed should work now as well. The old syntax for "release" still works (if you want to define the release to a different gesture), however I don't recommend using it.



