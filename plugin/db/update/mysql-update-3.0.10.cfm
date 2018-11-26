<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_SiteConfig Like 'Facebook_Enabled'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_SiteConfig` Add COLUMN `Facebook_Enabled` BIT(1) NOT NULL DEFAULT b'0' after `Stripe_LiveAPIKey`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_SiteConfig Like 'SmartyStreets_Enabled'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_SiteConfig` Add COLUMN `SmartyStreets_Enabled` BIT(1) NOT NULL DEFAULT B'0' after `Google_ReCaptchaSecretKey`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_SiteConfig Like 'SmartyStreets_APIID'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_SiteConfig` Add COLUMN `SmartyStreets_APIID` TINYTEXT NULL after `SmartyStreets_Enabled`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_SiteConfig Like 'SmartyStreets_APIToken'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_SiteConfig` Add COLUMN `SmartyStreets_APIToken` TINYTEXT NULL after `SmartyStreets_APIID`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Mailing_ZipPlus4'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Mailing_ZipPlus4` CHAR(4) NULL DEFAULT NULL after `Mailing_ZipCode`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Mailing_DeliveryPointBarcode'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Mailing_DeliveryPointBarcode` CHAR(12) NULL DEFAULT NULL after `Mailing_ZipPlus4`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Physical_ZipPlus4'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Physical_ZipPlus4` CHAR(4) NULL DEFAULT NULL after `Physical_ZipCode`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Physical_DeliveryPointBarcode'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Physical_DeliveryPointBarcode` CHAR(12) NULL DEFAULT NULL after `Physical_ZipPlus4`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Physical_Latitude'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Physical_Latitude` DECIMAL(10,5) NULL DEFAULT NULL after `Physical_DeliveryPointBarcode`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Physical_Longitude'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Physical_Longitude` DECIMAL(10,5) NULL DEFAULT NULL after `Physical_Latitude`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Physical_Timezone'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Physical_Timezone` TINYTEXT NULL after `Physical_Longitude`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Physical_DST'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Physical_DST` BIT(1) NULL DEFAULT NULL after `Physical_Timezone`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Physical_UTCOffset'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Physical_UTCOffset` CHAR(3) NULL DEFAULT NULL after `Physical_DST`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Physical_CountyName'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Physical_CountyName` TINYTEXT NULL after `Physical_UTCOffset`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Physical_CarrierRoute'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Physical_CarrierRoute` TINYTEXT NULL after `Physical_CountyName`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'Physical_CongressionalDistrict'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Membership` Add COLUMN `Physical_CongressionalDistrict` TINYTEXT NULL after `Physical_CarrierRoute`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_StateESCOrganizations Like 'Mailing_ZipPlus4'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_StateESCOrganizations` Add COLUMN `Mailing_ZipPlus4` CHAR(4) NULL DEFAULT NULL after `Mailing_ZipCode`
	</cfquery>
</cfif>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_StateESCOrganizations` Add COLUMN `Physical_ZipPlus4` CHAR(4) NULL DEFAULT NULL after `Physical_ZipCode`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_StateESCOrganizations Like 'Physical_DeliveryPointBarcode'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_StateESCOrganizations` Add COLUMN `Physical_DeliveryPointBarcode` CHAR(12) NULL DEFAULT NULL after `Physical_ZipPlus4`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_StateESCOrganizations Like 'Physical_Latitude'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_StateESCOrganizations` Add COLUMN `Physical_Latitude` DECIMAL(10,5) NULL DEFAULT NULL after `Physical_DeliveryPointBarcode`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_StateESCOrganizations Like 'Physical_Longitude'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_StateESCOrganizations` Add COLUMN `Physical_Longitude` DECIMAL(10,5) NULL DEFAULT NULL after `Physical_Latitude`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_StateESCOrganizations Like 'Physical_Timezone'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_StateESCOrganizations` Add COLUMN `Physical_Timezone` TINYTEXT NULL after `Physical_Longitude`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_StateESCOrganizations Like 'Physical_DST'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_StateESCOrganizations` Add COLUMN `Physical_DST` BIT(1) NULL DEFAULT NULL after `Physical_Timezone`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_StateESCOrganizations Like 'Physical_UTCOffset'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_StateESCOrganizations` Add COLUMN `Physical_UTCOffset` CHAR(3) NULL DEFAULT NULL after `Physical_DST`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_StateESCOrganizations Like 'Physical_CountyName'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_StateESCOrganizations` Add COLUMN `Physical_CountyName` TINYTEXT NULL after `Physical_UTCOffset`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_StateESCOrganizations Like 'Physical_CarrierRoute'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_StateESCOrganizations` Add COLUMN `Physical_CarrierRoute` TINYTEXT NULL after `Physical_CountyName`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_StateESCOrganizations Like 'Physical_CongressionalDistrict'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterSiteConfigAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_StateESCOrganizations` Add COLUMN `Physical_CongressionalDistrict` TINYTEXT NULL after `Physical_CarrierRoute`
	</cfquery>
</cfif>