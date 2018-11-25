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
			<div class="panel-heading"><h2>Profit/Loss Report: #Session.getSelectedEvent.ShortTitle#</h2></div>
			<cfform action="#buildURL('eventcoord:events.generateprofitlossreport')#&EventID=#URl.EventID#&UserAction=ShowProfitLossReport" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="alert alert-info"><p>Review the Income Section of this Report by the Participants who attended</p></div>
					<div class="alert alert-warning"><p>Review the Income Section of this Report by the Participants who attended</p></div>
					<cfloop query="Session.GetSelectedEventRegistrations">
						<div class="form-group">
							<label for="ParticipantName" class="control-label col-sm-3">#Session.GetSelectedEventRegistrations.Lname#, #Session.GetSelectedEventRegistrations.FName#:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Participants_#Session.GetSelectedEventRegistrations.TContent_ID#" name="Participants_#Session.GetSelectedEventRegistrations.TContent_ID#" value="#NumberFormat(Session.GetSelectedEventRegistrations.AttendeePrice, '9999.99')#" required="no"></div>
						</div>
					</cfloop>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
`					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Submit Income Section"><br /><br />
				</div>
			</cfform>
		<cfelse>
			<cfset TotalIncome = 0>
			<cfset TotalExpenses = 0>
			<div class="panel-heading"><h2>Profit/Loss Report: #Session.getSelectedEvent.ShortTitle#</h2></div>
			<div class="panel-body">
				<div class="panel-heading"><h1>Event Income Section</h1></div>
				<cfloop query="#Session.GetSelectedEventRegistrations#">
					<cfset Variables.TotalIncome = #Variables.TotalIncome# + #Session.GetSelectedEventRegistrations.AttendeePrice#>
				</cfloop>
				<div class="form-group row">
					<label for="ParticipantInfo" class="form-control-label col-sm-4">Total Participants&nbsp;</label>
						<div class="col-sm-6">#Session.GetSelectedEventRegistrations.RecordCount#</div>
					</div>
				<div class="panel-heading"><h1>Event Total Income: <span class="pull-right">#DollarFormat(Variables.TotalIncome)#</span></h1></div>
				<hr>
				<div class="panel-heading"><h1>Event Expense Section</h1></div>
				<cfloop query="#Session.getSelectedEventExpenses#">
					<cfset Variables.TotalExpenses = #Variables.TotalExpenses# + #Session.getSelectedEventExpenses.Cost_Amount#>
					<div class="form-group row">
						<label for="ParticipantInfo" class="form-control-label col-sm-4">#Session.getSelectedEventExpenses.Expense_Name#&nbsp;</label>
						<div class="col-sm-6">#DollarFormat(Session.getSelectedEventExpenses.Cost_Amount)#</div>
					</div>
				</cfloop>
				<div class="panel-heading"><h1>Event Total Expense: <span class="pull-right">#DollarFormat(Variables.TotalExpenses)#</span></h1></div>
			</div>
			<cfset ProfitLoss = #Variables.TotalIncome# - #Variables.TotalExpenses#>
			<div class="panel-heading"><h2>Profit/Loss Bottom Line: <span class="pull-right">#DollarFormat(Variables.ProfitLoss)#</span></h1></div>
			<br /><br />
			<div class="panel-footer">
				<a href="#buildURL('eventcoord:events.default')#" class="btn btn-primary pull-left">Back to Main Menu</a>
				<a href="#buildURL('eventcoord:events.default')#" class="btn btn-primary pull-right">Generate Report for another Event</a><br /><br />
			</div>
		</cfif>
	</div>
</cfoutput>