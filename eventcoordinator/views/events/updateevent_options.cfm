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
			<cfinput type="hidden" name="Event_OptionalCosts" value="0">			
			<cfinput type="hidden" name="BillForNoShow" value="0">			
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event Optional Settings</h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="Event_OptionalCosts" class="col-lg-5 col-md-5">Optional Costs:&nbsp;</label>
					<div class="col-lg-7">
						<cfswitch expression="#Session.getSelectedEvent.Event_OptionalCosts#">
							<cfcase value="1">
								<cfinput type="checkbox" class="form-check-input" name="Event_OptionalCosts" id="Event_OptionalCosts" value="1" checked>
							</cfcase>
							<cfdefaultcase>
								<cfinput type="checkbox" class="form-check-input" name="Event_OptionalCosts" id="Event_OptionalCosts" value="1">
							</cfdefaultcase>
						</cfswitch>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Any Additional Costs in addition to the published fees? (Books, Materials, Etc) for this event)</div>
					</div>
				</div>
				<div class="form-group">
					<label for="FacebookPostsEnabled" class="col-lg-5 col-md-5">Facebook Posts Enabled:&nbsp;</label>
					<div class="col-lg-7">
						<cfswitch expression="#Session.SiteConfigSettings.Facebook_Enabled#">
							<cfcase value="1">
								
							</cfcase>
							<cfdefaultcase>
								Facebook Posts are not enabled. Please have Site Admin enable in settings
							</cfdefaultcase>
						</cfswitch>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Allow Posts to be published on Facebook Business Fan Page)</div>
					</div>
				</div>
				<div class="form-group">
					<label for="BillForNoShow" class="col-lg-5 col-md-5">Bill Participants for NoShow:&nbsp;</label>
					<div class="col-lg-7">
						<cfswitch expression="#Session.getSelectedEvent.BillForNoShow#">
							<cfcase value="1">
								<cfinput type="checkbox" class="form-check-input" name="BillForNoShow" id="BillForNoShow" value="1" checked>
							</cfcase>
							<cfdefaultcase>
								<cfinput type="checkbox" class="form-check-input" name="BillForNoShow" id="BillForNoShow" value="1">
							</cfdefaultcase>
						</cfswitch>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Bill Participant who does not show to event)</div>
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