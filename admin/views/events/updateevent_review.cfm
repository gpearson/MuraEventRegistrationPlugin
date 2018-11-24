<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>

<cfimport taglib="/properties/uniForm/tags/" prefix="uForm">
<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
</cflock>
<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>
<cfoutput>
	<h2>Updating Workshop/Event: #Session.UserSuppliedInfo.ShortTitle#</h2>
	<div class="alert-box notice">Top make changes to the event listed below, simply click on the pencil icon for the category you are wanting to change.</div>
	<hr>
	<uForm:form action="" method="Post" id="UpdateEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
		commonassetsPath="/properties/uniForm/"
		showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
		cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
		submitValue="Update Event" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
		<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
		<input type="hidden" name="formSubmit" value="true">
		<input type="hidden" name="PerformAction" value="UpdateEvent">
		<uForm:fieldset legend="Event Date and Time  <a href='#buildURL('admin:events.updateevent_datetime')#' class='ui-icon ui-icon-pencil'></a>">
			<uform:field label="Primary Event Date" name="EventDate" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, First Date if event has multiple dates." />
			<cfif Session.UserSuppliedInfo.EventSpanDates EQ 1>
				<cfif isDefined("Session.UserSuppliedInfo.EventDate1")><uform:field label="Second Event Date" name="EventDate1" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate1, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." /></cfif>
				<cfif isDefined("Session.UserSuppliedInfo.EventDate2")><uform:field label="Third Event Date" name="EventDate2" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate2, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." /></cfif>
				<cfif isDefined("Session.UserSuppliedInfo.EventDate3")><uform:field label="Fourth Event Date" name="EventDate3" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate3, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." /></cfif>
				<cfif isDefined("Session.UserSuppliedInfo.EventDate4")><uform:field label="Fifth Event Date" name="EventDate4" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate4, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." /></cfif>
				<cfif isDefined("Session.UserSuppliedInfo.EventDate5")><uform:field label="Sixth Event Date" name="EventDate5" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate5, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Sixth Date if event has multiple dates." /></cfif>
			</cfif>
			<uform:field label="Registration Deadline" name="Registration_Deadline" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.Registration_Deadline, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Accept Registration up to this date" />
			<uform:field label="Registration Start Time" name="Registration_BeginTime" isDisabled="true" value="#TimeFormat(Session.UserSuppliedInfo.Registration_BeginTime, 'hh:mm tt')#" type="text" pluginSetup="#timeConfig#" hint="The Beginning Time onSite Registration begins" />
			<uform:field label="Event Start Time" name="Event_StartTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.Event_StartTime, 'hh:mm tt')#" pluginSetup="#timeConfig#" hint="The starting time of this event" />
			<uform:field label="Event End Time" name="Event_EndTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.Event_EndTime, 'hh:mm tt')#" pluginSetup="#timeConfig#" hint="The ending time of this event" />
		</uForm:fieldset>

		<uForm:fieldset legend="Event Description  <a href='#buildURL('admin:events.updateevent_description')#' class='ui-icon ui-icon-pencil'></a>">
			<uform:field label="Event Short Title" name="ShortTitle" isDisabled="true" value="#Session.UserSuppliedInfo.ShortTitle#" maxFieldLength="50" type="text" hint="Short Event Title of Event" />
			<uform:field label="Event Description" name="LongDescription" isDisabled="true" value="#Session.UserSuppliedInfo.LongDescription#" type="textarea" hint="Description of this meeting or event" />
		</uForm:fieldset>

		<uForm:fieldset legend="Event Details  <a href='#buildURL('admin:events.updateevent_details')#' class='ui-icon ui-icon-pencil'></a>">
			<uform:field label="Event Agenda" name="EventAgenda" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.EventAgenda#" hint="The Agenda if avaialble for this event." />
			<uform:field label="Event Target Audience" name="EventTargetAudience" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.EventTargetAudience#" hint="The Target Audience for this event. Who should come to this event" />
			<uform:field label="Event Strategies" name="EventStrategies" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.EventStrategies#" hint="The Strategies of this event, if any." />
			<uform:field label="Event Special Instructions" name="EventSpecialInstructions" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.EventSpecialInstructions#" hint="If available, any special instructions participants need." />
		</uForm:fieldset>

		<uForm:fieldset legend="Event Speaker(s)  <a href='#buildURL('admin:events.updateevent_presenter')#' class='ui-icon ui-icon-pencil'></a>">
			<uform:field label="Presenter(s)" name="Presenters" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.Presenters#" hint="If available, Individuals Presenting at this event." />
		</uFOrm:fieldset>

		<uForm:fieldset legend="Event Pricing  <a href='#buildURL('admin:events.updateevent_pricing')#' class='ui-icon ui-icon-pencil'></a>">
			<uform:field label="Member Pricing" name="MemberCost" isDisabled="true" type="text" value="#NumberFormat(Session.UserSuppliedInfo.MemberCost, '9999.99')#" hint="The cost for a member school district to attend per person." />
			<uform:field label="NonMember Pricing" name="NonMemberCost" isDisabled="true" type="text" value="#NumberFormat(Session.UserSuppliedInfo.NonMemberCost, '9999.99')#" hint="The cost for a nonmember school district to attend per person." />
		</uForm:fieldset>

		<uForm:fieldset legend="Event Special Pricing Information  <a href='#buildURL('admin:events.updateevent_specialprice')#' class='ui-icon ui-icon-pencil'></a>">
			<cfif Session.UserSuppliedInfo.ViewSpecialPricing EQ 1><cfset SpecialPrice_AvailableText = "Yes"><cfelse><cfset SpecialPrice_AvailableText = "No"></cfif>
			<uform:field label="Special Pricing Available" name="ViewSpecialPricing" type="text" isDisabled="true" value="#Variables.SpecialPrice_AvailableText#" hint="Does this event have special pricing available?" />
			<uform:field label="Requirements" name="SpecialPriceRequirements" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.SpecialPriceRequirements#" hint="The requirements a participant must meet to get this price for this event" />
			<uform:field label="Member Pricing" name="SpecialMemberCost" isDisabled="true" type="text" value="#NumberFormat(Session.UserSuppliedInfo.SpecialMemberCost, '9999.99')#" hint="The Special Price for this event from a Member School Districts" />
			<uform:field label="NonMember Pricing" name="SpecialNonMemberCost" isDisabled="true" type="text" value="#NumberFormat(Session.UserSuppliedInfo.SpecialNonMemberCost, '9999.99')#" hint="The Special Price for this event from a NonMember School Districts" />
		</uForm:fieldset>

		<cfif DateFormat(Session.UserSuppliedInfo.Featured_StartDate, 'mm/dd/yyyy') EQ "01/01/1980">
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo.Featured_StartDate = "">
			</cflock>
		</cfif>

		<cfif DateFormat(Session.UserSuppliedInfo.Featured_EndDate, 'mm/dd/yyyy') EQ "01/01/1980">
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo.Featured_EndDate = "">
			</cflock>
		</cfif>

		<uForm:fieldset legend="Event Featured  <a href='#buildURL('admin:events.updateevent_featured')#' class='ui-icon ui-icon-pencil'></a>">
			<cfif Session.UserSuppliedInfo.EventFeatured EQ 1><cfset EventFeatured_AvailableText = "Yes"><cfelse><cfset EventFeatured_AvailableText = "No"></cfif>
			<uform:field label="Event Featured" name="EventFeatured" type="text" isDisabled="true" value="#Variables.EventFeatured_AvailableText#" hint="Would this event be featured on the website?" />
			<uform:field label="Start Date" name="Featured_StartDate" isDisabled="true" type="date" value="#DateFormat(Session.UserSuppliedInfo.Featured_StartDate, 'mm/dd/yyyy')#" hint="The start date of this event being featured" />
			<uform:field label="End Date" name="Featured_EndDate" isDisabled="true" type="date" value="#DateFormat(Session.UserSuppliedInfo.Featured_EndDate, 'mm/dd/yyyy')#" hint="The ending date of this event being featured" />
		</uForm:fieldset>

		<cfif DateFormat(Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline, 'mm/dd/yyyy') EQ "01/01/1980">
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline = "">
			</cflock>
		</cfif>

		<uForm:fieldset legend="Event Early Bird Information  <a href='#buildURL('admin:events.updateevent_earlybirdinfo')#' class='ui-icon ui-icon-pencil'></a>">
			<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1><cfset EarlyBird_AvailableText = "Yes"><cfelse><cfset EarlyBird_AvailableText = "No"></cfif>
			<uform:field label="EarlyBird Registration Available" name="EarlyBird_RegistrationAvailable" type="text" isDisabled="true" value="#Variables.EarlyBird_AvailableText#" hint="Does this event have an EarlyBird Registration Cutoff Date/Price" />
			<uform:field label="Early Bird Deadline" name="EarlyBird_RegistrationDeadline" isDisabled="true" type="date" value="#DateFormat(Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline, 'mm/dd/yyyy')#" hint="The early bird deadline date" />
			<uform:field label="Member Pricing" name="EarlyBird_MemberCost" isDisabled="true" type="text" value="#NumberFormat(Session.UserSuppliedInfo.EarlyBird_MemberCost, '9999.99')#" hint="The Early Bird Price for this event from a Member School Districts" />
			<uform:field label="NonMember Pricing" name="EarlyBird_NonMemberCost" isDisabled="true" type="text" value="#NumberFormat(Session.UserSuppliedInfo.EarlyBird_NonMemberCost, '9999.99')#" hint="The Early Bird Price for this event from a NonMember School Districts" />
		</uForm:fieldset>

		<uForm:fieldset legend="Professional Growth Points Information  <a href='#buildURL('admin:events.updateevent_pgppoints')#' class='ui-icon ui-icon-pencil'></a>">
			<cfif Session.UserSuppliedInfo.PGPAvailable EQ 1><cfset PGPAvailable_AvailableText = "Yes"><cfelse><cfset PGPAvailable_AvailableText = "No"></cfif>
			<uform:field label="PGP Points Available" name="PGPAvailable" type="text" isDisabled="true" value="#Variables.PGPAvailable_AvailableText#" hint="Does this event have PGP Points for Attendee(s)?" />
			<uform:field label="Number of Points" name="PGPPoints" isDisabled="true" type="text" value="#NumberFormat(Session.UserSuppliedInfo.PGPPoints, '999.99')#" hint="The number of PGP Points available to particiapnt upon sucessfull completion of this event." />
		</uForm:fieldset>


		<cfif Session.UserSuppliedInfo.MealProvided EQ 1>
			<cfquery name="getCatererInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName
				From eCaterers
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT"> and
					TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.MealProvidedBy#" cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>
		<uForm:fieldset legend="Event Meal Information  <a href='#buildURL('admin:events.updateevent_mealinfo')#' class='ui-icon ui-icon-pencil'></a>">
			<cfif Session.UserSuppliedInfo.MealProvided EQ 1><cfset MealProvided_AvailableText = "Yes"><cfelse><cfset MealProvided_AvailableText = "No"></cfif>
			<uform:field label="Meal Provided" name="MealProvided" type="text" isDisabled="true" value="#Variables.MealProvided_AvailableText#" hint="Does this event have a meal available to attendee(s)?" />
			<uform:field label="Cost Per Person " name="MealCost_Estimated" isDisabled="true" value="#NumberFormat(Session.UserSuppliedInfo.MealCost_Estimated, '9999.99')#" type="text" hint="The estimated cost per person for providing this meal." />
			<cfif Session.UserSuppliedInfo.MealProvided EQ 1>
				<cfif Session.UserSuppliedInfo.MealProvidedBy EQ 0>
					<uform:field label="Meal Provided By" name="MealProvidedBy" isDisabled="true" value="Vendor/Speaker Provided Meal for Event" type="text" hint="Which Caterer is providing this meal?" />
				<cfelse>
					<uform:field label="Meal Provided By" name="MealProvidedBy" isDisabled="true" value="#getCatererInformation.FacilityName#" type="text" hint="Which Caterer is providing this meal?" />
				</cfif>
			<cfelse>
				<uform:field label="Meal Provided By" name="MealProvidedBy" isDisabled="true" value="#Session.UserSuppliedInfo.MealProvidedBy#" type="text" hint="Which Caterer is providing this meal?" />
			</cfif>
		</uForm:fieldset>

		<uForm:fieldset legend="Video Conferencing Information  <a href='#buildURL('admin:events.updateevent_ivcinfo')#' class='ui-icon ui-icon-pencil'></a>">
			<cfif Session.UserSuppliedInfo.AllowVideoConference EQ 1><cfset AllowVideoConference_AvailableText = "Yes"><cfelse><cfset AllowVideoConference_AvailableText = "No"></cfif>
			<uform:field label="Allow Video Conference" name="AllowVideoConference" isDisabled="true" type="text" value="#Variables.AllowVideoConference_AvailableText#" hint="Can an attendee participate with Video Conference (IP Video)?" />
			<uform:field label="Video Conference Details" name="VideoConferenceInfo" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.VideoConferenceInfo#" hint="Information about Video Conference that participants need to know to be able to connect." />
				<uform:field label="Video Conference Cost" name="VideoConferenceCost" isDisabled="true" type="text" value="#NumberFormat(Session.UserSuppliedInfo.VideoConferenceCost, '9999.99')#" hint="What are the costs for a participant to attend via video conference" />
		</uForm:fieldset>

		<cfquery name="getFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select FacilityName
			From eFacility
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT"> and
				FacilityType = <cfqueryparam value="#Session.UserSuppliedInfo.LocationType#" cfsqltype="cf_sql_varchar"> and
				TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getFacilityRoomInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, RoomName
			From eFacilityRooms
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				Facility_ID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationID#" cfsqltype="cf_sql_integer"> and
				TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.LocationRoomID#" cfsqltype="cf_sql_integer"> and
				Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT">
		</cfquery>

		<uForm:fieldset legend="Facility Room Information  <a href='#buildURL('admin:events.updateevent_facilityinfo')#' class='ui-icon ui-icon-pencil'></a>">
			<uform:field label="Facility Location" name="LocationIDName" isDisabled="true" type="text" value="#GetFacilityInformation.FacilityName#" hint="Where is this facility being held at?" />
			<uform:field label="Facility Room Name" name="LocationRoomIDName" isDisabled="true" type="text" value="#getFacilityRoomInformation.RoomName#" hint="Which room at this facility would this event be held?" />
			<uform:field label="Maximum Participants" name="RoomMaxParticipants" isDisabled="true" type="text" value="#Session.UserSuppliedInfo.RoomMaxParticipants#" hint="Maximum Participants allowed to register for this event?" />
		</uForm:fieldset>

		<uForm:fieldset legend="Allow Registrations">
			<uform:field label="Accept Registrations" name="AcceptRegistrations" type="select" hint="Do you want to accept registrations for this event?">
				<cfif Session.UserSuppliedInfo.AcceptRegistrations EQ 1>
					<uform:option display="Yes" value="1" isSelected="true" />
					<uform:option display="No" value="0" />
				<cfelse>
					<uform:option display="Yes" value="1"/>
					<uform:option display="No" value="0"  isSelected="true"  />
				</cfif>
			</uform:field>
		</uForm:fieldset>
	</uForm:form>
</cfoutput>