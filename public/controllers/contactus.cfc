/*


*/
<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="sendfeedback" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif not isDefined("Session.FormErrors")>
					<cfset Session.FormErrors = #ArrayNew()#>
				</cfif>
				<cfset Session.Captcha = #makeRandomString()#>
			</cflock>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormData = #StructCopy(FORM)#>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfif #HASH(FORM.ValidateCaptcha)# NEQ FORM.CaptchaEncrypted>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:contactus.sendfeedback&FormRetry=True">
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