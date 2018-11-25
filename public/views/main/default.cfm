<cfsilent>
	<!---
		This file is part of MuraFW1

		Copyright 2010-2015 Stephen J. Withington, Jr.
		Licensed under the Apache License, Version v2.0
		http://www.apache.org/licenses/LICENSE-2.0
	--->
	<cfif Session.Mura.IsLoggedIn EQ True>
		<cfparam name="Session.Mura.EventCoordinatorRole" default="0" type="boolean">
		<cfparam name="Session.Mura.EventPresenterRole" default="0" type="boolean">
		<cfparam name="Session.Mura.SuperAdminRole" default="0" type="boolean">
		<cfset UserMembershipQuery = #$.currentUser().getMembershipsQuery()#>
		<cfloop query="#Variables.UserMembershipQuery#">
			<cfif UserMembershipQuery.GroupName EQ "Event Facilitator"><cfset Session.Mura.EventCoordinatorRole = true></cfif>
			<cfif UserMembershipQuery.GroupName EQ "Event Presentator"><cfset Session.Mura.EventPresenterRole = true></cfif>
		</cfloop>
		<cfif Session.Mura.Username EQ "admin"><cfset Session.Mura.SuperAdminRole = true></cfif>
		<cfif Session.Mura.EventCoordinatorRole EQ "True"><cfoutput>#Variables.this.redirect("eventcoord:main.default")#</cfoutput></cfif>
		<cfif Session.Mura.SuperAdminRole EQ "true"><cfoutput>#Variables.this.redirect("siteadmin:main.default")#</cfoutput></cfif>

		<cfif isDefined("Session.UserRegistrationInfo")>
			<cfif DateDiff("n", Session.UserRegistrationInfo.DateRegistered, Now()) LTE 15>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&EventID=#Session.UserRegistrationInfo.EventID#" addtoken="false">
			<cfelse>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.UserRegistrationInfo.EventID#" addtoken="false">
			</cfif>
		</cfif>
	<cfelse>
		<cfparam name="Session.Mura.EventCoordinatorRole" default="0" type="boolean">
		<cfparam name="Session.Mura.EventPresenterRole" default="0" type="boolean">
		<cfparam name="Session.Mura.SuperAdminRole" default="0" type="boolean">
	</cfif>
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-heading"><h1>Current Events and/or Workshops</h1></div>
		<div class="panel-body">
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">

					<cfcase value="UserRegistered">
						<cfif URL.Successfull EQ "true">
							<div class="alert alert-success">You have successfully registered an individual for the event. Within the next few minutes, the registered participant will be receiving an electronic copy of the confirmation information for the event.</div>
						<cfelse>
							<div class="alert alert-danger">Something happened during the registration process. Please contact us so that we can resolve the system error</div>
						</cfif>
					</cfcase>
					<cfcase value="UserActivated">
						<cfif URL.Successfull EQ "true">
							<div class="alert alert-success">You have successfully activated your account on the event registration system. You are now able to login and register for any upcoming events or workshops that are offered through this system.</div>
						<cfelse>
							<div class="alert alert-danger">Something happened during the registration process. Please contact us so that we can resolve the system error</div>
						</cfif>
					</cfcase>
					<cfcase value="UserRegistration">
						<cfif URL.Successfull EQ "true">
							<div class="alert alert-success">You have successfully registered for an account on this event registration system. Within the next few minutes you will be receiving an email with a special link to click on that will activate your account. You will not be able to login to this system until your account has been activated.</div>
						<cfelse>
							<div class="alert alert-danger">Something happened during the registration process. Please contact us so that we can resolve the system error</div>
						</cfif>
					</cfcase>
				</cfswitch>
			</cfif>
			<cfif Session.getFeaturedEvents.RecordCount>
				<cfdump var="#Session.getFeaturedEvents#">
			</cfif>

			<cfif Session.getNonFeaturedEvents.RecordCount>
				<table class="table table-striped table-bordered">
					<thead class="thead-default">
						<tr>
							<th width="50%">Event Title</th>
							<th width="10%">Event Date</th>
							<th width="20%"></th>
							<th width="20%">Icons</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="#Session.getNonFeaturedEvents#">
							<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select Count(TContent_ID) as CurrentNumberofRegistrations
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getNonFeaturedEvents.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfset EventSeatsLeft = #Session.getNonFeaturedEvents.MaxParticipants# - #getCurrentRegistrationsbyEvent.CurrentNumberofRegistrations#>
							<tr>
								<td>#Session.getNonFeaturedEvents.ShortTitle#</td>
								<td>#DateFormat(Session.getNonFeaturedEvents.EventDate, "mmm dd, yy")#</td>
								<td>
									<cfif Session.getNonFeaturedEvents.AcceptRegistrations EQ 1>
										<cfif Variables.EventSeatsLeft GTE 1 and DateDiff("d", Now(), Session.getNonFeaturedEvents.Registration_Deadline) GTE 0>
											<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-small" alt="Register Event">Register</a>
										</cfif>
									</cfif><a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-small" alt="Event Information">More Info</a>
								</td>
								<td><cfif Session.getNonFeaturedEvents.PGPAvailable EQ 1><img src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/images/award.png" alt="PGP Certificate" border="0"></cfif><cfif Session.getNonFeaturedEvents.AllowVideoConference EQ 1 or Session.getNonFeaturedEvents.WebinarAvailable EQ 1><img src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/images/wifi.png" "Online Learning" border="0"></cfif></td>
							</tr>
						</cfloop>
					</tbody>
					<tfoot>
						<tr>
							<td></td>
							<td></td>
						</tr>
					</tfoot>
				</table>
			</cfif>
		</div>
	</div>
</cfoutput>