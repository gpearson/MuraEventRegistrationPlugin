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
		<cfcase value="EventDate">
			<cfquery name="getEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4
				From eEvents
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					EventDate = <cfqueryparam value="#DateFormat(FORM.SearchText, 'yyyy-mm-dd')#" cfsqltype="cf_sql_varchar"> or
					
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					EventDate1 = <cfqueryparam value="#DateFormat(FORM.SearchText, 'yyyy-mm-dd')#" cfsqltype="cf_sql_varchar"> or
					
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					EventDate2 = <cfqueryparam value="#DateFormat(FORM.SearchText, 'yyyy-mm-dd')#" cfsqltype="cf_sql_varchar"> or
					
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					EventDate3 = <cfqueryparam value="#DateFormat(FORM.SearchText, 'yyyy-mm-dd')#" cfsqltype="cf_sql_varchar"> or
					
					Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					EventDate4 = <cfqueryparam value="#DateFormat(FORM.SearchText, 'yyyy-mm-dd')#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfcase>
		<cfcase value="ShortTitle">
			<cfquery name="getEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4
				From eEvents
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					ShortTitle LIKE '%#FORM.SearchText#%'
				Order by EventDate ASC
			</cfquery>
		</cfcase>
	</cfswitch>
<cfelse>
	<cfquery name="getEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4
		From eEvents
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
			EventDate = <cfqueryparam value="#DateFormat(Now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_varchar">
		Order by EventDate ASC
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
						<div class="alert alert-error">
							<p>An Error has occurred in the database. Please try your request again.</p>
						</div>
						<cfdump var="#Session#">
					</cfcase>
				</cfswitch>
			</cfcase>
			<cfcase value="true">
				<cfif isDefined("URL.UserAction")>
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="UpdatedUser">
							<div class="alert alert-success">
								<p>You have successfully updated the User Account in the database.</p>
							</div>
						</cfcase>
						<cfcase value="AddedUser">
							<div class="alert alert-success">
								<p>You have successfully added a User Account to the database.</p>
							</div>
						</cfcase>
					</cfswitch>
				</cfif>
			</cfcase>
		</cfswitch>
	</cfif>
	<br />
	<div class="row-fluid">
		<div class="span12">
			<form class="form-search" method="post" action="">
				<table class="table table-striped" cellspacing="0" cellpadding="0">
					<tr>
						<td>Search Criteria</td>
						<td><Select name="SearchCriteria"><option value="EventDate">Event Date</option><option value="ShortTitle">Event Title</option></Select></td>
					</tr>
					<tr>
						<td>Search Terms</td>
						<td><input type="text" name="SearchText" class="input-medium search-query" maxlength="35" size="35"></td>
					</tr>
					<tr>
						<td colspan="2" align="right"><button class="btn btn-primary" name="FormSubmited" type="submit" value="Search Users">Search Events</button></td>
					</tr>
				</table>
			</form>
			<br>
			<table class="table table-striped table-hover" cellspacing="0" cellpadding="0">
				<thead>
					<tr>
						<th>Event Title</th>
						<th>Primary Event Date</th>
						<th>Attendee Signed Up</th>
						<th>Attendee Here</th>
						<th width="100">Actions</th>
					</tr>
				</thead>
				<tbody>
					<cfif getEvents.RecordCount>
						<cfloop query="getEvents">
							<cfquery name="getRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select Count(RegistrationID) as AttendeeRegistered
								From eRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#getEvents.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							
							<cfquery name="getAttendeeAtEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select Count(RegistrationID) as AttendeeOnSite
								From eRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#getEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									AttendedEvent = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
							</cfquery>
							
							<tr>
							<td>#getEvents.ShortTitle#</td>
							<td>#DateFormat(getEvents.EventDate, "mm-dd-yyyy")#</td>
							<td>#NumberFormat(getRegistrations.AttendeeRegistered, "99,999")#</td>
							<td>#NumberFormat(getAttendeeAtEvent.AttendeeOnSite, "99,999")#</td>
							<td><a href="#buildURL('admin:signin.addattendee')#&EventID=#getEvents.TContent_ID#" class="btn btn-success btn-sm">Sign In</a>
								
								<!--- <a href="#buildURL('admin:users.updateuser')#&PerformAction=Edit&RecNo=#getAllUsers.UserID#" class="btn btn-warning btn-small">U</a>&nbsp;<a href="#buildURL('admin:users.updateuser')#&PerformAction=Delete&RecNo=#getAllUsers.UserID#" class="btn btn-danger btn-small">D</a>&nbsp;<a href="#buildURL('admin:users.updateuser')#&PerformAction=LoginUser&RecNo=#getAllUsers.UserID#" class="btn btn-success btn-small">L</a> --->
							</td>
							</tr>
						</cfloop>	
					<cfelse>
						<tr>
							<td colspan="6" align="Center"><h4>No Events have been entered for this date. Please use the search form above to select either another date or a title of an event.</h4></td>
						</tr>			
					</cfif>
					
				</tbody>
			</table>
		</div>
	</div>
</cfoutput>