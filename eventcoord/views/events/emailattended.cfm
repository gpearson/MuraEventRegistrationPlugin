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

<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>
<cfoutput>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Sending an Email to Workshop/Event Attended Participants:<br>#Session.UserSuppliedInfo.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">Please complete this form to send a message to those who attended this event.<br><Strong>Number of Registrations Currently: #Session.EventNumberAttended#</Strong></div>
			<hr>
			<uForm:form action="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailattended&compactDisplay=false&EventID=#URL.EventID#&EventStatus=EmailParticipants" method="Post" id="EmailEventParticipants" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
				submitValue="Email Event Participants" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="PerformAction" value="CancelEvent">
				<uForm:fieldset legend="Event Date and Time">
					<uform:field label="Primary Event Date" name="EventDate" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, First Date if event has multiple dates." />
					<cfif Session.UserSuppliedInfo.EventSpanDates EQ 1>
						<uform:field label="Second Event Date" name="EventDate1" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate1, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Second Date if event has multiple dates." />
						<uform:field label="Third Event Date" name="EventDate2" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate2, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Third Date if event has multiple dates." />
						<uform:field label="Fourth Event Date" name="EventDate3" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate3, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fourth Date if event has multiple dates." />
						<uform:field label="Fifth Event Date" name="EventDate4" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.EventDate4, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Date of Event, Fifth Date if event has multiple dates." />
					</cfif>
					<uform:field label="Registration Deadline" name="Registration_Deadline" isDisabled="true" value="#DateFormat(Session.UserSuppliedInfo.Registration_Deadline, 'mm/dd/yyyy')#" type="text" inputClass="date" hint="Accept Registration up to this date" />
					<uform:field label="Registration Start Time" name="Registration_BeginTime" isDisabled="true" value="#TimeFormat(Session.UserSuppliedInfo.Registration_BeginTime, 'hh:mm tt')#" type="text" pluginSetup="#timeConfig#" hint="The Beginning Time onSite Registration begins" />
					<uform:field label="Event Start Time" name="Event_StartTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.Event_StartTime, 'hh:mm tt')#" pluginSetup="#timeConfig#" hint="The starting time of this event" />
					<uform:field label="Event End Time" name="Event_EndTime" isDisabled="true" type="text" value="#TimeFormat(Session.UserSuppliedInfo.Event_EndTime, 'hh:mm tt')#" pluginSetup="#timeConfig#" hint="The ending time of this event" />
				</uForm:fieldset>
				<uForm:fieldset legend="Event Description">
					<uform:field label="Event Short Title" name="ShortTitle" isDisabled="true" value="#Session.UserSuppliedInfo.ShortTitle#" maxFieldLength="50" type="text" hint="Short Event Title of Event" />
					<uform:field label="Event Description" name="LongDescription" isDisabled="true" value="#Session.UserSuppliedInfo.LongDescription#" type="textarea" hint="Description of this meeting or event" />
				</uForm:fieldset>
				<uForm:fieldset legend="Message to Participants">
					<uform:field label="Email Body Message" name="EmailMsg" isDisabled="false" type="textarea" hint="The Email Message Body for Participants" />
					<uform:field label="Include File Links" name="IncludeFileLinks" type="select" hint="Include Links to Event Documents in Email Message?">
						<uform:option display="Yes" value="1" isSelected="true" />
						<uform:option display="No" value="0" />
					</uform:field>
				</uForm:fieldset>
				<uForm:fieldset legend="Participant Materials">
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameSix)>
						<input type="Hidden" Name="FirstDocumentToSend" Value="">
						<uform:field label="First Document" name="FirstDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameSix#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="First Document" name="FirstDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameSix#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameSeven)>
						<input type="Hidden" Name="SecondDocumentToSend" Value="">
						<uform:field label="Second Document, if needed" name="SecondDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameSeven#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Second Document, if needed" name="SecondDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameSeven#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameEight)>
						<input type="Hidden" Name="ThirdDocumentToSend" Value="">
						<uform:field label="Third Document, if needed" name="ThirdDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameEight#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Third Document, if needed" name="ThirdDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameEight#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameNine)>
						<input type="Hidden" Name="FourthDocumentToSend" Value="">
						<uform:field label="Fourth Document, if needed" name="FourthDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameNine#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Fourth Document, if needed" name="FourthDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameNine#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameTen)>
						<input type="Hidden" Name="FifthDocumentToSend" Value="">
						<uform:field label="Fifth Document, if needed" name="FifthDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameTen#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Fifth Document, if needed" name="FifthDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameTen#" />
					</cfif>
				</uForm:fieldset>
				<cfif Session.EventNumberAttended GT 0>
					<uForm:fieldset legend="Send Email?">
						<uform:field label="Send Email Message" name="SendEmail" isDisabled="false" type="select" hint="Are you ready to send this email to participants?">
							<uform:option display="Yes, Send It" value="True" isSelected="true" />
							<uform:option display="No, Do not Send" value="False" />
						</uform:field>
					</uForm:fieldset>
				<cfelse>
					<input type="Hidden" Name="SendEMail" Value="False">
					<input type="Hidden" Name="EmailMsg" Value=" ">
				</cfif>
			</uForm:form>
		</div>
	</div>
</cfoutput>