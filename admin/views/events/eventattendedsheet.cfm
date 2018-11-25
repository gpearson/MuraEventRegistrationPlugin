<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>

<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
</cflock>

<cfset EventDateQuery = #QueryNew("EventDate")#>
<cfif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) EQ 0 and LEN(Session.getSelectedEvent.EventDate2) EQ 0 and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
	<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate)#>
<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) EQ 0 and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
	<cfset temp = #QueryAddRow(EventDateQuery, 2)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
	<cfset temp = #QueryAddRow(EventDateQuery, 3)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
	<cfset temp = #QueryAddRow(EventDateQuery, 4)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate3, 4)#>
<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) and LEN(Session.getSelectedEvent.EventDate4)>
	<cfset temp = #QueryAddRow(EventDateQuery, 5)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate, 1)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate1, 2)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate2, 3)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate3, 4)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", Session.getSelectedEvent.EventDate4, 5)#>
</cfif>
<cfset EventDates = ValueList(EventDateQuery.EventDate, ",")>

<cfoutput>
	<div class="art-blockheader">
		<h3 class="t">Event Attended Report Document</h3>
	</div>
	<div class="alert-box notice">Below is the participants who attended the selected event or workshop. Click <A href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:events.default" class="art-button">here</a> to return to the listing of available events.</div>
	<hr>
	<cfif ListLen(Variables.EventDates) GTE 2 and not isDefined("URL.EventDatePOS")>
		<Table style="border-width: 3px; border-spacing: 1px; border-style: outset; border-color: gray; border-collapse: separate; background-color: ##EDEDED;" Align="Center" Width="100%">
			<tr>
				<cfif ListLen(Variables.EventDates) GTE 1><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('admin:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 2><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('admin:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 3><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('admin:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 4><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('admin:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=4">SignIn Sheet Day 4</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 5><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('admin:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=5">SignIn Sheet Day 5</a></td></cfif>
			</tr>
			<tr>
				<td Style="border-width: thin; padding: 0px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Bold;" colspan="5"></td>
			</tr>
		</Table>
	<cfelse>
		<cfif isDefined("URL.AttendeePriceVerified")>
			<cfif URL.AttendeePriceVerified EQ "Yes">
				<cfquery name="UpdateAttendeePriceVerified" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update eRegistrations
					Set AttendeePriceVerified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
					Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and AttendedEvent = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				</cfquery>
			</cfif>
			<cfset getParticipants = #StructCopy(Session.getAttendedParticipants)#>
			<cfset StructClear(getParticipants)>
			<cfloop query="Session.getAttendedParticipants">
				<cfset temp = QueryAddRow(getParticipants)>
				<cfset temp = QuerySetCell(getParticipants, "Fname", Session.getAttendedParticipants.Fname)>
				<cfset temp = QuerySetCell(getParticipants, "Lname", Session.getAttendedParticipants.Lname)>
				<cfset temp = QuerySetCell(getParticipants, "Email", Session.getAttendedParticipants.Email)>
				<cfset temp = QuerySetCell(getParticipants, "Domain", Session.getAttendedParticipants.Domain)>
				<cfset temp = QuerySetCell(getParticipants, "ShortTitle", Session.getAttendedParticipants.ShortTitle)>
				<cfset temp = QuerySetCell(getParticipants, "EventDateFormat", Session.getAttendedParticipants.EventDateFormat)>
				<cfset temp = QuerySetCell(getParticipants, "CostToAttend", DollarFormat(Session.getAttendedParticipants.AttendeePrice))>
				<cfif Session.getAttendedParticipants.RequestsMeal EQ 1><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "No")></cfif>
				<cfif Session.getAttendedParticipants.IVCParticipant EQ 1><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "No")></cfif>
				<cfif Session.getAttendedParticipants.AttendedEvent EQ 1><cfset temp = QuerySetCell(getParticipants, "AttendedEvent", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "AttendedEvent", "No")></cfif>
			</cfloop>
			<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
			<cfset LogoPath = ArrayNew(1)>
			<cfloop from="1" to="#Session.getAttendedParticipants.RecordCount#" step="1" index="i">
				<cfset LogoPath[i] = #ExpandPath("/plugins/EventRegistration/library/images/NIESC_Logo.png")#>
			</cfloop>
			<cfset temp = QueryAddColumn(getParticipants, "NIESCLogoPath", "VarChar", Variables.LogoPath)>
			<cfset ReportDirectory = #ExpandPath("/plugins/EventRegistration/library/reports/")# >
			<cfset ReportExportLoc = #ExpandPath("/plugins/EventRegistration/library/ReportExports/")# & #URL.EventID# & "EventAttendedParticipantsSheet.pdf" >
			<jr:jasperreport jrxml="#ReportDirectory#/EventAttendedSheet.jrxml" query="#getParticipants#" exportfile="#ReportExportLoc#" exportType="pdf" />
			<!---
				<cf_jasperreport jrxml="#ReportDirectory#/EventSignInSheet.jrxml" filename="#ReportExportLoc#" exporttype="pdf" query="#getRegisteredParticipants#" />
			--->
			<embed src="/plugins/EventRegistration/library/ReportExports/#URL.EventID#EventAttendedParticipantsSheet.pdf" width="850" height="650">
		<cfelseif not isdefined("URL.AttendeePriceVerified")>
			<cfset NeedToVerifyAttendeePrice = 0>
			<cfloop query="Session.getAttendedParticipants">
				<cfif Session.getAttendedParticipants.AttendeePriceVerified EQ 0>
					<cfset NeedToVerifyAttendeePrice = 1>
				</cfif>
			</cfloop>
			<cfif Variables.NeedToVerifyAttendeePrice EQ 0>
				<cfset getParticipants = #StructCopy(Session.getAttendedParticipants)#>
				<cfset StructClear(getParticipants)>
				<cfloop query="Session.getAttendedParticipants">
					<cfset temp = QueryAddRow(getParticipants)>
					<cfset temp = QuerySetCell(getParticipants, "Fname", Session.getAttendedParticipants.Fname)>
					<cfset temp = QuerySetCell(getParticipants, "Lname", Session.getAttendedParticipants.Lname)>
					<cfset temp = QuerySetCell(getParticipants, "Email", Session.getAttendedParticipants.Email)>
					<cfset temp = QuerySetCell(getParticipants, "Domain", Session.getAttendedParticipants.Domain)>
					<cfset temp = QuerySetCell(getParticipants, "ShortTitle", Session.getAttendedParticipants.ShortTitle)>
					<cfset temp = QuerySetCell(getParticipants, "EventDateFormat", Session.getAttendedParticipants.EventDateFormat)>
					<cfset temp = QuerySetCell(getParticipants, "CostToAttend", DollarFormat(Session.getAttendedParticipants.AttendeePrice))>
					<cfif Session.getAttendedParticipants.RequestsMeal EQ 1><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "No")></cfif>
					<cfif Session.getAttendedParticipants.IVCParticipant EQ 1><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "No")></cfif>
					<cfif Session.getAttendedParticipants.AttendedEvent EQ 1><cfset temp = QuerySetCell(getParticipants, "AttendedEvent", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "AttendedEvent", "No")></cfif>
				</cfloop>
				<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
				<cfset LogoPath = ArrayNew(1)>
				<cfloop from="1" to="#Session.getAttendedParticipants.RecordCount#" step="1" index="i">
					<cfset LogoPath[i] = #ExpandPath("/plugins/EventRegistration/library/images/NIESC_Logo.png")#>
				</cfloop>
				<cfset temp = QueryAddColumn(getParticipants, "NIESCLogoPath", "VarChar", Variables.LogoPath)>
				<cfset ReportDirectory = #ExpandPath("/plugins/EventRegistration/library/reports/")# >
				<cfset ReportExportLoc = #ExpandPath("/plugins/EventRegistration/library/ReportExports/")# & #URL.EventID# & "EventAttendedParticipantsSheet.pdf" >
				<jr:jasperreport jrxml="#ReportDirectory#/EventAttendedSheet.jrxml" query="#getParticipants#" exportfile="#ReportExportLoc#" exportType="pdf" />
				<!---
					<cf_jasperreport jrxml="#ReportDirectory#/EventSignInSheet.jrxml" filename="#ReportExportLoc#" exporttype="pdf" query="#getRegisteredParticipants#" />
				--->
				<embed src="/plugins/EventRegistration/library/ReportExports/#URL.EventID#EventAttendedParticipantsSheet.pdf" width="850" height="650">
			<cfelseif Variables.NeedToVerifyAttendeePrice EQ 1>
				<table class="art-article" style="width:100%;">
					<thead>
						<tr>
							<td colspan="6" style="Font-Family: Arial; Font-Size: 12px;">
								Member Cost: #DollarFormat(Session.getSelectedEvent.MemberCost)#<br>
								NonMember Cost: #DollarFormat(Session.getSelectedEvent.NonMemberCost)#<hr>
								<cfif Session.getSelectedEvent.EarlyBird_RegistrationAvailable IS 1>
									EarlyBird Registration Deadline: #DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, "full")#<br>
									EarlyBird Member Cost: #DollarFormat(Session.getSelectedEvent.EarlyBird_MemberCost)#<br>
									EarlyBird NonMember Cost: #DollarFormat(Session.getSelectedEvent.EarlyBird_NonMemberCost)#<hr>
								</cfif>
								<cfif Session.getSelectedEvent.ViewSpecialPricing IS 1>
									Special Pricing Requirements: #Session.getSelectedEvent.SpecialPriceRequirements#<br>
									Special Price Member Cost: #DollarFormat(Session.getSelectedEvent.SpecialMemberCost)#<br>
									Special Price NonMember Cost: #DollarFormat(Session.getSelectedEvent.SpecialNonMemberCost)#<hr>
								</cfif>
								Video Conference Cost: #DollarFormat(Session.getSelectedEvent.VideoConferenceCost)#<hr>
								Webinar Member Cost: #DollarFormat(Session.getSelectedEvent.WebinarMemberCost)#<br>
								Webinar NonMember Cost: #DollarFormat(Session.getSelectedEvent.WebinarNonMemberCost)#<br>
							</td>
						</tr>
						<tr>
							<td width="30%" style="Font-Family: Arial; Font-Size: 12px;">Participant's Name</td>
							<td width="30%" style="Font-Family: Arial; Font-Size: 12px;">School District</td>
							<td width="15%" style="Font-Family: Arial; Font-Size: 12px;">Membership</td>
							<td width="15%" style="Font-Family: Arial; Font-Size: 12px;">Registration Date</td>
							<td style="Font-Family: Arial; Font-Size: 12px;">Charges</td>
							<td width="20%" style="Font-Family: Arial; Font-Size: 12px;">Actions</td>
						</tr>
					</thead>
					<cfif Session.getAttendedParticipants.RecordCount>
						<cfset IncomeAmount = 0>
						<tbody>
							<cfloop query="Session.getAttendedParticipants">
								<cfset UserEmailDomain = #Right(Session.getAttendedParticipants.EMail, Len(Session.getAttendedParticipants.Email) - Find("@", Session.getAttendedParticipants.Email))#>
								<cfquery name="getUserMembership" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT OrganizationName, OrganizationDomainName, Active
									From eMembership
									Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										OrganizationDomainName = <cfqueryparam value="#Variables.UserEmailDomain#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif Len(Session.getAttendedParticipants.AttendeePrice) EQ 0>
									<cfset Session.getAttendedParticipants.AttendeePrice = 0>
								</cfif>
								<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
									<td width="30%" style="Font-Family: Arial; Font-Size: 12px;">#Session.getAttendedParticipants.Fname# #Session.getAttendedParticipants.Lname#</td>
									<td width="30%" style="Font-Family: Arial; Font-Size: 12px;">#getUserMembership.OrganizationName#</td>
									<td width="15%" style="Font-Family: Arial; Font-Size: 12px;"><cfif getUserMembership.Active IS 1>Yes<cfelse>No</cfif></td>
									<td width="15%" style="Font-Family: Arial; Font-Size: 12px;">#DateFormat(Session.getAttendedParticipants.RegistrationDate, "mmm dd, yyyy")#</td>
									<td style="Font-Family: Arial; Font-Size: 12px;">#DollarFormat(Session.getAttendedParticipants.AttendeePrice)#</td>
									<td style="Font-Family: Arial; Font-Size: 12px;">
										<cfif Session.getAttendedParticipants.AttendeePriceVerified EQ 0>
											<a href="#buildURL('admin:events.updateparticipantcost2')#&EventID=#URl.EventID#&RegistrationID=#Session.getAttendedParticipants.TContent_ID#" class="art-button">Update Cost</a>
										<cfelse>&nbsp;</cfif>
									</td>
								</tr>
								<cfset IncomeAmount = #Variables.IncomeAmount# + #Session.getAttendedParticipants.AttendeePrice#>
							</cfloop>
							<cfif LEN(Session.getEventIncomeFromOtherParty.Event_TotalIncomeFromOtherParty)>
								<tr>
									<td colspan="5" style="Font-Family: Arial; Font-Size: 12px;">Income From Other Party</td>
									<td style="Font-Family: Arial; Font-Size: 12px;">#DollarFormat(Session.getEventIncomeFromOtherParty.Event_TotalIncomeFromOtherParty)#</td>
								</tr>
								<cfset IncomeAmount = #Variables.IncomeAmount# + #Session.getEventIncomeFromOtherParty.Event_TotalIncomeFromOtherParty#>
							</cfif>
						</tbody>
						<tfoot>
							<tr>
								<td colspan="5" style="Font-Family: Arial; Font-Size: 12px;">Tentative Income Amount</td>
								<td style="Font-Family: Arial; Font-Size: 12px;">#DollarFormat(Variables.IncomeAmount)#</td>
							</tr>
							<tr>
								<td colspan="6" style="Font-Family: Arial; Font-Size: 12px;"><a href="#buildURL('admin:events.eventattendedsheet')#&EventID=#URL.EventID#&AttendeePriceVerified=Yes" class="art-button">Proceed to Display Report</a></td>
							</tr>
						</tfoot>
					<cfelse>
						<!--- <tbody>
							<tr>
								<td colspan="6"><div align="center" class="alert-box notice">No Event Expenses have been located within the database. Please click <a href="#buildURL('admin:events.addeventexpenses')#&EventID=#URL.EventID#" class="art-button">here</a> to add a new expense for this event.</div></td>
							</tr>
						</tbody> --->
					</cfif>
				</table>
			</cfif>
			</div>
			</div>
		</cfif>
	</cfif>
</cfoutput>