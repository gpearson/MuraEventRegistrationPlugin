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
			<cfinput type="hidden" name="AcceptRegistrations" value="0">			
			<cfinput type="hidden" name="BillForNoShow" value="0">			
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event Registrations</h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="AcceptRegistrations" class="col-lg-5 col-md-5">Enable Registrations:&nbsp;</label>
					<div class="col-lg-7">
						<cfswitch expression="#Session.getSelectedEvent.AcceptRegistrations#">
							<cfcase value="1">
								<cfinput type="checkbox" class="form-check-input" name="AcceptRegistrations" id="AcceptRegistrations" value="1" checked>
							</cfcase>
							<cfdefaultcase>
								<cfinput type="checkbox" class="form-check-input" name="AcceptRegistrations" id="AcceptRegistrations" value="1">
							</cfdefaultcase>
						</cfswitch>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Allow individuals to register for this event)</div>
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