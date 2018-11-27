<cfif isDefined("URL.EventID")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, Event_HasMultipleDates, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
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
		Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_TimeZone, MailingAddress, MailingCity, MailingState, MailingZipCode, MailingZip4, Mailing_isAddressVerified, Mailing_USPSDeliveryPoint, Mailing_USPSCheckDigit, Mailing_USPSCarrierRoute, PrimaryVoiceNumber, PrimaryFaxNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, AdditionalNotes, Cost_HaveEventAt, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active
		From p_EventRegistration_Facility
		Where TContent_ID = <cfqueryparam value="#getSelectedEvent.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfif getSelectedEvent.Meal_Available EQ 1>
		<cfquery name="getEventCaterer" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, DeliveryInfo, GuaranteeInformation, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_Timezone, Active
		From p_EventRegistration_Caterers
			Where TContent_ID = <cfqueryparam value="#getSelectedEvent.Meal_ProvidedBy#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset Session.EventInfo.EventCaterer = #StructCopy(getEventCaterer)#>
	</cfif>

	<cfquery name="getEventFacilityRoom" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select RoomName, Capacity
		From p_EventRegistration_FacilityRooms
		Where TContent_ID = <cfqueryparam value="#getSelectedEvent.Event_FacilityRoomID#" cfsqltype="cf_sql_integer"> and Facility_ID = <cfqueryparam value="#getSelectedEvent.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery name="getFacilitator" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select FName, Lname, Email
		From tusers
		Where UserID = <cfqueryparam value="#getSelectedEvent.FacilitatorID#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfif LEN(getSelectedEvent.PresenterID)>
		<cfquery name="getPresenter" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select FName, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset Session.EventInfo.EventPresenter = #StructCopy(getPresenter)#>
	</cfif>

	<cfset Session.EventInfo.SelectedEvent = #StructCopy(getSelectedEvent)#>
	<cfset Session.EventInfo.EventRegistrations = #StructCopy(getCurrentRegistrationsbyEvent)#>
	<cfset Session.EventInfo.EventFacility = #StructCopy(getEventFacility)#>
	<cfset Session.EventInfo.EventFacilityRoom = #StructCopy(getEventFacilityRoom)#>
	<cfset Session.EventInfo.EventFacilitator = #StructCopy(getFacilitator)#>
	
<cfelse>
	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventpresenter:events.default" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventpresenter:events.default" >
	</cfif>
	<cflocation url="#Variables.newurl#" addtoken="false">
</cfif>