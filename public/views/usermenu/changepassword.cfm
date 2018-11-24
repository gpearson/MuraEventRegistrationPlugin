<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cfif not isDefined("Session.FormData")>
	<cflock scope="Session" timeout="60" type="Exclusive">
		<cfset Session.FormData = #StructNew()#>
	</cflock>
</cfif>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<cfset Session.FormErrors = #ArrayNew()#>
		<h2>Update Account Password</h2>
		<p class="alert-box notice">Please complete the following information to update your account password.</p>
		<hr>
		<uForm:form action="" method="Post" id="ChangePassword" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/properties/uniForm/"
			showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm"
			submitValue="Change Password" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
			<input type="hidden" name="formSubmit" value="true">
			<input type="hidden" name="UserID" value="#Session.Mura.UserID#">
			<uForm:fieldset legend="Required Fields">
				<uForm:field label="Current Password" name="oldPassword" isRequired="True" isDisabled="False" maxFieldLength="50" type="password" hint="What is your current account password" />
				<uForm:field label="New Desired Password" name="newPassword" isRequired="True" isDisabled="False" maxFieldLength="50" type="password" hint="What would you like your account password to be?" />
				<uForm:field label="Retype Desired Password" name="newVerifyPassword" isRequired="True" isDisabled="False" maxFieldLength="50" type="password" hint="Retype your new desired password to verify it is correct" />
				<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="3" captchaMaxChars="3" />
			</uForm:fieldset>
		</uForm:form>
	<cfelseif isDefined("URL.FormRetry")>
		<h2>Update Account Password</h2>
		<p class="alert-box notice">Please complete the following information to update your account password.</p>
		<hr>
		<uForm:form action="" method="Post" id="ChangePassword" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/properties/uniForm/"
			showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm"
			submitValue="Change Password" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
			<input type="hidden" name="formSubmit" value="true">
			<input type="hidden" name="UserID" value="#Session.Mura.UserID#">
			<uForm:fieldset legend="Required Fields">
				<uForm:field label="Current Password" name="oldPassword" value="#Session.FormData.oldPassword#" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="What is your current account password" />
				<uForm:field label="New Desired Password" name="newPassword" value="#Session.FormData.newPassword#" isRequired="True" isDisabled="False" maxFieldLength="50" type="password" hint="What would you like your account password to be?" />
				<uForm:field label="Verify Desired Password" name="newVerifyPassword" isRequired="True" value="#Session.FormData.newVerifyPassword#" isDisabled="False" maxFieldLength="50" type="password" hint="Retype your new desired password to verify it is correct" />
				<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="3" captchaMaxChars="3" />
			</uForm:fieldset>
		</uForm:form>
	</cfif>
</cfoutput>