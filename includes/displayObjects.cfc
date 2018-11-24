/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="mura.plugin.pluginGenericEventHandler" {

	// framework variables
	include 'fw1config.cfm';

	public any function init() {
		return this;
	}

	// ========================== Display Methods ==============================

	public any function ViewAvailableEvents($) {
		return getApplication().doAction('public:main.viewavailableevents');
	}

	public any function GetEventInformation($) {
		return getApplication().doAction('public:main.eventinfo');
	}

	public any function RegisterForEvent($) {
		return getApplication().doAction('public:registerevent.registration');
	}

	public any function RegistrationComplete($) {
		return getApplication().doAction('public:registerevent.registrationcomplete');
	}

	// ========================== Helper Methods ==============================

	private any function getApplication() {
		if(!StructKeyExists(request, '#variables.framework.applicationKey#Application') ) {
			request['#variables.framework.applicationKey#Application'] = new '#variables.framework.package#.Application'();
		};
		return request['#variables.framework.applicationKey#Application'];
	}

}