<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cfif isDefined("URL.Successful")>
	<cfswitch expression="#URL.Successful#">
		<cfcase value="true">
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="AddedEventExpense">
						<div class="alert-box success">
							<p>Your have successfully added a new expense for this event.</p>
						</div>
					</cfcase>
				</cfswitch>
			</cfif>
		</cfcase>
		<cfcase value="false">
			<cfswitch expression="#URL.UserAction#">
				<cfcase value="NoRegistrations">
					<div class="alert-box notice">
						<p>The Event you tried to send an email to did not have any users registered for it. For this reason emails were not sent from this system.</p>
					</div>
				</cfcase>
			</cfswitch>
		</cfcase>
	</cfswitch>
</cfif>
<cfoutput>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Profit / Loss Report: Review Income Participant Charges for #Session.getEvent.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<table class="art-article" style="width:100%;">
				<thead>
					<tr>
						<td colspan="6" style="Font-Family: Arial; Font-Size: 12px;">
							Member Cost: #DollarFormat(Session.getEvent.MemberCost)#<br>
							NonMember Cost: #DollarFormat(Session.getEvent.NonMemberCost)#<hr>
							<cfif Session.getEvent.EarlyBird_RegistrationAvailable IS 1>
								EarlyBird Registration Deadline: #DateFormat(Session.getEvent.EarlyBird_RegistrationDeadline, "full")#<br>
								EarlyBird Member Cost: #DollarFormat(Session.getEvent.EarlyBird_MemberCost)#<br>
								EarlyBird NonMember Cost: #DollarFormat(Session.getEvent.EarlyBird_NonMemberCost)#<hr>
							</cfif>
							<cfif Session.getEvent.ViewSpecialPricing IS 1>
								Special Pricing Requirements: #Session.getEvent.SpecialPriceRequirements#<br>
								Special Price Member Cost: #DollarFormat(Session.getEvent.SpecialMemberCost)#<br>
								Special Price NonMember Cost: #DollarFormat(Session.getEvent.SpecialNonMemberCost)#<hr>
							</cfif>
							Video Conference Cost: #DollarFormat(Session.getEvent.VideoConferenceCost)#<hr>
							Webinar Member Cost: #DollarFormat(Session.getEvent.WebinarMemberCost)#<br>
							Webinar NonMember Cost: #DollarFormat(Session.getEvent.WebinarNonMemberCost)#<br>
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
				<cfif Session.getRegistrations.RecordCount>
					<cfset IncomeAmount = 0>
					<tbody>
						<cfloop query="Session.getRegistrations">
							<cfset UserEmailDomain = #Right(Session.getRegistrations.EMail, Len(Session.getRegistrations.Email) - Find("@", Session.getRegistrations.Email))#>
							<cfquery name="getUserMembership" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								SELECT OrganizationName, OrganizationDomainName, Active
								From eMembership
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									OrganizationDomainName = <cfqueryparam value="#Variables.UserEmailDomain#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif Len(Session.getRegistrations.AttendeePrice) EQ 0>
								<cfset Session.getRegistrations.AttendeePrice = 0>
							</cfif>
							<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
								<td width="30%" style="Font-Family: Arial; Font-Size: 12px;">#Session.getRegistrations.Fname# #Session.getRegistrations.Lname#</td>
								<td width="30%" style="Font-Family: Arial; Font-Size: 12px;">#getUserMembership.OrganizationName#</td>
								<td width="15%" style="Font-Family: Arial; Font-Size: 12px;"><cfif getUserMembership.Active IS 1>Yes<cfelse>No</cfif></td>
								<td width="15%" style="Font-Family: Arial; Font-Size: 12px;">#DateFormat(Session.getRegistrations.RegistrationDate, "mmm dd, yyyy")#</td>
								<td style="Font-Family: Arial; Font-Size: 12px;">#DollarFormat(Session.getRegistrations.AttendeePrice)#</td>
								<td style="Font-Family: Arial; Font-Size: 12px;">
									<cfif Session.getRegistrations.AttendeePriceVerified EQ 0>
										<a href="#buildURL('admin:events.updateparticipantcost')#&EventID=#URl.EventID#&RegistrationID=#Session.getRegistrations.TContent_ID#" class="art-button">Update Cost</a>
									<cfelse>&nbsp;</cfif>
								</td>
							</tr>
							<cfset IncomeAmount = #Variables.IncomeAmount# + #Session.getRegistrations.AttendeePrice#>
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
							<td colspan="6" style="Font-Family: Arial; Font-Size: 12px;"><a href="#buildURL('admin:events.updateeventexpenses')#&EventID=#URL.EventID#" class="art-button">Proceed to Event Expenses</a></td>
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
		</div>
	</div>
</cfoutput>