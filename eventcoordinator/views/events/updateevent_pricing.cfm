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
			<cfinput type="hidden" name="EventPricePerDay" value="0">
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event Location Pricing</h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="Event_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.Event_MemberCost")>
							<cfinput type="text" class="form-control" id="Event_MemberCost" name="Event_MemberCost" value="#Session.FormInput.EventStep1.Event_MemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
						<cfelse>
							<cfinput type="text" class="form-control" id="Event_MemberCost" name="Event_MemberCost" value="#Session.getSelectedEvent.Event_MemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label for="Event_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.Event_NonMemberCost")>
							<cfinput type="text" class="form-control" id="Event_NonMemberCost" name="Event_NonMemberCost" value="#Session.FormInput.EventStep1.Event_NonMemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
						<cfelse>
							<cfinput type="text" class="form-control" id="Event_NonMemberCost" name="Event_NonMemberCost" value="#Session.getSelectedEvent.Event_NonMemberCost#" required="no"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is Per Event)</div>
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label for="EventPricePerDay" class="col-lg-5 col-md-5">Bill Per Event Date:&nbsp;</label>
					<div class="checkbox col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.EventPricePerDay")>
							<cfif Session.FormInput.EventStep1.EventPricePerDay EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
							</cfif>
						<cfelse>
							<cfif Session.getSelectedEvent.EventPricePerDay EQ 1>
								<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
							</cfif>
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