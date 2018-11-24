<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cfif not isDefined("URL.UserRegistrationSuccessfull")>
	<cflock timeout="60" scope="SESSION" type="Exclusive">
		<cfset Session.FormData = #StructNew()#>
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.UserRegistrationInfo = #StructNew()#>
	</cflock>
	<cfquery name="getSchoolDistricts" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select OrganizationName, StateDOE_IDNumber
		From eMembership
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
		Order by OrganizationName
	</cfquery>

	<cfoutput>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Register New User Account</h3>
			</div>
			<div class="art-blockcontent"><p class="alert-box notice">Please complete the following information to register for a user account on this event registration system. All electric communications from this system will be sent to the email address you provide. Any certificates that will be generated upon successfull completion of an event that issues certificates will use the information on this screen. Please make sure the information listed below is correct.</p>
				<hr>
				<uForm:form action="" method="Post" id="RegisterUser" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/plugins/EventRegistration/library/uniForm/"
					showCancel="no" cancelValue="<--- Return to Available Events" cancelName="cancelButton" cancelAction="/index.cfm"
					submitValue="Create User Account" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
						<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
						<input type="hidden" name="InActive" valule="1">
						<input type="hidden" name="formSubmit" value="true">
					<uForm:fieldset legend="User Account Fields">
						<uForm:field label="Your First Name" name="fName" isRequired="true" isDisabled="false" maxFieldLength="50" type="text" hint="Your First Name as you would like printed on certificates" />
						<uForm:field label="Your Last Name" name="lName" isRequired="true" isDisabled="false" maxFieldLength="50" type="text" hint="Your Last Name as you would like printed on certificates" />
						<uForm:field label="Your Email Address" name="UserName" isRequired="true" isDisabled="false" maxFieldLength="50" type="text" hint="Your Primary Email Address" />
						<uForm:field label="Your Desired Password" name="Password" isRequired="true" isDisabled="false" maxFieldLength="50" type="password" hint="The Password for this site" />
						<uForm:field label="Confirm Desired Password" name="VerifyPassword" isRequired="true" isDisabled="false" maxFieldLength="50" type="password" hint="Confirm Password for Site" />
					</uForm:fieldset>
					<uForm:fieldset legend="Optional Fields">
						<uform:field label="School District" name="Company" type="select" hint="School District employeed at?">
							<uform:option display="Corporate Business" value="0000" isSelected="true" />
							<uform:option display="School District Not Listed" value="0001"  />
							<cfloop query="getSchoolDistricts">
								<uform:option display="#getSchoolDistricts.OrganizationName#" value="#getSchoolDistricts.StateDOE_IDNumber#" />
							</cfloop>
						</uform:field>
						<uForm:field label="Phone Number" name="mobilePhone" type="text" maxFieldLength="14" mask="(999) 999-9999" hint="Your contact number in case of cancellation of event" />
						<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="5" />
					</uForm:fieldset>
				</uForm:form>
			</div>
		</div>
	</cfoutput>
<cfelseif isDefined("URL.UserRegistrationSuccessfull")>
	<cfquery name="getSchoolDistricts" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select OrganizationName, StateDOE_IDNumber
		From eMembership
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
		Order by OrganizationName
	</cfquery>

	<cfoutput>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Register New User Account</h3>
			</div>
			<div class="art-blockcontent"><p class="alert-box notice">Please complete the following information to register for a user account on this event registration system. All electric communications from this system will be sent to the email address you provide. Any certificates that will be generated upon successfull completion of an event that issues certificates will use the information on this screen. Please make sure the information listed below is correct.</p>
				<hr>
				<uForm:form action="" method="Post" id="RegisterUser" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/properties/uniForm/"
					showCancel="no" cancelValue="<--- Return to Available Events" cancelName="cancelButton" cancelAction="/index.cfm"
					submitValue="Create User Account" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
						<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
						<input type="hidden" name="InActive" valule="1">
						<input type="hidden" name="formSubmit" value="true">
						<uForm:fieldset legend="User Account Fields">
							<uForm:field label="Your First Name" name="fName" isRequired="true" isDisabled="false" value="#Session.FormData.fName#" maxFieldLength="50" type="text" hint="Your First Name as you would like printed on certificates" />
							<uForm:field label="Your Last Name" name="lName" isRequired="true" isDisabled="false" value="#Session.FormData.lName#" maxFieldLength="50" type="text" hint="Your Last Name as you would like printed on certificates" />
							<uForm:field label="Your Email Address" name="UserName" isRequired="true" isDisabled="false" value="#Session.FormData.UserName#" maxFieldLength="50" type="text" hint="Your Primary Email Address" />
							<uForm:field label="Your Desired Password" name="Password" isRequired="true" isDisabled="false" value="#Session.FormData.Password#" maxFieldLength="50" type="password" hint="The Password for this site" />
							<uForm:field label="Confirm Desired Password" name="VerifyPassword" isRequired="true" isDisabled="false" value="#Session.FormData.VerifyPassword#" maxFieldLength="50" type="password" hint="Confirm Password for Site" />
						</uForm:fieldset>
						<uForm:fieldset legend="Optional Fields">
							<uform:field label="School District" name="Company" type="select" hint="School District employeed at?">
								<cfif Session.FormData.Company eq "0000">
									<uform:option display="Corporate Business" value="0000" isSelected="true" />
								<cfelse>
									<uform:option display="Corporate Business" value="0000" />
								</cfif>
								<cfif Session.FormData.Company eq "0001">
									<uform:option display="School District Not Listed" value="0001" isSelected="true" />
								<cfelse>
									<uform:option display="School District Not Listed" value="0001" />
								</cfif>
								<cfloop query="getSchoolDistricts">
									<uform:option display="#getSchoolDistricts.OrganizationName#" value="#getSchoolDistricts.StateDOE_IDNumber#" />
								</cfloop>
							</uform:field>
							<uForm:field label="Phone Number" name="mobilePhone" type="text" maxFieldLength="14" mask="(999) 999-9999" value="#Session.FOrmData.mobilePhone#" hint="Your contact number in case of cancellation of event" />
							<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
						</uForm:fieldset>
				</uForm:form>
			</div>
		</div>
	</cfoutput>
</cfif>