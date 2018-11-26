<cfquery name="Create-p_EventRegistration_Caterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_Caterers` ( `TContent_ID` INT(11) NOT NULL AUTO_INCREMENT, `Site_ID` VARCHAR(20) NOT NULL, `FacilityName` TINYTEXT NOT NULL, `PhysicalAddress` TINYTEXT NULL, `PhysicalCity` TINYTEXT NULL, `PhysicalState` VARCHAR(2) NULL DEFAULT NULL, `PhysicalZipCode` VARCHAR(5) NULL DEFAULT NULL, `PhysicalZip4` VARCHAR(4) NULL DEFAULT NULL, `PrimaryVoiceNumber` VARCHAR(14) NULL DEFAULT NULL, `BusinessWebsite` TINYTEXT NULL, `ContactName` TINYTEXT NULL, `ContactPhoneNumber` TINYTEXT NULL, `ContactEmail` TINYTEXT NULL, `PaymentTerms` TINYTEXT NULL, `DeliveryInfo` TINYTEXT NULL, `GuaranteeInformation` TINYTEXT NULL, `AdditionalNotes` TINYTEXT NULL, `dateCreated` DATETIME NOT NULL, `lastUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `lastUpdateBy` TINYTEXT NOT NULL, `isAddressVerified` BIT(1) NOT NULL DEFAULT b'0', `GeoCode_Latitude` VARCHAR(20) NULL DEFAULT NULL, `GeoCode_Longitude` VARCHAR(20) NULL DEFAULT NULL, `GeoCode_Township` TINYTEXT NULL, `GeoCode_StateLongName` TINYTEXT NULL, `GeoCode_CountryShortName` TINYTEXT NULL, `GeoCode_Neighborhood` TINYTEXT NULL, `Active` BIT(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`, `Site_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_EventEmailLog" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_EventEmailLog` ( `TContent_ID` INT(11) NOT NULL AUTO_INCREMENT, `Site_ID` VARCHAR(20) NOT NULL, `Event_ID` INT(11) NOT NULL, `MsgBody` LONGTEXT NULL, `EmailType` TINYTEXT NULL, `LinksToInclude` TINYTEXT NULL, `DocsToInclude` TINYTEXT NULL, `EmailSentToParticipants` LONGTEXT NOT NULL, `dateCreated` DATETIME NOT NULL, `lastUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `lastUpdateBy` VARCHAR(35) NOT NULL, PRIMARY KEY (`TContent_ID`, `Event_ID`), INDEX `Event_ID_Index` (`Event_ID`) USING BTREE ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_EventExpenses" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_EventExpenses` ( `TContent_ID` INT(11) NOT NULL AUTO_INCREMENT, `Site_ID` VARCHAR(20) NOT NULL, `Event_ID` INT(11) NOT NULL, `Expense_ID` INT(11) NOT NULL, `Cost_Amount` DOUBLE(15,2) NOT NULL, `dateCreated` DATETIME NOT NULL, `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `lastUpdateBy` VARCHAR(35) NOT NULL, `Cost_Verified` BIT(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`, `Event_ID`), INDEX `Event_ID_Index` (`Event_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_EventResources" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_EventResources` ( `TContent_ID` INT(11) NOT NULL AUTO_INCREMENT, `Site_ID` VARCHAR(20) NOT NULL, `Event_ID` INT(11) NOT NULL, `ResourceType` CHAR(1) NOT NULL, `ResourceLink` TINYTEXT NULL, `dateCreated` DATETIME NOT NULL, `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `lastUpdateBy` VARCHAR(35) NOT NULL, `ResourceDocument` TINYTEXT NULL, `ResourceDocumentType` TINYTEXT NULL, `ResourceDocumentSize` TINYTEXT NULL, PRIMARY KEY (`TContent_ID`, `Event_ID`), INDEX `Event_ID_Index` (`Event_ID`) USING BTREE ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_Events` ( `TContent_ID` INT(10) NOT NULL AUTO_INCREMENT, `Site_ID` VARCHAR(20) NOT NULL DEFAULT '', `ShortTitle` TINYTEXT NOT NULL, `EventDate` DATE NOT NULL DEFAULT '1980-01-01', `EventDate1` DATE NULL DEFAULT NULL, `EventDate2` DATE NULL DEFAULT NULL, `EventDate3` DATE NULL DEFAULT NULL, `EventDate4` DATE NULL DEFAULT NULL, `EventDate5` DATE NULL DEFAULT NULL, `LongDescription` LONGTEXT NULL, `Event_StartTime` TIME NULL DEFAULT NULL, `Event_EndTime` TIME NULL DEFAULT NULL, `Registration_Deadline` DATE NOT NULL DEFAULT '1980-01-01', `Registration_BeginTime` TIME NULL DEFAULT NULL, `Registration_EndTime` TIME NULL DEFAULT NULL, `EventFeatured` BIT(1) NOT NULL DEFAULT b'0', `Featured_StartDate` DATE NULL DEFAULT '1980-01-01', `Featured_EndDate` DATE NULL DEFAULT '1980-01-01', `Featured_SortOrder` INT(10) NULL DEFAULT '100', `MemberCost` DECIMAL(15,4) NULL DEFAULT NULL, `NonMemberCost` DECIMAL(15,4) NULL DEFAULT NULL, `EarlyBird_RegistrationDeadline` DATE NULL DEFAULT '1980-01-01', `EarlyBird_RegistrationAvailable` BIT(1) NOT NULL DEFAULT b'0', `EarlyBird_MemberCost` DECIMAL(15,4) NULL DEFAULT NULL, `EarlyBird_NonMemberCost` DECIMAL(15,4) NULL DEFAULT NULL, `ViewGroupPricing` BIT(1) NOT NULL DEFAULT b'0', `GroupMemberCost` DECIMAL(15,4) NULL DEFAULT NULL, `GroupNonMemberCost` DECIMAL(15,4) NULL DEFAULT NULL, `GroupPriceRequirements` LONGTEXT NULL, `PGPAvailable` BIT(1) NOT NULL DEFAULT b'0', `PGPPoints` DECIMAL(5,2) NULL DEFAULT NULL, `MealAvailable` BIT(1) NOT NULL DEFAULT b'0', `MealIncluded` BIT(1) NOT NULL DEFAULT b'0', `MealProvidedBy` INT(11) NULL DEFAULT NULL, `MealCost` DECIMAL(15,4) NULL DEFAULT '0.0000', `Meal_Notes` LONGTEXT NULL, `AllowVideoConference` BIT(1) NOT NULL DEFAULT b'0', `VideoConferenceInfo` LONGTEXT NULL, `VideoConferenceCost` DECIMAL(15,4) NULL DEFAULT NULL, `AcceptRegistrations` BIT(1) NOT NULL DEFAULT b'0', `EventAgenda` LONGTEXT NULL, `EventTargetAudience` LONGTEXT NULL, `EventStrategies` LONGTEXT NULL, `EventSpecialInstructions` LONGTEXT NULL, `MaxParticipants` INT(10) NULL DEFAULT '0', `LocationID` INT(10) NULL DEFAULT '0', `LocationRoomID` INT(10) NULL DEFAULT '0', `Presenters` TINYTEXT NULL, `Facilitator` CHAR(35) NOT NULL, `dateCreated` DATETIME NOT NULL, `lastUpdated` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `lastUpdateBy` CHAR(35) NULL DEFAULT NULL, `Active` BIT(1) NOT NULL DEFAULT b'0', `EventCancelled` BIT(1) NOT NULL DEFAULT b'0', `WebinarAvailable` BIT(1) NOT NULL DEFAULT b'0', `WebinarConnectInfo` MEDIUMTEXT NULL, `WebinarMemberCost` DECIMAL(15,4) NULL DEFAULT NULL, `WebinarNonMemberCost` DECIMAL(15,4) NULL DEFAULT NULL, `PostedTo_Facebook` BIT(1) NOT NULL DEFAULT b'0', `PostedTo_Twitter` BIT(1) NOT NULL DEFAULT b'0', `EventHasDailySessions` BIT(1) NOT NULL DEFAULT b'0', `Session1BeginTime` TIME NULL DEFAULT NULL, `Session1EndTime` TIME NULL DEFAULT NULL, `Session2BeginTime` TIME NULL DEFAULT NULL, `Session2EndTime` TIME NULL DEFAULT NULL, `EventInvoicesGenerated` BIT(1) NOT NULL DEFAULT b'0', `PGPCertificatesGenerated` BIT(1) NOT NULL DEFAULT b'0', `BillForNoShow` BIT(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`, `Site_ID`) ) COLLATE='utf8_general_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_ExpenseList" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_ExpenseList` ( `TContent_ID` INT(11) NOT NULL AUTO_INCREMENT, `Site_ID` VARCHAR(20) NOT NULL, `Expense_Name` TINYTEXT NOT NULL, `Active` BIT(1) NOT NULL DEFAULT b'0', `dateCreated` DATETIME NOT NULL, `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `lastUpdateBy` VARCHAR(35) NOT NULL, PRIMARY KEY (`TContent_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_Facility" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_Facility` ( `TContent_ID` INT(10) NOT NULL AUTO_INCREMENT, `Site_ID` VARCHAR(20) NOT NULL DEFAULT '', `FacilityName` TINYTEXT NOT NULL, `PhysicalAddress` TINYTEXT NULL, `PhysicalCity` TINYTEXT NULL, `PhysicalState` VARCHAR(2) NULL DEFAULT NULL, `PhysicalZipCode` VARCHAR(5) NULL DEFAULT NULL, `PhysicalZip4` VARCHAR(4) NULL DEFAULT NULL, `PrimaryVoiceNumber` VARCHAR(14) NULL DEFAULT '', `BusinessWebsite` TINYTEXT NULL, `ContactName` TINYTEXT NULL, `ContactPhoneNumber` TINYTEXT NULL, `ContactEmail` TINYTEXT NULL, `dateCreated` DATETIME NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `lastUpdateBy` VARCHAR(50) NOT NULL DEFAULT '', `isAddressVerified` CHAR(1) NOT NULL DEFAULT '0', `GeoCode_Latitude` VARCHAR(20) NULL DEFAULT NULL, `GeoCode_Longitude` VARCHAR(20) NULL DEFAULT NULL, `GeoCode_Township` VARCHAR(40) NULL DEFAULT NULL, `GeoCode_StateLongName` VARCHAR(40) NULL DEFAULT NULL, `GeoCode_CountryShortName` VARCHAR(40) NULL DEFAULT NULL, `GeoCode_Neighborhood` VARCHAR(40) NULL DEFAULT NULL, `USPS_CarrierRoute` VARCHAR(20) NULL DEFAULT NULL, `USPS_CheckDigit` VARCHAR(20) NULL DEFAULT NULL, `USPS_DeliveryPoint` VARCHAR(20) NULL DEFAULT NULL, `PhysicalLocationCountry` VARCHAR(20) NULL DEFAULT NULL, `PhysicalCountry` VARCHAR(20) NULL DEFAULT NULL, `Active` CHAR(1) NOT NULL DEFAULT '1', `FacilityType` CHAR(1) NOT NULL DEFAULT 'B', 	`Physical_TimeZone` TINYTEXT NOT NULL, 	`Physical_UTCOffset` CHAR(4) NOT NULL, 	`Physical_DST` BIT(1) NOT NULL DEFAULT b'0', 	 PRIMARY KEY (`TContent_ID`, `Site_ID`) ) COLLATE='utf8_general_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_FacilityRooms" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_FacilityRooms` ( `TContent_ID` INT(10) NOT NULL AUTO_INCREMENT, `Site_ID` VARCHAR(20) NOT NULL DEFAULT '', `Facility_ID` INT(10) NOT NULL DEFAULT '1', `RoomName` VARCHAR(35) NOT NULL DEFAULT '', `Capacity` INT(10) NOT NULL DEFAULT '1', `RoomFees` DECIMAL(15,4) NULL DEFAULT '0.0000', `Active` BIT(1) NOT NULL DEFAULT b'1', `dateCreated` DATETIME NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `lastUpdateBy` VARCHAR(50) NOT NULL DEFAULT '', PRIMARY KEY (`TContent_ID`, `Site_ID`, `Facility_ID`) ) COLLATE='utf8_general_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_GradeLevels" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_GradeLevels` ( `TContent_ID` INT(11) NOT NULL, `Site_ID` TINYTEXT NOT NULL, `GradeLevel` TINYTEXT NOT NULL, `dateCreated` DATETIME NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `lastUpdateBy` VARCHAR(50) NOT NULL DEFAULT '', PRIMARY KEY (`TContent_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_GradeSubjects" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_GradeSubjects` ( `TContent_ID` INT(11) NOT NULL, `Site_ID` TINYTEXT NOT NULL, `GradeLevel` INT(11) NOT NULL, `GradeSubject` TINYTEXT NOT NULL, `dateCreated` DATETIME NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `lastUpdateBy` VARCHAR(50) NOT NULL DEFAULT '', PRIMARY KEY (`TContent_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_Membership" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_Membership` ( `TContent_ID` INT(11) NOT NULL AUTO_INCREMENT, `Site_ID` TINYTEXT NOT NULL, `OrganizationName` VARCHAR(50) NOT NULL, `OrganizationDomainName` VARCHAR(50) NOT NULL, `StateDOE_IDNumber` VARCHAR(10) NULL DEFAULT NULL, `StateDOE_ESCESAMembership` INT(11) NULL DEFAULT NULL, `StateDOE_State` TINYTEXT NULL, `Active` BIT(1) NOT NULL DEFAULT b'0', `dateCreated` DATETIME NOT NULL, `lastUpdateBy` VARCHAR(35) NOT NULL, `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `Mailing_Address` TINYTEXT NULL, `Mailing_City` TINYTEXT NULL, `Mailing_State` TINYTEXT NULL, `Mailing_ZipCode` TINYTEXT NULL, `Mailing_ZipPlus4` CHAR(4) NULL DEFAULT NULL, `Mailing_DeliveryPointBarcode` CHAR(12) NULL DEFAULT NULL, `Primary_PhoneNumber` TINYTEXT NULL, `Primary_FaxNumber` TINYTEXT NULL, `Physical_Address` TINYTEXT NULL, `Physical_City` TINYTEXT NULL, `Physical_State` TINYTEXT NULL, `Physical_ZipCode` TINYTEXT NULL, `Physical_ZipPlus4` CHAR(4) NULL DEFAULT NULL, `Physical_DeliveryPointBarcode` CHAR(12) NULL DEFAULT NULL, `Physical_Latitude` DECIMAL(10,5) NULL DEFAULT NULL, `Physical_Longitude` DECIMAL(10,5) NULL DEFAULT NULL, `Physical_TimeZone` TINYTEXT NULL, `Physical_DST` BIT(1) NULL DEFAULT NULL, `Physical_UTCOffset` CHAR(3) NULL DEFAULT NULL, `Physical_CountyName` TINYTEXT NULL, `Physical_CarrierRoute` TINYTEXT NULL, `Physical_CongressionalDistrict` TINYTEXT NULL, `AccountsPayable_EmailAddress` TINYTEXT NULL, `AccountsPayable_ContactName` TINYTEXT NULL, `ReceiveInvoicesByEmail` BIT(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_MembershipBuildings" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_MembershipBuildings` ( 	`TContent_ID` INT(11) NOT NULL AUTO_INCREMENT, `Site_ID` TINYTEXT NOT NULL, `MembershipDistrict_ID` INT(11) NOT NULL, `OrganizationName` VARCHAR(50) NOT NULL, `StateDOE_IDNumber` VARCHAR(10) NULL DEFAULT NULL, `StateDOE_State` TINYTEXT NULL, `Active` BIT(1) NOT NULL DEFAULT b'0', `dateCreated` DATETIME NOT NULL, `lastUpdateBy` VARCHAR(35) NOT NULL, `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `Mailing_Address` TINYTEXT NULL, `Mailing_City` TINYTEXT NULL, `Mailing_State` TINYTEXT NULL, `Mailing_ZipCode` TINYTEXT NULL, `Mailing_ZipPlus4` CHAR(4) NULL DEFAULT NULL, `Mailing_DeliveryPointBarcode` CHAR(12) NULL DEFAULT NULL, `Primary_PhoneNumber` TINYTEXT NULL, `Primary_FaxNumber` TINYTEXT NULL, `Physical_Address` TINYTEXT NULL, `Physical_City` TINYTEXT NULL, `Physical_State` TINYTEXT NULL, `Physical_ZipCode` TINYTEXT NULL, `Physical_ZipPlus4` CHAR(4) NULL DEFAULT NULL, `Physical_DeliveryPointBarcode` CHAR(12) NULL DEFAULT NULL, `Physical_Latitude` DECIMAL(10,5) NULL DEFAULT NULL, `Physical_Longitude` DECIMAL(10,5) NULL DEFAULT NULL, `Physical_TimeZone` TINYTEXT NULL, `Physical_DST` BIT(1) NULL DEFAULT NULL, `Physical_UTCOffset` CHAR(3) NULL DEFAULT NULL, `Physical_CountyName` TINYTEXT NULL, `Physical_CarrierRoute` TINYTEXT NULL, `Physical_CongressionalDistrict` TINYTEXT NULL, PRIMARY KEY (`TContent_ID`, `MembershipDistrict_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_ShortURL" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_ShortURL` (`TContent_ID` INT(10) NOT NULL AUTO_INCREMENT, `Site_ID` VARCHAR(20) NOT NULL DEFAULT '', `FullLink` LONGTEXT NULL, `ShortLink` TINYTEXT NULL, `Active` BIT(1) NOT NULL DEFAULT b'0', `dateCreated` DATETIME NULL DEFAULT NULL, `lastUpdateBy` VARCHAR(35) NULL DEFAULT NULL, `lastUpdated` DATETIME NULL DEFAULT NULL, PRIMARY KEY (`TContent_ID`, `Site_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>


<cfquery name="Create-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_SiteConfig` ( `TContent_ID` INT(11) NOT NULL AUTO_INCREMENT, `Site_ID` TINYTEXT NOT NULL, `DateCreated` DATETIME NOT NULL, `lastUpdateBy` VARCHAR(35) NOT NULL, `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `ProcessPayments_Stripe` BIT(1) NOT NULL DEFAULT b'0', `Stripe_TestMode` BIT(1) NOT NULL DEFAULT b'1', `Stripe_TestAPIKey` TINYTEXT NULL, `Stripe_LiveAPIKey` TINYTEXT NULL, `Facebook_Enabled` BIT(1) NULL DEFAULT b'0', `Facebook_AppID` TINYTEXT NULL, `Facebook_AppSecretKey` TINYTEXT NULL, `Facebook_PageID` TINYTEXT NULL, `Facebook_AppScope` TINYTEXT NULL, `Google_ReCaptchaSiteKey` TINYTEXT NULL, `Google_ReCaptchaSecretKey` TINYTEXT NULL, `SmartyStreets_Enabled` BIT(1) NOT NULL DEFAULT b'0', `SmartyStreets_APIID` TINYTEXT NULL, `SmartyStreets_APIToken` TINYTEXT NULL, PRIMARY KEY (`TContent_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_StateESCOrganizations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_StateESCOrganizations` ( `TContent_ID` INT(11) NOT NULL AUTO_INCREMENT, `Site_ID` TINYTEXT NOT NULL, `OrganizationName` VARCHAR(50) NOT NULL, `OrganizationDomainName` VARCHAR(50) NOT NULL, `StateDOE_IDNumber` VARCHAR(10) NULL DEFAULT NULL, `StateDOE_State` TINYTEXT NULL, `dateCreated` DATETIME NOT NULL, `lastUpdateBy` VARCHAR(35) NOT NULL, `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `Mailing_Address` TINYTEXT NULL, `Mailing_City` TINYTEXT NULL, `Mailing_State` TINYTEXT NULL, `Mailing_ZipCode` TINYTEXT NULL, `Mailing_ZipPlus4` CHAR(4) NULL DEFAULT NULL, `Mailing_DeliveryPointBarcode` CHAR(12) NULL DEFAULT NULL, `Primary_PhoneNumber` TINYTEXT NULL, `Primary_FaxNumber` TINYTEXT NULL, `Physical_Address` TINYTEXT NULL, `Physical_City` TINYTEXT NULL, `Physical_State` TINYTEXT NULL, `Physical_ZipCode` TINYTEXT NULL, `Physical_ZipPlus4` CHAR(4) NULL DEFAULT NULL, `Physical_DeliveryPointBarcode` CHAR(12) NULL DEFAULT NULL, `Physical_Latitude` DECIMAL(10,5) NULL DEFAULT NULL, `Physical_Longitude` DECIMAL(10,5) NULL DEFAULT NULL, `Physical_TimeZone` TINYTEXT NULL, `Physical_DST` BIT(1) NOT NULL DEFAULT b'0', `Physical_UTCOffset` CHAR(3) NOT NULL DEFAULT '0', `Physical_CountyName` TINYTEXT NULL, `Physical_CarrierRoute` TINYTEXT NULL, `Physical_CongressionalDistrict` TINYTEXT NULL, PRIMARY KEY (`TContent_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_UserMatrix" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_UserMatrix` ( `TContent_ID` INT(11) NOT NULL AUTO_INCREMENT, `Site_ID` TINYTEXT NOT NULL, `User_ID` CHAR(35) NOT NULL, `School_District` INT(11) NULL DEFAULT NULL, `dateCreated` DATETIME NOT NULL, `lastUpdateBy` VARCHAR(35) NOT NULL, `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `TeachingGrade` INT(11) NULL DEFAULT NULL, `TeachingSubject` INT(11) NULL DEFAULT NULL, `ReceiveMarketingFlyers` BIT(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="Create-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_UserRegistrations` ( `TContent_ID` INT(10) NOT NULL AUTO_INCREMENT, `Site_ID` VARCHAR(20) NOT NULL DEFAULT '', `RegistrationID` VARCHAR(35) NOT NULL DEFAULT '', `RegistrationDate` DATETIME NOT NULL DEFAULT '1980-01-01 01:00:00', `User_ID` CHAR(35) NOT NULL, `EventID` INT(10) NOT NULL DEFAULT '0', `RequestsMeal` BIT(1) NOT NULL DEFAULT b'0', `IVCParticipant` BIT(1) NOT NULL DEFAULT b'0', `AttendeePrice` DECIMAL(15,4) NULL DEFAULT '0.0000', `RegistrationIPAddr` VARCHAR(15) NOT NULL DEFAULT '0.0.0.0', `RegisterByUserID` VARCHAR(35) NOT NULL DEFAULT '', `OnWaitingList` BIT(1) NOT NULL DEFAULT b'0', `AttendedEventDate1` BIT(1) NOT NULL DEFAULT b'0', `AttendedEventDate2` BIT(1) NOT NULL DEFAULT b'0', `AttendedEventDate3` BIT(1) NOT NULL DEFAULT b'0', `AttendedEventDate4` BIT(1) NOT NULL DEFAULT b'0', `AttendedEventDate5` BIT(1) NOT NULL DEFAULT b'0', `AttendedEventDate6` BIT(1) NOT NULL DEFAULT b'0', `AttendedEventSessionAM` BIT(1) NOT NULL DEFAULT b'0', `AttendedEventSessionPM` BIT(1) NOT NULL DEFAULT b'0', `RegisterForEventDate1` BIT(1) NOT NULL DEFAULT b'0', `RegisterForEventDate2` BIT(1) NOT NULL DEFAULT b'0', `RegisterForEventDate3` BIT(1) NOT NULL DEFAULT b'0', `RegisterForEventDate4` BIT(1) NOT NULL DEFAULT b'0', `RegisterForEventDate5` BIT(1) NOT NULL DEFAULT b'0', `RegisterForEventDate6` BIT(1) NOT NULL DEFAULT b'0', `RegisterForEventSessionAM` BIT(1) NOT NULL DEFAULT b'0', `RegisterForEventSessionPM` BIT(1) NOT NULL DEFAULT b'0', `Comments` VARCHAR(255) NULL DEFAULT NULL, `WebinarParticipant` BIT(1) NOT NULL DEFAULT b'0', `AttendeePriceVerified` BIT(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`, `Site_ID`, `User_ID`) ) COLLATE='utf8_general_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
</cfquery>

<cfquery name="CheckGroups" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Select UserID, GroupName
	From tusers
	Where GroupName LIKE '%Event%'
</cfquery>
<cfif CheckGroups.RecordCount EQ 0>
	<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Facilitator");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
	</cfscript>
	<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Presenter");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
	</cfscript>
<cfelse>
	<cfset GroupPresenterExists = 0>
	<cfset GroupFacilitatorExists = 0>
	<cfloop query="CheckGroups">
		<cfif CheckGroups.GroupName EQ "Event Facilitator">
			<cfset GroupFacilitatorExists = 1>
		</cfif>
		<cfif CheckGroups.GroupName EQ "Event Presenter">
			<cfset GroupPresenterExists = 1>
		</cfif>
	</cfloop>
	<cfif GroupFacilitatorExists EQ 0>
		<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Facilitator");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
		</cfscript>
	</cfif>
	<cfif GroupPresenterExists EQ 0>
		<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Presenter");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
		</cfscript>
	</cfif>
</cfif>
