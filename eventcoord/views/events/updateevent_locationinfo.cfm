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
	<cfif not isDefined("URL.FormRetry") and not isDefined("URL.SelectRoom")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="LocationID" class="control-label col-sm-3">Event Location:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getAllLocations" value="TContent_ID" selected="#Session.getSelectedEvent.LocationID#" Display="FacilityName"  queryposition="below">
								<option value="----">Select Event Location</option>
							</cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry") and not isDefined("URL.SelectRoom")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#Session.FormData.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="LocationID" class="control-label col-sm-3">Event Location:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getAllLocations" value="TContent_ID" selected="#Session.getSelectedEvent.LocationID#" Display="FacilityName"  queryposition="below">
								<option value="----">Select Event Location</option>
							</cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif not isDefined("URL.FormRetry") and isDefined("URL.SelectRoom")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="LocationRoomID" class="control-label col-sm-3">Event Room Name:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="LocationRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getAllLocationRooms" value="TContent_ID" selected="#Session.getSelectedEvent.LocationRoomID#" Display="RoomName"  queryposition="below">
								<option value="----">Select Location Room</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<label for="MaxParticipants" class="control-label col-sm-3">Maximum Participants:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="RoomMaxParticipants" name="RoomMaxParticipants" value="#Session.getSelectedEvent.MaxParticipants#" required="yes"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry") and isDefined("URL.SelectRoom")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="LocationRoomID" class="control-label col-sm-3">Event Room Name:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="LocationRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getAllLocationRooms" value="TContent_ID" selected="#Session.getSelectedEvent.LocationRoomID#" Display="RoomName"  queryposition="below">
								<option value="----">Select Location Room</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<label for="MaxParticipants" class="control-label col-sm-3">Maximum Participants:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="RoomMaxParticipants" name="RoomMaxParticipants" value="#Session.getSelectedEvent.MaxParticipants#" required="yes"></div>
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
