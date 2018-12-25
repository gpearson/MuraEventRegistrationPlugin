<cfset dbTableEvents = application.configbean.getBean('dbUtility').setTable('p_EventRegistration_Events')>
<cfscript>
	dbTableEvents.addColumn(column='WhatIf_MealCostPerAttendee',dataType='double', nullable=true)
	.addColumn(column='WhatIf_FacilityCostTotal',dataType='double', nullable=true)
	.addColumn(column='WhatIf_PresenterCostTotal',dataType='double', nullable=true);
</cfscript>