<cfif not isDefined("URL.PerformAction") and not isDefined("URL.EventRegistrationaction")>
	<cflocation addtoken="true" url="/index.cfm">
<cfelseif isDefined("URL.PerformAction")>
	<cfquery name="getSchoolDistricts" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select OrganizationName, StateDOE_IDNumber
		From eMembership
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
		Order by OrganizationName
	</cfquery>

	<cfswitch expression="#URL.PerformAction#">
		<cfcase value="AddUser">
			<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
			<cfset GetAllUserGroups = #$.getBean( 'userManager' ).getUserGroups( rc.$.siteConfig('siteID'), 1 )#>
			<cfoutput>
				<uForm:form action="" method="Post" id="AddUserAccount" errors="#Session.FormErrors#" errorMessagePlacement="both"
					commonassetsPath="/plugins/EventRegistration/library/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
					cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users&compactDisplay=false"
					submitValue="Add Account" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
					<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
					<input type="hidden" name="formSubmit" value="true">
					<uForm:fieldset legend="Required Fields">
						<uForm:field label="First Name" name="Fname" isRequired="true" maxFieldLength="50" type="text" hint="User's First Name" />
						<uForm:field label="Last Name" name="Lname" isRequired="true" maxFieldLength="50" type="text" hint="User's Last Name" />
						<uForm:field label="Username" name="UserName" isRequired="true" maxFieldLength="50" type="text" hint="User's Login Username" />
						<uForm:field label="Email Address" name="Email" isRequired="true" maxFieldLength="50" type="text" hint="User's Email Address" />
					</uForm:fieldset>
					<uForm:fieldset legend="Optional Fields">
						<uform:field label="School District" name="Company" type="select" hint="School District employeed at?">
							<uform:option display="Corporate Business" value="0000" isSelected="true" />
							<uform:option display="School District Not Listed" value="0001"  />
							<cfloop query="getSchoolDistricts">
								<uform:option display="#getSchoolDistricts.OrganizationName#" value="#getSchoolDistricts.StateDOE_IDNumber#" />
							</cfloop>
						</uform:field>
						<uForm:field label="Job Title" name="JobTitle" type="text" maxFieldLength="50" hint="User's Job Title" />
						<uForm:field label="Mobile Phone Number" name="mobilePhone" type="text" maxFieldLength="14" mask="(999) 999-9999" hint="User's Contact Number in case of calcellation of event" />
					</uForm:fieldset>
					<uForm:fieldset legend="Account Membership">
						<uForm:field name="Memberships" type="checkboxgroup">
							<cfloop query="GetAllUserGroups">
								<uForm:checkbox label="#GetAllUserGroups.GroupName#" value="#GetAllUserGroups.UserID#" />
							</cfloop>
						</uForm:field>
					</uForm:fieldset>
					<uForm:fieldset legend="Informational Fields">
						<uForm:field label="Last Login" name="LastLogin" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="User's Last Login Date" />
						<uForm:field label="Last Update" name="LastUpdate" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="User's Last Account Update Date" />
						<uForm:field label="Last Update By" name="LastUpdateBy" type="text" isDisabled="true" value="#Session.Mura.Username#" hint="User's Last Account Last Update By" />
						<uForm:field label="Account Created" name="created" type="text" isDisabled="true" value="#DateFormat(Now(), 'FULL')#" hint="User's Account Created Date" />
					</uForm:fieldset>
				</uForm:form>
			</cfoutput>
		</cfcase>
	</cfswitch>
</cfif>