<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
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
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Review Event or Workshop Information</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">Please review the information listed below from the previous screens to make sure everything is correct.</div>
			<hr>
			<uForm:form action="#buildURL('eventcoord:events.addevent_review')#" method="Post" id="AddEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
				submitValue="Add New Event" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="Active" value="1">
				<input type="hidden" name="PerformAction" value="AddNewEvent">
				<uForm:fieldset legend="Event Date and Time">
					<uform:field label="Primary Event Date <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="EventDate" isDisabled="true" value="#Session.UserSuppliedInfo.EventDate#" type="date" inputClass="date" hint="Date of Event, First Date if event has multiple dates." />
					<cfif Session.UserSuppliedInfo.EventSpanDates EQ 1>
						<uform:field label="Second Event Date" name="EventDate1" isDisabled="true" value="#Session.UserSuppliedInfo.EventDate1#" type="date" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." />
						<uform:field label="Third Event Date" name="EventDate2" isDisabled="true" value="#Session.UserSuppliedInfo.EventDate2#" type="date" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." />
						<uform:field label="Fourth Event Date" name="EventDate3" isDisabled="true" value="#Session.UserSuppliedInfo.EventDate3#" type="date" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." />
						<uform:field label="Fifth Event Date" name="EventDate4" isDisabled="true" value="#Session.UserSuppliedInfo.EventDate4#" type="date" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." />
						<uform:field label="Sixth Event Date" name="EventDate5" isDisabled="true" value="#Session.UserSuppliedInfo.EventDate5#" type="date" inputClass="date" hint="Date of Event, Sixth Date if event has multiple dates." />
					</cfif>
					<uform:field label="Registration Deadline <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="Registration_Deadline" isDisabled="true" value="#Session.UserSuppliedInfo.Registration_Deadline#" type="date" inputClass="date" hint="Accept Registration up to this date" />
					<uform:field label="Registration Start Time <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="Registration_BeginTime" isDisabled="true" value="#Session.UserSuppliedInfo.Registration_BeginTime#" type="time" pluginSetup="#timeConfig#" hint="The Beginning Time onSite Registration begins" />
					<uform:field label="Event Start Time <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="Event_StartTime" isDisabled="true" type="time" value="#Session.UserSuppliedInfo.Event_StartTime#" pluginSetup="#timeConfig#" hint="The starting time of this event" />
					<uform:field label="Event End Time <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="Event_EndTime" isDisabled="true" type="time" value="#Session.UserSuppliedInfo.Event_EndTime#" pluginSetup="#timeConfig#" hint="The ending time of this event" />
				</uForm:fieldset>
				<uForm:fieldset legend="Event Description">
					<uform:field label="Event Short Title <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="ShortTitle" isDisabled="true" value="#Session.UserSuppliedInfo.ShortTitle#" maxFieldLength="50" type="text" hint="Short Event Title of Event" />
					<uform:field label="Event Description <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="LongDescription" isDisabled="true" value="#Session.UserSuppliedInfo.LongDescription#" type="textarea" hint="Description of this meeting or event" />
				</uForm:fieldset>
				<uForm:fieldset legend="Event Details">
					<uform:field label="Event Agenda <a href='#buildURL('admin:events.addevent_review##EditEventAgenda')#' class='ui-icon ui-icon-pencil'></a>" name="EventAgenda" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.EventAgenda#" hint="The Agenda if avaialble for this event." />
					<uform:field label="Event Target Audience <a href='#buildURL('admin:events.addevent_review##EditEventTargetAudience')#' class='ui-icon ui-icon-pencil'></a>" name="EventTargetAudience" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.EventTargetAudience#" hint="The Target Audience for this event. Who should come to this event" />
					<uform:field label="Event Strategies <a href='#buildURL('admin:events.addevent_review##EditEventStrategies')#' class='ui-icon ui-icon-pencil'></a>" name="EventStrategies" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.EventStrategies#" hint="The Strategies of this event, if any." />
					<uform:field label="Event Special Instructions <a href='#buildURL('admin:events.addevent_review##EditEventSpecialInstructions')#' class='ui-icon ui-icon-pencil'></a>" name="EventSpecialInstructions" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.EventSpecialInstructions#" hint="If available, any special instructions participants need." />
				</uForm:fieldset>
				<uForm:fieldset legend="Event Speaker(s)">
					<uform:field label="Presenter(s)" name="Presenters" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.EventSpecialInstructions#" hint="If available, Individuals Presenting at this event." />
				</uForm:fieldset>
				<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
					<uForm:fieldset legend="Event Pricing">
						<uform:field label="Member Pricing <a href='#buildURL('admin:events.addevent_step2')#' class='ui-icon ui-icon-pencil'></a>" name="MemberCost" isDisabled="true" type="text" value="#NumberFormat(Session.UserSuppliedInfo.MemberCost, '9999.99')#" hint="The cost for a member school district to attend per person." />
						<uform:field label="NonMember Pricing <a href='#buildURL('admin:events.addevent_step2')#' class='ui-icon ui-icon-pencil'></a>" name="NonMemberCost" isDisabled="true" type="text" value="#NumberFormat(Session.UserSuppliedInfo.NonMemberCost, '9999.99')#" hint="The cost for a nonmember school district to attend per person." />
					</uForm:fieldset>
					<cfif Session.UserSuppliedInfo.ViewSpecialPricing EQ 1>
						<uForm:fieldset legend="Event Special Pricing Information">
						<cfif Session.UserSuppliedInfo.ViewSpecialPricing EQ 1><cfset SpecialPrice_AvailableText = "Yes"><cfelse><cfset SpecialPrice_AvailableText = "No"></cfif>
						<uform:field label="Special Pricing Available <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="ViewSpecialPricing" type="text" isDisabled="true" value="#Variables.SpecialPrice_AvailableText#" hint="Does this event have special pricing available?" />
						<uform:field label="Requirements" name="SpecialPriceRequirements" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.SpecialPriceRequirements#" hint="The requirements a participant must meet to get this price for this event" />
						<uform:field label="Member Pricing" name="SpecialMemberCost" isDisabled="true" type="text" value="#Session.UserSuppliedInfo.SpecialMemberCost#" hint="The Special Price for this event from a Member School Districts" />
						<uform:field label="NonMember Pricing" name="SpecialNonMemberCost" isDisabled="true" type="text" value="#Session.UserSuppliedInfo.SpecialNonMemberCost#" hint="The Special Price for this event from a NonMember School Districts" />
						</uForm:fieldset>
					</cfif>
					<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1>
						<uForm:fieldset legend="Event Early Bird Information">
						<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1><cfset EarlyBird_AvailableText = "Yes"><cfelse><cfset EarlyBird_AvailableText = "No"></cfif>
						<uform:field label="EarlyBird Registration Available <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="EarlyBird_RegistrationAvailable" type="text" isDisabled="true" value="#Variables.EarlyBird_AvailableText#" hint="Does this event have an EarlyBird Registration Cutoff Date/Price" />
						<uform:field label="Early Bird Deadline" name="EarlyBird_RegistrationDeadline" isDisabled="true" type="date" value="#Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline#" hint="The early bird deadline date" />
						<uform:field label="Member Pricing" name="EarlyBird_MemberCost" isDisabled="true" type="text" value="#Session.UserSuppliedInfo.EarlyBird_MemberCost#" hint="The Early Bird Price for this event from a Member School Districts" />
						<uform:field label="NonMember Pricing" name="EarlyBird_NonMemberCost" isDisabled="true" type="text" value="#Session.UserSuppliedInfo.EarlyBird_NonMemberCost#" hint="The Early Bird Price for this event from a NonMember School Districts" />
						</uForm:fieldset>
					</cfif>
					<cfif Session.UserSuppliedInfo.MealProvided EQ 1>
						<cfquery name="getCatererInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select TContent_ID, FacilityName
							From eCaterers
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
								Active = <cfqueryparam value="1" cfsqltype="CF_SQL_BIT"> and
								TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.MealProvidedBy#" cfsqltype="cf_sql_integer">
						</cfquery>
						<uForm:fieldset legend="Event Meal Information">
						<cfif Session.UserSuppliedInfo.MealProvided EQ 1><cfset MealProvided_AvailableText = "Yes"><cfelse><cfset MealProvided_AvailableText = "No"></cfif>
						<uform:field label="Meal Provided <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="MealProvided" type="text" isDisabled="true" value="#Variables.MealProvided_AvailableText#" hint="Does this event have a meal available to attendee(s)?" />
						<uform:field label="Cost Per Person " name="MealCost_Estimated" isDisabled="true" value="#Session.UserSuppliedInfo.MealCost_Estimated#" type="text" hint="The estimated cost per person for providing this meal." />
						<uform:field label="Meal Provided By" name="MealProvidedBy" isDisabled="true" value="#getCatererInformation.FacilityName#" type="text" hint="Which Caterer is providing this meal?" />
						</uForm:fieldset>
					</cfif>
					<cfif Session.UserSuppliedInfo.AllowVideoConference EQ 1>
						<uForm:fieldset legend="Video Conferencing Information">
						<cfif Session.UserSuppliedInfo.AllowVideoConference EQ 1><cfset AllowVideoConference_AvailableText = "Yes"><cfelse><cfset AllowVideoConference_AvailableText = "No"></cfif>
						<uform:field label="Allow Video Conference <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="AllowVideoConference" isDisabled="true" type="text" value="#Variables.AllowVideoConference_AvailableText#" hint="Can an attendee participate with Video Conference (IP Video)?" />
						<uform:field label="Video Conference Details" name="VideoConferenceInfo" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.VideoConferenceInfo#" hint="Information about Video Conference that participants need to know to be able to connect." />
							<uform:field label="Video Confernece Cost" name="VideoConferenceCost" isDisabled="true" type="text" isRequired="true" value="#Session.UserSuppliedInfo.VideoConferenceCost#" hint="What are the costs for a participant to attend via video conference" />
						</uForm:fieldset>
					</cfif>
				</cfif>
				<cfif Session.UserSuppliedInfo.EventFeatured EQ 1>
					<uForm:fieldset legend="Event Featured">
						<cfif Session.UserSuppliedInfo.EventFeatured EQ 1><cfset EventFeatured_AvailableText = "Yes"><cfelse><cfset EventFeatured_AvailableText = "No"></cfif>
						<uform:field label="Event Featured <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="EventFeatured" type="text" isDisabled="true" value="#Variables.EventFeatured_AvailableText#" hint="Would this event be featured on the website?" />
						<uform:field label="Start Date" name="Featured_StartDate" isDisabled="true" type="text" value="#Session.UserSuppliedInfo.Featured_StartDate#" hint="The start date of this event being featured" />
						<uform:field label="End Date" name="Featured_EndDate" isDisabled="true" type="text" value="#Session.UserSuppliedInfo.Featured_EndDate#" hint="The ending date of this event being featured" />
					</uForm:fieldset>
				</cfif>
				<cfif Session.UserSuppliedInfo.PGPAvailable EQ 1>
					<uForm:fieldset legend="Professional Growth Points Information">
						<cfif Session.UserSuppliedInfo.PGPAvailable EQ 1><cfset PGPAvailable_AvailableText = "Yes"><cfelse><cfset PGPAvailable_AvailableText = "No"></cfif>
						<uform:field label="PGP Points Available <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="PGPAvailable" type="text" isDisabled="true" value="#Variables.PGPAvailable_AvailableText#" hint="Does this event have PGP Points for Attendee(s)?" />
						<uform:field label="Number of Points" name="PGPPoints" isDisabled="true" type="text" value="#Session.UserSuppliedInfo.PGPPoints#" hint="The number of PGP Points available to particiapnt upon sucessfull completion of this event." />
					</uForm:fieldset>
				</cfif>
				<cfif Session.UserSuppliedInfo.WebinarEvent EQ 1>
					<uForm:fieldset legend="Event Webinar Information">
						<cfif Session.UserSuppliedInfo.WebinarEvent EQ 1><cfset WebinarEvent_AvailableText = "Yes"><cfelse><cfset WebinarEvent_AvailableText = "No"></cfif>
						<uform:field label="Allow Webinar Conference <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="WebinarEvent" isDisabled="true" type="text" value="#Variables.WebinarEvent_AvailableText#" hint="Can an attendee participate with Webinar Technology?" />
						<uform:field label="Webinar Connection Details" name="WebinarConnectWebInfo" isDisabled="true" type="textarea" value="#Session.UserSuppliedInfo.WebinarConnectWebInfo#" hint="Provide the details for users to be able to connect to this webinar. Give information just incase user has to get viewing device software installed." />
						<uform:field label="Webinar Member Cost" name="WebinarMemberCost" type="text" isDisabled="true" Value="#NumberFormat(Session.UserSuppliedInfo.WebinarMemberCost, '9999.99')#" isRequired="true" hint="What is the cost for a member participant to attend via this method" />
						<uform:field label="Webinar NonMember Cost" name="WebinarNonMemberCost" type="text" isDisabled="true" Value="#NumberFormat(Session.UserSuppliedInfo.WebinarNonMemberCost, '9999.99')#" isRequired="true" hint="What is the cost for a nonmember participant to attend via this method" />
					</uForm:fieldset>
				</cfif>
				<cfif Session.UserSuppliedInfo.WebinarEvent EQ 0>
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
					<uForm:fieldset legend="Facility Room Information">
						<uform:field label="Facility Location <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="LocationIDName" isDisabled="true" type="text" value="#GetFacilityInformation.FacilityName#" hint="Where is this facility being held at?" />
						<uform:field label="Facility Room Name" name="LocationRoomIDName" isDisabled="true" type="text" value="#getFacilityRoomInformation.RoomName#" hint="Which room at this facility would this event be held?" />
						<uform:field label="Maximum Participants" name="RoomMaxParticipants" isDisabled="true" type="text" value="#Session.UserSuppliedInfo.RoomMaxParticipants#" hint="Maximum Participants allowed to register for this event?" />
					</uForm:fieldset>
				</cfif>
				<cfif Session.UserSuppliedInfo.PostEventToFB EQ 1>
					<uForm:fieldset legend="Event Posting to Facebook">
						<cfif Session.UserSuppliedInfo.PostEventToFB EQ 1><cfset EventPostToFB_AvailableText = "Yes"><cfelse><cfset EventPostToFB_AvailableText = "No"></cfif>
						<uform:field label="Post Event To Facebook <a href='#buildURL('admin:events.addevent')#' class='ui-icon ui-icon-pencil'></a>" name="PostEventToFB" type="text" isDisabled="true" value="#Variables.EventPostToFB_AvailableText#" hint="Would this event be posted to the Organization's Facebook Page?" />
					</uForm:fieldset>
					<cfset Session.UserSuppliedInfo.FB = #StructNew()#>
					<cfset Session.UserSuppliedInfo.FB.AppID = "923408481055376">
					<cfset Session.UserSuppliedInfo.FB.AppSecretKey = "95ed34b87333b62d01ef326848ae89fd">
					<cfset Session.UserSuppliedInfo.FB.PageID = "172096152818693">
					<cfset Session.UserSuppliedInfo.FB.AppScope = "email,public_profile,publish_actions">
				</cfif>
				<uForm:fieldset legend="Allow Registrations">
					<uform:field label="Accept Registrations" name="AcceptRegistrations" type="select" hint="Do you want to accept registrations for this event?">
						<uform:option display="Yes" value="1" />
						<uform:option display="No" value="0" isSelected="true" />
					</uform:field>
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>