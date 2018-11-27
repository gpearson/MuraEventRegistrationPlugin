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

			<cftry>
				<cfquery name="updateEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set ShortTitle = <cfqueryparam value="#Session.FormInput.EventStep1.ShortTitle#" cfsqltype="cf_sql_varchar">,
						<cfif LEN(Session.FormInput.EventStep1.LongDescription)>LongDescription = <cfqueryparam value="#Session.FormInput.EventStep1.LongDescription#" cfsqltype="cf_sql_varchar">,<cfelse>LongDescription = <cfqueryparam value="" cfsqltype="cf_sql_varchar">,</cfif>
						<cfif LEN(Session.FormInput.EventStep1.EventAgenda)>EventAgenda = <cfqueryparam value="#Session.FormInput.EventStep1.EventAgenda#" cfsqltype="cf_sql_varchar">,<cfelse>EventAgenda = <cfqueryparam value="" cfsqltype="cf_sql_varchar">,</cfif>
						<cfif LEN(Session.FormInput.EventStep1.EventTargetAudience)>EventTargetAudience = <cfqueryparam value="#Session.FormInput.EventStep1.EventTargetAudience#" cfsqltype="cf_sql_varchar">,<cfelse>EventTargetAudience = <cfqueryparam value="" cfsqltype="cf_sql_varchar">,</cfif>
						<cfif LEN(Session.FormInput.EventStep1.EventStrategies)>EventStrategies = <cfqueryparam value="#Session.FormInput.EventStep1.EventStrategies#" cfsqltype="cf_sql_varchar">,<cfelse>EventStrategies = <cfqueryparam value="" cfsqltype="cf_sql_varchar">,</cfif>
						<cfif LEN(Session.FormInput.EventStep1.EventSpecialInstructions)>EventSpecialInstructions = <cfqueryparam value="#Session.FormInput.EventStep1.EventSpecialInstructions#" cfsqltype="cf_sql_varchar">,<cfelse>EventSpecialInstructions = <cfqueryparam value="" cfsqltype="cf_sql_varchar">,</cfif>
						<cfif LEN(Session.FormInput.EventStep1.Event_SpecialMessage)>Event_SpecialMessage = <cfqueryparam value="#Session.FormInput.EventStep1.Event_SpecialMessage#" cfsqltype="cf_sql_varchar">,<cfelse>Event_SpecialMessage = <cfqueryparam value="" cfsqltype="cf_sql_varchar">,</cfif>
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
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventDescriptions&EventID=#URL.EventID#&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventDescriptions&EventID=#URL.EventID#&Successful=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">			
		</cfcase>
		<cfcase value="UpdateEvent">
			<cfset Session.FormInput.EventStep2 = #StructCopy(FORM)#>

		</cfcase>
	</cfswitch>
</cfif>