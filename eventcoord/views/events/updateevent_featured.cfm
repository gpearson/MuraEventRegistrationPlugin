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

<cfoutput>
	<script>
		$(function() {
			$("##Featured_StartDate").datepicker();
			$("##Featured_EndDate").datepicker();
		});
	</script>
	<h2>Updating Workshop/Event: #Session.UserSuppliedInfo.ShortTitle#</h2>
	<p class="alert-box notice">Please make changes to the information listed below so this event displays accurate information.</p>
	<hr>
	<uForm:form action="" method="Post" id="UpdateEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
		commonassetsPath="/properties/uniForm/"
		showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
		cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events&compactDisplay=false"
		submitValue="Update Event" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
		<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
		<input type="hidden" name="formSubmit" value="true">
		<input type="hidden" name="PerformAction" value="UpdateEvent">
		<uForm:fieldset legend="Event Featured">
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
			<cfif isDefined("Session.UserSuppliedInfo.Featured_StartDate")>
				<uform:field label="Start Date" name="Featured_StartDate" isRequired="true" value="#Session.UserSuppliedInfo.Featured_StartDate#" type="date" inputClass="date" hint="The start date of this event being featured" />
			<cfelse>
				<uform:field label="Start Date" name="Featured_StartDate" isRequired="true" type="date" inputClass="date" hint="The start date of this event being featured" />
			</cfif>
			<cfif isDefined("Session.UserSuppliedInfo.Featured_EndDate")>
				<uform:field label="End Date" name="Featured_EndDate" isRequired="true" type="date" value="#Session.UserSuppliedInfo.Featured_EndDate#" inputClass="date" hint="The ending date of this event being featured" />
			<cfelse>
				<uform:field label="End Date" name="Featured_EndDate" isRequired="true" type="date" inputClass="date" hint="The ending date of this event being featured" />
			</cfif>
			<cfif isDefined("Session.UserSuppliedInfo.Featured_SortOrder")>
				<uform:field label="Sort Order" name="Featured_SortOrder" isRequired="true" maxFieldLength="3" value="#Session.UserSuppliedInfo.Featured_SortOrder#" type="text" hint="The Sort Order of this featured event. Lower the number higher in the listing" />
			<cfelse>
				<uform:field label="Sort Order" name="Featured_SortOrder" isRequired="true" maxFieldLength="3" value="100" type="text" hint="The Sort Order of this featured event. Lower the number higher in the listing" />
			</cfif>
		</uForm:fieldset>
	</uForm:form>
</cfoutput>