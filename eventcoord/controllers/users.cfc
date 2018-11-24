/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.FormSubmited")>
			<cfswitch expression="#FORM.SearchCriteria#">
				<cfcase value="LName">
					<cfquery name="getAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID, GroupName, FName, LName, UserName, Password, PasswordCreated, Email, Company, JobTitle, mobilePhone, Website, Type, subType, Ext, ContactForm, Admin, S2, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, Perm, InActive, isPublic, SiteID, Subscribe, Notes, Description, Interests, keepPrivate, created
						From tusers
						Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							LName LIKE '%#FORM.SearchText#%'
						Order by LName ASC, FName ASC
					</cfquery>
					<cfset rc.Query = StructNew()>
					<cfset rc.Query = StructCopy(getAllUsers)>
					<cfreturn rc>
				</cfcase>
				<cfcase value="FName">
					<cfquery name="getAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID, GroupName, FName, LName, UserName, Password, PasswordCreated, Email, Company, JobTitle, mobilePhone, Website, Type, subType, Ext, ContactForm, Admin, S2, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, Perm, InActive, isPublic, SiteID, Subscribe, Notes, Description, Interests, keepPrivate, created
						From tusers
						Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							FName LIKE '%#FORM.SearchText#%'
						Order by LName ASC, FName ASC
					</cfquery>
					<cfset rc.Query = StructNew()>
					<cfset rc.Query = StructCopy(getAllUsers)>
					<cfreturn rc>
				</cfcase>
				<cfcase value="Email">
					<cfquery name="getAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID, GroupName, FName, LName, UserName, Password, PasswordCreated, Email, Company, JobTitle, mobilePhone, Website, Type, subType, Ext, ContactForm, Admin, S2, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, Perm, InActive, isPublic, SiteID, Subscribe, Notes, Description, Interests, keepPrivate, created
						From tusers
						Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Email LIKE '%#FORM.SearchText#%'
						Order by LName ASC, FName ASC
					</cfquery>
					<cfset rc.Query = StructNew()>
					<cfset rc.Query = StructCopy(getAllUsers)>
					<cfreturn rc>
				</cfcase>
				<cfcase value="Company">
					<cfquery name="getAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select UserID, GroupName, FName, LName, UserName, Password, PasswordCreated, Email, Company, JobTitle, mobilePhone, Website, Type, subType, Ext, ContactForm, Admin, S2, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, Perm, InActive, isPublic, SiteID, Subscribe, Notes, Description, Interests, keepPrivate, created
						From tusers
						Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
							Company LIKE '%#FORM.SearchText#%'
						Order by LName ASC, FName ASC
					</cfquery>
					<cfset rc.Query = StructNew()>
					<cfset rc.Query = StructCopy(getAllUsers)>
					<cfreturn rc>
				</cfcase>
			</cfswitch>
		<cfelse>
			<cfquery name="getAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, GroupName, FName, LName, UserName, Password, PasswordCreated, Email, Company, JobTitle, mobilePhone, Website, Type, subType, Ext, ContactForm, Admin, S2, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, Perm, InActive, isPublic, SiteID, Subscribe, Notes, Description, Interests, keepPrivate, created
				From tusers
				Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					LENGTH(FName) > 0 or
					SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					LENGTH(LName) > 0
					or SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					LENGTH(Username) > 0
				Order by LName ASC, FName ASC
			</cfquery>
			<cfset rc.Query = StructNew()>
			<cfset rc.Query = StructCopy(getAllUsers)>
			<cfreturn rc>
		</cfif>
	</cffunction>

	<cffunction name="adduser" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and not isDefined("FORM.ReSubmit")>
			<cfif isDefined("URL.PerformAction")>
				<cfswitch expression="#URL.PerformAction#">
					<cfcase value="AddUser">
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfset Session.FormData = #StructCopy(FORM)#>
							<cfset Session.UserSuppliedInfo = StructNew()>
							<cfset Session.UserSuppliedInfo.Fname = #FORM.Fname#>
							<cfset Session.UserSuppliedInfo.Lname = #FORM.Lname#>
							<cfset Session.UserSuppliedInfo.UserName = #FORM.UserName#>
							<cfset Session.UserSuppliedInfo.Email = #FORM.Email#>
							<cfset Session.UserSuppliedInfo.Company = #FORM.Company#>
							<cfset Session.UserSuppliedInfo.JobTitle = #FORM.JobTitle#>
							<cfset Session.UserSuppliedInfo.mobilePhone = #FORM.mobilePhone#>
							<cfif isDefined("FORM.Memberships")>
								<cfset Session.UserSuppliedInfo.Memberships = #FORM.Memberships#>
							</cfif>
						</cflock>

						<cfif not isValid("email", FORM.Email)>
							<cfscript>
								UsernameNotValid = {property="Email",message="The Email Address is not a valid email address. We use this email address as the communication method to get you information regarding events that you signup for."};
								arrayAppend(Session.FormErrors, UsernameNotValid);
							</cfscript>
							<cflocation url="/index.cfm?EventRegistrationaction=eventcoord:users.adduser&PerformAction=AddUser" addtoken="false">
						</cfif>

						<cfquery name="GetOrganizationName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select OrganizationName
							From eMembership
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
						<cfset NewUser.setEmail(FORM.Email)>

						<cfset AddNewAccount = #Application.userManager.save(NewUser)#>

						<cfif LEN(AddNewAccount.getErrors()) EQ 0>
							<cfif isDefined("FORM.Memberships")>
								<cfloop list="#FORM.Memberships#" index="i" delimiters=",">
									<cfquery name="insertUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into tusersmemb(UserID, GroupID)
										Values('#NewUser.getUserID()#', '#i#')
									</cfquery>
								</cfloop>
							</cfif>
						<cfelse>
							<cfdump var="#AddNewAccount.getErrors()#"><cfabort>
						</cfif>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users&UserAction=AddedUser&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
					</cfcase>
				</cfswitch>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="GetRoles" returntype="any" output="false">
		<cfargument name="RoleName" required="true" type="string" default="">
		<cfquery name="GetRole" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select UserID From tusers
			Where GroupName = <cfqueryparam value="#Arguments.RoleName#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfreturn GetRole.UserID>
	</cffunction>

	<cffunction name="updateuser" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit") and not isDefined("FORM.ReSubmit")>
			<cfif isDefined("URL.PerformAction")>
				<cfswitch expression="#URL.PerformAction#">
					<cfcase value="ChangePassword">
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfset Session.FormErrors = ArrayNew()>
							<cfset Session.FormData = #StructCopy(FORM)#>
							<cfset Session.UserSuppliedInfo = StructNew()>
							<cfset Session.UserSuppliedInfo.NewRecNo = #FORM.RecNo#>
							<cfif isDefined("FORM.Username")><cfset Session.UserSuppliedInfo.Username = #FORM.Username#></cfif>
							<cfif isDefined("FORM.Password")><cfset Session.UserSuppliedInfo.Password = #FORM.Password#></cfif>
							<cfif isDefined("FORM.VerifyPassword")><cfset Session.UserSuppliedInfo.VerifyPassword = #FORM.VerifyPassword#></cfif>
						</cflock>
						<cfset UpdateInfo = #StructNew()#>

						<cfif FORM.Password NEQ FORM.VerifyPassword>
							<cfscript>
								PasswordMisMatch = {property="Password",message="The Password and the Verify Password fields do not match. Please check these values you want for this user's account and try again.'"};
								arrayAppend(Session.FormErrors, PasswordMisMatch);
							</cfscript>
							<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:users.updateuser&PerformAction=ChangePassword&RecNo=#FORM.RecNo#" addtoken="false">
						<cfelse>
							<!--- Initiates the User Bean --->
							<cfset NewUser = #Application.userManager.readByUsername(form.Username, rc.$.siteConfig('siteID'))#>
							<CFSET NewUser.setPassword(FORM.Password)>
							<cfset NewUser.save()>
							<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:users&Successful=true&UserAction=ChangePassword" addtoken="false">
						</cfif>
					</cfcase>
					<cfcase value="Edit">
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfset Session.FormData = #StructCopy(FORM)#>
							<cfset Session.UserSuppliedInfo = StructNew()>
							<cfset Session.UserSuppliedInfo.NewRecNo = #FORM.RecNo#>
							<cfif isDefined("FORM.Fname")><cfset Session.UserSuppliedInfo.Fname = #FORM.Fname#></cfif>
							<cfif isDefined("FORM.Lname")><cfset Session.UserSuppliedInfo.Lname = #FORM.Lname#></cfif>
							<cfif isDefined("FORM.UserName")><cfset Session.UserSuppliedInfo.UserName = #FORM.UserName#></cfif>
							<cfif isDefined("FORM.Email")><cfset Session.UserSuppliedInfo.Email = #FORM.Email#></cfif>
							<cfif isDefined("FORM.JobTitle")><cfset Session.UserSuppliedInfo.JobTitle = #FORM.JobTitle#></cfif>
							<cfif isDefined("FORM.mobilePhone")><cfset Session.UserSuppliedInfo.mobilePhone = #FORM.mobilePhone#></cfif>
							<cfif isDefined("FORM.Company")><cfset Session.UserSuppliedInfo.Company = #FORM.Company#></cfif>
							<cfif isDefined("FORM.Memberships")><cfset Session.UserSuppliedInfo.Memberships = #FORM.Memberships#></cfif>
							<cfif isDefined("FORM.Active")><cfset Session.UserSuppliedInfo.Active = #FORM.Active#></cfif>
						</cflock>
						<cfset UpdateInfo = #StructNew()#>
						<cfquery name="getSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select UserID, Fname, Lname, UserName, Password, PasswordCreated, Email, Company, JobTitle, mobilePhone, Website, Type, subType, Ext, ContactForm, Admin, S2, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, Perm, InActive, isPublic, SiteID, Subscribe, notes, description, interests, keepPrivate, photoFileID, IMName, IMService, created, remoteID, tags, tablist, InActive
							From tusers
							Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
							Order by Lname ASC, Fname ASC
						</cfquery>
						<cfparam name="UpdateInfo.Fname" type="boolean" default="0">
						<cfparam name="UpdateInfo.Lname" type="boolean" default="0">
						<cfparam name="UpdateInfo.UserName" type="boolean" default="0">
						<cfparam name="UpdateInfo.Email" type="boolean" default="0">
						<cfparam name="UpdateInfo.JobTitle" type="boolean" default="0">
						<cfparam name="UpdateInfo.mobilePhone" type="boolean" default="0">
						<cfparam name="UpdateInfo.Company" type="boolean" default="0">
						<cfparam name="UpdateInfo.Active" type="boolean" default="0">

						<cfif getSelectedUser.Fname NEQ Form.Fname><cfset UpdateInfo.Fname = 1></cfif>
						<cfif getSelectedUser.Lname NEQ Form.Lname><cfset UpdateInfo.Lname = 1></cfif>
						<cfif getSelectedUser.UserName NEQ Form.UserName><cfset UpdateInfo.UserName = 1></cfif>
						<cfif getSelectedUser.Email NEQ Form.Email><cfset UpdateInfo.Email = 1></cfif>
						<cfif getSelectedUser.JobTitle NEQ Form.JobTitle><cfset UpdateInfo.JobTitle = 1></cfif>
						<cfif getSelectedUser.mobilePhone NEQ Form.mobilePhone><cfset UpdateInfo.mobilePhone = 1></cfif>
						<cfif getSelectedUser.Company NEQ Form.Company><cfset UpdateInfo.Company = 1></cfif>
						<cfif getSelectedUser.InActive NEQ Form.Active><cfset UpdateInfo.Active = 1></cfif>

						<cfif UpdateInfo.Fname EQ 1 OR UpdateInfo.Lname EQ 1 OR UpdateInfo.UserName EQ 1 OR UpdateInfo.Email EQ 1 OR UpdateInfo.JobTitle EQ 1 OR UpdateInfo.mobilePhone EQ 1 OR UpdateInfo.Active EQ 1>
							<cfif UpdateInfo.Fname EQ 1>
								<cfquery name="updateSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update tusers
									Set Fname = <cfqueryparam value="#Trim(Form.Fname)#" cfsqltype="cf_sql_varchar">
									Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>

							<cfif UpdateInfo.Lname EQ 1>
								<cfquery name="updateSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update tusers
									Set Lname = <cfqueryparam value="#Trim(Form.Lname)#" cfsqltype="cf_sql_varchar">
									Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>

							<cfif UpdateInfo.Username EQ 1>
								<cfquery name="updateSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update tusers
									Set UserName = <cfqueryparam value="#Trim(Form.UserName)#" cfsqltype="cf_sql_varchar">
									Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>

							<cfif UpdateInfo.Email EQ 1>
								<cfquery name="updateSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update tusers
									Set Email = <cfqueryparam value="#Trim(Form.Email)#" cfsqltype="cf_sql_varchar">
									Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>

							<cfif UpdateInfo.JobTitle EQ 1>
								<cfquery name="updateSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update tusers
									Set JobTitle = <cfqueryparam value="#Trim(Form.JobTitle)#" cfsqltype="cf_sql_varchar">
									Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>

							<cfif UpdateInfo.mobilePhone EQ 1>
								<cfquery name="updateSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update tusers
									Set mobilePhone = <cfqueryparam value="#Trim(Form.mobilePhone)#" cfsqltype="cf_sql_varchar">
									Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>

							<cfif UpdateInfo.Active EQ 1>
								<cfquery name="updateSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update tusers
									Set InActive = <cfqueryparam value="#Trim(Form.Active)#" cfsqltype="cf_sql_bit">
									Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
								</cfquery>
							</cfif>

							<cfquery name="getUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select GroupID
								From tusersmemb
								Where UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
							</cfquery>

							<cfif isDefined("FORM.Membership")>
								<cfif getUserMemberships.RecordCount NEQ ListLen(FORM.Memberships, ",")>
									<cfquery name="deleteUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from tusersmemb
										Where UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfloop list="#FORM.Memberships#" index="i" delimiters=",">
										<cfquery name="insertUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Insert into tusersmemb(UserID, GroupID)
											Values('#FORM.RecNo#', '#i#')
										</cfquery>
									</cfloop>
								</cfif>
							</cfif>

							<cfquery name="updateSelectedUserUpdateDate" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update tusers
								Set LastUpdate = #Now()#,
									LastUpdateBy = '#Session.Mura.Username#',
									LastUpdateByID = '#Session.Mura.UserID#'
								Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
							</cfquery>

							<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users&UserAction=UpdatedUser&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
						</cfif>

						<cfif UpdateInfo.Company EQ 1>
							<cfquery name="GetOrganizationName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select OrganizationName
								From eMembership
								Where StateDOE_IDNumber = #FORM.Company#
							</cfquery>

							<cfquery name="updateSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Update tusers
								Set Company = <cfqueryparam value="#Trim(GetOrganizationName.OrganizationName)#" cfsqltype="cf_sql_varchar">
								Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>

						<cfquery name="getUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select GroupID
							From tusersmemb
							Where UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
						</cfquery>

						<cfif not isDefined("FORM.Memberships")>
							<cfquery name="deleteUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Delete from tusersmemb
								Where UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfif>

						<cfif isDefined("FORM.Memberships")>
							<cfif getUserMemberships.RecordCount NEQ ListLen(FORM.Memberships, ",")>
								<cfquery name="deleteUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Delete from tusersmemb
									Where UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfloop list="#FORM.Memberships#" index="i" delimiters=",">
									<cfquery name="insertUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Insert into tusersmemb(UserID, GroupID)
										Values('#FORM.RecNo#', '#i#')
									</cfquery>
								</cfloop>
								<cfquery name="updateSelectedUserUpdateDate" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update tusers
									Set LastUpdate = #Now()#,
										LastUpdateBy = '#Session.Mura.Username#',
										LastUpdateByID = '#Session.Mura.UserID#'
									Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and UserID = <cfqueryparam value="#FORM.RecNo#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users&UserAction=UpdatedUser&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
							</cfif>
						</cfif>
						<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users" addtoken="false">
					</cfcase>
				</cfswitch>
			</cfif>
		</cfif>

		<cfif isDefined("URL.PerformAction")>
			<cfswitch expression="#URL.PerformAction#">
				<cfcase value="LoginUser">
					<cfset Session.MuraPreviousUser = #StructNew()#>
					<cfset Session.MuraPreviousUser = #StructCopy(Session.Mura)#>
					<cfset userLogin = application.serviceFactory.getBean("userUtility").loginByUserID("#URL.RecNo#", "#rc.$.siteConfig('siteID')#")>

					<cfif userLogin EQ true>
						<cflocation addtoken="true" url="/index.cfm">
					</cfif>
				</cfcase>
				<cfcase value="Delete">
					<cfquery name="updateUserRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update tusers
						Set inActive = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
						Where UserID = <cfqueryparam value="#URL.RecNo#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.default&Successful=true&UserAction=DeActivateAccount" addtoken="false">
				</cfcase>
			</cfswitch>
		</cfif>

		<cfif isDefined("FORM.formSubmit") and not isDefined("FORM.ReSubmit")>

		</cfif>
	</cffunction>
</cfcomponent>
