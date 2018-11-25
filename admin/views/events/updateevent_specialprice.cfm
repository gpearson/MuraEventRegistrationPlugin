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
			<h3 class="t">Add New Caterer</h3>
		</div>
		<div class="art-blockcontent">
			<p class="alert-box notice">Please make changes to the information listed below so this event displays accurate information.</p>
			<hr>
			<uForm:form action="" method="Post" id="UpdateEvent" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
				submitValue="Update Event" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="PerformAction" value="UpdateEvent">
				<uForm:fieldset legend="Event Special Price">
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
					<cfif isDefined("Session.UserSuppliedInfo.SpecialPriceRequirements")>
						<uform:field label="Requirements" name="SpecialPriceRequirements" isRequired="true" type="textarea" value="#Session.UserSuppliedInfo.SpecialPriceRequirements#" hint="The requirements a participant must meet to get this price for this event" />
					<cfelse>
						<uform:field label="Requirements" name="SpecialPriceRequirements" isRequired="true" type="textarea" hint="The requirements a participant must meet to get this price for this event" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.SpecialMemberCost")>
						<uform:field label="Member Pricing" name="SpecialMemberCost" isRequired="true" type="text" Value="#NumberFormat(Session.UserSuppliedInfo.SpecialMemberCost, '9999.99')#" hint="The Special Price for this event from a Member School Districts" />
					<cfelse>
						<uform:field label="Member Pricing" name="SpecialMemberCost" isRequired="true" type="text" Value="#NumberFormat('0.00', '9999.99')#" hint="The Special Price for this event from a Member School Districts" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.SpecialNonMemberCost")>
						<uform:field label="NonMember Pricing" name="SpecialNonMemberCost" isRequired="true" type="text" Value="#NumberFormat(Session.UserSuppliedInfo.SpecialNonMemberCost, '9999.99')#" hint="The Special Price for this event from a NonMember School Districts" />
					<cfelse>
						<uform:field label="NonMember Pricing" name="SpecialNonMemberCost" isRequired="true" type="text" Value="#NumberFormat('0.00', '9999.99')#" hint="The Special Price for this event from a NonMember School Districts" />
					</cfif>
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>