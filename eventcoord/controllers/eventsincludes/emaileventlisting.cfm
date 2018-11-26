<cfif not isDefined("FORM.FormSubmit")>
	<cfswitch expression="#application.configbean.getDBType()#">
		<cfcase value="mysql">
			<cfquery name="GetUpComingEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, LongDescription
				From p_EventRegistration_Events
				Where DateDiff(Registration_Deadline, Now()) >= 1
				Order by EventDate ASC
			</cfquery>
		</cfcase>
		<cfcase value="mssql">
			<cfquery name="GetUpComingEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, ShortTitle, EventDate, LongDescription
				From p_EventRegistration_Events
				Where DateDiff("d", GETUTCDATE(), Registration_Deadline) >= 1
				Order by EventDate ASC
			</cfquery>
		</cfcase>
	</cfswitch>

	<cfset MoreInfoImage = ArrayNew(1)>
	<cfset MoreInfoURL = ArrayNew(1)>
	<cfset MobileLink = ArrayNew(1)>
	<cfset LogoPath = ArrayNew(1)>
	<cfloop from="1" to="#GetUpComingEvents.RecordCount#" step="1" index="i">
		<cfset MoreInfoImage[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/MoreInfoButton_SM.png")#>
		<cfset MoreInfoURL[i] = "http://" & #CGI.Server_Name# & #CGI.Script_name# & #CGI.path_info# & "?" & #HTMLEditFormat(rc.pc.getPackage())# & "action=public:main.eventinfo&EventID=" & #GetUpComingEvents.TContent_ID#>
		<cfset MobileLink[i] = "Link">
		<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_Logo.png")#>
	</cfloop>
	<cfset temp = QueryAddColumn(GetUpComingEvents, "MoreInfoImage", "VarChar", Variables.MoreInfoImage)>
	<cfset temp = QueryAddColumn(GetUpComingEvents, "LinkURL", "VarChar", Variables.MoreInfoURL)>
	<cfset temp = QueryAddColumn(GetUpComingEvents, "MobileLink", "VarChar", Variables.MobileLink)>
	<cfset temp = QueryAddColumn(GetUpComingEvents, "NIESCLogoPath", "VarChar", Variables.LogoPath)>
	<cfset temp = QueryAddColumn(GetUpComingEvents, "EventDateFormat")>
	<cfloop query="#GetUpComingEvents#">
		<cfset temp = QuerySetCell(GetUpComingEvents, "EventDateFormat", DateFormat(GetUpComingEvents.EventDate, "ddd, mmm dd, yyyy"), GetUpComingEvents.CurrentRow)>
	</cfloop>

	<cfset Session.EmailMarketing = #StructNew()#>
	<cfset Session.EmailMarketing.MasterTemplate = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/EventUpcomingList.jrxml")#>
	<cfset Session.EmailMarketing.ReportExportDir = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")#>
	<cfset Session.EmailMarketing.WebExportDir = "/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/">
	<cfset Session.EmailMarketing.CompletedFile = #Session.EmailMarketing.ReportExportDir# & #DateFormat(Now(), "mm_dd_yyyy")# & "EmailMarketingListEvents.pdf">
	<cfset Session.EmailMarketing.WebExportCompletedFile = "/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/" & #DateFormat(Now(), "mm_dd_yyyy")# & "EmailMarketingListEvents.pdf">
	<cfset Session.EmailMarketing.QueryResults = #GetUpComingEvents#>

<cfelseif isDefined("FORM.FormSubmit")>
	<cfset Session.FormData = #StructCopy(FORM)#>
	<cfset Session.FormErrors = #ArrayNew()#>
	<cfif FORM.UserAction EQ "Back to Main Menu"><cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" addtoken="false"></cfif>
	<cfif FORM.WhoToSendTo EQ "----">
		<cflock timeout="60" scope="SESSION" type="Exclusive">
			<cfscript>
				address = {property="BusinessAddress",message="Please select who to send the upcoming event listing to."};
				arrayAppend(Session.FormErrors, address);
			</cfscript>
		</cflock>
		<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emaileventlisting&FormRetry=True">
	<cfelse>
		<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
		<cfif FORM.WhoToSendTo EQ 0>
			<cfset Temp = SendEmailCFC.SendEmailWithUpComingEventListing(rc, Session.Mura.UserID)>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailUpComingEvents&Successful=True" addtoken="false">
		<cfelseif FORM.WhoToSendTo EQ 1>
			<cfset Temp = SendEmailCFC.SendEmailWithUpComingEventListing(rc, "MailingLists")>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=EmailUpComingEvents&Successful=True" addtoken="false">
		</cfif>
	</cfif>
</cfif>