<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>

<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">

<cfoutput>
	<cfif not isDefined("URL.EventStatus") and not isDefined("URL.Records")>
		<cflock timeout="60" scope="SESSION" type="Exclusive">
			<cfset Session.FormData = #StructNew()#>
			<cfset Session.FormErrors = #ArrayNew()#>
		</cflock>
		<cfquery name="GetMembershipOrganizations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active
			From eMembership
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			Order by OrganizationName
		</cfquery>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Registering Participant for Workshop/Event: #Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h3>
			</div>
			<div class="art-blockcontent">
				<div class="alert-box notice">Please complete this form to register user(s) to this event.</div>
				<hr>
				<uForm:form action="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=CorporationSelected" method="Post" id="RegisterParticipants" errors="#Session.FormErrors#" errorMessagePlacement="both"
					commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
					cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
					submitValue="Register Participants" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
					<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
					<input type="hidden" name="formSubmit" value="true">
					<input type="hidden" name="PerformAction" value="ListParticipantsInOrganization">
					<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 0>
						<input type="hidden" name="WebinarParticipant" value="0">
					</cfif>
					<uForm:fieldset legend="Event Date and Time">
						<uform:field label="Primary Event Date" name="EventDate" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, First Date if event has multiple dates." />
						<cfif Session.UserSuppliedInfo.PickedEvent.EventSpanDates EQ 1>
							<uform:field label="Second Event Date" name="EventDate1" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate1, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." />
							<uform:field label="Third Event Date" name="EventDate2" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate2, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." />
							<uform:field label="Fourth Event Date" name="EventDate3" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate3, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." />
							<uform:field label="Fifth Event Date" name="EventDate4" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate4, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." />
							<uform:field label="Sixth Event Date" name="EventDate5" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate5, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Sixth Date if event has multiple dates." />
						</cfif>
						<uform:field label="Registration Deadline" name="Registration_Deadline" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.PickedEvent.Registration_Deadline, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Accept Registration up to this date" />
						<uform:field label="Registration Start Time" name="Registration_BeginTime" isDisabled="true" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Registration_BeginTime, 'hh:mm tt')#" type="text" hint="The Beginning Time onSite Registration begins" />
						<uform:field label="Event Start Time" name="Event_StartTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Event_StartTime, 'hh:mm tt')#" hint="The starting time of this event" />
						<uform:field label="Event End Time" name="Event_EndTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.PickedEvent.Event_EndTime, 'hh:mm tt')#" hint="The ending time of this event" />
					</uForm:fieldset>
					<uForm:fieldset legend="Event Description">
						<uform:field label="Event Short Title" name="ShortTitle" isDisabled="true" value="#Session.UserSuppliedInfo.PickedEvent.ShortTitle#" maxFieldLength="50" type="text" hint="Short Event Title of Event" />
						<uform:field label="Event Description" name="LongDescription" isDisabled="true" value="#Session.UserSuppliedInfo.PickedEvent.LongDescription#" type="textarea" hint="Description of this meeting or event" />
					</uForm:fieldset>
					<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
						<uForm:fieldset legend="Webinar Available">
							<uform:field label="Participating via Webinar" name="WebinarParticipant" type="select" isRequired="true" hint="Will everyone you register be participating via Webinar?">
								<uform:option display="No" value="0" isSelected="true" />
								<uform:option display="Yes" value="1" isSelected="false" />
							</uform:field>
						</uForm:fieldset>
					</cfif>
					<cfif Session.UserSuppliedInfo.PickedEvent.LocationID GT 0 and Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
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
			</div>
		</div>
	<cfelseif isDefined("URL.EventID") and isDefined("URL.EventStatus")>
		<cfswitch expression="#URL.EventStatus#">
					<cfcase value="CorporationSelected">
						<cfif Session.UserSuppliedInfo.EventRegistration.NumberOfUserAccountsWithinOrganization EQ 0>
							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipantsToEvent" addtoken="true">
						<cfelse>
							<div class="art-block clearfix">
								<div class="art-blockheader">
									<h3 class="t">Registering Participant for Workshop/Event: #Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h3>
								</div>
								<div class="art-blockcontent">
									<div class="alert-box notice">Please select the User(s) you would like to register for this event. If you would like to register individuals not listed on this screen you will have the opportunity to enter their information on the next screen.</div>
									<hr>
									<Form Method="Post" Action="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipantsToEvent" id="RegisterParticipants">
										<input type="Hidden" Name="formSubmit" Value="Submit">
										<input type="Hidden" Name="PerformAction" Value="RegisterParticipantsToEventWithAccounts">
										<Table Border="0" CellSpacing="0" CellPadding="0" Width="100%">
											<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
												<tr>
													<td colspan="2">Is each Participant Staying for Meal that you are registering for from this list?</td>
													<td><select name="RegisterParticipantStayForMeal"><option value="1" selected>Yes</option><option value="0">No</option></select></td>
												</tr>
											</cfif>
											<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
												<tr>
													<td colspan="2">Is each Participant Utilizing Webinar Option that you are registering for from this list?</td>
													<td><select name="RegisterParticipantWebinarOption"><option value="1" selected>Yes</option><option value="0">No</option></select></td>
												</tr>
											</cfif>
											<cfloop query="Session.UserSuppliedInfo.EventRegistration.SelectedOrganization">
												<cfquery name="CheckUserAlreadyRegistered" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
													Select User_ID, EventID
													From eRegistrations
													Where User_ID = <cfqueryparam value="#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID#" cfsqltype="cf_sql_varchar">
														and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
												</cfquery>
												<cfset CurrentModRow = #Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.CurrentRow# MOD 3>
												<cfswitch expression="#Variables.CurrentModRow#">
													<cfcase value="1">
														<tr><td width="33%" <cfif CheckUserAlreadyRegistered.RecordCount>Style="Color: ##009900;"</cfif>><cfoutput><input type="CheckBox" Name="ParticipantEmployee" Value="#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID#" <cfif CheckUserAlreadyRegistered.RecordCount>disabled <cfelseif Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID EQ Session.Mura.UserID> Checked="Yes"</cfif>>&nbsp;&nbsp;#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.LName#, #Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.FName#</cfoutput></td>
													</cfcase>
													<cfcase value="0">
														<td width="33%" <cfif CheckUserAlreadyRegistered.RecordCount>Style="Color: ##009900;"</cfif>><cfoutput><input type="CheckBox" Name="ParticipantEmployee" Value="#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID#" <cfif CheckUserAlreadyRegistered.RecordCount>disabled <cfelseif Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID EQ Session.Mura.UserID> Checked="Yes"</cfif>>&nbsp;&nbsp;#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.LName#, #Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.FName#</cfoutput></td></tr>
													</cfcase>
													<cfdefaultcase>
														<td Width="34%" <cfif CheckUserAlreadyRegistered.RecordCount>Style="Color: ##009900;"</cfif>><cfoutput><input type="CheckBox" Name="ParticipantEmployee" Value="#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID#" <cfif CheckUserAlreadyRegistered.RecordCount>disabled <cfelseif Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.UserID EQ Session.Mura.UserID> Checked="Yes"</cfif>>&nbsp;&nbsp;#Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.LName#, #Session.UserSuppliedInfo.EventRegistration.SelectedOrganization.FName#</cfoutput></td>
													</cfdefaultcase>
												</cfswitch>
											</cfloop>
											<cfswitch expression="#Variables.CurrentModRow#">
												<cfcase value="0"></cfcase>
												<cfcase value="1"><td colspan="2">&nbsp;</td></tr></cfcase>
												<cfdefaultcase><td>&nbsp;</td></tr></cfdefaultcase>
											</cfswitch>
											<tr>
												<td colspan="3"><input type="Submit" class="primaryAction" Value="Register Participants For Event"></td>
											</tr>
										</Table>
									</Form>
								</div>
							</div>
						</cfif>
					</cfcase>
					<cfcase value="RegisterParticipantsToEvent">
						<div class="art-block clearfix">
							<div class="art-blockheader">
								<h3 class="t">Registering Participant for Workshop/Event: #Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h3>
							</div>
							<div class="art-blockcontent">
								<cfif not StructKeyExists(Session.UserSuppliedInfo, "Registration")>
									<div class="alert-box notice">Please enter the Participant's Information that will be attending this event.</div>
								<cfelse>
									<div class="alert-box notice">Please enter the Participant's if any that were not listed on the previous page that will be attending this event with you.</div>
								</cfif>
								<hr>
								<uForm:form action="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipantsToEvent" method="Post" id="RegisterParticipants" errors="#Session.FormErrors#" errorMessagePlacement="both"
									commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
									cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
									submitValue="Register Participants to Event" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
									<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
									<input type="hidden" name="formSubmit" value="true">
									<input type="hidden" name="PerformAction" value="RegisterParticipantsToEvent">
									<input type="hidden" Name="MealProvided" Value="#Session.UserSuppliedInfo.PickedEvent.MealProvided#">
									<input type="hidden" Name="MealCost" Value="#Session.UserSuppliedInfo.PickedEvent.MealCost_Estimated#">
									<uForm:fieldset legend="First Participant's Information">
										<uform:field label="First Name" name="Participant1FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant1LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant1EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant1WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant1WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
									<uForm:fieldset legend="Second Participant's Information">
										<uform:field label="First Name" name="Participant2FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant2LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant2EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant2WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant2WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
									<uForm:fieldset legend="Third Participant's Information">
										<uform:field label="First Name" name="Participant3FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant3LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant3EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant3WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant3WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
									<uForm:fieldset legend="Fourth Participant's Information">
										<uform:field label="First Name" name="Participant4FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant4LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant4EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant4WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant4WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
									<uForm:fieldset legend="Fifth Participant's Information">
										<uform:field label="First Name" name="Participant5FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant5LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant5EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant5WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant5WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
									<uForm:fieldset legend="Sixth Participant's Information">
										<uform:field label="First Name" name="Participant6FirstName" maxFieldLength="50" type="text" hint="First Name of Particiapnt" />
										<uform:field label="Last Name" name="Participant6LastName" maxFieldLength="50" type="text" hint="Last Name of Particiapnt" />
										<uform:field label="Email Address" name="Participant6EmailAddress" maxFieldLength="50" type="text" hint="Email Address of Particiapnt" />
										<cfif Session.UserSuppliedInfo.PickedEvent.MealProvided EQ 1>
											<uform:field label="Staying for Meal" name="Participant6WantsMeal" type="select" hint="Will you be staying for the Meal?">
												<uform:option display="Yes" value="1" isSelected="true" />
												<uform:option display="No" value="0" />
											</uform:field>
										</cfif>
										<cfif Session.UserSuppliedInfo.PickedEvent.WebinarAvailable EQ 1>
											<uform:field label="Participate via Webinar" name="Participant6WantsWebinar" type="select" hint="Will you be participating via Webinar?">
												<uform:option display="Yes" value="1"  />
												<uform:option display="No" value="0"isSelected="true" />
											</uform:field>
										</cfif>
									</uForm:fieldset>
								</uForm:form>
							</div>
						</div>
					</cfcase>
				</cfswitch>
			</cfif>
</cfoutput>