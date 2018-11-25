<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfset PriorDate = #DateAdd("m", -2, Now())#>
<cfquery name="getMembershipOrganizations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select TContent_ID, Site_ID, OrganizationName, OrganizationDomainName, Active
	From eMembership
	Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
	Order by Active DESC, OrganizationName ASC
</cfquery>
<cfif isDefined("URL.Successful")>
	<cfswitch expression="#URL.Successful#">
		<cfcase value="true">
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="AddedOrganization">
						<cfoutput>
							<div class="alert-box success">
								<p>You have successfully added a new member organization to the system.</p>
							</div>
						</cfoutput>
					</cfcase>
					<cfcase value="DeactivatedOrganization">
						<div class="alert-box success">
							<p>You have successfully deactivated the organization from receiving membership pricing.</p>
						</div>
					</cfcase>
					<cfcase value="ActivatedOrganization">
						<div class="alert-box success">
							<p>You have successfully activated the organization so they can receive membership pricing.</p>
						</div>
					</cfcase>
					<cfcase value="UpdatedOrganization">
						<div class="alert-box success">
							<p>You have successfully updated the organization witin the registration system.</p>
						</div>
					</cfcase>
				</cfswitch>
			</cfif>
		</cfcase>
	</cfswitch>

</cfif>
<cfoutput>
	<div class="art-block clearfix">
		<div class="art-blockheader">
			<h3 class="t">Membership Districts</h3>
		</div>
		<div class="art-blockcontent">
			<table class="art-article" style="width:100%;">
				<thead>
					<tr>
						<th width="40%">Organization Name</th>
						<th width="15%">Domain Name</th>
						<th width="15%">Active Member</th>
						<th>Actions</th>
					</tr>
				</thead>
				<cfif getMembershipOrganizations.RecordCount>
					<tfoot>
						<tr>
							<td colspan="4">Add new Membership Organization not listed above by clicking <a href="#buildURL('admin:membership.addorganization')#" class="art-button">here</a></td>
						</tr>
					</tfoot>
					<tbody>
						<cfloop query="getMembershipOrganizations">
							<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
							<td>#getMembershipOrganizations.OrganizationName#</td>
							<td>#getMembershipOrganizations.OrganizationDomainName#</td>
							<td><cfif getMembershipOrganizations.Active EQ 1>Yes<cfelse>No</cfif></td>
							<td><a href="#buildURL('admin:membership.updateorganization')#&OrgID=#getMembershipOrganizations.TContent_ID#"><img src="/plugins/#variables.framework.package#/includes/assets/images/adminactions/imgUpdate.png" alt="Update Organization"></a><cfif getMembershipOrganizations.Active EQ 1><a href="#buildURL('admin:membership.updateorganization_deactivate')#&OrgID=#getMembershipOrganizations.TContent_ID#"><img src="/plugins/#variables.framework.package#/includes/assets/images/adminactions/imgDeActivate.png" alt="Deactivate Organization"></a><cfelse><a href="#buildURL('admin:membership.updateorganization_activate')#&OrgID=#getMembershipOrganizations.TContent_ID#"><img src="/plugins/#variables.framework.package#/includes/assets/images/adminactions/imgActivate.png" alt="Activate Organization"></a></cfif></td>
							</tr>
						</cfloop>
					</tbody>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="6"><div align="center" class="alert-box notice">No Member Organizations were located in the database. To add a member organization to the system click <a href="#buildURL('admin:membership.addorganization')#" class="art-button">here</a></div></td>
						</tr>
					</tbody>
				</cfif>
			</table>
		</div>
	</div>
</cfoutput>