<cfquery name="Create-p_EventRegistration_Caterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_Caterers` (
		 `TContent_ID` int(11) NOT NULL AUTO_INCREMENT,
		 `Site_ID` varchar(20) NOT NULL, `FacilityName` tinytext NOT NULL, `PhysicalAddress` tinytext NOT NULL, `PhysicalCity` tinytext NOT NULL, `PhysicalState` varchar(2) NOT NULL,
		 `PhysicalZipCode` varchar(5) NOT NULL, `PhysicalZip4` varchar(4) DEFAULT NULL, `PrimaryVoiceNumber` varchar(14) DEFAULT NULL, `BusinessWebsite` tinytext, `ContactName` tinytext,
		 `ContactPhoneNumber` tinytext, `ContactEmail` tinytext, `PaymentTerms` tinytext, `DeliveryInfo` tinytext, `GuaranteeInformation` tinytext, `AdditionalNotes` tinytext,
		 `dateCreated` datetime DEFAULT NULL, `lastUpdated` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP, `lastUpdateBy` tinytext NOT NULL,
		 `isAddressVerified` bit(1) NOT NULL DEFAULT b'0', `GeoCode_Latitude` varchar(20) DEFAULT NULL, `GeoCode_Longitude` varchar(20) DEFAULT NULL, `GeoCode_Township` tinytext,
		 `GeoCode_StateLongName` tinytext, `GeoCode_CountryShortName` tinytext, `GeoCode_Neighborhood` tinytext, `Active` bit(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`,`Site_ID`)
	) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1
</cfquery>

<cfquery name="Create-p_EventRegistration_EventExpenses" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_EventExpenses` (
		`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL, `Event_ID` int(11) NOT NULL, `Expense_ID` int(11) NOT NULL, `Cost_Amount` double(8,2) NOT NULL,
		`dateCreated` datetime NOT NULL, `lastUpdated` datetime NOT NULL, `lastUpdateBy` varchar(35) NOT NULL, `Cost_Verified` bit(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`,`Event_ID`),
		KEY `Event_ID_Index` (`Event_ID`) USING BTREE ) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
</cfquery>

<cfquery name="Create-p_EventRegistration_ExpenseList" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_ExpenseList` (
		`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL, `Expense_Name` tinytext NOT NULL, `Active` bit(1) NOT NULL DEFAULT b'0', `dateCreated` datetime NOT NULL,
		`lastUpdated` datetime NOT NULL, `lastUpdateBy` varchar(35) NOT NULL, PRIMARY KEY (`TContent_ID`) ) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
</cfquery>

