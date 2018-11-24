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
			$("##EarlyBird_RegistrationDeadline").datepicker();
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
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
				submitValue="Update Event" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="PerformAction" value="UpdateEvent">
				<uForm:fieldset legend="Event Early Bird Information">
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
					<cfif isDefined("Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline")>
						<uform:field label="Registration Deadline" name="EarlyBird_RegistrationDeadline" isRequired="true" value="#Session.UserSuppliedInfo.EarlyBird_RegistrationDeadline#" type="date" inputClass="date" hint="The cutoff date for Early Bird Registrations" />
					<cfelse>
						<uform:field label="Registration Deadline" name="EarlyBird_RegistrationDeadline" isRequired="true" type="date" inputClass="date" hint="The cutoff date for Early Bird Registrations" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.EarlyBird_MemberCost")>
						<uform:field label="Member Pricing" name="EarlyBird_MemberCost" isRequired="true" type="text" Value="#NumberFormat(Session.UserSuppliedInfo.EarlyBird_MemberCost, '9999.99')#" hint="The Early Bird Pricing for Member School Districts" />
					<cfelse>
						<uform:field label="Member Pricing" name="EarlyBird_MemberCost" isRequired="true" type="text" Value="#NumberFormat('50.00', '9999.99')#" hint="The Early Bird Pricing for Member School Districts" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.EarlyBird_NonMemberCost")>
						<uform:field label="NonMember Pricing" name="EarlyBird_NonMemberCost" isRequired="true" type="text" Value="#NumberFormat(Session.UserSuppliedInfo.EarlyBird_NonMemberCost, '9999.99')#" hint="The Early Bird Pricing for NonMember School Districts" />
					<cfelse>
						<uform:field label="NonMember Pricing" name="EarlyBird_NonMemberCost" isRequired="true" type="text" Value="#NumberFormat('100.00', '9999.99')#" hint="The Early Bird Pricing for NonMember School Districts" />
					</cfif>
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>