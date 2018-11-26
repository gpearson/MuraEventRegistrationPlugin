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
	<cfset pluginPath = rc.$.globalConfig('context') & '/plugins/' & rc.pluginConfig.getPackage() />
	<script type="text/javascript" src="#pluginPath#/includes/assets/js/jquery.formatCurrency-1.4.0.js"></script>
	<script type="text/javascript" src="#pluginPath#/includes/assets/js/jquery.formatCurrency.all.js"></script>
	<script type="text/javascript">
		$(document).ready(function()
			{
				$('##MealCost').blur(function() {
					$('##MealCost').formatCurrency();
				});
		});
	</script>
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
						<label for="MealAvailable" class="control-label col-sm-3">Meal Available:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="MealAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.MealAvailable#" Display="OptionName"  queryposition="below">
								<option value="----">Provide Meal to Participants</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<label for="MealIncluded" class="control-label col-sm-3">Meal Included in Registration Fee:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="MealIncluded" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.MealIncluded#" Display="OptionName"  queryposition="below">
								<option value="----">Meal Cost Included in Registration Fee</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected Yes to Meal Available option above. If Meal Included in registration fee is set to no, the informatiobn below will be displayed on the Info Screen of the event listed.</div>
					<div class="form-group">
						<label for="MealProvidedBy" class="control-label col-sm-3">Who's Providing Meal:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="MealProvidedBy" class="form-control" Required="Yes" Multiple="No" query="Session.getMealProviders" value="TContent_ID" selected="#Session.getSelectedEvent.MealProvidedBy#" Display="FacilityName"  queryposition="below">
								<option value="----">Select Meal Provider</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<label for="MealCost" class="control-label col-sm-3">Meal Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MealCost" name="MealCost" value="#DollarFormat(Session.getSelectedEvent.MealCost)#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MealNotes" class="control-label col-sm-3">Meal Information:&nbsp;</label>
						<div class="col-sm-8">
							<textarea name="MealNotes" id="MealNotes" class="form-control" cols="80" rows="10">#Session.getSelectedEvent.Meal_Notes#</textarea>
							<script>CKEDITOR.replace('MealNotes', {
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
						<label for="MealAvailable" class="control-label col-sm-3">Meal Available:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="MealAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.MealAvailable#" Display="OptionName"  queryposition="below">
								<option value="----">Provide Meal to Participants</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<label for="MealIncluded" class="control-label col-sm-3">Meal Included in Registration Fee:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="MealIncluded" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.MealIncluded#" Display="OptionName"  queryposition="below">
								<option value="----">Meal Cost Included in Registration Fee</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected Yes to Meal Available option above. If Meal Included in registration fee is set to no, the informatiobn below will be displayed on the Info Screen of the event listed.</div>
					<div class="form-group">
						<label for="MealProvidedBy" class="control-label col-sm-3">Who's Providing Meal:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="MealProvidedBy" class="form-control" Required="Yes" Multiple="No" query="Session.getMealProviders" value="TContent_ID" selected="#Session.getSelectedEvent.MealProvidedBy#" Display="FacilityName"  queryposition="below">
								<option value="----">Select Meal Provider</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<label for="MealCost" class="control-label col-sm-3">Meal Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PGPPoints" name="PGPPoints" value="#DollarFormat(Session.getSelectedEvent.MealCost)#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MealNotes" class="control-label col-sm-3">Meal Information:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<textarea name="MealNotes" id="MealNotes" class="form-control" cols="80" rows="10">#Session.getSelectedEvent.Meal_Notes#</textarea>
							<script>CKEDITOR.replace('MealNotes', {
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
