/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="init" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<!--- <cfset Session.FormData = StructNew()>
		<cfset Session.FormData.PluginInfo = StructNew()>
		<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
		<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
		<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
		<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
		<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#> --->
	</cffunction>

	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

	</cffunction>




	<cffunction name="testconfirmationreceipt" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

	</cffunction>

	<cffunction name="sendquestionform" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(Form)#>
			<cfset Session.FormData.PluginInfo = StructNew()>
			<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
			<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
			<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
			<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
			<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>

			<cfif StructCount(FORM) NEQ 16>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="FormErrors",message="Invalid Form Submission Detected"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfset Session.FormData = #StructCopy(FORM)#>
				</cflock>
				<cflocation addtoken="true" url="/plugins/EventRegistration/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
			<cfelse>
				<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cflock>
					<cflocation addtoken="true" url="/plugins/EventRegistration/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
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
							<cflocation addtoken="true" url="/plugins/EventRegistration/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
						</cfif>
						<cfif not isValid("email", FORM.EmailAddr)>
							<cflock timeout="60" scope="SESSION" type="Exclusive">
								<cfscript>
									errormsg = {property="EmailAddr",message="Email Address is not in proper format"};
									arrayAppend(Session.FormErrors, errormsg);
								</cfscript>
							</cflock>
							<cflocation addtoken="true" url="/plugins/EventRegistration/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
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
							<cflocation addtoken="true" url="/plugins/EventRegistration/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
						</cfif>
						<cfif not isValid("telephone", FORM.ContactNumber)>
							<cflock timeout="60" scope="SESSION" type="Exclusive">
								<cfscript>
									errormsg = {property="ContactNumber",message="Please enter proper telephone number format so we can reply to your inquiry"};
									arrayAppend(Session.FormErrors, errormsg);
								</cfscript>
							</cflock>
							<cflocation addtoken="true" url="/plugins/EventRegistration/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.sendquestionform&EventID=#URL.EventID#">
						</cfif>
					</cfcase>
				</cfswitch>
				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
				<cfquery name="getFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select FName, Lname, Email
					From tusers
					Where UserID = <cfqueryparam value="#Session.FormData.FacilitatorID#" cfsqltype="cf_sql_varchar">
				</cfquery>

				<cfset Session.FormData.FacilitatorInfo = StructNew()>
				<cfset Session.FormData.FacilitatorInfo.FName = #getFacilitator.FName#>
				<cfset Session.FormData.FacilitatorInfo.LName = #getFacilitator.LName#>
				<cfset Session.FormData.FacilitatorInfo.Email = #getFacilitator.Email#>
				<cfset temp = #SendEmailCFC.SendEventInquiryToFacilitator(Session.FormData)#>
				<cfset temp = #SendEmailCFC.SendEventInquiryToIndividual(Session.FormData)#>
				<cflocation addtoken="true" url="/plugins/EventRegistration/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#URL.EventID#&SentInquiry=true">
			</cfif>
		</cfif>

	</cffunction>
</cfcomponent>