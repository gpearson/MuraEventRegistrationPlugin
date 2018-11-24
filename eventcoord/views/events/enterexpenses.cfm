<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfquery name="getEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select ShortTitle
	From eEvents
	Where TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
		Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
</cfquery>
<cfquery name="getAvailableEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	SELECT eEvent_ExpenseList.Expense_Name, eEvent_Expenses.Cost_Amount
	FROM eEvent_Expenses
		INNER JOIN eEvent_ExpenseList ON eEvent_ExpenseList.TContent_ID = eEvent_Expenses.Expense_ID
	Where eEvent_Expenses.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
		eEvent_Expenses.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfif isDefined("URL.Successful")>
	<cfswitch expression="#URL.Successful#">
		<cfcase value="true">
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="AddExpenseCategory">
						<div class="alert-box success">
							<p>Your have successfully added a new expense category to use for current and future events to determine actual profit/loss report.</p>
						</div>
					</cfcase>
					<cfcase value="UpdateExpenseCategory">
						<div class="alert-box success">
							<p>Your have successfully updated a current expense category to use for current and future events to determine actual profit/loss report.</p>
						</div>
					</cfcase>
					<cfcase value="DeactivateExpenseCategory">
						<div class="alert-box success">
							<p>Your have successfully deactivated the expense category at this time from being used in future profit/loss reports.</p>
						</div>
					</cfcase>
					<cfcase value="ActivateExpenseCategory">
						<div class="alert-box success">
							<p>Your have successfully activated the expense category at this time so it can be used in future profit/loss reports.</p>
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
			<h3 class="t">Current Workshop or Event Expenses</h3>
		</div>
		<div class="art-blockcontent">
			<table class="art-article" style="width:100%;">
				<thead>
					<tr>
						<td colspan="3" style="Font-Family: Arial; Font-Size: 12px;">Event Expenses for: #getEvent.ShortTitle#</td>
					</tr>
					<tr>
						<td width="50%" style="Font-Family: Arial; Font-Size: 12px;">Expense Name</td>
						<td width="15%" style="Font-Family: Arial; Font-Size: 12px;">Cost</td>
						<td style="Font-Family: Arial; Font-Size: 12px;">Actions</td>
					</tr>
				</thead>
				<cfif getAvailableEventExpenses.RecordCount>
					<tfoot>
						<tr>
							<td colspan="3" style="Font-Family: Arial; Font-Size: 12px;">Add a new Expense for this event not listed above by clicking <a href="#buildURL('eventcoord:events.addeventexpenses')#&EventID=#URL.EventID#" class="art-button">here</a> or to enter non-participant revenue click <a href="#buildURL('eventcoord:events.addeventincome')#&EventID=#URL.EventID#" class="art-button">here</a></td>
						</tr>
					</tfoot>
					<tbody>
						<cfloop query="getAvailableEventExpenses">
							<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
								<td width="50%">#getAvailableEventExpenses.Expense_Name#</td>
								<td width="15%">#DollarFormat(getAvailableEventExpenses.Cost_Amount)#</td>
								<td>
								</td>

							</tr>
						</cfloop>
					</tbody>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="6"><div align="center" class="alert-box notice">No Event Expenses have been located within the database. Please click <a href="#buildURL('eventcoord:events.addeventexpenses')#&EventID=#URL.EventID#" class="art-button">here</a> to add a new expense for this event.</div></td>
						</tr>
					</tbody>
				</cfif>
			</table>
		</div>
	</div>
</cfoutput>