<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 1><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step4&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false"></cfif>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 3 of 5 - Add New Event</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete any additional information and click the Proceed Button Below to continue.</div>
					<div class="form-group">
						<label for="LocationRoomID" class="control-label col-sm-3">Which Room at Facility:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="LocationRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityRoomInfo" value="RoomID" Display="RoomName"  queryposition="below">
							<option value="----">Select Which Room at Facility this event is held in</option></cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 2">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Proceed to Step 4"><br /><br />
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
						<legend><h2>Step 3 of 5 - Add New Event</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete any additional information and click the Proceed Button Below to continue.</div>
					<div class="form-group">
						<label for="LocationRoomID" class="control-label col-sm-3">Which Room at Facility:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="LocationRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityRoomInfo" value="RoomID" Display="RoomName"  queryposition="below">
							<option value="----">Select Which Room at Facility this event is held in</option></cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 2">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Proceed to Step 4"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>