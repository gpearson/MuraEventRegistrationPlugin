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
						<label for="ViewGroupPricing" class="control-label col-sm-3">Allow Group Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="ViewGroupPricing" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.ViewGroupPricing#" Display="OptionName"  queryposition="below">
								<option value="----">Does Event have Group Pricing</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="GroupMemberCost" class="control-label col-sm-3">Member Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="GroupMemberCost" name="GroupMemberCost" value="#Session.getSelectedEvent.GroupMemberCost#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="GroupNonMemberCost" class="control-label col-sm-3">NonMember Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="GroupNonMemberCost" name="GroupNonMemberCost" value="#Session.getSelectedEvent.GroupNonMemberCost#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="GroupPriceRequirements" class="control-label col-sm-3">Requirements to Acquire Pricing:&nbsp;</label>
						<div class="col-sm-8">
							<textarea name="GroupPriceRequirements" id="GroupPriceRequirements" class="form-control" cols="80" rows="10">#Session.getSelectedEvent.GroupPriceRequirements#</textarea>
							<script>CKEDITOR.replace('GroupPriceRequirements', {
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
						<label for="ViewGroupPricing" class="control-label col-sm-3">Allow Group Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="ViewGroupPricing" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.ViewGroupPricing#" Display="OptionName"  queryposition="below">
								<option value="----">Does Event have Group Pricing</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="GroupMemberCost" class="control-label col-sm-3">Member Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="GroupMemberCost" name="GroupMemberCost" value="#Session.getSelectedEvent.GroupMemberCost#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="GroupNonMemberCost" class="control-label col-sm-3">NonMember Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="GroupNonMemberCost" name="GroupNonMemberCost" value="#Session.getSelectedEvent.GroupNonMemberCost#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="GroupPriceRequirements" class="control-label col-sm-3">Requirements to Acquire Pricing:&nbsp;</label>
						<div class="col-sm-8">
							<textarea name="GroupPriceRequirements" id="GroupPriceRequirements" class="form-control" cols="80" rows="10">#Session.getSelectedEvent.GroupPriceRequirements#</textarea>
							<script>CKEDITOR.replace('GroupPriceRequirements', {
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
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Review">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
