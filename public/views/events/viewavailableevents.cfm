<!---

--->

<cfif isDefined("URL.Info")>
	<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:events.eventinfo&EventID=#URL.Info#" addtoken="false">
</cfif>
<cfif isDefined("Session.Mura")>
	<cfif Session.Mura.isLoggedIn EQ "true" and isDefined("Session.UserRegistrationInfo")>
		<!--- Outer CFIF Code Block was added to prevent moving on to another page when user enters wrong password for account --->
		<cfif isDefined("Session.UserRegistrationInfo.DateRegistered") and isDefined("Session.UserRegistrationInfo.EventID")>
			<cfif DateDiff("s", Session.UserRegistrationInfo.DateRegistered, NOW()) LTE 120>
				<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#Session.UserRegistrationInfo.EventID#" addtoken="false">
			<cfelse>
				<cflock type="Exclusive" timeout="60" scope="Session">
					<cfset StructDelete(Session, "UserRegistrationInfo")>
				</cflock>
				<cflocation url="/index.cfm" addtoken="false">
			</cfif>
		</cfif>
	</cfif>
	<cfif Session.Mura.isLoggedIn EQ "true" and isDefined("URL.PerformAction")>
		<cfif URL.PerformAction EQ "LogoutUser">
			<cfset Session.Mura = #StructCopy(Session.MuraPreviousUser)#>
			<cfset temp = #StructDelete(Session, "MuraPreviousUser")#>
			<cflocation url="/index.cfm" addtoken="true">
		</cfif>
	</cfif>
</cfif>

<cfif isDefined("URL.UserAccountPasswordSent")>
	<cfswitch expression="#URL.UserAccountPasswordSent#">
		<cfcase value="True">
			<div class="art-block clearfix">
				<div class="art-blockheader">
					<h3 class="t">Account Temporary Password Sent Changed</h3>
				</div>
				<div class="art-blockcontent"><p class="alert-box notice">Within the next few minutes you will be receiving an email to the email address on file with a temporary password. Once you get this email you will be able to login to your account and change the password by using the Change Password Link under the Home Tab.</p></div>
			</div>
		</cfcase>
		<cfcase value="False">

		</cfcase>
	</cfswitch>
</cfif>

<cfif isDefined("URL.UserPasswordChangeSuccessfull")>
	<cfswitch expression="#URL.UserPasswordChangeSuccessfull#">
		<cfcase value="True">
			<div class="art-block clearfix">
				<div class="art-blockheader">
					<h3 class="t">Account Password Changed</h3>
				</div>
				<div class="art-blockcontent"><p class="alert-box notice">Your account password has been changed and you will need to use this new password on all future logins at this website.</p></div>
			</div>
		</cfcase>
		<cfcase value="False">
			<div class="art-block clearfix">
				<div class="art-blockheader">
					<h3 class="t">Account Password Not Changed</h3>
				</div>
				<div class="art-blockcontent"><p class="alert-box notice">Your account password has not been changed.</p></div>
			</div>
		</cfcase>
	</cfswitch>
</cfif>

<cfif isDefined("URL.UserProfileUpdateSuccessfull")>
	<cfswitch expression="#URL.UserProfileUpdateSuccessfull#">
		<cfcase value="True">
			<div class="art-block clearfix">
				<div class="art-blockheader">
					<h3 class="t">Account Updated</h3>
				</div>
				<div class="art-blockcontent"><p class="alert-box notice">Your account has been updated and we appriciate you for keeping correct information on file with us.</p></div>
			</div>
		</cfcase>
	</cfswitch>
</cfif>

<cfif isDefined("URL.UserRegistrationActive")>
	<cfswitch expression="#URL.UserRegistrationActive#">
		<cfcase value="True">
			<div class="art-block clearfix">
				<div class="art-blockheader">
					<h3 class="t">Account Activated</h3>
				</div>
				<div class="art-blockcontent"><p class="alert-box notice">Your account has been activated and you are able to login with your username and password to register for upcoming events.</p></div>
			</div>
		</cfcase>

		<cfcase value="False">
			<div class="art-block clearfix">
				<div class="art-blockheader">
					<h3 class="t">Account Not Activated</h3>
				</div>
				<div class="art-blockcontent"><p class="alert-box notice">Your account has not been activated due to more than 45 minutes have passed since we sent the activation email. Please contact us so that we can activate your account manually.</p></div>
			</div>
		</cfcase>
	</cfswitch>
