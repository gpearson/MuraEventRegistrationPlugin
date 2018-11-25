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
			<div class="panel-heading"><h1>Add New Event or Workshop - Step 1</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="AcceptRegistrations" value="0">
				<cfinput type="hidden" name="Registration_EndTime" value="0">
				<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="PerformAction" value="Step2">
				<div class="panel-body">
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for.</div>
					<div class="panel-heading"><h1>Event Date and Time Information</h1></div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate" name="EventDate" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventSpanDates" class="control-label col-sm-3">Event has Multiple Dates:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="EventSpanDates" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Does Event have multiple dates</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="Registration_Deadline" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Registration_BeginTime" class="control-label col-sm-3">Registration Start Time:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Event_StartTime" class="control-label col-sm-3">Event Begin Time:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Event_EndTime" class="control-label col-sm-3">Event Ending Time:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" required="yes"></div>
						</div>
						<div class="panel-heading"><h1>Event Description Information</h1></div>
						<div class="form-group">
							<label for="ShortTitle" class="control-label col-sm-3">Event Title:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="LongDescription" class="control-label col-sm-3">Event Description:&nbsp;</label>
							<div class="col-sm-8"><textarea name="LongDescription" id="LongDescription" class="form-control" ></textarea></div>
						</div>
						<div class="panel-heading"><h1>Event Specific Feature Information</h1></div>
						<div class="alert alert-info">The default option for each one of the following is No unless you specifically select Yes on these questions.</div>
						<div class="form-group">
							<label for="EventFeatured" class="control-label col-sm-3">Event is Featured:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="EventFeatured" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Will Event be Featured on Website</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Earlybird Registration Available:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="EarlyBird_RegistrationAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Will Event allow Early Bird Registrations</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="ViewSpecialPricing" class="control-label col-sm-3">Special Pricing Available:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="ViewSpecialPricing" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Will Event have special pricing avialable</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="PGPAvailable" class="control-label col-sm-3">PGP Certificate Available:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="PGPAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Will Event issue PGP Certificates</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="MealProvided" class="control-label col-sm-3">Meal Provided:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="MealProvided" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Will Meal be provided to Participants</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="AllowVideoConference" class="control-label col-sm-3">Is Distance Education Available:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="AllowVideoConference" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Can Participants participate via Distance Education</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="WebinarEvent" class="control-label col-sm-3">Webinar Only Event:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="WebinarEvent" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Webinar Only Event</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="PostEventToFB" class="control-label col-sm-3">Post to FB Fan Page:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="PostEventToFB" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Post Event to FB Page</option>
								</cfselect>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<cfinput type="Submit" name="RegisterAccount" class="btn btn-primary pull-right" value="Add Event - Step 2"><br /><br />
					</div>
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Add New Event or Workshop - Step 1</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="AcceptRegistrations" value="0">
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
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for.</div>
					<div class="panel-heading"><h1>Event Date and Time Information</h1></div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate" value="#Session.UserSuppliedInfo.EventDate#" name="EventDate" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EventSpanDates" class="control-label col-sm-3">Event has Multiple Dates:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="EventSpanDates" class="form-control" Required="Yes" Multiple="No" selected="#Session.UserSuppliedInfo.EventSpanDates#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Does Event have multiple dates</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="Registration_Deadline" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#Session.UserSuppliedInfo.Registration_Deadline#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Registration_BeginTime" class="control-label col-sm-3">Registration Start Time:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" value="#Session.UserSuppliedInfo.Registration_BeginTime#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Event_StartTime" class="control-label col-sm-3">Event Begin Time:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" value="#Session.UserSuppliedInfo.Event_StartTime#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Event_EndTime" class="control-label col-sm-3">Event Ending Time:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" value="#Session.UserSuppliedInfo.Event_EndTime#" required="yes"></div>
						</div>
						<div class="panel-heading"><h1>Event Description Information</h1></div>
						<div class="form-group">
							<label for="ShortTitle" class="control-label col-sm-3">Event Title:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" value="#Session.UserSuppliedInfo.ShortTitle#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="LongDescription" class="control-label col-sm-3">Event Description:&nbsp;</label>
							<div class="col-sm-8"><textarea name="LongDescription" id="LongDescription" class="form-control">#Session.UserSuppliedInfo.LongDescription#</textarea></div>
						</div>
						<div class="panel-heading"><h1>Event Specific Feature Information</h1></div>
						<div class="alert alert-info">The default option for each one of the following is No unless you specifically select Yes on these questions.</div>
						<div class="form-group">
							<label for="EventFeatured" class="control-label col-sm-3">Event is Featured:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="EventFeatured" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Will Event be Featured on Website</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Earlybird Registration Available:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="EarlyBird_RegistrationAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable#" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Will Event allow Early Bird Registrations</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="ViewSpecialPricing" class="control-label col-sm-3">Special Pricing Available:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="ViewSpecialPricing" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.UserSuppliedInfo.ViewSpecialPricing#" Display="OptionName"  queryposition="below">
									<option value="----">Will Event have special pricing avialable</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="PGPAvailable" class="control-label col-sm-3">PGP Certificate Available:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="PGPAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.UserSuppliedInfo.PGPAvailable#"  queryposition="below">
									<option value="----">Will Event issue PGP Certificates</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="MealProvided" class="control-label col-sm-3">Meal Provided:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="MealProvided" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.UserSuppliedInfo.MealProvided#" queryposition="below">
									<option value="----">Will Meal be provided to Participants</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="AllowVideoConference" class="control-label col-sm-3">Is Distance Education Available:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="AllowVideoConference" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.UserSuppliedInfo.AllowVideoConference#" Display="OptionName"  queryposition="below">
									<option value="----">Can Participants participate via Distance Education</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="WebinarEvent" class="control-label col-sm-3">Webinar Only Event:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="WebinarEvent" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.UserSuppliedInfo.WebinarEvent#" Display="OptionName"  queryposition="below">
									<option value="----">Webinar Only Event</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="PostEventToFB" class="control-label col-sm-3">Post to FB Fan Page:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="PostEventToFB" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.UserSuppliedInfo.PostEventToFB#" Display="OptionName"  queryposition="below">
									<option value="----">Post Event to FB Page</option>
								</cfselect>
							</div>
						</div>
					</div>
					<div class="panel-footer">
						<cfinput type="Submit" name="RegisterAccount" class="btn btn-primary pull-right" value="Add Event - Step 2"><br /><br />
					</div>
				</div>
			</cfform>
		</div>
	</cfif>

