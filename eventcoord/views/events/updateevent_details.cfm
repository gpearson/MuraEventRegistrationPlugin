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
			<h3 class="t">Updating Workshop/Event: #Session.UserSuppliedInfo.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<p class="alert-box notice">Please make changes to the information listed below so this event displays accurate information.</p>
			<hr>
			<uForm:form action="" method="Post" id="UpdateEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
				submitValue="Update Event" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="PerformAction" value="UpdateEvent">
				<uForm:fieldset legend="Event Details">
					<uform:field label="Event Agenda" name="EventAgenda" type="textarea" value="#Session.UserSuppliedInfo.EventAgenda#" hint="The Agenda if avaialble for this event." />
					<uform:field label="Event Target Audience" name="EventTargetAudience" type="textarea" value="#Session.UserSuppliedInfo.EventTargetAudience#" hint="The Target Audience for this event. Who should come to this event" />
					<uform:field label="Event Strategies" name="EventStrategies" type="textarea" value="#Session.UserSuppliedInfo.EventStrategies#" hint="The Strategies of this event, if any." />
					<uform:field label="Event Special Instructions" name="EventSpecialInstructions" type="textarea" value="#Session.UserSuppliedInfo.EventSpecialInstructions#" hint="If available, any special instructions participants need." />
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>