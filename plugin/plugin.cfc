/*

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
component persistent="false" accessors="true" output="false" extends="mura.plugin.plugincfc" {

	property name="config" type="any" default="";

	public any function init(any config='') {
		setConfig(arguments.config);
	}

	public void function install() {
		// triggered by the pluginManager when the plugin is INSTALLED.
		application.appInitialized = false;

		switch(application.configbean.getDBType()) {
			case "mssql":
				include "db/install/mssql-install.cfm";
				break;
			case "mysql":
				include "db/install/mysql-install.cfm";
				break;
		}

	}

	public void function update() {
		// triggered by the pluginManager when the plugin is UPDATED.
		application.appInitialized = false;

		switch(application.configbean.getDBType()) {
			case "mysql":
				include "db/update/mysql-update-3.0.4.cfm";
				include "db/update/mysql-update-3.0.6.0.cfm";
				include "db/update/mysql-update-3.0.8.0.cfm";
				include "db/update/mysql-update-3.0.8.6.cfm";
				include "db/update/mysql-update-3.0.8.7.cfm";
				include "db/update/mysql-update-3.0.10.cfm";
				break;
		}
	}

	public void function delete() {
		// triggered by the pluginManager when the plugin is DELETED.
		application.appInitialized = false;

		var dbWorker = application.configbean.getBean('dbUtility');

		dbWorker.dropTable('p_EventRegistration_Caterers');
		dbWorker.dropTable('p_EventRegistration_EventEmailLog');
		dbWorker.dropTable('p_EventRegistration_EventExpenses');
		dbWorker.dropTable('p_EventRegistration_EventResources');
		dbWorker.dropTable('p_EventRegistration_Events');
		dbWorker.dropTable('p_EventRegistration_ExpenseList');
		dbWorker.dropTable('p_EventRegistration_Facility');
		dbWorker.dropTable('p_EventRegistration_FacilityRooms');
		dbWorker.dropTable('p_EventRegistration_GradeLevels');
		dbWorker.dropTable('p_EventRegistration_GradeSubjects');
		dbWorker.dropTable('p_EventRegistration_Membership');
		dbWorker.dropTable('p_EventRegistration_MembershipBuildings');
		dbWorker.dropTable('p_EventRegistration_ShortURL');
		dbWorker.dropTable('p_EventRegistration_SiteConfig');
		dbWorker.dropTable('p_EventRegistration_StateESCOrganizations');
		dbWorker.dropTable('p_EventRegistration_UserRegistrations');
		dbWorker.dropTable('p_EventRegistration_UserMatrix');
	}
}