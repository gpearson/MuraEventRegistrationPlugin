<cfscript>
	var dbWorker = application.configbean.getBean('dbUtility');

	var CheckColumnExists = dbWorker.setTable('p_EventRegistration_Events').columnExists('MealProvided');
</cfscript>

<cfif Variables.CheckColumnExists eq True>
	<cfscript>
		dbWorker.setTable('p_EventRegistration_Events')
			.addColumn(column='MealAvailable',dataType='boolean',default=0,nullable=false)
			.dropColumn(column='MealProvided');
	</cfscript>
</cfif>

<cfscript>
	var CheckColumnExists = dbWorker.setTable('p_EventRegistration_Events').columnExists('MealIncluded');
</cfscript>

<cfif Variables.CheckColumnExists eq False>
	<cfscript>
		dbWorker.setTable('p_EventRegistration_Events')
			.addColumn(column='MealIncluded',dataType='boolean',default=0,nullable=false);
	</cfscript>
</cfif>

<cfscript>
	var CheckColumnExists = dbWorker.setTable('p_EventRegistration_Events').columnExists('Meal_Notes');
</cfscript>

<cfif Variables.CheckColumnExists eq False>
	<cfscript>
		dbWorker.setTable('p_EventRegistration_Events')
			.addColumn(column='Meal_Notes',dataType='longtext',nullable=true)
	</cfscript>
</cfif>

<cfscript>
	var CheckColumnExists = dbWorker.setTable('p_EventRegistration_Events').columnExists('MealCost_Estimated');
</cfscript>

<cfif Variables.CheckColumnExists eq True>
	<cfscript>
		dbWorker.setTable('p_EventRegistration_Events')
			.addColumn(column='Meal_Cost',dataType='double',nullable=true)
			.dropColumn(column='MealCost_Estimated');
	</cfscript>
</cfif>