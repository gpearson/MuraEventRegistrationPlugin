<cfif not isDefined("URL.EventID")>
	<cfoutput>
		<div class="panel panel-default">
			<div class="panel-heading"><h2>List of Events with Certificates</h2></div>
			<div class="panel-body">
				<fieldset>
					<legend>List of Events with Certificates</legend>
				</fieldset>
				<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td>Event Title</td>
						<td>Primary Date</td>
						<td width="15%"></td>
					</tr>
					<cfif Session.GetRegisteredEvents.RecordCount GTE 1>
						<cfloop query="Session.GetRegisteredEvents">
							<tr>
							<td>#Session.GetRegisteredEvents.ShortTitle#</td>
							<td>#dateFormat(Session.GetRegisteredEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate, "ddd")#)</td>
							<td width="15%">
								<cfif Session.GetRegisteredEvents.AttendedEventDate1 EQ 1 or Session.GetRegisteredEvents.AttendedEventDate2 EQ 1 or Session.GetRegisteredEvents.AttendedEventDate3 EQ 1 or Session.GetRegisteredEvents.AttendedEventDate4 EQ 1 or Session.GetRegisteredEvents.AttendedEventDate5 EQ 1 or Session.GetRegisteredEvents.AttendedEventDate6 EQ 1>
									<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.getcertificate&EventID=#Session.GetRegisteredEvents.EventID#&DisplayCertificate=True" class="btn btn-primary btn-small" alt="Event Information">Get Certificate</a>
								</cfif>
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
<cfelseif isDefined("URL.EventID") and isDefined("URL.DisplayCertificate")>
	<cfoutput>
		<div class="panel panel-default">
			<div class="panel-body">
				<fieldset>
					<legend>Certificate: #Session.GetSelectedEvent.ShortTitle#</legend>
				</fieldset>
				<embed src="#Session.CertificateCompletedFile#" width="100%" height="650">
			</div>
			<div class="panel-footer">
				<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.eventhistory" class="btn btn-primary btn-small" alt="Event Listing Button">Return to My Event History</a>
			</div>
		</div>
	</cfoutput>
</cfif>