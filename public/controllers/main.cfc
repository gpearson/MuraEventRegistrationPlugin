/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent output="false" persistent="false" accessors="true">

	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<!--- Checking to make sure that today's date is within the Featured Events Date Window, Otherwise Update Event to not be featured. --->
		<cfquery name="updateExpiredFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Update p_EventRegistration_Events
			Set EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
			Where DateDiff(Featured_StartDate, Now()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
				DateDiff(Featured_EndDate, Now()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
				EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
				Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
		</cfquery>

		<cfquery name="getNonFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, TContent_ID, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, AcceptRegistrations, Registration_Deadline, MaxParticipants, PGPAvailable, AllowVideoConference, WebinarAvailable
			From p_EventRegistration_Events
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				DateDiff(EventDate, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
				EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
				Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate1, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate2, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate3, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate4, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate5, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
			Order By EventDate
		</cfquery>

		<cfquery name="getFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, TContent_ID, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, AcceptRegistrations, Registration_Deadline, MaxParticipants, PGPAvailable, AllowVideoConference, WebinarAvailable
			From p_EventRegistration_Events
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				DateDiff(EventDate, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
				EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
				Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate1, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate2, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate3, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate4, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate5, Now()) >= <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
			Order By Featured_SortOrder ASC, EventDate ASC
		</cfquery>

		<cfif getFeaturedEvents.RecordCount>
			<cfset getFeaturedEventRecordID = #RandRange(1, getFeaturedEvents.RecordCount)#>
			<cfloop query="getFeaturedEvents">
				<cfif getFeaturedEvents.currentRow EQ getFeaturedEventRecordID>
					<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select Count(TContent_ID) as CurrentNumberofRegistrations
						From p_EventRegistration_UserRegistrations
						Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and EventID = <cfqueryparam value="#Variables.getFeaturedEventRecordID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfset getFeaturedEvent = StructCopy(getFeaturedEvents)>
					<cfif getFeaturedEvent.RecordCount>

					</cfif>
					<cfset FeatureEventShortTitle = #getFeaturedEvents.ShortTitle#>
					<cfset FeatureEventEventDate = #getFeaturedEvents.EventDate#>
					<cfset FeatureEventRecordID = #getFeaturedEvents.TContent_ID#>
					<cfset FeatureEventFeatured = #getFeaturedEvents.EventFeatured#>
					<cfset FeatureEventDisplayStartDate = #getFeaturedEvents.Featured_StartDate#>
					<cfset FeatureEventDisplayEndDate = #getFeaturedEvents.Featured_EndDate#>
					<cfset FeatureEventFeatureSortOrder = #getFeaturedEvents.Featured_SortOrder#>
					<cfset FeatureEventAcceptRegistrations = #getFeaturedEvents.AcceptRegistrations#>
					<cfset FeatureEventRegistrationDeadline = #getFeaturedEvents.Registration_Deadline#>
					<cfset FeatureEventMaxParticipants = #getFeaturedEvents.MaxParticipants#>
					<cfset FeatureEventPGPAvailable = #getFeaturedEvents.PGPAvailable#>
					<cfset FeatureEventAllowVideoConf = #getFeaturedEvents.AllowVideoConference#>
					<cfset FeatureEventWebinarAvailable = #getFeaturedEvents.WebinarAvailable#>
					<cfset FeaturedEventSeatsLeft = #Variables.FeatureEventMaxParticipants# - #getCurrentRegistrationsbyEvent.CurrentNumberofRegistrations#>
				<cfelse>
					<cfset temp = #QueryAddRow(getNonFeaturedEvents, 1)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "ShortTitle", getFeaturedEvents.ShortTitle)#>
					<cfif DateDiff("d", Now(), getFeaturedEvents.EventDate) LT 0 and Len(getFeaturedEvents.EventDate) eq 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate)#>
					<cfelseif DateDiff("d", Now(), getFeaturedEvents.EventDate) LT 0 and DateDiff("d", Now(), getFeaturedEvents.EventDate1) GT 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate1)#>
					<cfelseif DateDiff("d", Now(), getFeaturedEvents.EventDate1) LT 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate2)#>
					<cfelseif DateDiff("d", Now(), getFeaturedEvents.EventDate2) LT 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate3)#>
					<cfelseif DateDiff("d", Now(), getFeaturedEvents.EventDate3) LT 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate4)#>
					<cfelseif DateDiff("d", Now(), getFeaturedEvents.EventDate4) LT 0>
						<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate5)#>
					</cfif>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", getFeaturedEvents.EventDate)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "TContent_ID", getFeaturedEvents.TContent_ID)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventFeatured", getFeaturedEvents.EventFeatured)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Featured_StartDate", getFeaturedEvents.Featured_StartDate)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Featured_EndDate", getFeaturedEvents.Featured_EndDate)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Featured_SortOrder", getFeaturedEvents.Featured_SortOrder)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "AcceptRegistrations", getFeaturedEvents.AcceptRegistrations)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Registration_Deadline", getFeaturedEvents.Registration_Deadline)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "MaxParticipants", getFeaturedEvents.MaxParticipants)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "PGPAvailable", getFeaturedEvents.PGPAvailable)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "AllowVideoConference", getFeaturedEvents.AllowVideoConference)#>
					<cfset temp = #QuerySetCell(getNonFeaturedEvents, "WebinarAvailable", getFeaturedEvents.WebinarAvailable)#>
				</cfif>
			</cfloop>
		</cfif>
		<cfset Session.getNonFeaturedEvents = StructCopy(getNonFeaturedEvents)>
		<cfset Session.getFeaturedEvents = StructCopy(getFeaturedEvents)>
	</cffunction>

	<cffunction name="eventinfo" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("URL.EventID")>
			<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
				From p_EventRegistration_Events
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
					Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			</cfquery>

			<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Count(TContent_ID) as CurrentNumberofRegistrations
				From p_EventRegistration_UserRegistrations
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getEventFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, GeoCode_Latitude, GeoCode_Longitude, GeoCode_StateLongName
				From p_EventRegistration_Facility
				Where TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getEventFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select RoomName, Capacity
				From p_EventRegistration_FacilityRooms
				Where TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer"> and
					Facility_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfquery name="getFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FName, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getSelectedEvent.Facilitator#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfset Session.EventInfo.SelectedEvent = #StructCopy(getSelectedEvent)#>
			<cfset Session.EventInfo.EventRegistrations = #StructCopy(getCurrentRegistrationsbyEvent)#>
			<cfset Session.EventInfo.EventFacility = #StructCopy(getEventFacility)#>
			<cfset Session.EventInfo.EventFacilityRoom = #StructCopy(getEventFacilityRoom)#>
			<cfset Session.EventInfo.EventFacilitator = #StructCopy(getFacilitator)#>
		<cfelse>

		</cfif>
	</cffunction>

</cfcomponent>