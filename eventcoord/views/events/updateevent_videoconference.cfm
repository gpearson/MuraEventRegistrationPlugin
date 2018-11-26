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
	<script src="/requirements/ckeditor/ckeditor.js"></script>
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
						<label for="AllowVideoConference" class="control-label col-sm-3">Video Conference Available:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="AllowVideoConference" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.AllowVideoConference#" Display="OptionName"  queryposition="below">
								<option value="----">Allow Video Conference</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="VideoConferenceInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
						<div class="col-sm-8">
							<textarea name="VideoConferenceInfo" id="VideoConferenceInfo" class="form-control" cols="80" rows="10">#Session.getSelectedEvent.VideoConferenceInfo#</textarea>
							<script>CKEDITOR.replace('VideoConferenceInfo', {
								// Define the toolbar groups as it is a more accessible solution.
								toolbarGroups: [
									{"name":"basicstyles","groups":["basicstyles"]},
									{"name":"links","groups":["links"]},
									{"name":"paragraph","groups":["list","blocks"]},
									{"name":"document","groups":["mode"]},
									{"name":"insert","groups":["insert"]},
									{"name":"styles","groups":["styles"]},
									{"name":"about","groups":["about"]}
								],
								// Remove the redundant buttons from toolbar groups defined above.
								removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
							} );
							</script>
						</div>
					</div>
					<div class="form-group">
						<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Participate:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfinput type="text" class="form-control" id="VideoConferenceCost" name="VideoConferenceCost" value="#Session.getSelectedEvent.VideoConferenceCost#" required="no"></p></div>
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
						<label for="AllowVideoConference" class="control-label col-sm-3">Video Conference Available:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="AllowVideoConference" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.AllowVideoConference#" Display="OptionName"  queryposition="below">
								<option value="----">Allow Video Conference</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="VideoConferenceInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
						<div class="col-sm-8">
							<textarea name="VideoConferenceInfo" id="VideoConferenceInfo" class="form-control" cols="80" rows="10">#Session.getSelectedEvent.VideoConferenceInfo#</textarea>
							<script>CKEDITOR.replace('VideoConferenceInfo', {
								// Define the toolbar groups as it is a more accessible solution.
								toolbarGroups: [
									{"name":"basicstyles","groups":["basicstyles"]},
									{"name":"links","groups":["links"]},
									{"name":"paragraph","groups":["list","blocks"]},
									{"name":"document","groups":["mode"]},
									{"name":"insert","groups":["insert"]},
									{"name":"styles","groups":["styles"]},
									{"name":"about","groups":["about"]}
								],
								// Remove the redundant buttons from toolbar groups defined above.
								removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
							} );
							</script>
						</div>
					</div>
					<div class="form-group">
						<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Participate:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfinput type="text" class="form-control" id="VideoConferenceCost" name="VideoConferenceCost" value="#Session.getSelectedEvent.VideoConferenceCost#" required="no"></p></div>
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
