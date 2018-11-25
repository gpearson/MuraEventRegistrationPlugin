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

	<cffunction name="yearendofevents" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>

		<cfelseif isDefined("FORM.formSubmit")>
			<cfset GetYearlyEventsList = "">
			<cfset GetAllUsers = #QueryNew("User_ID,First_Name,Last_Name,Email_Address,EmailDomain")#>
			<cfset TotalRegistrations = 0>
			<cfquery name="tmpGetAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, Email, FName, LName
				From tusers
			</cfquery>
			<cfloop query="tmpGetAllUsers">
				<cfset temp=QueryAddRow(GetAllUsers,1)>
				<cfset temp = #QuerySetCell(GetAllUsers, "User_ID", tmpGetAllUsers.UserID)#>
				<cfset temp = #QuerySetCell(GetAllUsers, "First_Name", tmpGetAllUsers.FName)#>
				<cfset temp = #QuerySetCell(GetAllUsers, "Last_Name", tmpGetAllUsers.LName)#>
				<cfset temp = #QuerySetCell(GetAllUsers, "Email_Address", tmpGetAllUsers.Email)#>
				<cfset DomainSite = #LCase(Mid(tmpGetAllUsers.Email, Find("@", tmpGetAllUsers.Email, 1) + 1, 100))#>
				<cfset temp = #QuerySetCell(GetAllUsers, "EmailDomain", Variables.DomainSite)#>
			</cfloop>
			<cfset BeginDateYear = ListLast(FORM.YearBeginDate, "/")>
			<cfset BeginDateMonth = ListFirst(FORM.YearBeginDate, "/")>
			<cfset BeginDateDay = #ListGetAt(FORM.YearBeginDate, 2, "/")#>
			<cfset EndDateYear = ListLast(FORM.YearEndDate, "/")>
			<cfset EndDateMonth = ListFirst(FORM.YearEndDate, "/")>
			<cfset EndDateDay = #ListGetAt(FORM.YearEndDate, 2, "/")#>
			<cfset BegYearDate = #Variables.BeginDateYear# & "-" & #Variables.BeginDateMonth# & "-" & #Variables.BeginDateDay#>
			<cfset EndYearDate = #Variables.EndDateYear# & "-" & #Variables.EndDateMonth# & "-" & #Variables.EndDateDay#>
			<cfquery name="GetYearlyEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, MemberCost, NonMemberCost
				From eEvents
				Where EventDate BETWEEN '#Variables.BegYearDate#' and '#Variables.EndYearDate#' and EventCancelled = 0
				Order by EventDate ASC
			</cfquery>
			<cfset GetYearlyEventsList = #ValueList(GetYearlyEvents.TContent_ID, ",")#>
			<cfquery name="GetAllRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select EventID, User_ID, AttendedEvent
				From eRegistrations
				Where EventID IN (#Variables.GetYearlyEventsList#)
			</cfquery>
			<cfset YearlyEvents = StructNew()>
			<cfloop list="#GetYearlyEventsList#" index="EventID">
				<cfquery name="EventTitle" dbtype="query">Select * from GetYearlyEvents Where TContent_ID = #EventID#</cfquery>
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
				</cfif>
				<cfif GetRegistrations.RecordCount GTE 1>
					<cfquery name="GetEventIncomeExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Select Event_TotalIncomeFromParticipants, Event_TotalExpensesToHold, Event_CostPerParticipant, Event_TotalIncomeFromOtherParty
						From eEventsMatrix
						WHere Event_ID = #EventID#
					</cfquery>
					<cfset YearlyEvents[EventID] = StructNew() />
					<cfset YearlyEvents[EventID].EventInfo = "#EventTitle.ShortTitle# | #DateFormat(EventTitle.EventDate, "full")# | Registrations (#GetRegistrations.RecordCount#) | #DollarFormat(EventTitle.MemberCost)# | #DollarFormat(EventTitle.NonMemberCost)#">
					<cfif GetEventIncomeExpenses.RecordCount>
						<cfset YearlyEvents[EventID].TotalIncomeFromParticipants = #GetEventIncomeExpenses.Event_TotalIncomeFromParticipants#>
						<cfset YearlyEvents[EventID].TotalExpensesToHold = #GetEventIncomeExpenses.Event_TotalExpensesToHold#>
						<cfset YearlyEvents[EventID].TotalIncomeFromOtherParty = #GetEventIncomeExpenses.Event_TotalIncomeFromOtherParty#>
						<cfset YearlyEvents[EventID].ProfitPerParticipant = #GetEventIncomeExpenses.Event_CostPerParticipant#>
					<cfelse>
						<cfset YearlyEvents[EventID].TotalIncomeFromParticipants = 0>
						<cfset YearlyEvents[EventID].TotalExpensesToHold = 0>
						<cfset YearlyEvents[EventID].TotalIncomeFromOtherParty = 0>
						<cfset YearlyEvents[EventID].ProfitPerParticipant = 0>
					</cfif>

					<cfset TotalRegistrations = #Variables.TotalRegistrations# + #GetRegistrations.RecordCount#>
					<cfquery name="DistinctDomain" dbtype="query">Select Distinct EmailDomain from GetRegistrationUsers</cfquery>
					<cfset YearlyEvents[EventID].ParticipantInformation = #StructNew()#>
					<cfloop query="DistinctDomain">
						<cfquery name="RegistrationDomain" dbtype="query">Select * from GetRegistrationUsers Where EmailDomain = '#DistinctDomain.EmailDomain#' Order by LName</cfquery>
						<cfset YearlyEvents[EventID].ParticipantInformation[#DistinctDomain.EmailDomain#] = "Total #RegistrationDomain.RecordCount#" />
					</cfloop>
				<cfelse>
					<cfset YearlyEvents[EventID].EventInfo = "#EventTitle.ShortTitle# | #DateFormat(EventTitle.EventDate, "full")# | Registrations (#GetRegistrations.RecordCount#) | #DollarFormat(EventTitle.MemberCost)# | #DollarFormat(EventTitle.NonMemberCost)#">
				</cfif>
			</cfloop>
			<cfdump var="#YearlyEvents#"><cfabort>
		</cfif>
	</cffunction>


</cfcomponent>