<!---

	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Add new Event or Workshop</h3>
		</div>
		<div class="art-blockcontent">

			<hr>
			<uForm:form action="" method="Post" id="AddEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
				submitValue="Proceed To Step 2" loadValidation="true" loadMaskUI="true" loadDateUI="false"
				loadTimeUI="false">
				<uForm:fieldset legend="Event Date and Time">
					<cfif isDefined("Session.UserSuppliedInfo.EventDate")>
						<uform:field label="Primary Event Date" name="EventDate" id="EventDate" isRequired="true" value="#Session.UserSuppliedInfo.EventDate#" type="date" hint="Date of Event, First Date if event has multiple dates." />
					<cfelse>
						<uform:field label="Primary Event Date" name="EventDate" id="EventDate" isRequired="true" type="date" hint="Date of Event, First Date if event has multiple dates." />
					</cfif>
					<uform:field label="Event Span Dates" name="EventSpanDates" type="select" hint="Does this event span multiple dates">
						<cfif isDefined("Session.UserSuppliedInfo.EventSpanDates")>
							<cfif Session.UserSuppliedInfo.EventSpanDates EQ true>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>

					<cfif isDefined("Session.UserSuppliedInfo.Registration_Deadline")>
						<uform:field label="Registration Deadline" name="Registration_Deadline" isRequired="true" value="#Session.UserSuppliedInfo.Registration_Deadline#" type="date" inputClass="date" hint="Accept Registration up to this date" />
					<cfelse>
						<uform:field label="Registration Deadline" name="Registration_Deadline" isRequired="true" type="date" inputClass="date" hint="Accept Registration up to this date" />
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.Registration_BeginTime")>
						<uform:field label="Registration Start Time" name="Registration_BeginTime" isRequired="false" value="#Session.UserSuppliedInfo.Registration_BeginTime#" type="time" pluginSetup="#timeConfig#" hint="The Beginning Time onSite Registration begins" />
					<cfelse>
						<uform:field label="Registration Start Time" name="Registration_BeginTime" isRequired="false" type="time" pluginSetup="#timeConfig#" hint="The Beginning Time onSite Registration begins" />
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.Event_StartTime")>
						<uform:field label="Event Start Time" name="Event_StartTime" isRequired="true" type="time" value="#Session.UserSuppliedInfo.Event_StartTime#" pluginSetup="#timeConfig#" hint="The starting time of this event" />
					<cfelse>
						<uform:field label="Event Start Time" name="Event_StartTime" isRequired="true" type="time" pluginSetup="#timeConfig#" hint="The starting time of this event" />
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.Event_EndTime")>
						<uform:field label="Event End Time" name="Event_EndTime" isRequired="true" type="time" value="#Session.UserSuppliedInfo.Event_EndTime#" pluginSetup="#timeConfig#" hint="The starting time of this event" />
					<cfelse>
						<uform:field label="Event End Time" name="Event_EndTime" isRequired="true" type="time" pluginSetup="#timeConfig#" hint="The starting time of this event" />
					</cfif>
				</uForm:fieldset>

				<uForm:fieldset legend="Event Description">
					<cfif isDefined("Session.UserSuppliedInfo.ShortTitle")>
						<uform:field label="Event Short Title" name="ShortTitle" isRequired="true" value="#Session.UserSuppliedInfo.ShortTitle#" type="text" hint="Short Event Title of Event" />
					<cfelse>
						<uform:field label="Event Short Title" name="ShortTitle" isRequired="true" type="text" hint="Short Event Title of Event" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.LongDescription")>
						<uform:field label="Event Description" name="LongDescription" isRequired="true" value="#Session.UserSuppliedInfo.LongDescription#" type="textarea" hint="Description of this meeting or event" />
					<cfelse>
						<uform:field label="Event Description" name="LongDescription" isRequired="true" type="textarea" hint="Description of this meeting or event" />
					</cfif>
				</uForm:fieldset>

				<uForm:fieldset legend="Event Features">
					<uform:field label="Event Featured" name="EventFeatured" type="select" hint="Would this event be featured on the website?">
						<cfif isDefined("Session.UserSuppliedInfo.EventFeatured")>
							<cfif Session.UserSuppliedInfo.EventFeatured EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="EarlyBird Registration Available" name="EarlyBird_RegistrationAvailable" type="select" hint="Does this event have an EarlyBird Registration Cutoff Date/Price">
						<cfif isDefined("Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable")>
							<cfif Session.UserSuppliedInfo.EarlyBird_RegistrationAvailable EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="Special Pricing Available" name="ViewSpecialPricing" type="select" hint="Does this event have special pricing available?">
						<cfif isDefined("Session.UserSuppliedInfo.ViewSpecialPricing")>
							<cfif Session.UserSuppliedInfo.ViewSpecialPricing EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="PGP Points Available" name="PGPAvailable" type="select" hint="Does this event have PGP Points for Attendee(s)?">
						<cfif isDefined("Session.UserSuppliedInfo.PGPAvailable")>
							<cfif Session.UserSuppliedInfo.PGPAvailable EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="Meal Provided" name="MealProvided" type="select" hint="Does this event have a meal available to attendee(s)?">
						<cfif isDefined("Session.UserSuppliedInfo.MealProvided")>
							<cfif Session.UserSuppliedInfo.MealProvided EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="Allow Video Conference" name="AllowVideoConference" type="select" hint="Can an attendee participate with Video Conference (IP Video)?">
						<cfif isDefined("Session.UserSuppliedInfo.AllowVideoConference")>
							<cfif Session.UserSuppliedInfo.AllowVideoConference EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>

					<uform:field label="Webinar Event Only" name="WebinarEvent" type="select" hint="Is this event an online only event utilizing webinar technology">
						<cfif isDefined("Session.UserSuppliedInfo.WebinarEvent")>
							<cfif Session.UserSuppliedInfo.WebinarEvent EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="Post to Facebook Page" name="PostEventToFB" type="select" hint="Do you want to post this event to Facebook Timeline?">
						<cfif isDefined("Session.UserSuppliedInfo.PostEventToFB")>
							<cfif Session.UserSuppliedInfo.PostEventToFB EQ 1>
								<uform:option display="Yes" value="1" isSelected="true" />
								<uform:option display="No" value="0" />
							<cfelse>
								<uform:option display="Yes" value="1" />
								<uform:option display="No" value="0" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<uform:field label="Location for Event" name="LocationType" type="select" hint="What type of Facility will this event be held at?">
						<cfif isDefined("Session.UserSuppliedInfo.LocationType")>
							<cfif Session.UserSuppliedInfo.LocationType EQ "S">
								<uform:option display="School District" value="S" isSelected="true" />
								<uform:option display="Business Facility" value="B" />
							<cfelse>
								<uform:option display="School District" value="S" />
								<uform:option display="Business Facility" value="B" isSelected="true" />
							</cfif>
						<cfelse>
							<uform:option display="School District" value="S" />
							<uform:option display="Business Facility" value="B" isSelected="true" />
						</cfif>
					</uform:field>
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
	--->
</cfoutput>