<cfoutput>
	<div class="panel panel-default">
		<div class="panel-body">
			<fieldset>
				<legend>My Past Events</legend>
			</fieldset>
			<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
				<tr>
					<td width="50%">Event Title</td>
					<td width="15%">Primary Date</td>
					<td>&nbsp;</td>
				</tr>
				<cfif Session.GetPastRegisteredEvents.RecordCount GTE 1>
					<cfloop query="Session.GetPastRegisteredEvents">
						<!--- Logic for PGP Buttons
							1 = PGP Available and Attended
							2 = Did not attend event
							3 = No PGP Available
						--->
						<cfif Session.GetPastRegisteredEvents.AttendedEventDate1 EQ 1 OR Session.GetPastRegisteredEvents.AttendedEventDate2 EQ 1 OR Session.GetPastRegisteredEvents.AttendedEventDate3 EQ 1 OR Session.GetPastRegisteredEvents.AttendedEventDate4 EQ 1 OR Session.GetPastRegisteredEvents.AttendedEventDate5 EQ 1 OR Session.GetPastRegisteredEvents.AttendedEventDate6 EQ 1>
							<cfif Session.GetPastRegisteredEvents.PGPAvailable EQ 0>
								<cfset CertificateStatus = 3>
							<cfelse>
								<cfset CertificateStatus = 1>
							</cfif>
						<cfelse>
							<cfset CertificateStatus = 2>
						</cfif>
						<tr>
						<td>#Session.GetPastRegisteredEvents.ShortTitle#</td>
						<td>
							#dateFormat(Session.GetPastRegisteredEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.GetPastRegisteredEvents.EventDate, "ddd")#)
							<cfif isDate(Session.GetPastRegisteredEvents.EventDate1)><br>#dateFormat(Session.GetPastRegisteredEvents.EventDate1, "mm/dd/yyyy")# (#DateFormat(Session.GetPastRegisteredEvents.EventDate1, "ddd")#)</cfif>
							<cfif isDate(Session.GetPastRegisteredEvents.EventDate2)><br>#dateFormat(Session.GetPastRegisteredEvents.EventDate2, "mm/dd/yyyy")# (#DateFormat(Session.GetPastRegisteredEvents.EventDate2, "ddd")#)</cfif>
							<cfif isDate(Session.GetPastRegisteredEvents.EventDate3)><br>#dateFormat(Session.GetPastRegisteredEvents.EventDate3, "mm/dd/yyyy")# (#DateFormat(Session.GetPastRegisteredEvents.EventDate3, "ddd")#)</cfif>
							<cfif isDate(Session.GetPastRegisteredEvents.EventDate4)><br>#dateFormat(Session.GetPastRegisteredEvents.EventDate4, "mm/dd/yyyy")# (#DateFormat(Session.GetPastRegisteredEvents.EventDate4, "ddd")#)</cfif>
							<cfif isDate(Session.GetPastRegisteredEvents.EventDate5)><br>#dateFormat(Session.GetPastRegisteredEvents.EventDate5, "mm/dd/yyyy")# (#DateFormat(Session.GetPastRegisteredEvents.EventDate5, "ddd")#)</cfif>
						</td>
						<td>
							<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.GetPastRegisteredEvents.EventID#" class="btn btn-primary btn-small pull-right" alt="Event Information">View Event Info</a>
							<div class="pull-right">&nbsp;</div>
							<cfswitch expression="#Variables.CertificateStatus#">
								<cfcase value="1">
									<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.getcertificate&EventID=#Session.GetPastRegisteredEvents.EventID#&DisplayCertificate=True" class="btn btn-primary btn-small pull-right" alt="PGP Certificate">View Certificate</a>
								</cfcase>
								<cfcase value="2">
									<button type="button" class="btn btn-secondary btn-small pull-right">Not Attended</button>
								</cfcase>
								<cfcase value="3">
									<button type="button" class="btn btn-secondary btn-small pull-right">No PGP Available</button>
								</cfcase>
							</cfswitch>
						</td>
						</tr>
					</cfloop>
				<cfelse>
					<tr>
						<td colspan="3" align="center">To view available events you can register for <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default" class="btn btn-primary btn-small" alt="Event Listing Button">click here</a></td>
					</tr>
				</cfif>
			</table>
		</div>
	</div>
</cfoutput>