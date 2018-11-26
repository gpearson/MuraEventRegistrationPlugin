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
						<label for="PGPAvailable" class="control-label col-sm-3">PGP Certificate Available:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="PGPAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.PGPAvailable#" Display="OptionName"  queryposition="below">
								<option value="----">Offer PGP Certificates</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="PGPPoints" class="control-label col-sm-3">Number PGP Points for Event:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PGPPoints" name="PGPPoints" value="#Session.getSelectedEvent.PGPPoints#" required="no"></div>
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
						<label for="PGPAvailable" class="control-label col-sm-3">PGP Certificate Available:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="PGPAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.PGPAvailable#" Display="OptionName"  queryposition="below">
								<option value="----">Offer PGP Certificates</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="PGPPoints" class="control-label col-sm-3">Number PGP Points for Event:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PGPPoints" name="PGPPoints" value="#Session.getSelectedEvent.PGPPoints#" required="no"></div>
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
