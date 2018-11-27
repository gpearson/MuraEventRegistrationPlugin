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
	<script>
		$(function() {
			$("##EventDate").datepick();
			$("##EventDate1").datepick();
			$("##EventDate2").datepick();
			$("##EventDate3").datepick();
			$("##EventDate4").datepick();
			$("##EventDate5").datepick();
			$("##EventDate6").datepick();
			$("##Registration_Deadline").datepick();
			
			$('##EventSession1_StartTime').timepicker({ 'scrollDefault': 'now' });
			$('##EventSession1_EndTime').timepicker({ 'scrollDefault': 'now' });
			$('##EventSession2_StartTime').timepicker({ 'scrollDefault': 'now' });
			$('##EventSession2_EndTime').timepicker({ 'scrollDefault': 'now' });
			$('##Registration_BeginTime').timepicker({ 'scrollDefault': 'now' });
			$('##Event_StartTime').timepicker({ 'scrollDefault': 'now' });
			$('##Event_EndTime').timepicker({ 'scrollDefault': 'now' });
		});
	</script>
	<div class="panel panel-default">
		<cfif not isDefined("Session.FormInput.EventStep1")>
			<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="Event_HasMultipleDates" value="0">
				<cfinput type="hidden" name="Event_DailySessions" value="0">
				<cfinput type="hidden" name="PerformAction" value="Step2">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Event Dates</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventHasMultipleDates" class="col-lg-5 col-md-5">Event Has Multiple Dates:&nbsp;</label>
						<div class="col-lg-7">
							<cfswitch expression="#Session.getSelectedEvent.Event_HasMultipleDates#">
								<cfcase value="1">
									<cfinput type="checkbox" class="form-check-input" name="Event_HasMultipleDates" id="Event_HasMultipleDates" value="1" checked>
								</cfcase>
								<cfdefaultcase>
									<cfinput type="checkbox" class="form-check-input" name="Event_HasMultipleDates" id="Event_HasMultipleDates" value="1">
								</cfdefaultcase>
							</cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Multiple Day Event)</div>
						</div>
					</div>
					<div class="form-group">
						<label for="EventHasDailySessions" class="col-lg-5 col-md-5">Event Has Daily Sessions:&nbsp;</label>
						<div class="col-lg-7">
							<cfswitch expression="#Session.getSelectedEvent.Event_DailySessions#">
								<cfcase value="1">
									<cfinput type="checkbox" class="form-check-input" name="Event_DailySessions" id="Event_DailySessions" value="1" checked>
								</cfcase>
								<cfdefaultcase>
									<cfinput type="checkbox" class="form-check-input" name="Event_DailySessions" id="Event_DailySessions" value="1">
								</cfdefaultcase>
							</cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Allow Event to have AM and PM Sessions)</div>
						</div>
					</div>
					<div class="panel-footer">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Update Event">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Proceed To Step 2"><br /><br />
					</div>
				</div>
			</cfform>
		<cfelseif isdefined("Session.FormInput.EventStep1")>
			<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
				<cfinput type="hidden" name="EventPricePerDay" value="0">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="PerformAction" value="UpdateEvent">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Event Dates</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="col-lg-5 col-md-5">Primary Event Date:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep2.EventDate1")>
								<cfinput type="text" class="form-control" id="EventDate" name="EventDate" value="#Session.FormInput.EventStep2.EventDate#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="EventDate" name="EventDate" value="#DateFormat(Session.getSelectedEvent.EventDate, 'mm/dd/yyyy')#" required="no">
							</cfif>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.Event_HasMultipleDates CONTAINS 1>
						<div class="form-group">
							<label for="EventPricePerDay" class="col-lg-5 col-md-5">Bill Per Event Date:&nbsp;</label>
							<div class="checkbox col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventPricePerDay")>
									<cfif Session.FormInput.EventStep2.EventPricePerDay EQ 1>
										<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
									<cfelse>
										<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
									</cfif>
								<cfelse>
									<cfif Session.getSelectedEvent.EventPricePerDay EQ 1>
										<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" value="1" checked> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
									<cfelse>
										<cfinput type="checkbox" class="form-check-input" name="EventPricePerDay" id="EventPricePerDay" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
									</cfif>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate1" class="col-lg-5 col-md-5">Second Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate1")>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#Session.FormInput.EventStep2.EventDate1#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#DateFormat(Session.getSelectedEvent.EventDate1, 'mm/dd/yyyy')#" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate2" class="col-lg-5 col-md-5">Third Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate2")>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#Session.FormInput.EventStep2.EventDate2#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#DateFormat(Session.getSelectedEvent.EventDate2, 'mm/dd/yyyy')#" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate3" class="col-lg-5 col-md-5">Fourth Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate3")>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#Session.FormInput.EventStep2.EventDate3#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#DateFormat(Session.getSelectedEvent.EventDate3, 'mm/dd/yyyy')#" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate4" class="col-lg-5 col-md-5">Fifth Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate4")>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#Session.FormInput.EventStep2.EventDate4#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#DateFormat(Session.getSelectedEvent.EventDate4, 'mm/dd/yyyy')#" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate5" class="col-lg-5 col-md-5">Sixth Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate5")>
									<cfinput type="text" class="form-control" id="EventDate5" name="EventDate5" value="#Session.FormInput.EventStep2.EventDate5#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate5" name="EventDate5" value="#DateFormat(Session.getSelectedEvent.EventDate5, 'mm/dd/yyyy')#" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate6" class="col-lg-5 col-md-5">Seventh Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate6")>
									<cfinput type="text" class="form-control" id="EventDate6" name="EventDate6" value="#Session.FormInput.EventStep2.EventDate6#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate6" name="EventDate6" value="#DateFormat(Session.getSelectedEvent.EventDate6, 'mm/dd/yyyy')#" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<cfif Session.FormInput.EventStep1.Event_DailySessions CONTAINS 1>
						<fieldset>
							<legend><h2>Event Sessions Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="Event_Session1BeginTime" class="col-lg-5 col-md-5">First Session Begin Time:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Event_Session1BeginTime")>
									<cfinput type="text" class="form-control" id="Event_Session1BeginTime" name="Event_Session1BeginTime" value="#Session.FormInput.EventStep2.Event_Session1BeginTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session1BeginTime" name="Event_Session1BeginTime" value="#TimeFormat(Session.FormInput.EventStep2.Event_Session1BeginTime, 'hh:mm tt')#" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Event_Session1EndTime" class="col-lg-5 col-md-5">First Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep1.Event_Session1EndTime")>
									<cfinput type="text" class="form-control" id="Event_Session1EndTime" name="Event_Session1EndTime" value="#Session.FormInput.EventStep2.Event_Session1EndTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session1EndTime" name="Event_Session1EndTime" value="#TimeFormat(Session.FormInput.EventStep2.Event_Session1EndTime, 'hh:mm tt')#" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Event_Session2BeginTime" class="col-lg-5 col-md-5">Second Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Event_Session2BeginTime")>
									<cfinput type="text" class="form-control" id="Event_Session2BeginTime" name="Event_Session2BeginTime" value="#Session.FormInput.EventStep2.Event_Session2BeginTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session2BeginTime" name="Event_Session2BeginTime" value="#TimeFormat(Session.FormInput.EventStep2.Event_Session2BeginTime, 'hh:mm tt')#" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Event_Session2EndTime" class="col-lg-5 col-md-5">Second Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Event_Session2EndTime")>
									<cfinput type="text" class="form-control" id="Event_Session2EndTime" name="Event_Session2EndTime" value="#Session.FormInput.EventStep2.Event_Session2EndTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session2EndTime" name="Event_Session2EndTime" value="#TimeFormat(Session.FormInput.EventStep2.Event_Session2EndTime, 'hh:mm tt')#" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="Registration_Deadline" class="col-lg-5 col-md-5">Registration Deadline:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep2.Registration_Deadline")>
								<cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#Session.FormInput.EventStep2.Registration_Deadline#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#DateFormat(Session.getSelectedEvent.Registration_Deadline, 'mm/dd/yyyy')#" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="col-lg-5 col-md-5">Registration Start Time:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep2.Registration_BeginTime")>
								<cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" value="#TimeFormat(Session.FormInput.EventStep2.Registration_BeginTime, 'hh:mm tt')#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" value="#Session.getSelectedEvent.Registration_BeginTime#" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="col-lg-5 col-md-5">Event Start Time:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep2.Event_StartTime")>
								<cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" value="#TimeFormat(Session.FormInput.EventStep2.Event_StartTime, 'hh:mm tt')#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" value="#TimeFormat(Session.getSelectedEvent.Event_StartTime, 'hh:mm tt')#" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="col-lg-5 col-md-5">Event End Time:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep2.Event_EndTime")>
								<cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" value="#TimeFormat(Session.FormInput.EventStep2.Event_EndTime, 'hh:mm tt')#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" value="#TimeFormat(Session.getSelectedEvent.Event_EndTime, 'hh:mm tt')#" required="no">
							</cfif>
						</div>
					</div>
					<div class="panel-footer">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Update Event">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event"><br /><br />
					</div>
				</div>
			</cfform>
		</cfif>
	</div>
</cfoutput>



<!--- 
EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, 

, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime 
--->