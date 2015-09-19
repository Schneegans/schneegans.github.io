---
layout: nav-page
title : Gnome-Pie's Changelog
header : Gnome-Pie Changelog
description: A chronological list of changes of Gnome-Pie.
colors: color-use
---


## Gnome-Pie 0.6.6

* **New Feature:** New Numix theme. Similar to Adwaita Big but with dark colors.
* **New Feature:** It's now possible to export and to import themes.
* **New Feature:** There is a little info widget in the settings menu. It shows useful tips and tricks regarding Gnome-Pie.
* **Update:** Gnome-Pie now uses [Zanata](https://translate.zanata.org/zanata/iteration/view/gnome-pie/develop) for translations.
* **Update:** Translation updates for Spanish locale (thank you,[Gabriel Dubatti](https://github.com/gabdub)!). Please feel free to contribute to the [translation into your language]({% post_url 2015-08-07-translate-gnome-pie %})!
* **Update:** Translation updates for German locale.
* **Update:** The settings menu layout has been changed a bit.
* **Update:** The translations are now compiled at build time. Actually there was no reason for them being included in the repository.
* **Bugfix:** When typing slice names to select them, the typed letters are reset after a short delay. This allows for selecting an item even if you typed some wrong letters in the first place.


## Gnome-Pie 0.6.5

* **New Feature:** Added possibility to select slices by typing their names.
* **New Feature:** Its now possible to position each theme layer (icons, files and slice caption) relative to their centers with a x-offset and a y-offset (fixes [issue #115](https://github.com/Simmesimme/Gnome-Pie/issues/115)).
* **Update:** Translation updates for French locale (thank you, [Raphaël Rochet](https://github.com/RaphaelRochet)!). Please feel free to contribute to the [translation into your language]({% post_url 2011-11-09-translate-gnome-pie %})!
* **Update:** Translation updates for German locale.
* **Bugfix:** Fixed hard to read text when displaying slice hotkeys for some themes.


## Gnome-Pie 0.6.4

* **New Feature:** A new theme based on "Adwaita". It features bigger icons than the original theme. This looks awesome with some icon themes (the screenshot above uses [Faenza](http://tiheum.deviantart.com/art/Faenza-Icons-173323228)).
* **Bugfix:** Fixed missing icon of status icon in message tray.


## Gnome-Pie 0.6.3

* **New Feature:** Lithuanian translation (thank you, Moo!).
* **New Feature:** Added a commandline option to print a list of all pies with their according IDs (`--print-ids`).
* **Update:** The preferences dialog now uses the Gtk.StackSwitcher and Gtk.HeaderBar per default. Use the commandline arguments `--no-stack-switcher` and `--no-header-bar` to revert to the old behavior.
* **Update:** Translation updates for Spanish locale. Please feel free to contribute to the [translation into your language]({% post_url 2011-11-09-translate-gnome-pie %})!
* **Bugfix:** It's now possible to add more than one "unbound Pie" (thank you, [Gabriel Dubatti](https://github.com/gabdub)!).
* **Bugfix:** The `--help` commandline argument actually shows help again.
* **Bugfix:** The app indicator has now an icon now when using Gnome-Shell.
* **Bugfix:** Fixed a bug which made it possible that the add-new-slice button was not clickable.


## Gnome-Pie 0.6.2

* **New Feature:** A new Pie Group has been added which shows all windows of the current workspace only.
* **New Feature:** Optional usage of Gtk.HeaderBar (activate with `gnome-pie --header-bar`).
* **New Feature:** Optional usage of Gtk.StackSwitcher (activate with `gnome-pie --stack-switcher`).
* **Update:** The layout of the options menu has been made much clearer.
* **Update:** Translation updates: English and German --- please feel free to contribute to the [translation into your language]({% post_url 2011-11-09-translate-gnome-pie %})!
* **Update:** Many obsolete vapi files have been removed from the source directory.
* **Update:** The Adwaita theme is now the default theme.
* **Bugfix:** Under Unity, the Window List Group brings windows to front on slice activation now (thank you, [Gabriel Dubatti](https://github.com/gabdub)!).
* **Bugfix:** It's now possible to bind pies to hotkey combinations with the Super key
* **Bugfix:** Uses now standard D-Bus names to shutdown and reboot the system (thank you, [György Balló](https://github.com/City-busz)!).
* **Bugfix:** Update icon names to work with the default Adwaita icon theme (thank you, György Balló!).


## Gnome-Pie 0.6.1

* **New Feature:** Thanks to [Gabriel Dubatti](https://github.com/gabdub) its now possible to have half or quarter pies. The pie shape can be choosen automatically depending on the location of the mouse cursor while openening the pie.
* **New Feature:** Thanks to Gabriel Dubatti its now possible to define a maximum number of slices per pie. If there are more, you will have the possibility to scroll through the pie with your mouse wheel or Page-Up & Page-Down.
* **New Feature:** A very simple new theme has been added.
* **New Feature:** The option to warp the mouse cursor to the pie center has been added.
* **New Feature:** A new icon for Gnome-Pie has been designed.
* **Update:** Existing themes have been tweaked a little.
* **Update:** Translation updates: English, German and Spanish --- please feel free to contribute to the [translation into your language]({% post_url 2011-11-09-translate-gnome-pie %})!
* **Bugfix:** The faked background transparency for desktop environments without compositing works now close to panels and when the mouse moved while opening the pie.
* **Bugfix:** An old bug has been fixed which caused Gnome-Pie to hang at 100% CPU usage occasionally. Thanks Gabriel for your effort to catch this one!
* **Bugfix:** A bug has been fixed which caused tree view items to have no icons in the settings menu.
* **Bugfix:** A bug has been fixed which caused drag and drop icons to be invisible.
* **Bugfix:** A bug has been fixed which made delayed mode being re-enabled if the pie was opened once before being configured.
* **Bugfix:** A bug has been fixed which caused the quick action to be activated when the user clicked outside activation range.
* **Bugfix:** Its now possible to save trigger modes (delayed, turbo, ...) even if no binding is defined.
* **Bugfix:** Changed WM_CLASS which enables launchers to track windows properly.


## Gnome-Pie 0.5.7

* **New Feature:** Maximum activation radius: It can be set in the settings menu
* **Update** ported all Glade ui-files to GTK3
* **Update** removed old GTK2 code
* **Update** removed a lot deprecated code
* **Update** switched from libunique to GLib.Application
* **Update** switched from gee-0.6 to gee-0.8
* **Bugfix** added missing keyword to desktop file (thanks for the hint, [JoergFF](https://github.com/JoergFF))


## Gnome-Pie 0.5.6

* **Bugfix** Transparency under Gnome 3.10+ (thank you, [Raphaël Rochet](https://github.com/RaphaelRochet))
* **Bugfix** Pie hotkeys start numbering with one (instead of zero, since the zero key is really hard to press)
* **Bugfix** option windows are now resizable since they are too small with certain window managers (e.g. Gala)


## Gnome-Pie 0.5.5

* **Bugfix** The drag'n'drop between Pies in the editor has been improved a bit.
* **Bugfix** A major segmentation fault on start up when some icons were not found has been fixed.


## Gnome-Pie 0.5.4

* **Update** Statistics are not tracked anymore and new users wont be questioned to send the statistics file. I got files by more than 150 users and was able to [write a successful Bachelor thesis]({% post_url 2012-10-10-bachelor-thesis %}).
* **New Feature** A Bulgarian translation has been added. Thanks to Martin Dinov!
* **New Feature** A Chinese translation has been added. Thanks to Ting Zhou!
* **New Feature** It's now possible to drag and drop Slices between Pies in the configuration window.
* **Bugfix** It's now possible to bind Pies to hot keys containing the Super-key (normally referred to as the Windows-key)
* **Bugfix** A possible segmentation fault on start-up has been fixed.


## Gnome-Pie 0.5.3

* **Update** The French locale got updated (thanks Mathilde!)
* **Bugfix** There was a major bug which prevented the auto-start option to work at all (thanks to barteltm for pointing at this issue!).
* **New Feature** I implemented a popup window requesting the statistics file from you (as [described earlier]({% post_url 2012-05-10-help-baking-pies %})).
