<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>
<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
</cflock>
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cfoutput>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Sending an Email to Attended Participants with Professional Growth Point Certificates:<br>#DateFormat(Session.UserSuppliedInfo.PickedEvent.EventDate, 'mm/dd/yyyy')# - #Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">Please complete this form to send out the Professional Growth Points to those who attended this event.<br><Strong>Number of Registered Participants: #Session.EventNumberRegistrations#</Strong><br><strong>Number of PGP Certificates to Send: #Session.EventNumberPGPCertificataes#</strong></div>
			<hr>
			<uForm:form action="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events.sendpgpcertificates&compactDisplay=false&EventID=#URL.EventID#" method="Post" id="EmailEventParticipants" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
				submitValue="Email PGP Certificates" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="PerformAction" value="SendEmail">
				<uForm:fieldset legend="Message to Participants">
					<uform:field label="Email Body Message" isRequired="true" name="EmailMsg" isDisabled="false" type="textarea" hint="The Email Message Body for Participants" />
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>