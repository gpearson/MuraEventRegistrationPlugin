<cfif not isDefined("FORM.formSubmit")>
	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfif not isDefined("Session.FormErrors")>
			<cfset Session.FormErrors = #ArrayNew()#>
		</cfif>
		<cfquery name="Session.getSelectedExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, Expense_Name, Active, dateCreated, lastUpdated, lastUpdateBy
			From p_EventRegistration_ExpenseList
			Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
				TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.ExpenseID#">
		</cfquery>
	</cflock>
<cfelseif isDefined("FORM.formSubmit")>
	<cfset Session.FormData = #StructCopy(FORM)#>
	<cfset Session.FormErrors = #ArrayNew()#>

	<cfif FORM.UserAction EQ "Back to Main Menu">
		<cfset temp = StructDelete(Session, "FormData")>
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
		<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.listeventexpenses" addtoken="false">
	</cfif>

	<cfif FORM.ExpenseActive EQ "----">
		<cflock timeout="60" scope="SESSION" type="Exclusive">
			<cfscript>
				address = {property="BusinessAddress",message="Please select one of the options as to whether this expense is is active or not."};
				arrayAppend(Session.FormErrors, address);
			</cfscript>
		</cflock>
		<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.editeventexpense&FormRetry=True">
	</cfif>

	<cfquery name="updateOrganizationGroup" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Update p_EventRegistration_ExpenseList
		Set Expense_Name = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ExpenseName#">,
			lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
			lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
			Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ExpenseActive#">
		Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.ExpenseID#">
	</cfquery>
	<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.listeventexpenses&UserAction=ExpenseUpdated&Successful=True">
</cfif>