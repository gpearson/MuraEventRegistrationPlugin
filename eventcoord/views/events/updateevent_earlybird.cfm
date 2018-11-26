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
	<script>
		$(function() {
			$("##EarlyBird_RegistrationDeadline").datepicker();
		});
	</script>
	<script type="text/javascript">
		$(document).ready(function()
			{
				$('##EarlyBird_MemberCost').blur(function() {
					$('##EarlyBird_MemberCost').formatCurrency();
				});

				$('##EarlyBird_NonMemberCost').blur(function() {
					$('##EarlyBird_NonMemberCost').formatCurrency();
				});
		});	}
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
						<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Allow Early Bird Registrations:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EarlyBird_RegistrationAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.EarlyBird_RegistrationAvailable#" Display="OptionName"  queryposition="below">
								<option value="----">Does Event have Early Bird Registrations</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Early Bird Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_RegistrationDeadline" name="EarlyBird_RegistrationDeadline" value="#DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_MemberCost" class="control-label col-sm-3">Member Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_MemberCost" name="EarlyBird_MemberCost" value="#DollarFormat(Session.getSelectedEvent.EarlyBird_MemberCost)#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_NonMemberCost" class="control-label col-sm-3">NonMember Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#DollarFormat(Session.getSelectedEvent.EarlyBird_NonMemberCost)#" required="no"></div>
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
						<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Allow Early Bird Registrations:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EarlyBird_RegistrationAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.EarlyBird_RegistrationAvailable#" Display="OptionName"  queryposition="below">
								<option value="----">Does Event have Early Bird Registrations</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Early Bird Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_RegistrationDeadline" name="EarlyBird_RegistrationDeadline" value="#Session.getSelectedEvent.EarlyBird_RegistrationDeadline#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_MemberCost" class="control-label col-sm-3">Member Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_MemberCost" name="EarlyBird_MemberCost" value="#DollarFormat(Session.getSelectedEvent.EarlyBird_MemberCost)#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_NonMemberCost" class="control-label col-sm-3">NonMember Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#DollarFormat(Session.getSelectedEvent.EarlyBird_NonMemberCost)#" required="no"></div>
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
