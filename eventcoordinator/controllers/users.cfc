<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="getUsers" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Select UserID, FName, LName, UserName, Company, LastLogin, LastUpdate, InActive, Created
					From tusers
					Where GroupName is null and Username is not null
					Order by LName ASC, FName ASC
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="getUsers" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Select UserID, FName, LName, UserName, Company, LastLogin, LastUpdate, InActive, Created
					From tusers
					Where GroupName is null and Username is not null
					Order by LName ASC, FName ASC
				</cfquery>
			</cfcase>
		</cfswitch>
		<cfset Session.getUsers = StructCopy(getUsers)>
	</cffunction>

	<cffunction name="getAllUsers" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrUsers = ArrayNew(1)>

		<cfif isDefined("URL._search")>
			<cfif URL._search EQ "false">
				<cfquery name="getUsers" dbtype="Query">
					Select UserID, LName, FName, UserName, Company, LastLogin, Created, InActive
					From Session.getUsers
					<cfif Arguments.sidx NEQ "">
						Order By #Arguments.sidx# #Arguments.sord#
					<cfelse>
						Order by LName ASC, FName ASC
					</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="getUsers" dbtype="Query">
					Select UserID, LName, FName, UserName, Company, LastLogin, Created, InActive
					From Session.getUsers
					<cfif Arguments.sidx NEQ "">
						<cfswitch expression="#URL.searchOper#">
							<cfcase value="eq">
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="cn">
								<!--- Contains --->
								Where #URL.searchField# LIKE '%#URL.searchString#%'
							</cfcase>
							<cfcase value="ne">
								<!--- Not Equal --->
								Where #URL.searchField# <> '#URL.searchString#'
							</cfcase>
							<cfcase value="bw">
								<!--- Begin With --->
								Where #URL.searchField# LIKE '#URL.searchString#%'
							</cfcase>
							<cfcase value="ew">
								<!--- Ends With --->
								Where #URL.searchField# LIKE '%#URL.searchString#'
							</cfcase>
							<cfcase value="cn">
								<!--- Contains --->
								Where #URL.searchField# LIKE '%#URL.searchString#%'
							</cfcase>


							<cfcase value="bn">
								<!--- Does Not Begin With  --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="en">
								<!--- Does Not End With --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="nc">
								<!--- Does Not Contain --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="nu">
								<!--- Is Null --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="nn">
								<!--- Is Not Null --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="in">
								<!--- Is In --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="ni">
								<!--- Is Not In --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
						</cfswitch>
						Order By #Arguments.sidx# #Arguments.sord#
					</cfif>
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="getUsers" dbtype="Query">
				Select UserID, LName, FName, UserName, Company, LastLogin, Created, InActive
				From Session.getUsers
				<cfif Arguments.sidx NEQ "">
					Order By #Arguments.sidx# #Arguments.sord#
				<cfelse>
					Order by LName ASC, FName ASC
				</cfif>
			</cfquery>
		</cfif>

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

	<cffunction name="newuser" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getEventGroups" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select UserID, GroupName
				From tusers
				Where InActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> and GroupName Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%Event%">
				Order by GroupName ASC
			</cfquery>
			<cfset Session.getEventGroups = StructCopy(getEventGroups)>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to User Management">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "GetEventGroups")>
				<cfset temp = StructDelete(Session, "GetUsers")>
				<cfif isDefined("Session.getMembership")><cfset temp = StructDelete(Session, "getMembership")></cfif>
				<cfif isDefined("Session.getCaterers")><cfset temp = StructDelete(Session, "getCaterers")></cfif>
				<cfif isDefined("Session.getFacilities")><cfset temp = StructDelete(Session, "getFacilities")></cfif>

				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.default" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.default" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.InActive EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select if this account holder's account is active or not"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.Password) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.VerifyPassword) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Verify Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif FORM.Password NEQ FORM.VerifyPassword>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field and the Verify Password Field did not match. Please check these fields and try to submit this request again."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif not isValid("email", FORM.Email)>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid email address for this user account."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.FName) LT 3>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the users first name for their account. This will be used on all emails, certificates, signin sheets, etc."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.LName) LT 3>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the users last name for their account. This will be used on all emails, certificates, signin sheets."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<!--- Initiates the User Bean --->
			<cfset userRecord = $.getBean('user').loadBy(username='#FORM.Email#', siteid='#$.siteConfig("siteid")#')>
			<cfset temp = #userRecord.set('siteid', $.siteConfig("siteid"))#>
			<cfset temp = #userRecord.set('fname', '#Trim(FORM.FName)#')#>
			<cfset temp = #userRecord.set('lname', '#Trim(FORM.LName)#')#>
			<cfset temp = #userRecord.set('username', '#Trim(FORM.Email)#')#>
			<cfset temp = #userRecord.set('email', '#Trim(FORM.Email)#')#>
			<cfset temp = #userRecord.set('InActive', FORM.InActive)#>
			<cfset temp = #userRecord.set('jobtitle', '#Trim(FORM.JobTitle)#')#>
			<cfset temp = #userRecord.set('organization', '#Trim(FORM.Company)#')#>
			<cfset temp = #userRecord.set('mobilePhone', '#Trim(FORM.mobilePhone)#')#>
			<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
			<cfset temp = #userRecord.set('lastupdateby', '#Session.Mura.Fname# #Session.Mura.LName#')#>
			<cfset temp = #userRecord.set('lastupdatebyid', '#Session.Mura.UserID#')#>
			<cfset temp = #userRecord.setPasswordNoCache('#FORM.VerifyPassword#')#>

			<cfif userRecord.checkUsername() EQ "false">
			 	<cfdump var="#Variables.userRecord#" abort="true">
          	<cfelse>
          		<cfset AddNewAccount = #userRecord.save()#>
          		<cfif LEN(AddNewAccount.getErrors()) EQ 0>
          			<cfif isDefined("FORM.MemberGroup")>
          				<cfloop list="#FORM.MemberGroup#" index="i" delimiters=",">
          					<cfquery name="insertUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
          						Insert into tusersmemb(UserID, GroupID)
          						Values('#NewUser.getUserID()#', '#i#')
          					</cfquery>
          				</cfloop>
          			</cfif>
          		<cfelse>
          			<cfdump var="#AddNewAccount.getErrors()#"><cfabort>
          		</cfif>
          	</cfif>
          	<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.default&UserAction=AccountCreated&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.default&UserAction=AccountCreated&Successful=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="edituser" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getSelectedUser" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select Fname, Lname, UserName, Email, Company, JobTitle, mobilePhone, Website, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, InActive
				From tusers
				Where UserID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.UserID#">
			</cfquery>
			<cfquery name="getEventGroups" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select UserID, GroupName
				From tusers
				Where InActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> and GroupName Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%Event%">
				Order by GroupName ASC
			</cfquery>
			<cfset Session.getSelectedUser = StructCopy(getSelectedUser)>
			<cfset Session.getEventGroups = StructCopy(getEventGroups)>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to User Management">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "GetEventGroups")>
				<cfset temp = StructDelete(Session, "GetSelectedUser")>
				<cfset temp = StructDelete(Session, "GetUsers")>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.default" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.default" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif FORM.UserAction EQ "Change Password">
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.changepswd" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.changepswd" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.UserAction EQ "Activate Account">
				<cfset userRecord = $.getBean('user').loadBy(username='#FORM.UserName#', siteid='#$.siteConfig("siteid")#')>
				<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
				<cfset temp = #userRecord.set('lastupdateby', '#Session.Mura.Fname# #Session.Mura.LName#')#>
				<cfset temp = #userRecord.set('lastupdatebyid', '#Session.Mura.UserID#')#>
				<cfset temp = #userRecord.set('InActive', 0)#>
				<cfset AddNewAccount = #userRecord.save()#>
				<cfif LEN(AddNewAccount.getErrors()) EQ 0>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&UserID=#Session.FormInput.UserID#&UserAction=UserAccountActivated&Successful=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&UserID=#Session.FormInput.UserID#&UserAction=UserAccountActivated&Successful=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				<cfelse>
          			<cfdump var="#AddNewAccount.getErrors()#"><cfabort>
          		</cfif>
			</cfif>

			<cfif FORM.UserAction EQ "Login As User">
				<!--- 
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset Session.MuraPreviousUser = #StructNew()#>
					<cfset Session.MuraPreviousUser = #StructCopy(Session.Mura)#>
					<cfset userLogin = application.serviceFactory.getBean("userUtility").loginByUserID("#URL.UserID#", "#rc.$.siteConfig('siteID')#")>

					<cfif userLogin EQ true>
						<cflocation addtoken="true" url="/index.cfm">
					</cfif>
				</cflock>
				--->
			</cfif>
			<cfif FORM.InActive EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Account Holder's Account is InActive or Not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.FName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the First Name of this new user account."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.LName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the Last Name of this new user account."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif not isValid("email", FORM.EMail)>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid email address for this user account."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfset userRecord = $.getBean('user').loadBy(username='#FORM.UserName#', siteid='#$.siteConfig("siteid")#')>
			<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
			<cfset temp = #userRecord.set('lastupdateby', '#Session.Mura.Fname# #Session.Mura.LName#')#>
			<cfset temp = #userRecord.set('lastupdatebyid', '#Session.Mura.UserID#')#>
			<cfset temp = #userRecord.set('InActive', FORM.Inactive)#>
			<cfset temp = #userRecord.set('fname', '#Trim(FORM.FName)#')#>
			<cfset temp = #userRecord.set('lname', '#Trim(FORM.LName)#')#>
			<cfset temp = #userRecord.set('email', '#Trim(FORM.Email)#')#>
			<cfset temp = #userRecord.set('organization', '#Trim(FORM.Company)#')#>
			<cfset temp = #userRecord.set('mobilePhone', '#Trim(FORM.mobilePhone)#')#>
			<cfset temp = #userRecord.set('jobtitle', '#Trim(FORM.JobTitle)#')#>
			<cfset AddNewAccount = #userRecord.save()#>
			<cfif LEN(AddNewAccount.getErrors()) EQ 0>
				<cfif isDefined("FORM.MemberGroup")>
					<cfquery name="getUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Select GroupID
						From tusersmemb
						Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif getUserMemberships.RecordCount NEQ ListLen(FORM.MemberGroup, ",")>
						<cfquery name="deleteUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Delete from tusersmemb
							Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfloop list="#FORM.MemberGroup#" index="i" delimiters=",">
							<cfquery name="insertUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Insert into tusersmemb(UserID, GroupID)
								Values('#FORM.UserID#', '#i#')
							</cfquery>
						</cfloop>
					<cfelse>
						<cfloop list="#FORM.MemberGroup#" index="i" delimiters=",">
							<cfquery name="checkUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select GroupID
								From tusersmemb
								Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and
									GroupID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif checkUserMemberships.RecordCount EQ 0>
								<cfquery name="insertUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Insert into tusersmemb(UserID, GroupID)
									Values('#FORM.UserID#', '#i#')
								</cfquery>
							</cfif>
						</cfloop>
					</cfif>
				<cfelse>
          			<cfquery name="getUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Select GroupID
						From tusersmemb
						Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif getUserMemberships.RecordCount>
						<cfquery name="deleteUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Delete from tusersmemb
							Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfif>
				</cfif>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.default&UserID=#Session.FormInput.UserID#&UserAction=UserAccountUpdated&Successful=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.default&UserID=#Session.FormInput.UserID#&UserAction=UserAccountUpdated&Successful=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
          	<cfelse>
          		<cfdump var="#AddNewAccount.getErrors()#"><cfabort>
          	</cfif>
		</cfif>
	</cffunction>

	<cffunction name="changepswd" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getSelectedUser" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select Fname, Lname, UserName, Email, Company, JobTitle, mobilePhone, Website, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, InActive
				From tusers
				Where UserID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.UserID#">
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to User Management">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&UserID=#Session.FormInput.UserID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&UserID=#Session.FormInput.UserID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.Password) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.changepswd&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.changepswd&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.VerifyPassword) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Verify Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.changepswd&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.changepswd&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif FORM.Password NEQ FORM.VerifyPassword>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field and the Verify Password Field did not match. Please check these fields and try to submit this request again."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.changepswd&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.changepswd&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<!--- Initiates the User Bean --->
			<cfset userRecord = $.getBean('user').loadBy(username='#FORM.UserName#', siteid='#$.siteConfig("siteid")#')>
			<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
			<cfset temp = #userRecord.set('lastupdateby', '#Session.Mura.Fname# #Session.Mura.LName#')#>
			<cfset temp = #userRecord.set('lastupdatebyid', '#Session.Mura.UserID#')#>
			<cfset temp = #userRecord.setPasswordNoCache('#FORM.VerifyPassword#')#>
			<cfset AddNewAccount = #userRecord.save()#>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&UserID=#Session.FormInput.UserID#&UserAction=AccountPasswordChanged&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:users.edituser&UserID=#Session.FormInput.UserID#&UserAction=AccountPasswordChanged&Successful=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
	</cffunction>
</cfcomponent>