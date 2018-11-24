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

		/* var dbCheckTables = new query();
		dbCheckTables.setDatasource("#application.configBean.getDatasource()#");
		dbCheckTables.setSQL("Show Tables LIKE 'p_Auction_Bids'");
		var dbCheckTablesResults = dbCheckTables.execute();

		if (dbCheckTablesResults.getResult().recordcount eq 0) {
			// Since the Database Table does not exists, Lets Create it
			var dbCreateTable = new query();
			dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
			dbCreateTable.setSQL("CREATE TABLE `p_Auction_Bids` ( `TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Auction_ID` int(11) NOT NULL, `User_ID` varchar(30) NOT NULL, `Bid_Amount` double(15,2) NOT NULL, PRIMARY KEY (`TContent_ID`) ) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;");
			var dbCreateTableResults = dbCreateTable.execute();
		} else {
			// Database Table Exists, We must Drop it to create it again
			var dbDropTable = new query();
			dbDropTable.setDatasource("#application.configBean.getDatasource()#");
			dbDropTable.setSQL("DROP TABLE p_Auction_Bids");
			var dbDropTableResults = dbDropTable.execute();

			if (len(dbDropTableResults.getResult()) eq 0) {
				var dbCreateTable = new query();
				dbCreateTable.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTable.setSQL("CREATE TABLE `p_Auction_Bids` ( `TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Auction_ID` int(11) NOT NULL, `User_ID` varchar(30) NOT NULL, `Bid_Amount` double(15,2) NOT NULL, PRIMARY KEY (`TContent_ID`) ) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;");
				var dbCreateTableResults = dbCreateTable.execute();
			} else {
				 writedump(dbDropTableResults.getResult());
				 abort;
			}
		}
		* */

		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Facilitator");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupAuctionAdmin)#;

		var NewGroupEventPresentator = #application.userManager.read("")#;
		NewGroupEventPresentator.setSiteID(Session.SiteID);
		NewGroupEventPresentator.setGroupName("Event Presentator");
		NewGroupEventPresentator.setType(1);
		NewGroupEventPresentator.setIsPublic(1);
		NewGroupEventPresentatorStatus = #Application.userManager.create(NewGroupAuctionAdmin)#;
	}

	public void function update() {
		// triggered by the pluginManager when the plugin is UPDATED.
		application.appInitialized = false;
	}

	public void function delete() {
		// triggered by the pluginManager when the plugin is DELETED.
		application.appInitialized = false;
	}

}