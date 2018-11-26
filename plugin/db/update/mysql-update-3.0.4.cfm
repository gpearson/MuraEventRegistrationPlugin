<cfquery name="ShowOldTableeCaterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eCaterers'
</cfquery>
<cfif ShowOldTableeCaterers.RecordCount>
	<cfquery name="AlterTableeCaterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eCaterers RENAME p_EventRegistration_Caterers
	</cfquery>
	<cfquery name="ModifyTableeCaterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Caterers MODIFY COLUMN dateCreated datetime DEFAULT NULL
	</cfquery>
	<cfquery name="ModifyTableeCaterers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Caterers MODIFY COLUMN lastUpdated timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' ON UPDATE CURRENT_TIMESTAMP
	</cfquery>
</cfif>
<cfquery name="ShowOldTableeEventExpenseList" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eEvent_ExpenseList'
</cfquery>
<cfif ShowOldTableeEventExpenseList.RecordCount>
	<cfquery name="AlterTableeEventExpenseList" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eEvent_ExpenseList RENAME p_EventRegistration_ExpenseList
	</cfquery>
</cfif>
<cfquery name="ShowOldTableeEventExpenses" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eEvent_Expenses'
</cfquery>
<cfif ShowOldTableeEventExpenses.RecordCount>
	<cfquery name="AlterTableeEventExpenses" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eEvent_Expenses RENAME p_EventRegistration_EventExpenses
	</cfquery>
</cfif>
<cfquery name="ShowOldTableeFacilityRooms" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eFacilityRooms'
</cfquery>
<cfif ShowOldTableeFacilityRooms.RecordCount>
	<cfquery name="AlterTableeFacilityRooms" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eFacilityRooms RENAME p_EventRegistration_FacilityRooms
	</cfquery>
</cfif>

<cfquery name="ShowOldTableeFacility" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eFacility'
</cfquery>
<cfif ShowOldTableeFacility.RecordCount>
	<cfquery name="AlterTableeFacility" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eFacility RENAME p_EventRegistration_Facility
	</cfquery>
</cfif>

<cfquery name="ShowOldTableeUserMatrix" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eUserMatrix'
</cfquery>
<cfif ShowOldTableeUserMatrix.RecordCount>
	<cfquery name="AlterTableeUserMatrix" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eUserMatrix RENAME p_EventRegistration_UserMatrix
	</cfquery>
</cfif>

<cfquery name="ShowOldTableeMembership" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eMembership'
</cfquery>
<cfif ShowOldTableeMembership.RecordCount>
	<cfquery name="AlterTableeMembership" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eMembership RENAME p_EventRegistration_Membership
	</cfquery>
	<cfquery name="AlterTableeMembershipAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Membership Add COLUMN ReceiveInvoicesByEmail Bit(1) NOT NULL DEFAULT B'0' AFTER AccountsPayable_ContactName
	</cfquery>
</cfif>

