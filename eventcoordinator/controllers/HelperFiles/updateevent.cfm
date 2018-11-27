<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, Event_HasMultipleDates, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_Events
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order By EventDate DESC
	</cfquery>
	<cfset Session.getSelectedEvent = StructCopy(getSelectedEvent)>

	<cfquery name="getSelectedFacility" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_TimeZone, MailingAddress, MailingCity, MailingState, MailingZipCode, MailingZip4, Mailing_isAddressVerified, Mailing_USPSDeliveryPoint, Mailing_USPSCheckDigit, Mailing_USPSCarrierRoute, PrimaryVoiceNumber, PrimaryFaxNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, AdditionalNotes, Cost_HaveEventAt, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active
		From p_EventRegistration_Facility
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#getSelectedEvent.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer"> and Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
		Order by FacilityName
	</cfquery>
	<cfset Session.getSelectedFacility = StructCopy(getSelectedFacility)>

	<cfquery name="GetSelectedFacilityRoomInfo" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, Facility_ID, RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_FacilityRooms
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Facility_ID = <cfqueryparam value="#getSelectedEvent.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer"> and TContent_ID = <cfqueryparam value="#getSelectedEvent.Event_FacilityRoomID#" cfsqltype="cf_sql_integer">
		Order by RoomName
	</cfquery>
	<cfset Session.GetSelectedFacilityRoomInfo = StructCopy(GetSelectedFacilityRoomInfo)>

	<cfif LEN(getSelectedEvent.PresenterID)>
		<cfquery name="getFacilitator" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select FName, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset Session.getSelectedPresenterInfo = StructCopy(getFacilitator)>
	</cfif>

	<cfif getSelectedEvent.Meal_Available CONTAINS 1>
		<cfquery name="getCaterers" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, DeliveryInfo, GuaranteeInformation, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_Timezone, Active
			From p_EventRegistration_Caterers
			Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#getSelectedEvent.Meal_ProvidedBy#" cfsqltype="cf_sql_integer">
			Order by FacilityName
		</cfquery>
		<cfset Session.getSelectedCatererInfo = StructCopy(getCaterers)>
	</cfif>
<cfelse>
	<cfif FORM.UserAction EQ "Return to Event Listing">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
		<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
		<cfset temp = StructDelete(Session, "GetMembershipOrganizations")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "JSMuraScope")>
		<cfset temp = StructDelete(Session, "SignInReport")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>
</cfif>