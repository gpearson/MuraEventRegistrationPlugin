<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<cfform action="" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="EventID" value="#URL.EventID#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Revenue for: #Session.getSelectedEvent.ShortTitle#</h2></legend>
				</fieldset>
				<div class="alert alert-warning"><p>Review the Income Section of this Report by the Participants who attended:<br>
					<cfif isDate(Session.getSelectedEvent.EventDate)>#DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.getSelectedEvent.EventDate, "ddd")#)<br></cfif>
					<cfif isDate(Session.getSelectedEvent.EventDate1)>#DateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yyyy")# (#DateFormat(Session.getSelectedEvent.EventDate1, "ddd")#)<br></cfif>
					<cfif isDate(Session.getSelectedEvent.EventDate2)>#DateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yyyy")# (#DateFormat(Session.getSelectedEvent.EventDate2, "ddd")#)<br></cfif>
					<cfif isDate(Session.getSelectedEvent.EventDate3)>#DateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yyyy")# (#DateFormat(Session.getSelectedEvent.EventDate3, "ddd")#)<br></cfif>
					<cfif isDate(Session.getSelectedEvent.EventDate4)>#DateFormat(Session.getSelectedEvent.EventDate4, "mm/dd/yyyy")# (#DateFormat(Session.getSelectedEvent.EventDate4, "ddd")#)<br></cfif>
					<cfif isDate(Session.getSelectedEvent.EventDate1) or isDate(Session.getSelectedEvent.EventDate2) or isDate(Session.getSelectedEvent.EventDate3) or isDate(Session.getSelectedEvent.EventDate4) or isDate(Session.getSelectedEvent.EventDate5)>
						<p><strong>The Amount displayed for each participant is a single day amount.</strong></p>
					</cfif>
				</p></div>
				<cfif Session.getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
					<div class="alert alert-warning"><p><strong>Early Bird Registration Information:</strong><br>Registration Deadline: #DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, "mm/dd/yyyy")#<br><strong>Member Cost:</strong> #DollarFormat(Session.getSelectedEvent.EarlyBird_MemberCost)# - or - <strong>Non MemberCost:</strong> #DollarFormat(Session.getSelectedEvent.EarlyBird_NonMemberCost)#</p></div>
				</cfif>
				<cfif Session.getSelectedEvent.ViewGroupPricing EQ 1>
					<div class="alert alert-warning"><p><strong>Group Pricing Information:</strong><br>Discount Requirements: #Session.getSelectedEvent.GroupPriceRequirements#<br><strong>Member Cost:</strong> #DollarFormat(Session.getSelectedEvent.GroupMemberCost)# - or - <strong>Non MemberCost:</strong> #DollarFormat(Session.getSelectedEvent.GroupNonMemberCost)#</p></div>
				</cfif>
				<cfif Session.getSelectedEvent.AllowVideoConference EQ 1>
					<div class="alert alert-warning"><p><strong>Video Conference Information:</strong><br><strong>Connection Cost:</strong> #DollarFormat(Session.getSelectedEvent.VideoConferenceCost)#</p></div>
				</cfif>
				<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
					<div class="alert alert-warning"><p><strong>Webinar Information:</strong><br><strong>Member Cost:</strong> #DollarFormat(Session.getSelectedEvent.WebinarMemberCost)# - or - <strong>Non Member Cost:</strong> #DollarFormat(Session.getSelectedEvent.WebinarNonMemberCost)#</p></div>
				</cfif>
				<div class="alert alert-warning"><p><strong>General Pricing Information:</strong><br><strong>Member Cost:</strong> #DollarFormat(Session.getSelectedEvent.MemberCost)# -or- <strong>Non Member Cost:</strong> #DollarFormat(Session.getSelectedEvent.NonMemberCost)#</p></div>
				<cfset CurrentCorporation = "">
				<cfset TotalIncome = 0>
				<cfset GrandTotalDays = 0>
				<cfloop query="Session.GetSelectedEventRegistrations">
					<cfif CurrentCorporation IS NOT Session.GetSelectedEventRegistrations.Domain>
						<cfquery name="GetCorpName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select OrganizationName, Active
							From p_EventRegistration_Membership
							Where OrganizationDomainName = <cfqueryparam value="#Session.GetSelectedEventRegistrations.Domain#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfif GetCorpName.RecordCount>
							<cfset CurrentCorporation = #Session.GetSelectedEventRegistrations.Domain#>
							<cfset CurrentCorporationName = #GetCorpName.OrganizationName# & " (" >
							<cfswitch expression="#GetCorpName.Active#">
								<cfcase value="1">
									<cfset CurrentCorporationName = #Variables.CurrentCorporationName# & "Member" >
								</cfcase>
								<cfdefaultcase>
									<cfset CurrentCorporationName = #Variables.CurrentCorporationName# & "Non Member" >
								</cfdefaultcase>
							</cfswitch>
							<cfset CurrentCorporationName = #Variables.CurrentCorporationName# & ")" >
						<cfelse>
							<cfset CurrentCorporation = #Session.GetSelectedEventRegistrations.Domain#>
							<cfset CurrentCorporationName = #Session.GetSelectedEventRegistrations.Domain#>
						</cfif>
						<fieldset>
							<legend><h2>#Variables.CurrentCorporationName#</h2></legend>
						</fieldset>
					</cfif>
					<div class="form-group">
						<label for="ParticipantName" class="control-label col-sm-3">#Session.GetSelectedEventRegistrations.Lname#, #Session.GetSelectedEventRegistrations.FName#:&nbsp;</label>
						<div class="col-sm-2"><cfinput type="text" class="form-control" id="Participants_#Session.GetSelectedEventRegistrations.TContent_ID#" name="Participants_#Session.GetSelectedEventRegistrations.TContent_ID#" value="#NumberFormat(Session.GetSelectedEventRegistrations.AttendeePrice, '9999.99')#" required="no"></div>
						<div class="col-sm-2"><p class="form-control-static"><strong>Date Registered</strong></p></div>
						<div class="col-sm-2"><p class="form-control-static">#DateFormat(Session.GetSelectedEventRegistrations.RegistrationDate, "mm/dd/yyyy")#
							<cfif Session.getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
								<cfif DateDiff("d", Session.GetSelectedEventRegistrations.RegistrationDate, Session.getSelectedEvent.EarlyBird_RegistrationDeadline) LTE 0>
									<span class="glyphicon glyphicon-time"></span>
								</cfif>
							</cfif>
						</p></div>
						<div class="col-sm-2"><p class="form-control-static"><strong>Days Attended</strong></p></div>
						<div class="col-sm-1"><p class="form-control-static">
							<cfset NumberDaysAttended = 0>
							<cfif Session.GetSelectedEventRegistrations.AttendedEventDate1 EQ 1><cfset NumberDaysAttended = #Variables.NumberDaysAttended# + 1></cfif>
							<cfif Session.GetSelectedEventRegistrations.AttendedEventDate2 EQ 1><cfset NumberDaysAttended = #Variables.NumberDaysAttended# + 1></cfif>
							<cfif Session.GetSelectedEventRegistrations.AttendedEventDate3 EQ 1><cfset NumberDaysAttended = #Variables.NumberDaysAttended# + 1></cfif>
							<cfif Session.GetSelectedEventRegistrations.AttendedEventDate4 EQ 1><cfset NumberDaysAttended = #Variables.NumberDaysAttended# + 1></cfif>
							<cfif Session.GetSelectedEventRegistrations.AttendedEventDate5 EQ 1><cfset NumberDaysAttended = #Variables.NumberDaysAttended# + 1></cfif>
							<cfif Session.GetSelectedEventRegistrations.AttendedEventDate6 EQ 1><cfset NumberDaysAttended = #Variables.NumberDaysAttended# + 1></cfif>
							<cfif Session.GetSelectedEventRegistrations.AttendedEventSessionAM EQ 1><cfset NumberDaysAttended = #Variables.NumberDaysAttended# + 1></cfif>
							<cfif Session.GetSelectedEventRegistrations.AttendedEventSessionPM EQ 1><cfset NumberDaysAttended = #Variables.NumberDaysAttended# + 1></cfif>
							#Variables.NumberDaysAttended#
						</p></div>
					</div>
					<cfset GrandTotalDays = #Variables.GrandTotalDays# + 1>
					<cfset TotalIncome = #Variables.TotalIncome# + (#Session.GetSelectedEventRegistrations.AttendeePrice# * #Variables.NumberDaysAttended#)>
					<cfset GrandTotalIncome = #Variables.GrandTotalDays# * #Session.GetSelectedEventRegistrations.AttendeePrice#>
				</cfloop>
				<div class="form-group">
					<div class="col-sm-8"></div>
					<div class="col-sm-2"><strong>Total Revenue Attended</strong></div>
					<div class="col-sm-2">#DollarFormat(Variables.TotalIncome)#</div>
				</div>
				<div class="form-group">
					<div class="col-sm-8"></div>
					<div class="col-sm-2"><strong>Grand Total Revenue</strong></div>
					<div class="col-sm-2">#DollarFormat(Variables.GrandTotalIncome)#</div>
				</div>
			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
`				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Save Revenue and Update Total"><br /><br />
			</div>
		</cfform>
	</div>
</cfoutput>