<cfquery name="ShowOldTableSiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'p_EventRegistration_SiteConfig'
</cfquery>
<cfif ShowOldTableSiteConfig.RecordCount EQ 0>
	<cfquery name="Createp_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		CREATE TABLE `p_EventRegistration_SiteConfig` (
			`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `DateCreated` datetime NOT NULL, `lastUpdateBy` varchar(35) NOT NULL, `lastUpdated` datetime NOT NULL,
			`ProcessPayments_Stripe` bit(1) NOT NULL DEFAULT b'0', `Stripe_TestMode` bit(1) NOT NULL DEFAULT b'1', `Stripe_TestAPIKey` tinytext, `Stripe_LiveAPIKey` tinytext, `Facbook_AppID` tinytext,
			`Facebook_AppSecretKey` tinytext, `Facebook_PageID` tinytext, `Facebook_AppScope` tinytext, `Google_ReCaptchaSiteKey` tinytext, `Google_ReCaptchaSecretKey` tinytext,
			PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
	</cfquery>
</cfif>


<cfquery name="ShowOldTableeEvents" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eEvents'
</cfquery>
<cfif ShowOldTableeEvents.RecordCount>
	<cfquery name="AlterTableeEvents" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eEvents RENAME p_EventRegistration_Events
	</cfquery>
	<cfquery name="CheckTableFieldLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'LocationType'
	</cfquery>
	<cfif CheckTableFieldLocationType.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN LocationType
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileTypeOne" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeOne'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileTypeOne.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeOne
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileTypeTwo" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeTwo'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileTypeTwo.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeTwo
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileTypeThree" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeThree'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileTypeThree.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeThree
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileTypeFour" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeFour'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileTypeFour.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeFour
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileTypeFive" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeFive'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileTypeFive.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeFive
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileTypeSix" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeSix'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileTypeSix.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeSix
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileTypeSeven" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeSeven'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileTypeSeven.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeSeven
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileTypeEight" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeEight'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileTypeEight.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeEight
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileTypeNine" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeNine'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileTypeNine.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeNine
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileTypeTen" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileTypeTen'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileTypeTen.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileTypeTen
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileNameOne" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameOne'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileNameOne.RecordCount>
		<cfquery name="DropTableLocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameOne
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileNameTwo" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameTwo'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileNameTwo.RecordCount>
		<cfquery name="DropTableLocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameTwo
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileNameThree" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameThree'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileNameThree.RecordCount>
		<cfquery name="DropTableLocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameThree
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileNameFour" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameFour'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileNameFour.RecordCount>
		<cfquery name="DropTableLocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameFour
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileNameFive" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameFive'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileNameFive.RecordCount>
		<cfquery name="DropTableLocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameFive
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileNameSix" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameSix'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileNameSix.RecordCount>
		<cfquery name="DropTableLocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameSix
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileNameSeven" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameSeven'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileNameSeven.RecordCount>
		<cfquery name="DropTableLocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameSeven
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileNameEight" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameEight'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileNameEight.RecordCount>
		<cfquery name="DropTableLocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameEight
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileNameNine" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameNine'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileNameNine.RecordCount>
		<cfquery name="DropTableLocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameNine
		</cfquery>
	</cfif>
	<cfquery name="CheckTableFieldEventDoc_FileNameTen" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'EventDoc_FileNameTen'
	</cfquery>
	<cfif CheckTableFieldEventDoc_FileNameTen.RecordCount>
		<cfquery name="DropTableLocationName" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events DROP COLUMN EventDoc_FileNameTen
		</cfquery>
	</cfif>
	<cfquery name="ChangeTableSpecialPriceAvailableToGroupPriceAvailable" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events CHANGE `ViewSpecialPricing` `ViewGroupPricing` Bit(1) NOT NULL DEFAULT B'0'
	</cfquery>
	<cfquery name="ChangeTableSpecialPriceMemberCostToGroupPriceMemberCost" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events CHANGE `SpecialMemberCost` `GroupMemberCost` decimal(6,2) DEFAULT NULL
	</cfquery>
	<cfquery name="ChangeTableSpecialPriceNonMemberCostToGroupPriceNonMemberCost" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events CHANGE `SpecialNonMemberCost` `GroupNonMemberCost` decimal(6,2) DEFAULT NULL
	</cfquery>
	<cfquery name="ChangeTableSpecialPriceRequirementsToGroupPriceRequirements" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events CHANGE `SpecialPriceRequirements` `GroupPriceRequirements` longtext DEFAULT NULL
	</cfquery>
<cfelse>
	<cfquery name="CheckTableField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'ViewSpecialPricing'
	</cfquery>
	<cfif CheckTableField.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events CHANGE `ViewSpecialPricing` `ViewGroupPricing` Bit(1) NOT NULL DEFAULT B'0'
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField1" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'SpecialMemberCost'
	</cfquery>
	<cfif CheckTableField1.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events CHANGE `SpecialMemberCost` `GroupMemberCost` decimal(6,2) DEFAULT NULL
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField2" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'SpecialNonMemberCost'
	</cfquery>
	<cfif CheckTableField2.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events CHANGE `SpecialNonMemberCost` `GroupNonMemberCost` decimal(6,2) DEFAULT NULL
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField3" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'SpecialPriceRequirements'
	</cfquery>
	<cfif CheckTableField3.RecordCount>
		<cfquery name="DropTableLocationType" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_Events CHANGE `SpecialPriceRequirements` `GroupPriceRequirements` longtext DEFAULT NULL
		</cfquery>
	</cfif>
</cfif>

<cfquery name="ShowOldTableeRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'eRegistrations'
</cfquery>
<cfif ShowOldTableeRegistrations.RecordCount>
	<cfquery name="AlterTableeRegistrations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE eRegistrations RENAME p_EventRegistration_UserRegistrations
	</cfquery>
	<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations CHANGE `AttendedEvent` `AttendedEventDate1` Bit(1) NOT NULL DEFAULT B'0'
	</cfquery>
	<cfquery name="CheckTableField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'AttendedEventDate2'
	</cfquery>
	<cfif CheckTableField.RecordCount>
		<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventDate2 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate1
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'AttendedEventDate3'
	</cfquery>
	<cfif CheckTableField.RecordCount>
		<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventDate3 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate2
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'AttendedEventDate4'
	</cfquery>
	<cfif CheckTableField.RecordCount>
		<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventDate4 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate3
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'AttendedEventDate5'
	</cfquery>
	<cfif CheckTableField.RecordCount>
		<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventDate5 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate4
		</cfquery>
	</cfif>
	<cfquery name="CheckTableField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		SHOW COLUMNS FROM p_EventRegistration_Events LIKE 'AttendedEventDate6'
	</cfquery>
	<cfif CheckTableField.RecordCount>
		<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
			ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventDate6 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate5
		</cfquery>
	</cfif>
	<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventSessionAM Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventDate6
	</cfquery>
	<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN AttendedEventSessionPM Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventSessionAM
	</cfquery>
	<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate1 Bit(1) NOT NULL DEFAULT B'0' AFTER AttendedEventSessionPM
	</cfquery>
	<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate2 Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate1
	</cfquery>
	<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate3 Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate2
	</cfquery>
	<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate4 Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate3
	</cfquery>
	<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate5 Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate4
	</cfquery>
	<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventDate6 Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate5
	</cfquery>
	<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventSessionAM Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventDate6
	</cfquery>
	<cfquery name="AlterTableeRegistrationsAddField" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserRegistrations Add COLUMN RegisterForEventSessionPM Bit(1) NOT NULL DEFAULT B'0' AFTER RegisterForEventSessionAM
	</cfquery>
</cfif>

<cfquery name="CheckGroupEventFacilitator" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Select UserID, GroupName
	From tusers
	Where GroupName LIKE '%Event Facilitator%'
</cfquery>
<cfif CheckGroupEventFacilitator.RecordCount EQ 0>
	<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Facilitator");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
	</cfscript>
</cfif>

<cfquery name="CheckGroupEventPresenter" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Select UserID, GroupName
	From tusers
	Where GroupName LIKE '%Event Presenter%'
</cfquery>
<cfif CheckGroupEventFacilitator.RecordCount EQ 0>
	<cfscript>
		var NewGroupEventFacilitator = #application.userManager.read("")#;
		NewGroupEventFacilitator.setSiteID(Session.SiteID);
		NewGroupEventFacilitator.setGroupName("Event Presenter");
		NewGroupEventFacilitator.setType(1);
		NewGroupEventFacilitator.setIsPublic(1);
		NewGroupEventFacilitatorStatus = #Application.userManager.create(NewGroupEventFacilitator)#;
	</cfscript>
</cfif>