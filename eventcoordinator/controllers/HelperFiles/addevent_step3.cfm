<cfif not isDefined("FORM.formSubmit")>
	<cfquery name="getFacilitySelectedRoom" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, Facility_ID, RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_FacilityRooms
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Facility_ID = <cfqueryparam value="#Session.FormInput.EventStep1.LocationID#" cfsqltype="cf_sql_integer"> and TContent_ID = <cfqueryparam value="#Session.FormInput.EventStep2.LocationRoomID#" cfsqltype="cf_sql_integer">
		Order by RoomName
	</cfquery>
	<cfset Session.getSelectedFacilityRoomInfo = StructCopy(getFacilitySelectedRoom)>
<cfelse>
	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfif not isDefined("Session.FormInput")>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
		<cfparam name="FORM.AcceptRegistrations" default="0">
		<cfset Session.FormInput.EventStep3 = #StructCopy(FORM)#>
		<cfset Session.FormErrors = #ArrayNew()#>
	</cflock>
	<cfif FORM.UserAction EQ "Back to Step 2">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfif isDefined("Session.getActiveCaterers")><cfset temp = StructDelete(Session, "getActiveCaterers")></cfif>
		<cfif isDefined("Session.getMembership")><cfset temp = StructDelete(Session, "getMembership")></cfif>
		<cfif isDefined("Session.getFacilities")><cfset temp = StructDelete(Session, "getFacilities")></cfif>
		<cfif isDefined("Session.getUsers")><cfset temp = StructDelete(Session, "getUsers")></cfif>
		<cfif isDefined("Session.GetEventGroups")><cfset temp = StructDelete(Session, "GetEventGroups")></cfif>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_step2" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cfset newEvent = #Session.FormInput.FilePath# & #Session.FormInput.EventIDConfig#>
	<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "EventMaxParticipants", FORM.EventMaxParticipants)#>
	<cfset temp = #SetProfileString(variables.newEvent, "NewEvent", "AcceptRegistrations", FORM.AcceptRegistrations)#>

	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_review" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent_review" >
	</cfif>
	<cflocation url="#variables.newurl#" addtoken="false">
</cfif>