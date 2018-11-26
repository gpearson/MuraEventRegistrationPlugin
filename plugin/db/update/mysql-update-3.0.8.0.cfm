<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'MealProvided'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 1>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Events` CHANGE COLUMN `MealProvided` `MealAvailable` bit(1) NOT NULL DEFAULT b'0'
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'MealIncluded'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Events` Add COLUMN `MealIncluded` bit(1) NOT NULL DEFAULT b'0' after `MealAvailable`
	</cfquery>
</cfif>

<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'Meal_Notes'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 0>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Events` Add COLUMN `Meal_Notes` longtext after `MealCost_Estimated`
	</cfquery>
</cfif>
<cfquery name="CheckColumnNameCreated" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
	Show Columns From p_EventRegistration_Events Like 'MealCost_Estimated'
</cfquery>
<cfif CheckColumnNameCreated.RecordCount EQ 1>
	<cfquery name="AlterUserMatrixAddColumn" datasource="#application.configBean.getDatasource()#" username="#application.configBean.getDBUsername()#" password="#application.configBean.getDBPassword()#">
		ALTER TABLE `p_EventRegistration_Events` CHANGE COLUMN `MealCost_Estimated` `MealCost` decimal(6,2) DEFAULT '0.00'
	</cfquery>
</cfif>