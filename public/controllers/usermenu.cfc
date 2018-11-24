/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfset Session.FormData.PluginInfo = StructNew()>
		<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
		<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
		<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
		<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
		<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
	</cffunction>

	<cffunction name="editprofile" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and not isDefined("URL.FormRetry")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif not isDefined("Session.FormData.PluginInfo")>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cfif>

			<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.editprofile&FormRetry=True">
			</cfif>

			<cfif not isValid("email", FORM.Email)>
				<cfscript>
					UsernameNotValid = {property="Email",message="The Email Address is not a valid email address. We use this to lookup your account so that the correct information can be sent to you."};
					arrayAppend(Session.FormErrors, UsernameNotValid);
				</cfscript>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.editprofile&FormRetry=True">
			</cfif>

			<cfquery name="getSelectedSchoolDistrict" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select OrganizationName, StateDOE_IDNumber
				From eMembership
				Where StateDOE_IDNumber = <cfqueryparam value="#FORM.Company#" cfsqltype="cf_sql_varchar"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="getOrigionalUserValues" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select fName, LName, Email, Company, JobTitle, mobilePhone
				From tusers
				Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfparam name="UserEditProfile" type="boolean" default="0">

			<cfif Session.FormData.fName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set fName = <cfqueryparam value="#Session.FormData.FName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.lName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set lName = <cfqueryparam value="#Session.FormData.LName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.Email NEQ getOrigionalUserValues.EMail>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set EMail = <cfqueryparam value="#Session.FormData.Email#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.Company NEQ getOrigionalUserValues.Company>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set Company = <cfqueryparam value="#getSelectedSchoolDistrict.OrganizationName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.JobTitle NEQ getOrigionalUserValues.JobTitle>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set JobTitle = <cfqueryparam value="#Session.FormData.JobTitle#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.mobilePhone NEQ getOrigionalUserValues.mobilePhone>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set mobilePhone = <cfqueryparam value="#Session.FormData.mobilePhone#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Variables.UserEditProfile EQ 1>
				<cfset Session.Mura.Company = #getSelectedSchoolDistrict.OrganizationName#>
				<cfset Session.Mura.fName = #Session.FormData.fName#>
				<cfset Session.Mura.lName = #Session.FormData.lName#>
				<cfset Session.Mura.Email = #Session.FormData.Email#>
				<cflocation addtoken="true" url="/?UserProfileUpdateSuccessfull=True">
			<cfelse>
				<cflocation addtoken="true" url="/?">
			</cfif>

		<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.FormRetry")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif not isDefined("Session.FormData.PluginInfo")>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cfif>

			<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.editprofile&FormRetry=True">
			</cfif>

			<cfif not isValid("email", FORM.Email)>
				<cfscript>
					UsernameNotValid = {property="Email",message="The Email Address is not a valid email address. We use this to lookup your account so that the correct information can be sent to you."};
					arrayAppend(Session.FormErrors, UsernameNotValid);
				</cfscript>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.editprofile&FormRetry=True">
			</cfif>

			<cfquery name="getSelectedSchoolDistrict" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select OrganizationName, StateDOE_IDNumber
				From eMembership
				Where StateDOE_IDNumber = <cfqueryparam value="#FORM.Company#" cfsqltype="cf_sql_varchar"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="getOrigionalUserValues" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select fName, LName, Email, Company, JobTitle, mobilePhone
				From tusers
				Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfparam name="UserEditProfile" type="boolean" default="0">

			<cfif Session.FormData.fName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set fName = <cfqueryparam value="#Session.FormData.FName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.lName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set lName = <cfqueryparam value="#Session.FormData.LName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.Email NEQ getOrigionalUserValues.EMail>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set EMail = <cfqueryparam value="#Session.FormData.Email#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.Company NEQ getOrigionalUserValues.Company>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set Company = <cfqueryparam value="#getSelectedSchoolDistrict.OrganizationName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.JobTitle NEQ getOrigionalUserValues.JobTitle>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set JobTitle = <cfqueryparam value="#Session.FormData.JobTitle#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.mobilePhone NEQ getOrigionalUserValues.mobilePhone>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
					Update tusers
					Set mobilePhone = <cfqueryparam value="#Session.FormData.mobilePhone#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Variables.UserEditProfile EQ 1>
				<cfset Session.Mura.Company = #getSelectedSchoolDistrict.OrganizationName#>
				<cfset Session.Mura.fName = #Session.FormData.fName#>
				<cfset Session.Mura.lName = #Session.FormData.lName#>
				<cfset Session.Mura.Email = #Session.FormData.Email#>
				<cflocation addtoken="true" url="/?UserProfileUpdateSuccessfull=True">
			<cfelse>
				<cflocation addtoken="true" url="/?">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="lostpassword" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

		<cfif isDefined("FORM.formSubmit") and not isDefined("form.formSendTemporaryPassword")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif not isDefined("Session.FormData.PluginInfo")>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cfif>

			<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.lostpassword&FormRetry=True">
			</cfif>

			<cfif not isValid("email", FORM.Email)>
				<cfscript>
					UsernameNotValid = {property="Email",message="The Email Address is not a valid email address. We use this to lookup your account so that the correct information can be sent to you."};
					arrayAppend(Session.FormErrors, UsernameNotValid);
				</cfscript>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.lostpassword&FormRetry=True">
			</cfif>

			<cfquery name="GetAccountUsername" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
				Select Fname, Lname, UserName, Email, created
				From tusers
				Where Email = <cfqueryparam value="#FORM.Email#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfif GetAccountUsername.RecordCount EQ 0>
				<cfscript>
					UsernameNotValid = {property="Email",message="The Email Address was not located within the database as a valid account. We use this to lookup your account so that the correct information can be sent to you."};
					arrayAppend(Session.FormErrors, UsernameNotValid);
				</cfscript>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.lostpassword&FormRetry=True">
			</cfif>

			<cfset Temp = #SendEmailCFC.SendLostPasswordVerifyFormToUser(FORM.Email)#>
			<cflocation addtoken="true" url="/?UserAccountPasswordVerify=True">
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.formSendTemporaryPassword")>
			<cfquery name="GetAccountUsername" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
				Select Fname, Lname, UserName, Email, created
				From tusers
				Where Email = <cfqueryparam value="#FORM.UserAccountEmail#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfif not isDefined("Session.FormData.PluginInfo")>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cfif>
			<cfif FORM.formSubmit EQ "true" and FORM.formSendTemporaryPassword EQ "true">
				<cfif FORM.SendTempPassword EQ 1>
					<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
								arrayAppend(Session.FormErrors, errormsg);
							</cfscript>
						</cflock>
						<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.lostpassword&FormRetry=True&Key=#FORM.Key#">
					</cfif>
					<cfset Temp = #SendEmailCFC.SendTemporaryPasswordToUser(FORM.UserAccountEmail)#>
					<cflocation addtoken="true" url="/?UserAccountPasswordSent=True">
				<cfelse>
					<cflocation addtoken="true" url="/?UserAccountNotModified=True">
				</cfif>
			</cfif>

		</cfif>
	</cffunction>


	<cffunction name="cancelregistration" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif not isDefined("Session.FormData.PluginInfo")>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cfif>

			<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.cancelregistration&FormRetry=True&EventID=#FORM.EventID#&RegistrationID=#FORM.RegistrationID#">
			</cfif>

			<cfswitch expression="#FORM.CancelEventOption#">
				<cfcase value="Yes">
					<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
					<cfset Info = StructNew()>
					<cfset Info.RegistrationID = #URL.RegistrationID#>
					<cfset Info.FormData = #StructCopy(Session.FormData.PluginInfo)#>
					<cfset temp = #SendEmailCFC.SendEventCancellationToSingleParticipant(Variables.Info)#>
					<cflocation url="/index.cfm?CancelEventSuccessfull=True" addtoken="false">
				</cfcase>
				<cfcase value="No">
					<cflocation addtoken="true" url="?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.default&CancelEventAborted=True">
				</cfcase>
			</cfswitch>
		</cfif>


	</cffunction>

	<cffunction name="getcertificate" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

	</cffunction>

	<cffunction name="manageregistrations" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.CancelEventID")>
			<cfif isNumeric(FORM.CancelEventID) EQ True>
				<cfquery name="GetRegisteredEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					SELECT eRegistrations.TContent_ID, eEvents.TContent_ID, eEvents.ShortTitle, eEvents.EventDate, eRegistrations.RequestsMeal, eEvents.PGPAvailable, eEvents.PGPPoints, eRegistrations.IVCParticipant, eRegistrations.AttendeePrice, eRegistrations.WebinarParticipant
					FROM eRegistrations INNER JOIN eEvents ON eEvents.TContent_ID = eRegistrations.EventID
					WHERE eRegistrations.Site_ID = <cfqueryparam value="#Session.Mura.SiteID#" cfsqltype="cf_sql_varchar"> AND
						eRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
						eEvents.TContent_ID = <cfqueryparam value="#FORM.CancelEventID#" cfsqltype="cf_sql_integer">
					ORDER BY eRegistrations.RegistrationDate DESC
				</cfquery>
				<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.cancelregistration&RegistrationID=#FORM.CancelEventID#">
			</cfif>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.ViewRegistrationID")>
			<cfif isNumeric(FORM.ViewRegistrationID) EQ True>
				<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.getregistration&formSubmit=true&RegistrationID=#FORM.ViewRegistrationID#" addtoken="false">
			</cfif>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.CertificatelEventID")>
			<cfif isNumeric(FORM.CertificatelEventID) EQ True>
				<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.getcertificate&formSubmit=true&CertificateEventID=#FORM.CertificatelEventID#" addtoken="false">
			</cfif>
		</cfif>

	</cffunction>

	<cffunction name="changepassword" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and isDefined("form.UserID")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif not isDefined("Session.FormData.PluginInfo")>
				<cfset Session.FormData.PluginInfo = StructNew()>
				<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
				<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
				<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
				<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
				<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
			</cfif>

			<cfquery name="getAccountPassword" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Username, fname, lname, password
				From tusers
				Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfif Application.serviceFactory.getBean("utility").checkBCryptHash(FORM.oldPassword,getAccountPassword.password) EQ true OR (Hash(form.oldPassword) eq getAccountPassword.password)>
				<cfif #HASH(FORM.HumanChecker)# NEQ FORM.HumanCheckerhash>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							errormsg = {property="HumanChecker",message="The Characters entered did not match what was displayed"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cflock>
					<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.changepassword&FormRetry=True">
				</cfif>

				<cfif FORM.newPassword NEQ FORM.newVerifyPassword>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							errormsg = {property="newPassword",message="The new desired password did not match the verify desired password. Both of these password fields must match in order to change your password."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cflock>
					<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.changepassword&FormRetry=True">
				</cfif>

				<cftry>
					<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
						Update tusers
						Set password = <cfqueryparam value="#Application.serviceFactory.getBean('utility').toBCryptHash(FORM.newPassword)#" cfsqltype="cf_sql_varchar">
						Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cflocation addtoken="true" url="/?UserPasswordChangeSuccessfull=True">
					<cfcatch type="any">
						<cflocation addtoken="true" url="/?UserPasswordChangeSuccessfull=False">
					</cfcatch>
				</cftry>
			<cfelse>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="oldPassword",message="The Current Password does not match what is stored in the database. Please try entering your current password again."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/index.cfm?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.changepassword&FormRetry=True">
			</cfif>

		</cfif>
	</cffunction>

</cfcomponent>