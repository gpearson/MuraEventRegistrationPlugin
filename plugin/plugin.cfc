/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent persistent="false" accessors="true" output="false" extends="mura.plugin.plugincfc">
	<cfparam name="config" type="any" default="">

	<cffunction name="init" output="false" returntype="any">
		<cfargument name="config" required="true" default="">
	</cffunction>

	<cffunction name="install" output="false" returntype="any">
		<cfset application.appInitialized = false>

		<cfscript>
			var dbCheckTableRegistrations = new query();
			dbCheckTableRegistrations.setDatasource("#application.configBean.getDatasource()#");
			dbCheckTableRegistrations.setSQL("Show Tables LIKE 'eRegistrations'");
			var dbCheckTableRegistrationsResult = dbCheckTableRegistrations.execute();

			if (dbCheckTableRegistrationsResult.getResult().recordcount eq 0) {
				// Since the Database Table does not exists, Lets Create it
				var dbCreateTableRegistrations = new query();
				dbCreateTableRegistrations.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTableRegistrations.setSQL("CREATE TABLE `eRegistrations` (`TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `RegistrationID` varchar(35) NOT NULL DEFAULT '', `RegistrationDate` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `User_ID` char(35) NOT NULL, `EventID` int(10) NOT NULL DEFAULT '0', `RequestsMeal` bit(1) NOT NULL DEFAULT b'0', `IVCParticipant` bit(1) NOT NULL DEFAULT b'0', `AttendeePrice` double(6,2) DEFAULT '0.00', `RegistrationIPAddr` varchar(15) NOT NULL DEFAULT '0.0.0.0', `RegisterByUserID` varchar(35) NOT NULL DEFAULT '', `OnWaitingList` bit(1) NOT NULL DEFAULT b'0', `AttendedEvent` bit(1) NOT NULL DEFAULT b'0', `Comments` varchar(255) DEFAULT NULL, `WebinarParticipant` bit(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`, `Site_ID`, `User_ID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
				var dbCreateTableRegistrationsResults = dbCreateTableRegistrations.execute();
			} else {
				// Database Table Exists, We must Drop it to create it again
				var dbDropTableRegistrations = new query();
				dbDropTableRegistrations.setDatasource("#application.configBean.getDatasource()#");
				dbDropTableRegistrations.setSQL("DROP TABLE eRegistrations");
				var dbDropTableRegistrationsResult = dbDropTableRegistrations.execute();

				if (len(dbDropTableRegistrationsResult.getResult()) eq 0) {
					var dbCreateTableRegistrations = new query();
					dbCreateTableRegistrations.setDatasource("#application.configBean.getDatasource()#");
					dbCreateTableRegistrations.setSQL("CREATE TABLE `eRegistrations` (`TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `RegistrationID` varchar(35) NOT NULL DEFAULT '', `RegistrationDate` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `User_ID` char(35) NOT NULL, `EventID` int(10) NOT NULL DEFAULT '0', `RequestsMeal` bit(1) NOT NULL DEFAULT b'0', `IVCParticipant` bit(1) NOT NULL DEFAULT b'0', `AttendeePrice` double(6,2) DEFAULT '0.00', `RegistrationIPAddr` varchar(15) NOT NULL DEFAULT '0.0.0.0', `RegisterByUserID` varchar(35) NOT NULL DEFAULT '', `OnWaitingList` bit(1) NOT NULL DEFAULT b'0', `AttendedEvent` bit(1) NOT NULL DEFAULT b'0', `Comments` varchar(255) DEFAULT NULL, `WebinarParticipant` bit(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`, `Site_ID`, `User_ID`)) ENGINE=InnoDB DEFAULT CHARSET=utf8;");
					var dbCreateTableRegistrationsResults = dbCreateTableRegistrations.execute();
				} else {
				 writedump(dbDropTableRegistrationsResult.getResult());
				 abort;
				}
			}

			var dbCheckTableEvents = new query();
			dbCheckTableEvents.setDatasource("#application.configBean.getDatasource()#");
			dbCheckTableEvents.setSQL("Show Tables LIKE 'eEvents'");
			var dbCheckTableEventsResult = dbCheckTableEvents.execute();

			if (dbCheckTableEventsResult.getResult().recordcount eq 0) {
				// Since the Database Table does not exists, Lets Create it
				var dbCreateTableEvents = new query();
				dbCreateTableEvents.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTableEvents.setSQL("CREATE TABLE `eEvents` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `ShortTitle` varchar(75) NOT NULL DEFAULT '', `EventDate` date NOT NULL DEFAULT '1980-01-01', `EventDate1` date DEFAULT NULL, `EventDate2` date DEFAULT NULL, `EventDate3` date DEFAULT NULL, `EventDate4` date DEFAULT NULL, `EventDate5` date DEFAULT NULL, `LongDescription` longtext, `Event_StartTime` time DEFAULT NULL, `Event_EndTime` time DEFAULT NULL, `Registration_Deadline` date NOT NULL DEFAULT '1980-01-01', `Registration_BeginTime` time DEFAULT NULL, `Registration_EndTime` time DEFAULT NULL, `EventFeatured` bit(1) NOT NULL DEFAULT b'0', `Featured_StartDate` date DEFAULT '1980-01-01', `Featured_EndDate` date DEFAULT '1980-01-01', `Featured_SortOrder` int(10) DEFAULT '100', `MemberCost` decimal(6,2) DEFAULT NULL, `NonMemberCost` decimal(6,2) DEFAULT NULL, `EarlyBird_RegistrationDeadline` date DEFAULT '1980-01-01', `EarlyBird_RegistrationAvailable` bit(1) NOT NULL DEFAULT b'0', `EarlyBird_MemberCost` decimal(6,2) DEFAULT NULL, `EarlyBird_NonMemberCost` decimal(6,2) DEFAULT NULL, `ViewSpecialPricing` bit(1) NOT NULL DEFAULT b'0', `SpecialMemberCost` decimal(6,2) DEFAULT NULL, `SpecialNonMemberCost` decimal(6,2) DEFAULT NULL, `SpecialPriceRequirements` longtext, `PGPAvailable` bit(1) NOT NULL DEFAULT b'0', `PGPPoints` decimal(5,2) DEFAULT NULL, `MealProvided` bit(1) NOT NULL DEFAULT b'0', `MealProvidedBy` int(11) DEFAULT NULL, `MealCost_Estimated` decimal(6,2) DEFAULT '0.00', `AllowVideoConference` bit(1) NOT NULL DEFAULT b'0', `VideoConferenceInfo` longtext, `VideoConferenceCost` decimal(6,2) DEFAULT NULL, `AcceptRegistrations` bit(1) NOT NULL DEFAULT b'0', `EventAgenda` longtext, `EventTargetAudience` longtext, `EventStrategies` longtext, `EventSpecialInstructions` longtext, `MaxParticipants` int(10) DEFAULT '0', `LocationType` char(1) NOT NULL DEFAULT 'S', `LocationID` int(10) DEFAULT '0', `LocationRoomID` int(10) DEFAULT '0', `Presenters` tinytext, `Facilitator` char(35) DEFAULT '0', `dateCreated` date NOT NULL, `lastUpdated` date DEFAULT NULL, `lastUpdateBy` char(35) DEFAULT NULL, `Active` bit(1) NOT NULL DEFAULT b'0', `EventCancelled` bit(1) NOT NULL DEFAULT b'0', `WebinarAvailable` bit(1) NOT NULL DEFAULT b'0', `WebinarConnectInfo` mediumtext, `WebinarMemberCost` decimal(6,2) DEFAULT NULL, `WebinarNonMemberCost` decimal(6,2) DEFAULT NULL, PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;");
				var dbCreateTableEventsResults = dbCreateTableEvents.execute();
			} else {
				// Database Table Exists, We must Drop it to create it again
				var dbDropTableEvents = new query();
				dbDropTableEvents.setDatasource("#application.configBean.getDatasource()#");
				dbDropTableEvents.setSQL("DROP TABLE eEvents");
				var dbDropTableEventsResult = dbDropTableEvents.execute();

				if (len(dbDropTableEventsResult.getResult()) eq 0) {
					var dbCreateTableEvents = new query();
					dbCreateTableEvents.setDatasource("#application.configBean.getDatasource()#");
					dbCreateTableEvents.setSQL("CREATE TABLE `eEvents` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `ShortTitle` varchar(75) NOT NULL DEFAULT '', `EventDate` date NOT NULL DEFAULT '1980-01-01', `EventDate1` date DEFAULT NULL, `EventDate2` date DEFAULT NULL, `EventDate3` date DEFAULT NULL, `EventDate4` date DEFAULT NULL, `EventDate5` date DEFAULT NULL, `LongDescription` longtext, `Event_StartTime` time DEFAULT NULL, `Event_EndTime` time DEFAULT NULL, `Registration_Deadline` date NOT NULL DEFAULT '1980-01-01', `Registration_BeginTime` time DEFAULT NULL, `Registration_EndTime` time DEFAULT NULL, `EventFeatured` bit(1) NOT NULL DEFAULT b'0', `Featured_StartDate` date DEFAULT '1980-01-01', `Featured_EndDate` date DEFAULT '1980-01-01', `Featured_SortOrder` int(10) DEFAULT '100', `MemberCost` decimal(6,2) DEFAULT NULL, `NonMemberCost` decimal(6,2) DEFAULT NULL, `EarlyBird_RegistrationDeadline` date DEFAULT '1980-01-01', `EarlyBird_RegistrationAvailable` bit(1) NOT NULL DEFAULT b'0', `EarlyBird_MemberCost` decimal(6,2) DEFAULT NULL, `EarlyBird_NonMemberCost` decimal(6,2) DEFAULT NULL, `ViewSpecialPricing` bit(1) NOT NULL DEFAULT b'0', `SpecialMemberCost` decimal(6,2) DEFAULT NULL, `SpecialNonMemberCost` decimal(6,2) DEFAULT NULL, `SpecialPriceRequirements` longtext, `PGPAvailable` bit(1) NOT NULL DEFAULT b'0', `PGPPoints` decimal(5,2) DEFAULT NULL, `MealProvided` bit(1) NOT NULL DEFAULT b'0', `MealProvidedBy` int(11) DEFAULT NULL, `MealCost_Estimated` decimal(6,2) DEFAULT '0.00', `AllowVideoConference` bit(1) NOT NULL DEFAULT b'0', `VideoConferenceInfo` longtext, `VideoConferenceCost` decimal(6,2) DEFAULT NULL, `AcceptRegistrations` bit(1) NOT NULL DEFAULT b'0', `EventAgenda` longtext, `EventTargetAudience` longtext, `EventStrategies` longtext, `EventSpecialInstructions` longtext, `MaxParticipants` int(10) DEFAULT '0', `LocationType` char(1) NOT NULL DEFAULT 'S', `LocationID` int(10) DEFAULT '0', `LocationRoomID` int(10) DEFAULT '0', `Presenters` tinytext, `Facilitator` char(35) DEFAULT '0', `dateCreated` date NOT NULL, `lastUpdated` date DEFAULT NULL, `lastUpdateBy` char(35) DEFAULT NULL, `Active` bit(1) NOT NULL DEFAULT b'0', `EventCancelled` bit(1) NOT NULL DEFAULT b'0', `WebinarAvailable` bit(1) NOT NULL DEFAULT b'0', `WebinarConnectInfo` mediumtext, `WebinarMemberCost` decimal(6,2) DEFAULT NULL, `WebinarNonMemberCost` decimal(6,2) DEFAULT NULL, PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;");
					var dbCreateTableEventsResults = dbCreateTableEvents.execute();
				} else {
				 writedump(dbDropTableEventsResult.getResult());
				 abort;
				}
			}

			var dbCheckTableFacility = new query();
			dbCheckTableFacility.setDatasource("#application.configBean.getDatasource()#");
			dbCheckTableFacility.setSQL("Show Tables LIKE 'eFacility'");
			var dbCheckTableFacilityResult = dbCheckTableFacility.execute();

			if (dbCheckTableFacilityResult.getResult().recordcount eq 0) {
				// Since the Database Table does not exists, Lets Create it
				var dbCreateTableFacility = new query();
				dbCreateTableFacility.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTableFacility.setSQL("CREATE TABLE `eFacility` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `FacilityName` tinytext NOT NULL, `PhysicalAddress` tinytext NOT NULL, `PhysicalCity` tinytext NOT NULL, `PhysicalState` varchar(2) NOT NULL DEFAULT '', `PhysicalZipCode` varchar(5) NOT NULL DEFAULT '', `PhysicalZip4` varchar(4) DEFAULT '', `PrimaryVoiceNumber` varchar(14) DEFAULT '', `BusinessWebsite` tinytext, `ContactName` tinytext, `ContactPhoneNumber` tinytext, `ContactEmail` tinytext, `dateCreated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdateBy` varchar(50) NOT NULL DEFAULT '', `isAddressVerified` char(1) NOT NULL DEFAULT '0', `GeoCode_Latitude` varchar(20) DEFAULT NULL, `GeoCode_Longitude` varchar(20) DEFAULT NULL, `GeoCode_Township` varchar(40) DEFAULT NULL, `GeoCode_StateLongName` varchar(40) DEFAULT NULL, `GeoCode_CountryShortName` varchar(40) DEFAULT NULL, `GeoCode_Neighborhood` varchar(40) DEFAULT NULL, `USPS_CarrierRoute` varchar(20) DEFAULT NULL, `USPS_CheckDigit` varchar(20) DEFAULT NULL, `USPS_DeliveryPoint` varchar(20) DEFAULT NULL, `PhysicalLocationCountry` varchar(20) DEFAULT NULL, `PhysicalCountry` varchar(20) DEFAULT NULL, `Active` char(1) NOT NULL DEFAULT '1',  `FacilityType` char(1) NOT NULL DEFAULT 'B', PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;");
				var dbCreateTableFacilityResults = dbCreateTableFacility.execute();
			} else {
				// Database Table Exists, We must Drop it to create it again
				var dbDropTableFacility = new query();
				dbDropTableFacility.setDatasource("#application.configBean.getDatasource()#");
				dbDropTableFacility.setSQL("DROP TABLE eFacility");
				var dbDropTableFacilityResult = dbDropTableFacility.execute();

				if (len(dbDropTableFacilityResult.getResult()) eq 0) {
					var dbCreateTableFacility = new query();
					dbCreateTableFacility.setDatasource("#application.configBean.getDatasource()#");
					dbCreateTableFacility.setSQL("CREATE TABLE `eFacility` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `FacilityName` tinytext NOT NULL, `PhysicalAddress` tinytext NOT NULL, `PhysicalCity` tinytext NOT NULL, `PhysicalState` varchar(2) NOT NULL DEFAULT '', `PhysicalZipCode` varchar(5) NOT NULL DEFAULT '', `PhysicalZip4` varchar(4) DEFAULT '', `PrimaryVoiceNumber` varchar(14) DEFAULT '', `BusinessWebsite` tinytext, `ContactName` tinytext, `ContactPhoneNumber` tinytext, `ContactEmail` tinytext, `dateCreated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdateBy` varchar(50) NOT NULL DEFAULT '', `isAddressVerified` char(1) NOT NULL DEFAULT '0', `GeoCode_Latitude` varchar(20) DEFAULT NULL, `GeoCode_Longitude` varchar(20) DEFAULT NULL, `GeoCode_Township` varchar(40) DEFAULT NULL, `GeoCode_StateLongName` varchar(40) DEFAULT NULL, `GeoCode_CountryShortName` varchar(40) DEFAULT NULL, `GeoCode_Neighborhood` varchar(40) DEFAULT NULL, `USPS_CarrierRoute` varchar(20) DEFAULT NULL, `USPS_CheckDigit` varchar(20) DEFAULT NULL, `USPS_DeliveryPoint` varchar(20) DEFAULT NULL, `PhysicalLocationCountry` varchar(20) DEFAULT NULL, `PhysicalCountry` varchar(20) DEFAULT NULL, `Active` char(1) NOT NULL DEFAULT '1',  `FacilityType` char(1) NOT NULL DEFAULT 'B', PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;");
					var dbCreateTableFacilityResults = dbCreateTableFacility.execute();
				} else {
				 writedump(dbDropTableFacilityResult.getResult());
				 abort;
				}
			}

			var dbCheckTableFacilityRooms = new query();
			dbCheckTableFacilityRooms.setDatasource("#application.configBean.getDatasource()#");
			dbCheckTableFacilityRooms.setSQL("Show Tables LIKE 'eFacilityRooms'");
			var dbCheckTableFacilityRoomsResult = dbCheckTableFacilityRooms.execute();

			if (dbCheckTableFacilityRoomsResult.getResult().recordcount eq 0) {
				// Since the Database Table does not exists, Lets Create it
				var dbCreateTableFacilityRooms = new query();
				dbCreateTableFacilityRooms.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTableFacilityRooms.setSQL("CREATE TABLE `eFacilityRooms` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `Facility_ID` int(10) NOT NULL DEFAULT '1', `RoomName` varchar(35) NOT NULL DEFAULT '', `Capacity` int(10) NOT NULL DEFAULT '1', `RoomFees` double(6,2) DEFAULT '0.00', `Active` bit(1) NOT NULL DEFAULT b'1', `dateCreated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdateBy` varchar(50) NOT NULL DEFAULT '', PRIMARY KEY (`TContent_ID`, `Site_ID`, `Facility_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;");
				var dbCreateTableFacilityRoomsResult = dbCreateTableFacilityRooms.execute();
			} else {
				// Database Table Exists, We must Drop it to create it again
				var dbDropTableFacilityRooms = new query();
				dbDropTableFacilityRooms.setDatasource("#application.configBean.getDatasource()#");
				dbDropTableFacilityRooms.setSQL("DROP TABLE eFacilityRooms");
				var dbDropTableFacilityRoomsResult = dbDropTableFacilityRooms.execute();

				if (len(dbDropTableFacilityRoomsResult.getResult()) eq 0) {
					var dbCreateTableFacilityRooms = new query();
				dbCreateTableFacilityRooms.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTableFacilityRooms.setSQL("CREATE TABLE `eFacilityRooms` ( `TContent_ID` int(10) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL DEFAULT '', `Facility_ID` int(10) NOT NULL DEFAULT '1', `RoomName` varchar(35) NOT NULL DEFAULT '', `Capacity` int(10) NOT NULL DEFAULT '1', `RoomFees` double(6,2) DEFAULT '0.00', `Active` bit(1) NOT NULL DEFAULT b'1', `dateCreated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdated` datetime NOT NULL DEFAULT '1980-01-01 01:00:00', `lastUpdateBy` varchar(50) NOT NULL DEFAULT '', PRIMARY KEY (`TContent_ID`, `Site_ID`, `Facility_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;");
				var dbCreateTableFacilityRoomsResult = dbCreateTableFacilityRooms.execute();
				} else {
				 writedump(dbDropTableFacilityRoomsResult.getResult());
				 abort;
				}
			}

			var dbCheckTableCaterers = new query();
			dbCheckTableCaterers.setDatasource("#application.configBean.getDatasource()#");
			dbCheckTableCaterers.setSQL("Show Tables LIKE 'eCaterers'");
			var dbCheckTableCaterersResult = dbCheckTableCaterers.execute();

			if (dbCheckTableCaterersResult.getResult().recordcount eq 0) {
				// Since the Database Table does not exists, Lets Create it
				var dbCreateTableCaterers = new query();
				dbCreateTableCaterers.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTableCaterers.setSQL("CREATE TABLE `eCaterers` (`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL, `FacilityName` tinytext NOT NULL, `PhysicalAddress` tinytext NOT NULL, `PhysicalCity` tinytext NOT NULL, `PhysicalState` varchar(2) NOT NULL, `PhysicalZipCode` varchar(5) NOT NULL, `PhysicalZip4` varchar(4) DEFAULT NULL, `PrimaryVoiceNumber` varchar(14) DEFAULT NULL, `BusinessWebsite` tinytext, `ContactName` tinytext, `ContactPhoneNumber` tinytext, `ContactEmail` tinytext, `PaymentTerms` tinytext, `DeliveryInfo` tinytext, `GuaranteeInformation` tinytext, `AdditionalNotes` tinytext, `dateCreated` date NOT NULL, `lastUpdated` date NOT NULL, `lastUpdateBy` tinytext NOT NULL, `isAddressVerified` bit(1) NOT NULL DEFAULT b'0', `GeoCode_Latitude` varchar(20) DEFAULT NULL, `GeoCode_Longitude` varchar(20) DEFAULT NULL, `GeoCode_Township` tinytext, `GeoCode_StateLongName` tinytext, `GeoCode_CountryShortName` tinytext, `GeoCode_Neighborhood` tinytext, `Active` bit(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
				var dbCreateTableCaterersResult = dbCreateTableCaterers.execute();
			} else {
				// Database Table Exists, We must Drop it to create it again
				var dbDropTableCaterers = new query();
				dbDropTableCaterers.setDatasource("#application.configBean.getDatasource()#");
				dbDropTableCaterers.setSQL("DROP TABLE eCaterers");
				var dbDropTableCaterersResult = dbDropTableCaterers.execute();

				if (len(dbDropTableCaterersResult.getResult()) eq 0) {
					var dbCreateTableCaterers = new query();
				dbCreateTableCaterers.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTableCaterers.setSQL("CREATE TABLE `eCaterers` (`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL, `FacilityName` tinytext NOT NULL, `PhysicalAddress` tinytext NOT NULL, `PhysicalCity` tinytext NOT NULL, `PhysicalState` varchar(2) NOT NULL, `PhysicalZipCode` varchar(5) NOT NULL, `PhysicalZip4` varchar(4) DEFAULT NULL, `PrimaryVoiceNumber` varchar(14) DEFAULT NULL, `BusinessWebsite` tinytext, `ContactName` tinytext, `ContactPhoneNumber` tinytext, `ContactEmail` tinytext, `PaymentTerms` tinytext, `DeliveryInfo` tinytext, `GuaranteeInformation` tinytext, `AdditionalNotes` tinytext, `dateCreated` date NOT NULL, `lastUpdated` date NOT NULL, `lastUpdateBy` tinytext NOT NULL, `isAddressVerified` bit(1) NOT NULL DEFAULT b'0', `GeoCode_Latitude` varchar(20) DEFAULT NULL, `GeoCode_Longitude` varchar(20) DEFAULT NULL, `GeoCode_Township` tinytext, `GeoCode_StateLongName` tinytext, `GeoCode_CountryShortName` tinytext, `GeoCode_Neighborhood` tinytext, `Active` bit(1) NOT NULL DEFAULT b'0', PRIMARY KEY (`TContent_ID`,`Site_ID`) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;");
				var dbCreateTableCaterersResult = dbCreateTableCaterers.execute();
				} else {
				 writedump(dbDropTableCaterersResult.getResult());
				 abort;
				}
			}

			var dbCheckTableMembership = new query();
			dbCheckTableMembership.setDatasource("#application.configBean.getDatasource()#");
			dbCheckTableMembership.setSQL("Show Tables LIKE 'eMembership'");
			var dbCheckTableMembershipResult = dbCheckTableMembership.execute();

			if (dbCheckTableMembershipResult.getResult().recordcount eq 0) {
				// Since the Database Table does not exists, Lets Create it
				var dbCreateTableMembership = new query();
				dbCreateTableMembership.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTableMembership.setSQL("CREATE TABLE `eMembership` (`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `OrganizationName` varchar(50) NOT NULL, `OrganizationDomainName` varchar(50) NOT NULL, `StateDOE_IDNumber` varchar(10) DEFAULT NULL, `StateDOE_State` tinytext, `Active` bit(1) NOT NULL DEFAULT b'0', `dateCreated` date NOT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL, `Mailing_Address` tinytext, `Mailing_City` tinytext, `Mailing_State` tinytext, `Mailing_ZipCode` tinytext, `Primary_PhoneNumber` tinytext, `Primary_FaxNumber` tinytext, `Physical_Address` tinytext, `Physical_City` tinytext, `Physical_State` tinytext, `Physical_ZipCode` tinytext, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;");
				var dbCreateTableMembershipResult = dbCreateTableMembership.execute();
			} else {
				// Database Table Exists, We must Drop it to create it again
				var dbDropTableMembership = new query();
				dbDropTableMembership.setDatasource("#application.configBean.getDatasource()#");
				dbDropTableMembership.setSQL("DROP TABLE eMembership");
				var dbDropTableMembershipResult = dbDropTableMembership.execute();

				if (len(dbDropTableMembershipResult.getResult()) eq 0) {
					var dbCreateTableMembership = new query();
					dbCreateTableMembership.setDatasource("#application.configBean.getDatasource()#");
					dbCreateTableMembership.setSQL("CREATE TABLE `eMembership` (`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `OrganizationName` varchar(50) NOT NULL, `OrganizationDomainName` varchar(50) NOT NULL, `StateDOE_IDNumber` varchar(10) DEFAULT NULL, `StateDOE_State` tinytext, `Active` bit(1) NOT NULL DEFAULT b'0', `dateCreated` date NOT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL, `Mailing_Address` tinytext, `Mailing_City` tinytext, `Mailing_State` tinytext, `Mailing_ZipCode` tinytext, `Primary_PhoneNumber` tinytext, `Primary_FaxNumber` tinytext, `Physical_Address` tinytext, `Physical_City` tinytext, `Physical_State` tinytext, `Physical_ZipCode` tinytext, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;");
					var dbCreateTableMembershipResult = dbCreateTableMembership.execute();
				} else {
					writedump(dbCreateTableMembershipResult.getResult());
					abort;
				}
			}

			var dbCheckTableUserMatrix = new query();
			dbCheckTableUserMatrix.setDatasource("#application.configBean.getDatasource()#");
			dbCheckTableUserMatrix.setSQL("Show Tables LIKE 'eUserMatrix'");
			var dbCheckTableUserMatrixResult = dbCheckTableUserMatrix.execute();

			if (dbCheckTableUserMatrixResult.getResult().recordcount eq 0) {
				// Since the Database Table does not exists, Lets Create it
				var dbCreateTableUserMatrix = new query();
				dbCreateTableUserMatrix.setDatasource("#application.configBean.getDatasource()#");
				dbCreateTableUserMatrix.setSQL("CREATE TABLE `eUserMatrix` ( `TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `User_ID` char(35) NOT NULL, `School_District` int(11) DEFAULT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;");
				var dbCreateTableUserMatrixResult = dbCreateTableUserMatrix.execute();
			} else {
				// Database Table Exists, We must Drop it to create it again
				var dbDropTableUserMatrix = new query();
				dbDropTableUserMatrix.setDatasource("#application.configBean.getDatasource()#");
				dbDropTableUserMatrix.setSQL("DROP TABLE eUserMatrix");
				var dbDropTableUserMatrixResult = dbDropTableUserMatrix.execute();

				if (len(dbDropTableUserMatrixResult.getResult()) eq 0) {
					var dbCreateTableUserMatrix = new query();
					dbCreateTableUserMatrix.setDatasource("#application.configBean.getDatasource()#");
					dbCreateTableUserMatrix.setSQL("CREATE TABLE `eUserMatrix` ( `TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `User_ID` char(35) NOT NULL, `School_District` int(11) DEFAULT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;");
					var dbCreateTableUserMatrixResult = dbCreateTableUserMatrix.execute();
				} else {
				 writedump(dbCreateTableUserMatrixResult.getResult());
				 abort;
				}
			}
		</cfscript>

		<cfscript>
			inserteFacilityRows = arrayNew(1);
			inserteFacilityRows[1] = "'#Session.SiteID#', 'Northern Indiana ESC', '56535 Magnetic Dr', 'Mishawaka', 'IN', '46545', '', '(574)254-0111', 'http://www.niesc.k12.in.us', 'Ted Chittum', '574-254-0111', 'tchittum@niesc.k12.in.us', '2013-09-06 14:50:50', '2013-09-07 14:48:33', 'admin', 1, '41.6729735', '-86.1288432', 'Penn', 'Indiana', 'US', null, null, null, null, null, null, 1, 'S'";
			inserteFacilityRows[2] = "'#Session.SiteID#', 'Black Squirrel Golf Course', '1017 Larimer Dr', 'Goshen', 'IN', '46526', '', '(574)533-1828', '', 'Randy', '', '', '2013-09-10 08:46:47', '2013-09-10 08:46:48', 'admin', 1, '41.5793580', '-85.8562770', 'Elkhart', 'Indiana', 'US', null, null, null, null, null, null, 1, 'B'";
			inserteFacilityRows[3] = "'#Session.SiteID#', 'Christo\'s Banquet Center', '850 Lincolnway E', 'Plymouth', 'IN', '46563', '', '(574)935-9666', '', '', '', '', '2013-09-10 11:33:15', '2013-09-10 11:33:15', 'admin', 1, '41.3426657', '-86.2986407', 'Center', 'Indiana', 'US', null, null, null, null, null, null, 1, 'B'";

			insertFacilityRoomRows = arrayNew(1);
			insertFacilityRoomRows[1] = "'#Session.SiteID#', 1, 'Conference Room 1', 30, '0.00', 1, '2013-09-11 11:35:12', '2013-09-11 11:35:12', 'admin'";
			insertFacilityRoomRows[2] = "'#Session.SiteID#', 1, 'Conference Room 2', 15, '0.00', 1, '2013-09-11 11:35:12', '2013-09-11 11:35:12', 'admin'";

			insertMembershipRows = arrayNew(1);
			insertMembershipRows[1] = "'#Session.SiteID#','21st Century Charter Sch of Gary','geofoundation.org','9545','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','333 N Pennsylvania Suite 1000','Indianapolis','IN','46202','3175361027','3179219443','','','',''";
			insertMembershipRows[2] = "'#Session.SiteID#','Adams Central Community Schools','accs.k12.in.us','0015','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','222 W Washington St','Monroe','IN','46772','2606926193','2606926198','','','',''";
			insertMembershipRows[3] = "'#Session.SiteID#','Alexandria Com School Corp','alex.k12.in.us','5265','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','202 E Washington St','Alexandria','IN','46001','7657244496','7657245049','','','',''";
			insertMembershipRows[4] = "'#Session.SiteID#','Amish Parochial Schools of IN','','9235','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','11446 N 1000 W','Nappanee','IN','46550','8003216799','5740000000','','','',''";
			insertMembershipRows[5] = "'#Session.SiteID#','Anderson Community School Corp','acsc.net','5275','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1600 Hillcrest Ave','Anderson','IN','46011','7656412028','7656412080','','','',''";
			insertMembershipRows[6] = "'#Session.SiteID#','Anderson Preparatory Academy','goapa.org','9790','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','101 W 29th St','Anderson','IN','46016','7656498472','7656402550','','','',''";
			insertMembershipRows[7] = "'#Session.SiteID#','Andrew Academy','archindy.org','9715','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4050 E 38th St','Indianapolis','IN','46218','3172367324','3172361422','','','',''";
			insertMembershipRows[8] = "'#Session.SiteID#','Andrew J Brown Academy','heritageacademies.com','9615','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3600 N German Church Rd','Indianapolis','IN','46235','3178910730','3178910908','','','',''";
			insertMembershipRows[9] = "'#Session.SiteID#','Archdiocese of Indianapolis','archindy.org','9200','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1400 N Meridian St','Indianapolis','IN','46202','3172361441','3172613364','','','',''";
			insertMembershipRows[10] = "'#Session.SiteID#','Argos Community Schools','argos.k12.in.us','5470','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','410 N First St','Argos','IN','46501','5748925139','5748926527','','','',''";
			insertMembershipRows[11] = "'#Session.SiteID#','Aspire Charter Academy','heritageacademies.com','9685','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4900 W 15th Ave','Gary','IN','46406','2199447400','2199447474','','','',''";
			insertMembershipRows[12] = "'#Session.SiteID#','Attica Consolidated Sch Corp','attica.k12.in.us','2435','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','205 E Sycamore St','Attica','IN','47918','7657627000','7657627007','','','',''";
			insertMembershipRows[13] = "'#Session.SiteID#','Avon Community School Corp','avon-schools.org','3315','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','7203 E US Hwy 36','Avon','IN','46123','3175446000','3175446001','','','',''";
			insertMembershipRows[14] = "'#Session.SiteID#','Barr-Reeve Com Schools Inc','barr.k12.in.us','1315','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','Box 97','Montgomery','IN','47558','8124863220','8124863509','','','',''";
			insertMembershipRows[15] = "'#Session.SiteID#','Bartholomew Con School Corp','bcsc.k12.in.us','0365','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1200 Central Ave','Columbus','IN','47201','8123764220','8123764486','','','',''";
			insertMembershipRows[16] = "'#Session.SiteID#','Batesville Community Sch Corp','batesville.k12.in.us','6895','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 121','Batesville','IN','47006','8129342194','8129330833','','','',''";
			insertMembershipRows[17] = "'#Session.SiteID#','Baugo Community Schools','baugo.org','2260','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','29125 CR 22 W','Elkhart','IN','46517','5742938583','5742942171','','','',''";
			insertMembershipRows[18] = "'#Session.SiteID#','Beacon Academy','','9830','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','620 Cumberland Ave','West Lafayette','IN','47906','7658382045','7658382034','','','',''";
			insertMembershipRows[19] = "'#Session.SiteID#','Beech Grove City Schools','bgcs.k12.in.us','5380','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5334 Hornet Ave','Beech Grove','IN','46107','3177884481','3177824065','','','',''";
			insertMembershipRows[20] = "'#Session.SiteID#','Benton Community School Corp','benton.k12.in.us','0395','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 512','Fowler','IN','47944','7658840850','7658841614','','','',''";
			insertMembershipRows[21] = "'#Session.SiteID#','Blackford County Schools','bcs.k12.in.us','0515','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','0668 W 200 S','Hartford City','IN','47348','7653487550','7653487552','','','',''";
			insertMembershipRows[22] = "'#Session.SiteID#','Bloomfield School District','bsd.k12.in.us','2920','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 266 500 W South St','Bloomfield','IN','47424','8123844507','8123840172','','','',''";
			insertMembershipRows[23] = "'#Session.SiteID#','Blue River Valley Schools','brv.k12.in.us','3405','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 217','Mount Summit','IN','47361','7658364816','7658364817','','','',''";
			insertMembershipRows[24] = "'#Session.SiteID#','Bremen Public Schools','bps.k12.in.us','5480','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','512 W Grant St','Bremen','IN','46506','5745463929','5745466303','','','',''";
			insertMembershipRows[25] = "'#Session.SiteID#','Brown County School Corporation','brownco.k12.in.us','0670','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 38','Nashville','IN','47448','8129886601','8129885403','','','',''";
			insertMembershipRows[26] = "'#Session.SiteID#','Brownsburg Community Sch Corp','brownsburg.k12.in.us','3305','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','310 Stadium Dr','Brownsburg','IN','46112','3178525726','3178521015','','','',''";
			insertMembershipRows[27] = "'#Session.SiteID#','Brownstown Cnt Com Sch Corp','btownccs.k12.in.us','3695','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','608 W Commerce St','Brownstown','IN','47220','8123584271','8123585303','','','',''";
			insertMembershipRows[28] = "'#Session.SiteID#','Burris Laboratory School','','9620','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','Dean\'s Office-Teachers Clg BSU','Muncie','IN','47306','7652858488','7652852166','','','',''";
			insertMembershipRows[29] = "'#Session.SiteID#','C A Beard Memorial School Corp','cabeard.k12.in.us','3455','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','8139 W US 40','Knightstown','IN','46148','7653455101','7653455103','','','',''";
			insertMembershipRows[30] = "'#Session.SiteID#','Canaan Community Academy','canaanca.com','9725','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','8775 N Canaan Main St POB 20','Canaan','IN','47224','8128390003','','','','',''";
			insertMembershipRows[31] = "'#Session.SiteID#','Cannelton City Schools','cannelton.k12.in.us','6340','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','109 S Third St','Cannelton','IN','47520','8125472637','8125474142','','','',''";
			insertMembershipRows[32] = "'#Session.SiteID#','Career Academy at South Bend','sbcain.org','9880','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3801 Crescent Cir','South Bend','IN','46628','5742999800','5742881625','','','',''";
			insertMembershipRows[33] = "'#Session.SiteID#','Carmel Clay Schools','ccs.k12.in.us','3060','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5201 E Main St','Carmel','IN','46033','3178449961','3178449965','','','',''";
			insertMembershipRows[34] = "'#Session.SiteID#','Carpe Diem - Meridian Campus','carpediemmeridian.com','9755','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2220 N Meridian St','Indianapolis','IN','46208','3179217497','3179217299','','','',''";
			insertMembershipRows[35] = "'#Session.SiteID#','Carroll Consolidated Sch Corp','carroll.k12.in.us','0750','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2 S 3rd St','Flora','IN','46929','5749674113','5749673831','','','',''";
			insertMembershipRows[36] = "'#Session.SiteID#','Caston School Corporation','caston.k12.in.us','2650','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','Box 8','Fulton','IN','46931','5748572035','5748576795','','','',''";
			insertMembershipRows[37] = "'#Session.SiteID#','Center Grove Com Sch Corp','centergrove.k12.in.us','4205','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4800 W Stones Crossing Rd','Greenwood','IN','46143','3178819326','3178810241','','','',''";
			insertMembershipRows[38] = "'#Session.SiteID#','Centerville-Abington Com Schs','centerville.k12.in.us','8360','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','115 W South St','Centerville','IN','47330','7658553475','7658552524','','','',''";
			insertMembershipRows[39] = "'#Session.SiteID#','Central Noble Com School Corp','centralnoble.k12.in.us','6055','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','200 E Main St','Albion','IN','46701','2606362175','2606367918','','','',''";
			insertMembershipRows[40] = "'#Session.SiteID#','Challenge Foundation Academy','teamcfaindy.org','9645','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3980 Meadows Dr','Indianapolis','IN','46205','3178033182','3178032367','','','',''";
			insertMembershipRows[41] = "'#Session.SiteID#','Charles A Tindley Accelerated Schl','tindleyschool.org','9445','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3960 Meadows Dr','Indianapolis','IN','46205','3175451745','3175474415','','','',''";
			insertMembershipRows[42] = "'#Session.SiteID#','Charter School of the Dunes','csotd.org','9310','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','860 N Lake St','Gary','IN','46403','2199399690','2199399031','','','',''";
			insertMembershipRows[43] = "'#Session.SiteID#','Christel House Academy South','chacademy.org','9380','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2717 S East St','Indianapolis','IN','46225','3177834690','3177834693','','','',''";
			insertMembershipRows[44] = "'#Session.SiteID#','Christel House DORS South','chdors.org','9385','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2717 S East St','Indianapolis','IN','46225','3177834690','3170000000','','','',''";
			insertMembershipRows[45] = "'#Session.SiteID#','Clark-Pleasant Com School Corp','cpcsc.k12.in.us','4145','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','50 Center St','Whiteland','IN','46184','3175357579','3175354931','','','',''";
			insertMembershipRows[46] = "'#Session.SiteID#','Clarksville Com School Corp','ccsc.k12.in.us','1000','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','200 Ettel Ln','Clarksville','IN','47129','8122827753','8122827754','','','',''";
			insertMembershipRows[47] = "'#Session.SiteID#','Clay Community Schools','clay.k12.in.us','1125','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1013 S Forest Ave','Brazil','IN','47834','8124434461','8124420849','','','',''";
			insertMembershipRows[48] = "'#Session.SiteID#','Clinton Central School Corp','clinton.k12.in.us','1150','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','Box 118','Michigantown','IN','46057','7652492515','7652492504','','','',''";
			insertMembershipRows[49] = "'#Session.SiteID#','Clinton Prairie School Corp','cpsc.k12.in.us','1160','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4431 W Old SR 28','Frankfort','IN','46041','7656591339','7656595305','','','',''";
			insertMembershipRows[50] = "'#Session.SiteID#','Cloverdale Community Schools','cloverdale.k12.in.us','6750','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','310 E Logan','Cloverdale','IN','46120','7657954664','7657955166','','','',''";
			insertMembershipRows[51] = "'#Session.SiteID#','Community Montessori Inc','shiningminds.com','9320','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4102 St Joseph Rd','New Albany','IN','47150','8129481000','8129480441','','','',''";
			insertMembershipRows[52] = "'#Session.SiteID#','Community Schools of Frankfort','frankfort.k12.in.us','1170','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2400 E Wabash Ave','Frankfort','IN','46041','7656545585','7656596220','','','',''";
			insertMembershipRows[53] = "'#Session.SiteID#','Concord Community Schools','concord.k12.in.us','2270','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','59040 Minuteman Way','Elkhart','IN','46517','5748755161','5748758762','','','',''";
			insertMembershipRows[54] = "'#Session.SiteID#','Covington Community Sch Corp','covington.k12.in.us','2440','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','601 Market St','Covington','IN','47932','7657934877','7657935209','','','',''";
			insertMembershipRows[55] = "'#Session.SiteID#','Cowan Community School Corp','cowan.k12.in.us','1900','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','9401 S Nottingham','Muncie','IN','47302','7652894866','7652840315','','','',''";
			insertMembershipRows[56] = "'#Session.SiteID#','Crawford Co Com School Corp','cccs.k12.in.us','1300','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5805 E Administration Rd','Marengo','IN','47140','8123652135','8123652783','','','',''";
			insertMembershipRows[57] = "'#Session.SiteID#','Crawfordsville Com Schools','cville.k12.in.us','5855','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1000 Fairview Ave','Crawfordsville','IN','47933','7653622342','7653643237','','','',''";
			insertMembershipRows[58] = "'#Session.SiteID#','Crothersville Community Schools','','3710','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','201 S Preston St','Crothersville','IN','47229','8127932601','8127933004','','','',''";
			insertMembershipRows[59] = "'#Session.SiteID#','Crown Point Community Sch Corp','cps.k12.in.us','4660','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','200 E North St','Crown Point','IN','46307','2196633371','2196623414','','','',''";
			insertMembershipRows[60] = "'#Session.SiteID#','CSUSA Donnan','charterschoolusa.com','8825','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','','','','','2398347379','','','','',''";
			insertMembershipRows[61] = "'#Session.SiteID#','CSUSA Howe','charterschoolusa.com','8810','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6245 N Federal Hwy 5th Floor','Fort Lauderdale','FL','33308','9542023500','9542023512','','','',''";
			insertMembershipRows[62] = "'#Session.SiteID#','CSUSA Manual','charterschoolusa.com','8815','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','','','','','2398347379','','','','',''";
			insertMembershipRows[63] = "'#Session.SiteID#','Culver Community Schools Corp','culver.k12.in.us','5455','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 231','Culver','IN','46511','5748423364','5748424615','','','',''";
			insertMembershipRows[64] = "'#Session.SiteID#','Daleville Community Schools','daleville.k12.in.us','1940','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','14300 W 2nd St','Daleville','IN','47334','7653783329','7653783649','','','',''";
			insertMembershipRows[65] = "'#Session.SiteID#','Damar Charter Academy','damarcharteracademy.org','9920','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5125 Decatur Blvd Suite D','Indianapolis','IN','46241','3175487210','','','','',''";
			insertMembershipRows[66] = "'#Session.SiteID#','Danville Community School Corp','danville.k12.in.us','3325','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','200 Warrior Way','Danville','IN','46122','3177452212','3177453924','','','',''";
			insertMembershipRows[67] = "'#Session.SiteID#','Decatur County Com Schools','decaturco.k12.in.us','1655','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2020 N Montgomery Rd','Greensburg','IN','47240','8126634595','8126634168','','','',''";
			insertMembershipRows[68] = "'#Session.SiteID#','DeKalb Co Ctl United Sch Dist','dekalb.k12.in.us','1835','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3326 CR 427','Waterloo','IN','46793','2609201011','2608377767','','','',''";
			insertMembershipRows[69] = "'#Session.SiteID#','DeKalb Co Eastern Com Sch Dist','dekalbeastern.com','1805','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','300 E Washington St','Butler','IN','46721','2608682125','2608682562','','','',''";
			insertMembershipRows[70] = "'#Session.SiteID#','Delaware Community School Corp','delcomschools.org','1875','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','7821 SR 3 N','Muncie','IN','47303','7652845074','7652845259','','','',''";
			insertMembershipRows[71] = "'#Session.SiteID#','Delphi Community School Corp','delphi.k12.in.us','0755','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','501 Armory Rd','Delphi','IN','46923','7655642100','7655646919','','','',''";
			insertMembershipRows[72] = "'#Session.SiteID#','Diocese of Evansville','evdio.org','9215','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 4169','Evansville','IN','47724','8124245536','8124240973','','','',''";
			insertMembershipRows[73] = "'#Session.SiteID#','Diocese of Fort Wayne','fw.diocesefwsb.org','9220','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 390','Fort Wayne','IN','46801','2604224611','2604263077','','','',''";
			insertMembershipRows[74] = "'#Session.SiteID#','Diocese of Gary','dcgary.org','9205','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','9292 Broadway','Merrillville','IN','46410','2197699292','2197389034','','','',''";
			insertMembershipRows[75] = "'#Session.SiteID#','Diocese of Lafayette Catholic Sch','dol-in.org','9210','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2300 S 9th St','Lafayette','IN','47905','7652694670','7652694671','','','',''";
			insertMembershipRows[76] = "'#Session.SiteID#','Discovery Charter School','aqs.org','9870','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','800 Canonie Dr','Porter','IN','46304','3176952998','2190000000','','','',''";
			insertMembershipRows[77] = "'#Session.SiteID#','Dr Robert H Faulkner Academy','faulkneracademy.org','9795','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1111 W 2nd St','Marion','IN','46952','7656629910','7656629918','','','',''";
			insertMembershipRows[78] = "'#Session.SiteID#','Duneland School Corporation','duneland.k12.in.us','6470','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','601 W Morgan Ave','Chesterton','IN','46304','2199833600','2199833614','','','',''";
			insertMembershipRows[79] = "'#Session.SiteID#','East Allen County Schools','eacs.k12.in.us','0255','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1240 SR 930 E','New Haven','IN','46774','2604460100','2604460107','','','',''";
			insertMembershipRows[80] = "'#Session.SiteID#','East Chicago Lighthouse Charter','lighthouse-academies.org','9595','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3916 Pulaski St','East Chicago','IN','46312','2193787451','2193787460','','','',''";
			insertMembershipRows[81] = "'#Session.SiteID#','East Chicago Urban Enterprise Acad','aqs.org','9555','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1402 E Chicago Ave','East Chicago','IN','46312','2193923650','2193923652','','','',''";
			insertMembershipRows[82] = "'#Session.SiteID#','East Gibson School Corporation','egsc.k12.in.us','2725','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','941 S Franklin St','Oakland City','IN','47660','8127494755','8127493343','','','',''";
			insertMembershipRows[83] = "'#Session.SiteID#','East Noble School Corp','eastnoble.net','6060','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','126 W Rush St','Kendallville','IN','46755','2603472502','2603470111','','','',''";
			insertMembershipRows[84] = "'#Session.SiteID#','East Porter County School Corp','eastporter.k12.in.us','6510','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','502 E College Ave - PO Box 370','Kouts','IN','46347','2197662214','2197662885','','','',''";
			insertMembershipRows[85] = "'#Session.SiteID#','East Washington School Corp','ewsc.k12.in.us','8215','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1050 N Eastern School Rd','Pekin','IN','47165','8129673926','8129675797','','','',''";
			insertMembershipRows[86] = "'#Session.SiteID#','Eastbrook Community Sch Corp','eastbrook.k12.in.us','2815','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','CR 560 S 900 E','Marion','IN','46953','7656640624','7656640626','','','',''";
			insertMembershipRows[87] = "'#Session.SiteID#','Eastern Greene Schools','egreene.k12.in.us','2940','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1471 N SR 43','Bloomfield','IN','47424','8128255722','8128259413','','','',''";
			insertMembershipRows[88] = "'#Session.SiteID#','Eastern Hancock Co Com Sch Corp','easternhancock.org','3145','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','10370 E 250 N','Charlottesville','IN','46117','3174670064','3179365516','','','',''";
			insertMembershipRows[89] = "'#Session.SiteID#','Eastern Howard School Corp','eastern.k12.in.us','3480','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','221 W Main Suite One','Greentown','IN','46936','7656283391','7656285017','','','',''";
			insertMembershipRows[90] = "'#Session.SiteID#','Eastern Pulaski Com Sch Corp','epulaski.k12.in.us','6620','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','711 School Dr','Winamac','IN','46996','5749464010','5749464510','','','',''";
			insertMembershipRows[91] = "'#Session.SiteID#','Edinburgh Community Sch Corp','ecsc.k12.in.us','4215','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','202 S Keeley St','Edinburgh','IN','46124','8125262681','8125260271','','','',''";
			insertMembershipRows[92] = "'#Session.SiteID#','Edison Learning Roosevelt','edisonlearning.com','8820','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','730 W 25th Ave','Gary','in','46407','2488912752','','','','',''";
			insertMembershipRows[93] = "'#Session.SiteID#','EdPower Arlington','edpower.org','8830','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3960 Meadows Dr','Indianapolis','IN','46205','3175451745','3175414415','','','',''";
			insertMembershipRows[94] = "'#Session.SiteID#','Elkhart Community Schools','elkhart.k12.in.us','2305','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2720 California Rd','Elkhart','IN','46514','5742625516','5742625733','','','',''";
			insertMembershipRows[95] = "'#Session.SiteID#','Elwood Community School Corp','elwood.k12.in.us','5280','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1306 N Anderson St','Elwood','IN','46036','7655529861','7655528088','','','',''";
			insertMembershipRows[96] = "'#Session.SiteID#','Eminence Community School Corp','eminence.k12.in.us','5910','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 135','Eminence','IN','46125','7655282101','7655282262','','','',''";
			insertMembershipRows[97] = "'#Session.SiteID#','Enlace Academy','enlaceacademy.org','9365','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5420 N College Ave Ste 202','Indianapolis','IN','46220','3177489599','3172578230','','','',''";
			insertMembershipRows[98] = "'#Session.SiteID#','Evansville Vanderburgh Sch Corp','evsc.k12.in.us','7995','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','951 Walnut St','Evansville','IN','47713','8124358477','8124358421','','','',''";
			insertMembershipRows[99] = "'#Session.SiteID#','Excel Center for Adult Learners','goodwilleducation.org','9910','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1635 W Michigan St','Indianapolis','IN','46222','3175244141','3175244267','','','',''";
			insertMembershipRows[100] = "'#Session.SiteID#','Fairfield Community Schools','fairfield.k12.in.us','2155','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','67240 CR 31','Goshen','IN','46528','5748312188','5748315698','','','',''";
			insertMembershipRows[101] = "'#Session.SiteID#','Fall Creek Academy','','9370','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','333 N Pennsylvania Suite 1000','Indianapolis','IN','46204','3175361027','3179219443','','','',''";
			insertMembershipRows[102] = "'#Session.SiteID#','Fayette County School Corp','fayette.k12.in.us','2395','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1401 Spartan Dr','Connersville','IN','47331','7658252178','7658258060','','','',''";
			insertMembershipRows[103] = "'#Session.SiteID#','Flanner House Elementary School','flannerhouse.com','9390','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2424 Dr Martin Luther King Jr','Indianapolis','IN','46208','3179254231','3179239632','','','',''";
			insertMembershipRows[104] = "'#Session.SiteID#','Flat Rock-Hawcreek School Corp','flatrock.k12.in.us','0370','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','9423 N SR 9','Hope','IN','47246','8125462000','8125465617','','','',''";
			insertMembershipRows[105] = "'#Session.SiteID#','Fort Wayne Community Schools','fwcs.k12.in.us','0235','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1200 S Clinton St','Fort Wayne','IN','46802','2604672025','2604671975','','','',''";
			insertMembershipRows[106] = "'#Session.SiteID#','Franklin Community School Corp','franklinschools.org','4225','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','998 Grizzly Cub Dr','Franklin','IN','46131','3177385800','3177385812','','','',''";
			insertMembershipRows[107] = "'#Session.SiteID#','Franklin County Com Sch Corp','fccsc.k12.in.us','2475','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','225 E 10th St','Brookville','IN','47012','7656474128','7656472417','','','',''";
			insertMembershipRows[108] = "'#Session.SiteID#','Franklin Township Com Sch Corp','ftcsc.k12.in.us','5310','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6141 S Franklin Rd','Indianapolis','IN','46259','3178622411','3178627238','','','',''";
			insertMembershipRows[109] = "'#Session.SiteID#','Frankton-Lapel Community Schs','flcs.k12.in.us','5245','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','7916 W 300 N','Anderson','IN','46011','7657341261','7657341129','','','',''";
			insertMembershipRows[110] = "'#Session.SiteID#','Fremont Community Schools','fcs.k12.in.us','7605','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 665','Fremont','IN','46737','2604955005','2604959798','','','',''";
			insertMembershipRows[111] = "'#Session.SiteID#','Frontier School Corporation','frontier.k12.in.us','8525','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 809','Chalmers','IN','47929','2199845009','2199845022','','','',''";
			insertMembershipRows[112] = "'#Session.SiteID#','Garrett-Keyser-Butler Com','gkb.k12.in.us','1820','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','801 E Houston St','Garrett','IN','46738','2603573185','2603574565','','','',''";
			insertMembershipRows[113] = "'#Session.SiteID#','Gary Community School Corp','garycsc.k12.in.us','4690','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','620 E 10th Pl','Gary','IN','46402','2198815401','2198814102','','','',''";
			insertMembershipRows[114] = "'#Session.SiteID#','Gary Lighthouse Charter School','lighthouse-academies.org','9535','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3201 Pierce St','Gary','IN','46408','2198801762','2198844858','','','',''";
			insertMembershipRows[115] = "'#Session.SiteID#','Gary Middle College','geofoundation.org','9885','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1630 North Meridian St Ste 350','Indianapolis','IN','46202','3175361027','2190000000','','','',''";
			insertMembershipRows[116] = "'#Session.SiteID#','Geist Montessori Academy','','9665','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','13942 E 96th St Suite 120','McCordsville','IN','46055','3173351158','3173351265','','','',''";
			insertMembershipRows[117] = "'#Session.SiteID#','George & Veronica Phalen Academy','phalenacademies','9925','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1630 N Meridian St Ste 330','Indianapolis','IN','46202','3179975512','8668965660','','','',''";
			insertMembershipRows[118] = "'#Session.SiteID#','Goshen Community Schools','goshenschools.org','2315','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','613 E Purl St','Goshen','IN','46526','5745338631','5745332505','','','',''";
			insertMembershipRows[119] = "'#Session.SiteID#','Greater Clark County Schools','gcs.k12.in.us','1010','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2112 Utica-Sellersburg Rd','Jeffersonville','IN','47130','8122830701','8122884804','','','',''";
			insertMembershipRows[120] = "'#Session.SiteID#','Greater Jasper Con Schs','gjcs.k12.in.us','2120','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1520 St Charles St Suite 1','Jasper','IN','47546','8124821801','8124823388','','','',''";
			insertMembershipRows[121] = "'#Session.SiteID#','Greencastle Community Sch Corp','greencastle.k12.in.us','6755','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 480','Greencastle','IN','46135','7656539771','7656531282','','','',''";
			insertMembershipRows[122] = "'#Session.SiteID#','Greenfield-Central Com Schools','gcsc.k12.in.us','3125','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','110 W North St','Greenfield','IN','46140','3174624434','3174674227','','','',''";
			insertMembershipRows[123] = "'#Session.SiteID#','Greensburg Community Schools','greensburg.k12.in.us','1730','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1312 W Westridge Pky','Greensburg','IN','47240','8126634774','8126635713','','','',''";
			insertMembershipRows[124] = "'#Session.SiteID#','Greenwood Community Sch Corp','gws.k12.in.us','4245','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','605 W Smith Valley Rd','Greenwood','IN','46142','3178894060','3178894068','','','',''";
			insertMembershipRows[125] = "'#Session.SiteID#','Griffith Public Schools','griffith.k12.in.us','4700','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 749','Griffith','IN','46319','2199244250','2199225933','','','',''";
			insertMembershipRows[126] = "'#Session.SiteID#','Hamilton Community Schools','hcs.k12.in.us','7610','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','903 S Wayne St','Hamilton','IN','46742','2604882513','2604882348','','','',''";
			insertMembershipRows[127] = "'#Session.SiteID#','Hamilton Heights School Corp','mail.hhsc.k12.in.us','3025','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','410 W Main St','Arcadia','IN','46030','3179843538','3179843042','','','',''";
			insertMembershipRows[128] = "'#Session.SiteID#','Hamilton Southeastern Schools','hse.k12.in.us','3005','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','13485 Cumberland Rd','Fishers','IN','46038','3175944100','3175944109','','','',''";
			insertMembershipRows[129] = "'#Session.SiteID#','Hammond Academy of Science & Tech','hammondacademy.org','9705','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','33 Muenich Ct','Hammond','IN','46320','2198520500','2198534152','','','',''";
			insertMembershipRows[130] = "'#Session.SiteID#','Hanover Community School Corp','hanover.k12.in.us','4580','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 645','Cedar Lake','IN','46303','2193743500','2193744411','','','',''";
			insertMembershipRows[131] = "'#Session.SiteID#','Herron Charter','herronhighschool.org','9650','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','110 E 16th St','Indianapolis','IN','46202','3172310010','2312313759','','','',''";
			insertMembershipRows[132] = "'#Session.SiteID#','Hoosier Acad Virtual Charter','k12.com','9865','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2855 N Franklin Rd','Indianapolis','IN','46219','3174956494','3174956020','','','',''";
			insertMembershipRows[133] = "'#Session.SiteID#','Hoosier Academy - Indianapolis','k12.com','9805','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5640 Caito Dr','Indianapolis','IN','46226','3174956494','3175471500','','','',''";
			insertMembershipRows[134] = "'#Session.SiteID#','Hope Academy','fairbankscd.org','9655','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','8102 Clearvista Pky','Indianapolis','IN','46256','3175729356','3178063104','','','',''";
			insertMembershipRows[135] = "'#Session.SiteID#','Huntington Co Com Sch Corp','hccsc.k12.in.us','3625','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2485 Waterworks Rd','Huntington','IN','46750','2603568312','2603582222','','','',''";
			insertMembershipRows[136] = "'#Session.SiteID#','Imagine Life Sciences Acad - West','imagineschools.com','9850','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4950 W 34th St','Indianapolis','IN','46224','3172979100','3172979460','','','',''";
			insertMembershipRows[137] = "'#Session.SiteID#','IN Acad for Sci Math Humanities','','9625','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','Dean\'s Office-Teachers Clg BSU','Muncie','IN','47306','7652858488','7652852166','','','',''";
			insertMembershipRows[138] = "'#Session.SiteID#','IN Department of Correction','doc.in.gov','9100','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','302 W Washington St Rm E334','Indianapolis','IN','46204','3172333111','3172340956','','','',''";
			insertMembershipRows[139] = "'#Session.SiteID#','IN Department of Mental Health','fssa.state.in.us','9110','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','402 W Washington St Rm W353','Indianapolis','IN','46204','3172327844','3170000000','','','',''";
			insertMembershipRows[140] = "'#Session.SiteID#','IN Math & Science Academy - South','south.imsaindy.org','9375','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2701 Bethel Ave','Indianapolis','IN','46203','3177801200','3177800400','','','',''";
			insertMembershipRows[141] = "'#Session.SiteID#','IN Sch for the Blind & Vis Imprd','isbvik12.org','9605','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','7725 N College Ave','Indianapolis','IN','46240','3172531481','3172516511','','','',''";
			insertMembershipRows[142] = "'#Session.SiteID#','IN State Department of Health','isdh.in.gov','9105','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2 N Meridian St','Indianapolis','IN','46204','3172337102','3172337457','','','',''";
			insertMembershipRows[143] = "'#Session.SiteID#','Indiana Connections Academy','connectionseducation.com','9905','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6640 INTECH Blvd Suite 250','Indianapolis','IN','46278','3175503188','3172958022','','','',''";
			insertMembershipRows[144] = "'#Session.SiteID#','Indiana Cyber Charter Sch Inc','indianacyber.org','9765','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','746 US Hwy 30','Schererville','IN','46375','','','','','',''";
			insertMembershipRows[145] = "'#Session.SiteID#','Indiana Math and Science Academy','imsaindy.org','9785','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4575 W 38th St','Indianapolis','IN','46254','3172980025','3172980038','','','',''";
			insertMembershipRows[146] = "'#Session.SiteID#','Indiana Math Science Academy North','north.imsaindy.org','9895','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','7435 N Keystone Ave','Indianapolis','IN','46240','3172597300','3172597363','','','',''";
			insertMembershipRows[147] = "'#Session.SiteID#','Indiana School For The Deaf','isd.k12.in.us','9610','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1200 E 42nd St','Indianapolis','IN','46205','3179248400','3179232853','','','',''";
			insertMembershipRows[148] = "'#Session.SiteID#','Indiana Virtual School','indianavirtual.com','9890','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1111 E 54th St Ste 144','Indianapolis','IN','46220','3175815355','3175815399','','','',''";
			insertMembershipRows[149] = "'#Session.SiteID#','Indianapolis Metropolitan High Sch','goodwilleducation.org','9670','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1635 W Michigan St','Indianapolis','IN','46222','3175244501','3175244002','','','',''";
			insertMembershipRows[150] = "'#Session.SiteID#','Indianapolis Public Schools','ips.k12.in.us','5385','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','120 E Walnut St','Indianapolis','IN','46204','3172264411','3172264936','','','',''";
			insertMembershipRows[151] = "'#Session.SiteID#','Indpls Lighthouse Charter School','lighthouse-academies.org','9575','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1780 Sloan Ave','Indianapolis','IN','46203','3178972430','3178972448','','','',''";
			insertMembershipRows[152] = "'#Session.SiteID#','Inspire Academy - A Sch of Inquiry','','9735','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1600 S Madison St','Muncie','IN','47302','7652167980','7652167798','','','',''";
			insertMembershipRows[153] = "'#Session.SiteID#','Irvington Community School','ics-charter.org','9330','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6705 E Julian Ave','Indianapolis','IN','46219','3173575359','3173579752','','','',''";
			insertMembershipRows[154] = "'#Session.SiteID#','Jac-Cen-Del Community Sch Corp','jaccendel.k12.in.us','6900','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','723 N Buckeye St','Osgood','IN','47037','8126894114','8126897423','','','',''";
			insertMembershipRows[155] = "'#Session.SiteID#','Jay School Corp','jayschools.k12.in.us','3945','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 1239','Portland','IN','47371','2607269341','2607264959','','','',''";
			insertMembershipRows[156] = "'#Session.SiteID#','Jennings County Schools','jcsc.org','4015','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','34 Main St','North Vernon','IN','47265','8123464483','8123464490','','','',''";
			insertMembershipRows[157] = "'#Session.SiteID#','John Glenn School Corporation','jgsc.k12.in.us','7150','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','101 John Glenn Dr','Walkerton','IN','46574','5745863129','5745862660','','','',''";
			insertMembershipRows[158] = "'#Session.SiteID#','Joshua Academy','joshuaacademy.com','9495','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1230 E Illinois St','Evansville','IN','47711','8124016300','8124016307','','','',''";
			insertMembershipRows[159] = "'#Session.SiteID#','Kankakee Valley School Corp','kv.k12.in.us','3785','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 278','Wheatfield','IN','46392','2199874711','2199874710','','','',''";
			insertMembershipRows[160] = "'#Session.SiteID#','KIPP Indpls College Preparatory','kippindy.org','9400','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3202 E 42nd St','Indianapolis','IN','46205','3175475477','3175475499','','','',''";
			insertMembershipRows[161] = "'#Session.SiteID#','Knox Community School Corp','knox.k12.in.us','7525','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2 Redskin Trl','Knox','IN','46534','5747721600','5747721608','','','',''";
			insertMembershipRows[162] = "'#Session.SiteID#','Kokomo School Corporation','kokomo.k12.in.us','3500','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1500 S Washington PO Box 2188','Kokomo','IN','46904','7654558000','7654558018','','','',''";
			insertMembershipRows[163] = "'#Session.SiteID#','Lafayette School Corporation','lsc.k12.in.us','7855','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2300 Cason St','Lafayette','IN','47904','7657716000','7657716049','','','',''";
			insertMembershipRows[164] = "'#Session.SiteID#','Lake Central School Corp','lcscmail.com','4615','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','8260 Wicker Ave','Saint John','IN','46373','2195582707','2193656406','','','',''";
			insertMembershipRows[165] = "'#Session.SiteID#','Lake Ridge Schools','lakeridge.k12.in.us','4650','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6111 W Ridge Rd','Gary','IN','46408','2198381819','2199897801','','','',''";
			insertMembershipRows[166] = "'#Session.SiteID#','Lake Station Community Schools','lakes.k12.in.us','4680','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2500 Pike St','Lake Station','IN','46405','2199621159','2199624011','','','',''";
			insertMembershipRows[167] = "'#Session.SiteID#','Lakeland School Corporation','lakeland.k12.in.us','4535','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','200 S Cherry St','LaGrange','IN','46761','2604992400','2604634800','','','',''";
			insertMembershipRows[168] = "'#Session.SiteID#','Lanesville Community School Corp','lanesville.k12.in.us','3160','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2725 Crestview Ave NE','Lanesville','IN','47136','8129522555','8129523762','','','',''";
			insertMembershipRows[169] = "'#Session.SiteID#','LaPorte Community School Corp','lpcsc.k12.in.us','4945','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1921 \'A\' St','LaPorte','IN','46350','2193627056','2193249347','','','',''";
			insertMembershipRows[170] = "'#Session.SiteID#','Lawrenceburg Com School Corp','lburg.k12.in.us','1620','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','300 Tiger Blvd','Lawrenceburg','IN','47025','8125377201','8125370759','','','',''";
			insertMembershipRows[171] = "'#Session.SiteID#','Lebanon Community School Corp','leb.k12.in.us','0665','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1810 N Grant St','Lebanon','IN','46052','7654820380','7654833053','','','',''";
			insertMembershipRows[172] = "'#Session.SiteID#','Liberty-Perry Com School Corp','libertyperry.org','1895','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','Box 337','Selma','IN','47383','7652825615','7652813733','','','',''";
			insertMembershipRows[173] = "'#Session.SiteID#','Linton-Stockton School Corp','lssc.k12.in.us','2950','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','801 NE 1st St','Linton','IN','47441','8128476020','8128478659','','','',''";
			insertMembershipRows[174] = "'#Session.SiteID#','Logansport Community Sch Corp','lcsc.k12.in.us','0875','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2829 George St','Logansport','IN','46947','5747222911','5747530143','','','',''";
			insertMembershipRows[175] = "'#Session.SiteID#','Loogootee Community Sch Corp','loogootee.k12.in.us','5525','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 282','Loogootee','IN','47553','8122952595','8122955595','','','',''";
			insertMembershipRows[176] = "'#Session.SiteID#','Lutheran Schools of Indiana','in.lcms.org','9230','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1145 S Barr St','Fort Wayne','IN','46802','2604231511','2604231514','','','',''";
			insertMembershipRows[177] = "'#Session.SiteID#','M S D Bluffton-Harrison','bhmsd.k12.in.us','8445','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','805 E Harrison St','Bluffton','IN','46714','2608242620','2608246011','','','',''";
			insertMembershipRows[178] = "'#Session.SiteID#','M S D Boone Township','hebronschools.k12.in.us','6460','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','307 S Main St','Hebron','IN','46341','2199964771','2199965777','','','',''";
			insertMembershipRows[179] = "'#Session.SiteID#','M S D Decatur Township','msddecatur.k12.in.us','5300','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5275 Kentucky Ave','Indianapolis','IN','46221','3178565265','3178562156','','','',''";
			insertMembershipRows[180] = "'#Session.SiteID#','M S D Lawrence Township','msdlt.k12.in.us','5330','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6501 Sunnyside Rd','Indianapolis','IN','46236','3174238200','3175433534','','','',''";
			insertMembershipRows[181] = "'#Session.SiteID#','M S D Martinsville Schools','msdmail.net','5925','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 1416','Martinsville','IN','46151','7653426641','7653426877','','','',''";
			insertMembershipRows[182] = "'#Session.SiteID#','M S D Mount Vernon','mvschool.org','6590','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1000 W 4th St','Mount Vernon','IN','47620','8128384471','8128335179','','','',''";
			insertMembershipRows[183] = "'#Session.SiteID#','M S D North Posey Co Schools','northposey.k12.in.us','6600','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','101 N Church St','Poseyville','IN','47633','8128742243','8128748806','','','',''";
			insertMembershipRows[184] = "'#Session.SiteID#','M S D of New Durham Township','westville.k12.in.us','4860','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','207 E Valparaiso St','Westville','IN','46391','2197852239','2197854584','','','',''";
			insertMembershipRows[185] = "'#Session.SiteID#','M S D Pike Township','pike.k12.in.us','5350','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6901 Zionsville Rd','Indianapolis','IN','46268','3172930393','3172977896','','','',''";
			insertMembershipRows[186] = "'#Session.SiteID#','M S D Shakamak Schools','shakamak.k12.in.us','2960','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','9233 Shakamak School Rd','Jasonville','IN','47438','8126653550','8126655001','','','',''";
			insertMembershipRows[187] = "'#Session.SiteID#','M S D Southwest Allen County Schls','sacs.k12.in.us','0125','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4824 Homestead Rd','Fort Wayne','IN','46814','2604312010','2604312063','','','',''";
			insertMembershipRows[188] = "'#Session.SiteID#','M S D Steuben County','msdsc.org','7615','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','400 S Martha St','Angola','IN','46703','2606652854','2606659155','','','',''";
			insertMembershipRows[189] = "'#Session.SiteID#','M S D Wabash County Schools','msdwc.k12.in.us','8050','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','204 N 300 W','Wabash','IN','46992','2605638050','2605696836','','','',''";
			insertMembershipRows[190] = "'#Session.SiteID#','M S D Warren County','msdwarco.k12.in.us','8115','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','101 N Monroe St','Williamsport','IN','47993','7657623364','7657626623','','','',''";
			insertMembershipRows[191] = "'#Session.SiteID#','M S D Warren Township','warren.k12.in.us','5360','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','975 N Post Rd','Indianapolis','IN','46219','3178694300','3178694348','','','',''";
			insertMembershipRows[192] = "'#Session.SiteID#','M S D Washington Township','msdwt.k12.in.us','5370','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','8550 Woodfield Crossing Blvd','Indianapolis','IN','46240','3178459400','3172053362','','','',''";
			insertMembershipRows[193] = "'#Session.SiteID#','M S D Wayne Township','wayne.k12.in.us','5375','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1220 S High Sch Rd','Indianapolis','IN','46241','3172438251','3172435744','','','',''";
			insertMembershipRows[194] = "'#Session.SiteID#','Maconaquah School Corp','maconaquah.k12.in.us','5615','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','7932 S Strawtown Pk','Bunker Hill','IN','46914','7656899131','7656890995','','','',''";
			insertMembershipRows[195] = "'#Session.SiteID#','Madison Consolidated Schools','madison.k12.in.us','3995','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2421 Wilson Ave','Madison','IN','47250','8122748000','8122748011','','','',''";
			insertMembershipRows[196] = "'#Session.SiteID#','Madison-Grant United Sch Corp','mgargylls.com','2825','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','11580 S/E 00 W','Fairmount','IN','46928','7659484143','7659484150','','','',''";
			insertMembershipRows[197] = "'#Session.SiteID#','Manchester Community Schools','mcs.k12.in.us','8045','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','404 W Ninth St','N Manchester','IN','46962','2609827518','2609824583','','','',''";
			insertMembershipRows[198] = "'#Session.SiteID#','Marion Community Schools','marion.k12.in.us','2865','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1240 S Adams St','Marion','IN','46952','7656622546','7656512043','','','',''";
			insertMembershipRows[199] = "'#Session.SiteID#','Medora Community School Corp','medora.k12.in.us','3640','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 369','Medora','IN','47260','8129662210','8129662217','','','',''";
			insertMembershipRows[200] = "'#Session.SiteID#','Merrillville Community School','mvsc.k12.in.us','4600','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6701 Delaware St','Merrillville','IN','46410','2196505300','2196505320','','','',''";
			insertMembershipRows[201] = "'#Session.SiteID#','Michigan City Area Schools','mcas.k12.in.us','4925','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','408 S Carroll Ave','Michigan City','IN','46360','2198732000','2198732072','','','',''";
			insertMembershipRows[202] = "'#Session.SiteID#','Middlebury Community Schools','mcsin-k12.org','2275','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','56853 Northridge Dr','Middlebury','IN','46540','5748259425','5748259426','','','',''";
			insertMembershipRows[203] = "'#Session.SiteID#','Milan Community Schools','milan.k12.in.us','6910','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','412 E Carr St','Milan','IN','47031','8126542365','8126542441','','','',''";
			insertMembershipRows[204] = "'#Session.SiteID#','Mill Creek Community Sch Corp','mccsc.k12.in.us','3335','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6631 S CR 200 W','Clayton','IN','46118','3175399200','3175399215','','','',''";
			insertMembershipRows[205] = "'#Session.SiteID#','Mississinewa Community School Corp','olemiss.k12.in.us','2855','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','424 E S \'A\' St','Gas City','IN','46933','7656748528','7656748529','','','',''";
			insertMembershipRows[206] = "'#Session.SiteID#','Mitchell Community Schools','mitchell.k12.in.us','5085','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','441 N 8th St','Mitchell','IN','47446','8128494481','8128492133','','','',''";
			insertMembershipRows[207] = "'#Session.SiteID#','Monroe Central School Corp','monroecentral.org','6820','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1918 N CR 1000 W','Parker City','IN','47368','7654686868','7654686578','','','',''";
			insertMembershipRows[208] = "'#Session.SiteID#','Monroe County Com Sch Corp','mccsc.edu','5740','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','315 E North Dr','Bloomington','IN','47401','8123307700','8123302419','','','',''";
			insertMembershipRows[209] = "'#Session.SiteID#','Monroe-Gregg School District','m-gsd.org','5900','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','135 S Chestnut St','Monrovia','IN','46157','3179963720','3179962977','','','',''";
			insertMembershipRows[210] = "'#Session.SiteID#','Monument Lighthouse Charter School','lighthouse-academies.org','9590','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4002 N Franklin Rd','Indianapolis','IN','46226','','3178972448','','','',''";
			insertMembershipRows[211] = "'#Session.SiteID#','Mooresville Con School Corp','mooresvilleschools.org','5930','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','11 W Carlisle St','Mooresville','IN','46158','3178310950','3178319202','','','',''";
			insertMembershipRows[212] = "'#Session.SiteID#','Mt Vernon Community Sch Corp','mvcsc.k12.in.us','3135','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1776 W SR 234','Fortville','IN','46040','3174853100','3174853113','','','',''";
			insertMembershipRows[213] = "'#Session.SiteID#','Muncie Community Schools','muncie.k12.in.us','1970','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2501 N Oakwood Ave','Muncie','IN','47304','7657475205','7657475341','','','',''";
			insertMembershipRows[214] = "'#Session.SiteID#','Neighbors New Vistas High School','neoadulted.org','9730','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5391 Central Ave','Portage','IN','46368','2198504448','2198504445','','','',''";
			insertMembershipRows[215] = "'#Session.SiteID#','Nettle Creek School Corp','nettlecreek.k12.in.us','8305','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','297 E Northmarket St','Hagerstown','IN','47346','7654894543','7654894914','','','',''";
			insertMembershipRows[216] = "'#Session.SiteID#','New Albany-Floyd Co Con Sch','nafcs.k12.in.us','2400','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2813 Grant Line PO Box 1087','New Albany','IN','47150','8129494200','8129496941','','','',''";
			insertMembershipRows[217] = "'#Session.SiteID#','New Castle Community Sch Corp','nccsc.k12.in.us','3445','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','322 Elliott Ave','New Castle','IN','47362','7655217201','7655217268','','','',''";
			insertMembershipRows[218] = "'#Session.SiteID#','New Community School','ncs.k12.in.us','9340','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1904 Elmwood Ave','Lafayette','IN','47904','7654209617','7654209672','','','',''";
			insertMembershipRows[219] = "'#Session.SiteID#','New Prairie United School Corp','npusc.k12.in.us','4805','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5327 N Cougar Rd','New Carlisle','IN','46552','5746547273','5746547274','','','',''";
			insertMembershipRows[220] = "'#Session.SiteID#','Nexus Academy of Indianapolis','connectionseducation.com','9930','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6101 N Keystone Ave Ste 302','Indianapolis','IN','46220','3172525919','3172525917','','','',''";
			insertMembershipRows[221] = "'#Session.SiteID#','Nineveh-Hensley-Jackson United','nhj.k12.in.us','4255','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','802 S Indian Creek Dr','Trafalgar','IN','46181','3178782100','3178785765','','','',''";
			insertMembershipRows[222] = "'#Session.SiteID#','Noblesville Schools','nobl.k12.in.us','3070','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','18025 River Ave','Noblesville','IN','46062','3177733171','3177737845','','','',''";
			insertMembershipRows[223] = "'#Session.SiteID#','North Adams Community Schools','nadams.k12.in.us','0025','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','625 Stadium Dr','Decatur','IN','46733','2607247146','2607244777','','','',''";
			insertMembershipRows[224] = "'#Session.SiteID#','North Central Parke Comm Schl Corp','ncp.k12.in.us','6375','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1497 East SR 47','Marshall','IN','47859','7655972750','7655972755','','','',''";
			insertMembershipRows[225] = "'#Session.SiteID#','North Daviess Com Schools','ndaviess.k12.in.us','1375','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5494 E SR 58','Elnora','IN','47529','8126368000','8126367546','','','',''";
			insertMembershipRows[226] = "'#Session.SiteID#','North Gibson School Corp','ngsc.k12.in.us','2735','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1108 N Embree St','Princeton','IN','47670','8123854851','8123861531','','','',''";
			insertMembershipRows[227] = "'#Session.SiteID#','North Harrison Com School Corp','nhcs.k12.in.us','3180','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1260 Hwy 64 NW','Ramsey','IN','47166','8123472407','8123472870','','','',''";
			insertMembershipRows[228] = "'#Session.SiteID#','North Judson-San Pierre Sch Corp','njsp.k12.in.us','7515','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','801 Campbell Dr','North Judson','IN','46366','5748962155','5748962156','','','',''";
			insertMembershipRows[229] = "'#Session.SiteID#','North Knox School Corp','nknox.k12.in.us','4315','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','11110 N SR 159','Bicknell','IN','47512','8127354434','8123286262','','','',''";
			insertMembershipRows[230] = "'#Session.SiteID#','North Lawrence Com Schools','nlcs.k12.in.us','5075','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 729','Bedford','IN','47421','8122793521','8122751577','','','',''";
			insertMembershipRows[231] = "'#Session.SiteID#','North Miami Community Schools','nmcs.k12.in.us','5620','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 218','Denver','IN','46926','7659853891','7659853904','','','',''";
			insertMembershipRows[232] = "'#Session.SiteID#','North Montgomery Com Sch Corp','nm.k12.in.us','5835','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','480 W 580 N','Crawfordsville','IN','47933','7653592112','7653592111','','','',''";
			insertMembershipRows[233] = "'#Session.SiteID#','North Newton School Corp','nn.k12.in.us','5945','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 8','Morocco','IN','47963','2192852228','2192852708','','','',''";
			insertMembershipRows[234] = "'#Session.SiteID#','North Putnam Community Schools','nputnam.k12.in.us','6715','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 169-300 N Washington','Bainbridge','IN','46105','7655226218','7655223562','','','',''";
			insertMembershipRows[235] = "'#Session.SiteID#','North Spencer County Sch Corp','nspencer.k12.in.us','7385','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 316','Lincoln City','IN','47552','8129372400','8129377187','','','',''";
			insertMembershipRows[236] = "'#Session.SiteID#','North Vermillion Com Sch Corp','nvc.k12.in.us','8010','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5551 N Falcon Dr','Cayuga','IN','47928','7654924033','7654927001','','','',''";
			insertMembershipRows[237] = "'#Session.SiteID#','North West Hendricks Schools','hendricks.k12.in.us','3295','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','Box 70','Lizton','IN','46149','3179944100','3179945963','','','',''";
			insertMembershipRows[238] = "'#Session.SiteID#','North White School Corp','nwhite.k12.in.us','8515','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','402 E Broadway St','Monon','IN','47959','2192536618','2192536488','','','',''";
			insertMembershipRows[239] = "'#Session.SiteID#','Northeast Dubois Co Sch Corp','nedubois.k12.in.us','2040','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5379 E Main St Box 158','Dubois','IN','47527','8126782781','8126784418','','','',''";
			insertMembershipRows[240] = "'#Session.SiteID#','Northeast School Corp','nesc.k12.in.us','7645','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 493','Hymera','IN','47855','8123835761','8123834591','','','',''";
			insertMembershipRows[241] = "'#Session.SiteID#','Northeastern Wayne Schools','nws.k12.in.us','8375','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 406','Fountain City','IN','47341','7658472821','7658475355','','','',''";
			insertMembershipRows[242] = "'#Session.SiteID#','Northern Wells Com Schools','nwcs.k12.in.us','8435','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','312 N Jefferson St','Ossian','IN','46777','2606224125','2606227893','','','',''";
			insertMembershipRows[243] = "'#Session.SiteID#','Northwest Allen County Schools','nacs.k12.in.us','0225','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','13119 Coldwater Rd','Fort Wayne','IN','46845','2606373155','2606378355','','','',''";
			insertMembershipRows[244] = "'#Session.SiteID#','Northwestern Con School Corp','nwshelbyschools.org','7350','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4920 W 600 N','Fairland','IN','46126','3178357461','3178354441','','','',''";
			insertMembershipRows[245] = "'#Session.SiteID#','Northwestern School Corp','nwsc.k12.in.us','3470','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3075 N Washington St','Kokomo','IN','46901','7654523060','7654523065','','','',''";
			insertMembershipRows[246] = "'#Session.SiteID#','Oak Hill United School Corp','ohusc.k12.in.us','5625','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1474 N 800 W 27 PO Box 550','Converse','IN','46919','7653953341','7653953343','','','',''";
			insertMembershipRows[247] = "'#Session.SiteID#','Options Charter Sch - Noblesville','optionsined.org','9640','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','9945 Cumberland Pointe Blvd','Noblesville','IN','46060','3177738659','3177739017','','','',''";
			insertMembershipRows[248] = "'#Session.SiteID#','Options Charter School - Carmel','optionsined.org','9325','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','530 W Carmel Dr','Carmel','IN','46032','3178152098','3178463806','','','',''";
			insertMembershipRows[249] = "'#Session.SiteID#','Oregon-Davis School Corp','od.k12.in.us','7495','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5998 N 750 E','Hamlet','IN','46532','5748672111','5748678191','','','',''";
			insertMembershipRows[250] = "'#Session.SiteID#','Orleans Community Schools','orleans.k12.in.us','6145','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','173 W Marley St','Orleans','IN','47452','8128652688','8128653428','','','',''";
			insertMembershipRows[251] = "'#Session.SiteID#','Padua Academy','archindy.org','9720','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','349 N Warman Ave','Indianapolis','IN','46222','3172361532','3172361401','','','',''";
			insertMembershipRows[252] = "'#Session.SiteID#','Paoli Community School Corp','paoli.k12.in.us','6155','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','501 Elm St - Ofc Supt','Paoli','IN','47454','8127234717','8127235100','','','',''";
			insertMembershipRows[253] = "'#Session.SiteID#','Paramount School Of Excellence Inc','paramountindy.org','9680','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3020 Nowland Ave','Indianapolis','IN','46201','3177756660','3174230569','','','',''";
			insertMembershipRows[254] = "'#Session.SiteID#','Penn-Harris-Madison Sch Corp','phm.k12.in.us','7175','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','55900 Bittersweet Rd','Mishawaka','IN','46545','5742597941','5742589547','','','',''";
			insertMembershipRows[255] = "'#Session.SiteID#','Perry Central Com Schools Corp','pccs.k12.in.us','6325','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','18677 Old SR 37','Leopold','IN','47551','8128435576','8128434746','','','',''";
			insertMembershipRows[256] = "'#Session.SiteID#','Perry Township Schools','msdpt.k12.in.us','5340','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6548 Orinoco Ave','Indianapolis','IN','46227','3177893700','3177804224','','','',''";
			insertMembershipRows[257] = "'#Session.SiteID#','Peru Community Schools','peru.k12.in.us','5635','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','35 W 3rd St','Peru','IN','46970','7654733081','7654725129','','','',''";
			insertMembershipRows[258] = "'#Session.SiteID#','Pike County School Corp','pcsc.k12.in.us','6445','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','907 Walnut St','Petersburg','IN','47567','8123548731','8123548733','','','',''";
			insertMembershipRows[259] = "'#Session.SiteID#','Pioneer Regional School Corp','pioneer.k12.in.us','0775','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 577','Royal Center','IN','46978','5746432605','5746439977','','','',''";
			insertMembershipRows[260] = "'#Session.SiteID#','Plainfield Community Sch Corp','plainfield.k12.in.us','3330','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','985 S Longfellow Dr','Plainfield','IN','46168','3178392578','3178383664','','','',''";
			insertMembershipRows[261] = "'#Session.SiteID#','Plymouth Community School Corp','plymouth.k12.in.us','5485','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','611 Berkley St','Plymouth','IN','46563','5749363115','5749363160','','','',''";
			insertMembershipRows[262] = "'#Session.SiteID#','Portage Township Schools','portage.k12.in.us','6550','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6240 US Hwy 6','Portage','IN','46368','2197626511','2197638009','','','',''";
			insertMembershipRows[263] = "'#Session.SiteID#','Porter Township School Corp','ptsc.k12.in.us','6520','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','248 S 500 W','Valparaiso','IN','46385','2194774933','2194774834','','','',''";
			insertMembershipRows[264] = "'#Session.SiteID#','Prairie Heights Com Sch Corp','ph.k12.in.us','4515','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','0305 S 1150 E','LaGrange','IN','46761','2603513214','2603513614','','','',''";
			insertMembershipRows[265] = "'#Session.SiteID#','Randolph Central School Corp','randolphcentral.us','6825','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','103 N East St','Winchester','IN','47394','7655841401','7655841403','','','',''";
			insertMembershipRows[266] = "'#Session.SiteID#','Randolph Eastern School Corp','resc.k12.in.us','6835','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','907 N Plum St','Union City','IN','47390','7659644994','7659646590','','','',''";
			insertMembershipRows[267] = "'#Session.SiteID#','Randolph Southern School Corp','rssc.k12.in.us','6805','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1 Rebel Dr','Lynn','IN','47355','7658741181','7658741298','','','',''";
			insertMembershipRows[268] = "'#Session.SiteID#','Renaissance Academy Charter School','rschool.net','9690','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4093 W US 20','LaPorte','IN','46350','2198788711','8003116038','','','',''";
			insertMembershipRows[269] = "'#Session.SiteID#','Rensselaer Central School Corp','rcsc.k12.in.us','3815','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','605 Grove St','Rensselaer','IN','47978','2198667822','2198668360','','','',''";
			insertMembershipRows[270] = "'#Session.SiteID#','Richland-Bean Blossom C S C','rbbcsc.k12.in.us','5705','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','600 S Edgewood Dr','Ellettsville','IN','47429','8128767100','8128767020','','','',''";
			insertMembershipRows[271] = "'#Session.SiteID#','Richmond Community Schools','rcs.k12.in.us','8385','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','300 Hub Etchison Pky','Richmond','IN','47374','7659733300','7659733417','','','',''";
			insertMembershipRows[272] = "'#Session.SiteID#','Rising Sun-Ohio Co Com','risingsun.k12.in.us','6080','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','110 S Henrietta St','Rising Sun','IN','47040','8124382655','8124384636','','','',''";
			insertMembershipRows[273] = "'#Session.SiteID#','River Forest Community Sch Corp','rfcsc.k12.in.us','4590','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3250 Michigan St','Hobart','IN','46342','2199622909','2199624951','','','',''";
			insertMembershipRows[274] = "'#Session.SiteID#','Rochester Community Sch Corp','zebras.net','2645','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','690 Zebra Ln Box 108','Rochester','IN','46975','5742232159','5742234909','','','',''";
			insertMembershipRows[275] = "'#Session.SiteID#','Rock Creek Community Academy','rccasi.org','9875','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','11515 Hwy 31','Sellersburg','IN','47172','8122469271','8122460722','','','',''";
			insertMembershipRows[276] = "'#Session.SiteID#','Rossville Con School District','rcsd.k12.in.us','1180','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 11','Rossville','IN','46065','7653792990','7653793014','','','',''";
			insertMembershipRows[277] = "'#Session.SiteID#','Rural Community Schools Inc','','9465','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 85','Graysville','IN','47852','8123824500','8123824055','','','',''";
			insertMembershipRows[278] = "'#Session.SiteID#','Rush County Schools','rushville.k12.in.us','6995','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','330 W 8th St','Rushville','IN','46173','7659324186','7659381608','','','',''";
			insertMembershipRows[279] = "'#Session.SiteID#','Salem Community Schools','salemschools.com','8205','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','500 N Harrison St','Salem','IN','47167','8128834437','8128831031','','','',''";
			insertMembershipRows[280] = "'#Session.SiteID#','School City of East Chicago','ecps.org','4670','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','210 E Columbus Dr','East Chicago','IN','46312','2193914100','2193914126','','','',''";
			insertMembershipRows[281] = "'#Session.SiteID#','School City of Hammond','hammond.k12.in.us','4710','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','41 Williams St','Hammond','IN','46320','2199332400','2199332495','','','',''";
			insertMembershipRows[282] = "'#Session.SiteID#','School City of Hobart','hobart.k12.in.us','4730','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','32 E 7th St','Hobart','IN','46342','2199428885','2199420081','','','',''";
			insertMembershipRows[283] = "'#Session.SiteID#','School City of Mishawaka','mishawaka.k12.in.us','7200','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1402 S Main St','Mishawaka','IN','46544','5742544537','5742544585','','','',''";
			insertMembershipRows[284] = "'#Session.SiteID#','School Town of Highland','highland.k12.in.us','4720','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','9145 Kennedy Ave','Highland','IN','46322','2199225615','2199225671','','','',''";
			insertMembershipRows[285] = "'#Session.SiteID#','School Town of Munster','munster.k12.in.us','4740','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','8616 Columbia Ave','Munster','IN','46321','2198369111','2198363215','','','',''";
			insertMembershipRows[286] = "'#Session.SiteID#','School Town of Speedway','speedwayschools.org','5400','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5335 W 25th St','Speedway','IN','46224','3172440236','3174864843','','','',''";
			insertMembershipRows[287] = "'#Session.SiteID#','Scott County School District 1','scsd1.com','7230','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 9','Austin','IN','47102','8127948750','8127948765','','','',''";
			insertMembershipRows[288] = "'#Session.SiteID#','Scott County School District 2','scsd2.k12.in.us','7255','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','375 E McClain Ave','Scottsburg','IN','47170','8127528946','8127528951','','','',''";
			insertMembershipRows[289] = "'#Session.SiteID#','SE Neighborhood Sch of Excellence','senseindy.org','9485','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1601 S Barth Ave','Indianapolis','IN','46203','3174230204','3176314401','','','',''";
			insertMembershipRows[290] = "'#Session.SiteID#','Seymour Community Schools','scsc.k12.in.us','3675','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1638 S Walnut St','Seymour','IN','47274','8125223340','8125228031','','','',''";
			insertMembershipRows[291] = "'#Session.SiteID#','Shelby Eastern Schools','ses.k12.in.us','7285','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2451 N 600 E','Shelbyville','IN','46176','7655442246','7655442247','','','',''";
			insertMembershipRows[292] = "'#Session.SiteID#','Shelbyville Central Schools','shelbycs.k12.in.us','7365','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','803 St Joseph St','Shelbyville','IN','46176','3173922505','3173925737','','','',''";
			insertMembershipRows[293] = "'#Session.SiteID#','Shenandoah School Corporation','shenandoah.k12.in.us','3435','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5100 N Raider Rd','Middletown','IN','47356','7653542266','7653542274','','','',''";
			insertMembershipRows[294] = "'#Session.SiteID#','Sheridan Community Schools','sheridan.k12.in.us','3055','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','24795 N Hinesley Rd','Sheridan','IN','46069','3177584172','3177586248','','','',''";
			insertMembershipRows[295] = "'#Session.SiteID#','Shoals Community School Corp','shoals.k12.in.us','5520','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','11741 Ironton Rd','Shoals','IN','47581','8122472060','8122472278','','','',''";
			insertMembershipRows[296] = "'#Session.SiteID#','Signature School Inc','signature.edu','9315','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','610 Main St','Evansville','IN','47708','8124211820','8124219189','','','',''";
			insertMembershipRows[297] = "'#Session.SiteID#','Smith Academy for Excellence','fwsafe.com','9760','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6806 Embers Ct','Fort Wayne','IN','46815','2607495832','2607495832','','','',''";
			insertMembershipRows[298] = "'#Session.SiteID#','Smith-Green Community Schools','sgcs.k12.in.us','8625','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','222 W Tulley St','Churubusco','IN','46723','2606932007','2606936434','','','',''";
			insertMembershipRows[299] = "'#Session.SiteID#','South Adams Schools','southadams.k12.in.us','0035','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1075 Starfire Way','Berne','IN','46711','2605893133','2605892065','','','',''";
			insertMembershipRows[300] = "'#Session.SiteID#','South Bend Community Sch Corp','sbcsc.k12.in.us','7205','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','215 S St Joseph St','South Bend','IN','46601','5742838000','5742822266','','','',''";
			insertMembershipRows[301] = "'#Session.SiteID#','South Central Com School Corp','scentral.k12.in.us','4940','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','9808 S 600 W','Union Mills','IN','46382','2197672263','2197672260','','','',''";
			insertMembershipRows[302] = "'#Session.SiteID#','South Dearborn Com School Corp','sdcsc.k12.in.us','1600','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6109 Squire Pl','Aurora','IN','47001','8129262090','8129264216','','','',''";
			insertMembershipRows[303] = "'#Session.SiteID#','South Gibson School Corp','sgibson.k12.in.us','2765','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1029 W 650 S','Fort Branch','IN','47648','8127534230','8127534081','','','',''";
			insertMembershipRows[304] = "'#Session.SiteID#','South Harrison Com Schools','shcsc.k12.in.us','3190','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','315 S Harrison Dr','Corydon','IN','47112','8127382168','8127382158','','','',''";
			insertMembershipRows[305] = "'#Session.SiteID#','South Henry School Corp','shenry.k12.in.us','3415','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6972 S SR 103','Straughn','IN','47387','7659877882','7659877589','','','',''";
			insertMembershipRows[306] = "'#Session.SiteID#','South Knox School Corp','sknox.k12.in.us','4325','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6116 E SR 61','Vincennes','IN','47591','8127264440','8127432110','','','',''";
			insertMembershipRows[307] = "'#Session.SiteID#','South Madison Com Sch Corp','smcsc.com','5255','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','203 S Heritage Way','Pendleton','IN','46064','7657782152','7657788207','','','',''";
			insertMembershipRows[308] = "'#Session.SiteID#','South Montgomery Com Sch Corp','southmont.k12.in.us','5845','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 8','New Market','IN','47965','7658660203','7658660736','','','',''";
			insertMembershipRows[309] = "'#Session.SiteID#','South Newton School Corp','newton.k12.in.us','5995','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','13232 S 50 E','Kentland','IN','47951','2194745184','2194746966','','','',''";
			insertMembershipRows[310] = "'#Session.SiteID#','South Putnam Community Schools','sputnam.k12.in.us','6705','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3999 S US Hwy 231','Greencastle','IN','46135','7656533119','7656537476','','','',''";
			insertMembershipRows[311] = "'#Session.SiteID#','South Ripley Com Sch Corp','sripley.k12.in.us','6865','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 690','Versailles','IN','47042','8126896282','8126896760','','','',''";
			insertMembershipRows[312] = "'#Session.SiteID#','South Spencer County Sch Corp','sspencer.k12.in.us','7445','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 26','Rockport','IN','47635','8126492591','8126494249','','','',''";
			insertMembershipRows[313] = "'#Session.SiteID#','South Vermillion Com Sch Corp','svcs.k12.in.us','8020','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 387','Clinton','IN','47842','7658322426','7658327391','','','',''";
			insertMembershipRows[314] = "'#Session.SiteID#','Southeast Dubois Co Sch Corp','sedubois.k12.in.us','2100','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','432 E 15th St','Ferdinand','IN','47532','8123671653','8123671075','','','',''";
			insertMembershipRows[315] = "'#Session.SiteID#','Southeast Fountain School Corp','sefschools.org','2455','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','744 E US Hwy 136','Veedersburg','IN','47987','7652942254','7652943200','','','',''";
			insertMembershipRows[316] = "'#Session.SiteID#','Southeastern School Corp','sescschools.net','0815','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6422 E SR 218','Walton','IN','46994','5746262525','5746262751','','','',''";
			insertMembershipRows[317] = "'#Session.SiteID#','Southern Hancock Co Com Sch Corp','newpal.k12.in.us','3115','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 508','New Palestine','IN','46163','3178614463','3178612142','','','',''";
			insertMembershipRows[318] = "'#Session.SiteID#','Southern Wells Com Schools','swraiders.com','8425','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','9120 S 300 W','Poneto','IN','46781','7657285537','7657288124','','','',''";
			insertMembershipRows[319] = "'#Session.SiteID#','Southwest Dubois Co Sch Corp','swdubois.k12.in.us','2110','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','113 N Jackson St','Huntingburg','IN','47542','8126833971','8126832752','','','',''";
			insertMembershipRows[320] = "'#Session.SiteID#','Southwest Parke Com Sch Corp','swparke.k12.in.us','6260','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4851 S Coxville Rd','Montezuma','IN','47862','7655692073','7655690309','','','',''";
			insertMembershipRows[321] = "'#Session.SiteID#','Southwest School Corp','swest.k12.in.us','7715','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','110 N Main St','Sullivan','IN','47882','8122686311','8122686312','','','',''";
			insertMembershipRows[322] = "'#Session.SiteID#','Southwestern Con Sch Shelby Co','swshelby.k12.in.us','7360','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3406 W 600 S','Shelbyville','IN','46176','3177295746','3177295330','','','',''";
			insertMembershipRows[323] = "'#Session.SiteID#','Southwestern-Jefferson Co Con','swjcs.us','4000','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','239 S Main Cross St','Hanover','IN','47243','8128666255','8128666256','','','',''";
			insertMembershipRows[324] = "'#Session.SiteID#','Spencer-Owen Community Schools','socs.k12.in.us','6195','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','205 E Hillside','Spencer','IN','47460','8128292233','8128296614','','','',''";
			insertMembershipRows[325] = "'#Session.SiteID#','Springs Valley Com School Corp','svalley.k12.in.us','6160','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','498 S Larry Bird Blvd','French Lick','IN','47432','8129364474','8129369392','','','',''";
			insertMembershipRows[326] = "'#Session.SiteID#','Sunman-Dearborn Com Sch Corp','sunmandearborn.k12.in.us','1560','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1 Trojan Place Ste B','St Leon','IN','47012','8126232291','8126233341','','','',''";
			insertMembershipRows[327] = "'#Session.SiteID#','Switzerland County School Corp','switzerland.k12.in.us','7775','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1040 W Main St','Vevay','IN','47043','8124272611','8124273695','','','',''";
			insertMembershipRows[328] = "'#Session.SiteID#','Taylor Community School Corp','taylor.k12.in.us','3460','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3750 E CR 300 S','Kokomo','IN','46902','7654533035','7654558531','','','',''";
			insertMembershipRows[329] = "'#Session.SiteID#','Tell City-Troy Twp School Corp','tellcity.k12.in.us','6350','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','837 17th St','Tell City','IN','47586','8125473300','8125479704','','','',''";
			insertMembershipRows[330] = "'#Session.SiteID#','The Bloomington Project School','theprojectschool.org','9835','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','349 S Walnut St','Bloomington','IN','47401','8125580041','8123345873','','','',''";
			insertMembershipRows[331] = "'#Session.SiteID#','The Excel Center - Anderson','goodwilleducation.org','9750','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','630 Nichol Ave','Anderson','IN','46016','8889599062','3175244003','','','',''";
			insertMembershipRows[332] = "'#Session.SiteID#','The Excel Center - Kokomo','goodwilleducation.org','9355','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','101 W Superior St','Kokomo','IN','46901','3175244501','3175244002','','','',''";
			insertMembershipRows[333] = "'#Session.SiteID#','The Excel Center - Lafayette','goodwilleducation.org','9345','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','615 N 18th St 2nd Floor','Lafayette','IN','47904','3175244501','3175244002','','','',''";
			insertMembershipRows[334] = "'#Session.SiteID#','The Excel Center - Richmond','goodwilleducation.org','9305','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1635 W Michigan St','Indianapolis','IN','46222','3175244501','3175244002','','','',''";
			insertMembershipRows[335] = "'#Session.SiteID#','The Excel Center-Lafayette Square','goodwilleducation.org','9335','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1635 W Michigan Dr','Indianapolis','IN','46222','3175244501','3175244002','','','',''";
			insertMembershipRows[336] = "'#Session.SiteID#','Thea Bowman Leadership Academy','aqs.org','9460','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','975 W 6th Ave','Gary','IN','46402','2198834826','2198831331','','','',''";
			insertMembershipRows[337] = "'#Session.SiteID#','Thurgood Marshall Leadership Acad','aqs.org','9740','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','910 W Van Buren St Ste 500','Chicago','IL','60607','3122263355','3122261027','','','',''";
			insertMembershipRows[338] = "'#Session.SiteID#','Timothy L Johnson Academy','leonagroup.com','9350','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4615 Werling Dr','Fort Wayne','IN','46806','2604418727','2604419357','','','',''";
			insertMembershipRows[339] = "'#Session.SiteID#','Tindley Collegiate Academy','edpower.org','9940','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3960 Meadows Dr','Indianapolis','IN','46205','3175451745','3175474415','','','',''";
			insertMembershipRows[340] = "'#Session.SiteID#','Tindley Preparatory Academy','edpower.org','9745','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3960 Meadows Dr','Indianapolis','IN','46205','','','','','',''";
			insertMembershipRows[341] = "'#Session.SiteID#','Tindley Renaissance Academy','edpower.org','9945','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3960 Meadows Dr','Indianapolis','IN','46205','3175451745','3175474415','','','',''";
			insertMembershipRows[342] = "'#Session.SiteID#','Tippecanoe School Corp','tsc.k12.in.us','7865','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','21 Elston Rd','Lafayette','IN','47909','7654742481','7654740533','','','',''";
			insertMembershipRows[343] = "'#Session.SiteID#','Tippecanoe Valley School Corp','tvsc.k12.in.us','4445','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','8343 S SR 19','Akron','IN','46910','5743537741','5743537743','','','',''";
			insertMembershipRows[344] = "'#Session.SiteID#','Tipton Community School Corp','tcsc.k12.in.us','7945','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1051 S Main St','Tipton','IN','46072','7656752147','7656753857','','','',''";
			insertMembershipRows[345] = "'#Session.SiteID#','Tri-Central Community Schools','tccs.k12.in.us','7935','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','4774 N 200 W','Sharpsville','IN','46068','7659632585','7659633042','','','',''";
			insertMembershipRows[346] = "'#Session.SiteID#','Tri-County School Corp','trico.k12.in.us','8535','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','105 N 2nd St','Wolcott','IN','47995','2192792418','2192792242','','','',''";
			insertMembershipRows[347] = "'#Session.SiteID#','Tri-Creek School Corporation','tricreek.k12.in.us','4645','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','195 W Oakley Ave','Lowell','IN','46356','2196966661','2196962150','','','',''";
			insertMembershipRows[348] = "'#Session.SiteID#','Triton School Corporation','triton.k12.in.us','5495','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','100 Triton Dr','Bourbon','IN','46504','5743422255','5743428165','','','',''";
			insertMembershipRows[349] = "'#Session.SiteID#','Tri-Township Cons School Corp','lacrosse.k12.in.us','4915','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 249','Wanatah','IN','46390','2197542709','2197542793','','','',''";
			insertMembershipRows[350] = "'#Session.SiteID#','Twin Lakes School Corp','twinlakes.k12.in.us','8565','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','565 S Main St','Monticello','IN','47960','5745837211','5745838963','','','',''";
			insertMembershipRows[351] = "'#Session.SiteID#','Union Co/Clg Corner Joint Sch Dist','uc.k12.in.us','7950','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','107 S Layman St','Liberty','IN','47353','7654587471','7654585647','','','',''";
			insertMembershipRows[352] = "'#Session.SiteID#','Union School Corporation','usc.k12.in.us','6795','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','8707 W US Hwy 36 PO Box 148','Modoc','IN','47358','7658535464','7658535070','','','',''";
			insertMembershipRows[353] = "'#Session.SiteID#','Union Township School Corp','union.k12.in.us','6530','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','599 W 300 N Suite A','Valparaiso','IN','46385','2197592531','2197593250','','','',''";
			insertMembershipRows[354] = "'#Session.SiteID#','Union-North United School Corp','unorth.k12.in.us','7215','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','22601 Tyler Rd','Lakeville','IN','46536','5747848141','5747842181','','','',''";
			insertMembershipRows[355] = "'#Session.SiteID#','University Heights Preparatory Acd','TeamCFAIndy.org','9480','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3919 Madison Ave Ste 100','Indianapolis','IN','46227','3175361028','3174232507','','','',''";
			insertMembershipRows[356] = "'#Session.SiteID#','Valparaiso Community Schools','valpo.k12.in.us','6560','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3801 N Campbell St','Valparaiso','IN','46385','2195313000','2195313009','','','',''";
			insertMembershipRows[357] = "'#Session.SiteID#','Veritas Academy','veritasacademy.us','9360','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','530 E Ireland Rd Bldg B','South Bend','IN','46614','5742873230','5742872643','','','',''";
			insertMembershipRows[358] = "'#Session.SiteID#','Vigo County School Corp','vigoco.k12.in.us','8030','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 3703','Terre Haute','IN','47803','8124624216','8124624115','','','',''";
			insertMembershipRows[359] = "'#Session.SiteID#','Vincennes Community Sch Corp','vcsc.k12.in.us','4335','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1712 S Quail Run Rd','Vincennes','IN','47591','8128824844','8128851427','','','',''";
			insertMembershipRows[360] = "'#Session.SiteID#','Wabash City Schools','apaches.k12.in.us','8060','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1101 Colerain St  PO Box 744','Wabash','IN','46992','2605632151','2605632066','','','',''";
			insertMembershipRows[361] = "'#Session.SiteID#','Wa-Nee Community Schools','wanee.org','2285','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1300 N Main St','Nappanee','IN','46550','5747733131','5747735593','','','',''";
			insertMembershipRows[362] = "'#Session.SiteID#','Warrick County School Corp','warrick.k12.in.us','8130','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 809','Boonville','IN','47601','8128970400','8128976033','','','',''";
			insertMembershipRows[363] = "'#Session.SiteID#','Warsaw Community Schools','warsaw.k12.in.us','4415','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1 Administration Dr','Warsaw','IN','46580','5743715098','5743715046','','','',''";
			insertMembershipRows[364] = "'#Session.SiteID#','Washington Com Schools','wcs.k12.in.us','1405','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','301 E South St','Washington','IN','47501','8122545536','8122548346','','','',''";
			insertMembershipRows[365] = "'#Session.SiteID#','Wawasee Community School Corp','wawasee.k12.in.us','4345','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1 Warrior Path - Bldg 2','Syracuse','IN','46567','5744573188','5744574962','','','',''";
			insertMembershipRows[366] = "'#Session.SiteID#','Wes-Del Community Schools','wes-del.k12.in.us','1885','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','10290 N CR 600 W','Gaston','IN','47342','7653584006','7653584065','','','',''";
			insertMembershipRows[367] = "'#Session.SiteID#','West Central School Corp','wcsc.k12.in.us','6630','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 578','Francesville','IN','47946','2195679161','2195679761','','','',''";
			insertMembershipRows[368] = "'#Session.SiteID#','West Clark Community Schools','wclark.k12.in.us','0940','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','601 Renz Ave','Sellersburg','IN','47172','8122463375','8122469731','','','',''";
			insertMembershipRows[369] = "'#Session.SiteID#','West Lafayette Com School Corp','wl.k12.in.us','7875','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1130 N Salisbury','West Lafayette','IN','47906','7657461602','7657461644','','','',''";
			insertMembershipRows[370] = "'#Session.SiteID#','West Noble School Corporation','westnoble.k12.in.us','6065','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','5050 N US 33','Ligonier','IN','46767','2608943191','2608943260','','','',''";
			insertMembershipRows[371] = "'#Session.SiteID#','West Washington School Corp','wwcs.k12.in.us','8220','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','9699 W Mt Tabor Rd','Campbellsburg','IN','47108','8127554872','8127554843','','','',''";
			insertMembershipRows[372] = "'#Session.SiteID#','Western Boone Co Com Sch Dist','webo.k12.in.us','0615','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1201 N SR 75','Thorntown','IN','46071','7654826333','7654820890','','','',''";
			insertMembershipRows[373] = "'#Session.SiteID#','Western School Corp','western.k12.in.us','3490','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2600 S 600 W','Russiaville','IN','46979','7658835576','7658837946','','','',''";
			insertMembershipRows[374] = "'#Session.SiteID#','Western Wayne Schools','wwayne.k12.in.us','8355','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 217','Pershing','IN','47370','7654785375','7654784577','','','',''";
			insertMembershipRows[375] = "'#Session.SiteID#','Westfield-Washington Schools','wws.k12.in.us','3030','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','322 W Main St','Westfield','IN','46074','3178678000','3178670929','','','',''";
			insertMembershipRows[376] = "'#Session.SiteID#','Westview School Corporation','westview.k12.in.us','4525','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1545 S 600 W','Topeka','IN','46571','2607684404','2607687368','','','',''";
			insertMembershipRows[377] = "'#Session.SiteID#','White River Valley Sch Dist','wrv.k12.in.us','2980','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 1470','Switz City','IN','47465','8126591424','8126592278','','','',''";
			insertMembershipRows[378] = "'#Session.SiteID#','Whiting School City','ns.whiting.k12.in.us','4760','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1500 Center St','Whiting','IN','46394','2196590656','2194734008','','','',''";
			insertMembershipRows[379] = "'#Session.SiteID#','Whitko Community School Corp','whitko.org','4455','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','PO Box 114','Pierceton','IN','46562','5745942658','5745942326','','','',''";
			insertMembershipRows[380] = "'#Session.SiteID#','Whitley Co Cons Schools','wccs.k12.in.us','8665','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','107 N Walnut St','Columbia City','IN','46725','2602445771','2602444099','','','',''";
			insertMembershipRows[381] = "'#Session.SiteID#','Xavier School of Excellence','aqs.org','9845','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','850 W Jackson Blvd Ste 850','Chicago','IN','60607','5742316600','5742316600','','','',''";
			insertMembershipRows[382] = "'#Session.SiteID#','Yorktown Community Schools','yorktown.k12.in.us','1910','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2311 S Broadway St','Yorktown','IN','47396','7657592720','7657597894','','','',''";
			insertMembershipRows[383] = "'#Session.SiteID#','Zionsville Community Schools','zcs.k12.in.us','0630','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','900 Mulberry St','Zionsville','IN','46077','3178732858','3178738003','','','',''";
			insertMembershipRows[384] = "'#Session.SiteID#','Southern Indiana Educational Services Center','ciec.k12.in.us','9991','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1102 Tree Lane Drive','Jasper','IN','47546','81248216641','8124826652','','','',''";
			insertMembershipRows[385] = "'#Session.SiteID#','The Wilson Education Center','wesc.k12.in.us','9992','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','2101 Grace Avenue','Charleston','IN','47111','8125268000','8122568012','','','',''";
			insertMembershipRows[386] = "'#Session.SiteID#','West Central Education Center','wciesc.k12.in.us','9993','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','Post Office Box 21','Greencastle','IN','46135','7656532727','7656537897','','','',''";
			insertMembershipRows[387] = "'#Session.SiteID#','East Central Educational Service Center','ecesc.k12.in.us','9994','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','1601 Indiana Avenue','Connersville','IN','47331','7658251247','7658252532','','','',''";
			insertMembershipRows[388] = "'#Session.SiteID#','Wabash Valley Educational Service Center','esc5.k12.in.us','9995','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','3061 Benton Street','West Lafayette','IN','47906','7654631589','7654631580','','','',''";
			insertMembershipRows[389] = "'#Session.SiteID#','Northwest Indiana Educational Center','nwiesc.k12.in.us','9996','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','48 W. 900 N','Chesterton','IN','46304','2199265555','2199265553','','','',''";
			insertMembershipRows[390] = "'#Session.SiteID#','Northern Indiana Educational Services Center','niesc.k12.in.us','9997','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','56535 Magnetic Drive','Mishawaka','IN','46545','5742540111','5742540148','','','',''";
			insertMembershipRows[391] = "'#Session.SiteID#','Region 8 Education Service Center','r8esc.k12.in.us','9998','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','251 West 850 North','Decatur','IN','46733','2607246200','2607246201','','','',''";
			insertMembershipRows[392] = "'#Session.SiteID#','Central Indiana Educational Services Center','ciesc.k12.in.us','9999','IN',0,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','6036 Lakeside Blvd, Bldg A','Indianapolis','IN','46278','3177595555','3174890328','','','',''";
			insertMembershipRows[393] = "'#Session.SiteID#','School District Not Listed','','0001','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','','','','','','','','','',''";
			insertMembershipRows[394] = "'#Session.SiteID#','Corporate Business','','0000','IN',1,'2013-12-06','B6BA1738-9B59-4084-A3F9C1FBF3EAA61C','2013-12-06','','','','','','','','','',''";

		</cfscript>

		<cfloop array="#inserteFacilityRows#" index="i">
			<cfquery name="insertData" datasource="#Application.configBean.getDatasource()#">
				Insert into eFacility(Site_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, USPS_CarrierRoute, USPS_CheckDigit, USPS_DeliveryPoint, PhysicalLocationCountry, PhysicalCountry, Active, FacilityType)
				values(#i#)
			</cfquery>
		</cfloop>

		<cfloop array="#insertFacilityRoomRows#" index="i">
			<cfquery name="insertData" datasource="#Application.configBean.getDatasource()#">
				Insert into eFacilityRooms(Site_ID, Facility_ID, RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdated, lastUpdateBy)
				values(#i#)
			</cfquery>
		</cfloop>

		<cfloop array="#insertMembershipRows#" index="i">
			<cfquery name="insertData" datasource="#Application.configBean.getDatasource()#">
				Insert into eMembership(Site_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active, dateCreated, lastUpdateBy, lastUpdated, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, Physical_Address, Physical_City, Physical_State, Physical_ZipCode)
				values(#i#)
			</cfquery>
		</cfloop>

		<cfquery name="GetNIESCFacilityID" Datasource="#Application.configBean.getDatasource()#">
			Select TContent_ID
			From eFacility
			Where Site_ID = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="#Session.SiteID#"> and
				FacilityName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="Northern Indiana ESC"> and
				PhysicalAddress = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="56535 Magnetic Dr"> and
				PhysicalState = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="IN"> and
				PhysicalZipCode = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="46545">
		</cfquery>

		<cfquery name="UpdateFacilityRooms" Datasource="#Application.configBean.getDatasource()#">
			Update eFacilityRooms
			Set Facility_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#GetNIESCFacilityID.TContent_ID#">
			Where RoomName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="Conference Room 1"> and
				Capacity = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="30"> and
				Active = <cfqueryparam cfsqltype="CF_SQL_BIT" value="1">
		</cfquery>

		<cfquery name="UpdateFacilityRooms" Datasource="#Application.configBean.getDatasource()#">
			Update eFacilityRooms
			Set Facility_ID = <cfqueryparam cfsqltype="CF_SQL_INTEGER" value="#GetNIESCFacilityID.TContent_ID#">
			Where RoomName = <cfqueryparam cfsqltype="CF_SQL_VARCHAR" value="Conference Room 2"> and
				Capacity = <cfqueryparam cfsqltype="CF_SQL_NUMERIC" value="15"> and
				Active = <cfqueryparam cfsqltype="CF_SQL_BIT" value="1">
		</cfquery>

		<!--- Check to see if Specific JARS are within the directory for the website. If Not, we need to copy them into the directory --->
		<cfset CurLoc = #ExpandPath("/")#>
		<cfset DestFileLoc = #Variables.CurLoc# & "WEB-INF/railo/lib/">
		<cfset OrigFileLoc = #Variables.CurLoc# & "plugins/EventRegistration/library/jars/">
		<cfset itextFile1Dest = #Variables.DestFileLoc# & "itextpdf-5.3.3.jar">
		<cfset itextFile1Orig = #Variables.OrigFileLoc# & "itextpdf-5.3.3.jar">

		<cfset itextFile2Dest = #Variables.DestFileLoc# & "itext-xtra-5.3.3.jar">
		<cfset itextFile2Orig = #Variables.OrigFileLoc# & "itext-xtra-5.3.3.jar">

		<cfset itextFile3Dest = #Variables.DestFileLoc# & "itext-pdfa-5.3.3.jar">
		<cfset itextFile3Orig = #Variables.OrigFileLoc# & "itext-pdfa-5.3.3.jar">

		<cfif not FileExists(Variables.itextFile1Dest)>
			<cffile action="copy" source="#Variables.itextFile1Orig#" destination="#Variables.itextFile1Dest#">
		</cfif>

		<cfif not FileExists(Variables.itextFile2Dest)>
			<cffile action="copy" source="#Variables.itextFile2Orig#" destination="#Variables.itextFile2Dest#">
		</cfif>

		<cfif not FileExists(Variables.itextFile3Dest)>
			<cffile action="copy" source="#Variables.itextFile3Orig#" destination="#Variables.itextFile3Dest#">
		</cfif>

		<!--- Initiates the User Bean --->
		<!--- Creates the Group Presenter --->
		<cfset NewGroupPresenter = #Application.userManager.read("")#>
		<cfset NewGroupPresenter.setSiteID(Session.SiteID)>
		<cfset NewGroupPresenter.setGroupName("Presenter")>
		<cfset NewGroupPresenter.setType(1)>
		<cfset NewGroupPresenter.setIsPublic(1)>
		<cfset NewGroupPresneter=#Application.userManager.create(NewGroupPresenter)#>

		<!--- Creates the Group Presenter --->
		<cfset NewGroupFacilitator = #Application.userManager.read("")#>
		<cfset NewGroupFacilitator.setSiteID(Session.SiteID)>
		<cfset NewGroupFacilitator.setGroupName("Event Facilitator")>
		<cfset NewGroupFacilitator.setType(1)>
		<cfset NewGroupFacilitator.setIsPublic(1)>
		<cfset NewGroupFacilitator=#Application.userManager.create(NewGroupFacilitator)#>

	</cffunction>

	<cffunction name="update" output="false" returntype="any">
		<cfset application.appInitialized = false>
	</cffunction>

	<cffunction name="delete" output="false" returntype="any">
		<cfset application.appInitialized = false>
		<cfscript>
			var dbDropTableRegistrations = new query();
			dbDropTableRegistrations.setDatasource("#application.configBean.getDatasource()#");
			dbDropTableRegistrations.setSQL("DROP TABLE eRegistrations");
			var dbDropTableRegistrationsResult = dbDropTableRegistrations.execute();

			if (len(dbDropTableRegistrationsResult.getResult()) neq 0) {
				writedump(dbDropTableRegistrationsResult.getResult());
				abort;
			}

			var dbDropTableEvents = new query();
			dbDropTableEvents.setDatasource("#application.configBean.getDatasource()#");
			dbDropTableEvents.setSQL("DROP TABLE eEvents");
			var dbDropTableEventsResult = dbDropTableEvents.execute();

			if (len(dbDropTableEventsResult.getResult()) neq 0) {
				writedump(dbDropTableEventsResult.getResult());
				abort;
			}

			var dbDropTableFacility = new query();
			dbDropTableFacility.setDatasource("#application.configBean.getDatasource()#");
			dbDropTableFacility.setSQL("DROP TABLE eFacility");
			var dbDropTableFacilityResult = dbDropTableFacility.execute();

			if (len(dbDropTableFacilityResult.getResult()) neq 0) {
				writedump(dbDropTableFacilityResult.getResult());
				abort;
			}

			var dbDropTableFacilityRoom = new query();
			dbDropTableFacilityRoom.setDatasource("#application.configBean.getDatasource()#");
			dbDropTableFacilityRoom.setSQL("DROP TABLE eFacilityRooms");
			var dbDropTableFacilityRoomResult = dbDropTableFacilityRoom.execute();

			if (len(dbDropTableFacilityRoomResult.getResult()) neq 0) {
				writedump(dbDropTableFacilityRoomResult.getResult());
				abort;
			}

			var dbDropTableCaterers = new query();
			dbDropTableCaterers.setDatasource("#application.configBean.getDatasource()#");
			dbDropTableCaterers.setSQL("DROP TABLE eCaterers");
			var dbDropTableCaterersResult = dbDropTableCaterers.execute();

			if (len(dbDropTableCaterersResult.getResult()) neq 0) {
				writedump(dbDropTableCaterersResult.getResult());
				abort;
			}

			var dbDropTableMembership = new query();
			dbDropTableMembership.setDatasource("#application.configBean.getDatasource()#");
			dbDropTableMembership.setSQL("DROP TABLE eMembership");
			var dbDropTableMembershipResult = dbDropTableMembership.execute();

			if (len(dbDropTableMembershipResult.getResult()) neq 0) {
				writedump(dbDropTableMembershipResult.getResult());
				abort;
			}

			var dbDropTableUserMatrix = new query();
			dbDropTableUserMatrix.setDatasource("#application.configBean.getDatasource()#");
			dbDropTableUserMatrix.setSQL("DROP TABLE eUserMatrix");
			var dbDropTableUserMatrixResult = dbDropTableUserMatrix.execute();

			if (len(dbDropTableUserMatrixResult.getResult()) neq 0) {
				writedump(dbDropTableUserMatrixResult.getResult());
				abort;
			}
		</cfscript>
	</cffunction>

</cfcomponent>