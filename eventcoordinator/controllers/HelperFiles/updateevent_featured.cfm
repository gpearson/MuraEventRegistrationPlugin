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

			<cfif FORM.Featured_Event CONTAINS 1>
				<cfif LEN(FORM.Featured_StartDate) LT 10 or not isDate(FORM.Featured_StartDate)>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the stating date this event is to be featured."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_featured&EventID=#URL.EventID#&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_featured&EventID=#URL.EventID#&FormRetry=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>

				<cfif LEN(FORM.Featured_EndDate) LT 10 or not isDate(FORM.Featured_EndDate)>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the ending date this event is to be featured."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_featured&EventID=#URL.EventID#&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_featured&EventID=#URL.EventID#&FormRetry=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>

				<cfset Featured_StartDate = #CreateDate(ListLast(FORM.Featured_StartDate, '/'), ListFirst(FORM.Featured_StartDate, '/'), ListGetAt(FORM.Featured_StartDate, 2, '/'))#>
				<cfset FORM.Featured_StartDate = #Variables.Featured_StartDate#>

				<cfset Featured_EndDate = #CreateDate(ListLast(FORM.Featured_EndDate, '/'), ListFirst(FORM.Featured_EndDate, '/'), ListGetAt(FORM.Featured_EndDate, 2, '/'))#>
				<cfset FORM.Featured_EndDate = #Variables.Featured_EndDate#>

				<cftry>
					<cfquery name="updateEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set Featured_Event = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
							Featured_StartDate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.Featured_StartDate#">,
							Featured_EndDate = <cfqueryparam cfsqltype="cf_sql_date" value="#FORM.Featured_EndDate#">,
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
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventFeatured&EventID=#URL.EventID#&Successful=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventFeatured&EventID=#URL.EventID#&Successful=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">			
			<cfelse>
				<cftry>
					<cfquery name="updateEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set Featured_Event = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
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
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventFeatured&EventID=#URL.EventID#&Successful=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventFeatured&EventID=#URL.EventID#&Successful=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		</cfcase>
	</cfswitch>
</cfif>