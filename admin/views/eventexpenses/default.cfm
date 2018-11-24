<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfquery name="getAvailableEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select TContent_ID, Site_ID, Expense_Name, Active
	From eEvent_ExpenseList
	Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
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
			<h3 class="t">Current Expense Listing</h3>
		</div>
		<div class="art-blockcontent">
			<table class="art-article" style="width:100%;">
				<thead>
					<tr>
						<td width="50%">Expense Name</td>
						<td width="15%">Active</td>
						<td>Actions</td>
					</tr>
				</thead>
				<cfif getAvailableEventExpenses.RecordCount>
					<tfoot>
						<tr>
							<td colspan="3">Add a new Expense Caqtegory not listed above by clicking <a href="#buildURL('admin:eventexpenses.addexpense')#" class="art-button">here</a></td>
						</tr>
					</tfoot>
					<tbody>
						<cfloop query="getAvailableEventExpenses">
							<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
								<td width="50%">#getAvailableEventExpenses.Expense_Name#</td>
								<td width="15%"><cfif getAvailableEventExpenses.Active EQ 1>Yes<cfelse>No</cfif></td>
								<td><a href="#buildURL('admin:eventexpenses.updateexpense')#&ExpenseID=#getAvailableEventExpenses.TContent_ID#" class="art-button">Update</a>&nbsp;&nbsp;
									<cfif getAvailableEventExpenses.Active IS 1><a href="#buildURL('admin:eventexpenses.deactivateexpense')#&ExpenseID=#getAvailableEventExpenses.TContent_ID#" class="art-button">DeActivate</a></cfif>
									<cfif getAvailableEventExpenses.Active IS 0><a href="#buildURL('admin:eventexpenses.activateexpense')#&ExpenseID=#getAvailableEventExpenses.TContent_ID#" class="art-button">Activate</a></cfif>
								</td>

							</tr>
						</cfloop>
					</tbody>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="6"><div align="center" class="alert-box notice">No Event Expenses have been located within the database. Please click <a href="#buildURL('admin:eventexpenses.addexpense')#" class="art-button">here</a> to add a new expense category.</div></td>
						</tr>
					</tbody>
				</cfif>
			</table>
		</div>
	</div>
</cfoutput>