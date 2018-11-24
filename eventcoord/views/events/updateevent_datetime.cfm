<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
</cflock>
<cfoutput>
	<script>
		$(function() {
			$("##EventDate").datepicker();
			$("##EventDate1").datepicker();
			$("##EventDate2").datepicker();
			$("##EventDate3").datepicker();
			$("##EventDate4").datepicker();
			$("##EventDate5").datepicker();
			$("##Registration_Deadline").datepicker();
			$("##Registration_BeginTime").timepicker({
				timeFormat: 'hh:mm TT',
				controlType: 'select'
			});
			$("##Event_StartTime").timepicker({
				timeFormat: 'hh:mm TT',
				controlType: 'select'
			});
			$("##Event_EndTime").timepicker({
				timeFormat: 'hh:mm TT',
				controlType: 'select'
			});
		});
	</script>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Updating Workshop/Event: #Session.UserSuppliedInfo.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<p class="alert-box notice">Please make changes to the information listed below so this event displays accurate information.</p>
			<hr>
			<uForm:form action="" method="Post" id="UpdateEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
				submitValue="Update Event" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="PerformAction" value="UpdateEvent">
				<uForm:fieldset legend="Event Date and Time">
					<uform:field label="Primary Event Date" name="EventDate" isRequired="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate, 'mm/dd/yyyy')#" type="date" inputClass="date" hint="Date of Event, First Date if event has multiple dates." />
					<uform:field label="Registration Deadline" name="Registration_Deadline" isRequired="true" value="#DateFormat(Session.UserSuppliedInfo.Registration_Deadline, 'mm/dd/yyyy')#" type="date" inputClass="date" hint="Accept Registration up to this date" />
					<uform:field label="Registration Start Time" name="Registration_BeginTime" isRequired="false" value="#TimeFormat(Session.UserSuppliedInfo.Registration_BeginTime, 'hh:mm tt')#" type="time" hint="The Beginning Time onSite Registration begins" />
					<uform:field label="Event Start Time" name="Event_StartTime" isRequired="true" type="time" value="#TimeFormat(Session.UserSuppliedInfo.Event_StartTime, 'hh:mm tt')#" hint="The starting time of this event" />
					<uform:field label="Event End Time" name="Event_EndTime" isRequired="true" type="time" value="#TimeFormat(Session.UserSuppliedInfo.Event_EndTime, 'hh:mm tt')#" hint="The starting time of this event" />
					<uform:field label="Event Span Dates" name="EventSpanDates" type="select" hint="Does this event span multiple dates">
						<cfif Session.UserSuppliedInfo.EventSpanDates EQ true>
							<uform:option display="Yes" value="1" isSelected="true" />
							<uform:option display="No" value="0" />
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
					<cfif Session.UserSuppliedInfo.EventSpanDates EQ true>
						<cfif isDefined("Session.UserSuppliedInfo.EventDate1")>
							<uform:field label="Additional Event Date" name="EventDate1" isRequired="false" value="#DateFormat(Session.UserSuppliedInfo.EventDate1, 'mm/dd/yyyy')#" type="date" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." />
						<cfelse>
							<uform:field label="Additional Event Date" name="EventDate1" isRequired="false" type="date" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." />
						</cfif>
						<cfif isDefined("Session.UserSuppliedInfo.EventDate2")>
							<uform:field label="Additional Event Date" name="EventDate2" isRequired="false" value="#DateFormat(Session.UserSuppliedInfo.EventDate2, 'mm/dd/yyyy')#" type="date" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." />
						<cfelse>
							<uform:field label="Additional Event Date" name="EventDate2" isRequired="false" type="date" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." />
						</cfif>
						<cfif isDefined("Session.UserSuppliedInfo.EventDate3")>
							<uform:field label="Additional Event Date" name="EventDate3" isRequired="false" value="#DateFormat(Session.UserSuppliedInfo.EventDate3, 'mm/dd/yyyy')#" type="date" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." />
						<cfelse>
							<uform:field label="Additional Event Date" name="EventDate3" isRequired="false" type="date" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." />
						</cfif>
						<cfif isDefined("Session.UserSuppliedInfo.EventDate4")>
							<uform:field label="Additional Event Date" name="EventDate4" isRequired="false" value="#DateFormat(Session.UserSuppliedInfo.EventDate4, 'mm/dd/yyyy')#" type="date" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." />
						<cfelse>
							<uform:field label="Additional Event Date" name="EventDate4" isRequired="false" type="date" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." />
						</cfif>
						<cfif isDefined("Session.UserSuppliedInfo.EventDate5")>
							<uform:field label="Additional Event Date" name="EventDate5" isRequired="false" value="#DateFormat(Session.UserSuppliedInfo.EventDate5, 'mm/dd/yyyy')#" type="date" inputClass="date" hint="Date of Event, Sixth Date if event has multiple dates." />
						<cfelse>
							<uform:field label="Additional Event Date" name="EventDate5" isRequired="false" type="date" inputClass="date" hint="Date of Event, Sixth Date if event has multiple dates." />
						</cfif>
					</cfif>
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>