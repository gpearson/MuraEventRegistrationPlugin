<cfquery name="ShowOldTable-eCaterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eCaterers'
</cfquery>
<cfif ShowOldTable-eCaterers.RecordCount>
	<cfquery name="AlterTable-eCaterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eCaterers RENAME p_EventRegistration_Caterers
	</cfquery>
	<cfquery name="ModifyTable-eCaterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Caterers MODIFY COLUMN dateCreated datetime DEFAULT NULL
	</cfquery>
	<cfquery name="ModifyTable-eCaterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Caterers MODIFY COLUMN lastUpdated timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP
	</cfquery>
</cfif>

<cfquery name="ShowOldTable-eEventExpenseList" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eEvent_ExpenseList'
</cfquery>
<cfif ShowOldTable-eEventExpenseList.RecordCount>
	<cfquery name="AlterTable-eEventExpenseList" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eEvent_ExpenseList RENAME p_EventRegistration_ExpenseList
	</cfquery>
</cfif>

<cfquery name="ShowOldTable-eFacilityRooms" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eFacilityRooms'
</cfquery>
<cfif ShowOldTable-eFacilityRooms.RecordCount>
	<cfquery name="AlterTable-eFacilityRooms" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eFacilityRooms RENAME p_EventRegistration_FacilityRooms
	</cfquery>
</cfif>

<cfquery name="ShowOldTable-eFacility" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eFacility'
</cfquery>
<cfif ShowOldTable-eFacility.RecordCount>
	<cfquery name="AlterTable-eFacility" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eFacility RENAME p_EventRegistration_Facility
	</cfquery>
</cfif>

<cfquery name="ShowOldTable-eUserMatrix" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eUserMatrix'
</cfquery>
<cfif ShowOldTable-eUserMatrix.RecordCount>
	<cfquery name="AlterTable-eUserMatrix" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eUserMatrix RENAME p_EventRegistration_UserMatrix
	</cfquery>
</cfif>

<cfquery name="ShowOldTable-eMembership" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eMembership'
</cfquery>
<cfif ShowOldTable-eMembership.RecordCount>
	<cfquery name="AlterTable-eMembership" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eMembership RENAME p_EventRegistration_Membership
	</cfquery>
	<cfquery name="AlterTable-eMembershipAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Membership Add COLUMN ReceiveInvoicesByEmail Bit(1) NOT NULL DEFAULT B'0' AFTER AccountsPayable_ContactName
	</cfquery>
</cfif>

