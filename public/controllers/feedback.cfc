/*


*/
<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="requestworkshop" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FOrm)#>
			<cfset Session.FormData.PluginInfo = StructNew()>
			<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
			<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
			<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
			<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
			<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>

			<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback.requestworkshop&FormRetry=True">
			</cfif>

			<cfswitch expression="#FORM.ContactBy#">
				<cfcase value="Reply By Email">
					<cfif Len(FORM.ContactFormEmail) EQ 0>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								errormsg = {property="EmailAddr",message="Please enter your email address so we can reply to your inquiry"};
								arrayAppend(Session.FormErrors, errormsg);
							</cfscript>
						</cflock>
						<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback.requestworkshop&FormRetry=True">
					</cfif>
					<cfif not isValid("email", FORM.ContactFormEmail)>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								errormsg = {property="EmailAddr",message="Email Address is not in proper format"};
								arrayAppend(Session.FormErrors, errormsg);
							</cfscript>
						</cflock>
						<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback.requestworkshop&FormRetry=True">
					</cfif>
				</cfcase>
				<cfcase value="Reply By Telephone">
					<cfif Len(FORM.ContactFormNumber) EQ 0>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								errormsg = {property="ContactNumber",message="Please enter your contact phone number so we can reply to your inquiry"};
								arrayAppend(Session.FormErrors, errormsg);
							</cfscript>
						</cflock>
						<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback.requestworkshop&FormRetry=True">
					</cfif>
					<cfif not isValid("telephone", FORM.ContactFormNumber)>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								errormsg = {property="ContactNumber",message="Please enter proper telephone number format so we can reply to your inquiry"};
								arrayAppend(Session.FormErrors, errormsg);
							</cfscript>
						</cflock>
						<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback.requestworkshop&FormRetry=True">
					</cfif>
				</cfcase>
			</cfswitch>

			<cfif StructCount(FORM) NEQ 14>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="FormErrors",message="Invalid Form Submission Detected"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfset Session.FormData = #StructCopy(FORM)#>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback.requestworkshop&FormRetry=True">
			</cfif>

			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfset temp = #SendEmailCFC.SendWorkshopRequestFormToAdmin(Session.FormData)#>
			<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.viewavailableevents&SentCommentInquiry=true">
		</cfif>
	</cffunction>

	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FOrm)#>
			<cfset Session.FormData.PluginInfo = StructNew()>
			<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
			<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
			<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
			<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
			<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>

			<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback&FormRetry=True">
			</cfif>

			<cfif StructCount(FORM) NEQ 11>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="FormErrors",message="Invalid Form Submission Detected"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfset Session.FormData = #StructCopy(FORM)#>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback&FormRetry=True">
			</cfif>

			<cfswitch expression="#FORM.ContactBy#">
					<cfcase value="Reply By Email">
						<cfif Len(FORM.ContactFormEmail) EQ 0>
							<cflock timeout="60" scope="SESSION" type="Exclusive">
								<cfscript>
									errormsg = {property="EmailAddr",message="Please enter your email address so we can reply to your inquiry"};
									arrayAppend(Session.FormErrors, errormsg);
								</cfscript>
							</cflock>
							<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback&FormRetry=True">
						</cfif>
						<cfif not isValid("email", FORM.ContactFormEmail)>
							<cflock timeout="60" scope="SESSION" type="Exclusive">
								<cfscript>
									errormsg = {property="EmailAddr",message="Email Address is not in proper format"};
									arrayAppend(Session.FormErrors, errormsg);
								</cfscript>
							</cflock>
							<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback&FormRetry=True">
						</cfif>
					</cfcase>
					<cfcase value="Reply By Telephone">
						<cfif Len(FORM.ContactFormNumber) EQ 0>
							<cflock timeout="60" scope="SESSION" type="Exclusive">
								<cfscript>
									errormsg = {property="ContactNumber",message="Please enter your contact phone number so we can reply to your inquiry"};
									arrayAppend(Session.FormErrors, errormsg);
								</cfscript>
							</cflock>
							<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback&FormRetry=True">
						</cfif>
						<cfif not isValid("telephone", FORM.ContactFormNumber)>
							<cflock timeout="60" scope="SESSION" type="Exclusive">
								<cfscript>
									errormsg = {property="ContactNumber",message="Please enter proper telephone number format so we can reply to your inquiry"};
									arrayAppend(Session.FormErrors, errormsg);
								</cfscript>
							</cflock>
							<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:feedback&FormRetry=True">
						</cfif>
					</cfcase>
				</cfswitch>
				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
				<cfset temp = #SendEmailCFC.SendCommentFormToAdmin(Session.FormData)#>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.viewavailableevents&SentCommentInquiry=true">
		</cfif>


	</cffunction>

</cfcomponent>