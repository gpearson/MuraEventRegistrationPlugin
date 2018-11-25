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
	<script>
		$(function() {
			$("##Registration_Deadline").datepicker();
			$("##Registration_BeginTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##Event_StartTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##Event_EndTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
		});
	</script>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="Registration_Deadline" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#DateFormat(Session.getSelectedEvent.Registration_Deadline, 'mm/dd/yyyy')#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="control-label col-sm-3">Begin Time of OnSite Registrations:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" value="#TimeFormat(Session.getSelectedEvent.Registration_BeginTime, 'HH:MM tt')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="control-label col-sm-3">Event Start Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" value="#TimeFormat(Session.getSelectedEvent.Event_StartTime, 'HH:MM tt')#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="control-label col-sm-3">Event End Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" value="#TimeFormat(Session.getSelectedEvent.Event_EndTime, 'HH:MM tt')#" required="yes"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#Session.FormData.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="Registration_Deadline" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#DateFormat(Session.getSelectedEvent.Registration_Deadline, 'mm/dd/yyyy')#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="control-label col-sm-3">Begin Time of OnSite Registrations:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" value="#TimeFormat(Session.getSelectedEvent.Registration_BeginTime, 'HH:MM tt')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="control-label col-sm-3">Event Start Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" value="#TimeFormat(Session.getSelectedEvent.Event_StartTime, 'HH:MM tt')#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="control-label col-sm-3">Event End Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" value="#TimeFormat(Session.getSelectedEvent.Event_EndTime, 'HH:MM tt')#" required="yes"></div>
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
