<cfif not isDefined("FORM.formSubmit")>
	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
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
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cfscript>
				address = {property="BusinessAddress",message="Please select one of the options as to whether this expense is is active or not."};
				arrayAppend(Session.FormErrors, address);
			</cfscript>
		</cflock>
		<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addeventexpense&FormRetry=True">
	</cfif>
	<cfquery name="insertEventExpense" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Insert into p_EventRegistration_ExpenseList(Expense_Name, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active, Site_ID)
		Values(
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ExpenseName#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ExpenseActive#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
		)
	</cfquery>
	<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.listeventexpenses&UserAction=ExpenseCreatead&Successful=True">
</cfif>