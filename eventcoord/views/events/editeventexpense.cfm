<cfset ExpenseActiveQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(ExpenseActiveQuery, 1)>
<cfset temp = #QuerySetCell(ExpenseActiveQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(ExpenseActiveQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(ExpenseActiveQuery, 1)>
<cfset temp = #QuerySetCell(ExpenseActiveQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(ExpenseActiveQuery, "OptionName", "Yes")#>

<cfoutput>
	<div class="panel panel-default">
		<cfif not isDefined("URL.FormRetry")>
			<cfform action="" method="post" id="RegisterNewLocation" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="ExpenseID" value="#URL.ExpenseID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Event Expense</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="GroupName" class="control-label col-sm-3">Expense Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ExpenseName" name="ExpenseName" value="#Session.getSelectedExpense.Expense_name#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="GroupActive" class="control-label col-sm-3">Expense Active:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="ExpenseActive" class="form-control" Required="Yes" Multiple="No" selected="#Session.getSelectedExpense.Active#" query="ExpenseActiveQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Select Active</option>
							</cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Expense"><br /><br />
				</div>
			</cfform>
		<cfelseif isDefined("URL.FormRetry")>
			<cfform action="" method="post" id="RegisterNewLocation" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="ExpenseID" value="#URL.ExpenseID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif ArrayLen(Session.FormErrors) GTE 1>
					<br /><br />
					<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Event Expense</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="GroupName" class="control-label col-sm-3">Expense Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ExpenseName" name="ExpenseName" value="#Session.getSelectedExpense.Expense_name#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="GroupActive" class="control-label col-sm-3">Expense Active:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="ExpenseActive" class="form-control" Required="Yes" Multiple="No" selected="#Session.getSelectedExpense.Active#" query="ExpenseActiveQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Select Active</option>
							</cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Expense"><br /><br />
				</div>
			</cfform>
		</cfif>
	</div>
</cfoutput>