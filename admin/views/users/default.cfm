<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>

<cfif isDefined("FORM.FormSubmited")>
	<cfif LEN(FORM.SearchText) EQ 0>
		<cfset StructDelete(FORM, "FormSubmited", "True")>
		<cfset StructDelete(FORM, "SearchCriteria", "True")>
		<cfset StructDelete(FORM, "SearchText", "True")>
	</cfif>
</cfif>

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
		</cfcase>
		<cfcase value="FName">
			<cfquery name="getAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, GroupName, FName, LName, UserName, Password, PasswordCreated, Email, Company, JobTitle, mobilePhone, Website, Type, subType, Ext, ContactForm, Admin, S2, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, Perm, InActive, isPublic, SiteID, Subscribe, Notes, Description, Interests, keepPrivate, created
				From tusers
				Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					FName LIKE '%#FORM.SearchText#%'
				Order by LName ASC, FName ASC
			</cfquery>
		</cfcase>
		<cfcase value="Email">
			<cfquery name="getAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, GroupName, FName, LName, UserName, Password, PasswordCreated, Email, Company, JobTitle, mobilePhone, Website, Type, subType, Ext, ContactForm, Admin, S2, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, Perm, InActive, isPublic, SiteID, Subscribe, Notes, Description, Interests, keepPrivate, created
				From tusers
				Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					Email LIKE '%#FORM.SearchText#%'
				Order by LName ASC, FName ASC
			</cfquery>
		</cfcase>
		<cfcase value="Company">
			<cfquery name="getAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, GroupName, FName, LName, UserName, Password, PasswordCreated, Email, Company, JobTitle, mobilePhone, Website, Type, subType, Ext, ContactForm, Admin, S2, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, Perm, InActive, isPublic, SiteID, Subscribe, Notes, Description, Interests, keepPrivate, created
				From tusers
				Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					Company LIKE '%#FORM.SearchText#%'
				Order by LName ASC, FName ASC
			</cfquery>
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
</cfif>

<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfset Session.FormErrors = #ArrayNew()#>
	<cfset Session.UserSuppliedInfo = #structNew()#>
</cflock>

<cfoutput>
	<cfif isDefined("URL.Successful")>
		<cfswitch expression="#URL.Successful#">
			<cfcase value="false">
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="ErrorDatabase">
						<div class="alert-box error">
							<p>An Error has occurred in the database. Please try your request again.</p>
						</div>
						<cfdump var="#Session#">
					</cfcase>
				</cfswitch>
			</cfcase>
			<cfcase value="true">
				<cfif isDefined("URL.UserAction")>
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="ChangePassword">
							<div class="alert-box success">
								<p>You have successfully updated the User Account's Password in the database.</p>
							</div>
						</cfcase>
						<cfcase value="UpdatedUser">
							<div class="alert-box success">
								<p>You have successfully updated the User Account in the database.</p>
							</div>
						</cfcase>
						<cfcase value="AddedUser">
							<div class="alert-box success">
								<p>You have successfully added a User Account to the database.</p>
							</div>
						</cfcase>
						<cfcase value="DeActivateAccount">
							<div class="alert-box success">
								<p>You have successfully deactivated the User Account in this system.</p>
							</div>
						</cfcase>
					</cfswitch>
				</cfif>
			</cfcase>
		</cfswitch>
	</cfif>
	<br />
	<form class="form-search" method="post" action="?#HTMLEditFormat(rc.pc.getPackage())#action=admin:users.default">
		<table class="art-article" style="width:100%;">
			<tr>
				<td>Search Criteria</td>
				<td><Select name="SearchCriteria"><option value="LName">Last Name</option><option value="FName">First Name</option><option value="Email">Email</option><option value="Company">Company</option></Select></td>
			</tr>
			<tr>
				<td>Search Terms</td>
				<td><input type="text" name="SearchText" class="input-medium search-query" maxlength="35" size="35"></td>
			</tr>
			<tr>
				<td colspan="2" align="right"><button class="btn btn-primary" name="FormSubmited" type="submit" value="Search Users">Search Users</button></td>
			</tr>
		</table>
	</form>
	<br>
	<table class="art-article" style="width:100%;">
		<thead>
			<tr>
				<th>Last Name</th>
				<th>First Name</th>
				<th>Username</th>
				<th>Email</th>
				<th>Company</th>
				<th>InActive</th>
				<th width="100">Actions</th>
			</tr>
		</thead>
		<cfif getAllUsers.RecordCount>
			<tfoot>
				<tr>
					<td colspan="7">Add a new user not listed in the table above, click <a href="#buildURL('admin:users.adduser')#&PerformAction=AddUser" class="art-button">here</a></td>
				</tr>
			</tfoot>
			<tbody>
				<cfloop query="getAllUsers">
					<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
					<td>#getAllUsers.LName#</td>
					<td>#getAllUsers.FName#</td>
					<td>#getAllUsers.UserName#</td>
					<td>#getAllUsers.Email#</td>
					<td>#getAllUsers.Company#</td>
					<td><cfswitch expression="#getAllUsers.InActive#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></td>
					<td><a href="#buildURL('admin:users.updateuser')#&PerformAction=Edit&RecNo=#getAllUsers.UserID#" class="art-button">U</a>&nbsp;<a href="#buildURL('admin:users.updateuser')#&PerformAction=Delete&RecNo=#getAllUsers.UserID#" class="art-button">D</a>&nbsp;<a href="#buildURL('admin:users.updateuser')#&PerformAction=LoginUser&RecNo=#getAllUsers.UserID#" class="art-button">L</a>&nbsp;<a href="#buildURL('admin:users.updateuser')#&PerformAction=ChangePassword&RecNo=#getAllUsers.UserID#" class="art-button">P</a></td>
					</tr>
				</cfloop>
			</tbody>
		<cfelse>
			<tbody>
				<tr>
					<td colspan="7"><div align="center" class="alert-box notice">No Users have been entered into this application. Please click <a class="art-button" href="#buildURL('admin:users.adduser')#&PerformAction=AddUser">here</a> to add user to this system.</div></td>
				</tr>
			</tbody>
		</cfif>
	</table>
</cfoutput>