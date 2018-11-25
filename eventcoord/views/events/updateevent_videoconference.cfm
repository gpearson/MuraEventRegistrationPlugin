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
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="AllowVideoConference" class="control-label col-sm-3">Video Conference Available:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="AllowVideoConference" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.AllowVideoConference#" Display="OptionName"  queryposition="below">
								<option value="----">Allow Video Conference</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="VideoConferenceInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
						<div class="col-sm-8"><textarea name="VideoConferenceInfo" id="VideoConferenceInfo" class="form-control">#Session.getSelectedEvent.VideoConferenceInfo#</textarea></div>
					</div>
					<div class="form-group">
						<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Participate:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfinput type="text" class="form-control" id="VideoConferenceCost" name="VideoConferenceCost" value="#Session.getSelectedEvent.VideoConferenceCost#" required="no"></p></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#Session.FormData.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="AllowVideoConference" class="control-label col-sm-3">Video Conference Available:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="AllowVideoConference" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.AllowVideoConference#" Display="OptionName"  queryposition="below">
								<option value="----">Allow Video Conference</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="VideoConferenceInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><textarea name="VideoConferenceInfo" id="VideoConferenceInfo" class="form-control">#Session.getSelectedEvent.VideoConferenceInfo#</textarea></p></div>
					</div>
					<div class="form-group">
						<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Participate:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfinput type="text" class="form-control" id="VideoConferenceCost" name="VideoConferenceCost" value="#Session.getSelectedEvent.VideoConferenceCost#" required="no"></p></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
