<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>

<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventFeatured" class="control-label col-sm-3">Presenter:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EventPresenter" class="form-control" Required="Yes" Multiple="No" query="Session.AvailablePresenters" value="UserID" selected="#Session.getSelectedEvent.Presenters#" Display="DisplayName"  queryposition="below">
								<option value="----">Select Primary Event Presenter</option>
							</cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Review">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventFeatured" class="control-label col-sm-3">Presenter:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EventPresenter" class="form-control" Required="Yes" Multiple="No" query="Session.AvailablePresenters" value="UserID" selected="#Session.getSelectedEvent.Presenters#" Display="DisplayName"  queryposition="below">
								<option value="----">Select Primary Event Presenter</option>
							</cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Review">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
