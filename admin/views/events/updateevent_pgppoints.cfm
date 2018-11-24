<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>
<cfimport taglib="/properties/uniForm/tags/" prefix="uForm">
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
	<h2>Updating Workshop/Event: #Session.UserSuppliedInfo.ShortTitle#</h2>
	<p class="alert-box notice">Please make changes to the information listed below so this event displays accurate information.</p>
	<hr>
	<uForm:form action="" method="Post" id="UpdateEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
		commonassetsPath="/properties/uniForm/"
		showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
		cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
		submitValue="Update Event" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
		<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
		<input type="hidden" name="formSubmit" value="true">
		<input type="hidden" name="PerformAction" value="UpdateEvent">
		<uForm:fieldset legend="Event Professional Growth Points">
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
			<cfif isDefined("Session.UserSuppliedInfo.PGPPoints")>
				<uform:field label="Number of Points" name="PGPPoints" isRequired="true" type="text" Value="#NumberFormat(Session.UserSuppliedInfo.PGPPoints, '999.99')#" hint="The number of PGP Points available to particiapnt upon sucessfull completion of this event." />
			<cfelse>
				<uform:field label="Number of Points" name="PGPPoints" isRequired="true" type="text" Value="#NumberFormat('0.00', '999.99')#" hint="The number of PGP Points available to particiapnt upon sucessfull completion of this event." />
			</cfif>
		</uForm:fieldset>
	</uForm:form>
</cfoutput>