<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="SiteConfigSettings" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
				From p_EventRegistration_SiteConfig
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
			</cfquery>
			<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>
		<cfelse>

		</cfif>		
		
	</cffunction>

	<cffunction name="forgotpassword" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and not isDefined("URL.Key")>
			<cfquery name="SiteConfigSettings" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
				From p_EventRegistration_SiteConfig
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
			</cfquery>
			<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>
		<cfelseif isDefined("FORM.formSubmit") and not isDefined("URL.Key")>
			<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
				<cfset GoogleReCaptchaCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/recaptcha")>
			</cfif>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.SendInquiry EQ "Back to Current Events">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
				<cfif StructKeyExists(form, 'g-recaptcha-response')>
					<cfset CheckCaptcha = #GoogleReCaptchaCFC.verifyResponse(secret='#Session.SiteConfigSettings.GoogleReCaptcha_SecretKey#',response=form['g-recaptcha-response'], remoteip=cgi.remote_add)#>
					<cfif CheckCaptcha.success EQ "false">
						<cfscript>
							InvalidPassword = {property="VerifyPassword",message="We have detected that the form was completed by a Computer Robot. We ask that this form be completed by a human being."};
							arrayAppend(Session.FormErrors, InvalidPassword);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&UserAction=CaptchaWrong&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&UserAction=CaptchaWrong&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
				</cfif>
			</cfif>
			<cfif not isValid("email", FORM.UserEmailAddress)>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please check the email address entered as it appears to not be in the correct email format."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&UserAction=InvalidEmailAddress&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&UserAction=InvalidEmailAddress&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfset userRecord = #rc.$.getBean('user').loadBy(username='#FORM.UserEmailAddress#', siteid='#rc.$.siteConfig("siteid")#')#>

			<cfif userRecord.exists() EQ "False">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please check the email address entered as it was not located within the users table of this system."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&UserAction=UserAccountNotFound&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&UserAction=UserAccountNotFound&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			<cfelse>
				<cfset ValueToEncrypt = "UserID=" & #userRecord.getValue('userid')# & "&" & "Created=" & #userRecord.getValue('created')# & "&DateSent=" & #Now()#>
				<cfset EncryptedValue = #Tobase64(Variables.ValueToEncrypt)#>
				<cfset AccountVars = "Key=" & #Variables.EncryptedValue#>
				<cfset AccountVerifyLink = "http://" & #CGI.Server_Name# & "#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:usermenu.forgotpassword&" & #Variables.AccountVars#>

				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
				<cfset EventServicesComponent = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
				<cfset ShortenedURL = EventServicesComponent.insertShortURLContent(rc, AccountVerifyLink)>

				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
          			<cfset SendPasswordChangeVerifyEmail = #SendEmailCFC.SendForgotPasswordRequest(rc, userRecord.getValue('userid'), ShortenedURL)#>
          		<cfelse>
          			<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
          				<cfif rc.$.siteConfig('mailserverssl') EQ "True">
          					<cfset SendActivationEmail = #SendEmailCFC.SendForgotPasswordRequest(rc, userRecord.getValue('userid'), ShortenedURL, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
          				<cfelse>
          					<cfset SendActivationEmail = #SendEmailCFC.SendForgotPasswordRequest(rc, userRecord.getValue('userid'), ShortenedURL, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
          				</cfif>
          			<cfelse>
          				<cfset SendActivationEmail = #SendEmailCFC.SendForgotPasswordRequest(rc, userRecord.getValue('userid'), ShortenedURL, rc.$.siteConfig('mailserverip'))#>
          			</cfif>
          		</cfif>
          		<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=PasswordLinkSent" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=PasswordLinkSent" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		<cfelseif isDefined("URL.Key") and not isDefined("form.formSubmit")>
			<cfset KeyAsString = #ToString(ToBinary(URL.Key))#>
			<cfset Session.PasswordKey = StructNew()>
			<cfset Session.PasswordKey.UserID = #ListLast(ListFirst(Variables.KeyAsString, "&"), "=")#>
			<cfset Session.PasswordKey.DateCreated = #ListLast(ListLast(Variables.KeyAsString, "&"), "=")#>
			<cfif DateDiff("n", Session.PasswordKey.DateCreated, Now()) GT 45>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Reset Request Link has expired due to being longer than 45 minutes between the time someone requested it and it was clicked. No changes to the current account has been done. If you would like to reset your password please visit the Forgot Password Link under Home again and enter your email address."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=PasswordResetTimeExpired" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=PasswordResetTimeExpired" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		<cfelseif isDefined("form.formSubmit") and isDefined("form.UserID")>
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
				<cfset GoogleReCaptchaCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/recaptcha")>
			</cfif>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.SendInquiry EQ "Back to Current Events">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
				<cfif StructKeyExists(form, 'g-recaptcha-response')>
					<cfset CheckCaptcha = #GoogleReCaptchaCFC.verifyResponse(secret='#Session.SiteConfigSettings.GoogleReCaptcha_SecretKey#',response=form['g-recaptcha-response'], remoteip=cgi.remote_add)#>
					<cfif CheckCaptcha.success EQ "false">
						<cfscript>
							InvalidPassword = {property="VerifyPassword",message="We have detected that the form was completed by a Computer Robot. We ask that this form be completed by a human being."};
							arrayAppend(Session.FormErrors, InvalidPassword);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&UserAction=CaptchaWrong&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&UserAction=CaptchaWrong&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
				</cfif>
			</cfif>
			<cfif not isDefined("FORM.Password") or not isDefined("FORM.VerifyPassword")>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password or the Verify Password Field did not have any text entered. Please correct this issue before submitting your account to be created."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&Key=#URL.Key#&UserAction=PasswordMissing&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&Key=#URL.Key#&UserAction=PasswordMissing&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			<cfelseif FORM.Password NEQ FORM.VerifyPassword>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field and the Verify Password Field did not match each other. Please correct this issue before submitting your account to be created."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&Key=#URL.Key#&UserAction=PasswordMismatch&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&Key=#URL.Key#&UserAction=PasswordMismatch&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfset userRecord = #rc.$.getBean('user').loadBy(userid='#Session.PasswordKey.UserID#', siteid='#rc.$.siteConfig("siteid")#')#>
			<cfset temp = #userRecord.set('passwordcreated', '#Now()#')#>
			<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
			<cfset temp = #userRecord.set('lastupdateby', 'Forgot Password Retrievial Process')#>
			<cfset temp = #userRecord.set('lastupdatebyid', '')#>
			<cfset temp = #userRecord.setPasswordNoCache('#FORM.VerifyPassword#')#>

			<cfset ChangeAccountInfo = #userRecord.save()#>

			<cfif LEN(ChangeAccountInfo.getErrors()) EQ 0>
				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
          			<cfset SendPasswordChangedEmail = #SendEmailCFC.SendMessageToUserAboutPasswordChanged(rc, userRecord.getUserID())#>
          		<cfelse>
          			<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
          				<cfif rc.$.siteConfig('mailserverssl') EQ "True">
          					<cfset SendPasswordChangedEmail = #SendEmailCFC.SendMessageToUserAboutPasswordChanged(rc, userRecord.getUserID(), rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
          				<cfelse>
          					<cfset SendPasswordChangedEmail = #SendEmailCFC.SendMessageToUserAboutPasswordChanged(rc, userRecord.getUserID(), rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
          				</cfif>
          			<cfelse>
          				<cfset SendPasswordChangedEmail = #SendEmailCFC.SendMessageToUserAboutPasswordChanged(rc, userRecord.getUserID(), rc.$.siteConfig('mailserverip'))#>
          			</cfif>
          		</cfif>
          		<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=AccountPasswordChanged" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=AccountPasswordChanged" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			<cfelse>

			</cfif>
		</cfif>
		<!--- 

		<cfif not isDefined("FORM.formSubmit") and not isDefined("URL.ShortURL") and not isDefined("URL.Key")>

		<cfelseif not isDefined("FORM.formSubmit") and not isDefined("FORM.formUpdateAccountPassword") and isDefined("URL.ShortURL")>
			<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="GetFullLink">
				Select TContent_ID, FullLink
				From p_EventRegistration_ShortURL
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
					ShortLink = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.ShortURL#"> and
					Active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			</cfquery>

			<cfif GetFullLink.RecordCount EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Link you clicked on to reset a user's account password has either expired or is no longer valid."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			<cfelse>
				<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="UpdateShortURLLinkActiveStatus">
				Update p_EventRegistration_ShortURL
				Set Active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
					lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#GetFullLink.TContent_ID#">
				</cfquery>
				<cflocation url="#GetFullLink.FullLink#" addtoken="false">
			</cfif>
		<cfelseif not isDefined("FORM.formSubmit") and not isDefined("URL.ShortURL") and isDefined("URL.Key")>
			<cfset KeyAsString = #ToString(ToBinary(URL.Key))#>
			<cfset Session.PasswordKey = StructNew()>
			<cfset Session.PasswordKey.UserID = #ListLast(ListFirst(Variables.KeyAsString, "&"), "=")#>
			<cfset Session.PasswordKey.DateCreated = #ListLast(ListLast(Variables.KeyAsString, "&"), "=")#>

			<cfif DateDiff("n", Session.PasswordKey.DateCreated, Now()) GT 45>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Reset Request Link has expired due to being longer than 45 minutes between the time someone requested it and it was clicked. No changes to the current account has been done. If you would like to reset your password please visit the Forgot Password Link under Home again and enter your email address."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=PasswordTimeExpired" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=PasswordTimeExpired" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

		<cfelseif isDefined("FORM.formSubmit") and not isDefined("FORM.formUpdateAccountPassword") and not isDefined("URL.ShortURL")>
					
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>	
			<cfset EventServicesCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>	
		
			<cfif LEN(userRecord.Username) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="The email address entered was not located in the database of registered users. Please check the entered email address and try again. If you have issues please contact us so we can assist in getting your password reset."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			<cfelse>
				<cfset ValueToEncrypt = "UserID=" & #userRecord.UserID# & "&" & "Created=" & #userRecord.created# & "&DateSent=" & #Now()#>
				<cfset EncryptedValue = #Tobase64(Variables.ValueToEncrypt)#>
				<cfset AccountVars = "Key=" & #Variables.EncryptedValue#>
				<cfif LEN(cgi.path_info)>
					<cfset AccountPasswordLink = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&" & #Variables.AccountVars#>
				<cfelse>
					<cfset AccountPasswordLink = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&" & #Variables.AccountVars#>
				</cfif>
				<cfset ShortURLPasswordLink = #EventServicesCFC.insertShortURLContent(rc, Variables.AccountPasswordLink)#>

				<cfif LEN(cgi.path_info)>
					<cfif rc.$.siteConfig('useSSL') EQ 1>
						<cfset ShortURLLink = "https://" & #rc.$.siteconfig('domain')# & #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&" & "ShortURL=" & #Variables.ShortURLPasswordLink#>
					<cfelse>
						<cfset ShortURLLink = "http://" & #rc.$.siteconfig('domain')# & #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&" & "ShortURL=" & #Variables.ShortURLPasswordLink#>
					</cfif>
				<cfelse>
					<cfif rc.$.siteConfig('useSSL') EQ 1>
						<cfset ShortURLLink = "https://" & #rc.$.siteconfig('domain')# & #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&" & "ShortURL=" & #Variables.ShortURLPasswordLink#>
					<cfelse>
						<cfset ShortURLLink = "http://" & #rc.$.siteconfig('domain')# & #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&" & "ShortURL=" & #Variables.ShortURLPasswordLink#>
					</cfif>
				</cfif>
				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
					<cfset temp = #SendEmailCFC.SendForgotPasswordRequest(rc, userRecord, ShortURLLink, '127.0.0.1')#>
				<cfelse>
					<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
						<cfif rc.$.siteConfig('mailserverssl') EQ "True">
							<cfset temp = #SendEmailCFC.SendForgotPasswordRequest(rc, userRecord, ShortURLLink, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
						<cfelse>
							<cfset temp = #SendEmailCFC.SendForgotPasswordRequest(rc, userRecord, ShortURLLink, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
						</cfif>
					<cfelse>
						<cfset temp = #SendEmailCFC.SendForgotPasswordRequest(rc, userRecord, ShortURLLink, rc.$.siteConfig('mailserverip'))#>
					</cfif>
				</cfif>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=PasswordRequestSent" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=PasswordRequestSent" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.formUpdateAccountPassword")>
			<cfif Session.SiteConfigSettings.Google_ReCaptchaEnabled EQ 1>
				<cfset GoogleReCaptchaCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/recaptcha")>
			</cfif>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.SendInquiry EQ "Back to Current Events">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif Session.SiteConfigSettings.Google_ReCaptchaEnabled EQ 1>
				<cfif StructKeyExists(form, 'g-recaptcha-response')>
					<cfset CheckCaptcha = #GoogleReCaptchaCFC.verifyResponse(secret='#Session.SiteConfigSettings.Google_ReCaptchaSecretKey#',response=form['g-recaptcha-response'], remoteip=cgi.remote_add)#>
					<cfif CheckCaptcha.success EQ "false">
						<cfscript>
							InvalidPassword = {property="VerifyPassword",message="We have detected that the form was completed by a Computer Robot. We ask that this form be completed by a human being."};
							arrayAppend(Session.FormErrors, InvalidPassword);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&FormRetry=True&Key=#URL.Key#" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&FormRetry=True&Key=#URL.Key#">
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
				</cfif>
			</cfif>
			<cfif LEN(FORM.NewPassword) LT 5 or LEN(FORM.NewVerifyPassword) LT 5>
				<cfscript>
					InvalidPassword = {property="VerifyPassword",message="The system detected the password field(s) were too short. Please enter a password that is longer than 5 characters in length."};
					arrayAppend(Session.FormErrors, InvalidPassword);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&FormRetry=True&Key=#URL.Key#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&FormRetry=True&Key=#URL.Key#">
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			<cfelseif FORM.NewPassword NEQ FORM.NewVerifyPassword>
				<cfscript>
					InvalidPassword = {property="VerifyPassword",message="The system detected the password field(s) did not match each other. Please update these fields so they match and then your password can be updated."};
					arrayAppend(Session.FormErrors, InvalidPassword);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&FormRetry=True&Key=#URL.Key#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&FormRetry=True&Key=#URL.Key#">
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="GetUsernameFromUserID">
				Select UserName From tusers Where SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and UserID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.UserID#">
			</cfquery>

			<cfset userRecord = #rc.$.getBean('user').loadBy(username='#GetUsernameFromUserID.UserName#', siteid='#rc.$.siteConfig("siteid")#')#>
			<cfset temp = #userRecord.setPasswordNoCache('#FORM.NewVerifyPassword#')#>
			<cfset UpdateUserAccount = #userRecord.save()#>
			
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=PasswordResetSuccessfully" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=PasswordResetSuccessfully">
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">

		</cfif>

	--->
	</cffunction>
	
</cfcomponent>