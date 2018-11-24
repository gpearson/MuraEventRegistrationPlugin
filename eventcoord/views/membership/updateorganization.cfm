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
	<cfset Session.FormErrors = #ArrayNew()#>
	<cfif not isDefined("Session.UserSuppliedInfo")><cfset Session.UserSuppliedInfo = #StructNew()#></cfif>
</cflock>

<cfoutput>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Update District Information</h3>
		</div>
		<div class="art-blockcontent">
			<p class="alert-box notice">Please complete the following information to update an existing organization within the registration system.</p>
			<hr>
			<uForm:form action="" method="Post" id="UpdateOrganization" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership&compactDisplay=false"
				submitValue="Update Organization" loadValidation="true" loadMaskUI="true" loadDateUI="true"
				loadTimeUI="true">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="OrgID" value="#URL.OrgID#">
				<input type="hidden" name="PerformAction" value="UpdateOrganization">
				<uForm:fieldset legend="Organization Information">
					<cfif isDefined("Session.UserSuppliedInfo.MemberOrganization.OrganizationName")>
						<uform:field label="Organization Name" name="OrganizationName" isRequired="true" value="#Session.UserSuppliedInfo.MemberOrganization.OrganizationName#" maxFieldLength="50" type="text" hint="Member Organization Name" />
					<cfelse>
						<uform:field label="Organization Name" name="OrganizationName" isRequired="true" maxFieldLength="50" type="text" hint="Member Organization Name" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.MemberOrganization.OrganizationDomainName")>
						<uform:field label="Organization Domain Name" name="OrganizationDomainName" isRequired="true" value="#Session.UserSuppliedInfo.MemberOrganization.OrganizationDomainName#" maxFieldLength="50" type="text" hint="What is the Domain Name of the Organization, What is listed after the @ in a member's email address?" />
					<cfelse>
						<uform:field label="Organization Domain Name" name="OrganizationDomainName" isRequired="true" maxFieldLength="50" type="text" hint="What is the Domain Name of the Organization, What is listed after the @ in a member's email address?" />
					</cfif>
					<cfif isDefined("Session.UserSuppliedInfo.MemberOrganization.StateDOE_IDNumber")>
						<uform:field label="State Department of Education ID Number" name="StateDOE_IDNumber" isRequired="true" value="#Session.UserSuppliedInfo.MemberOrganization.StateDOE_IDNumber#" maxFieldLength="5" type="text" hint="What is the State Department of Education ID Number for the School District?" />
					<cfelse>
						<uform:field label="State Department of Education ID Number" name="StateDOE_IDNumber" isRequired="true" maxFieldLength="5" type="text" hint="What is the State Department of Education ID Number for the School District?" />
					</cfif>
					<uform:field label="Active" name="Active" type="select" hint="Is Membership Active for this Organization?">
						<cfif Session.UserSuppliedInfo.MemberOrganization.Active EQ 1>
							<uform:option display="Yes" value="1" isSelected="true" />
							<uform:option display="No" value="0" />
						<cfelse>
							<uform:option display="Yes" value="1" />
							<uform:option display="No" value="0" isSelected="true" />
						</cfif>
					</uform:field>
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>
