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

		// #rc.$.globalConfig('dbtype')#
		switch(application.configbean.getDBType()) {
			case "mssql":
				include "db/install/mssql-install.cfm";
				break;
			case "mysql":
				include "db/install/mysql-install.cfm";
				break;
		}

		Var dbInsertSiteConfigQuery = new query();
		dbInsertSiteConfigQuery.setDatasource("#application.configBean.getDatasource()#");
		dbInsertSiteConfigQuery.addparam(name="SiteID", value="#Session.SiteID#", cfsqltype="varchar");
		dbInsertSiteConfigQuery.addparam(name="DateCreated", value="#Now()#", cfsqltype="timestamp");
		dbInsertSiteConfigQuery.addparam(name="LastUpdateBy", value="System", cfsqltype="varchar");
		dbInsertSiteConfigQuery.addparam(name="LastUpdated", value="#Now()#", cfsqltype="timestamp");
		dbInsertSiteConfigQuery.addparam(name="ProcessStripe", value="0", cfsqltype="bit");
		dbInsertSiteConfigQuery.addparam(name="TestStripe", value="1", cfsqltype="bit");
		dbInsertSiteConfigQuery.setSQL("Insert into p_EventRegistration_SiteConfig(Site_ID, DateCreated, lastUpdateBy, lastUpdated, ProcessPayments_Stripe, Stripe_TestMode) Values(:SiteID, :DateCreated, :LastUpdateBy, :LastUpdated, :ProcessStripe, :TestStripe)");
		dbInsertSiteConfigQuery.execute();
	}

	public void function update() {
		// triggered by the pluginManager when the plugin is UPDATED.
		application.appInitialized = false;

		switch(application.configbean.getDBType()) {
			case "mysql":
				include "db/upgrade/mysql-update-3.0.4.cfm";
				break;
		}
	}

	public void function delete() {
		// triggered by the pluginManager when the plugin is DELETED.
		application.appInitialized = false;

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_Membership");
		var dbDropTableResults = dbDropTable.execute();
		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_UserMatrix");
		var dbDropTableResults = dbDropTable.execute();
		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_UserRegistrations");
		var dbDropTableResults = dbDropTable.execute();
		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_Events");
		var dbDropTableResults = dbDropTable.execute();
		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_EventExpenses");
		var dbDropTableResults = dbDropTable.execute();
		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_ExpenseList");
		var dbDropTableResults = dbDropTable.execute();
		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_Facility");
		var dbDropTableResults = dbDropTable.execute();
		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_FacilityRooms");
		var dbDropTableResults = dbDropTable.execute();
		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_Caterers");
		var dbDropTableResults = dbDropTable.execute();
		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}

		var dbDropTable = new query();
		dbDropTable.setDatasource("#application.configBean.getDatasource()#");
		dbDropTable.setSQL("DROP TABLE p_EventRegistration_SiteConfig");
		var dbDropTableResults = dbDropTable.execute();
		if (len(dbDropTableResults.getResult()) neq 0) {
			writedump(dbDropTableResults.getResult());
			abort;
		}
	}
}