<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and not isDefined("FORM.PerformAction")>
	<cfquery name="getCaterers" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, DeliveryInfo, GuaranteeInformation, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_Timezone, Active
		From p_EventRegistration_Caterers
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
		Order by FacilityName
	</cfquery>
	<cfset Session.getActiveCaterers = StructCopy(getCaterers)>
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

			<cfif FORM.Meal_Available CONTAINS 1>
				<cftry>
					<cfquery name="updateEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set Meal_Available = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
							<cfif FORM.Meal_Included CONTAINS 1>Meal_Included = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,<cfelse>Meal_Included = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>
							Meal_Cost = <cfqueryparam value="#FORM.Meal_Cost#" cfsqltype="cf_sql_double">,
							Meal_Information = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.Meal_Information#">,
							Meal_ProvidedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.Meal_ProvidedBy#">,
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
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventMeal&EventID=#URL.EventID#&Successful=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventMeal&EventID=#URL.EventID#&Successful=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">			
			<cfelse>
				<cftry>
					<cfquery name="updateEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set Meal_Available = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
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
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventMeal&EventID=#URL.EventID#&Successful=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventMeal&EventID=#URL.EventID#&Successful=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">		
			</cfif>
		</cfcase>
		<cfcase value="UpdateEvent">
			<cfset Session.FormInput.EventStep2 = #StructCopy(FORM)#>
		</cfcase>
	</cfswitch>
</cfif>