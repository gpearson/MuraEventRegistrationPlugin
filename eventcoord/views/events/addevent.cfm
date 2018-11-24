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
	<cfset Session.FormErrors = #ArrayNew()#>
	<cfif not isDefined("Session.UserSuppliedInfo")><cfset Session.UserSuppliedInfo = #StructNew()#></cfif>
</cflock>
<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>
<cfoutput>
	<script>
		$(function() {
			$("##EventDate").datepicker();
			$("##Registration_Deadline").datepicker();
			$("##Registration_BeginTime").timepicker({
				timeFormat: 'hh:mm tt',
				controlType: 'select'
			});
			$("##Event_StartTime").timepicker({
				timeFormat: 'hh:mm tt',
				controlType: 'select'
			});
			$("##Event_EndTime").timepicker({
				timeFormat: 'hh:mm tt',
				controlType: 'select'
			});
		});
	</script>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Add new Event or Workshop</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for.</div>
			<hr>
			<uForm:form action="" method="Post" id="AddEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
				submitValue="Proceed To Step 2" loadValidation="true" loadMaskUI="true" loadDateUI="false"
				loadTimeUI="false">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="AcceptRegistrations" value="0">
				<input type="hidden" name="Registration_EndTime" value="0">
				<input type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
				<input type="hidden" name="PerformAction" value="Step2">
				<uForm:fieldset legend="Event Date and Time">
					<cfif isDefined("Session.UserSuppliedInfo.EventDate")>
						<uform:field label="Primary Event Date" name="EventDate" id="EventDate" isRequired="true" value="#Session.UserSuppliedInfo.EventDate#" type="date" hint="Date of Event, First Date if event has multiple dates." />
					<cfelse>
						<uform:field label="Primary Event Date" name="EventDate" id="EventDate" isRequired="true" type="date" hint="Date of Event, First Date if event has multiple dates." />
					</cfif>
					<uform:field label="Event Span Dates" name="EventSpanDates" type="select" hint="Does this event span multiple dates">
						<cfif isDefined("Session.UserSuppliedInfo.EventSpanDates")>
							<cfif Session.UserSuppliedInfo.EventSpanDates EQ true>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>

					<cfif isDefined("Session.UserSuppliedInfo.Registration_Deadline")>
						<uform:field label="Registration Deadline" name="Registration_Deadline" isRequired="true" value="#Session.UserSuppliedInfo.Registration_Deadline#" type="date" inputClass="date" hint="Accept Registration up to this date" />
					<cfelse>
						<uform:field label="Registration Deadline" name="Registration_Deadline" isRequired="true" type="date" inputClass="date" hint="Accept Registration up to this date" />
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.Registration_BeginTime")>
						<uform:field label="Registration Start Time" name="Registration_BeginTime" isRequired="false" value="#Session.UserSuppliedInfo.Registration_BeginTime#" type="time" pluginSetup="#timeConfig#" hint="The Beginning Time onSite Registration begins" />
					<cfelse>
						<uform:field label="Registration Start Time" name="Registration_BeginTime" isRequired="false" type="time" pluginSetup="#timeConfig#" hint="The Beginning Time onSite Registration begins" />
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.Event_StartTime")>
						<uform:field label="Event Start Time" name="Event_StartTime" isRequired="true" type="time" value="#Session.UserSuppliedInfo.Event_StartTime#" pluginSetup="#timeConfig#" hint="The starting time of this event" />
					<cfelse>
						<uform:field label="Event Start Time" name="Event_StartTime" isRequired="true" type="time" pluginSetup="#timeConfig#" hint="The starting time of this event" />
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.Event_EndTime")>
						<uform:field label="Event End Time" name="Event_EndTime" isRequired="true" type="time" value="#Session.UserSuppliedInfo.Event_EndTime#" pluginSetup="#timeConfig#" hint="The starting time of this event" />
					<cfelse>
						<uform:field label="Event End Time" name="Event_EndTime" isRequired="true" type="time" pluginSetup="#timeConfig#" hint="The starting time of this event" />
					</cfif>
				</uForm:fieldset>

				<uForm:fieldset legend="Event Description">
					<cfif isDefined("Session.UserSuppliedInfo.ShortTitle")>
						<uform:field label="Event Short Title" name="ShortTitle" isRequired="true" value="#Session.UserSuppliedInfo.ShortTitle#" type="text" hint="Short Event Title of Event" />
					<cfelse>
						<uform:field label="Event Short Title" name="ShortTitle" isRequired="true" type="text" hint="Short Event Title of Event" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.LongDescription")>
						<uform:field label="Event Description" name="LongDescription" isRequired="true" value="#Session.UserSuppliedInfo.LongDescription#" type="textarea" hint="Description of this meeting or event" />
					<cfelse>
						<uform:field label="Event Description" name="LongDescription" isRequired="true" type="textarea" hint="Description of this meeting or event" />
					</cfif>
				</uForm:fieldset>

				<uForm:fieldset legend="Event Features">
					<uform:field label="Event Featured" name="EventFeatured" type="select" hint="Would this event be featured on the website?">
						<cfif isDefined("Session.UserSuppliedInfo.EventFeatured")>
							<cfif Session.UserSuppliedInfo.EventFeatured EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="EarlyBird Registration Available" name="EarlyBird_RegistrationAvailable" type="select" hint="Does this event have an EarlyBird Registration Cutoff Date/Price">
						<cfif isDefined("Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable")>
							<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="Special Pricing Available" name="ViewSpecialPricing" type="select" hint="Does this event have special pricing available?">
						<cfif isDefined("Session.UserSuppliedInfo.ViewSpecialPricing")>
							<cfif Session.UserSuppliedInfo.ViewSpecialPricing EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="PGP Points Available" name="PGPAvailable" type="select" hint="Does this event have PGP Points for Attendee(s)?">
						<cfif isDefined("Session.UserSuppliedInfo.PGPAvailable")>
							<cfif Session.UserSuppliedInfo.PGPAvailable EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="Meal Provided" name="MealProvided" type="select" hint="Does this event have a meal available to attendee(s)?">
						<cfif isDefined("Session.UserSuppliedInfo.MealProvided")>
							<cfif Session.UserSuppliedInfo.MealProvided EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="Allow Video Conference" name="AllowVideoConference" type="select" hint="Can an attendee participate with Video Conference (IP Video)?">
						<cfif isDefined("Session.UserSuppliedInfo.AllowVideoConference")>
							<cfif Session.UserSuppliedInfo.AllowVideoConference EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>

					<uform:field label="Webinar Event Only" name="WebinarEvent" type="select" hint="Is this event an online only event utilizing webinar technology">
						<cfif isDefined("Session.UserSuppliedInfo.WebinarEvent")>
							<cfif Session.UserSuppliedInfo.WebinarEvent EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="Post to Facebook Page" name="PostEventToFB" type="select" hint="Do you want to post this event to Facebook Timeline?">
						<cfif isDefined("Session.UserSuppliedInfo.PostEventToFB")>
							<cfif Session.UserSuppliedInfo.PostEventToFB EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="Location for Event" name="LocationType" type="select" hint="What type of Facility will this event be held at?">
						<cfif isDefined("Session.UserSuppliedInfo.LocationType")>
							<cfif Session.UserSuppliedInfo.LocationType EQ "S">
								<uform:option display="School District" value="S" isSelected="true" />
								<uform:option display="Business Facility" value="B" />
							<cfelse>
								<uform:option display="School District" value="S" />
								<uform:option display="Business Facility" value="B" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="School District" value="S" />
							<uform:option display="Business Facility" value="B" isSelected="true" />
						</cfif>
					</uform:field>
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>