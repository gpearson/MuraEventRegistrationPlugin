<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfif not isDefined("URL.OrgID")><cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:membership&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false"></cfif>
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfset Session.FormErrors = #ArrayNew()#>
	<cfif not isDefined("Session.UserSuppliedInfo.MemberOrganization")><cfset Session.UserSuppliedInfo.MemberOrganization = #StructNew()#></cfif>
</cflock>

<cfoutput>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Remove District from Active Membership Status</h3>
		</div>
		<div class="art-blockcontent">
			<p class="alert-box notice">Please submit this form to deactivate this organization so anyone with the organization's email address will no longer receive membership pricing.</p>
			<hr>
			<uForm:form action="" method="Post" id="DeActivateOrganization" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:membership&compactDisplay=false"
				submitValue="DeActivate Organization" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="OrgID" value="#URL.OrgID#">
				<input type="hidden" name="PerformAction" value="DeActivateOrganization">
				<uForm:fieldset legend="Organization Information">
					<cfif isDefined("Session.UserSuppliedInfo.MemberOrganization.OrganizationName")>
						<uform:field label="Organization Name" name="OrganizationName" isDisabled="true" value="#Session.UserSuppliedInfo.MemberOrganization.OrganizationName#" maxFieldLength="50" type="text" hint="Member Organization Name" />
					<cfelse>
						<uform:field label="Organization Name" name="OrganizationName" isDisabled="true" maxFieldLength="50" type="text" hint="Member Organization Name" />
					</cfif>

					<cfif isDefined("Session.UserSuppliedInfo.MemberOrganization.OrganizationDomainName")>
						<uform:field label="Organization Domain Name" name="OrganizationDomainName" isDisabled="true" value="#Session.UserSuppliedInfo.MemberOrganization.OrganizationDomainName#" maxFieldLength="50" type="text" hint="What is the Domain Name of the Organization, What is listed after the @ in a member's email address?" />
					<cfelse>
						<uform:field label="Organization Domain Name" name="OrganizationDomainName" isDisabled="true" maxFieldLength="50" type="text" hint="What is the Domain Name of the Organization, What is listed after the @ in a member's email address?" />
					</cfif>
					<cfif Session.UserSuppliedInfo.MemberOrganization.Active EQ 1><cfset ActiveText = "Yes"><cfelse><cfset ActiveText = "No"></cfif>
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>
