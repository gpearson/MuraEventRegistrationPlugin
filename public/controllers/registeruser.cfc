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
		<cfset GoogleReCaptchaCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/recaptcha")>

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSchoolDistricts" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select OrganizationName, StateDOE_IDNumber
				From p_EventRegistration_Membership
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				Order by OrganizationName
			</cfquery>
			<cfquery name="Session.getGradeLevels" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, GradeLevel
				From p_EventRegistration_GradeLevels
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				Order by GradeLevel
			</cfquery>
			<cfquery name="Session.getGradeSubjects" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, GradeSubject
				From p_EventRegistration_GradeSubjects
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				Order by GradeSubject
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

			<cfif StructKeyExists(form, 'g-recaptcha-response')>
				<cfset CheckCaptcha = #GoogleReCaptchaCFC.verifyResponse(secret='6Le6hw0UAAAAAMfQXFE5H3AJ4PnGmADX9v468d93',response=form['g-recaptcha-response'], remoteip=cgi.remote_add)#>
				<cfif CheckCaptcha.success EQ "false">
					<cfscript>
						InvalidPassword = {property="VerifyPassword",message="We have detected that the form was completed by a Computer Robot. We ask that this form be completed by a human being."};
						arrayAppend(Session.FormErrors, InvalidPassword);
					</cfscript>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:registeruser.default&FormRetry=True" addtoken="false">
				</cfif>
			</cfif>

			<cfquery name="GetOrganizationName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select StateDOE_IDNumber, OrganizationName
				From p_EventRegistration_Membership
				Where OrganizationDomainName = <cfqueryparam value="#Right(FORM.UserName, Len(FORM.UserName) - Find("@", FORM.UserName))#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<!--- Initiates the User Bean --->
			<cfset NewUser = #Application.userManager.readByUsername(form.Username, rc.$.siteConfig('siteID'))#>
			<cfset NewUser.setInActive(1)>
			<cfset NewUser.setSiteID(rc.$.siteConfig('siteID'))>
			<cfset NewUser.setFname(FORM.fName)>
			<cfset NewUser.setLname(FORM.lName)>
			<cfif GetOrganizationName.RecordCount><cfset NewUser.setCompany(GetOrganizationName.OrganizationName)></cfif>
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

				<cfif GetOrganizationName.RecordCount>
					<cfquery name="insertUserMatrixInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Insert into p_EventRegistration_UserMatrix(User_ID,Site_ID,School_District,created,LastUpdateBy,LastUpdated) Values('#Variables.NewUserID#','#rc.$.siteConfig("siteID")#',#GetOrganizationName.StateDOE_IDNumber#,#Now()#,'System',#Now()#)
					</cfquery>
				<cfelse>
					<cfquery name="insertUserMatrixInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Insert into p_EventRegistration_UserMatrix(User_ID,Site_ID,created,LastUpdateBy,LastUpdated) Values('#Variables.NewUserID#','#rc.$.siteConfig("siteID")#',#Now()#,'System',#Now()#)
					</cfquery>
				</cfif>

				<cfif FORM.GradeLevel NEQ "----">
					<cfquery name="updateUserMatrixGradeLevel" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_EventRegistration_UserMatrix
						Set TeachingGrade = <cfqueryparam value="#FORM.GradeLevel#" cfsqltype="cf_sql_integer">
						Where User_ID = <cfqueryparam value="#Variables.NewUserID#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>

				<cfif FORM.GradeSubjects NEQ "----">
					<cfquery name="updateUserMatrixGradeLevel" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update p_EventRegistration_UserMatrix
						Set TeachingSubjects = <cfqueryparam value="#FORM.GradeSubjects#" cfsqltype="cf_sql_integer">
						Where User_ID = <cfqueryparam value="#Variables.NewUserID#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>

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