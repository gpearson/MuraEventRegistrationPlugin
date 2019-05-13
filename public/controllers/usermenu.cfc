<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="SiteConfigSettings" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, Twitter_Enabled, Twitter_ConsumerKey, Twitter_ConsumerSecret, Twitter_AccessToken, Twitter_AccessTokenSecret, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
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
					<cfset CheckCaptcha = #GoogleReCaptchaCFC.verifyResponse(secret='#Session.SiteConfigSettings.GoogleReCaptcha_SecretKey#',response=form['g-recaptcha-response'], remoteip=cgi.remote_addr)#>
					<cfif CheckCaptcha.success EQ "false">
						<cfscript>
							InvalidPassword = {property="VerifyPassword",message="We have detected that the form was completed by a Computer Robot. We ask that this form be completed by a human being."};
							arrayAppend(Session.FormErrors, InvalidPassword);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&UserAction=CaptchaWrong&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.forgotpassword&UserAction=CaptchaWrong&FormRetry=True" >
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

	<cffunction name="upcomingevents" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="GetRegisteredEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_Events.Event_StartTime, p_EventRegistration_Events.Event_EndTime, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.LongDescription, p_EventRegistration_Events.EventAgenda, p_EventRegistration_Events.EventTargetAudience, p_EventRegistration_Events.EventStrategies, p_EventRegistration_Events.EventSpecialInstructions, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_Events.PresenterID, p_EventRegistration_Events.PGPCertificate_Available, p_EventRegistration_Events.Meal_Available, p_EventRegistration_Events.Meal_Included, p_EventRegistration_Events.H323_Available, p_EventRegistration_Events.Webinar_Available, p_EventRegistration_Events.Webinar_ConnectInfo, p_EventRegistration_Events.Webinar_MemberCost, p_EventRegistration_Events.Webinar_NonMemberCost, p_EventRegistration_Events.Event_HeldAtFacilityID, p_EventRegistration_Events.Event_FacilityRoomID, p_EventRegistration_UserRegistrations.Event_ID, p_EventRegistration_Facility.FacilityName, p_EventRegistration_FacilityRooms.RoomName
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID AND p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID INNER JOIN p_EventRegistration_Facility ON p_EventRegistration_Facility.TContent_ID = p_EventRegistration_Events.Event_HeldAtFacilityID INNER JOIN p_EventRegistration_FacilityRooms ON p_EventRegistration_FacilityRooms.TContent_ID = p_EventRegistration_Events.Event_FacilityRoomID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
				ORDER BY p_EventRegistration_UserRegistrations.RegistrationDate DESC
			</cfquery>
			<cfset Session.GetRegisteredEvents = #StructCopy(GetRegisteredEvents)#>
		</cfif>
	</cffunction>

	<cffunction name="cancelregistration" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_Events.Event_StartTime, p_EventRegistration_Events.Event_EndTime, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.LongDescription, p_EventRegistration_Events.EventAgenda, p_EventRegistration_Events.EventTargetAudience, p_EventRegistration_Events.EventStrategies, p_EventRegistration_Events.EventSpecialInstructions, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_Events.PresenterID, p_EventRegistration_Events.PGPCertificate_Available, p_EventRegistration_Events.PGPCertificate_Points, p_EventRegistration_Events.Meal_Available, p_EventRegistration_Events.Meal_Included, p_EventRegistration_Events.H323_Available, p_EventRegistration_Events.Webinar_Available, p_EventRegistration_Events.Webinar_ConnectInfo, p_EventRegistration_Events.Webinar_MemberCost, p_EventRegistration_Events.Webinar_NonMemberCost, p_EventRegistration_Events.Event_HeldAtFacilityID, p_EventRegistration_Events.Event_FacilityRoomID, p_EventRegistration_UserRegistrations.Event_ID, p_EventRegistration_Facility.FacilityName, p_EventRegistration_FacilityRooms.RoomName, p_EventRegistration_Facility.PhysicalAddress, p_EventRegistration_Facility.PhysicalCity, p_EventRegistration_Facility.PhysicalState, p_EventRegistration_Facility.PhysicalZipCode, p_EventRegistration_Facility.PrimaryVoiceNumber, p_EventRegistration_Facility.Physical_Latitude, p_EventRegistration_Facility.Physical_Longitude, p_EventRegistration_Facility.Physical_isAddressVerified
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID AND p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID INNER JOIN p_EventRegistration_Facility ON p_EventRegistration_Facility.TContent_ID = p_EventRegistration_Events.Event_HeldAtFacilityID INNER JOIN p_EventRegistration_FacilityRooms ON p_EventRegistration_FacilityRooms.TContent_ID = p_EventRegistration_Events.Event_FacilityRoomID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
					p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				ORDER BY p_EventRegistration_UserRegistrations.RegistrationDate DESC
			</cfquery>
			<cfif LEN(GetSelectedEvent.PresenterID)>
				<cfquery name="EventPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select FName, LName
					From tusers
					Where UserID = <cfqueryparam value="#GetSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfset Session.EventPresenter = #StructCopy(EventPresenter)#>
			</cfif>
			<cfset Session.GetSelectedEvent = #StructCopy(GetSelectedEvent)#>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif FORM.UserAction EQ "Back to Manage Registrations">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "GetSelectedEvent")>
				<cfset temp = StructDelete(Session, "GetEventFacility")>
				<cfset temp = StructDelete(Session, "GetEventFacilityRoom")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.manageregistrations" addtoken="false">
			</cfif>

			<cfif FORM.CancelRegistration EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Do you want to cancel your registration for this event? Select Yes or No below."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.cancelregistration&EventID=#FORM.EventID#&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.CancelRegistration EQ 1>
				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
				<cfset Info = StructNew()>
				<cfset Info.RegistrationID = #Session.GetSelectedEvent.RegistrationID#>
				<cfset Info.EventShortTitle = #Session.GetSelectedEvent.ShortTitle#>
				<cfset Info.EventShortTitle = #Session.GetSelectedEvent.ShortTitle#>
				<cfset Info.FormData = #StructCopy(Session.FormData)#>

				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
					<cfset temp = #Variables.SendEmailCFC.SendEventCancellationToSingleParticipant(rc, Variables.Info, "127.0.0.1")#>
				<cfelse>
					<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
						<cfif rc.$.siteConfig('mailserverssl') EQ "True">
							<cfset temp = #Variables.SendEmailCFC.SendEventCancellationToSingleParticipant(rc, Variables.Info, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
						<cfelse>
							<cfset temp = #Variables.SendEmailCFC.SendEventCancellationToSingleParticipant(rc, Variables.Info, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
						</cfif>
					<cfelse>
						<cfset temp = #Variables.SendEmailCFC.SendEventCancellationToSingleParticipant(rc, Variables.Info, rc.$.siteConfig('mailserverip'))#>
					</cfif>
				</cfif>
				
				<cfquery name="DeleteRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Delete from p_EventRegistration_UserRegistrations
					Where RegistrationID = <cfqueryparam value="#Info.RegistrationID#" cfsqltype="cf_sql_varchar">
				</cfquery>
				
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main&RegistrationCancelled=True" addtoken="false">
			<cfelse>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main&EventID=#FORM.EventID#&RegistrationCancelled=False" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="eventhistory" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="GetPastRegisteredEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_Events.Event_StartTime, p_EventRegistration_Events.Event_EndTime, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.LongDescription, p_EventRegistration_Events.EventAgenda, p_EventRegistration_Events.EventTargetAudience, p_EventRegistration_Events.EventStrategies, p_EventRegistration_Events.EventSpecialInstructions, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_Events.PresenterID, p_EventRegistration_Events.PGPCertificate_Available, p_EventRegistration_Events.PGPCertificate_Points, p_EventRegistration_Events.Meal_Available, p_EventRegistration_Events.Meal_Included, p_EventRegistration_Events.H323_Available, p_EventRegistration_Events.Webinar_Available, p_EventRegistration_Events.Webinar_ConnectInfo, p_EventRegistration_Events.Webinar_MemberCost, p_EventRegistration_Events.Webinar_NonMemberCost, p_EventRegistration_Events.Event_HeldAtFacilityID, p_EventRegistration_Events.Event_FacilityRoomID, p_EventRegistration_UserRegistrations.Event_ID, p_EventRegistration_Facility.FacilityName, p_EventRegistration_FacilityRooms.RoomName, p_EventRegistration_Facility.PhysicalAddress, p_EventRegistration_Facility.PhysicalCity, p_EventRegistration_Facility.PhysicalState, p_EventRegistration_Facility.PhysicalZipCode, p_EventRegistration_Facility.PrimaryVoiceNumber, p_EventRegistration_Facility.Physical_Latitude, p_EventRegistration_Facility.Physical_Longitude, p_EventRegistration_Facility.Physical_isAddressVerified
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID AND p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID INNER JOIN p_EventRegistration_Facility ON p_EventRegistration_Facility.TContent_ID = p_EventRegistration_Events.Event_HeldAtFacilityID INNER JOIN p_EventRegistration_FacilityRooms ON p_EventRegistration_FacilityRooms.TContent_ID = p_EventRegistration_Events.Event_FacilityRoomID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate, Now()) < <cfqueryparam value="0" cfsqltype="cf_sql_integer">
				ORDER BY p_EventRegistration_Events.EventDate DESC
			</cfquery>
			<cfset Session.GetPastRegisteredEvents = #StructCopy(GetPastRegisteredEvents)#>
		</cfif>
	</cffunction>

	<cffunction name="getcertificate" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("URL.EventID")>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.eventhistory" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:usermenu.eventhistory" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		<cfelseif isDefined("URL.EventID") and isDefined("URL.DisplayCertificate")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.TContent_ID, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_Events.PGPCertificate_Points, tusers.Fname, tusers.Lname, p_EventRegistration_Events.EventPricePerDay, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.WebinarParticipant
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and p_EventRegistration_Events.PGPCertificate_Available = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and p_EventRegistration_Events.TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfset EventDateQuery = #QueryNew("EventDate")#>
			<cfif LEN(GetSelectedEvent.EventDate)>
				<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(GetSelectedEvent.EventDate, "mm/dd/yy"))#>
			</cfif>
			<cfif LEN(GetSelectedEvent.EventDate1)>
				<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(GetSelectedEvent.EventDate1, "mm/dd/yy"))#>
			</cfif>
			<cfif LEN(GetSelectedEvent.EventDate2)>
				<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(GetSelectedEvent.EventDate2, "mm/dd/yy"))#>
			</cfif>
			<cfif LEN(GetSelectedEvent.EventDate3)>
				<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(GetSelectedEvent.EventDate3, "mm/dd/yy"))#>
			</cfif>
			<cfif LEN(GetSelectedEvent.EventDate4)>
				<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(GetSelectedEvent.EventDate4, "mm/dd/yy"))#>
			</cfif>
			<cfif LEN(GetSelectedEvent.EventDate5)>
				<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
				<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(GetSelectedEvent.EventDate5, "mm/dd/yy"))#>
			</cfif>

			<cfset CertificateExportTemplateDir = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")#>
			<cfset CertificateTemplateDir = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")#>
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

			<cfset ParticipantNumberOfPGPCertificatePoints = 0>
			<cfset ParticipantNumberOfDaysAttended = 0>
			<cfset EventDates = ValueList(EventDateQuery.EventDate, ",")>


			<cfif GetSelectedEvent.RegisterForEventDate1 EQ true and GetSelectedEvent.AttendedEventDate1 EQ true>
				<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #GetSelectedEvent.PGPCertificate_Points#>
				<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
			</cfif>

			<cfif GetSelectedEvent.RegisterForEventDate2 EQ 1 and GetSelectedEvent.AttendedEventDate2 EQ 1>
				<cfif LEN(GetSelectedEvent.PGPCertificate_Points)>
					<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #GetSelectedEvent.PGPCertificate_Points#>
					<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
				</cfif>	
			</cfif>

			<cfif GetSelectedEvent.RegisterForEventDate3 EQ 1 and GetSelectedEvent.AttendedEventDate3 EQ 1>
				<cfif LEN(GetSelectedEvent.PGPCertificate_Points)>
					<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #GetSelectedEvent.PGPCertificate_Points#>
					<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
				</cfif>	
			</cfif>

			<cfif GetSelectedEvent.RegisterForEventDate4 EQ 1 and GetSelectedEvent.AttendedEventDate4 EQ 1>
				<cfif LEN(GetSelectedEvent.PGPCertificate_Points)>
					<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #GetSelectedEvent.PGPCertificate_Points#>
					<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
				</cfif>	
			</cfif>

			<cfif GetSelectedEvent.RegisterForEventDate5 EQ 1 and GetSelectedEvent.AttendedEventDate5 EQ 1>
				<cfif LEN(GetSelectedEvent.PGPCertificate_Points)>
					<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #GetSelectedEvent.PGPCertificate_Points#>
					<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
				</cfif>	
			</cfif>

			<cfif GetSelectedEvent.RegisterForEventDate6 EQ 1 and GetSelectedEvent.AttendedEventDate6 EQ 1>
				<cfif LEN(GetSelectedEvent.PGPCertificate_Points)>
					<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #GetSelectedEvent.PGPCertificate_Points#>
					<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
				</cfif>	
			</cfif>

			<cfswitch expression="#rc.$.siteConfig('siteID')#">
				<cfdefaultcase>
					<cfset CertificateMasterTemplate = #Variables.CertificateTemplateDir# & "NIESCPGPCertificateTemplate.pdf">
				</cfdefaultcase>
			</cfswitch>

			<cfif GetSelectedEvent.EventPricePerDay EQ 0>
				<cfset ParticipantNumberOfPGPCertificatePoints = #NumberFormat(Variables.ParticipantNumberOfPGPCertificatePoints, "99.9")#>
			<cfelse>
				<cfset UpdatedPGPPoints = #Variables.ParticipantNumberOfPGPCertificatePoints# * #Variables.ParticipantNumberOfDaysAttended#>
				<cfset ParticipantNumberOfPGPCertificatePoints = #NumberFormat(Variables.UpdatedPGPPoints, "99.9")#>
			</cfif>
			
			
			<cfset ParticipantName = #GetSelectedEvent.FName# & " " & #GetSelectedEvent.LName#>
			<cfset ParticipantFilename = #Replace(Variables.ParticipantName, " ", "", "all")#>
			<cfset ParticipantFilename = #Replace(Variables.ParticipantFilename, ".", "", "all")#>
			<cfset PGPEarned = "PGP Earned: " & #NumberFormat(Variables.ParticipantNumberOfPGPCertificatePoints, "99.9")#>
			<cfset CertificateCompletedFile = #Variables.CertificateExportTemplateDir# & #URL.EventID# & "-" & #Variables.ParticipantFilename# & ".pdf">
			<cfscript>
				PDFCompletedCertificate = CreateObject("java", "java.io.FileOutputStream").init(CertificateCompletedFile);
				PDFMasterCertificateTemplate = CreateObject("java", "com.itextpdf.text.pdf.PdfReader").init(CertificateMasterTemplate);
				PDFStamper = CreateObject("java", "com.itextpdf.text.pdf.PdfStamper").init(PDFMasterCertificateTemplate, PDFCompletedCertificate);
				PDFStamper.setFormFlattening(true);
				PDFFormFields = PDFStamper.getAcroFields();
				PDFFormFields.setField("PGPEarned", Variables.PGPEarned);
				PDFFormFields.setField("ParticipantName", Variables.ParticipantName);
				PDFFormFields.setField("EventTitle", GetSelectedEvent.ShortTitle);
				PDFFormFields.setField("EventDates", Variables.EventDates);
				PDFFormFields.setField("SignDate", DateFormat(GetSelectedEvent.EventDate, "mm/dd/yyyy"));
				PDFStamper.close();
			</cfscript>
			<cfset Session.getSelectedEvent = StructCopy(GetSelectedEvent)>
			<cfset Session.CertificateCompletedFile = #Variables.CertificateCompletedFile#>
		</cfif>
	</cffunction>
	
</cfcomponent>