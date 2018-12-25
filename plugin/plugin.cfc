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

		switch(application.configBean.getDBType()) {
			case "mysql":
				include "db/dbstructure-mysqlinstall.cfm";
				break;
		}
	}

	public void function update() {
		// triggered by the pluginManager when the plugin is UPDATED.
		application.appInitialized = false;

		PluginConfig = #this.getConfig()#;
		PluginVersion = #PluginConfig.getVersion()#;

		switch(application.configBean.getDBType()) {
			case "mysql":
				if (Variables.PluginVersion CONTAINS "4.0.0") {

					if (Variables.PluginVersion EQ "4.0.0.3") {
						include "db/dbstructure-V4.0.0.3.cfm";		
					}

					if (Variables.PluginVersion EQ "4.0.0.4") {
						include "db/dbstructure-V4.0.0.4.cfm";		
					}

				} else {
					include "db/dbstructure-V3ToV4.0.0.2.cfm";	
				}
				break;
		}
	}
	
	public void function delete() {
		// triggered by the pluginManager when the plugin is DELETED.
		application.appInitialized = false;

		var dbWorker = application.configbean.getBean('dbUtility');
		dbWorker.dropTable(table='p_EventRegistration_Caterers');
		dbWorker.dropTable(table='p_EventRegistration_EventEmailLog');
		dbWorker.dropTable(table='p_EventRegistration_EventExpenses');
		dbWorker.dropTable(table='p_EventRegistration_EventResources');
		dbWorker.dropTable(table='p_EventRegistration_ExpenseList');
		dbWorker.dropTable(table='p_EventRegistration_Events');
		dbWorker.dropTable(table='p_EventRegistration_Facility');
		dbWorker.dropTable(table='p_EventRegistration_FacilityRooms');
		dbWorker.dropTable(table='p_EventRegistration_GradeLevels');
		dbWorker.dropTable(table='p_EventRegistration_GradeSubjects');
		dbWorker.dropTable(table='p_EventRegistration_Membership');
		dbWorker.dropTable(table='p_EventRegistration_MembershipBuildings');
		dbWorker.dropTable(table='p_EventRegistration_ShortURL');
		dbWorker.dropTable(table='p_EventRegistration_SiteConfig');
		dbWorker.dropTable(table='p_EventRegistration_StateESCOrganizations');
		dbWorker.dropTable(table='p_EventRegistration_UserRegistrations');
		dbWorker.dropTable(table='p_EventRegistration_UserMatrix');

		deleteGroups = new Query(datasource='#application.configBean.getDatasource()#', sql="Delete from tusers where GroupName LIKE :GroupPartName");
	    deleteGroups.addParam(name="GroupPartName", value="%Event%",CFSQLTYPE="CF_SQL_VARCHAR");
	    deleteGroupsResults = deleteGroups.execute();
	}

}