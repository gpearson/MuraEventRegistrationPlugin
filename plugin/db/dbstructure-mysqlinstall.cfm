<cfset dbTableCaterers = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_Caterers')>
<cfscript>
	dbTableCaterers.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='FacilityName',dataType='varchar',length='255',nullable=false)
		.addColumn(column='PhysicalAddress',dataType='longtext',nullable=true)
		.addColumn(column='PhysicalCity',dataType='char',length='50',nullable=true)
		.addColumn(column='PhysicalState',dataType='char',length='2',nullable=true)
		.addColumn(column='PhysicalZipCode',dataType='char',length='5',nullable=true)
		.addColumn(column='PhysicalZip4',dataType='char',length='4',nullable=true)
		.addColumn(column='PrimaryVoiceNumber',dataType='char',length='14',nullable=true)
		.addColumn(column='BusinessWebsite',dataType='varchar',length='255',nullable=true)
		.addColumn(column='ContactName',dataType='varchar',length='255',nullable=true)
		.addColumn(column='ContactPhoneNumber',dataType='char',length='14',nullable=true)
		.addColumn(column='ContactEmail',dataType='varchar',length='255',nullable=true)
		.addColumn(column='PaymentTerms',dataType='longtext',nullable=true)
		.addColumn(column='DeliveryInfo',dataType='longtext',nullable=true)
		.addColumn(column='GuaranteeInformation',dataType='longtext',nullable=true)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addColumn(column='Physical_isAddressVerified',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Physical_Latitude',dataType='char',length='20',nullable=true)
		.addColumn(column='Physical_Longitude',dataType='char',length='20',nullable=true)
		.addColumn(column='Physical_USPSDeliveryPoint',dataType='char',length='12',nullable=true)
		.addColumn(column='Physical_USPSCheckDigit',dataType='char',length='50',nullable=true)
		.addColumn(column='Physical_USPSCarrierRoute',dataType='char',length='50',nullable=true)
		.addColumn(column='Physical_DST',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Physical_UTCOffset',dataType='char',length='10',nullable=true)
		.addColumn(column='Physical_TimeZone',dataType='char',length='10',nullable=true)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addPrimaryKey(column='TContent_ID');
		.addIndex(column='Site_ID');
</cfscript>

<cfset dbTableEventEmailLog = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_EventEmailLog')>
<cfscript>
	dbTableEventEmailLog.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='Event_ID',dataType='integer',nullable=false)
		.addColumn(column='MsgBody',dataType='longtext',nullable=false)
		.addColumn(column='EmailType',dataType='longtext',nullable=false)
		.addColumn(column='LinksToInclude',dataType='longtext',nullable=true)
		.addColumn(column='DocsToInclude',dataType='longtext',nullable=true)
		.addColumn(column='EmailSentToParticipants',dataType='longtext',nullable=true)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addPrimaryKey(column='TContent_ID')
		.addIndex(column='Event_ID');
</cfscript>

<cfset dbTableEventExpenses = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_EventExpenses')>
<cfscript>
	dbTableEventExpenses.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='Event_ID',dataType='integer',nullable=false)
		.addColumn(column='Expense_ID',dataType='integer',nullable=false)
		.addColumn(column='Cost_Amount',dataType='double', nullable=false)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Cost_Verified',dataType='tinyint',nullable=false,default=0)
		.addPrimaryKey(column='TContent_ID')
		.addIndex(column='Event_ID');
</cfscript>

<cfset dbTableEventResources = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_EventResources')>
<cfscript>
	dbTableEventResources.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='Event_ID',dataType='integer',nullable=false)
		.addColumn(column='ResourceType',dataType='char',length='1',nullable=true)
		.addColumn(column='ResourceDocument',dataType='longtext',nullable=true)
		.addColumn(column='ResourceContentType',dataType='varchar',length='50',nullable=true)
		.addColumn(column='ResourceDocumentSize',dataType='longtext',nullable=true)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addPrimaryKey(column='TContent_ID')
		.addIndex(column='Event_ID');