<cfquery name="ShowOldTable-SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'p_EventRegistration_SiteConfig'
</cfquery>
<cfif ShowOldTable-SiteConfig.RecordCount EQ 0>
	<cfquery name="Create-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		CREATE TABLE `p_EventRegistration_SiteConfig` (
			`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `DateCreated` datetime NOT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL,
			`ProcessPayments_Stripe` bit(1) NOT NULL DEFAULT b'0', `Stripe_TestMode` bit(1) NOT NULL DEFAULT b'1', `Stripe_TestAPIKey` tinytext, `Stripe_LiveAPIKey` tinytext, `Facbook_AppID` tinytext,
			`Facebook_AppSecretKey` tinytext, `Facebook_PageID` tinytext, `Facebook_AppScope` tinytext, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
	</cfquery>
</cfif>


<cfquery name="ShowOldTable-eEvents" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eEvents'
</cfquery>
<cfif ShowOldTable-eEvents.RecordCount>
	<cfquery name="AlterTable-eEvents" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eEvents RENAME p_EventRegistration_Events
	</cfquery>
	<cfquery name="CheckTableField-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'LocationType'
	</cfquery>
	<cfif CheckTableField-LocationType.RecordCount>
		<cfquery name="DropTable-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN LocationType
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileTypeOne" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeOne'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileTypeOne.RecordCount>
		<cfquery name="DropTable-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeOne
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileTypeTwo" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeTwo'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileTypeTwo.RecordCount>
		<cfquery name="DropTable-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeTwo
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileTypeThree" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeThree'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileTypeThree.RecordCount>
		<cfquery name="DropTable-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeThree
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileTypeFour" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeFour'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileTypeFour.RecordCount>
		<cfquery name="DropTable-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeFour
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileTypeFive" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeFive'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileTypeFive.RecordCount>
		<cfquery name="DropTable-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeFive
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileTypeSix" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeSix'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileTypeSix.RecordCount>
		<cfquery name="DropTable-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeSix
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileTypeSeven" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeSeven'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileTypeSeven.RecordCount>
		<cfquery name="DropTable-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeSeven
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileTypeEight" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeEight'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileTypeEight.RecordCount>
		<cfquery name="DropTable-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeEight
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileTypeNine" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeNine'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileTypeNine.RecordCount>
		<cfquery name="DropTable-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeNine
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileTypeTen" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeTen'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileTypeTen.RecordCount>
		<cfquery name="DropTable-LocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeTen
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileNameOne" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameOne'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileNameOne.RecordCount>
		<cfquery name="DropTable-LocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameOne
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileNameTwo" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameTwo'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileNameTwo.RecordCount>
		<cfquery name="DropTable-LocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameTwo
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileNameThree" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameThree'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileNameThree.RecordCount>
		<cfquery name="DropTable-LocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameThree
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileNameFour" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameFour'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileNameFour.RecordCount>
		<cfquery name="DropTable-LocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameFour
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileNameFive" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameFive'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileNameFive.RecordCount>
		<cfquery name="DropTable-LocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameFive
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileNameSix" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameSix'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileNameSix.RecordCount>
		<cfquery name="DropTable-LocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameSix
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileNameSeven" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameSeven'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileNameSeven.RecordCount>
		<cfquery name="DropTable-LocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameSeven
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileNameEight" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameEight'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileNameEight.RecordCount>
		<cfquery name="DropTable-LocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameEight
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileNameNine" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameNine'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileNameNine.RecordCount>
		<cfquery name="DropTable-LocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameNine
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField-EventDoc_FileNameTen" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameTen'
	</cfquery>
	<cfif CheckTableField-EventDoc_FileNameTen.RecordCount>
		<cfquery name="DropTable-LocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameTen
		</cfquery>
	</cfif>
</cfif>

<cfquery name="ShowOldTable-eRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eRegistrations'
</cfquery>
<cfif ShowOldTable-eRegistrations.RecordCount>
	<cfquery name="AlterTable-eRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eRegistrations RENAME p_EventRegistration_UserRegistrations
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations CHANGE COLUMN AttendedEvent AttendedEventDate1 Bit(1) NOT NULL DEFAULT B'0'
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventDate2 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate1
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ZALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventDate3 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate2
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventDate4 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate3
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventDate5 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate4
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventDate6 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate5
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventSessionAM Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate6
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventSessionPM Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventSessionAM
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate1 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventSessionPM
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate2 Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate1
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate3 Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate2
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate4 Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate3
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate5 Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate4
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate6 Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate5
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventSessionAM Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate6
	</cfquery>
	<cfquery name="AlterTable-eRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventSessionPM Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForSessionAM
	</cfquery>
</cfif>

<cfquery name="CheckGroup-EventFacilitator" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Select UserID, GroupName
	From tusers
	Where GroupName LIKE '%Event Facilitator%'
</cfquery>
<cfif CheckGroup-EventFacilitator.RecordCount EQ 0>
	<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Facilitator");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
	</cfscript>
</cfif>

<cfquery name="CheckGroup-EventPresenter" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Select UserID, GroupName
	From tusers
	Where GroupName LIKE '%Event Presenter%'
</cfquery>
<cfif CheckGroup-EventFacilitator.RecordCount EQ 0>
	<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Presenter");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
	</cfscript>
</cfif>