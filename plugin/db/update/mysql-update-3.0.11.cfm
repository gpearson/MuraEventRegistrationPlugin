<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'PGPCertificatesGenerated'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Events` Add COLUMN `PGPCertificatesGenerated` BIT(1) NOT NULL DEFAULT b'0' after `EventInvoicesGenerated`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Facility Like 'Physical_TimeZone'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Facility` Add COLUMN `Physical_TimeZone` TINYTEXT NOT NULL after `FacilityType`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Facility Like 'Physical_UTCOffset'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Facility` Add COLUMN `Physical_UTCOffset` CHAR(4) NOT NULL after `Physical_TimeZone`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Facility Like 'Physical_DST'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Facility` Add COLUMN `Physical_DST` BIT(1) NOT NULL DEFAULT b'0' after `Physical_UTCOffset`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'BillForNoShow'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Events` Add COLUMN `BillForNoShow` BIT(1) NOT NULL DEFAULT b'0' after `EventHasDailySessions`
	</cfquery>
</cfif>

<cfquery name="ShowMembershipBuildingsTables" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'p_EventRegistration_MembershipBuildings'
</cfquery>

<cfif ShowMembershipBuildingsTables.RecordCount EQ 0>
	<cfquery name="Create-p_EventRegistration_MembershipBuildings" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		CREATE TABLE `p_EventRegistration_MembershipBuildings` (`TContent_ID` INT(11) NOT NULL AUTO_INCREMENT, `Site_ID` TINYTEXT NOT NULL, `MembershipDistrict_ID` INT(11) NOT NULL, `OrganizationName` VARCHAR(50) NOT NULL, `StateDOE_IDNumber` VARCHAR(10) NULL DEFAULT NULL, `StateDOE_State` TINYTEXT NULL, `Active` BIT(1) NOT NULL DEFAULT b'0', `dateCreated` DATETIME NOT NULL, `lastUpdateBy` VARCHAR(35) NOT NULL, `lastUpdated` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, `Mailing_Address` TINYTEXT NULL, `Mailing_City` TINYTEXT NULL, `Mailing_State` TINYTEXT NULL, `Mailing_ZipCode` TINYTEXT NULL, `Mailing_ZipPlus4` CHAR(4) NULL DEFAULT NULL, `Mailing_DeliveryPointBarcode` CHAR(12) NULL DEFAULT NULL, `Primary_PhoneNumber` TINYTEXT NULL, `Primary_FaxNumber` TINYTEXT NULL, `Physical_Address` TINYTEXT NULL, `Physical_City` TINYTEXT NULL, `Physical_State` TINYTEXT NULL, `Physical_ZipCode` TINYTEXT NULL, `Physical_ZipPlus4` CHAR(4) NULL DEFAULT NULL, `Physical_DeliveryPointBarcode` CHAR(12) NULL DEFAULT NULL, `Physical_Latitude` DECIMAL(10,5) NULL DEFAULT NULL, `Physical_Longitude` DECIMAL(10,5) NULL DEFAULT NULL, `Physical_TimeZone` TINYTEXT NULL, `Physical_DST` BIT(1) NULL DEFAULT NULL, `Physical_UTCOffset` CHAR(3) NULL DEFAULT NULL, `Physical_CountyName` TINYTEXT NULL, `Physical_CarrierRoute` TINYTEXT NULL, `Physical_CongressionalDistrict` TINYTEXT NULL, PRIMARY KEY (`TContent_ID`, `MembershipDistrict_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
	</cfquery>
</cfif>

<cfquery name="ShowSHortURLTable" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'p_EventRegistration_ShortURL'
</cfquery>

<cfif ShowSHortURLTable.RecordCount EQ 0>
	<cfquery name="Create-p_EventRegistration_ShortURL" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		CREATE TABLE `p_EventRegistration_ShortURL` (`TContent_ID` INT(10) NOT NULL AUTO_INCREMENT, `Site_ID` VARCHAR(20) NOT NULL DEFAULT '', `FullLink` LONGTEXT NULL, `ShortLink` TINYTEXT NULL, `Active` BIT(1) NOT NULL DEFAULT b'0', `dateCreated` DATETIME NULL DEFAULT NULL, `lastUpdateBy` VARCHAR(35) NULL DEFAULT NULL, `lastUpdated` DATETIME NULL DEFAULT NULL, PRIMARY KEY (`TContent_ID`, `Site_ID`) ) COLLATE='latin1_swedish_ci' ENGINE=InnoDB AUTO_INCREMENT=1;
	</cfquery>
</cfif>