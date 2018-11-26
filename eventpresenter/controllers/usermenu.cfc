<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

	</cffunction>

	<cffunction name="editprofile" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getUserProfile" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select tusers.UserName, tusers.FName, tusers.Lname, tusers.Email, tusers.Company, tusers.JobTitle, tusers.mobilePhone, tusers.Website, tusers.LastLogin, tusers.LastUpdate, tusers.LastUpdateBy, tusers.LastUpdateByID, tusers.InActive, tusers.created, p_EventRegistration_UserMatrix.School_District, p_EventRegistration_UserMatrix.TeachingGrade, p_EventRegistration_UserMatrix.TeachingSubject, p_EventRegistration_UserMatrix.ReceiveMarketingFlyers
				From tusers INNER JOIN p_EventRegistration_UserMatrix ON p_EventRegistration_UserMatrix.User_ID = tusers.UserID
				Where tusers.UserID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
					tusers.SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
			</cfquery>
			<cfif getUserProfile.RecordCount EQ 0>
				<cfquery name="insertUserToUserMatrix" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into p_EventRegistration_UserMatrix(Site_ID, User_ID, created, lastUpdateBy, lastUpdated)
					Values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
						<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value="#Session.Mura.Fname# #Session.Mura.Lname#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
					)
				</cfquery>
				<cfquery name="getUserProfile" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select tusers.UserName, tusers.FName, tusers.Lname, tusers.Email, tusers.Company, tusers.JobTitle, tusers.mobilePhone, tusers.Website, tusers.LastLogin, tusers.LastUpdate, tusers.LastUpdateBy, tusers.LastUpdateByID, tusers.InActive, tusers.created, p_EventRegistration_UserMatrix.School_District, p_EventRegistration_UserMatrix.TeachingGrade, p_EventRegistration_UserMatrix.TeachingSubject, p_EventRegistration_UserMatrix.ReceiveMarketingFlyers
					From tusers INNER JOIN p_EventRegistration_UserMatrix ON p_EventRegistration_UserMatrix.User_ID = tusers.UserID
					Where tusers.UserID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
						tusers.SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
				</cfquery>
			</cfif>
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

			<cfset Session.getUserProfile = #StructCopy(getUserProfile)#>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "getUserProfile")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventpresenter:main.default" addtoken="false">
			</cfif>

			<cfif LEN(FORM.Password) OR LEN(FORM.VerifyPassword)>
				<cfif FORM.Password NEQ FORM.VerifyPassword>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							errormsg = {property="HumanChecker",message="The Password and Verify Password Fields did not match. Please correct."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cflock>
					<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventpresenter:usermenu.editprofile&FormRetry=True">
				<cfelse>
					<cfset NewUser = #Application.userManager.readByUsername(form.UserID, rc.$.siteConfig('siteID'))#>
					<cfset NewUser.setPassword(FORM.Password)>
					<cfset NewUser.setSiteID(rc.$.siteConfig('siteID'))>
					<cfset AddNewAccount = #Application.userManager.save(NewUser)#>
				</cfif>
			</cfif>

			<cfif FORM.ReceiveMarketingFlyers EQ "----">
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="Please select your option to receive upcoming marketing flyers that we send electronically."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventpresenter:usermenu.editprofile&FormRetry=True">
			</cfif>

			<cfquery name="getOrigionalUserValues" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select fName, LName, Email, Company, JobTitle, mobilePhone, website
				From tusers
				Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="getOrigionalUserMatrixValues" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TeachingGrade, TeachingSubject, ReceiveMarketingFlyers
				From p_EventRegistration_UserMatrix
				Where User_ID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfparam name="UserEditProfile" type="boolean" default="0">

			<cfif Session.FormData.fName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update tusers
					Set fName = <cfqueryparam value="#Session.FormData.FName#" cfsqltype="cf_sql_varchar">,
						lastUpdate = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="#Session.FormData.UserID#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.ReceiveMarketingFlyers NEQ getOrigionalUserMatrixValues.ReceiveMarketingFlyers>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_UserMatrix
					Set ReceiveMarketingFlyers = <cfqueryparam value="#FORM.ReceiveMarketingFlyers#" cfsqltype="cf_sql_bit">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">
					Where User_ID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.lName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update tusers
					Set lName = <cfqueryparam value="#Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdate = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="#Session.FormData.UserID#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.JobTitle NEQ getOrigionalUserValues.JobTitle>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update tusers
					Set JobTitle = <cfqueryparam value="#Session.FormData.JobTitle#" cfsqltype="cf_sql_varchar">,
						lastUpdate = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="#Session.FormData.UserID#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.mobilePhone NEQ getOrigionalUserValues.mobilePhone>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update tusers
					Set mobilePhone = <cfqueryparam value="#Session.FormData.mobilePhone#" cfsqltype="cf_sql_varchar">,
						lastUpdate = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="#Session.FormData.UserID#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.website NEQ getOrigionalUserValues.website>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update tusers
					Set website = <cfqueryparam value="#Session.FormData.website#" cfsqltype="cf_sql_varchar">,
						lastUpdate = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="#Session.FormData.UserID#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.GradeLevel NEQ "----" and  Session.FormData.GradeLevel NEQ getOrigionalUserMatrixValues.TeachingGrade>
				<cfset UserEditProfile = 1>
				<cfquery name="updateTeachingGrade" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_UserMatrix
					Set TeachingGrade = <cfqueryparam value="#Session.FormData.GradeLevel#" cfsqltype="cf_sql_integer">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.GradeSubjects NEQ "----" and  Session.FormData.GradeSubjects NEQ getOrigionalUserMatrixValues.TeachingSubject>
				<cfset UserEditProfile = 1>
				<cfquery name="updateTeachingSubject" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_UserMatrix
					Set TeachingSubject = <cfqueryparam value="#Session.FormData.GradeSubjects#" cfsqltype="cf_sql_integer">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Variables.UserEditProfile EQ 1>
				<cfset Session.Mura.fName = #Session.FormData.fName#>
				<cfset Session.Mura.lName = #Session.FormData.lName#>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventpresenter:main.default&UserAction=UserProfileUpdated">
			<cfelse>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventpresenter:main.default">
			</cfif>



		</cfif>
	</cffunction>

</cfcomponent>