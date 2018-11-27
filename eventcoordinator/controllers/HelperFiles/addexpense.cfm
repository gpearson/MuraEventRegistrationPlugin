<cfif not isDefined("FORM.formSubmit")>
	<cfquery name="getExpenseList" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, Expense_Name, Active, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_ExpenseList
		where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">
		Order by Expense_Name
	</cfquery>
	<cfset Session.getExpenseList = #StructCopy(getExpenseList)#>

<cfelseif isDefined("FORM.formSubmit")>
	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.FormInput = #StructCopy(FORM)#>
	</cflock>

	<cfif FORM.UserAction EQ "Back to Events Menu">
		<cfset temp = StructDelete(Session, "getAllEvents")>
		<cfset temp = StructDelete(Session, "getAvailableExpenseList")>
		<cfset temp = StructDelete(Session, "getEventExpenses")>
		<cfset temp = StructDelete(Session, "getExpenseList")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>

		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cfif FORM.ExpenseActive EQ "----">
		<cfscript>
			errormsg = {property="EmailMsg",message="Please select if this Expense is Active or not."};
			arrayAppend(Session.FormErrors, errormsg);
		</cfscript>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addexpense&FormRetry=True" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addexpense&FormRetry=True" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cfquery name="insertNewExpense" result="InsertNewRecord" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Insert into p_EventRegistration_ExpenseList(Site_ID, Expense_Name, Active, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID)
		Values(
			<cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#FORM.ExpenseName#" cfsqltype="cf_sql_varchar">,
			<cfqueryparam value="#FORM.ExpenseActive#" cfsqltype="cf_sql_bit">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
			)
	</cfquery>
	<cfset temp = StructDelete(Session, "FormErrors")>
	<cfset temp = StructDelete(Session, "FormInput")>
	<cfset temp = StructDelete(Session, "getExpenseList")>
	

	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addexpense&UserAction=EventExpenseAdded&Successful=True" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addexpense&UserAction=EventExpenseAdded&Successful=True">
	</cfif>
	<cflocation url="#variables.newurl#" addtoken="false">

</cfif>