<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cfoutput>
	<cfset UserEmailDomain = #Right(Session.getRegistrations.EMail, Len(Session.getRegistrations.Email) - Find("@", Session.getRegistrations.Email))#>
	<cfquery name="getUserMembership" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		SELECT OrganizationName, OrganizationDomainName, Active
		From eMembership
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
			OrganizationDomainName = <cfqueryparam value="#Variables.UserEmailDomain#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfif getUserMembership.Active IS 1>
		<cfset ActiveMembership = "Yes">
	<cfelse>
		<cfset ActiveMembership = "No">
	</cfif>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Update Participant's Cost to attend: #Session.getSelectedEvent.ShortTitle#</h3>
		</div>
		<div class="art-blockcontent">
			<div class="alert-box notice">Please complete the following information to update participant's cost to attend event or workshop.</div>
			<hr>
			<uForm:form action="" method="Post" id="AddEventExpenses" errors="#Session.FormErrors#" errorMessagePlacement="both"
				commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
				cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:events&compactDisplay=false"
				submitValue="Update Participant Cost to Attend" loadValidation="true" loadMaskUI="true" loadDateUI="false"
				loadTimeUI="false">
				<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="EventID" value="#URL.EventID#">
				<input type="hidden" name="RegistrationID" value="#URL.RegistrationID#">
				<uForm:fieldset legend="Participant's Information">
					<uform:field label="Participant Name" name="ParticipantName" id="ParticipantName" isDisabled="true" type="text" value="#Session.getRegistrations.FName# #Session.getRegistrations.LName#" hint="Name of Participant" />
					<uform:field label="School District" name="ParticipantDistrict" id="ParticipantDistrict" isDisabled="true" type="text" value="#getUserMembership.OrganizationName#" hint="School District" />
					<uform:field label="Active Membership" name="DistrictActiveMembership" id="DistrictActiveMembership" isDisabled="true" type="text" value="#Variables.ActiveMembership#" hint="School District Active Membership" />
				</uForm:fieldset>
				<uForm:fieldset legend="Participant's New Cost">
					<uform:field label="New Cost to Attend" name="ParticipantCost" type="text" value="#NumberFormat(Session.getRegistrations.AttendeePrice, '9999.99')#" hint="The new amount to charge the participant who attended this event. Just enter Dollars and Cents Only" />
				</uForm:fieldset>
			</uForm:form>
		</div>
	</div>
</cfoutput>