<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_UserMatrix Like 'created'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserMatrix Add COLUMN `created` datetime NOT NULL AFTER School_District
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameTeachingGrade" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_UserMatrix Like 'TeachingGrade'
</cfquery>
<cfif CheckColumnNameTeachingGrade.RecordCount EQ 0>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserMatrix Add COLUMN `TeachingGrade` int(11) DEFAULT NULL AFTER lastUpdated
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameTeachingSubject" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_UserMatrix Like 'TeachingSubject'
</cfquery>
<cfif CheckColumnNameTeachingGrade.RecordCount EQ 0>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserMatrix Add COLUMN `TeachingSubject` int(11) DEFAULT NULL AFTER TeachingGrade
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameReceiveMarketingFlyers" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_UserMatrix Like 'ReceiveMarketingFlyers'
</cfquery>
<cfif CheckColumnNameReceiveMarketingFlyers.RecordCount EQ 0>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_UserMatrix Add COLUMN `ReceiveMarketingFlyers` bit(1) NOT NULL DEFAULT b'0' AFTER TeachingSubject
	</cfquery>
</cfif>

<cfquery name="ShowGradeLevelsTable" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'p_EventRegistration_GradeLevels'
</cfquery>
<cfif ShowGradeLevelsTable.RecordCount EQ 0>
	<cfquery name="Create-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		CREATE TABLE `p_EventRegistration_GradeLevels` (
			`TContent_ID` int(11) NOT NULL, `Site_ID` tinytext NOT NULL, `GradeLevel` tinytext NOT NULL, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
	</cfquery>
</cfif>

<cfquery name="ShowGradeSubjectsTable" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'p_EventRegistration_GradeSubjects'
</cfquery>
<cfif ShowGradeSubjectsTable.RecordCount EQ 0>
	<cfquery name="Create-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		CREATE TABLE `p_EventRegistration_GradeSubjects` (
			`TContent_ID` int(11) NOT NULL, `Site_ID` tinytext NOT NULL, `GradeLevel` int(11) NOT NULL, `GradeSubject` tinytext NOT NULL, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
	</cfquery>
</cfif>

<cfquery name="ShowESCOrganizationsTable" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'p_EventRegistration_StateESCOrganizations'
</cfquery>
<cfif ShowESCOrganizationsTable.RecordCount EQ 0>
	<cfquery name="Create-p_EventRegistration_StateESCOrganizations" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		CREATE TABLE `p_EventRegistration_StateESCOrganizations` (
			`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` tinytext NOT NULL, `OrganizationName` varchar(50) NOT NULL, `OrganizationDomainName` varchar(50) NOT NULL,
			`StateDOE_IDNumber` varchar(10) DEFAULT NULL, `StateDOE_State` tinytext,
			`dateCreated` date NOT NULL, `lastUpdateBy` tinytext NOT NULL, `lastUpdated` timestamp default now() ON UPDATE now(), `Mailing_Address` tinytext, `Mailing_City` tinytext, `Mailing_State` tinytext, `Mailing_ZipCode` tinytext, `Primary_PhoneNumber` tinytext, `Primary_FaxNumber` tinytext,
			`Physical_Address` tinytext, `Physical_City` tinytext, `Physical_State` tinytext, `Physical_ZipCode` tinytext, PRIMARY KEY (`TContent_ID`) ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameEventHasDailySessions" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'EventHasDailySessions'
</cfquery>
<cfif CheckColumnNameEventHasDailySessions.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events Add COLUMN `EventHasDailySessions` bit(1) NOT NULL DEFAULT b'0' AFTER PostedTo_Twitter
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameSession1BeginTime" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'Session1BeginTime'
</cfquery>
<cfif CheckColumnNameSession1BeginTime.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events Add COLUMN `Session1BeginTime` time DEFAULT NULL AFTER EventHasDailySessions
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameSession1EndTime" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'Session1EndTime'
</cfquery>
<cfif CheckColumnNameSession1EndTime.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events Add COLUMN `Session1EndTime` time DEFAULT NULL AFTER Session1BeginTime
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameSession2BeginTime" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'Session2BeginTime'
</cfquery>
<cfif CheckColumnNameSession2BeginTime.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events Add COLUMN `Session2BeginTime` time DEFAULT NULL AFTER Session1EndTime
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameSession2EndTime" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'Session2EndTime'
</cfquery>
<cfif CheckColumnNameSession2EndTime.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events Add COLUMN `Session2EndTime` time DEFAULT NULL AFTER Session2BeginTime
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameEventInvoicesGenerated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'EventInvoicesGenerated'
</cfquery>
<cfif CheckColumnNameEventInvoicesGenerated.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Events Add COLUMN `EventInvoicesGenerated` bit(1) NOT NULL DEFAULT b'0' AFTER Session2EndTime
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameGoogleReCaptchSiteKey" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_SiteConfig Like 'Google_ReCaptchaSiteKey'
</cfquery>
<cfif CheckColumnNameGoogleReCaptchSiteKey.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_SiteConfig Add COLUMN `Google_ReCaptchaSiteKey` tinytext AFTER Facebook_AppScope
	</cfquery>
	<cfquery name="Alter-p_EventRegistration_SiteConfig" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_SiteConfig Add COLUMN `Google_ReCaptchaSecretKey` tinytext AFTER Google_ReCaptchaSiteKey
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameStateDOEESCMembership" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Membership Like 'StateDOE_ESCESAMembership'
</cfquery>
<cfif CheckColumnNameStateDOEESCMembership.RecordCount EQ 0>
	<cfquery name="Alter-p_EventRegistration_Events" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE p_EventRegistration_Membership Add COLUMN `StateDOE_ESCESAMembership` int(11) DEFAULT NULL AFTER StateDOE_IDNumber
	</cfquery>
</cfif>
