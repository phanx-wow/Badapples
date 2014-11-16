### Version 6.0.2.13

* Updated for WoW 6.0
* Added Russian translations

### Version 5.4.1.10

* Updated for WoW 5.4
* Added German and Spanish translations
* Removed a bunch of old broken code

### Version 5.2.0.7

* Updated for WoW 5.1

### Version 5.0.5.4

* It's alive!

-----

Versions 3.2.0 and earlier were published by Cirk, the original author of Badapples.

### Version 3.2.0

* Changed warning visibility by making text messages red
* Changed notification function to improve visual aspects of warnings and to add a (red) warning message on the UI errors frame as well for party and raid member alerts
* Changed default badapple color to dark greyish-green
* Increased warning interval between warning of the same player to 10 seconds
* Replaced ChatFrame_MessageEventHandler hooking with GetColoredName hooking instead, to simplify code
* Fixed bug in invite check popup where it wasn't passing on the YES action (thanks Oxides)
* Code cleanups for popup definitions and other minor stuff
* Changed version string to 3.2.0

### Version 3.1.0

* Added an entry for Blizzard's interface options screen that shows a list of the slash commands, tidied up the help text, removed the normal addon "announce".
* Drop-down list code now uses UIDropDownMenu_CreateInfo()
* Changed version string to 3.1.0

### Version 3.0.1

* Fix issue that arises when logging in on a newly created character or after reinstalling WoW due to client messages arriving in unexpected order.
* Changed version string to v3.0.1.

### Version 3.0.0

* Changed version string to v3.0.0.
* Various minor changes for version 3.0 compatibility

### Version 2.4.0

* Changed version string to 2.4.0 and changed interface number for the 2.4 patches.
* Moved all of Badapples' functions into a single global table.
* Fixed bug where the alert icon doesn't get shown properly due to the way the static popup was being resized (thanks pzykho).
* Badapples will only show you one warning message in the first chat frame it finds that is being shown (again thanks pzykho).
* Renamed exported function BadapplesCheck to Badapples.CheckName
* Renamed exported function BadapplesColor to Badapples.GetColor