<cfquery name="Create-p_EventRegistration_Facility" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_Facility` (
		`TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `FacilityName` tinytext NOT NULL, `PhysicalAddress` tinytext NOT NULL, `PhysicalCity` tinytext NOT NULL,
		`PhysicalState` varchar(2) NOT NULL DEFAULT '', `PhysicalZipCode` varchar(5) NOT NULL DEFAULT '', `PhysicalZip4` varchar(4) DEFAULT '', `PrimaryVoiceNumber` varchar(14) DEFAULT '',
		`BusinessWebsite` tinytext, `ContactName` tinytext, `ContactPhoneNumber` tinytext, `ContactEmail` tinytext, `dateCreated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00',
		`lastUpdated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdateBy` varchar(50) NOT NULL DEFAULT '', `isAddressVerified` char(1) NOT NULL DEFAULT '0',
		`GeoCode_Latitude` varchar(20) DEFAULT NULL, `GeoCode_Longitude` varchar(20) DEFAULT NULL, `GeoCode_Township` varchar(40) DEFAULT NULL, `GeoCode_StateLongName` varchar(40) DEFAULT NULL,
		`GeoCode_CountryShortName` varchar(40) DEFAULT NULL, `GeoCode_Neighborhood` varchar(40) DEFAULT NULL, `USPS_CarrierRoute` varchar(20) DEFAULT NULL, `USPS_CheckDigit` varchar(20) DEFAULT NULL,
		`USPS_DeliveryPoint` varchar(20) DEFAULT NULL, `PhysicalLocationCountry` varchar(20) DEFAULT NULL, `PhysicalCountry` varchar(20) DEFAULT NULL, `Active` char(1) NOT NULL DEFAULT '1',
		`FacilityType` char(1) NOT NULL DEFAULT 'B', PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
</cfquery>

<cfquery name="Create-p_EventRegistration_FacilityRooms" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_FacilityRooms` (
		`TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `Facility_ID` int(10) NOT NULL DEFAULT '1', `RoomName` varchar(35) NOT NULL DEFAULT '',
		`Capacity` int(10) NOT NULL DEFAULT '1', `RoomFees` double(6,2) DEFAULT '0.00', `Active` bit(1) NOT NULL DEFAULT b'1', `dateCreated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00',
		`lastUpdated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdateBy` varchar(50) NOT NULL DEFAULT '', PRIMARY KEY (`TContent_ID`,`Site_ID`,`Facility_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
</cfquery>

<cfquery name="Create-p_EventRegistration_Membership" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_Membership` (
		`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `OrganizationName` varchar(50) NOT NULL, `OrganizationDomainName` varchar(50) NOT NULL, `StateDOE_IDNumber` varchar(10) DEFAULT NULL,
		`StateDOE_State` tinytext, `Active` bit(1) NOT NULL DEFAULT b'0', `dateCreated` date NOT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL, `Mailing_Address` tinytext,
		`Mailing_City` tinytext, `Mailing_State` tinytext, `Mailing_ZipCode` tinytext, `Primary_PhoneNumber` tinytext, `Primary_FaxNumber` tinytext, `Physical_Address` tinytext, `Physical_City` tinytext,
		`Physical_State` tinytext, `Physical_ZipCode` tinytext, `AccountsPayable_EmailAddress` tinytext, `AccountsPayable_ContactName` tinytext, `ReceiveInvoicesByEmail` bit(1) NOT NULL DEFAULT b'0',
		PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
</cfquery>

<cfquery name="Create-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_SiteConfig` (
		`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `DateCreated` datetime NOT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL,
		`ProcessPayments_Stripe` bit(1) NOT NULL DEFAULT b'0', `Stripe_TestMode` bit(1) NOT NULL DEFAULT b'1', `Stripe_TestAPIKey` tinytext, `Stripe_LiveAPIKey` tinytext, `Facbook_AppID` tinytext,
		`Facebook_AppSecretKey` tinytext, `Facebook_PageID` tinytext, `Facebook_AppScope` tinytext, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
</cfquery>

<cfquery name="Create-p_EventRegistration_UserMatrix" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_UserMatrix` (
		`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `User_ID` char(35) NOT NULL, `School_District` int(11) DEFAULT NULL,
		`created` datetime NOT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL, `TeachingGrade` int(11) DEFAULT NULL,
		`TeachingSubject` int(11) DEFAULT NULL,
		`ReceiveMarketingFlyers` bit(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
</cfquery>

<cfquery name="Create-p_EventRegistration_UserRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_UserRegistrations` (
		`TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `RegistrationID` varchar(35) NOT NULL DEFAULT '', `RegistrationDate` datetime NOT NULL DEFAULT '1980-01-01 01:00:00',
		`User_ID` char(35) NOT NULL, `EventID` int(10) NOT NULL DEFAULT '0', `RequestsMeal` bit(1) NOT NULL DEFAULT b'0', `IVCParticipant` bit(1) NOT NULL DEFAULT b'0', `AttendeePrice` double(6,2) DEFAULT '0.00',
		`RegistrationIPAddr` varchar(15) NOT NULL DEFAULT '0.0.0.0', `RegisterByUserID` varchar(35) NOT NULL DEFAULT '', `OnWaitingList` bit(1) NOT NULL DEFAULT b'0', `AttendedEventDate1` bit(1) NOT NULL DEFAULT b'0',
		`AttendedEventDate2` bit(1) NOT NULL DEFAULT b'0', `AttendedEventDate3` bit(1) NOT NULL DEFAULT b'0', `AttendedEventDate4` bit(1) NOT NULL DEFAULT b'0', `AttendedEventDate5` bit(1) NOT NULL DEFAULT b'0',
		`AttendedEventDate6` bit(1) NOT NULL DEFAULT b'0', `AttendedEventSessionAM` bit(1) NOT NULL DEFAULT b'0', `AttendedEventSessionPM` bit(1) NOT NULL DEFAULT b'0', `Comments` varchar(255) DEFAULT NULL,
		`WebinarParticipant` bit(1) NOT NULL DEFAULT b'0', `AttendeePriceVerified` bit(1) NOT NULL DEFAULT b'0', `RegisterForEventDate1` bit(1) NOT NULL DEFAULT b'0', `RegisterForEventDate2` bit(1) NOT NULL DEFAULT b'0',
		`RegisterForEventDate3` bit(1) NOT NULL DEFAULT b'0', `RegisterForEventDate4` bit(1) NOT NULL DEFAULT b'0', `RegisterForEventDate5` bit(1) NOT NULL DEFAULT b'0', `RegisterForEventDate6` bit(1) NOT NULL DEFAULT b'0',
		`RegisterForEventSessionAM` bit(1) NOT NULL DEFAULT b'0', `RegisterForEventSessionPM` bit(1) NOT NULL DEFAULT b'0',
		PRIMARY KEY (`TContent_ID`,`Site_ID`,`User_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
</cfquery>

<cfquery name="Create-p_EventRegistrations_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	CREATE TABLE `p_EventRegistration_Events` (
		`TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `ShortTitle` tinytext NOT NULL, `EventDate` date NOT NULL DEFAULT '1980-01-01',
		`EventDate1` date DEFAULT NULL, `EventDate2` date DEFAULT NULL, `EventDate3` date DEFAULT NULL, `EventDate4` date DEFAULT NULL, `EventDate5` date DEFAULT NULL,
		`LongDescription` longtext, `Event_StartTime` time DEFAULT NULL, `Event_EndTime` time DEFAULT NULL, `Registration_Deadline` date NOT NULL DEFAULT '1980-01-01',
		`Registration_BeginTime` time DEFAULT NULL, `Registration_EndTime` time DEFAULT NULL, `EventFeatured` bit(1) NOT NULL DEFAULT b'0', `Featured_StartDate` date DEFAULT '1980-01-01',
		`Featured_EndDate` date DEFAULT '1980-01-01', `Featured_SortOrder` int(10) DEFAULT '100', `MemberCost` decimal(6,2) DEFAULT NULL, `NonMemberCost` decimal(6,2) DEFAULT NULL,
		`EarlyBird_RegistrationDeadline` date DEFAULT '1980-01-01', `EarlyBird_RegistrationAvailable` bit(1) NOT NULL DEFAULT b'0', `EarlyBird_MemberCost` decimal(6,2) DEFAULT NULL,
		`EarlyBird_NonMemberCost` decimal(6,2) DEFAULT NULL, `ViewGroupPricing` bit(1) NOT NULL DEFAULT b'0', `GroupMemberCost` decimal(6,2) DEFAULT NULL,
		`GroupNonMemberCost` decimal(6,2) DEFAULT NULL, `GroupPriceRequirements` longtext, `PGPAvailable` bit(1) NOT NULL DEFAULT b'0', `PGPPoints` decimal(5,2) DEFAULT NULL,
		`MealProvided` bit(1) NOT NULL DEFAULT b'0', `MealProvidedBy` int(11) DEFAULT NULL, `MealCost_Estimated` decimal(6,2) DEFAULT '0.00', `AllowVideoConference` bit(1) NOT NULL DEFAULT b'0',
		`VideoConferenceInfo` longtext, `VideoConferenceCost` decimal(6,2) DEFAULT NULL, `AcceptRegistrations` bit(1) NOT NULL DEFAULT b'0', `EventAgenda` longtext,
		`EventTargetAudience` longtext, `EventStrategies` longtext, `EventSpecialInstructions` longtext, `MaxParticipants` int(10) DEFAULT '0', `LocationID` int(10) DEFAULT '0',
		`LocationRoomID` int(10) DEFAULT '0', `Presenters` tinytext, `Facilitator` char(35) DEFAULT '0', `dateCreated` date NOT NULL, `lastUpdated` date DEFAULT NULL,
		`lastUpdateBy` char(35) DEFAULT NULL, `Active` bit(1) NOT NULL DEFAULT b'0', `EventCancelled` bit(1) NOT NULL DEFAULT b'0', `WebinarAvailable` bit(1) NOT NULL DEFAULT b'0',
		`WebinarConnectInfo` mediumtext, `WebinarMemberCost` decimal(6,2) DEFAULT NULL, `WebinarNonMemberCost` decimal(6,2) DEFAULT NULL, `PostedTo_Facebook` bit(1) NOT NULL DEFAULT b'0',
		`PostedTo_Twitter` bit(1) NOT NULL DEFAULT b'0', `EventHasDailySessions` bit(1) NOT NULL DEFAULT b'0', `Session1BeginTime` time DEFAULT NULL, `Session1EndTime` time DEFAULT NULL,
		`Session2BeginTime` time DEFAULT NULL, `Session2EndTime` time DEFAULT NULL, PRIMARY KEY (`TContent_ID`,`Site_ID`)
	) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;
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