<cfquery name="ShowEventEmailLogTable" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'p_EventRegistration_EventEmailLog'
</cfquery>

<cfif ShowEventEmailLogTable.RecordCount EQ 0>
	<cfquery name="Create-p_EventRegistrations_EventEmailLog" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		CREATE TABLE `p_EventRegistration_EventEmailLog` (
			`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL, `Event_ID` int(11) NOT NULL, `MsgBody` longtext, `EmailType` tinytext,
			`LinksToInclude` tinytext, `DocsToInclude` tinytext, `dateCreated` datetime NOT NULL, `lastUpdated` timestamp default now() ON UPDATE now(), `lastUpdateBy` tinytext NOT NULL,
			PRIMARY KEY (`TContent_ID`,`Event_ID`), KEY `Event_ID_Index` (`Event_ID`) USING BTREE
		) ENGINE=MyISAM DEFAULT CHARSET=latin1;
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_EventEmailLog Like 'EmailSentToParticipants'
</cfquery>

<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_EventEmailLog` Add COLUMN `EmailSentToParticipants` longtext after `DocsToInclude`
	</cfquery>
</cfif>
