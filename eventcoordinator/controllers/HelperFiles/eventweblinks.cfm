<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and not isDefined("URL.UserAction") and not isDefined("FORM.UserAction")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_Events
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order By EventDate DESC
	</cfquery>

	<cfquery name="getSelectedEventLinks" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, Site_ID, Event_ID, ResourceType, ResourceDocument, ResourceContentType, ResourceDocumentSize, dateCreated, lastUpdated, lastUpdateby, lastUpdateByID
		From p_EventRegistration_EventResources
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and ResourceType = <cfqueryparam value="L" cfsqltype="cf_sql_varchar"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
	</cfquery>

	<cfset Session.getSelectedEvent = #StructCopy(getSelectedEvent)#>
	<cfset Session.getSelectedEventLinks = #StructCopy(getSelectedEventLinks)#>
<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.EventID") and isDefined("FORM.UserAction")>
	<cfif FORM.UserAction EQ "Back to Event Listing">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "SiteConfigSettings")>
		<cfset temp = StructDelete(Session, "getAllEvents")>
		<cfset temp = StructDelete(Session, "getAvailableExpenseList")>
		<cfset temp = StructDelete(Session, "getEventExpenses")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.FormInput = #StructCopy(FORM)#>
	</cflock>

	<cfhttp url="#FORM.EventLink#" result="WebRequest" resolveurl="true" method="head">

	<cfswitch expression="#WebRequest.status_code#">
		<cfcase value="200">
			<cfquery name="insertEventWebLink" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Insert into p_EventRegistration_EventResources(Site_ID, Event_ID, ResourceType, ResourceDocument, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active)
				Values(
					<cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="L" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#FORM.EventLink#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
					<cfqueryparam value="1" cfsqltype="cf_sql_bit">
				)
			</cfquery>
			<cfquery name="getSelectedEventLinks" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, Event_ID, ResourceType, ResourceDocument, ResourceDocumentSize, dateCreated, lastUpdated, lastUpdateby, lastUpdateByID
				From p_EventRegistration_EventResources
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and ResourceType = <cfqueryparam value="L" cfsqltype="cf_sql_varchar"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
			</cfquery>
			<cfset Session.getSelectedEventLinks = #StructCopy(getSelectedEventLinks)#>
		</cfcase>
		<cfdefaultcase>
			<cfset errormsg = StructNew()>
			<cfset errormsg.property = "EmailMsg">
			<cfset errormsg.message = "An Error has been detected. The Error Message of the URL '" & #FORM.EventLink# & "' was '" & #WebRequest.statuscode# & "'. Please check your link to make sure it is valid.">

			<cfscript>
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.eventweblinks&EventID=#URL.EventID#&FormRetry=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.eventweblinks&EventID=#URL.EventID#&FormRetry=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfdefaultcase>
	</cfswitch>

	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.eventweblinks&EventID=#URL.EventID#&UserAction=LinkUploaded&Successful=True" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.eventweblinks&EventID=#URL.EventID#&UserAction=LinkUploaded&Successful=True">
	</cfif>
	<cflocation url="#variables.newurl#" addtoken="false">
<cfelseif isDefined("URL.UserAction") and isDefined("URL.EventID") and isDefined("FORM.formSubmit")>
	<cfif FORM.UserAction EQ "Back to Event Listing">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "SiteConfigSettings")>
		<cfset temp = StructDelete(Session, "getAllEvents")>
		<cfset temp = StructDelete(Session, "getAvailableExpenseList")>
		<cfset temp = StructDelete(Session, "getEventExpenses")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cfquery name="getSelectedEventLinks" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, Site_ID, Event_ID, ResourceType, ResourceDocument, ResourceDocumentSize, dateCreated, lastUpdated, lastUpdateby, lastUpdateByID
		From p_EventRegistration_EventResources
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and ResourceType = <cfqueryparam value="L" cfsqltype="cf_sql_varchar"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
	</cfquery>
	<cfset Session.getSelectedEventLinks = #StructCopy(getSelectedEventLinks)#>
<cfelseif isDefined("URL.UserAction") and isDefined("URL.EventID") and not isdefined("FORM.formSubmit")>

	<cfif URL.UserAction EQ "DeleteEventLink">
		<cfquery name="updateEventDocument" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			update p_EventRegistration_EventResources
			set Active = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
				lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">
			where TContent_ID = <cfqueryparam value="#URL.LinkID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfif>

	<cfquery name="getSelectedEventLinks" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, Site_ID, Event_ID, ResourceType, ResourceDocument, ResourceDocumentSize, dateCreated, lastUpdated, lastUpdateby, lastUpdateByID
		From p_EventRegistration_EventResources
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and ResourceType = <cfqueryparam value="L" cfsqltype="cf_sql_varchar"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
	</cfquery>
	<cfset Session.getSelectedEventLinks = #StructCopy(getSelectedEventLinks)#>
</cfif>