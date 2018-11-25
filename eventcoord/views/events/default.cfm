<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-heading"><h1>Available Events and/or Workshops</h1></div>
		<div class="panel-body">
			<cfif isDefined("Session.FormErrors")>
				<cfif ArrayLen(Session.FormErrors) GTE 1>
					<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
				</cfif>
			</cfif>
			<cfif isDefined("URL.UserAction")>
				<div class="panel-body">
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="PostToFB">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div class="alert alert-success"><p>You have successfully posted the event to the Organization's Facebook Page</p></div>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="EventCancelled">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "False">
									<div class="alert alert-info"><p>Event was not cancelled due to selecting the 'No' option when asked if you really want to cancel this event.</p></div>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="AddedEvent">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div class="alert alert-success"><p>You have successfully added a new event to the database.</p></div>
									<cfif isDefined("URL.FacebookPost")>
										<div class="alert alert-warning"><p>The event was not posted to Facebook even though the option was selected to post this event to Facebook. Within the Site Configuration, the necessary information needed to post to Facebook was not entered.</p></div>
									</cfif>
								</cfif>
							</cfif>
						</cfcase>
					</cfswitch>
				</div>
			</cfif>
			<table class="table table-striped table-bordered">
				<cfif Session.getAvailableEvents.RecordCount>
					<thead class="thead-default">
						<tr>
							<th width="50%">Event Title</th>
							<th  width="15%">Event Date</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<td colspan="3">Add a new Event or Workshop to allow registrations not listed above by clicking <a href="#buildURL('eventcoord:events.addevent')#" class="btn btn-primary btn-small">here</a></td>
						</tr>
					</tfoot>
					<tbody>
						<cfloop query="Session.getAvailableEvents">
							<cfquery name="getRegistrationsForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfquery name="getAttendedParticipantsForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID, User_ID
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEvent = <cfqueryparam value="1" cfsqltype="cf_sql_boolean">
							</cfquery>
							<cfquery name="getEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID
								From p_EventRegistration_EventExpenses
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									Event_ID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<tr>
								<td width="50%">(<a href="http://#cgi.server_name#/?Info=#Session.getAvailableEvents.TContent_ID#">#Session.getAvailableEvents.TContent_ID#</a>) / #Session.getAvailableEvents.ShortTitle#</td>
								<td width="15%">#DateFormat(Session.getAvailableEvents.EventDate, "mmm dd, yy")#</td>
								<td>
									<a href="#buildURL('eventcoord:events.updateevent_review')#&EventID=#Session.getAvailableEvents.TContent_ID#" role="button" class="btn btn-primary btn-small"><small>Update</small></a>&nbsp;
									<a href="#buildURL('eventcoord:events.cancelevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Cancel</small></a>&nbsp;
									<a href="#buildURL('eventcoord:events.emailregistered')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Email Registered</small></a>&nbsp;
									<a href="#buildURL('eventcoord:events.copypriorevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Copy</small></a><br />
									<a href="#buildURL('eventcoord:events.emailattended')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Email Attended</small></a>&nbsp;
									<a href="#buildURL('eventcoord:events.geteventinfo')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Info</small></a>&nbsp;
									<a href="#buildURL('eventcoord:events.registeruserforevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Register</small></a>
									<a href="#buildURL('eventcoord:events.publishtofb')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small small"><small>Post to Facebook</small></a><br>
									<cfif getRegistrationsForEvent.RecordCount>
										&nbsp;<a href="#buildURL('eventcoord:events.deregisteruserforevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>De-Register</small></a>
										&nbsp;<a href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Sign-In Sheet</small></a>
										&nbsp;<a href="#buildURL('eventcoord:events.eventsigninparticipant')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Sign-In Participant</small></a>
										&nbsp;<a href="#buildURL('eventcoord:events.eventnamebadges')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Participant Name Badges</small></a>
									</cfif>
									<cfif getAttendedParticipantsForEvent.RecordCount and Session.getAvailableEvents.PGPAvailable EQ 1>
										&nbsp;<a href="#buildURL('eventcoord:events.sendpgpcertificates')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Send PGP Certificates</small></a>
										&nbsp;<a href="#buildURL('eventcoord:events.enterexpenses')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Enter Event Expenses</small></a>
									<cfelseif getAttendedParticipantsForEvent.RecordCount and Session.getAvailableEvents.PGPAvailable EQ 0>
										&nbsp;<a href="#buildURL('eventcoord:events.enterexpenses')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Enter Event Expenses</small></a>
									</cfif>
									<cfif getEventExpenses.RecordCount>
										&nbsp;<a href="#buildURL('eventcoord:events.generateprofitlossreport')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Generate Profit/Loss Report</small></a><br />
									</cfif>
								</td>
							</tr>
						</cfloop>
					</tbody>
				</cfif>
			</table>
		</div>
	</div>
</cfoutput>