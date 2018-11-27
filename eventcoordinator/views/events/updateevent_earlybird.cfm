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
	<script>
		$(function() {
			$("##EarlyBird_Deadline").datepick();
		});
	</script>
	<div class="panel panel-default">
		<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="EarlyBird_Available" value="0">
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event Early Bird Discount</h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="EarlyBird_Available" class="col-lg-5 col-md-5">Event Has Early Bird Registration Discount:&nbsp;</label>
					<div class="col-lg-7">
						<cfswitch expression="#Session.getSelectedEvent.EarlyBird_Available#">
							<cfcase value="1">
								<cfinput type="checkbox" class="form-check-input" name="EarlyBird_Available" id="EarlyBird_Available" value="1" checked>
							</cfcase>
							<cfdefaultcase>
								<cfinput type="checkbox" class="form-check-input" name="EarlyBird_Available" id="EarlyBird_Available" value="1">
							</cfdefaultcase>
						</cfswitch>
						 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Event to have an Early Bird Registration Discount)</div>
					</div>
				</div>
				<div class="form-group">
					<label for="EarlyBird_Deadline" class="col-lg-5 col-md-5">Early Bird Registration Deadline:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.EarlyBird_Deadline")>
							<cfinput type="text" class="form-control" id="EarlyBird_Deadline" name="EarlyBird_Deadline" value="#Session.FormInput.EventStep1.EarlyBird_Deadline#" required="no">
						<cfelse>
							<cfinput type="text" class="form-control" id="EarlyBird_Deadline" name="EarlyBird_Deadline" value="#DateFormat(Session.getSelectedEvent.EarlyBird_Deadline, 'mm/dd/yyyy')#" required="no">
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label for="EarlyBird_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep2.EarlyBird_MemberCost")>
							<cfinput type="text" class="form-control" id="EarlyBird_MemberCost" name="EarlyBird_MemberCost" value="#Session.FormInput.EventStep2.EarlyBird_MemberCost#" required="no">
						<cfelse>
							<cfinput type="text" class="form-control" id="EarlyBird_MemberCost" name="EarlyBird_MemberCost" value="#Session.getSelectedEvent.EarlyBird_MemberCost#" required="no">
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label for="EarlyBird_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep2.EarlyBird_NonMemberCost")>
							<cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#Session.FormInput.EventStep2.EarlyBird_NonMemberCost#" required="no">
						<cfelse>
							<cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#Session.getSelectedEvent.EarlyBird_NonMemberCost#" required="no">
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