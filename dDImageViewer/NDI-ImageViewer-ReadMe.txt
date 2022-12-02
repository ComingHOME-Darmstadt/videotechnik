NDI Drag&Drop Image Viewer

The latest (illustrated) version of this ReadMe can be accessed online at https://www.ndistuff.uk/zen-ndi-drag-drop-image-viewer/ (or press F1 while using the app's user interface)

IMPORTANT NOTES

1) This is a hobby project and I'm not a professional programmer, as a result of which:-

a) The software is supplied "as-is", and is not guaranteed to be fit for any particular purpose, nor to be bug-free (although bug-reports are welcome). Tested with Windows 10.

b) There is no "Installer", just a zipped folder containing the files I think you may need in order to run the .exe file. The folder can be located anywhere on your system, and you may wish to create a shortcut to the .exe file to make it quicker to run. You may need to allow network access for the program the first time you run it. As for the supporting .dll files, you will definitely need the included Processing.NDI.Lib.x86.dll file but I'm not sure what else. The reason for that is that I don't have enough computers to be able to test this process on a "clean" computer, only on those which already have other similar apps and/or the Microsoft Visual Studio 2017 edition which was used to create this code. If you get a message asking for a missing DLL, try installing the "vc_redist" run-time package from Microsoft (there's a link in the Installation Notes near the top of the zenvideo.co.uk/ndi.htm page) and, if you still have a problem, let me know.

2) This is a time-limited test version, valid for ten months after the month shown in the "About" window. . I will continue to upload newer builds as I revise the code, so each new one will (probably) have a new time limit, starting from the new build date. The About window is accessed by right-clicking top left to display the standard system menu, to which the “About NDI D&D Image Viewer” menu item is appended. Pressing the ‘E’ key with the About window open will show the time remaining in months.
  
3) Image files can be drag&dropped onto the preview window to output them as an NDI source, with an optional background. The NDI resolution is independent of the image size, and is set via a drop-down menu button, along with the NDI framerate. Supported image formats include bmp, gif, png & tif file formats, at up to 32bit/pixel (i.e. including alpha/transparency).

4) By default, the output will be in RGBA mode (RGB + alpha/transparency), so that any embedded alpha information in the image files is transmitted over NDI. If alpha information is not required (eg to feed a BirdDog NDI Decoder - one with firmware that doesn't accept RGBA format), there is a "No alpha output" option in the system menu (Rt click - top left). 

5) Different scaling modes are available. Images are centred on the output and maintain their original aspect ratio in all modes. 
	a) "None" will use the source image with 1:1 pixel sizing (i.e. no scaling). Images will have a border (i.e not fill the screen) or be cropped to fit, depending on the relative size of the image and the chosen NDI output resolution.
	b) "Contain" will scale the image with the aim of filling the screen, but without cropping, therefore leaving borders if the aspect ration doesn't match.     
	c) "Crop & Fill" will scale the image to fill the screen so that no borders remain. Parts of the source image will be cropped if the aspect ratio doesn't match the output.

6) Different background options are available, which will appear when the source image doesn't fill the screen. The options are selected from the menu button on the top right.
	a) "Black" is a solid black background.
	b) "Graduated Fill" uses two colours, which can be changed via the colour buttons below the Background menu button, and includes 3 patterns, each with the ability to quickly swap the colours via the respective "reversed" option.
	c) "Copy from grabbed" enables any image to be grabbed and used as a background. Drag and drop a suitable image in the usual way, then press the "Grab" button (which will change to show "Grabbed" when active), and then select the "Copy from grabbed" menu item to create a new background. Note that the background can include transparency - the grab function will take whatever is currently on the output.
	d) "None" is a transparent background.

7) The Cut/Fade transition button (lower left) selects between a straight cut and a short crossfade when a new image is loaded.

8) The Watch/Watching button enables a "watch" on the last loaded image file and, when active (green) will reload it if the file is updated.

9) The 0-255 / 16-235 button is for selecting source quantization level. Selecting 16-235 will convert the image to 0-255 using a simple 8-bit LUT (and therefore increase the contrast whilst clipping blacks below 16 and whites above 235).

10) Multiple instances of the Image Viewer can be run, and each will have auto-numbered NDI source names.

11) By default, the app window has the "Always on top" attribute set, but this can be changed in the system menu, right click top left.

12) There is a short video on the ZEN NDI Software Facebook Group page, showing the Image Viewer in use.

13) The current config/settings can be saved and loaded at startup using several options in the system menu (right click top left). Included in v1.1.x onwards.
	a) When "Use Last" is enabled, the various settings (eg Resolution, Framerate, Background, Cut/fade, etc) will be saved on exit to the "last.ziv" file. This file will be loaded on startup, if it exists, and if the "Use Last" setting had been applied, then the saved settings will be applied to the new session. When starting additional instances of the ImageViewer (eg. No 2, No 3, etc), the files are named "last2.ziv", "last3.ziv", etc, so that different configs can be loaded and saved for each instance. 
	b) When "Use Image" is enabled, the file path to the currently loaded image will also be saved in the "last.ziv" file, and will be reloaded (after a short delay) if it can be found when the file is reloaded at the start of a new session. 
	c) There is also a Command Line option that can be used, "/force_last", which will attempt to use the settings in the "last.ziv" file, even if the Use Last setting is not enabled in the file - which would normally result in it being ignored. The purpose of the option is to create a way to ensure that a particular configuration is always loaded on startup, irrespective of how (most of) the settings are changed during the session. To create a suitable "last.ziv" config file, apply the settings you require, but ensure "Use Last" is disabled, and then use the "Save config now" menu option to create a config file which, under normal circumstances, will be ignored, but will be forced to load (and the settings used) by the "/force_last" command line switch. Unless the "Use Last" menu option is re-enabled again, no new file will be saved on exit, so the same config will be loaded each time  
 
Martin Kay
ZEN Computer Services
www.zenvideo.co.uk

HISTORY

v1.0.0.1  12-Jan-2019   Initial release as an image viewer generating an NDI ouput.

v1.0.0.2  20-Jan-2019   Added a simple "Watch" function (polled every 3 secs) 

v1.0.1.3   8-Mar-1019   Added a "No alpha output" menu option

v1.0.2.4  21-Aug-2019   Recompiled with NDI v4.0 SDK - no other changes

v1.0.2.5   6-Oct-2019   Added 0-255 / 16-235 button for selecting source quantization level

v1.0.3.6   2-Feb-2020   Added 1080x1920 "vertical HD video" resolution and recompiled with NDI v4.15 SDK. 32 & 64 bit versions included.

v1.0.3.7  27-Sep-2020   Recompiled to extend expiry date and use the NDI v4.53 DLL.

v1.1.0.10 18-Mar-2021   Added "Use Last" & "Use Image" menu options for saving/loading config files. Also added F1 & system menu methods of accessing the ReadMe online, and sponsor ads at startup. Includes the NDI v4.62 DLL. 

v1.1.0.11 30-Oct-2021   Recompiled to extend expiry date and use the NDI v5.03 DLL. 64-bit only (no 32-bit version in this release)

v1.1.0.12  5-Sep-2022   Recompiled to extend expiry date and use the NDI v5.5 DLL. 64-bit only.