<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_Events
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order By EventDate DESC
	</cfquery>
	<cfset Session.getSelectedEvent = StructCopy(getSelectedEvent)>
	
	<cfif LEN(getSelectedEvent.PresenterID)>
		<cfquery name="getPresenter" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select FName, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cfif>

	<cfswitch expression="#application.configbean.getDBType()#">
		<cfcase value="mysql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
		<cfcase value="mssql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
	</cfswitch>
	
	<cfswitch expression="#rc.$.siteConfig('siteID')#">
		<cfcase value="NIESCEvents">
			<cfset LogoPathLoc = "/plugins/" & #rc.pc.getPackage()# & "assets/images/NIESC_LogoSM.png">
		</cfcase>
		<cfcase value="NWIESCEvents">
			<cfset LogoPathLoc = "/plugins/" & #rc.pc.getPackage()# & "/assets/images/NWIESC_Logo.png">
		</cfcase>
		<cfdefaultcase>
			<cfset LogoPathLoc = "/plugins/" & #rc.pc.getPackage()# & "/assets/images/NIESC_LogoSM.png">
		</cfdefaultcase>
	</cfswitch>
	<cfset RowsToAdd = 8 - (#getRegisteredParticipants.RecordCount# MOD 8)>
	<cfif Variables.RowsToAdd><cfset temp = #QueryAddRow(getRegisteredParticipants, Variables.RowsToAdd)#></cfif>
	<cfset AddOrganizataionName = #QueryAddColumn(getRegisteredParticipants, "OrganizationName", "VarChar")#>
	<cffile action="readbinary" file="#ExpandPath(Variables.LogoPathLoc)#" variable="ImageBinaryString">
	<cfscript>FileMimeType = fileGetMimeType(ExpandPath(Variables.LogoPathLoc));</cfscript>
	<cfloop query="getRegisteredParticipants">
		<cfif LEN(getRegisteredParticipants.User_ID)>
			<cfquery name="lookupOrganizationInfo" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select OrganizationName
				From p_EventRegistration_Membership
				Where OrganizationDomainName = <cfqueryparam value="#getRegisteredParticipants.Domain#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset temp = #QuerySetCell(getRegisteredParticipants, "OrganizationName", lookupOrganizationInfo.OrganizationName, getRegisteredParticipants.currentrow)#>
		</cfif>
	</cfloop>
	<cfset ReportExportDirLoc = "/plugins/" & #rc.pc.getPackage()# & "/library/ReportExports/">
	<cfset ReportExportLoc = #ExpandPath(ReportExportDirLoc)# & #URL.EventID# & "-NameTags.pdf">

	<cfset FirstRowRecord = 1>
	<cfset SecondRowRecord = 2>
	<cfset NumberLoops = #getRegisteredParticipants.RecordCount# / 2>
	<cfoutput>
		<cfdocument format="PDF" filename="#Variables.ReportExportLoc#" fontEmbed="yes" orientation="portrait" localurl="Yes" pageType="letter" overwrite="true" saveAsName="#URL.EventID#-NameTags.pdf" margintop=".25" marginbottom=".5">
			<cfdocumentsection>
				<table border="0" cellspacing="0" cellpadding="0" width="600">
					<cfloop from="1" to="#Variables.NumberLoops#" index="Rec">
						<cfset FirstRecord = #queryRowData(getRegisteredParticipants, Variables.FirstRowRecord)#>
						<cfset SecondRecord = #queryRowData(getRegisteredParticipants, Variables.SecondRowRecord)#>
						<tr>
							<td width="300" align="Center" height="200">
								<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
									<tr><td align="center" style="font-family: Arial; font-size: 24px; font-weight: bold;"><cfif LEN(FirstRecord.FName)>#FirstRecord.FName#<cfelse>&nbsp;</cfif></td></tr>
									<tr><td align="center" style="font-family: Arial; font-size: 14px;"><cfif LEN(FirstRecord.LName)>#FirstRecord.LName#<cfelse>&nbsp;</cfif></td></tr>
									<tr><td align="center" style="font-family: Arial; font-size: 14px;"><cfif LEN(FirstRecord.OrganizationName)>#FirstRecord.OrganizationName#<cfelse>&nbsp;</cfif></td></tr>
									<tr><td align="center" style="font-family: Arial; font-size: 10px;">&nbsp;</td></tr>
									<tr><td align="center" style="font-family: Arial; font-size: 10px;"><img src="data:#Variables.FileMimeType#;base64,#ToBase64(Variables.ImageBinaryString)#" width="100"></td></tr>
								</table>
							</td>
							<td width="300" align="Center" height="200">
								<table border="0" cellspacing="0" cellpadding="0" width="100%" height="100%">
									<tr><td align="center" style="font-family: Arial; font-size: 24px; font-weight: bold;"><cfif LEN(SecondRecord.FName)>#SecondRecord.FName#<cfelse>&nbsp;</cfif></td></tr>
									<tr><td align="center" style="font-family: Arial; font-size: 14px;"><cfif LEN(SecondRecord.LName)>#SecondRecord.LName#<cfelse>&nbsp;</cfif></td></tr>
									<tr><td align="center" style="font-family: Arial; font-size: 14px;"><cfif LEN(SecondRecord.OrganizationName)>#SecondRecord.OrganizationName#<cfelse>&nbsp;</cfif></td></tr>
									<tr><td align="center" style="font-family: Arial; font-size: 10px;">&nbsp;</td></tr>
									<tr><td align="center" style="font-family: Arial; font-size: 10px;"><img src="data:#Variables.FileMimeType#;base64,#ToBase64(Variables.ImageBinaryString)#" width="100"></td></tr>
								</table>
							</td>
						</tr>
						<cfset FirstRowRecord = #Variables.FirstRowRecord# + 2>
						<cfset SecondRowRecord = #Variables.SecondRowRecord# + 2>
					</cfloop>
				</table>
			</cfdocumentsection>
		</cfdocument>
	</cfoutput>
	<cfset Session.NameTagReport = #Variables.ReportExportLoc#>
<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
	<cfif FORM.UserAction EQ "Back to Event Listing">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "SiteConfigSettings")>
		<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
		<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
		<cfset temp = StructDelete(Session, "GetMembershipOrganizations")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "JSMuraScope")>
		<cfset temp = StructDelete(Session, "SignInReport")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

</cfif>