</cfif>

<cfif isDefined("URL.UserRegistrationSuccessfull")>
	<cfswitch expression="#URL.UserRegistrationSuccessfull#">
		<cfcase value="True">
			<div class="art-block clearfix">
				<div class="art-blockheader">
					<h3 class="t">Account Created</h3>
				</div>
				<div class="art-blockcontent"><p class="alert-box notice">Your account has been created successfully. Within the next few minutes, you will be receiving an email message with instructions on how to complete the registration process.</p></div>
			</div>
		</cfcase>
	</cfswitch>
</cfif>

<cfif isDefined("URL.SentInquiry")>
	<cfswitch expression="#URL.SentInquiry#">
		<cfcase value="True">
			<cfif isDefined("URL.RequestEvent")>
				<div class="art-block clearfix">
					<div class="art-blockheader">
						<h3 class="t">Workshop Request Sent</h3>
					</div>
					<div class="art-blockcontent"><p class="alert-box notice">The workshop request has been sent. We will review this information and see who might also be interested in this same event. If we have any questions we will reach out to you with the information provided on the form. Thank you for your request.</p></div>
				</div>
			</cfif>
			<cfif isDefined("URL.CommentSuggestion")>
				<div class="art-block clearfix">
					<div class="art-blockheader">
						<h3 class="t">Comment/Suggestion Sent</h3>
					</div>
					<div class="art-blockcontent"><p class="alert-box notice">The comment or suggestion which you filed is being sent. We will review this information and reach out to you depending on the information you sent. We thank you for your request as it helps us to improve the events we offer.</p></div>
				</div>
			</cfif>
		</cfcase>
	</cfswitch>
</cfif>

<cfif isDefined("URL.RegistrationSuccessfull")>
	<cfswitch expression="#URL.RegistrationSuccessfull#">
		<cfcase value="true">
			<div class="art-block clearfix">
					<div class="art-blockheader">
						<h3 class="t">Registration Successfull</h3>
					</div>
					<cfif isDefined("URL.SingleRegistration")>
						<div class="art-blockcontent"><p class="alert-box notice">You have sucessfully registered yourself for the event. You will receive an email confirmation to your email address within the next few minutes regarding the details of this registration.</p></div>
					<cfelse>
						<div class="art-blockcontent"><p class="alert-box notice">You have sucessfully registered yourself and others for the event. You will receive an email confirmation to your email address within the next few minutes regarding the details of this registration. You will need to share this information with the other people who you registered at this same time.</p></div>
					</cfif>
				</div>
		</cfcase>
	</cfswitch>
</cfif>

<cfif isDefined("URL.CancelEventSuccessfull")>
	<cfswitch expression="#URL.CancelEventSuccessfull#">
		<cfcase value="True">
			<div class="art-block clearfix">
					<div class="art-blockheader">
						<h3 class="t">Registration Cancelled Successfull</h3>
					</div>
					<div class="art-blockcontent"><p class="alert-box notice">You have sucessfully cancelled the registration to attend the event. If this was done by error, you will need to register for the event again.</p></div>
				</div>
		</cfcase>
	</cfswitch>
</cfif>


<cfoutput>

