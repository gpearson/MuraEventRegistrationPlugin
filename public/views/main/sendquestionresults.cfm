<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormErrors = #ArrayNew()#>
</cflock>
<cfif StructCount(FORM) NEQ 15>
	<cflock timeout="60" scope="SESSION" type="Exclusive">
		<cfscript>
			errormsg = {property="FormErrors",message="Invalid Form Submission Detected"};
			arrayAppend(Session.FormErrors, errormsg);
		</cfscript>
		<cfset Session.FormData = #StructCopy(FORM)#>
	</cflock>
	<cflocation addtoken="true" url="?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
<cfelse>
	<cflock timeout="60" scope="SESSION" type="Exclusive">
		<cfset Session.FormData = #StructCopy(FORM)#>
	</cflock>
	<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
		<cflock timeout="60" scope="SESSION" type="Exclusive">
			<cfscript>
				errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
				arrayAppend(Session.FormErrors, errormsg);
			</cfscript>
		</cflock>
		<cflocation addtoken="true" url="?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
	</cfif>
	
	<cfswitch expression="#FORM.ContactBy#">
		<cfcase value="Reply By Email">
			<cfif Len(FORM.EmailAddr) EQ 0>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="EmailAddr",message="Please enter your email address so we can reply to your inquiry"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
			</cfif>
			<cfif not isValid("email", FORM.EmailAddr)>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="EmailAddr",message="Email Address is not in proper format"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
			</cfif>
		</cfcase>
		<cfcase value="Reply By Telephone">
			<cfif Len(FORM.ContactNumber) EQ 0>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="ContactNumber",message="Please enter your contact phone number so we can reply to your inquiry"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
			</cfif>
			<cfif not isValid("telephone", FORM.ContactNumber)>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="ContactNumber",message="Please enter proper telephone number format so we can reply to your inquiry"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
			</cfif>
		</cfcase>
	</cfswitch>
	<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
	
	<cfquery name="getFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select FName, Lname, Email
		From tusers
		Where UserID = <cfqueryparam value="#Session.FormData.FacilitatorID#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfset Session.FormData.PluginInfo = StructNew()>
	<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
	<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
	<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
	<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
	<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
	<cfset Session.FormData.FacilitatorInfo = StructNew()>
	<cfset Session.FormData.FacilitatorInfo.FName = #getFacilitator.FName#>
	<cfset Session.FormData.FacilitatorInfo.LName = #getFacilitator.LName#>
	<cfset Session.FormData.FacilitatorInfo.Email = #getFacilitator.Email#>
	<cfset temp = #SendEmailCFC.SendEventInquiryToFacilitator(Session.FormData)#>
	<cfset temp = #SendEmailCFC.SendEventInquiryToIndividual(Session.FormData)#>
	<cflocation addtoken="true" url="?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#URL.EventID#&SentInquiry=true">
</cfif>