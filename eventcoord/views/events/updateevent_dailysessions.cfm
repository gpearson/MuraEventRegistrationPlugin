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
			$("##EventSession1_StartTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##EventSession2_StartTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##EventSession1_EndTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##EventSession2_EndTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
		});
	</script>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventHaveSessions" class="control-label col-sm-3">Event has Daily Sessions:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EventHaveSessions" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.getSelectedEvent.EventHasDailySessions#" queryposition="below">
								<option value="----">Will Event have 2 Sessions on a Single Day</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<label for="EventSession1_StartTime" class="control-label col-sm-3">First Session Begin Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession1_StartTime" name="EventSession1_StartTime" value="#TimeFormat(Session.getSelectedEvent.Session1BeginTime, 'hh:mm tt')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventSession1_EndTime" class="control-label col-sm-3">First Session End Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession1_EndTime" name="EventSession1_EndTime" value="#TimeFormat(Session.getSelectedEvent.Session1EndTime, 'hh:mm tt')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventSession2_StartTime" class="control-label col-sm-3">Second Session Begin Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession2_StartTime" name="EventSession2_StartTime" value="#TimeFormat(Session.getSelectedEvent.Session2BeginTime, 'hh:mm tt')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventSession2_EndTime" class="control-label col-sm-3">Second Session End Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession2_EndTime" name="EventSession2_EndTime" value="#TimeFormat(Session.getSelectedEvent.Session2EndTime, 'hh:mm tt')#" required="no"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Review">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#Session.FormData.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="panel-body">
					<fieldset>
						<legend><h2>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventHaveSessions" class="control-label col-sm-3">Event has Daily Sessions:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="EventHaveSessions" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.getSelectedEvent.EventHasDailySessions#" queryposition="below">
								<option value="----">Will Event have 2 Sessions on a Single Day</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<label for="EventSession1_StartTime" class="control-label col-sm-3">First Session Begin Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession1_StartTime" name="EventSession1_StartTime" value="#TimeFormat(Session.getSelectedEvent.Session1BeginTime, 'hh:mm tt')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventSession1_EndTime" class="control-label col-sm-3">First Session End Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession1_EndTime" name="EventSession1_EndTime" value="#TimeFormat(Session.getSelectedEvent.Session1EndTime, 'hh:mm tt')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventSession2_StartTime" class="control-label col-sm-3">Second Session Begin Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession2_StartTime" name="EventSession2_StartTime" value="#TimeFormat(Session.getSelectedEvent.Session2BeginTime, 'hh:mm tt')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventSession2_EndTime" class="control-label col-sm-3">Second Session End Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventSession2_EndTime" name="EventSession2_EndTime" value="#TimeFormat(Session.getSelectedEvent.Session2EndTime, 'hh:mm tt')#" required="no"></div>
					</div>
				</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Review">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
