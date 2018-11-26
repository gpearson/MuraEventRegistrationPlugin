<cfif not isDefined("URL.EventID") and Session.Mura.IsLoggedIn EQ "True">
	<cfoutput>
		<cfif isDefined("URL.CancelEventAborted")>
			<br>
			<div class="alert-box error">The Event has not been cancelled due to your selection on the event cancellation form. If this not your intention, please go through the process and select Yes, Cancel Registration to cancel your registration to the event.</div>
		</cfif>
		<cfif isDefined("URL.CancelEventSuccessfull")>
			<br><div class="alert-box success">The Event has been cancelled from your account. If this was done in error, you will need to register for this event again.</div>
		</cfif>
		<h2>Your Registered Events</h2>
		<cfif GetRegisteredEvents.RecordCount EQ 0>
			<div class="alert-box notice"><p class="text-center">You currently are not registered for any active events at this time.</p></div>
		<cfelse>
			<div class="alert-box success">The table lists all of the current events which you either registered for or someone has registered for you.</div>
			<hr>
			<table class="art-article" style="width: 100%;" cellspacing="0" cellpadding="0">
				<tr style="font-face: Arial; font-weight: bold; font-size: 14px;">
					<th width="50%">Event Title</th>
					<th width="25%">Event Date</th>
					<th>Actions</th>
				</tr>
				<cfloop query="GetRegisteredEvents">
				<tr style="font-face: Arial; font-weight: normal; font-size: 12px;">
					<td width="50%">#GetRegisteredEvents.ShortTitle#</td>
					<td width="25%">#DateFormat(GetRegisteredEvents.EventDate, "mm/dd/yyyy")#</td>
					<td>
						<cfif GetRegisteredEvents.AttendedEvent EQ 0>
							<a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.manageregistrations" class="art-button" alt="Cancel Event">Manage Registration</a>
						<cfelseif GetRegisteredEvents.AttendedEvent EQ 1 and GetRegisteredEvents.PGPAvailable EQ 1>
							<a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.getcertificate&EventID=#GetRegisteredEvents.EventID#&RegistrationID=#GetRegisteredEvents.RegistrationID#" class="art-button" alt="Retrieve Certificate">Retrieve Certificate</a>
						</cfif>
					</td>
				</tr>
				</cfloop>
			</table>
		</cfif>
	</cfoutput>
<cfelseif Session.Mura.IsLoggedIn EQ "False" and isDefined("URL.EventID")>
	<cflocation url="/index.cfm?EventRegistrationaction=public:events.viewavailableevents" addtoken="false">
</cfif>
