<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cfif not isDefined("Session.FormData")>
	<cflock scope="Session" timeout="60" type="Exclusive">
		<cfset Session.FormData = #StructNew()#>
	</cflock>
</cfif>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfquery name="getSchoolDistricts" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select OrganizationName, StateDOE_IDNumber
			From eMembership
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			Order by OrganizationName
		</cfquery>
		<cfquery name="getAccountDetails" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select JobTitle, mobilePhone
			From tusers
			Where UserID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<div class="art-blockheader">
			<h3 class="t">Update Account Profile</h3>
		</div>
		<p class="alert-box notice">Please complete the following information to update your account profile.</p>
		<hr>
		<uForm:form action="" method="Post" id="EditProfile" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/plugins/EventRegistration/library/uniForm/"
			showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm"
			submitValue="Update Profile" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
			<input type="hidden" name="formSubmit" value="true">
			<input type="hidden" name="UserID" value="#Session.Mura.UserID#">
			<uForm:fieldset legend="Required Fields">
				<uForm:field label="Account First Name" name="Fname" value="#Session.Mura.Fname#" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The First Name of the Account Holder" />
				<uForm:field label="Account Last Name" name="Lname" value="#Session.Mura.Lname#" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The Last Name of the Account Holder" />
				<uForm:field label="Account Email" name="Email" value="#Session.Mura.Email#" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The Email Address of the Account Holder" />
				<uForm:field label="Account Username" name="Username" value="#Session.Mura.Username#" isRequired="False" isDisabled="True" maxFieldLength="50" type="text" hint="The Username of the Account Holder" />
			</uForm:fieldset>
			<uForm:fieldset legend="Optional Fields">
				<uform:field label="School District" name="Company" type="select" hint="School District employeed at?">
					<cfif Session.Mura.Company EQ "Corporate Business">
						<uform:option display="Corporate Business" value="0000" isSelected="true" />
					<cfelse>
						<uform:option display="Corporate Business" value="0000" />
					</cfif>
					<cfif Session.Mura.Company EQ "School District Not Listed">
						<uform:option display="School District Not Listed" value="0001" isSelected="true"  />
					<cfelse>
						<uform:option display="School District Not Listed" value="0001"  />
					</cfif>

					<cfloop query="getSchoolDistricts">
						<cfif Session.Mura.Company EQ getSchoolDistricts.OrganizationName>
							<uform:option display="#getSchoolDistricts.OrganizationName#" value="#getSchoolDistricts.StateDOE_IDNumber#" isSelected="true" />
						<cfelse>
							<uform:option display="#getSchoolDistricts.OrganizationName#" value="#getSchoolDistricts.StateDOE_IDNumber#" />
						</cfif>
					</cfloop>
				</uform:field>
				<uForm:field label="Job Title" name="JobTitle" type="text" value="#getAccountDetails.JobTitle#" isRequired="False" isDisabled="False" maxFieldLength="50" hint="Your current Job Title" />
				<uForm:field label="Phone Number" name="mobilePhone" type="text" value="#getAccountDetails.mobilePhone#" maxFieldLength="14" isRequired="False" isDisabled="False" mask="(999) 999-9999" hint="Your contact number in case of cancellation of event during extreme sitations" />
				<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
			</uForm:fieldset>
		</uForm:form>
	<cfelseif isDefined("URL.FormRetry")>
		<cfquery name="getSchoolDistricts" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select OrganizationName, StateDOE_IDNumber
			From eMembership
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			Order by OrganizationName
		</cfquery>
		<cfquery name="getAccountDetails" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select JobTitle, mobilePhone
			From tusers
			Where UserID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<div class="art-blockheader">
			<h3 class="t">Update Account Password</h3>
		</div>
		<p class="alert-box notice">Please complete the following information to update your account profile.</p>
		<hr>
		<uForm:form action="" method="Post" id="EditProfile" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/plugins/EventRegistration/library/uniForm/"
			showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm"
			submitValue="Update Profile" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
			<input type="hidden" name="formSubmit" value="true">
			<input type="hidden" name="UserID" value="#Session.Mura.UserID#">
			<uForm:fieldset legend="Required Fields">
				<uForm:field label="Account First Name" name="Fname" value="#Session.FormData.Fname#" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The First Name of the Account Holder" />
				<uForm:field label="Account Last Name" name="Lname" value="#Session.FormData.Lname#" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The Last Name of the Account Holder" />
				<uForm:field label="Account Email" name="Email" value="#Session.FormData.Email#" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The Email Address of the Account Holder" />
				<uForm:field label="Account Username" name="Username" value="#Session.Mura.Username#" isRequired="False" isDisabled="True" maxFieldLength="50" type="text" hint="The Username of the Account Holder" />
			</uForm:fieldset>
			<uForm:fieldset legend="Optional Fields">
				<uform:field label="School District" name="Company" type="select" hint="School District employeed at?">
					<cfif Session.FormData.Company EQ "Corporate Business">
						<uform:option display="Corporate Business" value="0000" isSelected="true" />
					<cfelse>
						<uform:option display="Corporate Business" value="0000" />
					</cfif>
					<cfif Session.FormData.Company EQ "School District Not Listed">
						<uform:option display="School District Not Listed" value="0001" isSelected="true"  />
					<cfelse>
						<uform:option display="School District Not Listed" value="0001"  />
					</cfif>

					<cfloop query="getSchoolDistricts">
						<cfif Session.FormData.Company EQ getSchoolDistricts.OrganizationName>
							<uform:option display="#getSchoolDistricts.OrganizationName#" value="#getSchoolDistricts.StateDOE_IDNumber#" isSelected="true" />
						<cfelse>
							<uform:option display="#getSchoolDistricts.OrganizationName#" value="#getSchoolDistricts.StateDOE_IDNumber#" />
						</cfif>
					</cfloop>
				</uform:field>
				<uForm:field label="Job Title" name="JobTitle" type="text" value="#Session.FormData.JobTitle#" isRequired="False" isDisabled="False" maxFieldLength="50" hint="Your current Job Title" />
				<uForm:field label="Phone Number" name="mobilePhone" type="text" value="#Session.FormData.mobilePhone#" maxFieldLength="14" isRequired="False" isDisabled="False" mask="(999) 999-9999" hint="Your contact number in case of cancellation of event during extreme sitations" />
				<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
			</uForm:fieldset>
		</uForm:form>
	</cfif>
</cfoutput>