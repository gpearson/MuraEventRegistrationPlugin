<cfscript>
	var dbWorker = application.configbean.getBean('dbUtility');

	var CheckTable = dbWorker.tableExists('p_EventRegistration_EventEmailLog');
</cfscript>

<cfif Variables.CheckTable EQ False>
	<cfscript>
		dbWorker.setTable('p_EventRegistration_EventEmailLog')
			.addColumn(column='TContent_ID',dataType='int',nullable=false,autoincrement=true)
			.addColumn(column='Site_ID',dataType='char',length='25',nullable=false)
			.addColumn(column='Event_ID',dataType='int',nullable=false)
			.addColumn(column='MsgBody',dataType='longtext',nullable=false)
			.addColumn(column='EmailType',dataType='longtext',nullable=false)
			.addColumn(column='LinksToInclude',dataType='varchar',length='255',nullable=true)
			.addColumn(column='DocsToInclude',dataType='varchar',length='255',nullable=true)
			.addColumn(column='EmailSentToParticipants',dataType='varchar',length='255',nullable=true)
			.addColumn(column='dateCreated',dataType='datetime')
			.addColumn(column='lastUpdated',dataType='datetime')
			.addColumn(column='lastUpdateBy',dataType='varchar',length='255')
			.addColumn(column='lastUpdateByID',dataType='varchar',length='35')
			.addPrimaryKey(column='TContent_ID');
	</cfscript>
<cfelse>
	<cfscript>
		var checkTableColumn = dbWorker.columnExists('EmailSentToParticipants');
	</cfscript>
	<cfif variables.checkTableColumn eq False>
		<cfscript>
			dbWorker.setTable('p_EventRegistration_EventEmailLog')
				.addColumn(column='EmailSentToParticipants',dataType='varchar',length='255',nullable=true);
		</cfscript>
	</cfif>
</cfif>