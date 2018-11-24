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
			<h3 class="t">Sending an Email to Workshop/Event Registered Participants:<br>#DateFormat(Session.UserSuppliedInfo.EventDate, 'mm/dd/yyyy')# - #Session.UserSuppliedInfo.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">Please complete this form to send a message to those who have registered for this event.<br><Strong>Number of Registrations Currently: #Session.EventNumberRegistrations#</Strong></div>
			<hr>
			<uForm:form action="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailregistered&compactDisplay=false&EventID=#URL.EventID#&EventStatus=EmailParticipants" method="Post" id="EmailEventParticipants" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
				submitValue="Email Event Participants" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="PerformAction" value="CancelEvent">
				<uForm:fieldset legend="Message to Participants">
					<uform:field label="Email Body Message" name="EmailMsg" isDisabled="false" type="textarea" hint="The Email Message Body for Participants" />
					<uform:field label="Include File Links" name="IncludeFileLinks" type="select" hint="Include Links to Event Documents in Email Message?">
						<uform:option display="Yes" value="1" />
						<uform:option display="No" value="0" isSelected="true" />
					</uform:field>
				</uForm:fieldset>
				<uForm:fieldset legend="Participant Web Links">
					<uform:field label="First Website Link" name="FirstWebLink" type="text" />
					<uform:field label="Second Website Link" name="SecondWebLink" type="text" />
				</uForm:fieldset>
				<uForm:fieldset legend="Participant Materials">
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameOne)>
						<input type="Hidden" Name="FirstDocumentToSend" Value="">
						<uform:field label="First Document" name="FirstDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameOne#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="First Document" name="FirstDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameOne#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameTwo)>
						<input type="Hidden" Name="SecondDocumentToSend" Value="">
						<uform:field label="Second Document, if needed" name="SecondDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameTwo#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Second Document, if needed" name="SecondDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameTwo#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameThree)>
						<input type="Hidden" Name="ThirdDocumentToSend" Value="">
						<uform:field label="Third Document, if needed" name="ThirdDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameThree#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Third Document, if needed" name="ThirdDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameThree#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameFour)>
						<input type="Hidden" Name="FourthDocumentToSend" Value="">
						<uform:field label="Fourth Document, if needed" name="FourthDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameFour#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Fourth Document, if needed" name="FourthDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameFour#" />
					</cfif>
					<cfif LEN(Session.UserSuppliedInfo.EventDoc_FileNameFive)>
						<input type="Hidden" Name="FifthDocumentToSend" Value="">
						<uform:field label="Fifth Document, if needed" name="FifthDocument" value="#Session.UserSuppliedInfo.EventDoc_FileNameFifth#" type="text" isDisabled="true" />
					<cfelse>
						<uform:field label="Fifth Document, if needed" name="FifthDocumentToSend" type="file" value="#Session.UserSuppliedInfo.EventDoc_FileNameFive#" />
					</cfif>
				</uForm:fieldset>
				<cfif Session.EventNumberRegistrations GT 0>
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