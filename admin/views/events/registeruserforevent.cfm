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

<cfoutput>
	<cfif not isDefined("URL.EventStatus") and not isDefined("URL.Records")>
		<cfquery name="GetMembershipOrganizations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active
			From eMembership
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			Order by OrganizationName
		</cfquery>
		<h2 align="Center">Registering Participant for Workshop/Event:<br>#Session.UserSuppliedInfo.ShortTitle#</h2>
		<div class="alert-box notice">Please complete this form to register user(s) to this event.</div>
		<hr>
		<uForm:form action="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=CorporationSelected" method="Post" id="RegisterParticipants" errors="#Session.FormErrors#" errorMessagePlacement="both"
			commonassetsPath="/properties/uniForm/"
			showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
			cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
			submitValue="Register Participants" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
			<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<input type="hidden" name="formSubmit" value="true">
			<input type="hidden" name="PerformAction" value="ListParticipantsInOrganization">
			<cfif Session.UserSuppliedInfo.WebinarAvailable EQ 0>
				<input type="hidden" name="WebinarParticipant" value="0">
			</cfif>
			<uForm:fieldset legend="Event Date and Time">
				<uform:field label="Primary Event Date" name="EventDate" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, First Date if event has multiple dates." />
				<cfif Session.UserSuppliedInfo.EventSpanDates EQ 1>
					<uform:field label="Second Event Date" name="EventDate1" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate1, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." />
					<uform:field label="Third Event Date" name="EventDate2" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate2, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." />
					<uform:field label="Fourth Event Date" name="EventDate3" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate3, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." />
					<uform:field label="Fifth Event Date" name="EventDate4" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate4, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." />
					<uform:field label="Sixth Event Date" name="EventDate5" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate5, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Sixth Date if event has multiple dates." />
				</cfif>
				<uform:field label="Registration Deadline" name="Registration_Deadline" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.Registration_Deadline, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Accept Registration up to this date" />
				<uform:field label="Registration Start Time" name="Registration_BeginTime" isDisabled="true" value="#TimeFormat(Session.UserSuppliedInfo.Registration_BeginTime, 'hh:mm tt')#" type="text" hint="The Beginning Time onSite Registration begins" />
				<uform:field label="Event Start Time" name="Event_StartTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.Event_StartTime, 'hh:mm tt')#" hint="The starting time of this event" />
				<uform:field label="Event End Time" name="Event_EndTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.Event_EndTime, 'hh:mm tt')#" hint="The ending time of this event" />
			</uForm:fieldset>
			<uForm:fieldset legend="Event Description">
				<uform:field label="Event Short Title" name="ShortTitle" isDisabled="true" value="#Session.UserSuppliedInfo.ShortTitle#" maxFieldLength="50" type="text" hint="Short Event Title of Event" />
				<uform:field label="Event Description" name="LongDescription" isDisabled="true" value="#Session.UserSuppliedInfo.LongDescription#" type="textarea" hint="Description of this meeting or event" />
			</uForm:fieldset>
			<cfif Session.UserSuppliedInfo.WebinarAvailable EQ 1>
				<uForm:fieldset legend="Webinar Available">
					<uform:field label="Participating via Webinar" name="WebinarParticipant" type="select" isRequired="true" hint="Will everyone you register be participating via Webinar?">
						<uform:option display="No" value="0" isSelected="true" />
						<uform:option display="Yes" value="1" isSelected="false" />
					</uform:field>
				</uForm:fieldset>
			</cfif>
			<cfif Session.UserSuppliedInfo.LocationID GT 0>
				<uForm:fieldset legend="Participate at Facility">
					<uform:field label="Participating at Facility" name="FacilityParticipant" type="select" isRequired="true" hint="Will everyone you register be participating at the Facility Location?">
						<uform:option display="No" value="0" isSelected="true" />
						<uform:option display="Yes" value="1" isSelected="false" />
					</uform:field>
				</uForm:fieldset>
			</cfif>
			<uForm:fieldset legend="Email Confirmation">
				<uform:field label="Send Email Confirmations" name="EmailConfirmations" type="select" isRequired="true" hint="Do you want to send an email confirmation to participants about registering for this event?">
						<uform:option display="No" value="0" isSelected="true" />
						<uform:option display="Yes" value="1" isSelected="false" />
					</uform:field>
			</uForm:fieldset>
			<uForm:fieldset legend="School District">
				<uform:field label="District Name" name="DistrictName" type="select" isRequired="true" hint="Which School District does user work at?">
					<uform:option display="Business Organization" value="0" isSelected="true" />
					<cfloop query="GetMembershipOrganizations">
						<uform:option display="#GetMembershipOrganizations.OrganizationName#" value="#GetMembershipOrganizations.OrganizationDomainName#" isSelected="false" />
					</cfloop>
				</uform:field>
			</uForm:fieldset>
		</uForm:form>
	<cfelseif isDefined("URL.EventID") and isDefined("URL.EventStatus")>
		<cfdump var="#Session.UserSuppliedInfo#">
		<p>registeruserforevent admin view</p>
	</cfif>
	<!---
	<cfelseif isDefined("URL.EventID") and isDefined("URL.EventStatus")>
		<cfdump var="#FORM#">
		<cfabort>
	<cfelseif isDefined("URL.UserAction") and isDefined("URL.Records")>
		<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, EventFeatured, Featured_StartDate, Featured_EndDate, MemberCost, NonMemberCost,  EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Presenters, Facilitator
			From eEvents
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				TContent_ID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
		</cfquery>
		<div align="center"><h4>Registering Participants for Event: #getSelectedEvent.ShortTitle#</h4></div>
		<p class="alert-box notice">Please complete the following information to register participants for this event. Each participant will receive a confirmation email that they have been registered for this event by you.</p>
		<hr>
		<Form method="Post" action="" id="">
			<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<input type="hidden" name="EventID" value="#Session.UserSuppliedInfo.RecNo#">
			<input type="hidden" name="formSubmit" value="true">
			<input type="hidden" name="FacilityParticipant" value="#Session.UserSuppliedInfo.FORMData.FacilityParticipant#">
			<input type="hidden" name="EmailConfirmations" value="#Session.UserSuppliedInfo.FORMData.EmailConfirmations#">
			<input type="hidden" name="DistrictName" value="#Session.UserSuppliedInfo.FORMData.DistrictName#">
			<cfif isDefined("Session.FormData.WebinarParticipant")><input type="Hidden" Name="WebinarParticipant" Value="#Session.FormData.WebinarParticipant#"></cfif>
			<table class="art-article" border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 99%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
							<cfquery name="GetSelectedAccountsWithinOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select UserID, Fname, Lname, Email
								From tusers
								Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									Email LIKE '%#Session.UserSuppliedInfo.FormData.DistrictName#%'
								Order by Lname, Fname
							</cfquery>
							<cfif GetSelectedAccountsWithinOrganization.RecordCount>
							<table class="art-article" style="width: 100%;">
								<thead>
									<tr>
										<td colspan="4" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
											<strong>Registered User Accounts</strong> (Individuals in Green already Registered)
										</td>
									</tr>
								</thead>
								<tbody>
										<cfloop query="GetSelectedAccountsWithinOrganization">
										<cfquery name="CheckUserAlreadyRegistered" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select TContent_ID
											From eRegistrations
											Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
												User_ID = <cfqueryparam value="#GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar"> and
												EventID = <cfqueryparam value="#Session.UserSuppliedInfo.RecNo#" cfsqltype="cf_sql_integer">
										</cfquery>
										<cfset CurrentModRow = #GetSelectedAccountsWithinOrganization.CurrentRow# MOD 4>
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr width="25%"><td <cfif CheckUserAlreadyRegistered.RecordCount>Style="border-width: 1px; padding: 1px; border-style: none; border-color: gray; background-color: white; -moz-border-radius: ; Color: ##009900;"</cfif>><cfoutput><input type="CheckBox" Name="additionalParticipants" Value="#GetSelectedAccountsWithinOrganization.UserID#" <cfif CheckUserAlreadyRegistered.RecordCount>disabled </cfif><cfif GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID>checked</cfif>>&nbsp;&nbsp;#GetSelectedAccountsWithinOrganization.Lname#, #GetSelectedAccountsWithinOrganization.Fname#</cfoutput></td>
											</cfcase>
											<cfcase value="0">
												<td width="25%" <cfif CheckUserAlreadyRegistered.RecordCount>Style="border-width: 1px; padding: 1px; border-style: none; border-color: gray; background-color: white; -moz-border-radius: ; Color: ##009900;"</cfif>><cfoutput><input type="CheckBox" Name="additionalParticipants" Value="#GetSelectedAccountsWithinOrganization.UserID#" <cfif CheckUserAlreadyRegistered.RecordCount>disabled </cfif><cfif GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID>checked</cfif>>&nbsp;&nbsp;#GetSelectedAccountsWithinOrganization.Lname#, #GetSelectedAccountsWithinOrganization.Fname#</cfoutput></td></tr>
											</cfcase>
											<cfdefaultcase>
												<td width="25%" <cfif CheckUserAlreadyRegistered.RecordCount>Style="border-width: 1px; padding: 1px; border-style: none; border-color: gray; background-color: white; -moz-border-radius: ; Color: ##009900;"</cfif>><cfoutput><input type="CheckBox" Name="additionalParticipants" Value="#GetSelectedAccountsWithinOrganization.UserID#" <cfif CheckUserAlreadyRegistered.RecordCount>disabled </cfif><cfif GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID>checked</cfif>>&nbsp;&nbsp;#GetSelectedAccountsWithinOrganization.Lname#, #GetSelectedAccountsWithinOrganization.Fname#</cfoutput></td>
											</cfdefaultcase>
										</cfswitch>
										</cfloop>
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="0"></cfcase>
											<cfcase value="1"><td colspan="2">&nbsp;</td></tr></cfcase>
											<cfdefaultcase><td width="25%">&nbsp;</td></tr></cfdefaultcase>
										</cfswitch>
								</tbody>
							</table>
							</cfif>
							<table class="art-article" style="width: 100%;">
								<thead>
									<tr>
										<td colspan="2" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
											<strong>First Additional Participant's Information <cfif GetSelectedAccountsWithinOrganization.RecordCount>(Not Checked Above)</cfif></strong>
										</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td width="25%">First Name</td>
										<td><input type="Text" name="AdditionalParticipant_1_FirstName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Last Name</td>
										<td><input type="Text" name="AdditionalParticipant_1_LastName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Email Address</td>
										<td><input type="Text" name="AdditionalParticipant_1_EMail" maxlength="150" size="50"></td>
									</tr>
									<cfif getSelectedEvent.MealProvided EQ "True">
										<tr>
										<td width="25%">Staying for Meal?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_1_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_1_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
									<cfif getSelectedEvent.AllowVideoConference EQ "True">
										<tr>
										<td width="25%">Participate via Distance Education?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_1_IPVideo" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_1_IPVideo" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
								</tbody>
							</table>
							<table class="art-article" style="width: 100%;">
								<thead>
									<tr>
										<td colspan="2" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
											<strong>Second Additional Participant's Information <cfif GetSelectedAccountsWithinOrganization.RecordCount>(Not Checked Above)</cfif></strong>
										</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td width="25%">First Name</td>
										<td><input type="Text" name="AdditionalParticipant_2_FirstName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Last Name</td>
										<td><input type="Text" name="AdditionalParticipant_2_LastName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Email Address</td>
										<td><input type="Text" name="AdditionalParticipant_2_EMail" maxlength="150" size="50"></td>
									</tr>
									<cfif getSelectedEvent.MealProvided EQ "True">
										<tr>
										<td width="25%">Staying for Meal?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_2_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_2_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
									<cfif getSelectedEvent.AllowVideoConference EQ "True">
										<tr>
										<td width="25%">Participate via Distance Education?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_2_IPVideo" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_2_IPVideo" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
								</tbody>
							</table>
							<table class="art-article" style="width: 100%;">
								<thead>
									<tr>
										<td colspan="2" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
											<strong>Third Additional Participant's Information <cfif GetSelectedAccountsWithinOrganization.RecordCount>(Not Checked Above)</cfif></strong>
										</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td width="25%">First Name</td>
										<td><input type="Text" name="AdditionalParticipant_3_FirstName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Last Name</td>
										<td><input type="Text" name="AdditionalParticipant_3_LastName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Email Address</td>
										<td><input type="Text" name="AdditionalParticipant_3_EMail" maxlength="150" size="50"></td>
									</tr>
									<cfif getSelectedEvent.MealProvided EQ "True">
										<tr>
										<td width="25%">Staying for Meal?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_3_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_3_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
									<cfif getSelectedEvent.AllowVideoConference EQ "True">
										<tr>
										<td width="25%">Participate via Distance Education?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_3_IPVideo" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_3_IPVideo" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
								</tbody>
							</table>
							<table class="art-article" style="width: 100%;">
								<thead>
									<tr>
										<td colspan="2" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
											<strong>Fourth Additional Participant's Information <cfif GetSelectedAccountsWithinOrganization.RecordCount>(Not Checked Above)</cfif></strong>
										</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td width="25%">First Name</td>
										<td><input type="Text" name="AdditionalParticipant_4_FirstName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Last Name</td>
										<td><input type="Text" name="AdditionalParticipant_4_LastName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Email Address</td>
										<td><input type="Text" name="AdditionalParticipant_4_EMail" maxlength="150" size="50"></td>
									</tr>
									<cfif getSelectedEvent.MealProvided EQ "True">
										<tr>
										<td width="25%">Staying for Meal?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_4_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_4_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
									<cfif getSelectedEvent.AllowVideoConference EQ "True">
										<tr>
										<td width="25%">Participate via Distance Education?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_4_IPVideo" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_4_IPVideo" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
								</tbody>
							</table>
							<table class="art-article" style="width: 100%;">
								<thead>
									<tr>
										<td colspan="2" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
											<strong>Fifth Additional Participant's Information <cfif GetSelectedAccountsWithinOrganization.RecordCount>(Not Checked Above)</cfif></strong>
										</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td width="25%">First Name</td>
										<td><input type="Text" name="AdditionalParticipant_5_FirstName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Last Name</td>
										<td><input type="Text" name="AdditionalParticipant_5_LastName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Email Address</td>
										<td><input type="Text" name="AdditionalParticipant_5_EMail" maxlength="150" size="50"></td>
									</tr>
									<cfif getSelectedEvent.MealProvided EQ "True">
										<tr>
										<td width="25%">Staying for Meal?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_5_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_5_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
									<cfif getSelectedEvent.AllowVideoConference EQ "True">
										<tr>
										<td width="25%">Participate via Distance Education?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_5_IPVideo" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_5_IPVideo" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
								</tbody>
							</table>
							<table class="art-article" style="width: 100%;">
								<thead>
									<tr>
										<td colspan="2" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
											<strong>Sixth Additional Participant's Information <cfif GetSelectedAccountsWithinOrganization.RecordCount>(Not Checked Above)</cfif></strong>
										</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td width="25%">First Name</td>
										<td><input type="Text" name="AdditionalParticipant_6_FirstName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Last Name</td>
										<td><input type="Text" name="AdditionalParticipant_6_LastName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Email Address</td>
										<td><input type="Text" name="AdditionalParticipant_6_EMail" maxlength="150" size="50"></td>
									</tr>
									<cfif getSelectedEvent.MealProvided EQ "True">
										<tr>
										<td width="25%">Staying for Meal?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_6_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_6_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
									<cfif getSelectedEvent.AllowVideoConference EQ "True">
										<tr>
										<td width="25%">Participate via Distance Education?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_6_IPVideo" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_6_IPVideo" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
								</tbody>
							</table>
							<table class="art-article" style="width: 100%;">
								<thead>
									<tr>
										<td colspan="2" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
											<strong>Seventh Additional Participant's Information <cfif GetSelectedAccountsWithinOrganization.RecordCount>(Not Checked Above)</cfif></strong>
										</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td width="25%">First Name</td>
										<td><input type="Text" name="AdditionalParticipant_7_FirstName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Last Name</td>
										<td><input type="Text" name="AdditionalParticipant_7_LastName" maxlength="50" size="50"></td>
									</tr>
									<tr>
										<td width="25%">Email Address</td>
										<td><input type="Text" name="AdditionalParticipant_7_EMail" maxlength="150" size="50"></td>
									</tr>
									<cfif getSelectedEvent.MealProvided EQ "True">
										<tr>
										<td width="25%">Staying for Meal?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_7_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_7_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
									<cfif getSelectedEvent.AllowVideoConference EQ "True">
										<tr>
										<td width="25%">Participate via Distance Education?</td>
										<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_7_IPVideo" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_7_IPVideo" value="0">&nbsp;&nbsp;No</td></tr></table></td>
										</tr>
									</cfif>
								</tbody>
							</table>
							<table class="art-article" style="width: 100%;">
								<thead></thead>
								<tbody>
									<tr>
										<td align="right"><input type="submit" class="art-button" value="Register Additional People" name="RegisterAdditionalPeople"></td>
									</tr>
								</tbody>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
		</Form>
	</cfif> --->
</cfoutput>