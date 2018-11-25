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
	<script>
		$(function() {
			$("##EarlyBird_RegistrationDeadline").datepicker();
		});
	</script>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Allow Early Bird Registrations:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="EarlyBird_RegistrationAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.EarlyBird_RegistrationAvailable#" Display="OptionName"  queryposition="below">
								<option value="----">Does Event have Early Bird Registrations</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Member Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_RegistrationDeadline" name="EarlyBird_RegistrationDeadline" value="#Session.getSelectedEvent.EarlyBird_RegistrationDeadline#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_MemberCost" class="control-label col-sm-3">Member Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_MemberCost" name="EarlyBird_MemberCost" value="#Session.getSelectedEvent.EarlyBird_MemberCost#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_NonMemberCost" class="control-label col-sm-3">NonMember Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#Session.getSelectedEvent.EarlyBird_NonMemberCost#" required="no"></div>
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
						<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Allow Early Bird Registrations:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="EarlyBird_RegistrationAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedEvent.EarlyBird_RegistrationAvailable#" Display="OptionName"  queryposition="below">
								<option value="----">Does Event have Early Bird Registrations</option>
							</cfselect>
						</div>
					</div>
					<div class="alert alert-info">Complete the following if you selected the Yes Option above.</div>
					<div class="form-group">
						<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Member Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_RegistrationDeadline" name="EarlyBird_RegistrationDeadline" value="#Session.getSelectedEvent.EarlyBird_RegistrationDeadline#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_MemberCost" class="control-label col-sm-3">Member Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_MemberCost" name="EarlyBird_MemberCost" value="#Session.getSelectedEvent.EarlyBird_MemberCost#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_NonMemberCost" class="control-label col-sm-3">NonMember Cost:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#Session.getSelectedEvent.EarlyBird_NonMemberCost#" required="no"></div>
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
