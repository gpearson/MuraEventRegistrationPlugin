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
		<cfif not isDefined("URL.UserAction")>
			<cfform action="#buildURL('eventcoord:events.generateprofitlossreport')#&EventID=#URl.EventID#" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Profit/Loss Report: #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<cfif Session.GetSelectedEventRegistrations.RecordCount GTE 1>
						<div class="alert alert-warning"><p>Review the Income Section of this Report by the Participants who attended</p></div>
						<cfloop query="Session.GetSelectedEventRegistrations">
							<div class="form-group">
								<label for="ParticipantName" class="control-label col-sm-3">#Session.GetSelectedEventRegistrations.Lname#, #Session.GetSelectedEventRegistrations.FName#:&nbsp;</label>
								<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participants_#Session.GetSelectedEventRegistrations.TContent_ID#" name="Participants_#Session.GetSelectedEventRegistrations.TContent_ID#" value="#NumberFormat(Session.GetSelectedEventRegistrations.AttendeePrice, '9999.99')#" required="no"></div>
							</div>
						</cfloop>
					<cfelse>
						<div class="alert alert-warning"><p>All Income has previous been verified. Simply click the Button Submit Income Section below to view the Profit/Loss Report for this event</p></div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
`					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Submit Income Section"><br /><br />
				</div>
			</cfform>
		<cfelse>
			<cfset TotalIncome = 0>
			<cfset TotalExpenses = 0>
			<div class="panel-body">
				<fieldset>
					<legend><h2>Profit/Loss Report: #Session.getSelectedEvent.ShortTitle#</h2></legend>
				</fieldset>
				<br />
				<fieldset>
					<legend><h2>Event Income Section</h2></legend>
				</fieldset>
				<cfloop query="#Session.GetSelectedEventRegistrations#">
					<cfset Variables.TotalIncome = #Variables.TotalIncome# + #Session.GetSelectedEventRegistrations.AttendeePrice#>
				</cfloop>
				<div class="form-group row">
					<label for="ParticipantInfo" class="form-control-label col-sm-4">Total Participants&nbsp;</label>
					<div class="col-sm-6">#Session.GetSelectedEventRegistrations.RecordCount#</div>
				</div>
				<fieldset>
					<legend><h2>Event Total Income: <span class="pull-right">#DollarFormat(Variables.TotalIncome)#</span></h2></legend>
				</fieldset>
				<br><br>
			<br><br>
			<br><br>
			<br><br>
			<br><br>
			<br><br>
				<fieldset>
					<legend><h2>Event Expense Section</h2></legend>
				</fieldset>
				<cfloop query="#Session.getSelectedEventExpenses#">
					<cfset Variables.TotalExpenses = #Variables.TotalExpenses# + #Session.getSelectedEventExpenses.Cost_Amount#>
					<div class="form-group row">
						<label for="ParticipantInfo" class="form-control-label col-sm-4">#Session.getSelectedEventExpenses.Expense_Name#&nbsp;</label>
						<div class="col-sm-6">#DollarFormat(Session.getSelectedEventExpenses.Cost_Amount)#</div>
					</div>
				</cfloop>
				<fieldset>
					<legend><h2>Event Total Expenses: <span class="pull-right">#DollarFormat(Variables.TotalExpenses)#</span></h2></legend>
				</fieldset>
			</div>
			<cfset ProfitLoss = #Variables.TotalIncome# - #Variables.TotalExpenses#>
			<br><br>
			<br><br>
			<br><br>
			<fieldset>
				<legend><h2>Profit/Loss Bottom Line: <span class="pull-right">#DollarFormat(Variables.ProfitLoss)#</span></h2></legend>
			</fieldset>
			<br /><br />
			<div class="panel-footer">
				<a href="#buildURL('eventcoord:events.default')#" class="btn btn-primary pull-left">Back to Event Listing</a>
				<cfif Session.GetSelectedEventRegistrations.RecordCount><a href="#buildURL('eventcoord:events.generateinvoices')#&EventID=#URL.EventID#" class="btn btn-primary  pull-right">Generate Invoices</a></cfif>
				<span class="pull-right">&nbsp;&nbsp;</span>
				<a href="#buildURL('eventcoord:events.default')#" class="btn btn-primary pull-right">Generate Report for another Event</a><br /><br />
			</div>
		</cfif>
	</div>
</cfoutput>