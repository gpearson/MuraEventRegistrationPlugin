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

		/* 

		checkGroups = new Query(name='checkGroups', datasource='#application.configBean.getDatasource()#', sql="Select UserID, GroupName From tusers where GroupName LIKE :GroupPartName");
	    checkGroups.addParam(name="GroupPartName", value="%Event%",CFSQLTYPE="CF_SQL_VARCHAR");
	    checkGroupsResults = checkGroups.execute();

	    if (checkGroupsResults.getResult().recordcount EQ 0) {
	    	var NewGroupEventFacilitator = #application.userManager.read('')#;
    		NewGroupEventFacilitator.setSiteID(Session.SiteID);
    		NewGroupEventFacilitator.setGroupName('Event Facilitator');
    		NewGroupEventFacilitator.setType(1);
    		NewGroupEventFacilitator.setIsPublic(1);
    		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;

    		var NewGroupEventFacilitator = #application.userManager.read('')#;
    		NewGroupEventFacilitator.setSiteID(Session.SiteID);
    		NewGroupEventFacilitator.setGroupName('Event Presenter');
    		NewGroupEventFacilitator.setType(1);
    		NewGroupEventFacilitator.setIsPublic(1);
    		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
	    }
	    */
	}

	public void function update() {
		// triggered by the pluginManager when the plugin is UPDATED.
		application.appInitialized = false;

		var dbSiteConfig = application.configbean.getBean('dbUtility');
	  	dbSiteConfig.setTable('p_EventRegistration_SiteConfig')
	  	.addColumn(column='BillForNoShowRegistrations',dataType='boolean',default=0,nullable=false)
	  	.addColumn(column='RequireEventSurveyToGetCertificate',dataType='boolean',default=0,nullable=false);

	  	var dbCateringTable = application.configbean.getBean('dbUtility');
	  	dbCateringTable.setTable('p_EventRegistration_Caterers')
	  	 .addColumn(column='Physical_USPSDeliveryPoint',dataType='varchar',length='12',nullable=true)
	  	 .addColumn(column='Physical_USPSCheckDigit',dataType='varchar',length='50',nullable=true)
	  	 .addColumn(column='Physical_USPSCarrierRoute',dataType='varchar',length='50',nullable=true)
	  	 .addColumn(column='Physical_DST',dataType='boolean',default=0,nullable=false)
	  	 .addColumn(column='Physical_UTCOffset',dataType='char',length='10')
	  	 .addColumn(column='lastUpdateByID',dataType='varchar',length='255')
	  	 .addColumn(column='Physical_TimeZone',dataType='char',length='50');

	  	var dbFacilityTable = application.configbean.getBean('dbUtility');
	  	dbFacilityTable.setTable('p_EventRegistration_Facility')
	  	.renameColumn(column='Physical_Address', newcolumn='PhysicalAddress')
	  	.renameColumn(column='Physical_City', newcolumn='PhysicalCity')
	  	.renameColumn(column='Physical_State', newcolumn='PhysicalState')
	  	.renameColumn(column='Physical_ZipCode', newcolumn='PhysicalZipCode')
	  	.renameColumn(column='Physical_ZipPlus4', newcolumn='PhysicalZip4')
	  	.renameColumn(column='Physical_Latitude', newcolumn='GeoCode_Latitude')
	  	.renameColumn(column='Physical_Longitude', newcolumn='GeoCode_Longitude')
	  	.addColumn(column='Physical_isAddressVerified',dataType='boolean',default=0,nullable=false)
	  	.addColumn(column='Mailing_isAddressVerified',dataType='boolean',default=0,nullable=false)
	  	.addColumn(column='GeoCode_Township',dataType='varchar',length='255',nullable=true)
		.addColumn(column='GeoCode_StateLongName',dataType='varchar',length='255',nullable=true)
		.addColumn(column='GeoCode_CountryShortName',dataType='varchar',length='255',nullable=true)
		.addColumn(column='GeoCode_Neighborhood',dataType='varchar',length='255',nullable=true)
		.renameColumn(column='Mailing_Address', newcolumn='MailingAddress')
	  	.renameColumn(column='Mailing_City', newcolumn='MailingCity')
	  	.renameColumn(column='Mailing_State', newcolumn='MailingState')
	  	.renameColumn(column='Mailing_ZipCode', newcolumn='MailingZipCode')
	  	.renameColumn(column='Mailing_ZipPlus4', newcolumn='MailingZip4')
	  	.dropColumn(column='Physical_CountyName')
	  	.dropColumn(column='Physical_CongressionalDistrict')
	  	.dropColumn(column='Physical_CountyFIPS')
	  	.addColumn(column='PaymentTerms',dataType='longtext',nullable=true)
	  	.addColumn(column='AdditionalNotes',dataType='longtext',nullable=true)
	  	.dropColumn(column='Physical_CountyName');

	  	var dbMembershipTable = application.configbean.getBean('dbUtility');
	  	dbMembershipTable.setTable('p_EventRegistration_Membership')
	  	.renameColumn(column='Mailing_Address', newcolumn='MailingAddress')
	  	.renameColumn(column='Mailing_City', newcolumn='MailingCity')
	  	.renameColumn(column='Mailing_State', newcolumn='MailingState')
	  	.renameColumn(column='Mailing_ZipCode', newcolumn='MailingZipCode')
	  	.renameColumn(column='Mailing_ZipPlus4', newcolumn='MailingZip4')
	  	.renameColumn(column='Physical_Address', newcolumn='PhysicalAddress')
	  	.renameColumn(column='Physical_City', newcolumn='PhysicalCity')
	  	.renameColumn(column='Physical_State', newcolumn='PhysicalState')
	  	.renameColumn(column='Physical_ZipCode', newcolumn='PhysicalZipCode')
	  	.renameColumn(column='Physical_ZipPlus4', newcolumn='PhysicalZip4')
	  	.addColumn(column='GeoCode_Township',dataType='varchar',length='255',nullable=true)
	  	.addColumn(column='GeoCode_StateLongName',dataType='varchar',length='255',nullable=true)
	  	.addColumn(column='GeoCode_CountryShortName',dataType='varchar',length='255',nullable=true)
	  	.addColumn(column='GeoCode_Neighborhood',dataType='varchar',length='255',nullable=true)
	  	.dropColumn(column='Physical_CountyName')
	  	.dropColumn(column='Physical_CongressionalDistrict')
	  	.dropColumn(column='Physical_CountyFIPS');


	  	var dbEventsTable = application.configbean.getBean('dbUtility');
	  	dbEventsTable.setTable('p_EventRegistration_Events')
	  	.renameColumn(column='VideoConferenceCost', newcolumn='VideoConferenceMemberCost')
		.addColumn(column='VideoConferenceNonMemberCost',dataType='double',nullable=true)
		.addColumn(column='EventHasOptionalCosts',dataType='boolean',default=0,nullable=false)
	  	.addColumn(column='EventPricePerDay',dataType='boolean',default=0,nullable=false);

	  	var dbUserRegistrationsTable = application.configbean.getBean('dbUtility');
	  	dbUserRegistrationsTable.setTable('p_EventRegistration_UserRegistrations')
	  	.addColumn(column='RequestsMeal',dataType='boolean',default=0,nullable=false);

	  	var dbEventExpensesTable = application.configbean.getBean('dbUtility');
	  	dbEventExpensesTable.setTable('p_EventRegistration_EventExpenses')
	  	.addColumn(column='Event_ID',dataType='int',nullable=false)
		.addIndex(column="Event_ID");

		var dbEventResourcesTable = application.configbean.getBean('dbUtility');
	  	dbEventResourcesTable.setTable('p_EventRegistration_EventResources')
	  	.addColumn(column='Event_ID',dataType='int',nullable=false)
	  	.renameColumn(column='ResourceDocumentSized', newcolumn='ResourceDocumentSize')
		.addIndex(column="Event_ID");

		
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