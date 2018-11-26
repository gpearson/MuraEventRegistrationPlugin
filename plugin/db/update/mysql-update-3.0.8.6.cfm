<cfscript>
	var dbWorker = application.configbean.getBean('dbUtility');

	var CheckTable = dbWorker.tableExists('p_EventRegistration_EventResources');
</cfscript>

<cfif Variables.CheckTable EQ False>
	<cfscript>
		dbWorker.setTable('p_EventRegistration_EventResources')
			.addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
			.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
			.addColumn(column='ResourceType',dataType='char',length='1',nullable=false)
			.addColumn(column='ResourceLink',dataType='longtext',nullable=true)
			.addColumn(column='ResourceDocument',dataType='longtext',nullable=true)
			.addColumn(column='ResourceDocumentSized',dataType='longtext',nullable=true)
			.addColumn(column='dateCreated',dataType='datetime')
			.addColumn(column='lastUpdated',dataType='datetime')
			.addColumn(column='lastUpdateBy',dataType='varchar',length='255')
			.addColumn(column='lastUpdateByID',dataType='varchar',length='35')
			.addPrimaryKey(column='TContent_ID');
	</cfscript>
</cfif>