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
						<cfcase value="ActivateAccount">
							<div class="alert-box success">
								<p>You have successfully activated the User Account in this system.</p>
							</div>
						</cfcase>
					</cfswitch>
				</cfif>
			</cfcase>
		</cfswitch>
	</cfif>
	<div class="art-blockheader">
		<h3 class="t">Search for Specific User Account</h3>
	</div>
	<form class="form-search" method="post" action="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:users.default">
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
	<div class="art-blockheader">
		<h3 class="t">List Available User Accounts</h3>
	</div>
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
		<cfif rc.Query.RecordCount>
			<tfoot>
				<tr>
					<td colspan="7">Add a new user not listed in the table above, click <a href="#buildURL('eventcoord:users.adduser')#&PerformAction=AddUser" class="art-button">here</a></td>
				</tr>
			</tfoot>
			<tbody>
				<cfloop query="rc.Query">
					<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
					<td>#rc.Query.LName#</td>
					<td>#rc.Query.FName#</td>
					<td>#rc.Query.UserName#</td>
					<td>#rc.Query.Email#</td>
					<td>#rc.Query.Company#</td>
					<td><cfswitch expression="#rc.Query.InActive#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></td>
					<td><a href="#buildURL('eventcoord:users.updateuser')#&PerformAction=Edit&RecNo=#rc.Query.UserID#" class="art-button">Update</a>&nbsp;
					<cfif rc.Query.InActive EQ 1>
						<a href="#buildURL('eventcoord:users.updateuser')#&PerformAction=Activate&RecNo=#rc.Query.UserID#" class="art-button">Activate</a>
					<cfelse>
						<a href="#buildURL('eventcoord:users.updateuser')#&PerformAction=Delete&RecNo=#rc.Query.UserID#" class="art-button">DeActivate</a>
					</cfif>
					&nbsp;<a href="#buildURL('eventcoord:users.updateuser')#&PerformAction=LoginUser&RecNo=#rc.Query.UserID#" class="art-button">Login As</a>&nbsp;<a href="#buildURL('eventcoord:users.updateuser')#&PerformAction=ChangePassword&RecNo=#rc.Query.UserID#" class="art-button">Pwd Change</a></td>
					</tr>
				</cfloop>
			</tbody>
		<cfelse>
			<tbody>
				<tr>
					<td colspan="7"><div align="center" class="alert-box notice">No Users have been entered into this application. Please click <a class="art-button" href="#buildURL('eventcoord:users.adduser')#&PerformAction=AddUser">here</a> to add user to this system.</div></td>
				</tr>
			</tbody>
		</cfif>
	</table>
</cfoutput>