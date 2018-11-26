<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>
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
			$("##EventDate").datepicker();
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
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="Registration_EndTime" value="0">
				<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="PerformAction" value="Step2">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Add New Event or Workshop - Step 1</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for.</div>
					<fieldset>
						<legend><h2>Event Date and Time Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate" name="EventDate" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventSpanDates" class="control-label col-sm-3">Event has Multiple Dates:&nbsp;</label>
						<div class="checkbox col-sm-1">&nbsp;</div>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="EventSpanDates" id="EventSpanDates" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Enable Multiple Day Event)</div></div>
					</div>
					<div class="form-group required">
						<label for="Registration_Deadline" class="control-label col-sm-3">Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="control-label col-sm-3">Registration Start Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="control-label col-sm-3">Event Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="control-label col-sm-3">Event Ending Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" required="yes"></div>
					</div>
					<fieldset>
						<legend><h2>Event Description Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ShortTitle" class="control-label col-sm-3">Event Title:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LongDescription" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8"><textarea name="LongDescription" id="LongDescription" class="form-control" ></textarea><span id="LongDescriptionCharacters"></span> Characters</div>
					</div>
					<fieldset>
						<legend><h2>Event Specific Feature Information</h2></legend>
					</fieldset>
					<div class="alert alert-info">The default option for each one of the following is No unless you specifically select Yes on these questions.</div>
					<div class="form-group">
						<label for="EventFeatured" class="control-label col-sm-3">Event is Featured:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="EventFeatured" id="EventFeatured" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="EventHaveSessions" class="control-label col-sm-3">Event has Daily Sessions:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="EventHaveSessions" id="EventHaveSessions" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<!---
					<div class="form-group">
						<label for="EventHasBreakoutSessions" class="control-label col-sm-3">Event has Breakout Sessions:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="EventBreakoutSessions" id="EventBreakoutSessions" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					--->
					<div class="form-group">
						<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Earlybird Registration Available:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="EarlyBird_RegistrationAvailable" id="EarlyBird_RegistrationAvailable" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="ViewGroupPricing" class="control-label col-sm-3">Group Pricing Available:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="ViewGroupPricing" id="ViewGroupPricing" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="PGPAvailable" class="control-label col-sm-3">PGP Certificate Available:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="PGPAvailable" id="PGPAvailable" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="MealAvailable" class="control-label col-sm-3">Meal Available:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="MealAvailable" id="MealAvailable" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to enable this event feature)</div></div>
					</div>
					<div class="form-group">
						<label for="AllowVideoConference" class="control-label col-sm-3">Is Distance Education Available:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="AllowVideoConference" id="AllowVideoConference" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="WebinarEvent" class="control-label col-sm-3">Webinar Only Event:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="WebinarEvent" id="WebinarEvent" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="PostEventToFB" class="control-label col-sm-3">Post to FB Fan Page:&nbsp;&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="PostEventToFB" id="PostEventToFB" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Add Event - Step 2"><br /><br />
				</div>
			</cfform>
		</div>
		<script type="text/javascript">
			$('##LongDescription').keyup(LongDescriptionupdateCounter);
			$('##LongDescription').keydown(LongDescriptionupdateCounter);

			function LongDescriptionupdateCounter() {
				var cs = $(this).val().length;
				$('##LongDescriptionCharacters').text(cs);
			}
		</script>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="Registration_EndTime" value="0">
				<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="PerformAction" value="Step2">
				<cfif isDefined("Session.FormErrors")>
					<div class="panel-body">
						<cfif ArrayLen(Session.FormErrors) GTE 1>
							<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
						</cfif>
					</div>
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Add New Event or Workshop - Step 1</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for.</div>
					<fieldset>
						<legend><h2>Event Date and Time Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate" value="#Session.UserSuppliedInfo.EventDate#" name="EventDate" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventSpanDates" class="control-label col-sm-3">Event has Multiple Dates:&nbsp;</label>
						<div class="checkbox col-sm-1">&nbsp;</div>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="EventSpanDates" id="EventSpanDates" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Enable Multiple Day Event)</div></div>
					</div>
					<div class="form-group">
						<label for="Registration_Deadline" class="control-label col-sm-3">Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#Session.UserSuppliedInfo.Registration_Deadline#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="control-label col-sm-3">Registration Start Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" value="#Session.UserSuppliedInfo.Registration_BeginTime#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="control-label col-sm-3">Event Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" value="#Session.UserSuppliedInfo.Event_StartTime#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="control-label col-sm-3">Event Ending Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" value="#Session.UserSuppliedInfo.Event_EndTime#" required="yes"></div>
					</div>
					<fieldset>
						<legend><h2>Event Description Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ShortTitle" class="control-label col-sm-3">Event Title:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" value="#Session.UserSuppliedInfo.ShortTitle#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LongDescription" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8"><textarea name="LongDescription" id="LongDescription" class="form-control">#Session.UserSuppliedInfo.LongDescription#</textarea><span id="LongDescriptionCharacters"></span> Characters</div>
					</div>
					<fieldset>
						<legend><h2>Event Specific Feature Information</h2></legend>
					</fieldset>
					<div class="alert alert-info">The default option for each one of the following is No unless you specifically select Yes on these questions.</div>
					<div class="form-group">
						<label for="EventFeatured" class="control-label col-sm-3">Event is Featured:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="EventFeatured" id="EventFeatured" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="EventHaveSessions" class="control-label col-sm-3">Event has Daily Sessions:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="EventHaveSessions" id="EventHaveSessions" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<!---
					<div class="form-group">
						<label for="EventHasBreakoutSessions" class="control-label col-sm-3">Event has Breakout Sessions:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="EventBreakoutSessions" id="EventBreakoutSessions" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					--->
					<div class="form-group">
						<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Earlybird Registration Available:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="EarlyBird_RegistrationAvailable" id="EarlyBird_RegistrationAvailable" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="ViewGroupPricing" class="control-label col-sm-3">Group Pricing Available:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="ViewGroupPricing" id="ViewGroupPricing" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="PGPAvailable" class="control-label col-sm-3">PGP Certificate Available:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="PGPAvailable" id="PGPAvailable" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="MealAvailable" class="control-label col-sm-3">Meal Provided:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="MealAvailable" id="MealAvailable" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="AllowVideoConference" class="control-label col-sm-3">Is Distance Education Available:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="AllowVideoConference" id="AllowVideoConference" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="WebinarEvent" class="control-label col-sm-3">Webinar Only Event:&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="WebinarEvent" id="WebinarEvent" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
					<div class="form-group">
						<label for="PostEventToFB" class="control-label col-sm-3">Post to FB Fan Page:&nbsp;&nbsp;</label>
						<div class="checkbox col-sm-6"><cfinput type="checkbox" name="PostEventToFB" id="PostEventToFB" value="Yes"> <div style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Add Event - Step 2"><br /><br />
				</div>
			</cfform>
		</div>
		<script type="text/javascript">
			$('##LongDescription').keyup(LongDescriptionupdateCounter);
			$('##LongDescription').keydown(LongDescriptionupdateCounter);

			function LongDescriptionupdateCounter() {
				var cs = $(this).val().length;
				$('##LongDescriptionCharacters').text(cs);
			}
		</script>
	</cfif>
</cfoutput>