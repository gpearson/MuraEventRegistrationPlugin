<cfif isDefined("URL.EventID")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, Member_Cost, NonMember_Cost, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewGroupPricing, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPAvailable, PGPPoints, Meal_Available, Meal_Included, Meal_Notes, Meal_Cost, Meal_ProvidedBy, AllowVideoConference, VideoConferenceInfo, VideoConferenceMemberCost, VideoConferenceNonMemberCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, PresenterID, FacilitatorID, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, PostedTo_Facebook, PostedTo_Twitter, EventHasDailySessions, Session1BeginTime, Session1EndTime, Session2BeginTime, Session2EndTime, EventInvoicesGenerated, PGPCertificatesGenerated, BillForNoShow, EventPricePerDay, EventHasOptionalCosts
		From p_EventRegistration_Events
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order By EventDate DESC
	</cfquery>

	<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select Count(TContent_ID) as CurrentNumberofRegistrations
		From p_EventRegistration_UserRegistrations
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery name="getEventFacility" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, GeoCode_Latitude, GeoCode_Longitude, GeoCode_StateLongName
		From p_EventRegistration_Facility
		Where TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif getSelectedEvent.Meal_Included EQ 0>
		<cfquery name="getEventCaterer" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite
			From p_EventRegistration_Caterers
			Where TContent_ID = <cfqueryparam value="#getSelectedEvent.Meal_ProvidedBy#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset Session.EventInfo.EventCaterer = #StructCopy(getEventCaterer)#>
	</cfif>

	<cfquery name="getEventFacilityRoom" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select RoomName, Capacity
		From p_EventRegistration_FacilityRooms
		Where TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer"> and Facility_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery name="getFacilitator" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select FName, Lname, Email
		From tusers
		Where UserID = <cfqueryparam value="#getSelectedEvent.FacilitatorID#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfquery name="getPresenter" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select FName, Lname, Email
		From tusers
		Where UserID = <cfqueryparam value="#getSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfset Session.EventInfo.SelectedEvent = #StructCopy(getSelectedEvent)#>
	<cfset Session.EventInfo.EventRegistrations = #StructCopy(getCurrentRegistrationsbyEvent)#>
	<cfset Session.EventInfo.EventFacility = #StructCopy(getEventFacility)#>
	<cfset Session.EventInfo.EventFacilityRoom = #StructCopy(getEventFacilityRoom)#>
	<cfset Session.EventInfo.EventFacilitator = #StructCopy(getFacilitator)#>
	<cfset Session.EventInfo.EventPresenter = #StructCopy(getPresenter)#>
<cfelse>
	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
	</cfif>
	<cflocation url="#Variables.newurl#" addtoken="false">
</cfif>