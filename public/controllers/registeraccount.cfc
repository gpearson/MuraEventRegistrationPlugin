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
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
				</cfif>
			</cfif>
			<cfif Len(FORM.fName) LTE 3>
				<cfscript>
					errormsg = {property="EmailMsg",message="It seems that the First Name field had less than three characters entered within it. If your first name has less than three characters in it, please contact us so that we can create your account from the Administrative Interface"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif Len(FORM.lName) LTE 3>
				<cfscript>
					errormsg = {property="EmailMsg",message="It seems that the Last Name field had less than three characters entered within it. If your last name has less than three characters in it, please contact us so that we can create your account from the Administrative Interface"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif not isValid("email", FORM.UserName)>
				<cfscript>
					errormsg = {property="EmailMsg",message="It appears that the email address entered was not in proper format as a valid email address. Please check this field and try to submit your account request again. If you continue to have issues, please utilize the contact us form so we can resolve this issue."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif not isDefined("FORM.Password") or not isDefined("FORM.VerifyPassword")>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password or the Verify Password Field did not have any text entered. Please correct this issue before submitting your account to be created."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			<cfelseif FORM.Password NEQ FORM.VerifyPassword>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field and the Verify Password Field did not match each other. Please correct this issue before submitting your account to be created."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<!--- Initiates the User Bean --->
			<cfset userRecord = rc.$.getBean('user').loadBy(username='#FORM.UserName#', siteid='#rc.$.siteConfig("siteid")#')>
			<cfset temp = #userRecord.set('siteid', rc.$.siteConfig("siteid"))#>
			<cfset temp = #userRecord.set('fname', '#Trim(FORM.FName)#')#>
			<cfset temp = #userRecord.set('lname', '#Trim(FORM.LName)#')#>
			<cfset temp = #userRecord.set('username', '#Trim(FORM.UserName)#')#>
			<cfset temp = #userRecord.set('email', '#Trim(FORM.UserName)#')#>
			<cfset temp = #userRecord.set('InActive', 1)#>
			<cfif LEN(form.mobilePhone)><cfset temp = #userRecord.set('mobilePhone', '#Trim(FORM.mobilePhone)#')#></cfif>
			<cfset temp = #userRecord.set('created', '#Now()#')#>
			<cfset temp = #userRecord.set('passwordcreated', '#Now()#')#>
			<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
			<cfset temp = #userRecord.set('lastupdateby', '#Session.Mura.Fname# #Session.Mura.LName#')#>
			<cfset temp = #userRecord.set('lastupdatebyid', '#Session.Mura.UserID#')#>
			<cfset temp = #userRecord.setPasswordNoCache('#FORM.VerifyPassword#')#>

			<cfif userRecord.checkUsername() EQ "false">
				<cfscript>
					errormsg = {property="EmailMsg",message="The email address '#FORM.UserName#' already exists in our database. This system requires each account to be unique on the email address. If this is actually your email address you can go through the Forgot Password process to recover your account information."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:registeraccount.default&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
          	<cfelse>
          		<cfset AddNewAccount = #userRecord.save()#>
          		<cfif LEN(AddNewAccount.getErrors()) EQ 0>
          			<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
          				<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmail(rc, AddNewAccount.getUserID())#>
          			<cfelse>
          				<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
          					<cfif rc.$.siteConfig('mailserverssl') EQ "True">
          						<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmail(rc, AddNewAccount.getUserID(), rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
          					<cfelse>
          						<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmail(rc, AddNewAccount.getUserID(), rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
          					</cfif>
          				<cfelse>
          					<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmail(rc, AddNewAccount.getUserID(), rc.$.siteConfig('mailserverip'))#>
          				</cfif>
          			</cfif>
          			<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=VerifyAccount" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=VerifyAccount" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
          		<cfelse>

          		</cfif>
          	</cfif>
		</cfif>
	</cffunction>

	<cffunction name="activateaccount" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("URL.Key")><cflocation url="/index.cfm" addtoken="false"></cfif>

		<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

		<cfif isDefined("URL.Key")>
			<cfset DecryptedURLString = #ToString(ToBinary(URL.Key))#>
			<cfset UserID = #ListFirst(Variables.DecryptedURLString, "&")#>
			<cfset DateSentCreated = #ListLast(Variables.DecryptedURLString, "&")#>

			<cfquery name="getUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Fname, Lname, UserName, Email, created
				From tusers
				Where UserID = <cfqueryparam value="#ListLast(Variables.UserID, '=')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfif DateDiff("n", ListLast(Variables.DateSentCreated, '='), Now()) LTE 45>
				<!--- Allow Up To 45 Minutes for user to click on the link to activate the account --->
				<cftry>
					<cfquery name="updateUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update tusers
						Set inActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
							LastUpdate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam value="System" cfsqltype="cf_sql_varchar">,
							lastUpdateByID = <cfqueryparam value="System" cfsqltype="cf_sql_varchar">
						Where UserID = <cfqueryparam value="#ListLast(Variables.UserID, '=')#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfcatch type="database">
						<cfdump var="#cfcatch#">
					</cfcatch>
				</cftry>

				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
          			<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmailConfirmation(rc, AddNewAccount.getUserID())#>
          		<cfelse>
          			<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
          				<cfif rc.$.siteConfig('mailserverssl') EQ "True">
          					<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmailConfirmation(rc, ListLast(Variables.UserID, '='), rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
          				<cfelse>
          					<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmailConfirmation(rc, ListLast(Variables.UserID, '='), rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
          				</cfif>
          			<cfelse>
          				<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmailConfirmation(rc, ListLast(Variables.UserID, '='), rc.$.siteConfig('mailserverip'))#>
          			</cfif>
          		</cfif>
          		<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=UserActivated" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=UserActivated" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			<cfelse>
				<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmail(rc, ListLast(Variables.UserID, '='))#>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:main.default&UserAction=UserActivated&Successfull=false" addtoken="false">
			</cfif>			

		</cfif>
	</cffunction>
</cfcomponent>