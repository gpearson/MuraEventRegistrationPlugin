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
						<cfcase value="EmailUpComingEvents">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div class="alert alert-success"><p>You have successfully sent an email with the PDF Attachment of all upcoming events currently active in the system. Depending on the number of participants, this process can take a few minutes before the email shows up in the user's inbox.</p></div>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="SentPGPCertificates">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div class="alert alert-success"><p>You have successfully scheduled PGP Certificates to be sent to anyone who has attended the event. Depending on the number of PGP Certificates will depend on how fast they are electronically tramsferred to the participants inbox.</p></div>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="RemovedParticipants">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div class="alert alert-success"><p>You have successfully removed participants from the event. If you selected the option to send confirmation email messages the participant will be receiving this communication within the next few minutes.</p></div>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="EmailParticipants">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div class="alert alert-success"><p>You have successfully send registered participants an email message regarding the event. The system in in process of delivering these messages and depending on how many registered participants will depend on how much time will pass</p></div>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="EmailAttended">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div class="alert alert-success"><p>You have successfully send attended participants an email message regarding the event. The system in in process of delivering these messages and depending on how many attended participants will depend on how much time will pass</p></div>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="ParticipantsRegistered">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div class="alert alert-success"><p>You have successfully registered participants to the event. If you selected the option to send confirmation emails they are in process to be delivered to the participants at this time.</p></div>
								</cfif>
							</cfif>
						</cfcase>
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
								<cfelseif URL.Successful EQ "True">
									<div class="alert alert-success"><p>You have successfully cancelled this event and anyone who was registered for this event is receiving an email message letting them know of this action.</p></div>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="EventCopied">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "False">
									<div class="alert alert-info"><p>Event was not copied due to selecting the 'No' option when asked if you really want to copy this event to a new event.</p></div>
								<cfelseif URL.Successful EQ "True">
									<div class="alert alert-success"><p>You have successfully copied the event to a new event. Make the necessary changes to the new event as necessary.</p></div>
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
									AttendedEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_boolean"> or
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_boolean"> or
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_boolean"> or
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_boolean"> or
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_boolean"> or
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_boolean">
							</cfquery>
							<cfquery name="getRegisteredParticipantsForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID, User_ID
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEventDate1 = <cfqueryparam value="0" cfsqltype="cf_sql_boolean"> or
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEventDate2 = <cfqueryparam value="0" cfsqltype="cf_sql_boolean"> or
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEventDate3 = <cfqueryparam value="0" cfsqltype="cf_sql_boolean"> or
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEventDate4 = <cfqueryparam value="0" cfsqltype="cf_sql_boolean"> or
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEventDate5 = <cfqueryparam value="0" cfsqltype="cf_sql_boolean"> or
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEventDate6 = <cfqueryparam value="0" cfsqltype="cf_sql_boolean">
							</cfquery>
							<cfquery name="getEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID
								From p_EventRegistration_EventExpenses
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									Event_ID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<tr>
								<td width="50%">(<a href="http://#cgi.server_name#/?Info=#Session.getAvailableEvents.TContent_ID#">#Session.getAvailableEvents.TContent_ID#</a>) / #Session.getAvailableEvents.ShortTitle#</td>
								<td width="15%"><cfif DateDiff("d", Now(), Session.getAvailableEvents.EventDate) GTE 0>#DateFormat(Session.getAvailableEvents.EventDate, "mmm dd, yy")#<br><cfelse></cfif>
									<cfif LEN(Session.getAvailableEvents.EventDate1) OR LEN(Session.getAvailableEvents.EventDate2) OR LEN(Session.getAvailableEvents.EventDate3) OR LEN(Session.getAvailableEvents.EventDate4) OR LEN(Session.getAvailableEvents.EventDate5)>
										<cfif LEN(Session.getAvailableEvents.EventDate1) and DateDiff("d", Now(), Session.getAvailableEvents.EventDate1) GTE 0>#DateFormat(Session.getAvailableEvents.EventDate1, "mmm dd, yy")#<br></cfif>
										<cfif LEN(Session.getAvailableEvents.EventDate2) and DateDiff("d", Now(), Session.getAvailableEvents.EventDate2) GTE 0>#DateFormat(Session.getAvailableEvents.EventDate2, "mmm dd, yy")#<br></cfif>
										<cfif LEN(Session.getAvailableEvents.EventDate3) and DateDiff("d", Now(), Session.getAvailableEvents.EventDate3) GTE 0>#DateFormat(Session.getAvailableEvents.EventDate3, "mmm dd, yy")#<br></cfif>
										<cfif LEN(Session.getAvailableEvents.EventDate4) and DateDiff("d", Now(), Session.getAvailableEvents.EventDate4) GTE 0>#DateFormat(Session.getAvailableEvents.EventDate4, "mmm dd, yy")#<br></cfif>
										<cfif LEN(Session.getAvailableEvents.EventDate5) and DateDiff("d", Now(), Session.getAvailableEvents.EventDate5) GTE 0>#DateFormat(Session.getAvailableEvents.EventDate5, "mmm dd, yy")#<br></cfif>
									</cfif>
								</td>
								<td>
									<a href="#buildURL('eventcoord:events.updateevent_review')#&EventID=#Session.getAvailableEvents.TContent_ID#" role="button" class="btn btn-primary btn-small"><small>Update</small></a>
									<a href="#buildURL('eventcoord:events.cancelevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Cancel</small></a>
									<a href="#buildURL('eventcoord:events.copyevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Copy</small></a>
									<a href="#buildURL('eventcoord:events.registeruserforevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Register</small></a>
									<a href="#buildURL('eventcoord:events.geteventinfo')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Info</small></a><br />
									<cfif getRegisteredParticipantsForEvent.RecordCount>
										<a href="#buildURL('eventcoord:events.deregisteruserforevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>De-Register</small></a>
										<a href="#buildURL('eventcoord:events.emailregistered')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Email Registered</small></a>
										<a href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Sign-In Sheet</small></a><br>
										<a href="#buildURL('eventcoord:events.signinparticipant')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Sign-In Participant</small></a>
										<a href="#buildURL('eventcoord:events.namebadges')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Name Badges</small></a>
									</cfif>
									<cfif getAttendedParticipantsForEvent.RecordCount>
										<a href="#buildURL('eventcoord:events.emailattended')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Email Attended</small></a>
										<cfif Session.getAvailableEvents.PGPAvailable EQ 1><a href="#buildURL('eventcoord:events.sendpgpcertificates')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Send PGP Certificates</small></a></cfif>
										<a href="#buildURL('eventcoord:events.enterexpenses')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Enter Expenses</small></a>
									</cfif>
									<a href="#buildURL('eventcoord:events.publishtofb')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small small"><small>Post to Facebook</small></a><br>
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
	<cfdump var="#Application.configBean.getPluginManager()#">
</cfoutput>