</cfscript>

<cfset dbTableEventExpenseList = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_ExpenseList')>
<cfscript>
	dbTableEventExpenseList.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='Expense_Name',dataType='varchar',length='100',nullable=true)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addPrimaryKey(column='TContent_ID');
</cfscript>

<cfset dbTableEvents = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_Events')>
<cfscript>
	dbTableEvents.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='ShortTitle',dataType='varchar',length='100',nullable=false)
		.addColumn(column='EventDate',dataType='datetime',nullable=false)
		.addColumn(column='EventDate1',dataType='datetime',length='10',nullable=true)
		.addColumn(column='EventDate2',dataType='datetime',length='10',nullable=true)
		.addColumn(column='EventDate3',dataType='datetime',length='10',nullable=true)
		.addColumn(column='EventDate4',dataType='datetime',length='10',nullable=true)
		.addColumn(column='EventDate5',dataType='datetime',length='10',nullable=true)
		.addColumn(column='EventDate6',dataType='datetime',length='10',nullable=true)
		.addColumn(column='Event_HasMultipleDates',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='LongDescription',dataType='longtext',nullable=true)
		.addColumn(column='EventAgenda',dataType='longtext',nullable=true)
		.addColumn(column='EventTargetAudience',dataType='longtext',nullable=true)
		.addColumn(column='EventStrategies',dataType='longtext',nullable=true)
		.addColumn(column='EventSpecialInstructions',dataType='longtext',nullable=true)
		.addColumn(column='Event_SpecialMessage',dataType='longtext',nullable=true)
		.addColumn(column='Event_StartTime',dataType='char',length='8',nullable=true)
		.addColumn(column='Event_EndTime',dataType='char',length='8',nullable=true)
		.addColumn(column='Event_MemberCost',dataType='double', nullable=false)
		.addColumn(column='Event_NonMemberCost',dataType='double', nullable=false)
		.addColumn(column='Event_HeldAtFacilityID',dataType='integer',nullable=false)
		.addColumn(column='Event_FacilityRoomID',dataType='integer',nullable=false)
		.addColumn(column='Event_MaxParticipants',dataType='integer',nullable=false)
		.addColumn(column='Registration_Deadline',dataType='datetime',nullable=false)
		.addColumn(column='Registration_BeginTime',dataType='char',length='8',nullable=false)
		.addColumn(column='Registration_EndTime',dataType='char',length='8',nullable=false)
		.addColumn(column='Featured_Event',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Featured_StartDate',dataType='datetime',nullable=true)
		.addColumn(column='Featured_EndDate',dataType='datetime',nullable=true)
		.addColumn(column='Featured_SortOrder',dataType='integer',nullable=false,default=0)
		.addColumn(column='EarlyBird_Available',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='EarlyBird_Deadline',dataType='datetime',nullable=true)
		.addColumn(column='EarlyBird_MemberCost',dataType='double', nullable=true)
		.addColumn(column='EarlyBird_NonMemberCost',dataType='double', nullable=true)
		.addColumn(column='GroupPrice_Available',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='GroupPrice_Requirements',dataType='longtext',nullable=true)
		.addColumn(column='GroupPrice_MemberCost',dataType='double', nullable=true)
		.addColumn(column='GroupPrice_NonMemberCost',dataType='double', nullable=true)
		.addColumn(column='PGPCertificate_Available',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='PGPCertificate_Points',dataType='double', nullable=true)
		.addColumn(column='Meal_Available',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Meal_Included',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Meal_Information',dataType='longtext',nullable=true)
		.addColumn(column='Meal_Cost',dataType='double', nullable=true)
		.addColumn(column='Meal_ProvidedBy',dataType='integer',nullable=false,default=0)
		.addColumn(column='PresenterID',dataType='char',length='35',nullable=true)
		.addColumn(column='FacilitatorID',dataType='char',length='35',nullable=false)
		.addColumn(column='Webinar_Available',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Webinar_ConnectInfo',dataType='longtext',nullable=true)
		.addColumn(column='Webinar_MemberCost',dataType='double', nullable=true)
		.addColumn(column='Webinar_NonMemberCost',dataType='double', nullable=true)
		.addColumn(column='Event_DailySessions',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Event_Session1BeginTime',dataType='char',length='8',nullable=true)
		.addColumn(column='Event_Session1EndTime',dataType='char',length='8',nullable=true)
		.addColumn(column='Event_Session2BeginTime',dataType='char',length='8',nullable=true)
		.addColumn(column='Event_Session2EndTime',dataType='char',length='8',nullable=true)
		.addColumn(column='H323_Available',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='H323_ConnectInfo',dataType='longtext',nullable=true)
		.addColumn(column='H323_MemberCost',dataType='double', nullable=true)
		.addColumn(column='H323_NonMemberCost',dataType='double', nullable=true)
		.addColumn(column='WhatIf_MealCostPerAttendee',dataType='double', nullable=true)
		.addColumn(column='WhatIf_FacilityCostTotal',dataType='double', nullable=true)
		.addColumn(column='WhatIf_PresenterCostTotal',dataType='double', nullable=true)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='AcceptRegistrations',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='EventCancelled',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='EventInvoicesGenerated',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='BillForNoShow',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='PGPCertificatesGenerated',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='EventPricePerDay',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='PostedTo_Facebook',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='PostedTo_Twitter',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Event_OptionalCosts',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addPrimaryKey(column='TContent_ID');
</cfscript>

<cfset dbTableFacilities = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_Facility')>
<cfscript>
	dbTableFacilities.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='FacilityName',dataType='varchar',length='255',nullable=false)
		.addColumn(column='PhysicalAddress',dataType='longtext',nullable=true)
		.addColumn(column='PhysicalCity',dataType='char',length='50',nullable=true)
		.addColumn(column='PhysicalState',dataType='char',length='2',nullable=true)
		.addColumn(column='PhysicalZipCode',dataType='char',length='5',nullable=true)
		.addColumn(column='PhysicalZip4',dataType='char',length='4',nullable=true)
		.addColumn(column='Physical_isAddressVerified',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Physical_Latitude',dataType='char',length='20',nullable=true)
		.addColumn(column='Physical_Longitude',dataType='char',length='20',nullable=true)
		.addColumn(column='Physical_USPSDeliveryPoint',dataType='char',length='12',nullable=true)
		.addColumn(column='Physical_USPSCheckDigit',dataType='char',length='50',nullable=true)
		.addColumn(column='Physical_USPSCarrierRoute',dataType='char',length='50',nullable=true)
		.addColumn(column='Physical_DST',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Physical_UTCOffset',dataType='char',length='10',nullable=true)
		.addColumn(column='Physical_TimeZone',dataType='char',length='10',nullable=true)
		.addColumn(column='MailingAddress',dataType='longtext',nullable=true)
		.addColumn(column='MailingCity',dataType='char',length='50',nullable=true)
		.addColumn(column='MailingState',dataType='char',length='2',nullable=true)
		.addColumn(column='MailingZipCode',dataType='char',length='5',nullable=true)
		.addColumn(column='MailingZip4',dataType='char',length='4',nullable=true)
		.addColumn(column='Mailing_isAddressVerified',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Mailing_USPSDeliveryPoint',dataType='char',length='12',nullable=true)
		.addColumn(column='Mailing_USPSCheckDigit',dataType='char',length='50',nullable=true)
		.addColumn(column='Mailing_USPSCarrierRoute',dataType='char',length='50',nullable=true)
		.addColumn(column='PrimaryVoiceNumber',dataType='char',length='14',nullable=true)
		.addColumn(column='PrimaryFaxNumber',dataType='char',length='14',nullable=true)
		.addColumn(column='BusinessWebsite',dataType='varchar',length='255',nullable=true)
		.addColumn(column='ContactName',dataType='varchar',length='255',nullable=true)
		.addColumn(column='ContactPhoneNumber',dataType='char',length='14',nullable=true)
		.addColumn(column='ContactEmail',dataType='varchar',length='255',nullable=true)
		.addColumn(column='PaymentTerms',dataType='longtext',nullable=true)
		.addColumn(column='AdditionalNotes',dataType='longtext',nullable=true)
		.addColumn(column='Cost_HaveEventAt',dataType='double', nullable=true)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addPrimaryKey(column='TContent_ID');
</cfscript>

<cfset dbTableFacilityRooms = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_FacilityRooms')>
<cfscript>
	dbTableFacilityRooms.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='Facility_ID',dataType='integer',nullable=false)
		.addColumn(column='RoomName',dataType='varchar',length='35',nullable=false)
		.addColumn(column='Capacity',dataType='integer',nullable=false)
		.addColumn(column='RoomFees',dataType='double', nullable=true)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addPrimaryKey(column='TContent_ID')
		.addIndex(column='Facility_ID');
</cfscript>

<cfset dbTableGradeLevels = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_GradeLevels')>
<cfscript>
	dbTableGradeLevels.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='GradeLevel',dataType='varchar',length='75',nullable=false)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addPrimaryKey(column='TContent_ID');
</cfscript>

<cfset dbTableGradeSubjects = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_GradeSubjects')>
<cfscript>
	dbTableGradeSubjects.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='GradeLevelID',dataType='integer',nullable=false)
		.addColumn(column='GradeSubject',dataType='varchar',length='75',nullable=false)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addPrimaryKey(column='TContent_ID')
		.addIndex(column='GradeLevelID');
</cfscript>

<cfset dbTableMembership = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_Membership')>
<cfscript>
	dbTableMembership.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='OrganizationName',dataType='varchar',length='255',nullable=false)
		.addColumn(column='OrganizationDomainName',dataType='varchar',length='255',nullable=false)
		.addColumn(column='PhysicalAddress',dataType='longtext',nullable=true)
		.addColumn(column='PhysicalCity',dataType='char',length='50',nullable=true)
		.addColumn(column='PhysicalState',dataType='char',length='2',nullable=true)
		.addColumn(column='PhysicalZipCode',dataType='char',length='5',nullable=true)
		.addColumn(column='PhysicalZip4',dataType='char',length='4',nullable=true)
		.addColumn(column='Physical_isAddressVerified',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Physical_Latitude',dataType='char',length='20',nullable=true)
		.addColumn(column='Physical_Longitude',dataType='char',length='20',nullable=true)
		.addColumn(column='Physical_USPSDeliveryPoint',dataType='char',length='12',nullable=true)
		.addColumn(column='Physical_USPSCheckDigit',dataType='char',length='50',nullable=true)
		.addColumn(column='Physical_USPSCarrierRoute',dataType='char',length='50',nullable=true)
		.addColumn(column='Physical_DST',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Physical_UTCOffset',dataType='char',length='10',nullable=true)
		.addColumn(column='Physical_TimeZone',dataType='char',length='10',nullable=true)
		.addColumn(column='MailingAddress',dataType='longtext',nullable=true)
		.addColumn(column='MailingCity',dataType='char',length='50',nullable=true)
		.addColumn(column='MailingState',dataType='char',length='2',nullable=true)
		.addColumn(column='MailingZipCode',dataType='char',length='5',nullable=true)
		.addColumn(column='MailingZip4',dataType='char',length='4',nullable=true)
		.addColumn(column='Mailing_isAddressVerified',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Mailing_USPSDeliveryPoint',dataType='char',length='12',nullable=true)
		.addColumn(column='Mailing_USPSCheckDigit',dataType='char',length='50',nullable=true)
		.addColumn(column='Mailing_USPSCarrierRoute',dataType='char',length='50',nullable=true)
		.addColumn(column='PrimaryVoiceNumber',dataType='char',length='14',nullable=true)
		.addColumn(column='PrimaryFaxNumber',dataType='char',length='14',nullable=true)
		.addColumn(column='BusinessWebsite',dataType='varchar',length='255',nullable=true)
		.addColumn(column='StateDOE_IDNumber',dataType='char',length='50',nullable=true)
		.addColumn(column='StateDOE_State',dataType='char',length='50',nullable=true)
		.addColumn(column='StateDOE_ESCESAMembership',dataType='integer',nullable=false,default=0)
		.addColumn(column='AccountsPayable_ContactName',dataType='varchar',length='255',nullable=true)
		.addColumn(column='AccountsPayable_EmailAddress',dataType='varchar',length='255',nullable=true)		
		.addColumn(column='ReceiveInvoicesByEmail',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addPrimaryKey(column='TContent_ID');
</cfscript>

<cfset dbTableMembershipBuildings = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_MembershipBuildings')>
<cfscript>
	dbTableMembershipBuildings.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='MembershipDistrict_ID',dataType='integer',nullable=false)
		.addColumn(column='OrganizationName',dataType='varchar',length='255',nullable=false)
		.addColumn(column='PhysicalAddress',dataType='longtext',nullable=true)
		.addColumn(column='PhysicalCity',dataType='char',length='50',nullable=true)
		.addColumn(column='PhysicalState',dataType='char',length='2',nullable=true)
		.addColumn(column='PhysicalZipCode',dataType='char',length='5',nullable=true)
		.addColumn(column='PhysicalZip4',dataType='char',length='4',nullable=true)
		.addColumn(column='Physical_isAddressVerified',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Physical_Latitude',dataType='char',length='20',nullable=true)
		.addColumn(column='Physical_Longitude',dataType='char',length='20',nullable=true)
		.addColumn(column='Physical_USPSDeliveryPoint',dataType='char',length='12',nullable=true)
		.addColumn(column='Physical_USPSCheckDigit',dataType='char',length='50',nullable=true)
		.addColumn(column='Physical_USPSCarrierRoute',dataType='char',length='50',nullable=true)
		.addColumn(column='Physical_DST',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Physical_UTCOffset',dataType='char',length='10',nullable=true)
		.addColumn(column='Physical_TimeZone',dataType='char',length='10',nullable=true)
		.addColumn(column='MailingAddress',dataType='longtext',nullable=true)
		.addColumn(column='MailingCity',dataType='char',length='50',nullable=true)
		.addColumn(column='MailingState',dataType='char',length='2',nullable=true)
		.addColumn(column='MailingZipCode',dataType='char',length='5',nullable=true)
		.addColumn(column='MailingZip4',dataType='char',length='4',nullable=true)
		.addColumn(column='Mailing_isAddressVerified',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Mailing_USPSDeliveryPoint',dataType='char',length='12',nullable=true)
		.addColumn(column='Mailing_USPSCheckDigit',dataType='char',length='50',nullable=true)
		.addColumn(column='Mailing_USPSCarrierRoute',dataType='char',length='50',nullable=true)
		.addColumn(column='PrimaryVoiceNumber',dataType='char',length='14',nullable=true)
		.addColumn(column='PrimaryFaxNumber',dataType='char',length='14',nullable=true)
		.addColumn(column='StateDOE_IDNumber',dataType='char',length='50',nullable=true)
		.addColumn(column='StateDOE_State',dataType='char',length='50',nullable=true)
		.addColumn(column='StateDOE_ESCESAMembership',dataType='integer',nullable=false,default=0)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addPrimaryKey(column='TContent_ID')
		.addIndex(column='MembershipDistrict_ID');
</cfscript>

<cfset dbTableShortURL = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_ShortURL')>
<cfscript>
	dbTableShortURL.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='FullLink',dataType='longtext',nullable=false)
		.addColumn(column='ShortLink',dataType='char',length='50',nullable=false)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addPrimaryKey(column='TContent_ID');
</cfscript>

<cfset dbTableSiteConfig = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_SiteConfig')>
<cfscript>
	dbTableSiteConfig.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='Stripe_ProcessPayments',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Stripe_TestMode',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Stripe_TestAPIKey',dataType='varchar',length='50',nullable=true)
		.addColumn(column='Stripe_LiveAPIKey',dataType='varchar',length='50',nullable=true)
		.addColumn(column='Facebook_Enabled',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Facebook_AppID',dataType='varchar',length='50',nullable=true)
		.addColumn(column='Facebook_AppSecretKey',dataType='varchar',length='50',nullable=true)
		.addColumn(column='Facebook_PageID',dataType='varchar',length='50',nullable=true)
		.addColumn(column='Facebook_AppScope',dataType='varchar',length='50',nullable=true)
		.addColumn(column='GoogleReCaptcha_Enabled',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='GoogleReCaptcha_SiteKey',dataType='varchar',length='50',nullable=true)
		.addColumn(column='GoogleReCaptcha_SecretKey',dataType='varchar',length='50',nullable=true)
		.addColumn(column='SmartyStreets_Enabled',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='SmartyStreets_APIID',dataType='varchar',length='50',nullable=true)
		.addColumn(column='SmartyStreets_APIToken',dataType='varchar',length='50',nullable=true)
		.addColumn(column='Twitter_Enabled',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Twitter_ConsumerKey',dataType='varchar',length='50',nullable=true)
		.addColumn(column='Twitter_ConsumerSecret',dataType='varchar',length='50',nullable=true)
		.addColumn(column='Twitter_AccessToken',dataType='varchar',length='50',nullable=true)
		.addColumn(column='Twitter_AccessTokenSecret',dataType='varchar',length='50',nullable=true)
		.addColumn(column='BillForNoShowRegistrations',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='RequireSurveyToGetCertificate',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='GitHub_URL',dataType='varchar',length='50',nullable=true)
		.addColumn(column='Twitter_URL',dataType='varchar',length='50',nullable=true)
		.addColumn(column='Facebook_URL',dataType='varchar',length='50',nullable=true)
		.addColumn(column='GoogleProfile_URL',dataType='varchar',length='50',nullable=true)
		.addColumn(column='LinkedIn_URL',dataType='varchar',length='50',nullable=true)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addPrimaryKey(column='TContent_ID');
</cfscript>

<cfset dbTableUserMatrix = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_UserMatrix')>
<cfscript>
	dbTableUserMatrix.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='User_ID',dataType='char',length='35',nullable=false)
		.addColumn(column='SchoolDistrictID',dataType='integer',nullable=false,default=0)
		.addColumn(column='SchoolBuildingID',dataType='integer',nullable=false,default=0)
		.addColumn(column='GradeLevelID',dataType='integer',nullable=false,default=0)
		.addColumn(column='GradeSubjectID',dataType='integer',nullable=false,default=0)
		.addColumn(column='ReceiveMarketingFlyers',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addPrimaryKey(column='TContent_ID')
		.addIndex(column='User_ID');
</cfscript>

<cfset dbTableStateESCESAOrganizations = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_StateESCOrganizations')>
<cfscript>
	dbTableStateESCESAOrganizations.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='OrganizationName',dataType='varchar',length='255',nullable=false)
		.addColumn(column='PhysicalAddress',dataType='longtext',nullable=true)
		.addColumn(column='PhysicalCity',dataType='char',length='50',nullable=true)
		.addColumn(column='PhysicalState',dataType='char',length='2',nullable=true)
		.addColumn(column='PhysicalZipCode',dataType='char',length='5',nullable=true)
		.addColumn(column='PhysicalZip4',dataType='char',length='4',nullable=true)
		.addColumn(column='Physical_isAddressVerified',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Physical_Latitude',dataType='char',length='20',nullable=true)
		.addColumn(column='Physical_Longitude',dataType='char',length='20',nullable=true)
		.addColumn(column='Physical_USPSDeliveryPoint',dataType='char',length='12',nullable=true)
		.addColumn(column='Physical_USPSCheckDigit',dataType='char',length='50',nullable=true)
		.addColumn(column='Physical_USPSCarrierRoute',dataType='char',length='50',nullable=true)
		.addColumn(column='Physical_DST',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Physical_UTCOffset',dataType='char',length='10',nullable=true)
		.addColumn(column='Physical_TimeZone',dataType='char',length='10',nullable=true)
		.addColumn(column='MailingAddress',dataType='longtext',nullable=true)
		.addColumn(column='MailingCity',dataType='char',length='50',nullable=true)
		.addColumn(column='MailingState',dataType='char',length='2',nullable=true)
		.addColumn(column='MailingZipCode',dataType='char',length='5',nullable=true)
		.addColumn(column='MailingZip4',dataType='char',length='4',nullable=true)
		.addColumn(column='Mailing_isAddressVerified',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='Mailing_USPSDeliveryPoint',dataType='char',length='12',nullable=true)
		.addColumn(column='Mailing_USPSCheckDigit',dataType='char',length='50',nullable=true)
		.addColumn(column='Mailing_USPSCarrierRoute',dataType='char',length='50',nullable=true)
		.addColumn(column='PrimaryVoiceNumber',dataType='char',length='14',nullable=true)
		.addColumn(column='PrimaryFaxNumber',dataType='char',length='14',nullable=true)
		.addColumn(column='Website',dataType='varchar',length='255',nullable=false)
		.addColumn(column='StateDOE_IDNumber',dataType='char',length='50',nullable=true)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addColumn(column='Active',dataType='tinyint',nullable=false,default=0)
		.addPrimaryKey(column='TContent_ID');
</cfscript>

<cfset dbTableUserRegistrations = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_UserRegistrations')>
<cfscript>
	dbTableUserRegistrations.addColumn(column='TContent_ID',dataType='integer',nullable=false,autoincrement=true)
		.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
		.addColumn(column='User_ID',dataType='char',length='35',nullable=false)
		.addColumn(column='Event_ID',dataType='integer',nullable=false,default=0)
		.addColumn(column='RegistrationID',dataType='char',length='35',nullable=false)
		.addColumn(column='RegistrationDate',dataType='datetime',nullable=false)
		.addColumn(column='OnWaitingList',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='AttendeePrice',dataType='double', nullable=true)
		.addColumn(column='AttendeePriceVerified',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='RequestsMeal',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='WebinarParticipant',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='H323Participant',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='RegisterForEventDate1',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='RegisterForEventDate2',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='RegisterForEventDate3',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='RegisterForEventDate4',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='RegisterForEventDate5',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='RegisterForEventDate6',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='RegisterForEventSessionAM',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='RegisterForEventSessionPM',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='AttendedEventDate1',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='AttendedEventDate2',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='AttendedEventDate3',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='AttendedEventDate4',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='AttendedEventDate5',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='AttendedEventDate6',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='AttendedEventSessionAM',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='AttendedEventSessionPM',dataType='tinyint',nullable=false,default=0)
		.addColumn(column='RegistrationIPAddr',dataType='char',length='35',nullable=false)
		.addColumn(column='RegisteredByUserID',dataType='char',length='35',nullable=false)
		.addColumn(column='Comments',dataType='longtext',nullable=true)
		.addColumn(column='dateCreated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdated',dataType='datetime',nullable=false)
		.addColumn(column='lastUpdateBy',dataType='varchar',length='100',nullable=true)
		.addColumn(column='lastUpdateByID',dataType='varchar',length='35',nullable=true)
		.addPrimaryKey(column='TContent_ID')
		.addIndex(column='User_ID');
		.addIndex(column='Site_ID');
</cfscript>