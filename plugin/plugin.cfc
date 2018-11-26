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

		var dbCaterers = application.configbean.getBean('dbUtility');
		dbCaterers.setTable('p_EventRegistration_Caterers')
			.addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
			.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
			.addColumn(column='FacilityName',dataType='varchar',length='255',nullable=false)
			.addColumn(column='PhysicalAddress',dataType='varchar',length='255')
			.addColumn(column='PhysicalCity',dataType='char',length='50')
			.addColumn(column='PhysicalState',dataType='char',length='2')
			.addColumn(column='PhysicalZipCode',dataType='char',length='5')
			.addColumn(column='PhysicalZip4',dataType='char',length='4')
			.addColumn(column='PrimaryVoiceNumber',dataType='char',length='14')
			.addColumn(column='BusinessWebsite',dataType='varchar',length='255')
			.addColumn(column='ContactName',dataType='varchar',length='255')
			.addColumn(column='ContactPhoneNumber',dataType='char',length='14')
			.addColumn(column='ContactEmail',dataType='varchar',length='255')
			.addColumn(column='PaymentTerms',dataType='longtext',nullable=true)
			.addColumn(column='DeliveryInfo',dataType='longtext',nullable=true)
			.addColumn(column='GuaranteeInformation',dataType='longtext',nullable=true)
			.addColumn(column='AdditionalNotes',dataType='longtext',nullable=true)
			.addColumn(column='dateCreated',dataType='datetime')
			.addColumn(column='lastUpdated',dataType='datetime')
			.addColumn(column='lastUpdateBy',dataType='varchar',length='255')
			.addColumn(column='isAddressVerified',dataType='boolean',default=0,nullable=false)
			.addColumn(column='GeoCode_Latitude',dataType='char',length='20',nullable=true)
			.addColumn(column='GeoCode_Longitude',dataType='char',length='20',nullable=true)
			.addColumn(column='GeoCode_Township',dataType='varchar',length='255',nullable=true)
			.addColumn(column='GeoCode_StateLongName',dataType='varchar',length='255',nullable=true)
			.addColumn(column='GeoCode_CountryShortName',dataType='varchar',length='255',nullable=true)
			.addColumn(column='GeoCode_Neighborhood',dataType='varchar',length='255',nullable=true)
			.addColumn(column='Active',dataType='boolean',default=0,nullable=false)
			.addPrimaryKey(column='TContent_ID');

		var dbEventEmailLog = application.configbean.getBean('dbUtility');
		dbEventEmailLog.setTable('p_EventRegistration_EventEmailLog')
			.addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
			.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
			.addColumn(column='Event_ID',dataType='int',nullable=false)
			.addColumn(column='MsgBody',dataType='longtext',nullable=false)
			.addColumn(column='EmailType',dataType='longtext',nullable=false)
			.addColumn(column='LinksToInclude',dataType='varchar',length='255',nullable=true)
			.addColumn(column='DocsToInclude',dataType='varchar',length='255',nullable=true)
			.addColumn(column='EmailSentToParticipants',dataType='varchar',length='255',nullable=true)
			.addColumn(column='dateCreated',dataType='datetime')
			.addColumn(column='lastUpdated',dataType='datetime')
			.addColumn(column='lastUpdateBy',dataType='varchar',length='255')
			.addColumn(column='lastUpdateByID',dataType='varchar',length='35')
			.addPrimaryKey(column='TContent_ID');
		
		var dbEventExpenses = application.configbean.getBean('dbUtility');
		dbEventExpenses.setTable('p_EventRegistration_EventExpenses')
			.addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
			.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
			.addColumn(column='Expense_ID',dataType='int',nullable=false)
			.addColumn(column='Cost_Amount',dataType='double',nullable=false)
			.addColumn(column='dateCreated',dataType='datetime')
			.addColumn(column='lastUpdated',dataType='datetime')
			.addColumn(column='lastUpdateBy',dataType='varchar',length='255')
			.addColumn(column='lastUpdateByID',dataType='varchar',length='35')
			.addColumn(column='Cost_Verified',dataType='boolean',default=0,nullable=false)
			.addPrimaryKey(column='TContent_ID');

		var dbEventResources = application.configbean.getBean('dbUtility');
		dbEventResources.setTable('p_EventRegistration_EventResources')
			.addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
			.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
			.addColumn(column='ResourceType',dataType='char',length='1',nullable=false)
			.addColumn(column='ResourceLink',dataType='longtext',nullable=true)
			.addColumn(column='ResourceDocument',dataType='longtext',nullable=true)
			.addColumn(column='ResourceDocumentSized',dataType='longtext',nullable=true)
			.addColumn(column='dateCreated',dataType='datetime')
			.addColumn(column='lastUpdated',dataType='datetime')
			.addColumn(column='lastUpdateBy',dataType='varchar',length='255')
			.addColumn(column='lastUpdateByID',dataType='varchar',length='35')
			.addPrimaryKey(column='TContent_ID');

		var dbExpenseList = application.configbean.getBean('dbUtility');	
		dbExpenseList.setTable('p_EventRegistration_ExpenseList')
			.addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
			.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
			.addColumn(column='Expense_Name',dataType='varchar',length='100',nullable=false)
			.addColumn(column='Active',dataType='boolean',default=0,nullable=false)
			.addColumn(column='dateCreated',dataType='datetime')
			.addColumn(column='lastUpdated',dataType='datetime')
			.addColumn(column='lastUpdateBy',dataType='varchar',length='255')
			.addColumn(column='lastUpdateByID',dataType='varchar',length='35')
			.addPrimaryKey(column='TContent_ID');

		var dbEvents = application.configbean.getBean('dbUtility');
		dbEvents.setTable('p_EventRegistration_Events')
		    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
		    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		    .addColumn(column='ShortTitle',dataType='varchar',length='100')
		    .addColumn(column='EventDate',dataType='date',nullable=false)
		    .addColumn(column='EventDate1',dataType='date',nullable=true)
		    .addColumn(column='EventDate2',dataType='date',nullable=true)
		    .addColumn(column='EventDate3',dataType='date',nullable=true)
		    .addColumn(column='EventDate4',dataType='date',nullable=true)
		    .addColumn(column='EventDate5',dataType='date',nullable=true)
		    .addColumn(column='EventDate6',dataType='date',nullable=true)
		    .addColumn(column='LongDescription',dataType='longtext',nullable=false)
		    .addColumn(column='Event_StartTime',dataType='timestamp',nullable=false)
		    .addColumn(column='Event_EndTime',dataType='timestamp',nullable=false)
		    .addColumn(column='Registration_Deadline',dataType='date',nullable=false)
		    .addColumn(column='Registration_BeginTime',dataType='timestamp')
		    .addColumn(column='Registration_EndTime',dataType='timestamp')
		    .addColumn(column='EventFeatured',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Featured_StartDate',dataType='date',nullable=true)
		    .addColumn(column='Featured_EndDate',dataType='date',nullable=true)
		    .addColumn(column='Featured_SortOrder',dataType='int',nullable=false,default=0)
		    .addColumn(column='Member_Cost',dataType='double',nullable=false)
		    .addColumn(column='NonMember_Cost',dataType='double',nullable=false)
		    .addColumn(column='EarlyBird_Available',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='EarlyBird_Deadline',dataType='date',nullable=true)
		    .addColumn(column='EarlyBird_MemberCost',dataType='double',nullable=true)
		    .addColumn(column='EarlyBird_NonMemberCost',dataType='double',nullable=true)
		    .addColumn(column='ViewGroupPricing',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='GroupPrice_Requirements',dataType='longtext',nullable=true)
		    .addColumn(column='GroupPrice_MemberCost',dataType='double',nullable=false)
		    .addColumn(column='GroupPrice_NonMemberCost',dataType='double',nullable=false)
		    .addColumn(column='PGPAvailable',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='PGPPoints',dataType='double',nullable=true)
		    .addColumn(column='Meal_Available',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Meal_Included',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Meal_Notes',dataType='longtext',nullable=true)
		    .addColumn(column='Meal_Cost',dataType='double',nullable=true)
		    .addColumn(column='Meal_ProvidedBy',dataType='int',nullable=false,default=0)
		    .addColumn(column='AllowVideoConference',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='VideoConferenceInfo',dataType='longtext',nullable=true)
		    .addColumn(column='VideoConferenceCost',dataType='double',nullable=true)
		    .addColumn(column='AcceptRegistrations',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='EventAgenda',dataType='longtext',nullable=true)
		    .addColumn(column='EventTargetAudience',dataType='longtext',nullable=true)
		    .addColumn(column='EventStrategies',dataType='longtext',nullable=true)
		    .addColumn(column='EventSpecialInstructions',dataType='longtext',nullable=true)
		    .addColumn(column='MaxParticipants',dataType='int',nullable=false,default=0)
		    .addColumn(column='LocationID',dataType='int',nullable=false,default=0)
		    .addColumn(column='LocationRoomID',dataType='int',nullable=false,default=0)
		    .addColumn(column='PresenterID',dataType='char',length='35',nullable=true)
		    .addColumn(column='FacilitatorID',dataType='char',length='35',nullable=false)
		    .addColumn(column='dateCreated',dataType='datetime')
		    .addColumn(column='lastUpdated',dataType='datetime')
		    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
		    .addColumn(column='lastUpdateByID',dataType='varchar',length='35')
		    .addColumn(column='Active',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='EventCancelled',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='WebinarAvailable',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='WebinarConnectInfo',dataType='longtext',nullable=true)
		    .addColumn(column='Webinar_MemberCost',dataType='double',nullable=true)
		    .addColumn(column='Webinar_NonMemberCost',dataType='double',nullable=true)
		    .addColumn(column='PostedTo_Facebook',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='PostedTo_Twitter',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='EventHasDailySessions',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Session1BeginTime',dataType='timestamp',nullable=true)
		    .addColumn(column='Session1EndTime',dataType='timestamp',nullable=true)
		    .addColumn(column='Session2BeginTime',dataType='timestamp',nullable=true)
		    .addColumn(column='Session2EndTime',dataType='timestamp',nullable=true)
		    .addColumn(column='EventInvoicesGenerated',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='PGPCertificatesGenerated',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='BillForNoShow',dataType='boolean',default=0,nullable=false)
		    .addPrimaryKey(column='TContent_ID');

	    var dbFacility = application.configbean.getBean('dbUtility');
	    dbFacility.setTable('p_EventRegistration_Facility')
		    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
		    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		    .addColumn(column='FacilityName',dataType='varchar',length='255',nullable=false)
		    .addColumn(column='Mailing_Address',dataType='varchar',length='255')
		    .addColumn(column='Mailing_City',dataType='char',length='50')
		    .addColumn(column='Mailing_State',dataType='char',length='2')
		    .addColumn(column='Mailing_ZipCode',dataType='char',length='5')
		    .addColumn(column='Mailing_ZipPlus4',dataType='char',length='4')
		    .addColumn(column='Mailing_USPSDeliveryPoint',dataType='char',length='12')
		    .addColumn(column='Mailing_USPSCheckDigit',dataType='varchar',length='50',nullable=true)
		    .addColumn(column='Mailing_USPSCarrierRoute',dataType='varchar',length='50',nullable=true)
		    .addColumn(column='Mailing_isAddressVerified',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Physical_Address',dataType='varchar',length='255')
		    .addColumn(column='Physical_City',dataType='char',length='50')
		    .addColumn(column='Physical_State',dataType='char',length='2')
		    .addColumn(column='Physical_ZipCode',dataType='char',length='5')
		    .addColumn(column='Physical_ZipPlus4',dataType='char',length='4')
		    .addColumn(column='Physical_USPSDeliveryPoint',dataType='varchar',length='12',nullable=true)
		    .addColumn(column='Physical_USPSCheckDigit',dataType='varchar',length='50',nullable=true)
		    .addColumn(column='Physical_USPSCarrierRoute',dataType='varchar',length='50',nullable=true)
		    .addColumn(column='Physical_Latitude',dataType='char',length='12')
		    .addColumn(column='Physical_Longitude',dataType='char',length='12')
		    .addColumn(column='Physical_TimeZone',dataType='char',length='50')
		    .addColumn(column='Physical_DST',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Physical_UTCOffset',dataType='char',length='10')
		    .addColumn(column='Physical_CountyName',dataType='char',length='30')
		    .addColumn(column='Physical_CongressionalDistrict',dataType='char',length='30')
		    .addColumn(column='Physical_CountyFIPS',dataType='varchar',length='50',nullable=true)
		    .addColumn(column='Physical_isAddressVerified',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='PrimaryVoiceNumber',dataType='char',length='14')
		    .addColumn(column='BusinessWebsite',dataType='varchar',length='255')
		    .addColumn(column='ContactName',dataType='varchar',length='255')
		    .addColumn(column='ContactPhoneNumber',dataType='char',length='14')
		    .addColumn(column='ContactEmail',dataType='varchar',length='255')
		    .addColumn(column='dateCreated',dataType='datetime')
		    .addColumn(column='lastUpdated',dataType='datetime')
		    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
		    .addColumn(column='lastUpdateByID',dataType='char',length='35')
		    .addColumn(column='Active',dataType='boolean',default=0,nullable=false)
		    .addPrimaryKey(column='TContent_ID');

	   	var dbFacilityRooms = application.configbean.getBean('dbUtility');
		dbFacilityRooms.setTable('p_EventRegistration_FacilityRooms')
		    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
		    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		    .addColumn(column='Facility_ID',dataType='int',nullable=false)
		    .addColumn(column='RoomName',dataType='varchar',length='50')
		    .addColumn(column='Capacity',dataType='int',nullable=false)
		    .addColumn(column='RoomFees',dataType='double',nullable=true)
		    .addColumn(column='Active',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='dateCreated',dataType='datetime')
		    .addColumn(column='lastUpdated',dataType='datetime')
		    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
		    .addColumn(column='lastUpdateByID',dataType='char',length='35')
		    .addPrimaryKey(column='TContent_ID');

	    var dbGradeLevels = application.configbean.getBean('dbUtility');
	   	dbGradeLevels.setTable('p_EventRegistration_GradeLevels')
		    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
		    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		    .addColumn(column='GradeLevel',dataType='char',length='50',nullable=false)
		    .addColumn(column='dateCreated',dataType='datetime')
		    .addColumn(column='lastUpdated',dataType='datetime')
		    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
		    .addColumn(column='lastUpdateByID',dataType='char',length='35')
		    .addPrimaryKey(column='TContent_ID');

	  	var dbGradeSubjects = application.configbean.getBean('dbUtility');	  
	  	dbGradeSubjects.setTable('p_EventRegistration_GradeSubjects')
		    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
		    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		    .addColumn(column='GradeLevel',dataType='int',nullable=false)
		    .addColumn(column='GradeSubject',dataType='char',length='50',nullable=false)
		    .addColumn(column='dateCreated',dataType='datetime')
		    .addColumn(column='lastUpdated',dataType='datetime')
		    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
		    .addColumn(column='lastUpdateByID',dataType='char',length='35')
		    .addPrimaryKey(column='TContent_ID');

	    var dbMembership = application.configbean.getBean('dbUtility');
	    dbMembership.setTable('p_EventRegistration_Membership')
		    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
		    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		    .addColumn(column='OrganizationName',dataType='char',length='50',nullable=false)
		    .addColumn(column='OrganizationDomainName',dataType='char',length='150',nullable=false)
		    .addColumn(column='StateDOE_IDNumber',dataType='char',length='10',nullable=true)
		    .addColumn(column='StateDOE_ESCESAMembership',dataType='int',nullable=true)
		    .addColumn(column='StateDOE_State',dataType='char',length='50',nullable=true)
		    .addColumn(column='Mailing_Address',dataType='varchar',length='255')
		    .addColumn(column='Mailing_City',dataType='char',length='50')
		    .addColumn(column='Mailing_State',dataType='char',length='2')
		    .addColumn(column='Mailing_ZipCode',dataType='char',length='5')
		    .addColumn(column='Mailing_ZipPlus4',dataType='char',length='4')
		    .addColumn(column='Mailing_USPSDeliveryPoint',dataType='char',length='12')
		    .addColumn(column='Mailing_USPSCheckDigit',dataType='varchar',length='50',nullable=true)
		    .addColumn(column='Mailing_USPSCarrierRoute',dataType='varchar',length='50',nullable=true)
		    .addColumn(column='Mailing_isAddressVerified',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Physical_Address',dataType='varchar',length='255')
		    .addColumn(column='Physical_City',dataType='char',length='50')
		    .addColumn(column='Physical_State',dataType='char',length='2')
		    .addColumn(column='Physical_ZipCode',dataType='char',length='5')
		    .addColumn(column='Physical_ZipPlus4',dataType='char',length='4')
		    .addColumn(column='Physical_USPSDeliveryPoint',dataType='varchar',length='12',nullable=true)
		    .addColumn(column='Physical_USPSCheckDigit',dataType='varchar',length='50',nullable=true)
		    .addColumn(column='Physical_USPSCarrierRoute',dataType='varchar',length='50',nullable=true)
		    .addColumn(column='Physical_Latitude',dataType='char',length='12')
		    .addColumn(column='Physical_Longitude',dataType='char',length='12')
		    .addColumn(column='Physical_TimeZone',dataType='char',length='50')
		    .addColumn(column='Physical_DST',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Physical_UTCOffset',dataType='char',length='10')
		    .addColumn(column='Physical_CountyName',dataType='char',length='30')
		    .addColumn(column='Physical_CongressionalDistrict',dataType='char',length='30')
		    .addColumn(column='Physical_CountyFIPS',dataType='varchar',length='50',nullable=true)
		    .addColumn(column='Physical_isAddressVerified',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='AccountsPayable_ContactName',dataType='varchar',length='100')
		    .addColumn(column='AccountsPayable_EmailAddress',dataType='varchar',length='255')
		    .addColumn(column='ReceiveInvoicesByEmail',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='PrimaryVoiceNumber',dataType='char',length='14')
		    .addColumn(column='PrimaryFaxNumber',dataType='char',length='14')
		    .addColumn(column='BusinessWebsite',dataType='varchar',length='255')
		    .addColumn(column='dateCreated',dataType='datetime')
		    .addColumn(column='lastUpdated',dataType='datetime')
		    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
		    .addColumn(column='lastUpdateByID',dataType='char',length='35')
		    .addColumn(column='Active',dataType='boolean',default=0,nullable=false)
		    .addPrimaryKey(column='TContent_ID');

	    var dbMembershipBuildings = application.configbean.getBean('dbUtility');
	    dbMembershipBuildings.setTable('p_EventRegistration_MembershipBuildings')
		    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
		    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		    .addColumn(column='MembershipDistrict_ID',dataType='int',nullable=false)
		    .addColumn(column='OrganizationName',dataType='char',length='50',nullable=false)
		    .addColumn(column='StateDOE_IDNumber',dataType='char',length='10',nullable=true)
		    .addColumn(column='StateDOE_State',dataType='char',length='50',nullable=true)
		    .addColumn(column='Mailing_Address',dataType='varchar',length='255')
		    .addColumn(column='Mailing_City',dataType='char',length='50')
		    .addColumn(column='Mailing_State',dataType='char',length='2')
		    .addColumn(column='Mailing_ZipCode',dataType='char',length='5')
		    .addColumn(column='Mailing_ZipPlus4',dataType='char',length='4')
		    .addColumn(column='Mailing_DeliveryPointBarCode',dataType='char',length='12')
		    .addColumn(column='Physical_Address',dataType='varchar',length='255')
		    .addColumn(column='Physical_City',dataType='char',length='50')
		    .addColumn(column='Physical_State',dataType='char',length='2')
		    .addColumn(column='Physical_ZipCode',dataType='char',length='5')
		    .addColumn(column='Physical_ZipPlus4',dataType='char',length='4')
		    .addColumn(column='Physical_DeliveryPointBarCode',dataType='char',length='12')
		    .addColumn(column='Physical_Latitude',dataType='char',length='12')
		    .addColumn(column='Physical_Longitude',dataType='char',length='12')
		    .addColumn(column='Physical_TimeZone',dataType='char',length='50')
		    .addColumn(column='Physical_DST',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Physical_UTCOffset',dataType='char',length='10')
		    .addColumn(column='Physical_CountyName',dataType='char',length='30')
		    .addColumn(column='Physical_CongressionalDistrict',dataType='char',length='30')
		    .addColumn(column='Physical_CarrierRoute',dataType='char',length='30')
		    .addColumn(column='PrimaryVoiceNumber',dataType='char',length='14')
		    .addColumn(column='BusinessWebsite',dataType='varchar',length='255')
		    .addColumn(column='dateCreated',dataType='datetime')
		    .addColumn(column='lastUpdated',dataType='datetime')
		    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
		    .addColumn(column='lastUpdateByID',dataType='char',length='35')
		    .addColumn(column='isAddressVerified',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Active',dataType='boolean',default=0,nullable=false)
		    .addPrimaryKey(column='TContent_ID')
		    .addIndex(column='MembershipDistrict_ID');

	    var dbShortURL = application.configbean.getBean('dbUtility');
	    dbShortURL.setTable('p_EventRegistration_ShortURL')
		    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
		    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		    .addColumn(column='FullLink',dataType='longtext',nullable=true)
		    .addColumn(column='ShortLink',dataType='varchar',length='255')
		    .addColumn(column='dateCreated',dataType='datetime')
		    .addColumn(column='lastUpdated',dataType='datetime')
		    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
		    .addColumn(column='lastUpdateByID',dataType='char',length='35')
		    .addColumn(column='Active',dataType='boolean',default=0,nullable=false)
		    .addPrimaryKey(column='TContent_ID');

		var dbSiteConfig = application.configbean.getBean('dbUtility');
	  	dbSiteConfig.setTable('p_EventRegistration_SiteConfig')
		    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
		    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		    .addColumn(column='dateCreated',dataType='datetime')
		    .addColumn(column='lastUpdated',dataType='datetime')
		    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
		    .addColumn(column='lastUpdateByID',dataType='char',length='35')
		    .addColumn(column='ProcessPayments_Stripe',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Stripe_TestMode',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Stripe_TestAPIKey',dataType='char',length='50',nullable=true)
		    .addColumn(column='Stripe_LiveAPIKey',dataType='char',length='50',nullable=true)
		    .addColumn(column='Facebook_Enabled',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Facebook_AppID',dataType='char',length='50',nullable=true)
		    .addColumn(column='Facebook_AppSecretKey',dataType='char',length='50',nullable=true)
		    .addColumn(column='Facebook_PageID',dataType='char',length='50',nullable=true)
		    .addColumn(column='Facebook_AppScope',dataType='char',length='50',nullable=true)
		    .addColumn(column='Google_ReCaptchaEnabled',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='Google_ReCaptchaSiteKey',dataType='char',length='50',nullable=true)
		    .addColumn(column='Google_ReCaptchaSecretKey',dataType='char',length='50',nullable=true)
		    .addColumn(column='SmartyStreets_Enabled',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='SmartyStreets_APIID',dataType='char',length='50',nullable=true)
		    .addColumn(column='SmartyStreets_APIToken',dataType='char',length='50',nullable=true)
		    .addColumn(column='GitHub_URL',dataType='char',length='150',nullable=true)
		    .addColumn(column='Twitter_URL',dataType='char',length='150',nullable=true)
		    .addColumn(column='Facebook_URL',dataType='char',length='150',nullable=true)
		    .addColumn(column='GoogleProfile_URL',dataType='char',length='150',nullable=true)
		    .addColumn(column='LinkedIn_URL',dataType='char',length='150',nullable=true)
		    .addColumn(column='BillForNoShowRegistrations',dataType='boolean',default=0,nullable=false)
		    .addPrimaryKey(column='TContent_ID');

		var dbStateESCOrganizations = application.configbean.getBean('dbUtility');
		dbStateESCOrganizations.setTable('p_EventRegistration_StateESCOrganizations')
	        .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
	        .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
	        .addColumn(column='OrganizationName',dataType='char',length='50',nullable=false)
	        .addColumn(column='OrganizationDomainName',dataType='char',length='150',nullable=false)
	        .addColumn(column='StateDOE_IDNumber',dataType='char',length='10',nullable=true)
	        .addColumn(column='StateDOE_State',dataType='char',length='50',nullable=true)
	        .addColumn(column='Mailing_Address',dataType='varchar',length='255')
	        .addColumn(column='Mailing_City',dataType='char',length='50')
	        .addColumn(column='Mailing_State',dataType='char',length='2')
	        .addColumn(column='Mailing_ZipCode',dataType='char',length='5')
	        .addColumn(column='Mailing_ZipPlus4',dataType='char',length='4')
	        .addColumn(column='Mailing_USPSDeliveryPoint',dataType='char',length='12')
	        .addColumn(column='Mailing_USPSCheckDigit',dataType='varchar',length='50',nullable=true)
	        .addColumn(column='Mailing_USPSCarrierRoute',dataType='varchar',length='50',nullable=true)
	        .addColumn(column='Mailing_isAddressVerified',dataType='boolean',default=0,nullable=false)
	        .addColumn(column='Physical_Address',dataType='varchar',length='255')
	        .addColumn(column='Physical_City',dataType='char',length='50')
	        .addColumn(column='Physical_State',dataType='char',length='2')
	        .addColumn(column='Physical_ZipCode',dataType='char',length='5')
	        .addColumn(column='Physical_ZipPlus4',dataType='char',length='4')
	        .addColumn(column='Physical_USPSDeliveryPoint',dataType='varchar',length='12',nullable=true)
	        .addColumn(column='Physical_USPSCheckDigit',dataType='varchar',length='50',nullable=true)
	        .addColumn(column='Physical_USPSCarrierRoute',dataType='varchar',length='50',nullable=true)
	        .addColumn(column='Physical_Latitude',dataType='char',length='12')
	        .addColumn(column='Physical_Longitude',dataType='char',length='12')
	        .addColumn(column='Physical_TimeZone',dataType='char',length='50')
	        .addColumn(column='Physical_DST',dataType='boolean',default=0,nullable=false)
	        .addColumn(column='Physical_UTCOffset',dataType='char',length='10')
	        .addColumn(column='Physical_CountyName',dataType='char',length='30')
	        .addColumn(column='Physical_CongressionalDistrict',dataType='char',length='30')
	        .addColumn(column='Physical_CountyFIPS',dataType='varchar',length='50',nullable=true)
	        .addColumn(column='Physical_isAddressVerified',dataType='boolean',default=0,nullable=false)
	        .addColumn(column='PrimaryVoiceNumber',dataType='char',length='14')
	        .addColumn(column='PrimaryFaxNumber',dataType='char',length='14')
	        .addColumn(column='BusinessWebsite',dataType='varchar',length='255')
	        .addColumn(column='dateCreated',dataType='datetime')
	        .addColumn(column='lastUpdated',dataType='datetime')
	        .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
	        .addColumn(column='lastUpdateByID',dataType='char',length='35')
	        .addColumn(column='Active',dataType='boolean',default=0,nullable=false)
	        .addPrimaryKey(column='TContent_ID');     

		var dbUserMatrix = application.configbean.getBean('dbUtility');
		dbUserMatrix.setTable('p_EventRegistration_UserMatrix')
		    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
		    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		    .addColumn(column='User_ID',dataType='char',length='35',nullable=false)
		    .addColumn(column='SchoolDistrict_ID',dataType='int',nullable=true)
		    .addColumn(column='SchoolBuilding_ID',dataType='int',nullable=true)
		    .addColumn(column='GradeLevel',dataType='int',nullable=true)
		    .addColumn(column='GradeSubject',dataType='int',nullable=true)
		    .addColumn(column='dateCreated',dataType='datetime')
		    .addColumn(column='lastUpdated',dataType='datetime')
		    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
		    .addColumn(column='lastUpdateByID',dataType='char',length='35')
		    .addColumn(column='ReceiveMarketingFlyers',dataType='boolean',default=0,nullable=false)
		    .addPrimaryKey(column='TContent_ID')
		    .addIndex(column='User_ID');

		var dbUserRegistrations = application.configbean.getBean('dbUtility');
        dbUserRegistrations.setTable('p_EventRegistration_UserRegistrations')
		    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
		    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		    .addColumn(column='User_ID',dataType='char',length='35',nullable=false)
		    .addColumn(column='Event_ID',dataType='int',nullable=false)
		    .addColumn(column='RegistrationID',dataType='char',length='35',nullable=false)
		    .addColumn(column='RegistrationDate',dataType='datetime')
		    .addColumn(column='IVCParticipant',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='OnWaitingList',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='AttendedEventDate1',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='AttendedEventDate2',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='AttendedEventDate3',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='AttendedEventDate4',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='AttendedEventDate5',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='AttendedEventDate6',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='AttendedEventSessionAM',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='AttendedEventSessionPM',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='RegisterFOrEventDate1',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='RegisterFOrEventDate2',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='RegisterFOrEventDate3',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='RegisterFOrEventDate4',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='RegisterFOrEventDate5',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='RegisterFOrEventDate6',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='RegisterForEventSessionAM',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='RegisterForEventSessionPM',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='AttendeePrice',dataType='double',nullable=false)
		    .addColumn(column='RegistrationIPAddr',dataType='char',length='35',nullable=false)
		    .addColumn(column='RegisterByUserID',dataType='char',length='35',nullable=false)
		    .addColumn(column='Comments',dataType='longtext',nullable=true)
		    .addColumn(column='WeminarParticipant',dataType='boolean',default=0,nullable=false)
		    .addColumn(column='AttendeePriceVerified',dataType='boolean',default=0,nullable=false)
		    .addPrimaryKey(column='TContent_ID')
		    .addIndex(column='Event_ID')
		    .addIndex(column='User_ID');

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
	}

	public void function update() {
		// triggered by the pluginManager when the plugin is UPDATED.
		application.appInitialized = false;

		var dbSiteConfig = application.configbean.getBean('dbUtility');
	  	dbSiteConfig.setTable('p_EventRegistration_SiteConfig')
	  	 .addColumn(column='BillForNoShowRegistrations',dataType='boolean',default=0,nullable=false);

	}
	
	public void function delete() {
		// triggered by the pluginManager when the plugin is DELETED.
		application.appInitialized = false;

		var dbWorker = application.configbean.getBean('dbUtility');
		dbWorker.dropTable('p_EventRegistration_Caterers');
		dbWorker.dropTable('p_EventRegistration_EventEmailLog');
		dbWorker.dropTable('p_EventRegistration_EventExpenses');
		dbWorker.dropTable('p_EventRegistration_EventResources');
		dbWorker.dropTable('p_EventRegistration_ExpenseList');
		dbWorker.dropTable('p_EventRegistration_Events');
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


		deleteGroups = new Query(datasource='#application.configBean.getDatasource()#', sql="Delete from tusers where GroupName LIKE :GroupPartName");
	    deleteGroups.addParam(name="GroupPartName", value="%Event%",CFSQLTYPE="CF_SQL_VARCHAR");
	    deleteGroupsResults = deleteGroups.execute();
	}

}