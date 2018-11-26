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
						<label for="EventFeatured" class="control-label col-sm-3">Presenter:&nbsp;</label>
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
				<cfinput type="hidden" name="EventID" value="#Session.FormData.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventFeatured" class="control-label col-sm-3">Feature Event:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="EventFeatured" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.EventFeatured#" Display="OptionName"  queryposition="below">
								<option value="----">Feature this Event on Front Page of Site</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above. Featured Sort Order will be displayed in Assending Order from Smallest to Largest Number</div>
					<div class="form-group">
						<label for="Featured_StartDate" class="control-label col-sm-3">Start Date of Featuring Event:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" value="#DateFormat(Session.getSelectedEvent.Featured_StartDate, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Featured_EndDate" class="control-label col-sm-3">End Date of Featuring Event:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" value="#DateFormat(Session.getSelectedEvent.featured_EndDate, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Featured_SortOrder" class="control-label col-sm-3">Sort Order of Featured Events:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_SortOrder" name="Featured_SortOrder" value="#Session.getSelectedEvent.Featured_SortOrder#" required="no"></div>
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
