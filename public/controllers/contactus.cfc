<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="sendfeedback" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif not isDefined("Session.FormErrors")>
					<cfset Session.FormErrors = #ArrayNew()#>
				</cfif>
				<cfquery name="getSiteSettings" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select ProcessPayments_Stripe, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_ENabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, Google_ReCaptchaEnabled, Google_ReCaptchaSiteKey, Google_ReCaptchaSecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken
					From p_EventRegistration_SiteConfig
					Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif not isDefined("Session.EventRegistration.SiteSettings")>
					<cfset Session.EventRegistration = StructNew()>
				</cfif>
				<cfset Session.EventRegistration.SiteSettings = #StructCopy(getSiteSettings)#>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormData = #StructCopy(FORM)#>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset GoogleReCaptchaCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/recaptcha")>

			<cfif Session.EventRegistration.SiteSettings.Google_ReCaptchaEnabled EQ 1>
				<cfif StructKeyExists(form, 'g-recaptcha-response')>
					<cfset CheckCaptcha = #GoogleReCaptchaCFC.verifyResponse(secret='6Le6hw0UAAAAAMfQXFE5H3AJ4PnGmADX9v468d93',response=form['g-recaptcha-response'], remoteip=cgi.remote_add)#>
					<cfif CheckCaptcha.success EQ "false">
						<cfscript>
							InvalidPassword = {property="VerifyPassword",message="We have detected that the form was completed by a Computer Robot. We ask that this form be completed by a human being."};
							arrayAppend(Session.FormErrors, InvalidPassword);
						</cfscript>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:contactus.sendfeedback&FormRetry=True" addtoken="false">
					</cfif>
				</cfif>
			</cfif>
			<cfif FORM.BestContactMethod EQ 0>
				<cfif not isValid("email", FORM.ContactEmail)>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							errormsg = {property="EmailAddr",message="Email Address is not in proper format"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cflock>
					<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:contactus.sendfeedback&FormRetry=True">
				</cfif>
			<cfelseif FORM.BestContactMethod EQ 1>
				<cfif Len(FORM.ContactPhone) LTE 7>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							errormsg = {property="ContactNumber",message="Please enter your contact phone number with area code so we can reply to your inquiry"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cflock>
					<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:contactus.sendfeedback&FormRetry=True">
				</cfif>
				<cfif not isValid("telephone", FORM.ContactPhone)>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							errormsg = {property="ContactNumber",message="Please enter proper telephone number format so we can reply to your inquiry"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cflock>
					<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:contactus.sendfeedback&FormRetry=True">
				</cfif>
			</cfif>
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfif isDefined("Session.FormData.SendTo")>
				<cfswitch expression="#Session.FormData.SendTo#">
					<cfcase value="Presenter">
						<cfset temp = #SendEmailCFC.SendCommentFormToPresenter(rc, Session.FormData)#>
						<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#URL.EventID#&SentInquiry=true">
					</cfcase>
					<cfcase value="Facilitator">
						<cfset temp = #SendEmailCFC.SendCommentFormToFacilitator(rc, Session.FormData)#>
						<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#URL.EventID#&SentInquiry=true">
					</cfcase>
				</cfswitch>
			<cfelse>
				<cfset temp = #SendEmailCFC.SendCommentFormToAdmin(rc, Session.FormData)#>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:contactus.default&SentInquiry=true">
			</cfif>

		</cfif>
	</cffunction>

	<cffunction name="makeRandomString" ReturnType="String" output="False">
		<cfset var chars = "23456789ABCDEFGHJKMNPQRSTUVWXYZ">
		<cfset var length = RandRange(4,7)>
		<cfset var result = "">
		<cfset var i = "">
		<cfset var char = "">
		<cfscript>
			for (i = 1; i < length; i++) {
				char = mid(chars, randRange(1, len(chars)), 1);
				result &= char;
			}
		</cfscript>
		<cfreturn result>
	</cffunction>

</cfcomponent>