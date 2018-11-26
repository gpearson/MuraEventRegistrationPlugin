
<cfscript>
  var dbWorker = application.configbean.getBean('dbUtility');

  dbWorker.setTable('p_EventRegistration_Caterers')
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

  dbWorker.setTable('p_EventRegistration_EventEmailLog')
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

  dbWorker.setTable('p_EventRegistration_EventExpenses')
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

  dbWorker.setTable('p_EventRegistration_EventResources')
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

  dbWorker.setTable('p_EventRegistration_ExpenseList')
    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
    .addColumn(column='Expense_Name',dataType='varchar',length='100',nullable=false)
    .addColumn(column='Active',dataType='boolean',default=0,nullable=false)
    .addColumn(column='dateCreated',dataType='datetime')
    .addColumn(column='lastUpdated',dataType='datetime')
    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
    .addColumn(column='lastUpdateByID',dataType='varchar',length='35')
    .addPrimaryKey(column='TContent_ID');


  dbWorker.setTable('p_EventRegistration_Events')
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

  dbWorker.setTable('p_EventRegistration_Facility')
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


  dbWorker.setTable('p_EventRegistration_FacilityRooms')
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

  dbWorker.setTable('p_EventRegistration_GradeLevels')
    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
    .addColumn(column='GradeLevel',dataType='char',length='50',nullable=false)
    .addColumn(column='dateCreated',dataType='datetime')
    .addColumn(column='lastUpdated',dataType='datetime')
    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
    .addColumn(column='lastUpdateByID',dataType='char',length='35')
    .addPrimaryKey(column='TContent_ID');

  dbWorker.setTable('p_EventRegistration_GradeSubjects')
    .addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
    .addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
    .addColumn(column='GradeLevel',dataType='int',nullable=false)
    .addColumn(column='GradeSubject',dataType='char',length='50',nullable=false)
    .addColumn(column='dateCreated',dataType='datetime')
    .addColumn(column='lastUpdated',dataType='datetime')
    .addColumn(column='lastUpdateBy',dataType='varchar',length='255')
    .addColumn(column='lastUpdateByID',dataType='char',length='35')
    .addPrimaryKey(column='TContent_ID');

  dbWorker.setTable('p_EventRegistration_Membership')
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

  dbWorker.setTable('p_EventRegistration_MembershipBuildings')
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

  dbWorker.setTable('p_EventRegistration_ShortURL')
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

  dbWorker.setTable('p_EventRegistration_SiteConfig')
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
    .addPrimaryKey(column='TContent_ID');

  dbWorker.setTable('p_EventRegistration_StateESCOrganizations')
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

  dbWorker.setTable('p_EventRegistration_UserMatrix')
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
    .addIndex(column='User_ID')
    ;

  dbWorker.setTable('p_EventRegistration_UserRegistrations')
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
</cfscript>

<cfquery name='CheckGroups' datasource='#application.configBean.getDatasource()#' username='#application.configBean.getDBUsername()#' password='#application.configBean.getDBPassword()#'>
  Select UserID, GroupName
  From tusers
  Where GroupName LIKE '%Event%'
</cfquery>
<cfif CheckGroups.RecordCount EQ 0>
  <cfscript>
    var NewGroupEventFacilitator = #application.userManager.read('')#;
    NewGroupEventFacilitator.setSiteID(Session.SiteID);
    NewGroupEventFacilitator.setGroupName('Event Facilitator');
    NewGroupEventFacilitator.setType(1);
    NewGroupEventFacilitator.setIsPublic(1);
    NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
  </cfscript>
  <cfscript>
    var NewGroupEventFacilitator = #application.userManager.read('')#;
    NewGroupEventFacilitator.setSiteID(Session.SiteID);
    NewGroupEventFacilitator.setGroupName('Event Presenter');
    NewGroupEventFacilitator.setType(1);
    NewGroupEventFacilitator.setIsPublic(1);
    NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
  </cfscript>
<cfelse>
  <cfset GroupPresenterExists = 0>
  <cfset GroupFacilitatorExists = 0>
  <cfloop query='CheckGroups'>
    <cfif CheckGroups.GroupName EQ 'Event Facilitator'>
      <cfset GroupFacilitatorExists = 1>
    </cfif>
    <cfif CheckGroups.GroupName EQ 'Event Presenter'>
      <cfset GroupPresenterExists = 1>
    </cfif>
  </cfloop>
  <cfif GroupFacilitatorExists EQ 0>
    <cfscript>
    var NewGroupEventFacilitator = #application.userManager.read('')#;
    NewGroupEventFacilitator.setSiteID(Session.SiteID);
    NewGroupEventFacilitator.setGroupName('Event Facilitator');
    NewGroupEventFacilitator.setType(1);
    NewGroupEventFacilitator.setIsPublic(1);
    NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
    </cfscript>
  </cfif>
  <cfif GroupPresenterExists EQ 0>
    <cfscript>
    var NewGroupEventFacilitator = #application.userManager.read('')#;
    NewGroupEventFacilitator.setSiteID(Session.SiteID);
    NewGroupEventFacilitator.setGroupName('Event Presenter');
    NewGroupEventFacilitator.setType(1);
    NewGroupEventFacilitator.setIsPublic(1);
    NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
    </cfscript>
  </cfif>
</cfif>

<cfquery name='InsertSiteToSiteConfig' datasource='#application.configBean.getDatasource()#' username='#application.configBean.getDBUsername()#' password='#application.configBean.getDBPassword()#'>
  Insert into p_EventRegistration_SiteConfig(Site_ID, DateCreated, lastUpdateBy, lastUpdated)
  Values(
    <cfqueryparam value='#Session.SiteID#' cfsqltype='cf_sql_varchar'>,
    <cfqueryparam value='#Now()#' cfsqltype='cf_sql_timestamp'>,
    <cfqueryparam value='Admin' cfsqltype='cf_sql_varchar'>,
    <cfqueryparam value='#Now()#' cfsqltype='cf_sql_timestamp'>
    )
</cfquery>