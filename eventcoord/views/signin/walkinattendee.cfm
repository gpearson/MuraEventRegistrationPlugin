<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>

<cfif not isDefined("Session.FormData")>
	<cflock timeout="60" scope="SESSION" type="Exclusive">
		<cfset Session.FormData = #StructNew()#>
		<cfset Session.FormData.PluginInfo = StructNew()>
		<cfset Session.FormData.PluginInfo.Datasource = #rc.$.globalConfig('datasource')#>
		<cfset Session.FormData.PluginInfo.DBUserName = #rc.$.globalConfig('dbusername')#>
		<cfset Session.FormData.PluginInfo.DBPassword = #rc.$.globalConfig('dbpassword')#>
		<cfset Session.FormData.PluginInfo.PackageName = #HTMLEditFormat(rc.pc.getPackage())#>
		<cfset Session.FormData.PluginInfo.SiteID = #rc.$.siteConfig('siteID')#>
	</cflock>
</cfif>

<cfif #URLDecode(ListLast(ListFirst(ListLast(CGI.http_referer, "?"), "&"), "="))# EQ "signin.addattendee" and isDefined("URL.EventID") or 
	#URLDecode(ListLast(ListFirst(ListLast(CGI.http_referer, "?"), "&"), "="))# EQ "eventcoord:signin.addattendee" and isDefined("URL.EventID") or 
	#URLDecode(ListLast(ListFirst(ListLast(CGI.http_referer, "?"), "&"), "="))# EQ "eventcoord:signin.walkinattendee" and isDefined("URL.EventID")>
	<cfif not isDefined("FORM.FormErrors")>
		<cflock timeout="60" scope="SESSION" type="Exclusive">
			<cfset Session.FormErrors = #ArrayNew()#>
		</cflock>
	</cfif>
	
	<cfquery name="getEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4
		From eEvents
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
			TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order by EventDate ASC
	</cfquery>
	
	<cfset AvailableAttendees = #QueryNew("UserID,Fname,Lname,Company")#>
	<cfquery name="getAvailableAttendee" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select UserID, Fname, Lname, Company
		From tusers
		Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
			Type = <cfqueryparam value="2" cfsqltype="cf_sql_integer">
		Order by Company ASC, Lname ASC, Fname ASC
	</cfquery>
	
	<cfloop query="getAvailableAttendee">
		<cfquery name="checkAttendeeRegisteredForWorkshop" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select RegistrationID
			From eRegistrations
			Where UserID = <cfqueryparam value="#getAvailableAttendee.UserID#" cfsqltype="cf_sql_varchar"> and
				EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>
		
		<cfif checkAttendeeRegisteredForWorkshop.RecordCount>
		<cfelse>
			<cfset temp = QueryAddRow(Variables.AvailableAttendees, 1)>
			<cfset temp = #QuerySetCell(AvailableAttendees, "UserID", getAvailableAttendee.UserID)#>
			<cfset temp = #QuerySetCell(AvailableAttendees, "Fname", getAvailableAttendee.Fname)#>
			<cfset temp = #QuerySetCell(AvailableAttendees, "Lname", getAvailableAttendee.Lname)#>
			<cfset temp = #QuerySetCell(AvailableAttendees, "Company", getAvailableAttendee.Company)#>
		</cfif>
	</cfloop>
	
	<cfoutput>
		<div class="container-fluid">
			<div class="row-fluid">
			<div class="span12">
				<form class="form-inline" role="form" method="post" action="">
					<input type="hidden" name="formSubmit" value="true">
					<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<table class="table table-striped table-hover" cellspacing="0" cellpadding="0" width="95%">
					<thead>
						<tr>
							<td colspan="4"><h1 class="text-center">Attendee Electronic Signin Sheet<br><small>#getEvents.ShortTitle# on #DateFormat(getEvents.EventDate, "mmm dd, yyyy")#</small></h1></td>
						</tr>
					</thead>
					<tbody>
						<cfif AvailableAttendees.RecordCount>
							<cfloop query="AvailableAttendees">
								<cfset CurrentCellPos = #AvailableAttendees.CurrentRow# MOD 4>
								#Variables.CurrentCellPos#
								<cfswitch expression="#Variables.CurrentCellPos#">
									<cfcase value="1">
										<tr><td width="25%">
											<table class="table" cellspacing="0" cellpadding="0">
												<tr>
													<td width="75%">#AvailableAttendees.Lname#, #AvailableAttendees.Fname#</td>
													<td width="25%" align="center"><input type="checkbox" name="AttendeeUserID" value="#AvailableAttendees.UserID#"></td>
												</tr>
											</table>
											</td>
									</cfcase>
									<cfcase value="0">
										<td width="25%">
											<table class="table" cellspacing="0" cellpadding="0">
												<tr>
													<td width="75%">#AvailableAttendees.Lname#, #AvailableAttendees.Fname#</td>
													<td width="25%" align="center"><input type="checkbox" name="AttendeeUserID" value="#AvailableAttendees.UserID#"></td>
												</tr>
											</table>
										</td>
										</td></tr>
									</cfcase>
									<cfdefaultcase>
										<td width="25%">
											<table class="table" cellspacing="0" cellpadding="0">
												<tr>
													<td width="75%">#AvailableAttendees.Lname#, #AvailableAttendees.Fname#</td>
													<td width="25%" align="center"><input type="checkbox" name="AttendeeUserID" value="#AvailableAttendees.UserID#"></td>
												</tr>
											</table>
										</td>
									</cfdefaultcase>
								</cfswitch>
							</cfloop>
							<cfswitch expression="#Variables.CurrentCellPos#">
								<cfcase value="1">
									<td colspan="3" width="75%">&nbsp;</td>
								</cfcase>
								<cfcase value="2">
									<td colspan="2" width="50%">&nbsp;</td>
								</cfcase>
								<cfcase value="3">
									<td width="25%">&nbsp;</td>
								</cfcase>
								<cfdefaultcase>
									End: #Variables.CurrentCellPos#
								</cfdefaultcase>
							</cfswitch>
						</cfif>
						<tr>
							<td colspan="4"><button type="submit" name="RegisterWalkInAttendee" value="RegisterWalkInAttendee" class="btn btn-default btn-sm">Register WalkIn Attendee</button></td>
						</tr>
					</tbody>
				</table>
				</form>
			</div>
			</div>
		</div>			
	</cfoutput>
<cfelse>
	<cfoutput>
		#ListLast(ListFirst(ListLast(CGI.http_referer, "?"), "&"), "=")# <BR>
		#isDefined("URL.EventID")#
	</cfoutput>
	<cfabort>
	<cfif isDefined("URL.EventID")>
		<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:signin.addattendee&SiteID=#rc.$.siteConfig('siteID')#&EventID=#URL.EventID#" addtoken="false">	
	<cfelse>
		<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:main.default" addtoken="false">
	</cfif>
</cfif>