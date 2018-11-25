/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
	</cffunction>

	<cffunction name="yearendreport" returntype="any" output="true">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif isDefined("FORM.formSubmit")>
			<cfswitch expression="#FORM.formSubmit#">
				<cfcase value="True">
					<cfset GetYearlyEventsList = "">
					<cfset GetAllUsers = #QueryNew("User_ID,First_Name,Last_Name,Email_Address,EmailDomain")#>
					<cfset TotalRegistrations = 0>
					<cfquery name="tmpGetAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select UserID, Email, FName, LName From tusers</cfquery>
					<cfloop query="tmpGetAllUsers">
						<cfset temp=QueryAddRow(GetAllUsers,1)>
						<cfset temp = #QuerySetCell(GetAllUsers, "User_ID", tmpGetAllUsers.UserID)#>
						<cfset temp = #QuerySetCell(GetAllUsers, "First_Name", tmpGetAllUsers.FName)#>
						<cfset temp = #QuerySetCell(GetAllUsers, "Last_Name", tmpGetAllUsers.LName)#>
						<cfset temp = #QuerySetCell(GetAllUsers, "Email_Address", tmpGetAllUsers.Email)#>
						<cfset DomainSite = #LCase(Mid(tmpGetAllUsers.Email, Find("@", tmpGetAllUsers.Email, 1) + 1, 100))#>
						<cfset temp = #QuerySetCell(GetAllUsers, "EmailDomain", Variables.DomainSite)#>
					</cfloop>
					<cfquery name="GetYearlyEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select TContent_ID, ShortTitle, EventDate, MemberCost, NonMemberCost From eEvents Where EventDate BETWEEN '#DateFormat(FORM.ReportStartDate, "yyyy-mm-dd")#' and '#DateFormat(FORM.ReportEndDate, "yyyy-mm-dd")#' Order by EventDate ASC</cfquery>
					<cfset GetYearlyEventsList = #ValueList(GetYearlyEvents.TContent_ID, ",")#>
					<cfquery name="GetAllRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select EventID, User_ID, AttendedEvent From eRegistrations Where EventID IN (#Variables.GetYearlyEventsList#)</cfquery>
					<cfset Session.YearlyEvents = ArrayNew(2)>
					<cfset RowCount = 1>
					<cfset Session.FormResponse = StructNew()>
					<cfset Session.FormResponse.Info = #FORM#>
					<cfloop list="#GetYearlyEventsList#" index="EventID">
						<cfquery name="EventTitle" dbtype="query">Select * from GetYearlyEvents Where TContent_ID = #EventID#</cfquery>
						<cfset Session.YearlyEvents[Variables.RowCount][1] = #EventTitle#>
						<cfquery name="GetRegistrations" dbtype="query">Select * from GetAllRegistrations Where EventID = #EventID# and AttendedEvent = 1 Order by User_ID</cfquery>
						<cfif GetRegistrations.RecordCount>
							<cfset GetRegistrationUsers = #QueryNew("UserID,FName,LName,Email,EmailDomain")#>
							<cfloop query="GetRegistrations">
								<cfquery name="GetUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select UserID, Email, FName, LName From tusers Where UserID = "#GetRegistrations.User_ID#"</cfquery>
								<cfset temp=QueryAddRow(GetRegistrationUsers,1)>
								<cfset temp = #QuerySetCell(GetRegistrationUsers, "UserID", GetUserInfo.UserID)#>
								<cfset temp = #QuerySetCell(GetRegistrationUsers, "FName", GetUserInfo.FName)#>
								<cfset temp = #QuerySetCell(GetRegistrationUsers, "LName", GetUserInfo.LName)#>
								<cfset temp = #QuerySetCell(GetRegistrationUsers, "Email", GetUserInfo.Email)#>
								<cfset DomainSite = #LCase(Mid(GetUserInfo.Email, Find("@", GetUserInfo.Email, 1) + 1, 100))#>
								<cfset temp = #QuerySetCell(GetRegistrationUsers, "EmailDomain", Variables.DomainSite)#>
							</cfloop>
							<cfset Session.YearlyEvents[Variables.RowCount][2] = #GetRegistrationUsers#>
						</cfif>
						<cfset RowCount = #Variables.RowCount# + 1>
					</cfloop>
					<cfquery name="GetAllUniqueRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select User_ID
						From eRegistrations
						Where EventID IN (#Variables.GetYearlyEventsList#) and AttendedEvent = 1
						Group by User_ID
						Order By User_ID
					</cfquery>
					<cfset Session.UniqueRegistrations = #GetAllUniqueRegistrations#>
					<cfreturn Session.YearlyEvents>
				</cfcase>
			</cfswitch>
		</cfif>
	</cffunction>


</cfcomponent>
