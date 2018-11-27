<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
</cfsilent>
<cfoutput>
	<script src="/requirements/ckeditor/ckeditor.js"></script>
	<div class="panel panel-default">
		<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event Primary Presenter</h2></legend>
				</fieldset>
				<div class="form-group">
					<div class="alert alert-info">If the primary presenter does not show within the dropdown box below, You will need to grant the user access through the User Manager to give them the Group 'Event Presenter'</div>
				</div>
				<div class="form-group">
					<label for="PresenterID" class="col-lg-5 col-md-5">Primary Presenter:&nbsp;</label>
					<div class="col-lg-7">
						<cfif isDefined("Session.FormInput.EventStep1.PresenterID")>
							<cfselect name="PresenterID" class="form-control" Required="Yes" Multiple="No" query="Session.getAllPresenters" value="UserID" Display="DisplayName" selected="#Session.FormInput.EventStep1.PresenterID#" queryposition="below"><option value="----">Select Primary Event Presenter</option></cfselect>
						<cfelse>
							<cfselect name="PresenterID" class="form-control" Required="Yes" Multiple="No" query="Session.getAllPresenters" value="UserID" Display="DisplayName" selected="#Session.getSelectedEvent.PresenterID#"  queryposition="below"><option value="----">Select Primary Event Presenter</option></cfselect>
						</cfif>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Update Event">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event"><br /><br />
				</div>
			</div>
		</cfform>
	</div>
</cfoutput>