GazePlotterWPF
==============

A simple application that plots gaze data coming out of The Eye Tribe API. It is written in C# using Visual Studio 2012 and requires .Net 3.5 or higher. 

Current functionality:
 - Left and right eye gaze X/Y coordinates (when calibrated)
 - Left and right eye pupil size
 - Crude blink detection based on momentarily lost tracking,
   flashing background to indicate a potential blink event.

![alt tag](http://theeyetribe.com/images/gazeplotter.PNG)
