<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

	</cffunction>

	<cffunction name="yearendreport" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="GetAllUsers" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, Fname, LName, UserName, Email, SUBSTRING_INDEX(Email,"@",-1) AS Domain
				From tusers
				Where GroupName is null
			</cfquery>

			<cfquery name="GetAllMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select OrganizationName, Active, OrganizationDomainName
				From p_EventRegistration_Membership
			</cfquery>

			<cfquery name="GetAllMembershipAgencies" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName
				From p_EventRegistration_StateESCOrganizations
			</cfquery>

			<cfset Session.QueryForReport = StructNew()>
			<cfset Session.QueryForReport.GetAllUsers = StructCopy(GetAllUsers)>
			<cfset Session.QueryForReport.GetAllMemberships = StructCopy(GetAllMemberships)>
			<cfset Session.QueryForReport.GetMembershipAgencies = StructCopy(GetAllMembershipAgencies)>
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
			<cfquery name="GetAllMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select OrganizationName, OrganizationDomainName, Active, StateDOE_ESCESAMembership
				From p_EventRegistration_Membership
				Where StateDOE_ESCESAMembership = #FORM.MembershipID#
				Order by OrganizationName ASC
			</cfquery>
			<cfquery name="GetYearlyEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, MemberCost, NonMemberCost, EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, WebinarAvailable, WebinarMemberCost, WebinarNonMemberCost, PGPAvailable, PGPPoints, Active, EventCancelled
				From p_EventRegistration_Events
				Where (EventDate BETWEEN '#Variables.BegYearDate#' and '#Variables.EndYearDate#') and EventCancelled = 0
				Order by EventDate ASC
			</cfquery>

			<cfset ReportQuery = ArrayNew(2)>
			<cfset ReportYearlyEvents = ArrayNew(2)>
			<cfloop query="GetAllMemberships">
				<cfset Variables.ReportQuery[GetAllMemberships.CurrentRow][1] = #GetAllMemberships.OrganizationName#>
				<cfset Variables.ReportQuery[GetAllMemberships.CurrentRow][2] = #GetAllMemberships.OrganizationDomainName#>
				<cfset Variables.ReportQuery[GetAllMemberships.CurrentRow][3] = 0>
			</cfloop>
			<cfloop query="GetYearlyEvents">
				<cfset Variables.ReportYearlyEvents[GetYearlyEvents.CurrentRow][1] = #GetYearlyEvents.TContent_ID#>
				<cfset Variables.ReportYearlyEvents[GetYearlyEvents.CurrentRow][2] = #GetYearlyEvents.ShortTitle#>
				<cfset Variables.ReportYearlyEvents[GetYearlyEvents.CurrentRow][3] = #GetYearlyEvents.EventDate#>
				<cfset Variables.ReportYearlyEvents[GetYearlyEvents.CurrentRow][4] = #GetYearlyEvents.CurrentRow# + 3>
				<cfset Variables.ReportYearlyEvents[GetYearlyEvents.CurrentRow][5] = #GetYearlyEvents.PGPAvailable#>
				<cfset Variables.ReportYearlyEvents[GetYearlyEvents.CurrentRow][6] = #GetYearlyEvents.PGPPoints#>
			</cfloop>

			<cfset eRecord = 1>
						
			<cfloop array="#Variables.ReportYearlyEvents#" index="e" from="1" to="#ArrayLen(Variables.ReportYearlyEvents)#">
				<cfset sRecord = 1>
				<cfloop array="#Variables.ReportQuery#" index="s" from="1" to="#ArrayLen(Variables.ReportQuery)#">
					<cftry>
						<cfquery name="GetCorporationAttendeesByEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Select p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM, tusers.Fname, tusers.Lname, tusers.email
							From p_EventRegistration_UserRegistrations INNER JOIN tusers ON p_EventRegistration_UserRegistrations.User_ID = tusers.UserID
							Where p_EventRegistration_UserRegistrations.EventID = #Variables.ReportYearlyEvents[eRecord][1]# and tusers.Email LIKE '%#Variables.ReportQuery[sRecord][2]#'
						</cfquery>
						<cfset TotalCorporationAttendees = 0>
						<cfset TotalCorporationEventPGPPoints = 0>

						<cfloop query="GetCorporationAttendeesByEvent">
							<cfset TotalCorporationAttendees = #Variables.TotalCorporationAttendees# + #GetCorporationAttendeesByEvent.AttendedEventDate1# + #GetCorporationAttendeesByEvent.AttendedEventDate2# + #GetCorporationAttendeesByEvent.AttendedEventDate3# + #GetCorporationAttendeesByEvent.AttendedEventDate4# + #GetCorporationAttendeesByEvent.AttendedEventDate5# + #GetCorporationAttendeesByEvent.AttendedEventDate6# + #GetCorporationAttendeesByEvent.AttendedEventSessionAM# + #GetCorporationAttendeesByEvent.AttendedEventSessionPM#>
							<cfif e[5] EQ 1>
								<cfset TotalCorporationEventPGPPoints = #Variables.TotalCorporationEventPGPPoints# + ((#GetCorporationAttendeesByEvent.AttendedEventDate1# + #GetCorporationAttendeesByEvent.AttendedEventDate2# + #GetCorporationAttendeesByEvent.AttendedEventDate3# + #GetCorporationAttendeesByEvent.AttendedEventDate4# + #GetCorporationAttendeesByEvent.AttendedEventDate5# + #GetCorporationAttendeesByEvent.AttendedEventDate6# + #GetCorporationAttendeesByEvent.AttendedEventSessionAM# + #GetCorporationAttendeesByEvent.AttendedEventSessionPM#) * #e[6]#)>
							</cfif>
						</cfloop>
						<cfset EventColumn = #Variables.ReportYearlyEvents[eRecord][4]#>
						<cfset Variables.ReportQuery[Variables.sRecord][Variables.EventColumn] = #Variables.TotalCorporationAttendees#>
						<cfif Variables.ReportQuery[Variables.sRecord][3] EQ 0>
							<cfset Variables.ReportQuery[Variables.sRecord][3] = #Variables.TotalCorporationEventPGPPoints#>
						<cfelse>
							<cfset Variables.ReportQuery[Variables.sRecord][3] = #Variables.ReportQuery[Variables.sRecord][3]# + #Variables.TotalCorporationEventPGPPoints#>
						</cfif>
						<cfcatch type="any">
							<cfdump var="#CFCATCH#">
							<cfdump var="#Variables.ReportQuery#" abort="true">
						</cfcatch>
					</cftry>
					<cfset sRecord = #Variables.sRecord# + 1>
				</cfloop>
				<cfset eRecord = #Variables.eRecord# + 1>
			</cfloop>

			<cfset YearEndReportExportDir = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")#>
			<cfset YearBegin = #DateFormat(CreateDate(ListLast(FORM.BegYearDate, "/"), ListFirst(FORM.BegYearDate, "/"), ListGetAt(FORM.BegYearDate, 2, "/")), "mm-yy")#>
			<cfset YearEnd = #DateFormat(CreateDate(ListLast(FORM.EndYearDate, "/"), ListFirst(FORM.EndYearDate, "/"), ListGetAt(FORM.EndYearDate, 2, "/")), "mm-yy")#>
			<cfset CompletdYearEndReportFile = #Variables.YearEndReportExportDir# & #Variables.YearBegin# & "_" & #Variables.YearEnd# & "-" & #FORM.MembershipID# & "YearlyEventReport.csv">

			<cffile action="Write" file="#Variables.CompletdYearEndReportFile#" output="Corporation,Domain,PGP Total" addnewline="no">
			<cfloop array="#Variables.ReportYearlyEvents#" index="e" from="1" to="#ArrayLen(Variables.ReportYearlyEvents)#">
				<cffile action="Append" file="#Variables.CompletdYearEndReportFile#" output=",#chr(34)##e[2]##CHR(34)#" addnewline="no">
			</cfloop>
			<cffile action="Append" file="#Variables.CompletdYearEndReportFile#" output="" addnewline="yes">
			<cfloop array="#Variables.ReportQuery#" index="s" from="1" to="#ArrayLen(Variables.ReportQuery)#">
				<cffile action="Append" addnewline="true" file="#Variables.CompletdYearEndReportFile#" output="#ArrayToList(s,',')#">
			</cfloop>
			<cfset Session.ReportQuery = #StructNew()#>
			<cfset Session.ReportQuery.YearlyEvents = #Variables.ReportYearlyEvents#>
			<cfset Session.ReportQuery.Corporations = #Variables.ReportQuery#>
			<cfset Session.ReportQuery.ReportFileName = #Variables.YearBegin# & "_" & #Variables.YearEnd# & "-" & #FORM.MembershipID# & "YearlyEventReport.csv">
			<cfset Session.ReportQuery.ReportURLLocation = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/library/ReportExports/">
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:reports.yearendreport&DisplayReport=True">
		</cfif>
	</cffunction>

	<cffunction name="membership" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="GetAllMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select OrganizationName, Active, OrganizationDomainName, StateDOE_ESCESAMembership
				From p_EventRegistration_Membership
			</cfquery>

			<cfquery name="GetAllMembershipAgencies" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName
				From p_EventRegistration_StateESCOrganizations
			</cfquery>
			<cfset ReportQuery = #QueryNew('OrganizationName,Active,OrganizationDomainName,AffilitationName')#>
			<cfloop query="GetAllMemberships">
				<cfset temp = QueryAddRow(Variables.ReportQuery, 1)>
				<cfset temp = QuerySetCell(Variables.ReportQuery, "OrganizationName", GetAllMemberships.OrganizationName)>
				<cfif GetAllMemberships.Active EQ 1>
					<cfset temp = QuerySetCell(Variables.ReportQuery, "Active", "Yes")>
				<cfelse>
					<cfset temp = QuerySetCell(Variables.ReportQuery, "Active", "No")>
				</cfif>
				<cfset temp = QuerySetCell(Variables.ReportQuery, "OrganizationDomainName", GetAllMemberships.OrganizationDomainName)>
				<cfif GetAllMemberships.StateDOE_ESCESAMembership EQ 0>
					<cfset temp = QuerySetCell(Variables.ReportQuery, "AffilitationName", "No ESC/ESA Membership")>	
				<cfelse>
					<cfquery name="GetAffiliationInfo" dbtype="query">
						Select * from GetAllMembershipAgencies
						Where TContent_ID = #GetAllMemberships.StateDOE_ESCESAMembership#
					</cfquery>
					<cfset temp = QuerySetCell(Variables.ReportQuery, "AffilitationName", GetAffiliationInfo.OrganizationName)>
				</cfif>
			</cfloop>
			<cfset LogoPath = ArrayNew(1)>
			<cfloop from="1" to="#Variables.ReportQuery.RecordCount#" step="1" index="i">
				<cfswitch expression="#rc.$.siteConfig('siteID')#">
					<cfcase value="NIESCEvents">
						<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_Logo.png")#>
					</cfcase>
					<cfcase value="NWIESCEvents">
						<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NWIESC_Logo.png")#>
					</cfcase>
				</cfswitch>
			</cfloop>
			<cfset temp = QueryAddColumn(Variables.ReportQuery, "LogoPath", "VarChar", Variables.LogoPath)>	
			<cfset Session.ReportQuery = #Variables.ReportQuery#>
		</cfif>
	</cffunction>
</cfcomponent>