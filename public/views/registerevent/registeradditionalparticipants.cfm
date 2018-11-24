<cfif isDefined("URL.EventID") and isNumeric(URL.EventID) and Session.Mura.IsLoggedIn EQ "true">
	<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, EventFeatured, Featured_StartDate, Featured_EndDate, MemberCost, NonMemberCost,  EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Presenters, Facilitator
		From eEvents
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfquery name="getEventFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, GeoCode_Latitude, GeoCode_Longitude, GeoCode_StateLongName
		From eFacility
		Where FacilityType = <cfqueryparam value="#getSelectedEvent.LocationType#" cfsqltype="cf_sql_varchar"> and
			TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfquery name="getEventFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select RoomName, Capacity
		From eFacilityRooms
		Where TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer"> and
			Facility_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfquery name="getFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select FName, Lname, Email
		From tusers
		Where UserID = <cfqueryparam value="#getSelectedEvent.Facilitator#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfset UserEmailDomain = #Right(Session.Mura.EMail, Len(Session.Mura.Email) - Find("@", Session.Mura.Email))#>
	<cfquery name="getActiveMembership" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select TContent_ID, OrganizationName, OrganizationDomainName, Active
		From eMembership
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
			OrganizationDomainName = <cfqueryparam value="#Variables.UserEmailDomain#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfif getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
		<cfif DateDiff("d", Now(), getSelectedEvent.EarlyBird_RegistrationDeadline) GTE 0>
			<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = True>
		<cfelse>
			<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
		</cfif>
	<cfelse>
		<cfset Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration = False>
	</cfif>

	<cfif getSelectedEvent.ViewSpecialPricing EQ 1>
		<cfset Session.UserRegistrationInfo.SpecialPricingAvailable = True>
		<cfset Session.UserRegistrationInfo.SpecialPriceRequirements = #getSelectedEvent.SpecialPriceRequirements#>
		<cfif getActiveMembership.RecordCount GTE 1>
			<cfset Session.UserRegistrationInfo.SpecialPriceEventCost = #getSelectedEvent.SpecialMemberCost#>
		<cfelse>
			<cfset Session.UserRegistrationInfo.SpecialPriceEventCost = #getSelectedEvent.SpecialNonMemberCost#>
		</cfif>
	<cfelse>
		<cfset Session.UserRegistrationInfo.SpecialPricingAvailable = False>
	</cfif>

	<cfif getSelectedEvent.MealProvided EQ 1>
		<cfset Session.UserRegistrationInfo.MealOptionAvailable = True>
	<cfelse>
		<cfset Session.UserRegistrationInfo.MealOptionAvailable = False>
	</cfif>

	<cfif getSelectedEvent.AllowVideoConference EQ 1>
		<cfset Session.UserRegistrationInfo.VideoConferenceOption = True>
		<cfset Session.UserRegistrationInfo.VideoConferenceInfo = #getSelectedEvent.VideoConferenceInfo#>
		<cfset Session.UserRegistrationInfo.VideoConferenceCost = #getSelectedEvent.VideoConferenceCost#>
	<cfelse>
		<cfset Session.UserRegistrationInfo.VideoConferenceOption = False>
	</cfif>

	<cfif getSelectedEvent.PGPAvailable EQ 1>
		<cfset Session.UserRegistrationInfo.PGPPointsAvailable = True>
		<cfset Session.UserRegistrationInfo.PGPPoints = #getSelectedEvent.PGPPoints#>
	<cfelse>
		<cfset Session.UserRegistrationInfo.PGPPointsAvailable = False>
	</cfif>

	<cfset UserEmailDomain = #Right(Session.Mura.EMail, Len(Session.Mura.Email) - Find("@", Session.Mura.Email))#>

	<cfquery name="getActiveMembership" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select TContent_ID, OrganizationName, OrganizationDomainName, Active
		From eMembership
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
			OrganizationDomainName = <cfqueryparam value="#Variables.UserEmailDomain#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfif getActiveMembership.RecordCount EQ 1>
		<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = True>
		<cfset Session.UserRegistrationInfo.UserEventPrice = #getSelectedEvent.MemberCost#>
		<cfif Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration EQ "True">
			<cfset Session.UserRegistrationInfo.UserEventEarlyBirdPrice = #getSelectedEvent.EarlyBird_MemberCost#>
		</cfif>
	<cfelse>
		<cfset Session.UserRegistrationInfo.UserGetsMembershipPrice = False>
		<cfset Session.UserRegistrationInfo.UserEventPrice = #getSelectedEvent.NonMemberCost#>
		<cfif Session.UserRegistrationInfo.UserGetsEarlyBirdRegistration EQ "True">
			<cfset Session.UserRegistrationInfo.UserEventEarlyBirdPrice = #getSelectedEvent.EarlyBird_NonMemberCost#>
		</cfif>
	</cfif>

	<cfquery name="GetUsersWithinCorporation" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select UserID, Fname, Lname, Email
		From tusers
		Where Email LIKE '%#Variables.UserEmailDomain#'
		Order By Lname ASC, Fname ASC
	</cfquery>

	<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">

	<cfif not isDefined("URL.RegistrationSuccessfull")>
		<cfoutput>
			<div align="center"><h4>Registering Additional Participants for Event: #getSelectedEvent.ShortTitle#</h4></div>
			<p class="alert-box notice">Please complete the following information to register additional participants for this event. Each additional participant will receive a confirmation email that they have been registered for this event by you.</p>
			<hr>
			<Form method="Post" action="" id="">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="EventID" value="#URL.EventID#">
				<input type="hidden" name="formSubmit" value="true">
				<cfif isDefined("Session.FormData.RegisterAllDays")><input type="hidden" name="RegisterAllDays" value="#Session.FormData.RegisterAllDays#"><cfelse><input type="hidden" name="RegisterAllDays" value="0"></cfif>
				<cfif isDefined("Session.FormData.WebinarParticipant")><input type="Hidden" Name="WebinarParticipant" Value="#Session.FormData.WebinarParticipant#"></cfif>
				<input type="hidden" name="WantsMeal" value="#Session.FormData.WantsMeal#">
				<table class="art-article" border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
					<tbody>
						<tr>
							<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 99%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
								<table class="art-article" style="width: 100%;">
									<thead>
										<tr>
											<td colspan="4" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
												<strong>Registered User Accounts</strong> (Individuals in <span style="color: ##FF9999; font-weight: bold;">Red</span> already Registered)
											</td>
										</tr>
									</thead>
									<tbody>
										<cfloop query="GetUsersWithinCorporation">
										<cfquery name="CheckUserAlreadyRegistered" datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select TContent_ID
											From eRegistrations
											Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
												User_ID = <cfqueryparam value="#GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar"> and
												EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
										</cfquery>
										<cfset CurrentModRow = #GetUsersWithinCorporation.CurrentRow# MOD 4>

										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr width="25%">
													<td width="25%" style="border-width: 1px; padding: 1px; border-color: gray;">
													<cfif CheckUserAlreadyRegistered.RecordCount>
														<cfoutput><input type="CheckBox" Name="additionalParticipants" Value="#GetUsersWithinCorporation.UserID#" checked disabled><span style="color: ##FF9999; font-weight: bold;">&nbsp;&nbsp;#GetUsersWithinCorporation.Lname#, #GetUsersWithinCorporation.Fname#</span></cfoutput>
													<cfelse>
														<cfoutput><input type="CheckBox" Name="additionalParticipants" Value="#GetUsersWithinCorporation.UserID#" <cfif GetUsersWithinCorporation.UserID EQ Session.Mura.UserID>checked</cfif>>&nbsp;&nbsp;#GetUsersWithinCorporation.Lname#, #GetUsersWithinCorporation.Fname#</cfoutput>
													</cfif>
												</td>
											</cfcase>
											<cfcase value="0">
												<td width="25%" style="border-width: 1px; padding: 1px; border-color: gray;">
													<cfif CheckUserAlreadyRegistered.RecordCount>
														<cfoutput><input type="CheckBox" Name="additionalParticipants" Value="#GetUsersWithinCorporation.UserID#" checked disabled><span style="color: ##FF9999; font-weight: bold;">&nbsp;&nbsp;#GetUsersWithinCorporation.Lname#, #GetUsersWithinCorporation.Fname#</span></cfoutput>
													<cfelse>
														<cfoutput><input type="CheckBox" Name="additionalParticipants" Value="#GetUsersWithinCorporation.UserID#" <cfif GetUsersWithinCorporation.UserID EQ Session.Mura.UserID>checked</cfif>>&nbsp;&nbsp;#GetUsersWithinCorporation.Lname#, #GetUsersWithinCorporation.Fname#</cfoutput>
													</cfif>
												</td></tr>
											</cfcase>
											<cfdefaultcase>
												<td width="25%" style="border-width: 1px; padding: 1px; border-color: gray;">
													<cfif CheckUserAlreadyRegistered.RecordCount>
														<cfoutput><input type="CheckBox" Name="additionalParticipants" Value="#GetUsersWithinCorporation.UserID#" checked disabled><span style="color: ##FF9999; font-weight: bold;">&nbsp;&nbsp;#GetUsersWithinCorporation.Lname#, #GetUsersWithinCorporation.Fname#</span></cfoutput>
													<cfelse>
														<cfoutput><input type="CheckBox" Name="additionalParticipants" Value="#GetUsersWithinCorporation.UserID#" <cfif GetUsersWithinCorporation.UserID EQ Session.Mura.UserID>checked</cfif>>&nbsp;&nbsp;#GetUsersWithinCorporation.Lname#, #GetUsersWithinCorporation.Fname#</cfoutput>
													</cfif>
												</td>
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
								<table class="art-article" style="width: 100%;">
									<thead>
										<tr>
											<td colspan="2" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
												<strong>First Additional Participant's Information (Not Checked Above)</strong>
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
										<cfif Session.UserRegistrationInfo.MealOptionAvailable EQ "True">
											<tr>
											<td width="25%">Staying for Meal?</td>
											<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_1_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_1_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
											</tr>
										</cfif>
										<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
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
												<strong>Second Additional Participant's Information (Not Checked Above)</strong>
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
										<cfif Session.UserRegistrationInfo.MealOptionAvailable EQ "True">
											<tr>
											<td width="25%">Staying for Meal?</td>
											<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_2_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_2_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
											</tr>
										</cfif>
										<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
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
												<strong>Third Additional Participant's Information (Not Checked Above)</strong>
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
										<cfif Session.UserRegistrationInfo.MealOptionAvailable EQ "True">
											<tr>
											<td width="25%">Staying for Meal?</td>
											<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_3_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_3_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
											</tr>
										</cfif>
										<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
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
												<strong>Fourth Additional Participant's Information (Not Checked Above)</strong>
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
										<cfif Session.UserRegistrationInfo.MealOptionAvailable EQ "True">
											<tr>
											<td width="25%">Staying for Meal?</td>
											<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_4_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_4_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
											</tr>
										</cfif>
										<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
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
												<strong>Fifth Additional Participant's Information (Not Checked Above)</strong>
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
										<cfif Session.UserRegistrationInfo.MealOptionAvailable EQ "True">
											<tr>
											<td width="25%">Staying for Meal?</td>
											<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_5_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_5_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
											</tr>
										</cfif>
										<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
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
												<strong>Sixth Additional Participant's Information (Not Checked Above)</strong>
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
										<cfif Session.UserRegistrationInfo.MealOptionAvailable EQ "True">
											<tr>
											<td width="25%">Staying for Meal?</td>
											<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_6_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_6_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
											</tr>
										</cfif>
										<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
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
												<strong>Seventh Additional Participant's Information (Not Checked Above)</strong>
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
										<cfif Session.UserRegistrationInfo.MealOptionAvailable EQ "True">
											<tr>
											<td width="25%">Staying for Meal?</td>
											<td><table border="0" cellspacing="1" cellpadding="0" align="center" width="300"><tr><td><input type="radio" name="AdditionalParticipant_7_Stay4Meal" value="1">&nbsp;&nbsp;Yes</td><td><input type="radio" name="AdditionalParticipant_7_Stay4Meal" value="0">&nbsp;&nbsp;No</td></tr></table></td>
											</tr>
										</cfif>
										<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
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
		</cfoutput>
	</cfif>
</cfif>