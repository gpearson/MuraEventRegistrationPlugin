<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cfif not isDefined("Session.FormData")>
	<cflock scope="Session" timeout="60" type="Exclusive">
		<cfset Session.FormData = #StructNew()#>
	</cflock>
</cfif>
<cfoutput>
	<cfif not isDefined("URL.FormRetry") and not isDefined("URL.Key")>
		<cfset Session.FormErrors = #ArrayNew()#>
		<div class="art-blockheader">
			<h3 class="t">Acquire Lost Password</h3>
		</div>
		<p class="alert-box notice">Please complete the following information to retrieve your lost account password.</p>
		<hr>
		<uForm:form action="" method="Post" id="LostPassword" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/plugins/EventRegistration/library/uniForm/"
			showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm?EventRegistrationaction=public:events.viewavailableevents&Return=True"
			submitValue="Get Password" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
			<input type="hidden" name="formSubmit" value="true">
			<uForm:fieldset legend="Required Fields">
				<uForm:field label="Account First Name" name="Fname" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The First Name of the Account Holder" />
				<uForm:field label="Account Last Name" name="Lname" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The Last Name of the Account Holder" />
				<uForm:field label="Account Email" name="Email" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The Email Address of the Account Holder" />
				<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
			</uForm:fieldset>
		</uForm:form>
	<cfelseif isDefined("URL.FormRetry") and not isDefined("URL.Key")>
		<div class="art-blockheader">
			<h3 class="t">Acquire Lost Password</h3>
		</div>
		<p class="alert-box notice">Please complete the following information to retrieve your lost account password.</p>
		<hr>
		<uForm:form action="" method="Post" id="LostPassword" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/plugins/EventRegistration/library/uniForm/"
			showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm?EventRegistrationaction=public:events.viewavailableevents&Return=True"
			submitValue="Get Password" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
			<input type="hidden" name="formSubmit" value="true">
			<uForm:fieldset legend="Required Fields">
				<cfif isDefined("Session.FormData.Fname")>
					<uForm:field label="Account First Name" name="Fname" isRequired="True" value="#Session.FormData.Fname#" isDisabled="False" maxFieldLength="50" type="text" hint="The First Name of the Account Holder" />
				<cfelse>
					<uForm:field label="Account First Name" name="Fname" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The First Name of the Account Holder" />
				</cfif>

				<cfif isDefined("Session.FormData.Lname")>
					<uForm:field label="Account Last Name" name="Lname" isRequired="True" value="#Session.FormData.Lname#" isDisabled="False" maxFieldLength="50" type="text" hint="The Last Name of the Account Holder" />
				<cfelse>
					<uForm:field label="Account Last Name" name="Lname" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The Last Name of the Account Holder" />
				</cfif>

				<cfif isDefined("Session.FormData.Email")>
					<uForm:field label="Account Email" name="Email" isRequired="True" value="#Session.FormData.Email#" isDisabled="False" maxFieldLength="50" type="text" hint="The Email Address of the Account Holder" />
				<cfelse>
					<uForm:field label="Account Email" name="Email" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="The Email Address of the Account Holder" />
				</cfif>
				<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
			</uForm:fieldset>
		</uForm:form>
	<cfelseif isDefined("URL.Key") and not isDefined("URL.FormRetry")>
		<cfset DecryptKey = #ToString(ToBinary(URL.Key))#>
		<cfset UserID = #ListLast(ListFirst(Variables.DecryptKey, "&"), "=")#>
		<cfset DateSent = #ListLast(ListLast(Variables.DecryptKey, "="), "&")#>
		<cfif not isDefined("Session.FormErrors")>
			<cfset Session.FormErrors = #StructNew()#>
		</cfif>

		<cfquery name="GetAccountUsername" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, UserName, Email, created
			From tusers
			Where UserName = <cfqueryparam value="#Variables.UserID#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfif DateDiff("n", Now(), Variables.DateSent) GTE 45>
			<p class="alert-box error">The time between when the initial request in the password retrieval email and the current time is greater than the allotted time of 45 minutes. This attempt has failed and to reset your password a new request must be made.</p>
		<cfelse>
			<div class="art-blockheader">
				<h3 class="t">Acquire Lost Password</h3>
			</div>
			<p class="alert-box notice">Please complete the following information to retrieve your lost account password.</p>
			<hr>
			<uForm:form action="" method="Post" id="LostPassword" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/plugins/EventRegistration/library/uniForm/"
				showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm?EventRegistrationaction=public:events.viewavailableevents&Return=True"
				submitValue="Send Temporary Password" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="formSendTemporaryPassword" value="true">
				<input type="hidden" name="UserAccountEmail" value="#GetAccountUsername.Email#">
				<input type="hidden" name="UserAccountUsername" value="#GetAccountUsername.UserName#">
				<input type="hidden" name="Key" value="#URL.Key#">
				<uForm:fieldset legend="Required Fields">
					<uform:field label="Send Temporary Password" name="SendTempPassword" type="select" hint="Do you want system to send new password?">
						<uform:option display="Yes" value="1" />
						<uform:option display="No" value="0" isSelected="true"/>
					</uform:field>
					<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
				</uForm:fieldset>
			</uForm:form>
		</cfif>
	<cfelseif isDefined("URL.Key") and isDefined("URL.FormRetry")>
		<cfset DecryptKey = #ToString(ToBinary(URL.Key))#>
		<cfset UserID = ListFirst(ListLast(Variables.DecryptKey, "="), "&")>
		<cfset DateSent = #ListLast(ListLast(Variables.DecryptKey, "="), "&")#>

		<cfquery name="GetAccountUsername" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, UserName, Email, created
			From tusers
			Where UserName = <cfqueryparam value="#Variables.UserID#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif DateDiff("n", Now(), Variables.DateSent) GTE 45>
			<p class="alert-box error">The time between when the initial request in the password retrieval email and the current time is greater than the allotted time of 45 minutes. This attempt has failed and to reset your password a new request must be made.</p>
		<cfelse>
			<div class="art-blockheader">
				<h3 class="t">Acquire Lost Password</h3>
			</div>
			<p class="alert-box notice">Please complete the following information to retrieve your lost account password.</p>
			<hr>
			<uForm:form action="" method="Post" id="LostPassword" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/plugins/EventRegistration/library/uniForm/"
				showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm?EventRegistrationaction=public:events.viewavailableevents&Return=True"
				submitValue="Send Temporary Password" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="formSendTemporaryPassword" value="true">
				<input type="hidden" name="UserAccountEmail" value="#GetAccountUsername.Email#">
				<input type="hidden" name="UserAccountUsername" value="#GetAccountUsername.UserName#">
				<input type="hidden" name="Key" value="#URL.Key#">
				<uForm:fieldset legend="Required Fields">
					<uform:field label="Send Temporary Password" name="SendTempPassword" type="select" hint="Do you want system to send new password?">
						<uform:option display="Yes" value="1" />
						<uform:option display="No" value="0" isSelected="true"/>
					</uform:field>
					<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
				</uForm:fieldset>
			</uForm:form>
		</cfif>
	</cfif>
</cfoutput>