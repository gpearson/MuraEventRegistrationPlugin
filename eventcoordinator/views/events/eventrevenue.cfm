<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
<cfif LEN(cgi.path_info)><cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# ><cfelse><cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action#></cfif>
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<cfform action="" method="post" id="VerifyIncomeRevenue" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<fieldset>
				<legend><h2>Event Revenue Confirmation: #Session.getSelectedEvent.ShortTitle#</h2></legend>
			</fieldset>
			<div class="alert alert-info">Please verify the amounts for each participant who attended this event</div>
			<div class="panel-body">
				<div class="alert alert-info">This event has the following costs to participants who attended this event:
					<br><table border="0" class="table" width="100%"><tbody><tr><th>Member Pricing</th><td>#DollarFormat(Session.getSelectedEvent.Event_MemberCost)#</td></tr><tr><th>NonMember Pricing</th><td>#DollarFormat(Session.getSelectedEvent.Event_NonMemberCost)#</td></tr><tr><th>Registration Deadline</th><td>#DateFormat(Session.getSelectedEvent.Registration_Deadline, "full")#</td></tr></tbody></table>
				</div>
				<cfif Session.getSelectedEvent.EventPricePerDay EQ 1>
					<div class="alert alert-info">This event was configured that the published cost to participants was for each event date instead of a single event cost for all event dates.</div>
				</cfif>
				<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1>
					<div class="alert alert-info">This event has Early Bird Registration enabled which has the following costs for this option:<br>
						<table border="0" class="table" width="100%">
							<thead><tr><td>#DateFormat(Session.getSelectedEvent.EarlyBird_Available, "full")#</td></tr></thead>
							<tbody><tr><th>Member Pricing</th><td>#DollarFormat(Session.getSelectedEvent.EarlyBird_MemberCost)#</td></tr><tr><th>NonMember Pricing</th><td>#DollarFormat(Session.getSelectedEvent.EarlyBird_NonMemberCost)#</td></tr>
							</tbody>
						</table>
					</div>
				</cfif>
				<cfif Session.getSelectedEvent.GroupPrice_Available EQ 1>
					<div class="alert alert-info">This event has Group Price enabledwhich has the following costs for this option:<br>
						<table border="0" class="table" width="100%">
							<thead><tr><td>#Session.getSelectedEvent.GroupPrice_Requirements#</td></tr></thead>
							<tbody><tr><th>Member Pricing</th><td>#DollarFormat(Session.getSelectedEvent.Webinar_MemberCost)#</td></tr><tr><th>NonMember Pricing</th><td>#DollarFormat(Session.getSelectedEvent.Webinar_NonMemberCost)#</td></tr>
							</tbody>
						</table>
					</div>
				</cfif>
				<cfif Session.getSelectedEvent.Webinar_Available EQ 1>
					<div class="alert alert-info">This event has Webinar Option enabled which has the following costs for this option:<br>
						<table border="0" class="table" width="100%">
							<tbody><tr><th>Member Pricing</th><td>#DollarFormat(Session.getSelectedEvent.Webinar_MemberCost)#</td></tr><tr><th>NonMember Pricing</th><td>#DollarFormat(Session.getSelectedEvent.Webinar_NonMemberCost)#</td></tr>
							</tbody>
						</table>
					</div>
				</cfif>
				<cfif Session.getSelectedEvent.H323_Available EQ 1>
					<div class="alert alert-info">This event has H323 Option enabled which has the following costs for this option:<br>
						<table border="0" class="table" width="100%">
							<tbody><tr><th>Member Pricing</th><td>#DollarFormat(Session.getSelectedEvent.H323_MemberCost)#</td></tr><tr><th>NonMember Pricing</th><td>#DollarFormat(Session.getSelectedEvent.H323_NonMemberCost)#</td></tr>
							</tbody>
						</table>
					</div>
				</cfif>
				<cfif Session.getSelectedEvent.BillForNoShow EQ 1>
					<div class="alert alert-info">This event has been configured to Bill Participants who have registered and did not attend the event.</div>
				</cfif>
			</div>
			<div class="panel-body">
				<cfset TotalParticipants = 0>

				<table border="0" class="table table-striped" cellspacing="0" cellpadding="0" width="100%">
					<thead>
						<tr>
							<th style="font-family: Arial; font-size: 12px; text-align: left">Participant's Name</th>
							<th style="font-family: Arial; font-size: 12px; text-align: left">Email Address</th>
							<th style="font-family: Arial; font-size: 12px; text-align: left">Membership</th>
							<th style="font-family: Arial; font-size: 12px; text-align: left">Registration Date</th>
							<th style="font-family: Arial; font-size: 12px; text-align: left">Days Attended</th>
							<th style="font-family: Arial; font-size: 12px; text-align: left">Event Cost</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="#Session.getRegisteredParticipants#">
							<cfset ParticipantRegisteredForDays = 0>
							<cfset ParticipantAttendedDays = 0>
							<cfquery name="GetMembershipStatus" dbtype="Query">
								Select *
								From Session.GetMembershipOrganizations
								Where OrganizationDomainName = <cfqueryparam value="#Session.getRegisteredParticipants.Domain#" cfsqltype="cf_sql_varchar">
							</cfquery>

							<cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfset ParticipantRegisteredForDays = #Variables.ParticipantRegisteredForDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfset ParticipantRegisteredForDays = #Variables.ParticipantRegisteredForDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfset ParticipantRegisteredForDays = #Variables.ParticipantRegisteredForDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfset ParticipantRegisteredForDays = #Variables.ParticipantRegisteredForDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfset ParticipantRegisteredForDays = #Variables.ParticipantRegisteredForDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.RegisterForEventDate6 EQ 1><cfset ParticipantRegisteredForDays = #Variables.ParticipantRegisteredForDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.RegisterForEventSessionAM EQ 1><cfset ParticipantRegisteredForDays = #Variables.ParticipantRegisteredForDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.RegisterForEventSessionPM EQ 1><cfset ParticipantRegisteredForDays = #Variables.ParticipantRegisteredForDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.AttendedEventDate1 EQ 1><cfset ParticipantAttendedDays = #Variables.ParticipantAttendedDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.AttendedEventDate2 EQ 1><cfset ParticipantAttendedDays = #Variables.ParticipantAttendedDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.AttendedEventDate3 EQ 1><cfset ParticipantAttendedDays = #Variables.ParticipantAttendedDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.AttendedEventDate4 EQ 1><cfset ParticipantAttendedDays = #Variables.ParticipantAttendedDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.AttendedEventDate5 EQ 1><cfset ParticipantAttendedDays = #Variables.ParticipantAttendedDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.AttendedEventDate6 EQ 1><cfset ParticipantAttendedDays = #Variables.ParticipantAttendedDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.AttendedEventSessionAM EQ 1><cfset ParticipantAttendedDays = #Variables.ParticipantAttendedDays# + 1></cfif>
							<cfif Session.getRegisteredParticipants.AttendedEventSessionPM EQ 1><cfset ParticipantAttendedDays = #Variables.ParticipantAttendedDays# + 1></cfif>
							<tr>
							<td style="font-family: Arial; font-size: 12px; text-align: left">#Session.getRegisteredParticipants.Fname# #Session.getRegisteredParticipants.Lname#</td>
							<td style="font-family: Arial; font-size: 12px; text-align: left">#Session.getRegisteredParticipants.Email#</td>
							<td style="font-family: Arial; font-size: 12px; text-align: left"><cfswitch expression="#GetMembershipStatus.Active#"><cfcase value="1">Yes</cfcase><cfdefaultcase>No</cfdefaultcase></cfswitch></td>
							<td style="font-family: Arial; font-size: 12px; text-align: left">#DateFormat(Session.getRegisteredParticipants.RegistrationDate, "short")#</td>
							<td style="font-family: Arial; font-size: 12px; text-align: left">#Variables.ParticipantAttendedDays#</td>
							<td style="font-family: Arial; font-size: 12px; text-align: left"><cfif Session.getSelectedEvent.BillForNoShow EQ 1 and Variables.ParticipantAttendedDays EQ 0>
								<input type="text" name="ParticipantCost_#Session.getRegisteredParticipants.User_ID#" Value="#NumberFormat(Session.getRegisteredParticipants.AttendeePrice, "999.99")#">
							<cfelseif Session.getSelectedEvent.EventPricePerDay EQ 1>
								<cfset TotalCost = #Variables.ParticipantAttendedDays# * #Session.getRegisteredparticipants.AttendeePrice#>
								<input type="text" name="ParticipantCost_#Session.getRegisteredParticipants.User_ID#" Value="#NumberFormat(Variables.TotalCost, "999.99")#">
							<cfelse>
								<input type="text" name="ParticipantCost_#Session.getRegisteredParticipants.User_ID#" Value="#NumberFormat(Session.getRegisteredParticipants.AttendeePrice, "999.99")#">
							</cfif>
							</td>
							</tr>
							<cfset Variables.TotalParticipants = #Variables.TotalParticipants# + 1>
						</cfloop>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="5"></td>
						</tr>
					</tfoot>
				</table>
			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Events Menu">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Event Income Verified"><br /><br />
			</div>
		</cfform>
	</div>
</cfoutput>