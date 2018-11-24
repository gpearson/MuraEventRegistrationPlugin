<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cfoutput>
	<cfif not isDefined("URL.UserAction")>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Current Workshop or Event Expenses</h3>
			</div>
			<div class="art-blockcontent">
				<table class="art-article" style="width:100%;">
					<thead>
						<tr>
							<td colspan="3" style="Font-Family: Arial; Font-Size: 12px;">Event Expenses for: #Session.getEvent.ShortTitle#</td>
						</tr>
						<tr>
							<td width="50%" style="Font-Family: Arial; Font-Size: 12px;">Expense Name</td>
							<td width="15%" style="Font-Family: Arial; Font-Size: 12px;">Cost</td>
							<td style="Font-Family: Arial; Font-Size: 12px;">Actions</td>
						</tr>
					</thead>
					<cfif Session.getAvailableEventExpenses.RecordCount>
						<tfoot>
							<tr>
								<td colspan="3" style="Font-Family: Arial; Font-Size: 12px;">Add a new Expense for this event not listed above by clicking <a href="#buildURL('admin:events.updateeventexpenses')#&EventID=#URL.EventID#&UserAction=AddExpenses" class="art-button">here</a> or to enter non-participant revenue click <a href="#buildURL('admin:events.updateeventexpenses')#&EventID=#URL.EventID#&UserAction=AddIncome" class="art-button">here</a></td>
							</tr>
							<tr>
								<td colspan="3" style="Font-Family: Arial; Font-Size: 12px;">Generate Profit and Loss Report by clicking <a href="#buildURL('admin:events.updateeventexpenses')#&EventID=#URL.EventID#&UserAction=GeneratePLReport" class="art-button">here</a></td>
							</tr>
						</tfoot>
						<tbody>
							<cfloop query="Session.getAvailableEventExpenses">
								<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
									<td width="50%">#Session.getAvailableEventExpenses.Expense_Name#</td>
									<td width="15%">#DollarFormat(Session.getAvailableEventExpenses.Cost_Amount)#</td>
									<td>
									</td>
								</tr>
							</cfloop>
						</tbody>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="6"><div align="center" class="alert-box notice">No Event Expenses have been located within the database. Please click <a href="#buildURL('admin:events.updateeventexpenses')#&EventID=#URL.EventID#&UserAction=AddExpenses" class="art-button">here</a> to add a new expense for this event.</div></td>
							</tr>
						</tbody>
					</cfif>
				</table>
			</div>
		</div>
	<cfelseif isDefined("URL.UserAction")>
		<cfswitch expression="#URL.UserAction#">
			<cfcase value="GeneratePLReport">
				<cfquery name="getEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select ShortTitle, MemberCost, NonMemberCost, EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialPriceRequirements, SpecialMemberCost, SpecialNonMemberCost, VideoConferenceCost, WebinarMemberCost, WebinarNonMemberCost
					From eEvents
					Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				</cfquery>

				<cfquery name="getEventParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select Count(TContent_ID) as NumParticipants
					From eRegistrations
					Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
						AttendedEvent = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				</cfquery>

				<cfquery name="EventExpenseCostVerified" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update eEvent_Expenses
					Set Cost_Verified = 1
					Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfquery name="getEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select Cost_Amount
					From eEvent_Expenses
					Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						Cost_Verified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				</cfquery>

				<cfquery name="checkEventMatrix" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select TContent_ID, Event_TotalIncomeFromOtherParty, Event_RebatePerParticipant
					From eEventsMatrix
					Where Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>

				<cfquery name="getEventIncome" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select AttendeePrice
					From eRegistrations
					Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
						AttendedEvent = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
						AttendeePriceVerified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				</cfquery>

				<cfset EventTotalExpenses = 0>
				<cfset EventTotalIncome = 0>
				<cfloop query="getEventExpenses"><cfset EventTotalExpenses = #Variables.EventTotalExpenses# + #getEventExpenses.Cost_Amount#></cfloop>
				<cfloop query="getEventIncome"><cfset EventTotalIncome = #Variables.EventTotalIncome# + #getEventIncome.AttendeePrice#></cfloop>
				<cfif Len(checkEventMatrix.Event_TotalIncomeFromOtherParty) EQ 0>
					<cfset EventTotalIncomeFromParticipants = #Variables.EventTotalIncome#>
				<cfelse>
					<cfset EventTotalIncomeFromParticipants = #Variables.EventTotalIncome#>
					<cfset EventTotalIncomeFromOtherParty = #checkEventMatrix.Event_TotalIncomeFromOtherParty#>
					<cfset EventTotalIncome = #Variables.EventTotalIncomeFromParticipants# + #Variables.EventTotalIncomeFromOtherParty#>
				</cfif>

				<cfif checkEventMatrix.RecordCount>
					<cfquery name="updateEventmatrixInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update eEventsMatrix
						Set Event_TotalExpensesToHold = <cfqueryparam value="#Variables.EventTotalExpenses#" cfsqltype="cf_sql_double">,
							Event_TotalIncomeFromParticipants = <cfqueryparam value="#Variables.EventTotalIncomeFromParticipants#" cfsqltype="cf_sql_double">
						Where TContent_ID = #checkEventMatrix.TContent_ID#
					</cfquery>
				<cfelse>
					<cfquery name="insertEventmatrixInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						insert into eEventsMatrix(Event_ID, Event_TotalExpensesToHold, Event_TotalIncomeFromParticipants)
						Values(<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Variables.EventTotalExpenses#" cfsqltype="cf_sql_double">,
							<cfqueryparam value="#Variables.EventTotalIncomeFromParticipants#" cfsqltype="cf_sql_double">
						)
					</cfquery>
				</cfif>
				<cfset TentativeProfitLossForEvent = #Variables.EventTotalIncome# - #Variables.EventTotalExpenses#>
				<cfset CostPerParticipant = #Variables.TentativeProfitLossForEvent# / #getEventParticipants.NumParticipants#>

				<div class="art-block clearfix">
					<div class="art-blockheader">
						<h3 class="t">Tentative Profit and Loss Report for: #getEvent.ShortTitle#</h3>
					</div>
					<div class="art-blockcontent">
						<uForm:form action="" method="Post" id="AddEventExpenses" errors="#Session.FormErrors#" errorMessagePlacement="both"
							commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
							cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
							submitValue="Update Rebate Information" loadValidation="true" loadMaskUI="true" loadDateUI="false"
							loadTimeUI="false">
							<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
							<input type="hidden" name="formSubmit" value="true">
							<input type="hidden" name="EnterRebateNumbers" value="true">
							<input type="hidden" name="EventID" value="#URL.EventID#">
							<input type="hidden" name="CostPerParticiant" value="#Variables.CostPerParticipant#">
							<uForm:fieldset legend="Event Information">
								<uform:field label="Event Total Income" name="EventTotalIncome" id="EventTotalIncome" isRequired="true" value="#NumberFormat(Variables.EventTotalIncome, '99999.99')#" type="text" isDisabled="true" hint="Total Income" />
								<uform:field label="Event Total Expenses" name="EventTotalExpenses" id="EventTotalExpenses" isRequired="true" value="#NumberFormat(Variables.EventTotalExpenses, '99999.99')#" type="text" isDisabled="true" hint="Total Expenses" />
								<uform:field label="Event Tentative Profit/Loss" name="EventTentativeProfitLossAmount" id="EventTentativeProfitLossAmount" isRequired="true" value="#NumberFormat(Variables.TentativeProfitLossForEvent, '99999.99')#" type="text" isDisabled="true" hint="Total Expenses" />
								<uform:field label="Event Total Participants" name="EventTotalParticipants" id="EventTotalParticipants" isRequired="true" value="#NumberFormat(getEventParticipants.NumParticipants, '99999')#" type="text" isDisabled="true" hint="Total Number of Attended Participants" />
							</uForm:fieldset>
							<uForm:fieldset legend="Participant Profit">
								<uform:field label="Participant Breakdown" name="CostPerParticiant" id="CostPerParticipant" isRequired="true" value="#NumberFormat(Variables.CostPerParticipant, '99999.99')#" type="text" isDisabled="True" hint="Profit per Attended Participant" />
							</uForm:fieldset>
						</uForm:form>
			</cfcase>
			<cfcase value="AddExpenses">
				<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfset Session.FormData = #StructNew()#>
					<cfset Session.FormErrors = #ArrayNew()#>
					<cfif not isDefined("Session.UserSuppliedInfo")><cfset Session.UserSuppliedInfo = #StructNew()#></cfif>
				</cflock>
				<div class="art-block clearfix">
					<div class="art-blockheader">
						<h3 class="t">Add new Event Expense for #Session.getEvent.ShortTitle#</h3>
					</div>
					<div class="art-blockcontent">
						<div class="alert-box notice">Please complete the following information to add a new event expense.</div>
						<hr>
						<uForm:form action="" method="Post" id="AddEventExpenses" errors="#Session.FormErrors#" errorMessagePlacement="both"
							commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
							cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
							submitValue="Add Event Expense" loadValidation="true" loadMaskUI="true" loadDateUI="false"
							loadTimeUI="false">
							<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
							<input type="hidden" name="formSubmit" value="true">
							<input type="hidden" name="EventID" value="#URL.EventID#">
							<input type="hidden" name="EventExpenses" value="true">
							<uForm:fieldset legend="Expense Information">
								<uform:field label="Expense Name" name="EventExpenseID" id="EventExpenseID" isRequired="true" type="select" hint="Name of Expense that can be associated with an Event">
									<uform:option display="Select Expense from List" value="0" isSelected="true" />
									<cfloop query="Session.getEventExpenseList">
										<uform:option display="#Session.getEventExpenseList.Expense_Name#" value="#Session.getEventExpenseList.TContent_ID#" />
									</cfloop>
								</uform:field>
								<uform:field label="Expense Amount" name="ExpenseAmount" type="text" value="#NumberFormat('0.00', '9999.99')#" hint="The Amount of the Expense. Just enter Dollars and Cents Only" />
							</uForm:fieldset>
						</uForm:form>
					</div>
				</div>
			</cfcase>
			<cfcase value="AddIncome">
				<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfset Session.FormData = #StructNew()#>
					<cfset Session.FormErrors = #ArrayNew()#>
					<cfif not isDefined("Session.UserSuppliedInfo")><cfset Session.UserSuppliedInfo = #StructNew()#></cfif>
				</cflock>
				<div class="art-block clearfix">
					<div class="art-blockheader">
						<h3 class="t">Add new Event Income for #Session.getEvent.ShortTitle#</h3>
					</div>
					<div class="art-blockcontent">
						<div class="alert-box notice">Please complete the following information to add a new event income amount.</div>
						<hr>
						<uForm:form action="" method="Post" id="AddEventIncome" errors="#Session.FormErrors#" errorMessagePlacement="both"
							commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
							cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
							submitValue="Add Event Income" loadValidation="true" loadMaskUI="true" loadDateUI="false"
							loadTimeUI="false">
							<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
							<input type="hidden" name="formSubmit" value="true">
							<input type="hidden" name="EventIncome" value="true">
							<input type="hidden" name="EventID" value="#URL.EventID#">
							<uForm:fieldset legend="Income Information">
								<uform:field label="Income Amount" name="IncomeAmount" type="text" value="#NumberFormat('0.00', '9999.99')#" hint="The Amount of the Income. Just enter Dollars and Cents Only" />
							</uForm:fieldset>
						</uForm:form>
					</div>
				</div>
			</cfcase>
		</cfswitch>
	</cfif>
</cfoutput>