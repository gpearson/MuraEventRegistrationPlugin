<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

	</cffunction>

	<cffunction name="yearendreport" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.GetAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, Fname, LName, UserName, Email, SUBSTRING_INDEX(Email,"@",-1) AS Domain
				From tusers
			</cfquery>


		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormData = #StructCopy(FORM)#>
			<cfset Session.FormErrors = #ArrayNew()#>

			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:main.default" addtoken="false">
			</cfif>

			<cfif not isDate(FORM.BegYearDate)>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						address = {property="BusinessAddress",message="The Begin Year Date did not appear to be in a valid U.S. Date Format. Please check date and try again."};
						arrayAppend(Session.FormErrors, address);
					</cfscript>
				</cflock>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:reports.yearendreport&FormRetry=True">
			</cfif>

			<cfif not isDate(FORM.EndYearDate)>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						address = {property="BusinessAddress",message="The End Year Date did not appear to be in a valid U.S. Date Format. Please check date and try again."};
						arrayAppend(Session.FormErrors, address);
					</cfscript>
				</cflock>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:reports.yearendreport&FormRetry=True">
			</cfif>

			<cfset BegYearDate = #DateFormat(CreateDate(ListLast(FORM.BegYearDate, "/"), ListFirst(FORM.BegYearDate, "/"), ListGetAt(FORM.BegYearDate, 2, "/")), "yyyy-mm-dd")#>
			<cfset EndYearDate = #DateFormat(CreateDate(ListLast(FORM.EndYearDate, "/"), ListFirst(FORM.EndYearDate, "/"), ListGetAt(FORM.EndYearDate, 2, "/")), "yyyy-mm-dd")#>
			<cfset GetYearlyEventsList = "">
			<cfset TotalRegistrations = 0>
			<cfquery name="GetYearlyEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, MemberCost, NonMemberCost, EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, WebinarAvailable, WebinarMemberCost, WebinarNonMemberCost
				From p_EventRegistration_Events
				Where EventDate BETWEEN '#Variables.BegYearDate#' and '#Variables.EndYearDate#' and Active = 1
				Order by EventDate ASC
			</cfquery>
			<cfset GetYearlyEventsList = #ValueList(GetYearlyEvents.TContent_ID, ",")#>
			<cfquery name="GetAllRegistrationsInYearlyEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select User_ID, EventID, AttendeePrice, AttendedEventDate1, AttendedEventDate2, AttendedEventDate3, AttendedEventDate4, AttendedEventDate5, AttendedEventDate6, AttendedEventSessionAM, AttendedEventSessionPM, WebinarParticipant, IVCParticipant
				From p_EventRegistration_UserRegistrations
				Where EventID IN (#Variables.GetYearlyEventsList#)
			</cfquery>
			<cfset QueryForReport = StructCopy(GetYearlyEvents)>
			<cfset temp = StructClear(QueryForReport)>
			<cfset temp = QueryAddColumn(QueryForReport, "NumRegistrations")>
			<cfset temp = QueryAddColumn(QueryForReport, "User_ID")>
			<cfset temp = QueryAddColumn(QueryForReport, "Fname")>
			<cfset temp = QueryAddColumn(QueryForReport, "LName")>
			<cfset temp = QueryAddColumn(QueryForReport, "UserName")>
			<cfset temp = QueryAddColumn(QueryForReport, "Email")>
			<cfset temp = QueryAddColumn(QueryForReport, "Domain")>
			<cfset temp = QueryAddColumn(QueryForReport, "AttendeePrice")>
			<cfset temp = QueryAddColumn(QueryForReport, "AttendedEventDate1")>
			<cfset temp = QueryAddColumn(QueryForReport, "AttendedEventDate2")>
			<cfset temp = QueryAddColumn(QueryForReport, "AttendedEventDate3")>
			<cfset temp = QueryAddColumn(QueryForReport, "AttendedEventDate4")>
			<cfset temp = QueryAddColumn(QueryForReport, "AttendedEventDate5")>
			<cfset temp = QueryAddColumn(QueryForReport, "AttendedEventDate6")>
			<cfset temp = QueryAddColumn(QueryForReport, "AttendedEventSessionAM")>
			<cfset temp = QueryAddColumn(QueryForReport, "AttendedEventSessionPM")>
			<cfset temp = QueryAddColumn(QueryForReport, "WebinarParticipant")>
			<cfset temp = QueryAddColumn(QueryForReport, "IVCParticipant")>

			<cfloop list="#GetYearlyEventsList#" index="EventID">
				<cfquery name="EventTitle" dbtype="query">Select * from GetYearlyEvents Where TContent_ID = #EventID#</cfquery>
				<cfquery name="GetEventRegistrations" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select Count(User_ID) as NumRegistrations
					From p_EventRegistration_UserRegistrations
					Where EventID = #EventID#
				</cfquery>
				<cfset temp = QueryAddRow(QueryForReport, 1)>
				<cfset temp = QuerySetCell(QueryForReport, "NumRegistrations", GetEventRegistrations.NumRegistrations)>
				<cfset temp = QuerySetCell(QueryForReport, "TContent_ID", EventTitle.TContent_ID)>
				<cfset temp = QuerySetCell(QueryForReport, "ShortTitle", EventTitle.ShortTitle)>
				<cfset temp = QuerySetCell(QueryForReport, "EventDate", EventTitle.EventDate)>
				<cfset temp = QuerySetCell(QueryForReport, "EventDate1", EventTitle.EventDate1)>
				<cfset temp = QuerySetCell(QueryForReport, "EventDate2", EventTitle.EventDate2)>
				<cfset temp = QuerySetCell(QueryForReport, "EventDate3", EventTitle.EventDate3)>
				<cfset temp = QuerySetCell(QueryForReport, "EventDate4", EventTitle.EventDate4)>
				<cfset temp = QuerySetCell(QueryForReport, "EventDate5", EventTitle.EventDate5)>
				<cfset temp = QuerySetCell(QueryForReport, "MemberCost", EventTitle.MemberCost)>
				<cfset temp = QuerySetCell(QueryForReport, "NonMemberCost", EventTitle.NonMemberCost)>
				<cfset temp = QuerySetCell(QueryForReport, "EarlyBird_RegistrationAvailable", EventTitle.EarlyBird_RegistrationAvailable)>
				<cfset temp = QuerySetCell(QueryForReport, "EarlyBird_RegistrationDeadline", EventTitle.EarlyBird_RegistrationDeadline)>
				<cfset temp = QuerySetCell(QueryForReport, "EarlyBird_MemberCost", EventTitle.EarlyBird_MemberCost)>
				<cfset temp = QuerySetCell(QueryForReport, "EarlyBird_NonMemberCost", EventTitle.EarlyBird_NonMemberCost)>
				<cfset temp = QuerySetCell(QueryForReport, "WebinarAvailable", EventTitle.WebinarAvailable)>
				<cfset temp = QuerySetCell(QueryForReport, "WebinarMemberCost", EventTitle.WebinarMemberCost)>
				<cfset temp = QuerySetCell(QueryForReport, "WebinarNonMemberCost", EventTitle.WebinarNonMemberCost)>

				<cfquery name="GetEventAtendedRegistrations" dbtype="query">Select * from GetAllRegistrationsInYearlyEvents Where EventID = #EventID# and AttendedEventDate1 = 1 or EventID = #EventID# and AttendedEventDate2 = 1 or EventID = #EventID# and AttendedEventDate3 = 1 or EventID = #EventID# and AttendedEventDate4 = 1 or EventID = #EventID# and AttendedEventDate5 = 1 or EventID = #EventID# and AttendedEventDate6 = 1 or EventID = #EventID# and AttendedEventSessionAM = 1 or EventID = #EventID# and AttendedEventSessionPM = 1 Order by User_ID</cfquery>
				<cfif GetEventAtendedRegistrations.RecordCount>
					<cfloop query="GetEventAtendedRegistrations">
						<cfquery name="GetUserInfo" dbtype="query">Select * from Session.GetAllUsers Where UserID = '#GetEventAtendedRegistrations.User_ID#'</cfquery>

						<cfif GetEventAtendedRegistrations.CurrentRow EQ 1>
							<cfset temp = QuerySetCell(QueryForReport, "User_ID", GetEventAtendedRegistrations.User_ID)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendeePrice", GetEventAtendedRegistrations.AttendeePrice)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate1", GetEventAtendedRegistrations.AttendedEventDate1)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate2", GetEventAtendedRegistrations.AttendedEventDate2)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate3", GetEventAtendedRegistrations.AttendedEventDate3)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate4", GetEventAtendedRegistrations.AttendedEventDate4)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate5", GetEventAtendedRegistrations.AttendedEventDate5)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate6", GetEventAtendedRegistrations.AttendedEventDate6)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventSessionAM", GetEventAtendedRegistrations.AttendedEventSessionAM)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventSessionPM", GetEventAtendedRegistrations.AttendedEventSessionPM)>
							<cfset temp = QuerySetCell(QueryForReport, "WebinarParticipant", GetEventAtendedRegistrations.WebinarParticipant)>
							<cfset temp = QuerySetCell(QueryForReport, "IVCParticipant", GetEventAtendedRegistrations.IVCParticipant)>
							<cfset temp = QuerySetCell(QueryForReport, "FName", GetUserInfo.FName)>
							<cfset temp = QuerySetCell(QueryForReport, "LName", GetUserInfo.LName)>
							<cfset temp = QuerySetCell(QueryForReport, "UserName", GetUserInfo.UserName)>
							<cfset temp = QuerySetCell(QueryForReport, "Email", GetUserInfo.Email)>
							<cfset temp = QuerySetCell(QueryForReport, "Domain", GetUserInfo.Domain)>

						<cfelse>
							<cfset temp = QueryAddRow(QueryForReport, 1)>
							<cfset temp = QuerySetCell(QueryForReport, "NumRegistrations", GetEventRegistrations.NumRegistrations)>
							<cfset temp = QuerySetCell(QueryForReport, "TContent_ID", EventTitle.TContent_ID)>
							<cfset temp = QuerySetCell(QueryForReport, "ShortTitle", EventTitle.ShortTitle)>
							<cfset temp = QuerySetCell(QueryForReport, "EventDate", EventTitle.EventDate)>
							<cfset temp = QuerySetCell(QueryForReport, "EventDate1", EventTitle.EventDate1)>
							<cfset temp = QuerySetCell(QueryForReport, "EventDate2", EventTitle.EventDate2)>
							<cfset temp = QuerySetCell(QueryForReport, "EventDate3", EventTitle.EventDate3)>
							<cfset temp = QuerySetCell(QueryForReport, "EventDate4", EventTitle.EventDate4)>
							<cfset temp = QuerySetCell(QueryForReport, "EventDate5", EventTitle.EventDate5)>
							<cfset temp = QuerySetCell(QueryForReport, "MemberCost", EventTitle.MemberCost)>
							<cfset temp = QuerySetCell(QueryForReport, "NonMemberCost", EventTitle.NonMemberCost)>
							<cfset temp = QuerySetCell(QueryForReport, "EarlyBird_RegistrationAvailable", EventTitle.EarlyBird_RegistrationAvailable)>
							<cfset temp = QuerySetCell(QueryForReport, "EarlyBird_RegistrationDeadline", EventTitle.EarlyBird_RegistrationDeadline)>
							<cfset temp = QuerySetCell(QueryForReport, "EarlyBird_MemberCost", EventTitle.EarlyBird_MemberCost)>
							<cfset temp = QuerySetCell(QueryForReport, "EarlyBird_NonMemberCost", EventTitle.EarlyBird_NonMemberCost)>
							<cfset temp = QuerySetCell(QueryForReport, "WebinarAvailable", EventTitle.WebinarAvailable)>
							<cfset temp = QuerySetCell(QueryForReport, "WebinarMemberCost", EventTitle.WebinarMemberCost)>
							<cfset temp = QuerySetCell(QueryForReport, "WebinarNonMemberCost", EventTitle.WebinarNonMemberCost)>
							<cfset temp = QuerySetCell(QueryForReport, "User_ID", GetEventAtendedRegistrations.User_ID)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendeePrice", GetEventAtendedRegistrations.AttendeePrice)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate1", GetEventAtendedRegistrations.AttendedEventDate1)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate2", GetEventAtendedRegistrations.AttendedEventDate2)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate3", GetEventAtendedRegistrations.AttendedEventDate3)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate4", GetEventAtendedRegistrations.AttendedEventDate4)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate5", GetEventAtendedRegistrations.AttendedEventDate5)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventDate6", GetEventAtendedRegistrations.AttendedEventDate6)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventSessionAM", GetEventAtendedRegistrations.AttendedEventSessionAM)>
							<cfset temp = QuerySetCell(QueryForReport, "AttendedEventSessionPM", GetEventAtendedRegistrations.AttendedEventSessionPM)>
							<cfset temp = QuerySetCell(QueryForReport, "WebinarParticipant", GetEventAtendedRegistrations.WebinarParticipant)>
							<cfset temp = QuerySetCell(QueryForReport, "IVCParticipant", GetEventAtendedRegistrations.IVCParticipant)>
							<cfset temp = QuerySetCell(QueryForReport, "FName", GetUserInfo.FName)>
							<cfset temp = QuerySetCell(QueryForReport, "LName", GetUserInfo.LName)>
							<cfset temp = QuerySetCell(QueryForReport, "UserName", GetUserInfo.UserName)>
							<cfset temp = QuerySetCell(QueryForReport, "Email", GetUserInfo.Email)>
							<cfset temp = QuerySetCell(QueryForReport, "Domain", GetUserInfo.Domain)>
						</cfif>
					</cfloop>
				</cfif>
			</cfloop>
			<cfset LogoPath = ArrayNew(1)>
			<cfloop from="1" to="#QueryForReport.RecordCount#" step="1" index="i">
				<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_LogoSM.png")#>
			</cfloop>
			<cfset temp = QueryAddColumn(QueryForReport, "ImagePath", "VarChar", Variables.LogoPath)>
			<cfset Session.QueryForReport = StructCopy(QueryForReport)>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:reports.yearendreport&DisplayReport=True">

		</cfif>

	</cffunction>


</cfcomponent>