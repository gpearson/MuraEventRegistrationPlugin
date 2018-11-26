MuraEventRegistration
=====================

A Mura CMS Plugin to allow website visitors the ability to register for upcoming events or workshops that you are hosting within your organization.


Minimum Requirements
====================

Mura CMS 6.0+
Railo 4+ ; Lucee
MySQL 5

Note: Upon Installation create an account through the Register Account Section to add your account to the database. A manual entry of the tusersmemb table is needed which maps your account to the Event Facilitator UUID to access the Event Coordinator Subsystem of the Plugin.

Note: After installing plugin the itext*.jar files within the library/jars of the plugin directory will need to be manually copied to your WEB-INF/{railo},{lucee}/lib directory and then restart the service for these jar files to be included.


Description
====================
This plugin utilizes MuraFW/1 as the base to this plugin and allows website users the ability to create events or workshops so visitors can register themselves for the upcoming event. This plugin utilizes security roles (Event Presenter, Event Coordinator) to distinguish who would have access to what part of the system.


