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
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Add Event Expense</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="GroupName" class="col-lg-3 col-md-3">Expense Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="ExpenseName" name="ExpenseName" required="No"></div>
					</div>
					<div class="form-group">
						<label for="GroupActive" class="col-lg-3 col-md-3">Expense Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9">
							<cfselect name="ExpenseActive" class="form-control" Required="Yes" Multiple="No" query="ExpenseActiveQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Select Active</option>
							</cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Event Expense"><br /><br />
				</div>
			</cfform>
		<cfelseif isDefined("URL.FormRetry")>
			<cfform action="" method="post" id="RegisterNewLocation" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="OrganizationID" value="#Session.Mura.GrpMessageOrganizationID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif ArrayLen(Session.FormErrors) GTE 1>
					<br /><br />
					<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Add Event Expense</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ExpenseName" class="col-lg-3 col-md-3">Expense Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" value="#Session.FormData.ExpenseName#" id="ExpenseName" name="ExpenseName" required="No"></div>
					</div>
					<div class="form-group">
						<label for="GroupActive" class="col-lg-3 col-md-3">Expense Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9">
							<cfselect name="ExpenseActive" class="form-control" Required="Yes" Multiple="No" query="ExpenseActiveQuery" value="ID" Display="OptionName" selected="#Session.FormData.ExpenseActive#"  queryposition="below">
								<option value="----">Select Active</option>
							</cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Event Expense"><br /><br />
				</div>
			</cfform>
		</cfif>
	</div>
</cfoutput>