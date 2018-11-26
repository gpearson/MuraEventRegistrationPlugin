<cfquery name="ShowEventResourcesTable" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Tables LIKE 'p_EventRegistration_EventResources'
</cfquery>

<cfif ShowEventResourcesTable.RecordCount EQ 0>
	<cfquery name="Create-p_EventRegistration_EventResources" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		CREATE TABLE `p_EventRegistration_EventResources` (
			`TContent_ID` int(11) NOT NULL AUTO_INCREMENT, `Site_ID` varchar(20) NOT NULL, `Event_ID` int(11) NOT NULL, `ResourceType` char(1) NOT NULL,
			`ResourceLink` tinytext, `dateCreated` datetime NOT NULL, `lastUpdated` timestamp default now() ON UPDATE now(), `lastUpdateBy` tinytext NOT NULL, `ResourceDocument` tinytext,
			`ResourceDocumentType` tinytext, `ResourceDocumentSize` tinytext, PRIMARY KEY (`TContent_ID`,`Event_ID`), KEY `Event_ID_Index` (`Event_ID`) USING BTREE
		) ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
	</cfquery>
</cfif>
