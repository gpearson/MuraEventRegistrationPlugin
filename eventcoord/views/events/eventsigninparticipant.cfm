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

<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, EventFeatured, Featured_StartDate, Featured_EndDate, MemberCost, NonMemberCost,  EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Presenters, Facilitator
	From eEvents
	Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
		TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="GetRegisteredUsersForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	SELECT tusers.Fname, tusers.Lname, eRegistrations.UserID
	FROM eRegistrations INNER JOIN tusers ON tusers.UserID = eRegistrations.UserID
	WHERE eRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
		eRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
		eRegistrations.AttendedEvent = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
	ORDER BY tusers.Lname ASC, tusers.Fname ASC
</cfquery>

<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>

<cfoutput>
	<cfif GetRegisteredUsersForEvent.RecordCount EQ 0>
		<h2 align="Center">Sign In Participant for Workshop/Event:<br>#getSelectedEvent.ShortTitle#</h2>
		<div class="alert-box notice">You have electronically signed in everyone who has registrered for this event. Please click on one of the navigation menu items above to perform another action.</div>
		<hr>
	<cfelseif not isDefined("URL.UserAction") and not isDefined("URL.Records")>
		<h2 align="Center">Sign In Participant for Workshop/Event:<br>#getSelectedEvent.ShortTitle#</h2>
		<div class="alert-box notice">Please complete this form to electronically signin a participant for this event.</div>
		<hr>
		<cfif ArrayLen(Session.FormErrors)>
			<div class="alert-box error">Please select atleast one participant that needs to be electronically signin to this event.</div>
			<cfset Session.FormErrors = #ArrayNew()#>
		</cfif>
		<cfif isDefined("URL.Successful") and isDefined("URL.UserAction")>
			<cfif URL.Successful EQ "True" and URL.UserAction EQ "SignInParticipant">
				<div class="alert-box success">You have successfully electronically signed in participants for this event. Below are still participants who are currently not in attendance.</div>
			</cfif>

		</cfif>
		<Form method="Post" action="" id="">
			<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<input type="hidden" name="EventID" value="#URL.EventID#">
			<input type="hidden" name="formSubmit" value="true">
			<table class="art-article" border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 99%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
							<cfif GetRegisteredUsersForEvent.RecordCount>
							<table class="art-article" style="width: 100%;">
								<thead>
									<tr>
										<td colspan="4" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
											<strong>Registered User Accounts</strong>
										</td>
									</tr>
								</thead>
								<tbody>
									<cfloop query="GetRegisteredUsersForEvent">
									<cfset CurrentModRow = #GetRegisteredUsersForEvent.CurrentRow# MOD 4>
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr width="25%"><td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#GetRegisteredUsersForEvent.UserID#">&nbsp;&nbsp;#GetRegisteredUsersForEvent.Lname#, #GetRegisteredUsersForEvent.Fname#</cfoutput></td>
										</cfcase>
										<cfcase value="0">
											<td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#GetRegisteredUsersForEvent.UserID#">&nbsp;&nbsp;#GetRegisteredUsersForEvent.Lname#, #GetRegisteredUsersForEvent.Fname#</cfoutput></td></tr>
										</cfcase>
										<cfdefaultcase>
											<td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#GetRegisteredUsersForEvent.UserID#">&nbsp;&nbsp;#GetRegisteredUsersForEvent.Lname#, #GetRegisteredUsersForEvent.Fname#</cfoutput></td>
										</cfdefaultcase>
									</cfswitch>
									</cfloop>
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="0"></cfcase>
										<cfcase value="1"><td colspan="3">&nbsp;</td></tr></cfcase>
										<cfdefaultcase><td width="25%">&nbsp;</td></tr></cfdefaultcase>
									</cfswitch>
								</tbody>
							</table>
							</cfif>
						</td>
					</tr>
					<tr>
						<td><input type="Submit" Name="PerformAction" class="art-button" value="SignIn Participant(s)"></td>
					</tr>
				</tbody>
			</table>
		</form>
	<cfelseif isDefined("URL.UserAction") and isDefined("URL.Successful")>
		<h2 align="Center">Sign In Participant for Workshop/Event:<br>#getSelectedEvent.ShortTitle#</h2>
		<div class="alert-box notice">Please complete this form to electronically signin a participant for this event.</div>
		<hr>
		<cfif ArrayLen(Session.FormErrors)>
			<div class="alert-box error">Please select atleast one participant that needs to be electronically signin to this event.</div>
			<cfset Session.FormErrors = #ArrayNew()#>
		</cfif>
		<cfif isDefined("URL.Successful") and isDefined("URL.UserAction")>
			<cfif URL.Successful EQ "True" and URL.UserAction EQ "SignInParticipant">
				<div class="alert-box success">You have successfully electronically signed in participants for this event. Below are still participants who are currently not in attendance.</div>
			</cfif>

		</cfif>
		<Form method="Post" action="" id="">
			<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<input type="hidden" name="EventID" value="#URL.EventID#">
			<input type="hidden" name="formSubmit" value="true">
			<table class="art-article" border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 99%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
							<cfif GetRegisteredUsersForEvent.RecordCount>
							<table class="art-article" style="width: 100%;">
								<thead>
									<tr>
										<td colspan="4" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
											<strong>Registered User Accounts</strong>
										</td>
									</tr>
								</thead>
								<tbody>
									<cfloop query="GetRegisteredUsersForEvent">
									<cfset CurrentModRow = #GetRegisteredUsersForEvent.CurrentRow# MOD 4>
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr width="25%"><td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#GetRegisteredUsersForEvent.UserID#">&nbsp;&nbsp;#GetRegisteredUsersForEvent.Lname#, #GetRegisteredUsersForEvent.Fname#</cfoutput></td>
										</cfcase>
										<cfcase value="0">
											<td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#GetRegisteredUsersForEvent.UserID#">&nbsp;&nbsp;#GetRegisteredUsersForEvent.Lname#, #GetRegisteredUsersForEvent.Fname#</cfoutput></td></tr>
										</cfcase>
										<cfdefaultcase>
											<td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#GetRegisteredUsersForEvent.UserID#">&nbsp;&nbsp;#GetRegisteredUsersForEvent.Lname#, #GetRegisteredUsersForEvent.Fname#</cfoutput></td>
										</cfdefaultcase>
									</cfswitch>
									</cfloop>
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="0"></cfcase>
										<cfcase value="1"><td colspan="3">&nbsp;</td></tr></cfcase>
										<cfdefaultcase><td width="25%">&nbsp;</td></tr></cfdefaultcase>
									</cfswitch>
								</tbody>
							</table>
							</cfif>
						</td>
					</tr>
					<tr>
						<td><input type="Submit" Name="PerformAction" class="art-button" value="SignIn Participant(s)"></td>
					</tr>
				</tbody>
			</table>
		</form>
	</cfif>
</cfoutput>