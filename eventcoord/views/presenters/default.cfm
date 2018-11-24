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
<cfset Session.Presenters = #StructNew()#>
<cfset GetAllGroups = #$.getBean( 'userManager' ).getUserGroups( rc.$.siteConfig('siteID'), 1 )#>
<cfloop query="GetAllGroups">
	<cfif GetAllGroups.GroupName EQ "Presenters">
		<cfset Session.Presenters.GroupID = #GetAllGroups.UserID#>
	</cfif>
</cfloop>

<cfif isDefined("FORM.FormSubmited")>
	<cfswitch expression="#FORM.SearchCriteria#">
		<cfcase value="LName">
			<cfquery name="getAllPresenters" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT tusers.UserID, tusers.Fname, tusers.Lname, tusers.UserName, tusers.Email, tusers.Company, tusersmemb.GroupID, tusers.SiteID
				FROM tusers INNER JOIN tusersmemb ON tusersmemb.UserID = tusers.UserID
				WHERE tusersmemb.GroupID = '#Session.Presenters.GroupID#' AND tusers.SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> AND
					tusers.S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					tusers.LName LIKE '%#FORM.SearchText#%'
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
		<cfcase value="FName">
			<cfquery name="getAllPresenters" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT tusers.UserID, tusers.Fname, tusers.Lname, tusers.UserName, tusers.Email, tusers.Company, tusersmemb.GroupID, tusers.SiteID
				FROM tusers INNER JOIN tusersmemb ON tusersmemb.UserID = tusers.UserID
				WHERE tusersmemb.GroupID = '#Session.Presenters.GroupID#' AND tusers.SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> AND
					tusers.S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					tusers.FName LIKE '%#FORM.SearchText#%'
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
		<cfcase value="Email">
			<cfquery name="getAllPresenters" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT tusers.UserID, tusers.Fname, tusers.Lname, tusers.UserName, tusers.Email, tusers.Company, tusersmemb.GroupID, tusers.SiteID
				FROM tusers INNER JOIN tusersmemb ON tusersmemb.UserID = tusers.UserID
				WHERE tusersmemb.GroupID = '#Session.Presenters.GroupID#' AND tusers.SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> AND
					tusers.S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					tusers.Email LIKE '%#FORM.SearchText#%'
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
		<cfcase value="Company">
			<cfquery name="getAllPresenters" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT tusers.UserID, tusers.Fname, tusers.Lname, tusers.UserName, tusers.Email, tusers.Company, tusersmemb.GroupID, tusers.SiteID
				FROM tusers INNER JOIN tusersmemb ON tusersmemb.UserID = tusers.UserID
				WHERE tusersmemb.GroupID = '#Session.Presenters.GroupID#' AND tusers.SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> AND
					tusers.S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer"> and
					tusers.Company LIKE '%#FORM.SearchText#%'
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
	</cfswitch>
<cfelse>
	<cfquery name="getAllPresenters" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		SELECT tusers.UserID, tusers.Fname, tusers.Lname, tusers.UserName, tusers.Email, tusers.Company, tusersmemb.GroupID, tusers.SiteID
		FROM tusers INNER JOIN tusersmemb ON tusersmemb.UserID = tusers.UserID
		WHERE tusersmemb.GroupID = '#Session.Presenters.GroupID#' AND tusers.SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> AND
			tusers.S2 = <cfqueryparam value="0" cfsqltype="cf_sql_integer">
		ORDER BY tusers.Lname ASC, tusers.Fname ASC
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
						<cfcase value="AddedCaterers">
							<div class="alert-box success">
								<p>You have successfully added a new caterer to the database.</p>
							</div>
						</cfcase>
						<cfcase value="UpdatedFacility">
							<div class="alert-box success">
								<p>You have successfully updated a caterer in the database.</p>
							</div>
						</cfcase>
						<cfcase value="DeleteFacility">
							<div class="alert-box success">
								<p>You have successfully removed a caterer from the database.</p>
							</div>
						</cfcase>
					</cfswitch>
				</cfif>
			</cfcase>
		</cfswitch>
	</cfif>
	<form class="form-search" method="post" action="">
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
				<td colspan="2" align="right"><button class="art-button" name="FormSubmited" type="submit" value="Search Users">Search Users</button></td>
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
				<th width="100">Actions</th>
			</tr>
		</thead>
		<cfif getAllPresenters.RecordCount>
			<tfoot>
				<tr>
					<td colspan="6">Add new Membership Organization not listed above by clicking <a href="#buildURL('eventcoord:membership.addorganization')#" class="art-button">here</a></td>
				</tr>
			</tfoot>
			<tbody>
				<cfloop query="getAllPresenters">
					<tr>
					<td>#getAllPresenters.LName#</td>
					<td>#getAllPresenters.FName#</td>
					<td>#getAllPresenters.UserName#</td>
					<td>#getAllPresenters.Email#</td>
					<td>#getAllPresenters.Company#</td>
					<td><a href="#buildURL('eventcoord:presenters.updateuser')#&PerformAction=Edit&RecNo=#getAllPresenters.UserID#" class="art-button">U</a>&nbsp;<a href="#buildURL('eventcoord:presenters.updateuser')#&PerformAction=Delete&RecNo=#getAllPresenters.UserID#" class="art-button">D</a></td>
					</tr>
				</cfloop>
			</tbody>
		<cfelse>
			<tbody>
				<tr>
					<td colspan="6" align="Center"><h4>No Presenters have been entered into this application. Please click <a class="art-button" href="#buildURL('eventcoord:users.adduser')#">here</a> to add a presenter to this system.</h4></td>
				</tr>
			</tbody>
		</cfif>
	</table>
</cfoutput>