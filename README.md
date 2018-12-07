MuraEventRegistration
=====================

A Mura CMS Plugin to allow website visitors the ability to register for upcoming events or workshops that you are hosting within your organization.


Minimum Requirements
====================

* [Mura CMS](http://www.getmura.com) Core Version 7.0+
* [Adobe ColdFusion](http://www.adobe.com/coldfusion) 2016.0.02.299200
* [Lucee](http://lucee.org) 5.0.0.254

Note: A new dsp_login.cfm page located in includes/display_objects will need to be placed within the current template folder display_objects of your Mura Installation. This template has buttons for Forgot Password and Create Account that walks a user through these processes if they are having issues getting logged in.


Description
====================
This plugin utilizes MuraFW/1 as the base to this plugin and allows website users the ability to create events or workshops so visitors can register themselves for the upcoming event. This plugin utilizes security roles (Event Presenter, Event Coordinator) to distinguish who would have access to what part of the system.





Update
====================
If running plugin on Mura Version 6.1, upgrade Mura first to the latest version through updating Mura Core then Mura Sites. When you get a blank white screen while doing the Mura Core Update, restart the coldfusion service then login to mura admin. You might need to clear your cache by pressing <CTRL> + <F5> a few times. Update Mura Core again, then update Mura Site. Once this has been completed, then update the Plugin through the Plugin Manager. Once the plugin has updated, click on the plugin name to view the Super Admin Subsystem and update settings.