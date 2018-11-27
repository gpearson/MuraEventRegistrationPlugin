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
			$("##Featured_StartDate").datepick();
			$("##Featured_EndDate").datepick();
		});
	</script>
	<div class="panel panel-default">
		<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="Featured_Event" value="0">
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event Featured</h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="Featured_Event" class="col-lg-5 col-md-5">Event Is Featured:&nbsp;</label>
					<div class="col-lg-7">
						<cfswitch expression="#Session.getSelectedEvent.Featured_Event#">
							<cfcase value="1">
								<cfinput type="checkbox" class="form-check-input" name="Featured_Event" id="Featured_Event" value="1" checked>
							</cfcase>
							<cfdefaultcase>
								<cfinput type="checkbox" class="form-check-input" name="Featured_Event" id="Featured_Event" value="1">
							</cfdefaultcase>
						</cfswitch>
						 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Event to be Featured)</div>
					</div>
				</div>
				<div class="form-group">
					<label for="Featured_StartDate" class="col-lg-5 col-md-5">Featured Start Date:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.Featured_StartDate")>
							<cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" value="#Session.FormInput.EventStep1.Featured_StartDate#" required="no">
						<cfelse>
							<cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" value="#DateFormat(Session.getSelectedEvent.Featured_StartDate, 'mm/dd/yyyy')#" required="no">
						</cfif>
					</div>
				</div>
				<div class="form-group">
					<label for="Featured_EndDate" class="col-lg-5 col-md-5">Featured End Date:&nbsp;</label>
					<div class="col-lg-7 col-md-7">
						<cfif isDefined("Session.FormInput.EventStep1.Featured_EndDate")>
							<cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" value="#Session.FormInput.EventStep1.Featured_EndDate#" required="no">
						<cfelse>
							<cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" value="#DateFormat(Session.getSelectedEvent.Featured_EndDate, 'mm/dd/yyyy')#" required="no">
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