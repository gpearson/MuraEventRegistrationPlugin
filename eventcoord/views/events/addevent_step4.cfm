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
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 4 of 5 - Add New Event</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete any additional information and click the Proceed Button Below to continue.</div>
					<fieldset>
						<legend><h2>Maximum Participants for Event or Workshop</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="RoomMaxParticipants" class="control-label col-sm-3">Maximum Registrations:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
								<cfinput type="text" class="form-control" id="RoomMaxParticipants" name="RoomMaxParticipants" value="#Session.getSpecificFacilityRoomInfo.Capacity#" required="yes">
							<cfelse>
								<cfinput type="text" class="form-control" id="RoomMaxParticipants" name="RoomMaxParticipants" required="yes">
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Allow Online Registrations</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AcceptRegistrations" class="control-label col-sm-3">Accept Registrations:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="AcceptRegistrations" id="AcceptRegistrations" value="1"> <div style="Color: ##CCCCCC;">(Check Box to allow participants to register)</div></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 3">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Proceed to Review Step"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif isDefined("Session.FormErrors")>
					<div class="panel-body">
						<cfif ArrayLen(Session.FormErrors) GTE 1>
							<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
						</cfif>
					</div>
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 4 of 5 - Add New Event</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete any additional information and click the Proceed Button Below to continue.</div>
					<fieldset>
						<legend><h2>Maximum Participants for Event or Workshop</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="RoomMaxParticipants" class="control-label col-sm-3">Maximum Registrations:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
								<cfinput type="text" class="form-control" id="RoomMaxParticipants" name="RoomMaxParticipants" value="#Session.getFacilityRoomInfo.Capacity#" required="yes">
							<cfelse>
								<cfinput type="text" class="form-control" id="RoomMaxParticipants" name="RoomMaxParticipants" value="#Session.UserSuppliedInfo.FourthStep.MaxRoomParticipants#"required="yes">
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Allow Online Registrations</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AcceptRegistrations" class="control-label col-sm-3">Accept Registrations:&nbsp;</label>
						<div class="checkbox col-sm-6">
							<cfif Session.UserSuppliedInfo.FourthStep.AcceptRegistrations EQ 1>
								<cfinput type="checkbox" name="AcceptRegistrations" id="AcceptRegistrations" value="1" checked>
							<cfelse>
								<cfinput type="checkbox" name="AcceptRegistrations" id="AcceptRegistrations" value="1">
							</cfif>
						 <div style="Color: ##CCCCCC;">(Check Box to allow participants to register)</div></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 3">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Proceed to Review Step"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>