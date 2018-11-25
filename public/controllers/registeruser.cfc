/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="activateaccount" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("URL.Key")><cflocation url="/index.cfm" addtoken="false"></cfif>

		<cfif isDefined("URL.Key")>
			<cfset DecryptedURLString = #ToString(ToBinary(URL.Key))#>
			<cfset UserID = #ListFirst(Variables.DecryptedURLString, "&")#>
			<cfset DateSentCreated = #ListLast(Variables.DecryptedURLString, "&")#>

			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

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
						Set inActive = 0, LastUpdateBy = 'System', LastUpdateByID = '', LastUpdate = #Now()#
						Where UserID = <cfqueryparam value="#ListLast(Variables.UserID, '=')#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfcatch type="database">
						<cfdump var="#cfcatch#">
					</cfcatch>
				</cftry>
				<cfset SendActivationEmailConfirmation = #SendEmailCFC.SendAccountActivationEmailConfirmation(rc, ListLast(Variables.UserID, '='))#>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:main.default&UserAction=UserActivated&Successfull=true" addtoken="false">
			<cfelse>
				<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmail(rc, ListLast(Variables.UserID, '='))#>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:main.default&UserAction=UserActivated&Successfull=false" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSchoolDistricts" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select OrganizationName, StateDOE_IDNumber
				From p_EventRegistration_Membership
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				Order by OrganizationName
			</cfquery>
			<cfset Session.Captcha = #makeRandomString()#>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif FORM.Password NEQ FORM.VerifyPassword>
				<cfscript>
					InvalidPassword = {property="VerifyPassword",message="The Password and the Verify Password Fields do not match each other. Please make sure these fields match."};
					arrayAppend(Session.FormErrors, InvalidPassword);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:registeruser.default&FormRetry=True" addtoken="false">
			</cfif>

			<cfif not isValid("email", FORM.UserName)>
				<cfscript>
					UsernameNotValid = {property="UserName",message="The Email Address is not a valid email address. We use this email address as the communication method to get you information regarding events that you signup for."};
					arrayAppend(Session.FormErrors, UsernameNotValid);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:registeruser.default&FormRetry=True" addtoken="false">
			</cfif>

			<cfquery name="GetOrganizationName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select OrganizationName
				From p_EventRegistration_Membership
				Where StateDOE_IDNumber = #FORM.Company#
			</cfquery>

			<!--- Initiates the User Bean --->
			<cfset NewUser = #Application.userManager.readByUsername(form.Username, rc.$.siteConfig('siteID'))#>
			<cfset NewUser.setInActive(1)>
			<cfset NewUser.setSiteID(rc.$.siteConfig('siteID'))>
			<cfset NewUser.setFname(FORM.fName)>
			<cfset NewUser.setLname(FORM.lName)>
			<cfset NewUser.setCompany(GetOrganizationName.OrganizationName)>
			<cfset NewUser.setUsername(FORM.UserName)>
			<cfset NewUser.setMobilePhone(FORM.mobilePhone)>
			<cfset NewUser.setPassword(FORM.Password)>
			<cfset NewUser.setEmail(FORM.UserName)>

			<cfif NewUser.checkUsername() EQ "false">
				<!--- Username already exists within the database. --->
				<cfscript>
					UsernameExists = {property="UserName",message="The Email Address already exists within the database. If this Email Address is your account, you can request a forgot password by clicking on the Forgot Password Link under the Home Navigation Menu at the top of this screen. Otherwise please enter a different email address so your account can be created."};
					arrayAppend(Session.FormErrors, UsernameExists);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:registeruser.default&FormRetry=True" addtoken="false">
			</cfif>

			<cfset AddNewAccount = #Application.userManager.save(NewUser)#>

			<cfif LEN(AddNewAccount.getErrors()) EQ 0>
				<cfset NewUserID = #AddNewAccount.getUserID()#>

				<cfquery name="insertUserMatrixInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into p_EventRegistration_UserMatrix(User_ID,Site_ID,School_District,LastUpdateBy,LastUpdated) Values('#Variables.NewUserID#','#rc.$.siteConfig("siteID")#',#FORM.Company#,'System',#Now()#)
				</cfquery>

				<cfset SendActivationEmail = #SendEmailCFC.SendAccountActivationEmail(rc, Variables.NewUserID)#>
				<cflocation url="#CGI.Script_name##CGI.path_info#/?UserAction=UserRegistration&Successfull=true" addtoken="false">
			<cfelse>
				<cfdump var="#AddNewAccount.getErrors()#"><cfabort>
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