<cfif not isDefined("URL.display")>
	<!--- Checking to make sure that today's date is within the Featured Events Date Window, Otherwise Update Event to not be featured. --->
	<cfquery name="updateExpiredFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Update eEvents
		Set EventFeatured = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
		Where DateDiff(Featured_StartDate, Now()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
			DateDiff(Featured_EndDate, Now()) > <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
			EventFeatured = <cfqueryparam value="1" cfsqltype="cf_sql_integer"> and
			Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
	</cfquery>

	<cfquery name="getNonFeaturedEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, TContent_ID, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, AcceptRegistrations, Registration_Deadline, MaxParticipants, PGPAvailable, AllowVideoConference, WebinarAvailable
		From eEvents
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
		From eEvents
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
					From eRegistrations
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and EventID = <cfqueryparam value="#Variables.getFeaturedEventRecordID#" cfsqltype="cf_sql_integer">
				</cfquery>
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

		<cfif #DateDiff("d", Now(), Variables.FeatureEventDisplayStartDate)# LT 0 AND #DateDiff("d", Variables.FeatureEventDisplayEndDate, Now())# LTE 0>
			<div class="art-block clearfix">
				<div class="art-blockheader">
					<h3 class="t">Featured Event</h3>
				</div>
				<div class="art-blockcontent">
					<p><table class="art-article" style="width: 100%;">
						<thead>
							<tr>
								<th style="width: 50%;">Event Title</td>
								<th style="width: 20%;">Event Date</td>
								<th style="width: 20%;">Event Actions</td>
								<th style="width: 10%;">Event Icons</td>
							</tr>
						</thead>
						<tfoot>
							<tr>
								<td colspan="4"><img src="/plugins/EventRegistration/includes/assets/images/wifi.png" "Online Learning"> = Online Learning Available <img src="/plugins/EventRegistration/includes/assets/images/award.png" alt="PGP Certificate"> = PGP Certificate Available</td>
							</tr>
						</tfoot>
						<tbody>
							<tr style="font-face: Arial; font-weight: bold; font-size: 14px;">
								<td style="width: 50%;">#Variables.FeatureEventShortTitle#</td>
								<td style="width: 20%;">#DateFormat(Variables.FeatureEventEventDate, "mmm dd, yy")#</td>
								<td style="width: 20%;">
									<cfif Variables.FeatureEventAcceptRegistrations EQ 1>
										<cfif DateDiff("d", Now(), FeatureEventRegistrationDeadline) GTE 0>
											<cfif Variables.FeaturedEventSeatsLeft GT 0>
												<a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#Variables.FeatureEventRecordID#" class="art-button" alt="Register Event">Register</a>
											</cfif>
										</cfif>
									</cfif>
									<a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:events.eventinfo&EventID=#Variables.FeatureEventRecordID#" class="art-button">More Info</a>
								</td>
								<td style="width: 10%;"></td>
							</tr>
						</tbody>
					</table></p>
				</div>
			</div>
			<br /><br />
		<cfelse>
			<cfset temp = #QueryAddRow(getNonFeaturedEvents, 1)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "ShortTitle", Variables.FeatureEventShortTitle)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventDate", Variables.FeatureEventEventDate)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "TContent_ID", Variables.FeatureEventRecordID)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "EventFeatured", Variables.FeatureEventFeatured)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Featured_StartDate", Variables.FeatureEventDisplayStartDate)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Featured_EndDate", Variables.FeatureEventDisplayEndDate)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Featured_SortOrder", Variables.FeatureEventFeatureSortOrder)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "AcceptRegistrations", Variables.FeatureEventAcceptRegistrations)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "Registration_Deadline", Variables.FeatureEventRegistrationDeadline)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "MaxParticipants", Variables.FeatureEventMaxParticipants)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "PGPAvailable", Variables.FeatureEventPGPAvailable)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "AllowVideoConference", Variables.FeatureEventAllowVideoConf)#>
			<cfset temp = #QuerySetCell(getNonFeaturedEvents, "WebinarAvailable", Variables.FeatureEventWebinarAvailable)#>
		</cfif>

		<cfquery name="ReSortgetNonFeaturedEvents" dbtype="Query">
			Select *
			From getNonFeaturedEvents
			Order by EventDate ASC
		</cfquery>
		<cfset temp = #StructClear(getNonFeaturedEvents)#>
		<cfset getNonFeaturedEvents = #StructCopy(ReSortgetNonFeaturedEvents)#>
	</cfif>

	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Available Events</h3>
		</div>
		<div class="art-blockcontent"><p>
			<table class="art-article" style="width: 100%;">
				<thead>
					<tr>
						<th style="width: 50%;">Event Title</td>
						<th style="width: 20%;">Event Date</td>
						<th style="width: 20%;">Event Actions</td>
						<th style="width: 10%;">Event Icons</td>
					</tr>
				</thead>
				<tfoot>
					<tr>
						<td colspan="4"><img src="/plugins/EventRegistration/includes/assets/images/wifi.png" "Online Learning" border="0"> = Online Learning Available <img src="/plugins/EventRegistration/includes/assets/images/award.png" alt="PGP Certificate" border="0"> = PGP Certificate Available</td>
					</tr>
				</tfoot>
				<tbody>
					<cfloop query="getNonFeaturedEvents">
						<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select Count(TContent_ID) as CurrentNumberofRegistrations
							From eRegistrations
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
								EventID = <cfqueryparam value="#getNonFeaturedEvents.TContent_ID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfset EventSeatsLeft = #getNonFeaturedEvents.MaxParticipants# - #getCurrentRegistrationsbyEvent.CurrentNumberofRegistrations#>
						<tr style="font-face: Arial; font-weight: bold; font-size: 14px;">
							<td style="width: 50%;">#getNonFeaturedEvents.ShortTitle#</td>
							<td style="width: 20%;">
								<cfif DateDiff("d", Now(), getNonFeaturedEvents.EventDate) GT 0>
									#DateFormat(getNonFeaturedEvents.EventDate, "mmm dd, yy")#
								<cfelse>
									<cfif #Len(getNonFeaturedEvents.EventDate1)#>
										<cfif DateDiff("d", Now(), getNonFeaturedEvents.EventDate1) GTE 0 and isDate(getNonFeaturedEvents.EventDate2) eq False>
											#DateFormat(getNonFeaturedEvents.EventDate1, "mmm dd, yy")#
										</cfif>
									<cfelseif #Len(getNonFeaturedEvents.EventDate2)#>
										<cfif DateDiff("d", Now(), getNonFeaturedEvents.EventDate2) GTE 0 and isDate(getNonFeaturedEvents.EventDate3) eq False>
											#DateFormat(getNonFeaturedEvents.EventDate2, "mmm dd, yy")#
										</cfif>
									<cfelseif #Len(getNonFeaturedEvents.EventDate3)#>
										<cfif DateDiff("d", Now(), getNonFeaturedEvents.EventDate3) GTE 0 and isDate(getNonFeaturedEvents.EventDate4) eq False>
											#DateFormat(getNonFeaturedEvents.EventDate3, "mmm dd, yy")#
										</cfif>
									<cfelseif #Len(getNonFeaturedEvents.EventDate4)#>
										<cfif DateDiff("d", Now(), getNonFeaturedEvents.EventDate4) GTE 0 and isDate(getNonFeaturedEvents.EventDate5) eq False>
											#DateFormat(getNonFeaturedEvents.EventDate4, "mmm dd, yy")#
										</cfif>
									<cfelseif #Len(getNonFeaturedEvents.EventDate5)#>
										<cfif DateDiff("d", Now(), getNonFeaturedEvents.EventDate5) GTE 0>
											#DateFormat(getNonFeaturedEvents.EventDate5, "mmm dd, yy")#
										</cfif>
									</cfif>
								</cfif>
							</td>
							<td style="width: 20%;">
								<cfif getNonFeaturedEvents.AcceptRegistrations EQ 1>
									<cfif Variables.EventSeatsLeft GTE 1 and DateDiff("d", Now(), getNonFeaturedEvents.Registration_Deadline) GTE 0>
										<a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:registerevent.default&EventID=#getNonFeaturedEvents.TContent_ID#" class="art-button" alt="Register Event">Register</a> &nbsp;
									</cfif>
								</cfif><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:events.eventinfo&EventID=#getNonFeaturedEvents.TContent_ID#" class="art-button">More Info</a>
							</td>
							<td style="width: 10%;">
								<cfif getNonFeaturedEvents.PGPAvailable EQ 1><img src="/plugins/EventRegistration/includes/assets/images/award.png" alt="PGP Certificate" border="0"></cfif>
								<cfif getNonFeaturedEvents.AllowVideoConference EQ 1 or getNonFeaturedEvents.WebinarAvailable EQ 1><img src="/plugins/EventRegistration/includes/assets/images/wifi.png" "Online Learning" border="0"></cfif>
							</td>
						</tr>
					</cfloop>
				</tbody>
			</table>
		</p></div>
	</div>
</cfif>
	<!--- <cfset GetAllGroups = #$.getBean( 'userManager' ).getUserGroups( rc.$.siteConfig('siteID'), 1 )#>
	<cfset GetGroupMembers = #members=$.getBean( 'user' ).loadBy( groupname = 'Event Coordinator' ).getRecordCount()#>
	<cfset UserSuperUser = #rc.$.getCurrentUser().isSuperUser()#>
	 --->
</cfoutput>