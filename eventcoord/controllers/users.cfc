<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="Session.getUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select UserID, FName, LName, UserName, Company, LastLogin, LastUpdate, InActive, Created
					From tusers
					Where SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and GroupName is null and Username <> "admin"
					Order by LName ASC, FName ASC
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="Session.getUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select UserID, FName, LName, UserName, Company, LastLogin, LastUpdate, InActive, Created
					From tusers
					Where SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and GroupName is null
					Order by LName ASC, FName ASC
				</cfquery>
			</cfcase>
		</cfswitch>
	</cffunction>

	<cffunction name="getAllUsers" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrUsers = ArrayNew(1)>
		<cfquery name="getUsers" dbtype="Query">
			Select UserID, LName, FName, UserName, Company, LastLogin, Created, InActive
			From Session.getUsers
			<cfif Arguments.sidx NEQ "">
				Order By #Arguments.sidx# #Arguments.sord#
			<cfelse>
				Order by LName ASC, FName ASC
			</cfif>
		</cfquery>

		<!--- Calculate the Start Position for the loop query. So, if you are on 1st page and want to display 4 rows per page, for first page you start at: (1-1)*4+1 = 1.
				If you go to page 2, you start at (2-)1*4+1 = 5 --->
		<cfset start = ((arguments.page-1)*arguments.rows)+1>

		<!--- Calculate the end row for the query. So on the first page you go from row 1 to row 4. --->
		<cfset end = (start-1) + arguments.rows>

		<!--- When building the array --->
		<cfset i = 1>

		<cfloop query="getUsers" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfif #InActive# EQ 1>
				<cfset strActive = "Yes">
			<cfelse>
				<cfset strActive = "No">
			</cfif>
			<cfif getUsers.UserName NEQ "admin">
				<cfset arrUsers[i] = [#UserID#,#LName#,#FName#,#UserName#,#Company#,#LastLogin#,#Created#,#strActive#]>
				<cfset i = i + 1>
			</cfif>
		</cfloop>

		<!--- Calculate the Total Number of Pages for your records. --->
		<cfset totalPages = Ceiling(getUsers.recordcount/arguments.rows)>

		<!--- The JSON return.
			Total - Total Number of Pages we will have calculated above
			Page - Current page user is on
			Records - Total number of records
			rows = our data
		--->
		<cfset stcReturn = {total=#totalPages#,page=#Arguments.page#,records=#getUsers.recordcount#,rows=arrUsers}>
		<cfreturn stcReturn>
	</cffunction>

	<cffunction name="edituser" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Fname, Lname, UserName, Email, Company, JobTitle, mobilePhone, Website, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, InActive
				From tusers
				Where SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">  and
					UserID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.UserID#">
			</cfquery>
			<cfquery name="Session.getEventGroups" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, GroupName
				From tusers
				Where SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and InActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> and
					GroupName Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%Event%">
				Order by GroupName ASC
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getSelectedUser")>
				<cfset temp = StructDelete(Session, "getEventGroups")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.default" addtoken="false">
			</cfif>
			<cfif FORM.UserAction EQ "Change Password">
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.changepassword" addtoken="false">
			</cfif>
			<cfif FORM.UserAction EQ "Activate Account">
				<cfquery name="ActivateAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update tusers
					Set InActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0">
					Where UserID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.UserID#">
				</cfquery>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.default&UserAction=ActivatedAccount&Successful=True" addtoken="false">
			</cfif>

			<cfif FORM.InActive EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Account Holder's Account is InActive or Not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.edituser&FormRetry=True&UserID=#FORM.UserID#" addtoken="false">
			</cfif>

			<cfquery name="updateUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				update tusers
				Set FName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.FName#">,
					LName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.LName#">,
					Email = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.Email#">,
					Company = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.Company#">,
					JobTitle = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.JobTitle#">,
					mobilePhone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.mobilePhone#">,
					InActive = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.InActive#">,
					LastUpdate = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					LastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.FName# #Session.Mura.LName#">,
					LastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
				Where UserID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.UserID#">
			</cfquery>

			<cfif isDefined("FORM.MemberGroup")>
				<cfquery name="getUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select GroupID
					From tusersmemb
					Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif getUserMemberships.RecordCount NEQ ListLen(FORM.MemberGroup, ",")>
					<cfquery name="deleteUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Delete from tusersmemb
						Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfloop list="#FORM.MemberGroup#" index="i" delimiters=",">
						<cfquery name="insertUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Insert into tusersmemb(UserID, GroupID)
							Values('#FORM.UserID#', '#i#')
						</cfquery>
					</cfloop>
				<cfelse>
					<cfloop list="#FORM.MemberGroup#" index="i" delimiters=",">
						<cfquery name="checkUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select GroupID
							From tusersmemb
							Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and
								GroupID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfif checkUserMemberships.RecordCount EQ 0>
							<cfquery name="insertUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Insert into tusersmemb(UserID, GroupID)
								Values('#FORM.UserID#', '#i#')
							</cfquery>
						</cfif>
					</cfloop>
				</cfif>
			<cfelse>
				<cfquery name="getUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select GroupID
					From tusersmemb
					Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cfif getUserMemberships.RecordCount>
					<cfquery name="deleteUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Delete from tusersmemb
						Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
					</cfquery>
				</cfif>
			</cfif>

			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.default&UserAction=AccountUpdated&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="changepassword" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedUser" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Fname, Lname, UserName, Email, Company, JobTitle, mobilePhone, Website, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, InActive
				From tusers
				Where SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">  and
					UserID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.UserID#">
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.edituser&UserID=#FORM.UserID#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.Password) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.changepassword&FormRetry=True" addtoken="false">
			</cfif>
			<cfif LEN(FORM.VerifyPassword) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Verify Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.changepassword&FormRetry=True" addtoken="false">
			</cfif>
			<cfif FORM.Password NEQ FORM.VerifyPassword>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field and the Verify Password Field did not match. Please check these fields and try to submit this request again."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.changepassword&FormRetry=True" addtoken="false">
			</cfif>
			<!--- Initiates the User Bean --->
			<cfset NewUser = #Application.userManager.readByUsername(form.UserName, rc.$.siteConfig('siteID'))#>
			<CFSET NewUser.setPassword(FORM.Password)>
			<cfset NewUser.save()>

			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.edituser&UserID=#FORM.UserID#&UserAction=PasswordChanged&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="adduser" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getEventGroups" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, GroupName
				From tusers
				Where SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and InActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> and
					GroupName Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%Event%">
				Order by GroupName ASC
			</cfquery>

		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getCaterers")>
				<cfset temp = StructDelete(Session, "getSelectedCaterer")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.default" addtoken="false">
			</cfif>

			<cfif FORM.InActive EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Account Holder's Account is InActive or Not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.adduser&FormRetry=True" addtoken="false">
			</cfif>
			<cfif LEN(FORM.Password) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.adduser&FormRetry=True" addtoken="false">
			</cfif>
			<cfif LEN(FORM.VerifyPassword) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Verify Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.adduser&FormRetry=True" addtoken="false">
			</cfif>
			<cfif FORM.Password NEQ FORM.VerifyPassword>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field and the Verify Password Field did not match. Please check these fields and try to submit this request again."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.adduser&FormRetry=True" addtoken="false">
			</cfif>

			<!--- Initiates the User Bean --->
			<cfset NewUser = #Application.userManager.readByUsername(form.Email, rc.$.siteConfig('siteID'))#>
			<cfset NewUser.setInActive(FORM.InActive)>
			<cfset NewUser.setSiteID(rc.$.siteConfig('siteID'))>
			<cfset NewUser.setFname(FORM.FName)>
			<cfset NewUser.setLname(FORM.LName)>
			<cfset NewUser.setCompany(FORM.Company)>
			<CFSET NewUser.setPassword(FORM.Password)>
			<cfset NewUser.setUsername(FORM.Email)>
			<cfset NewUser.setMobilePhone(FORM.mobilePhone)>
			<cfset NewUser.setEmail(FORM.Email)>
			<cfset AddNewAccount = #Application.userManager.save(NewUser)#>

			<cfif LEN(AddNewAccount.getErrors()) EQ 0>
				<cfif isDefined("FORM.MemberGroup")>
					<cfloop list="#FORM.MemberGroup#" index="i" delimiters=",">
						<cfquery name="insertUserMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Insert into tusersmemb(UserID, GroupID)
							Values('#NewUser.getUserID()#', '#i#')
						</cfquery>
					</cfloop>
				</cfif>
			<cfelse>
				<cfdump var="#AddNewAccount.getErrors()#"><cfabort>
			</cfif>

			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.default&UserAction=AccountCreated&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

</cfcomponent>