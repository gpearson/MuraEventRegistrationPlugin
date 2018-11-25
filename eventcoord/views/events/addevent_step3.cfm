<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfif Session.UserSuppliedInfo.WebinarEvent EQ 1><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.addevent_step4&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false"></cfif>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Add New Event or Workshop - Step 3</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="alert alert-info">This is Step 3 of the New Workshop or Event Creation Process. Please complete this information and click the button below to move to the next screen.</div>
					<div class="panel-heading"><h1>Event held in Room of Facility</h1></div>
					<div class="form-group">
						<label for="LocationRoomID" class="control-label col-sm-3">Which Room at Facility:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="LocationRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityRoomInfo" value="RoomID" Display="RoomName"  queryposition="below">
							<option value="----">Select Which Room at Facility this event is held in</option></cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 2">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Add Event - Step 4"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Add New Event or Workshop - Step 3</h1></div>
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
					<div class="alert alert-info">This is Step 3 of the New Workshop or Event Creation Process. Please complete this information and click the button below to move to the next screen.</div>
					<div class="panel-heading"><h1>Event held in Room of Facility</h1></div>
					<div class="form-group">
						<label for="LocationRoomID" class="control-label col-sm-3">Which Room at Facility:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="LocationRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityRoomInfo" value="RoomID" Display="RoomName"  queryposition="below">
							<option value="----">Select Which Room at Facility this event is held in</option></cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 2">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Add Event - Step 4"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>