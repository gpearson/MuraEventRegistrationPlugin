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

			<cfif FORM.BillForNoShow CONTAINS 1>
				<cftry>
					<cfquery name="updateEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set BillForNoShow = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
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

				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventOptions&EventID=#URL.EventID#&Successful=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventOptions&EventID=#URL.EventID#&Successful=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">	
			<cfelse>
				<cftry>
					<cfquery name="updateEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set BillForNoShow = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
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

				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventOptions&EventID=#URL.EventID#&Successful=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventOptions&EventID=#URL.EventID#&Successful=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		</cfcase>
		<cfcase value="UpdateEvent">
			<cfset Session.FormInput.EventStep2 = #StructCopy(FORM)#>
		</cfcase>
	</cfswitch>
</cfif>