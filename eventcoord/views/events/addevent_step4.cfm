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
			<div class="panel-heading"><h1>Add New Event or Workshop - Step 4</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="alert alert-info">This is Step 4 of the New Workshop or Event Creation Process. Please complete this information and click the button below to move to the next screen.</div>
					<div class="panel-heading"><h1>What is Maximum Registrations</h1></div>
					<div class="form-group">
						<label for="RoomMaxParticipants" class="control-label col-sm-3">Maximum Registrations:&nbsp;</label>
						<div class="col-sm-8">
							<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
								<cfinput type="text" class="form-control" id="RoomMaxParticipants" name="RoomMaxParticipants" value="#Session.getSpecificFacilityRoomInfo.Capacity#" required="yes">
							<cfelse>
								<cfinput type="text" class="form-control" id="RoomMaxParticipants" name="RoomMaxParticipants" required="yes">
							</cfif>
						</div>
					</div>
					<div class="panel-heading"><h1>Allow individuals to register</h1></div>
					<div class="form-group">
						<label for="AcceptRegistrations" class="control-label col-sm-3">Accept Registrations:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="AcceptRegistrations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
							<option value="----">Allow Individuals To Register</option></cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 3">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Add Event - Review Information"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Add New Event or Workshop - Step 4</h1></div>
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
					<div class="alert alert-info">This is Step 4 of the New Workshop or Event Creation Process. Please complete this information and click the button below to move to the next screen.</div>
					<div class="panel-heading"><h1>What is Maximum Registrations</h1></div>
					<div class="form-group">
						<label for="RoomMaxParticipants" class="control-label col-sm-3">Maximum Registrations:&nbsp;</label>
						<div class="col-sm-8">
							<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
								<cfinput type="text" class="form-control" id="RoomMaxParticipants" name="RoomMaxParticipants" value="#Session.getFacilityRoomInfo.Capacity#" required="yes">
							<cfelse>
								<cfinput type="text" class="form-control" id="RoomMaxParticipants" name="RoomMaxParticipants" value="#Session.UserSuppliedInfo.FourthStep.MaxRoomParticipants#"required="yes">
							</cfif>
						</div>
					</div>
					<div class="panel-heading"><h1>Allow individuals to register</h1></div>
					<div class="form-group">
						<label for="AcceptRegistrations" class="control-label col-sm-3">Accept Registrations:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="AcceptRegistrations" class="form-control" Required="Yes" Selected="#Session.UserSuppliedInfo.FourthStep.AcceptRegistrations#" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
							<option value="----">Allow Individuals To Register</option></cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 3">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Add Event - Review Information"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>