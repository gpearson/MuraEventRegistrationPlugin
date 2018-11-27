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
						<cfif isDefined("URL.EventID")>
							<cfif LEN(cgi.path_info)>
								<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True&EventID=#URL.EventID#" >
							<cfelse>
								<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True&EventID=#URL.EventID#" >
							</cfif>
						<cfelse>
							<cfif LEN(cgi.path_info)>
								<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True" >
							<cfelse>
								<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True" >
							</cfif>
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
				</cfif>
			</cfif>
			<cfif FORM.BestContactMethod EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please make a selection on the Best Contact Method for a reply on this inquiry"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif isDefined("URL.EventID")>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True&EventID=#URL.EventID#" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True&EventID=#URL.EventID#" >
					</cfif>
				<cfelse>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True" >
					</cfif>
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			<cfelseif FORM.BestContactMethod EQ 0>
				<cfif not isValid("email", FORM.ContactEmail)>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please update the entered email address as it does not appear to be in proper email format."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif isDefined("URL.EventID")>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True&EventID=#URL.EventID#" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True&EventID=#URL.EventID#" >
						</cfif>
					<cfelse>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True" >
						</cfif>
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
			<cfelseif FORM.BestContactMethod EQ 1>
				<cfif Len(FORM.ContactPhone) LTE 7>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please update the entered telephone number with area code so we can reply to your inquiry."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif isDefined("URL.EventID")>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True&EventID=#URL.EventID#" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True&EventID=#URL.EventID#" >
						</cfif>
					<cfelse>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True" >
						</cfif>
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
				<cfif not isValid("telephone", FORM.ContactPhone)>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please update the entered telephone number in proper United States Telephone Format so we can reply to your inquiry."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif isDefined("URL.EventID")>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True&EventID=#URL.EventID#" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True&EventID=#URL.EventID#" >
						</cfif>
					<cfelse>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:contactus.default&FormRetry=True" >
						</cfif>
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
			
			</cfif>
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfif isDefined("Session.FormInput.SendTo")>
				<cfswitch expression="#Session.FormInput.SendTo#">
					<cfcase value="Presenter">
						<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
							<cfset temp = #SendEmailCFC.SendCommentFormToPresenter(rc, Session.FormInput, '127.0.0.1')#>
						<cfelse>
							<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
								<cfif rc.$.siteConfig('mailserverssl') EQ "True">
									<cfset temp = #SendEmailCFC.SendCommentFormToPresenter(rc, Session.FormInput, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
								<cfelse>
									<cfset temp = #SendEmailCFC.SendCommentFormToPresenter(rc, Session.FormInput, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
								</cfif>
							<cfelse>
								<cfset temp = #SendEmailCFC.SendCommentFormToPresenter(rc, Session.FormInput, rc.$.siteConfig('mailserverip'))#>
							</cfif>
						</cfif>
						<cfif isDefined("URL.EventID")>
							<cfif LEN(cgi.path_info)>
								<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&EventID=#URL.EventID#&SentInquiry=true" >
							<cfelse>
								<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&EventID=#URL.EventID#&SentInquiry=true" >
							</cfif>
						<cfelse>
							<cfif LEN(cgi.path_info)>
								<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&SentInquiry=true" >
							<cfelse>
								<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&SentInquiry=true" >
							</cfif>
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfcase>
					<cfcase value="Facilitator">
						<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
							<cfset temp = #SendEmailCFC.SendCommentFormToFacilitator(rc, Session.FormInput, '127.0.0.1')#>
						<cfelse>
							<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
								<cfif rc.$.siteConfig('mailserverssl') EQ "True">
									<cfset temp = #SendEmailCFC.SendCommentFormToFacilitator(rc, Session.FormInput, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
								<cfelse>
									<cfset temp = #SendEmailCFC.SendCommentFormToFacilitator(rc, Session.FormInput, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
								</cfif>
							<cfelse>
								<cfset temp = #SendEmailCFC.SendCommentFormToFacilitator(rc, Session.FormInput, rc.$.siteConfig('mailserverip'))#>
							</cfif>
						</cfif>
						<cfif isDefined("URL.EventID")>
							<cfif LEN(cgi.path_info)>
								<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&EventID=#URL.EventID#&SentInquiry=true" >
							<cfelse>
								<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&EventID=#URL.EventID#&SentInquiry=true" >
							</cfif>
						<cfelse>
							<cfif LEN(cgi.path_info)>
								<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&SentInquiry=true" >
							<cfelse>
								<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&SentInquiry=true" >
							</cfif>
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfcase>
				</cfswitch>
			<cfelse>
				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
					<cfset temp = #SendEmailCFC.SendCommentFormToAdmin(rc, Session.FormInput, '127.0.0.1')#>
				<cfelse>
					<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
						<cfif rc.$.siteConfig('mailserverssl') EQ "True">
							<cfset temp = #SendEmailCFC.SendCommentFormToAdmin(rc, Session.FormInput, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
						<cfelse>
							<cfset temp = #SendEmailCFC.SendCommentFormToAdmin(rc, Session.FormInput, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
						</cfif>
					<cfelse>
						<cfset temp = #SendEmailCFC.SendCommentFormToAdmin(rc, Session.FormInput, rc.$.siteConfig('mailserverip'))#>
					</cfif>
				</cfif>
				<cfif isDefined("URL.EventID")>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&EventID=#URL.EventID#&SentInquiry=true" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&EventID=#URL.EventID#&SentInquiry=true" >
					</cfif>
				<cfelse>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&SentInquiry=true" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&SentInquiry=true" >
					</cfif>
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>
	
</cfcomponent>