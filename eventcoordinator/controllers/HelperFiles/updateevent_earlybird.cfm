<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and not isDefined("FORM.PerformAction")>

<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.EventID") and isDefined("FORM.PerformAction")>
	<cfif FORM.UserAction EQ "Back to Update Event">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
		<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
		<cfset temp = StructDelete(Session, "GetMembershipOrganizations")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "JSMuraScope")>
		<cfset temp = StructDelete(Session, "SignInReport")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&EventID=#URL.EventID#" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&EventID=#URL.EventID#" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
	</cflock>
	<cfif not isDefined("Session.PluginFramework")>
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cflocation url="/" addtoken="false">
		</cflock>
	</cfif>

	<cfswitch expression="#FORM.PerformAction#">
		<cfcase value="Step2">
			<cfset Session.FormInput.EventStep1 = #StructCopy(FORM)#>

			<cfif FORM.EarlyBird_Available CONTAINS 1>
				<cfif LEN(FORM.EarlyBird_Deadline) LT 10 or not isDate(FORM.EarlyBird_Deadline)>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for early bird registration deadline."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_earlybird&EventID=#URL.EventID#&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_earlybird&EventID=#URL.EventID#&FormRetry=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>

				<cfset EarlyBird_Deadline = #CreateDate(ListLast(FORM.EarlyBird_Deadline, '/'), ListFirst(FORM.EarlyBird_Deadline, '/'), ListGetAt(FORM.EarlyBird_Deadline, 2, '/'))#>
				<cfset FORM.EarlyBird_Deadline = #Variables.EarlyBird_Deadline#>
				
				<cftry>
					<cfquery name="updateEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set EarlyBird_Available = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
							EarlyBird_Deadline = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.EarlyBird_Deadline#">,
							EarlyBird_MemberCost = <cfqueryparam value="#FORM.EarlyBird_MemberCost#" cfsqltype="cf_sql_double">,
							EarlyBird_NonMemberCost = <cfqueryparam value="#FORM.EarlyBird_NonMemberCost#" cfsqltype="cf_sql_double">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">
					</cfquery>
					<cfcatch type="any">
						<cfdump var="#CFCATCH#" abort="True">
					</cfcatch>
				</cftry>

				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>

				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventEarlyBird&EventID=#URL.EventID#&Successful=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventEarlyBird&EventID=#URL.EventID#&Successful=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">			
			<cfelse>
				<cftry>
					<cfquery name="updateEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set EarlyBird_Available = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">
					</cfquery>
					<cfcatch type="any">
						<cfdump var="#CFCATCH#" abort="True">
					</cfcatch>
				</cftry>

				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
				
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventEarlyBird&EventID=#URL.EventID#&Successful=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventEarlyBird&EventID=#URL.EventID#&Successful=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		</cfcase>
	</cfswitch>
</cfif>