<cfcomponent displayName="Event Registration Email Routines">
	<cffunction name="SendCommentFormToAdmin" ReturnType="Any" Output="True">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="EmailInfo" type="struct" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfquery name="getAdminUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, Email
			From tusers
			Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				UserName = <cfqueryparam value="admin" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfinclude template="EmailTemplates/CommentFormInquiryTemplateToAdmin.cfm">
	</cffunction>

	<cffunction name="SendAccountActivationEmail" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="UserID" type="String" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfquery name="getUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, UserName, Email, created
			From tusers
			Where UserID = <cfqueryparam value="#Arguments.UserID#" cfsqltype="cf_sql_varchar"> and
				InActive = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
		</cfquery>
		<cfset ValueToEncrypt = "UserID=" & #Arguments.UserID# & "&" & "Created=" & #getUserAccount.created# & "&DateSent=" & #Now()#>
		<cfset EncryptedValue = #Tobase64(Variables.ValueToEncrypt)#>
		<cfset AccountVars = "Key=" & #Variables.EncryptedValue#>
		<cfset AccountActiveLink = "http://" & #CGI.Server_Name# & "#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:registeraccount.activateaccount&" & #Variables.AccountVars#>

		<cfset EventServicesComponent = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
		<cfset ShortenedURL = EventServicesComponent.insertShortURLContent(rc, AccountActiveLink)>

		<cfif LEN(cgi.path_info)>
			<cfif CGI.server_port EQ "80">
				<cfset AccountActiveLink = "http://" & #cgi.server_name# & #cgi.script_name# & #cgi.path_info# & "?" & "ShortURL=" & #Variables.ShortenedURL# >
			<cfelse>
				<cfset AccountActiveLink = "https://" & #cgi.server_name# & #cgi.script_name# & #cgi.path_info# & "?" & "ShortURL=" & #Variables.ShortenedURL# >
			</cfif>
		<cfelse>
			<cfif CGI.server_port EQ "80">
				<cfset AccountActiveLink = "http://" & #cgi.server_name# & #cgi.script_name# & "?" & "ShortURL=" & #Variables.ShortenedURL# >
			<cfelse>
				<cfset AccountActiveLink = "https://" & #cgi.server_name# & #cgi.script_name# & "?" & "ShortURL=" & #Variables.ShortenedURL# >
			</cfif>
		</cfif>
		<cfinclude template="EmailTemplates/SendAccountActivationEmailToIndividual.cfm">
	</cffunction>

	<cffunction name="SendAccountActivationEmailFromOrganizationPerson" returntype="Any" Output="false">
		<cfargument name="requestinfo" required="true" type="struct" default="#StructNew()#">
		<cfargument name="UserID" type="String" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfquery name="getUserAccount" Datasource="#Arguments.requestinfo.DBInfo.Datasource#" username="#Arguments.requestinfo.DBInfo.DBUsername#" password="#Arguments.requestinfo.DBInfo.DBPassword#">
			Select Fname, Lname, UserName, Email, created
			From tusers
			Where UserID = <cfqueryparam value="#Arguments.UserID#" cfsqltype="cf_sql_varchar"> and
				InActive = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
		</cfquery>
		<cfset ValueToEncrypt = "UserID=" & #Arguments.UserID# & "&" & "Created=" & #getUserAccount.created# & "&DateSent=" & #Now()#>
		<cfset EncryptedValue = #Tobase64(Variables.ValueToEncrypt)#>
		<cfset AccountVars = "Key=" & #Variables.EncryptedValue#>
		<cfset AccountActiveLink = "http://" & #CGI.Server_Name# & "#CGI.Script_name##CGI.path_info#?#Arguments.RequestInfo.DBInfo.PackageName#action=public:registeraccount.activateaccount&" & #Variables.AccountVars#>

		<cfset EventServicesComponent = createObject("component","plugins/#HTMLEditFormat(Arguments.RequestInfo.DBInfo.PackageName)#/library/components/EventServices")>
		<cfset ShortenedURL = EventServicesComponent.insertShortURLContent(requestinfo, AccountActiveLink)>

		<cfif LEN(cgi.path_info)>
			<cfif CGI.server_port EQ "80">
				<cfset AccountActiveLink = "http://" & #cgi.server_name# & #cgi.script_name# & #cgi.path_info# & "?" & "ShortURL=" & #Variables.ShortenedURL# >
			<cfelse>
				<cfset AccountActiveLink = "https://" & #cgi.server_name# & #cgi.script_name# & #cgi.path_info# & "?" & "ShortURL=" & #Variables.ShortenedURL# >
			</cfif>
		<cfelse>
			<cfif CGI.server_port EQ "80">
				<cfset AccountActiveLink = "http://" & #cgi.server_name# & #cgi.script_name# & "?" & "ShortURL=" & #Variables.ShortenedURL# >
			<cfelse>
				<cfset AccountActiveLink = "https://" & #cgi.server_name# & #cgi.script_name# & "?" & "ShortURL=" & #Variables.ShortenedURL# >
			</cfif>
		</cfif>
		<cfinclude template="EmailTemplates/SendAccountActivationEmailToIndividualFromOrganizationPerson.cfm">
	</cffunction>

	<cffunction name="SendAccountActivationEmailConfirmation" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="UserID" type="String" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfquery name="getUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, UserName, Email, created
			From tusers
			Where UserID = <cfqueryparam value="#Arguments.UserID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfinclude template="EmailTemplates/AccountActivationConfirmationEmailToIndividual.cfm">
	</cffunction>

	<cffunction name="SendForgotPasswordRequest" returntype="Any" Output="False">
		<cfargument name="rc" type="struct" required="true" default="#StructNew()#">
		<cfargument name="UserID" type="String" Required="True">
		<cfargument name="ShortURLValue" required="true" type="String">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">
		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfquery name="getUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, UserName, Email, created
			From tusers
			Where UserID = <cfqueryparam value="#Arguments.UserID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif LEN(cgi.path_info)>
			<cfif CGI.server_port EQ "80">
				<cfset AccountVerifyLink = "http://" & #cgi.server_name# & #cgi.script_name# & #cgi.path_info# & "?" & "ShortURL=" & #Arguments.ShortURLValue# >
			<cfelse>
				<cfset AccountVerifyLink = "https://" & #cgi.server_name# & #cgi.script_name# & #cgi.path_info# & "?" & "ShortURL=" & #Arguments.ShortURLValue# >
			</cfif>
		<cfelse>
			<cfif CGI.server_port EQ "80">
				<cfset AccountVerifyLink = "http://" & #cgi.server_name# & #cgi.script_name# & "?" & "ShortURL=" & #Arguments.ShortURLValue# >
			<cfelse>
				<cfset AccountVerifyLink = "https://" & #cgi.server_name# & #cgi.script_name# & "?" & "ShortURL=" & #Arguments.ShortURLValue# >
			</cfif>
		</cfif>

		<cfinclude template="EmailTemplates/SendLostPasswordVerifyFormToUser.cfm">
	</cffunction>

	<cffunction name="SendMessageToUserAboutPasswordChanged" returntype="Any" Output="false">
		<cfargument name="rc" type="struct" required="true" default="#StructNew()#">
		<cfargument name="UserID" type="String" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfquery name="getUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select UserID, Fname, Lname, UserName, Email, created
			From tusers
			Where UserID = <cfqueryparam value="#Arguments.UserID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfinclude template="EmailTemplates/SendAccountPasswordChangedToUser.cfm">
	</cffunction>

	<cffunction name="SendEventRegistrationToSingleParticipant" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="RegistrationRecordID" type="String" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfset EventServicesComponent = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>

		<cfquery name="getRegistrationInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			SELECT
				tusers.Fname as ParticipantFName, tusers.Lname as ParticipantLName, tusers.Email, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegistrationID,p_EventRegistration_UserRegistrations.RegistrationDate, p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.AttendeePrice, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.WebinarParticipant, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.RegistrationIPAddr, p_EventRegistration_UserRegistrations.RegisteredByUserID, p_EventRegistration_UserRegistrations.dateCreated, p_EventRegistration_UserRegistrations.lastUpdated, p_EventRegistration_UserRegistrations.lastUpdateBy, p_EventRegistration_UserRegistrations.lastUpdateByID, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5, p_EventRegistration_Events.EventDate6, p_EventRegistration_Events.LongDescription, p_EventRegistration_Events.Event_StartTime, p_EventRegistration_Events.Event_EndTime, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Facility.FacilityName, p_EventRegistration_Facility.PhysicalAddress, p_EventRegistration_Facility.PhysicalCity, p_EventRegistration_Facility.PhysicalState, p_EventRegistration_Facility.PhysicalZipCode, p_EventRegistration_Facility.PhysicalZip4, p_EventRegistration_Facility.Physical_isAddressVerified, p_EventRegistration_Facility.Physical_Latitude, p_EventRegistration_Facility.Physical_Longitude, p_EventRegistration_FacilityRooms.RoomName, p_EventRegistration_Events.Event_MemberCost, p_EventRegistration_Events.Event_MaxParticipants, p_EventRegistration_Events.EventAgenda, p_EventRegistration_Events.EventTargetAudience, p_EventRegistration_Events.EventStrategies, p_EventRegistration_Events.EventSpecialInstructions, p_EventRegistration_Events.PGPCertificate_Available, p_EventRegistration_Events.PGPCertificate_Points, p_EventRegistration_Events.Webinar_Available, p_EventRegistration_Events.Event_DailySessions, p_EventRegistration_Events.H323_Available, p_EventRegistration_Events.BillForNoShow, p_EventRegistration_Events.Meal_Available, p_EventRegistration_Events.Meal_Included, p_EventRegistration_Events.PresenterID
			FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID INNER JOIN p_EventRegistration_Facility ON p_EventRegistration_Facility.TContent_ID = p_EventRegistration_Events.Event_HeldAtFacilityID INNER JOIN p_EventRegistration_FacilityRooms ON p_EventRegistration_FacilityRooms.TContent_ID = p_EventRegistration_Events.Event_FacilityRoomID
			WHERE p_EventRegistration_UserRegistrations.TContent_ID = <cfqueryparam value="#Arguments.RegistrationRecordID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfif LEN(getRegistrationInfo.PresenterID)>
			<cfquery name="getEventPresenterInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Fname, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getRegistrationInfo.PresenterID#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset PresenterInfo = #getEventPresenterInfo.Lname# & ", " & #getEventPresenterInfo.Fname# & " (" & #getEventPresenterInfo.Email# & ")">
		</cfif>

		<cfif getRegistrationInfo.User_ID NEQ getRegistrationInfo.RegisteredByUserID>
			<cfquery name="getRegisteredByUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Fname, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getRegistrationInfo.RegisteredByUserID#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset RegisteredBy = #getRegisteredByUserInfo.Lname# & ", " & #getRegisteredByUserInfo.Fname# & " (" & #getRegisteredByUserInfo.Email# & ")">
		<cfelse>
			<cfset RegisteredBy = "self">
		</cfif>

		<cfset RegisteredDateFormatted = #DateFormat(getRegistrationInfo.RegistrationDate, "full")#>
		<cfif getRegistrationInfo.OnWaitingList EQ 1><cfset UserOnWaitingList = "Yes"><cfelse><cfset UserOnWaitingList = "No"></cfif>
		<cfif getRegistrationInfo.RequestsMeal EQ 1><cfset UserRequestMeal = "Yes"><cfelse><cfset UserRequestMeal = "No"></cfif>
		<cfif getRegistrationInfo.H323Participant EQ 1><cfset UserRequestDistanceEducation = "Yes"><cfelse><cfset UserRequestDistanceEducation = "No"></cfif>
		<cfif getRegistrationInfo.WebinarParticipant EQ 1><cfset UserRequestWebinar = "Yes"><cfelse><cfset UserRequestWebinar = "No"></cfif>
		<cfif getRegistrationInfo.PGPCertificate_Available EQ 1><cfset PGPPointsFormatted = #NumberFormat(getRegistrationInfo.PGPCertificate_Points, "99.99")#><cfelse><cfset NumberPGPPoints = 0><cfset PGPPointsFormatted = #NumberFormat(Variables.NumberPGPPoints, "99.99")#></cfif>
		<cfset DisplayEventDateInfo = #DateFormat(getRegistrationInfo.EventDate, "ddd, mmm dd, yyyy")#>
		<cfif LEN(getRegistrationInfo.EventDate1)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(getRegistrationInfo.EventDate1, "ddd, mmm dd, yyyy")#></cfif>
		<cfif LEN(getRegistrationInfo.EventDate2)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(getRegistrationInfo.EventDate2, "ddd, mmm dd, yyyy")#></cfif>
		<cfif LEN(getRegistrationInfo.EventDate3)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(getRegistrationInfo.EventDate3, "ddd, mmm dd, yyyy")#></cfif>
		<cfif LEN(getRegistrationInfo.EventDate4)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(getRegistrationInfo.EventDate4, "ddd, mmm dd, yyyy")#></cfif>
		<cfif LEN(getRegistrationInfo.EventDate5)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(getRegistrationInfo.EventDate5, "ddd, mmm dd, yyyy")#></cfif>
		<cfif LEN(getRegistrationInfo.EventDate6)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(getRegistrationInfo.EventDate6, "ddd, mmm dd, yyyy")#></cfif>

		<cfset CurLoc = #ExpandPath("/")#>
		<cfif getRegistrationInfo.WebinarParticipant EQ 1 and getRegistrationInfo.Webinar_Available EQ 1>
			<cfset FacilityEventLocationText = "Online Webinar: Connection Details to follow in email from presenter.">
		<cfelseif getRegistrationInfo.H323Participant EQ 1 and getRegistrationInfo.H323_Available EQ 1>
			<cfset FacilityEventLocationText = "Online Video Conference: Connection Details to follow in email from presenter.">
		<cfelseif getRegistrationInfo.WebinarParticipant EQ 0 and getRegistrationInfo.H323Participant EQ 0>
			<cfset CurLoc = #ExpandPath("/")#>
			<cfif getRegistrationInfo.Physical_isAddressVerified EQ 1>
				<cfset FacilityLocationMapURL = "https://maps.google.com/maps?q=#getRegistrationInfo.Physical_Latitude#,#getRegistrationInfo.Physical_Longitude#">
				<cfset FacilityLocationFileName = #reReplace(getRegistrationInfo.FacilityName, "[[:space:]]", "", "ALL")#>
				<cfset FacilityLocationFileName = #reReplace(Variables.FacilityLocationFileName, "'", "", "ALL")#>
				<cfset FacilityURLAndImage = #EventServicesComponent.QRCodeImage(Variables.FacilityLocationMapURL,HTMLEditFormat(rc.pc.getPackage()),Variables.FacilityLocationFileName)#>
				<cfset FacilityFileDirAndImage = #Variables.CurLoc# & #Variables.FacilityURLAndImage#>
				<cfset FacilityEventLocationText = #getRegistrationInfo.FacilityName# & " (" & #getRegistrationInfo.PhysicalAddress# & " " & #getRegistrationInfo.PhysicalCity# & ", " & #getRegistrationInfo.PhysicalState# & " " & #getRegistrationInfo.PhysicalZipCode# & ")">
			<cfelse>
				<cfset FacilityFileDirAndImage = "">
				<cfset FacilityEventLocationText = #getRegistrationInfo.FacilityName# & " (" & #getRegistrationInfo.PhysicalAddress# & " " & #getRegistrationInfo.PhysicalCity# & ", " & #getRegistrationInfo.PhysicalState# & " " & #getRegistrationInfo.PhysicalZipCode# & ")">
			</cfif>
		</cfif>

		<cfset FileStoreLoc = #Variables.CurLoc# & "plugins/#HTMLEditFormat(rc.pc.getPackage())#/temp/">
		<cfset UserRegistrationPDFFilename = #getRegistrationInfo.RegistrationID# & ".pdf">
		<cfset UserRegistrationiCalFilename = #getRegistrationInfo.RegistrationID# & ".ics">
		<cfset UserRegistrationPDFAbsoluteFilename = #Variables.FileStoreLoc# & #Variables.UserRegistrationPDFFilename#>
		<cfset UserRegistrationiCalAbsoluteFilename = #Variables.FileStoreLoc# & #Variables.UserRegistrationiCalFilename#>
		<cfset PDFFormTemplateDir = #Variables.CurLoc# & "plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/PDFFormTemplates/">
		<cfset EventConfirmationTemplateLoc = #Variables.PDFFormTemplateDir# & "EventConfirmationPage.pdf">
		<cfset UserRegistrationiCalData = #EventServicesComponent.iCalUS(rc, Arguments.RegistrationRecordID)#>

		<cfif #DirectoryExists(Variables.FileStoreLoc)# EQ "True">
			<cffile action="Write" file="#Variables.UserRegistrationiCalAbsoluteFilename#" output="#Variables.UserRegistrationiCalData#">
		<cfelse>
			<cfdirectory action="create" directory="#Variables.FileStoreLoc#">
			<cffile action="Write" file="#Variables.UserRegistrationiCalAbsoluteFilename#" output="#Variables.UserRegistrationiCalData#">
		</cfif>

		<cfswitch expression="#rc.$.siteConfig('siteID')#">
			<cfcase value="NIESCEvents">
				<cfset LogoPathLoc = "/plugins/" & #rc.pc.getPackage()# & "/assets/images/NIESC_LogoSM.png">
			</cfcase>
			<cfcase value="NWIESCEvents">
				<cfset LogoPathLoc = "/plugins/" & #rc.pc.getPackage()# & "/assets/images/NWIESC_Logo.png">
			</cfcase>
			<cfdefaultcase>
				<cfset LogoPathLoc = "/plugins/" & #rc.pc.getPackage()# & "/assets/images/NIESC_LogoSM.png">
			</cfdefaultcase>
		</cfswitch>
		
		<cfset ReportExportDirLoc = "/plugins/" & #rc.pc.getPackage()# & "/library/ReportExports/">
		<cfset ReportExportLoc = #ExpandPath(ReportExportDirLoc)# & #getRegistrationInfo.RegistrationID# & "-EventConfirmation.pdf" >
		<cffile action="readbinary" file="#ExpandPath(Variables.LogoPathLoc)#" variable="ImageBinaryString">
		<cfscript>FileMimeType = fileGetMimeType(ExpandPath(Variables.LogoPathLoc));</cfscript>
			
		<cfoutput>
			<cfdocument format="PDF" filename="#Variables.ReportExportLoc#" fontEmbed="yes" orientation="portrait" localurl="Yes" pageType="letter" saveAsName="#getRegistrationInfo.RegistrationID#-EventConfirmation.pdf">
				<cfdocumentitem type="header" evalAtPrint="true">
					<table border="0" colspacing="1" cellpadding="1" width="100%">
						<tr>
							<th width="30%"><img src="data:#Variables.FileMimeType#;base64,#ToBase64(Variables.ImageBinaryString)#"></th>
							<th width="70%">Northern Indiana Educational Services Center<br>56535 Magnetic Drive<br>Mishawaka IN 46545<br>(800) 326-5642 / (574) 254-0111<br>http://www.niesc.k12.in.us</th>
						</tr>
						<tr> <th colspan="2"><h1>Event Registration Confirmation Page</h1></th></tr>
						<tr><td colspan="2"><hr style="border-top: 1px solid ##8c8b8b;" /></td></tr>
					</table>
				</cfdocumentitem>
				<cfdocumentitem type="footer" evalAtPrint="true">
					<table class="table table-striped">
						<tr><td><hr style="border-top: 1px solid ##8c8b8b;" /></td></tr>
						<tr><td style="Color: ##000000; font-family: Arial; font-size: 8px; font-weight: bold;">Any Professional Growth Points available for this event will be electronically sent (to the email address we have on file) after the event has concluded and attendance recorded.</td></tr>
					</table>
				</cfdocumentitem>
				<cfdocumentsection>
					<table class="table table-striped">
						<tr>
							<td scope="col" width="40%"><strong>Participant's Name:</strong></td>
							<td scope="row" width="60%">#getRegistrationInfo.ParticipantFName# #getRegistrationInfo.ParticipantLName#</td>
						</tr>
						<tr>
							<td scope="col" width="40%"><strong>Registration Date:</strong></td>
							<td scope="row" width="60%">#DateFormat(getRegistrationInfo.RegistrationDate, "full")#</td>
						</tr>
						<tr>
							<td scope="col" width="40%"><strong>Registered By:</strong></td>
							<td scope="row" width="60%">#Variables.RegisteredBy#</td>
						</tr>
						<cfif getRegistrationInfo.Meal_Available EQ 1 and getRegistrationInfo.Meal_Included EQ 0>
							<tr>
							<td scope="col" width="40%"><strong>Requests Meal:</strong></td>
							<td scope="row" width="60%">#Variables.UserRequestMeal#</td>
							</tr>
						</cfif>
						<cfif getRegistrationInfo.OnWaitingList EQ 1>
							<tr>
							<td scope="col" width="40%"><strong>On Waiting List:</strong></td>
							<td scope="row" width="60%">#Variables.UserOnWaitingList#</td>
							</tr>
						</cfif>
						<cfif getRegistrationInfo.H323_Available EQ 1 and getRegistrationInfo.H323Participant EQ 1>
							<tr>
							<td scope="col" width="40%"><strong>Distance Education Partiicpant:</strong></td>
							<td scope="row" width="60%">#Variables.UserRequestDistanceEducation#</td>
							</tr>
						</cfif>
						<cfif getRegistrationInfo.Webinar_Available EQ 1 and getRegistrationInfo.WebinarParticipant EQ 1>
							<tr>
							<td scope="col" width="40%"><strong>Webinar Partiicpant:</strong></td>
							<td scope="row" width="60%">#Variables.UserRequestWebinar#</td>
							</tr>
						</cfif>
						<cfif getRegistrationInfo.PGPCertificate_Available EQ 1>
							<tr>
							<td scope="col" width="40%"><strong>PGP Certificate Points:</strong></td>
							<td scope="row" width="60%">#Variables.PGPPointsFormatted#</td>
							</tr>
						</cfif>
						<tr>
							<td scope="col" width="40%"><strong>Attendee Cost:</strong></td>
							<td scope="row" width="60%" valign="Top">#DollarFormat(getRegistrationinfo.AttendeePrice)#<div style="Color: ##CCCCCC; font-family: Arial; font-size: 8px; font-weight: bold;">Any adjustments for special discounts or group rates will be made on your final billing and may not be reflected at time of registration.</div></td>
							</tr>
						<tr><td colspan="2"><hr></td></tr>
						<tr>
							<td scope="col" width="40%"><strong>Event Date(s):</strong></td>
							<td scope="row" width="60%">#Variables.DisplayEventDateInfo#</td>
						</tr>
						<cfif getRegistrationInfo.Event_DailySessions EQ 0>
							<tr>
								<td scope="col" width="40%"><strong>Event Times:</strong></td>
								<td scope="row" width="60%">#TimeFormat(getRegistrationInfo.Event_StartTime, "HH:MM tt")# till #TimeFormat(getRegistrationInfo.Event_EndTime, "HH:MM tt")#</td>
							</tr>
						</cfif>
						<tr>
							<td scope="col" width="40%"><strong>Event Title:</strong></td>
							<td scope="row" width="60%">#getRegistrationInfo.ShortTitle#</td>
						</tr>
						<cfif LEN(getRegistrationInfo.PresenterID)>
							<tr>
							<td scope="col" width="40%"><strong>Event Main Presenter:</strong></td>
							<td scope="row" width="60%">#Variables.PresenterInfo#</td>
							</tr>
						</cfif>
						<tr><td colspan="2"><hr></td></tr>
						<tr>
							<td scope="col" width="40%"><strong>Event Location:</strong></td>
							<td scope="row" width="60%">#Variables.FacilityEventLocationText#</td>
						</tr>
						<tr>
							<td scope="col" width="40%"><strong>Room Information:</strong></td>
							<td scope="row" width="60%">#getRegistrationInfo.RoomName#</td>
						</tr>
						<cfif getRegistrationInfo.Physical_isAddressVerified EQ 1>
							<tr>
							<td scope="col" width="40%"><strong>Map Directions:</strong><div class="form-check-label" style="Color: ##CCCCCC;">Scan Barcode for directions</div></td>
							<td scope="row" width="60%">#Variables.FacilityFileDirAndImage#</td>
							</tr>
						<cfelse>
							<tr>
							<td scope="col" width="40%"><strong>Map Directions:</strong><div class="form-check-label" style="Color: ##CCCCCC; font-family: Arial; font-size: 8px; font-weight: bold;">Scan Barcode for directions</div></td>
							<td scope="row" width="60%" style="Color: ##CCCCCC; font-family: Arial; font-size: 8px; font-weight: bold;">Addess of Location not verified and might not be located on Google Maps. For Assistance please contact the facility where event is to be held.</td>
							</tr>
						</cfif>
						<cfif getRegistrationInfo.BillForNoShow EQ 1>
							<tr>
								<td scope="col" colspan="2"><br /><br /></td>
							</tr>
							<tr>
								<td scope="col" colspan="2" align="center" style="Color: ##FF0000; font-family: Arial; font-size: 12px; font-weight: bold;"><strong>Notice: Registrations must be cancelled prior to #DateFormat(getRegistrationInfo.Registration_Deadline, "full")# in order to avoid charges.</strong></td>
							</tr>
						</cfif>
					</table>
				</cfdocumentsection>
			</cfdocument>
		</cfoutput>
		<cfswitch expression="#Variables.RegisteredBy#">
			<cfcase value="self">
				<cfinclude template="EmailTemplates/EventRegistrationConfirmationToIndividual.cfm">
			</cfcase>
			<cfdefaultcase>
				<cfinclude template="EmailTemplates/EventRegistrationConfirmationToIndividualFromAnother.cfm">
			</cfdefaultcase>
		</cfswitch>
	</cffunction>

	<cffunction name="SendEventRegistrationConfirmationSummaryToSingleParticipant" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="EventID" type="numeric" Required="True">
		<cfargument name="RegisterIndividuals" type="String" Required="True">		
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select ShortTitle, EventDate
			From p_EventRegistration_Events
			Where TContent_ID = <cfqueryparam value="#Arguments.EventID#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfinclude template="EmailTemplates/SendEventRegistrationConfirmationSummaryToSingleParticipant.cfm">
	</cffunction>

	<cffunction name="SendEventCancellationByFacilitatorToSingleParticipant" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="Info" type="Struct" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfinclude template="EmailTemplates/EventRegistrationCancellationByFacilitatorToIndividual.cfm">
	</cffunction>

	<cffunction name="SendEventMessageToAllParticipants" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="ParticipantInfo" type="struct" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfinclude template="EmailTemplates/SendEventMessageToParticipantsFromFacilitator.cfm">
	</cffunction>

	<cffunction name="SendPGPCertificateToIndividual" returntype="Any" output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="ParticipantInfo" type="struct" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfinclude template="EmailTemplates/SendEventPGPCertificateToIndividual.cfm">
	</cffunction>

	<cffunction name="SendStatementofAttendanceToMembership" returntype="Any" Output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="ReportLocFilename" required="true" type="String">
		<cfargument name="ShortTitle" required="true" type="String">
		<cfargument name="ActPayableContactName" required="true" type="String">
		<cfargument name="ActPayableContactEmail" required="true" type="String">
		<cfargument name="OrganizationName" required="true" type="String">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfinclude template="EmailTemplates/SendEmailStatementOfCorporationAttendance.cfm">
	</cffunction>

	<cffunction name="SendStatementofAttendanceSummaryToFacilitator" returntype="Any" Output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="ReportLocFilename" required="true" type="Array">
		<cfargument name="ShortTitle" required="true" type="String">
		<cfargument name="ActPayableContactName" required="true" type="String">
		<cfargument name="ActPayableContactEmail" required="true" type="String">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfinclude template="EmailTemplates/SendEmailSummaryStatementOfCorporationAttendance.cfm">

	</cffunction>

	<cffunction name="SendStatementofInvoiceToMembership" returntype="Any" Output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="ReportLocFilename" required="true" type="String">
		<cfargument name="ShortTitle" required="true" type="String">
		<cfargument name="ActPayableContactName" required="true" type="String">
		<cfargument name="ActPayableContactEmail" required="true" type="String">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfinclude template="EmailTemplates/SendStatementofInvoiceToMembership.cfm">
	</cffunction>

	<cffunction name="SendStatementofInvoiceToSiteAccountsPayableAdmin" returntype="Any" Output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="ReportLocFilename" required="true" type="Array">
		<cfargument name="ShortTitle" required="true" type="String">
		<cfargument name="ActPayableContactName" required="true" type="String">
		<cfargument name="ActPayableContactEmail" required="true" type="String">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfinclude template="EmailTemplates/SendStatementofInvoiceToSiteAccountsPayableAdmin.cfm">
	</cffunction>

	<cffunction name="SendEventCancellationToSingleParticipant" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="Info" type="Struct" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfinclude template="EmailTemplates/EventRegistrationCancellationToIndividual.cfm">
	</cffunction>


	


	



	






	




<!--- Stop Here Aboe has been reworked below is Version 3 Functions --->


	<cffunction name="SendCommentFormToPresenter" ReturnType="Any" Output="True">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="EmailInfo" type="struct" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfquery name="getEventPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Presenters
			From p_EventRegistration_Events
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				TContent_ID = <cfqueryparam value="#Arguments.EmailInfo.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getEventPresenterInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select FName, Lname, Email
			From tusers
			Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				UserID = <cfqueryparam value="#getEventPresenter.Presenters#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfinclude template="EmailTemplates/CommentFormInquiryTemplateToPresenter.cfm">
	</cffunction>

	<cffunction name="SendCommentFormToFacilitator" ReturnType="Any" Output="True">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="EmailInfo" type="struct" Required="True">
		<cfargument name="MailServerHostname" type="string" required="True">
		<cfargument name="MailServerUsername" type="string" required="False">
		<cfargument name="MailServerPassword" type="string" required="False">
		<cfargument name="MailServerSSL" type="boolean" required="False">

		<cfif not isDefined("Arguments.MailServerSSL")><cfset Arguments.MailServerSSL = "False"><cfset Arguments.MailServerPort = 25><cfelse><cfset Arguments.MailServerPort = 465></cfif>

		<cfquery name="getEventFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Facilitator
			From p_EventRegistration_Events
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				TContent_ID = <cfqueryparam value="#Arguments.EmailInfo.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getEventFacilitatorInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select FName, Lname, Email
			From tusers
			Where SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
				UserID = <cfqueryparam value="#getEventFacilitator.Facilitator#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfinclude template="EmailTemplates/CommentFormInquiryTemplateToFacilitator.cfm">
	</cffunction>

	<cffunction name="SendEventWaitingListToSingleParticipant" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="RegistrationRecordID" type="numeric" Required="True">

		<cfset EventServicesComponent = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>

		<cfquery name="getRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select RegistrationID, RegistrationDate, User_ID, EventID, RequestsMeal, IVCParticipant, AttendeePrice, RegisterByUserID, OnWaitingList, Comments, WebinarParticipant
			From p_EventRegistration_UserRegistrations
			Where TContent_ID = <cfqueryparam value="#Arguments.RegistrationRecordID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getRegisteredUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getRegistration.User_ID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif getRegistration.User_ID NEQ getRegistration.RegisterByUserID>
			<cfquery name="getRegisteredByUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Fname, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getRegistration.RegisterByUserID#" cfsqltype="cf_sql_varchar">
			</cfquery>
		</cfif>

		<cfquery name="getEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, PGPPoints, MealAvailable, MealIncluded, AllowVideoConference, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, LocationID, LocationRoomID, PGPAvailable, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
			From p_EventRegistration_Events
			Where TContent_ID = <cfqueryparam value="#getRegistration.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getEventLocation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, GeoCode_Latitude, GeoCode_Longitude
			From p_EventRegistration_Facility
			Where TContent_ID = #getEvent.LocationID#
		</cfquery>

		<cfif GetRegistration.User_ID EQ getRegistration.RegisterByUserID>
			<cfset RegisteredBy = "self">
		<cfelse>
			<cfquery name="getRegisteredByUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select Fname, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getRegistration.RegisterByUserID#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset RegisteredBy = #getRegisteredByUserInfo.Lname# & ", " & #getRegisteredByUserInfo.Fname#>
		</cfif>

		<cfset RegisteredDateFormatted = #DateFormat(getRegistration.RegistrationDate, "full")#>

		<cfif getRegistration.RequestsMeal EQ "1">
			<cfset UserRequestMeal = "Yes">
		<cfelse>
			<cfset UserRequestMeal = "No">
		</cfif>

		<cfif getRegistration.IVCParticipant EQ "1">
			<cfset UserRequestDistanceEducation = "Yes">
		<cfelse>
			<cfset UserRequestDistanceEducation = "No">
		</cfif>

		<cfif getRegistration.WebinarParticipant EQ "1">
			<cfset UserRequestWebinar = "Yes">
		<cfelse>
			<cfset UserRequestWebinar = "No">
		</cfif>

		<cfif getEvent.PGPAvailable EQ 1>
			<cfset PGPPointsFormatted = #NumberFormat(getEvent.PGPPoints, "99.99")#>
		<cfelse>
			<cfset NumberPGPPoints = 0>
			<cfset PGPPointsFormatted = #NumberFormat(Variables.NumberPGPPoints, "99.99")#>>
		</cfif>

		<cfset DisplayEventDateInfo = #DateFormat(getEvent.EventDate, "ddd, mmm dd, yy")#>
		<cfif LEN(getEvent.EventDate1)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(getEvent.EventDate1, "ddd, mmm dd, yy")#></cfif>
		<cfif LEN(getEvent.EventDate2)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(getEvent.EventDate2, "ddd, mmm dd, yy")#></cfif>
		<cfif LEN(getEvent.EventDate3)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(getEvent.EventDate3, "ddd, mmm dd, yy")#></cfif>
		<cfif LEN(getEvent.EventDate4)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(getEvent.EventDate4, "ddd, mmm dd, yy")#></cfif>

		<cfif getRegistration.WebinarParticipant EQ 1 and getEvent.WebinarAvailable EQ 1>
			<cfset FacilityEventLocationText = "Online Webinar: Connection Details to follow in email from presenter.">
		<cfelse>
			<cfset FacilityLocationMapURL = "https://maps.google.com/maps?q=#getEventLocation.GeoCode_Latitude#,#getEventLocation.GeoCode_Longitude#">
			<cfset FacilityLocationFileName = #reReplace(getEventLocation.FacilityName, "[[:space:]]", "", "ALL")#>
			<cfset FacilityURLAndImage = #EventServicesComponent.QRCodeImage(Variables.FacilityLocationMapURL,HTMLEditFormat(rc.pc.getPackage()),Variables.FacilityLocationFileName)#>
			<cfset FacilityEventLocationText = #getEventLocation.FacilityName# & " (" & #getEventLocation.PhysicalAddress# & " " & #getEventLocation.PhysicalCity# & ", " & #getEventLocation.PhysicalState# & " " & #getEventLocation.PhysicalZipCode# & ")">
		</cfif>

		<cfset CurLoc = #ExpandPath("/")#>
		<cfset FileStoreLoc = #Variables.CurLoc# & "plugins/#HTMLEditFormat(Session.FormData.PluginInfo.PackageName)#">
		<cfset UserRegistrationPDFFilename = #getRegistration.RegistrationID# & ".pdf">
		<cfset UserRegistrationiCalFilename = #getRegistration.RegistrationID# & ".ics">
		<cfset FileStoreLoc = #Variables.FileStoreLoc# & "/temp/">
		<cfset UserRegistrationPDFAbsoluteFilename = #Variables.FileStoreLoc# & #Variables.UserRegistrationPDFFilename#>
		<cfset UserRegistrationiCalAbsoluteFilename = #Variables.FileStoreLoc# & #Variables.UserRegistrationiCalFilename#>
		<cfset PDFFormTemplateDir = #Variables.CurLoc# & "plugins/#HTMLEditFormat(Session.FormData.PluginInfo.PackageName)#/library/components/PDFFormTemplates/">
		<cfset EventConfirmationTemplateLoc = #Variables.PDFFormTemplateDir# & "EventConfirmationPage.pdf">

		<cfif getRegistration.WebinarParticipant EQ 1 and getEvent.WebinarAvailable EQ 1>
			<cfset FacilityEventLocationText = "Online Webinar: Connection Details to follow in email from presenter.">
		<cfelseif getEvent.WebinarAvailable EQ 0>
			<cfset FacilityLocationMapURL = "https://maps.google.com/maps?q=#getEventLocation.GeoCode_Latitude#,#getEventLocation.GeoCode_Longitude#">
			<cfset FacilityLocationFileName = #reReplace(getEventLocation.FacilityName, "[[:space:]]", "", "ALL")#>
			<cfset FacilityLocationFileName = #reReplace(Variables.FacilityLocationFileName, "'", "", "ALL")#>
			<cfset FacilityURLAndImage = #EventServicesComponent.QRCodeImage(Variables.FacilityLocationMapURL,HTMLEditFormat(Session.FormData.PluginInfo.PackageName),Variables.FacilityLocationFileName)#>
			<cfset FacilityFileDirAndImage = #Variables.CurLoc# & #Variables.FacilityURLAndImage#>
			<cfset FacilityEventLocationText = #getEventLocation.FacilityName# & " (" & #getEventLocation.PhysicalAddress# & " " & #getEventLocation.PhysicalCity# & ", " & #getEventLocation.PhysicalState# & " " & #getEventLocation.PhysicalZipCode# & ")">
		</cfif>

		<cfset UserRegistrationiCalData = #EventServicesComponent.iCalUS(Arguments.RegistrationRecordID)#>

		<cfif #DirectoryExists(Variables.FileStoreLoc)# EQ "True">
			<cffile action="Write" file="#Variables.UserRegistrationiCalAbsoluteFilename#" output="#Variables.UserRegistrationiCalData#">
		<cfelse>
			<cfdirectory action="create" directory="#Variables.FileStoreLoc#">
			<cffile action="Write" file="#Variables.UserRegistrationiCalAbsoluteFilename#" output="#Variables.UserRegistrationiCalData#">
		</cfif>

		<cfscript>
			ReadPDF = Variables.EventConfirmationTemplateLoc;
			WritePDF = Variables.UserRegistrationPDFAbsoluteFilename;
			FileIO = CreateObject("java","java.io.FileOutputStream").init(WritePDF);
			PDFReader = CreateObject("java","com.itextpdf.text.pdf.PdfReader").init(ReadPDF);
			QRCodeImage = CreateObject("java","com.itextpdf.text.Image");
			PDFStamper = CreateObject("java","com.itextpdf.text.pdf.PdfStamper").init(PDFReader, FileIO);
			PDFContent = PDFStamper.getOverContent(PDFReader.getNumberOfPages());
			PDFForm = PDFStamper.getAcroFields();

			// Populate the PDF Fields with Confirmation Registration Information
			PDFForm.setField("RegistrationNumber", "#getRegistration.RegistrationID#");
			PDFForm.setField("ParticipantFirstName", "#getRegisteredUserInfo.Fname#");
			PDFForm.setField("ParticipantLastName", "#getRegisteredUserInfo.LName#");
			PDFForm.setField("RegisteredDate", "#variables.RegisteredDateFormatted#");
			PDFForm.setField("RegisteredBy", "#Variables.RegisteredBy#");
			PDFForm.setField("EventTitle", "#getEvent.ShortTitle#");
			PDFForm.setField("RequestMeal", "#Variables.UserRequestMeal#");
			PDFForm.setField("DistanceEducation", "#Variables.UserRequestDistanceEducation#");
			PDFForm.setField("PGPPoints", "#Variables.PGPPointsFormatted#");
			PDFForm.setField("EventCost", "#DollarFormat(getRegistration.AttendeePrice)#");
			PDFForm.setField("EventLocationInformation", "#Variables.FacilityEventLocationText#");
			PDFForm.setField("EventDates", "#Variables.DisplayEventDateInfo#");
			PDFForm.setField("EventDescription", "#getEvent.LongDescription#");

			// Place the QRCode on the Event Confirmation Page
			if (getRegistration.WebinarParticipant EQ 0) {
				img = QRCodeImage.getInstance(Variables.FacilityFileDirAndImage);
				img.setAbsolutePosition(javacast("float","500"),javacast("float", "277"));
				PDFContent.addImage(img);
			}

			PDFStamper.setFormFlattening(true);
			PDFStamper.close();
			PDFReader.close();
			FileIO.close();
		</cfscript>
		<cfinclude template="EmailTemplates/EventRegistrationConfirmationToIndividualOnWaitingList.cfm">
	</cffunction>

	

	

	

	<cffunction name="SendEmailWithUpComingEventListing" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="UserID" type="String" Required="True">

		<cfquery name="getUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, UserName, Email, created
			From tusers
			Where UserID = <cfqueryparam value="#Arguments.UserID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif getUserAccount.RecordCount GTE 1>
			<cfinclude template="EmailTemplates/SendEmailToUserWithUpComingEventListing.cfm">
		<cfelse>
			<cfinclude template="EmailTemplates/SendEmailToMailingListsWithUpComingEventListing.cfm">
		</cfif>


	</cffunction>

	<cffunction name="SendInvoiceToCompanyAccountsPayable" returntype="Any" Output="False">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="ReportLocFilename" required="true" type="String">
		<cfargument name="ShortTitle" required="true" type="String">
		<cfargument name="ActPayableContactName" required="true" type="String">
		<cfargument name="ActPayableContactEmail" required="true" type="String">
		<cfinclude template="EmailTemplates/SendEmailInvoiceToAccountsPayable.cfm">
	</cffunction>

	

	
	<cffunction name="SendEventInquiryToFacilitator" ReturnType="Any" Output="False">
		<cfargument name="EmailInfo" type="struct" Required="True">

		<cfquery name="getEvent" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, MemberCost, NonMemberCost,  EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Presenters, Facilitator
			From p_EventRegistration_Events
			Where Site_ID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar"> and
				TContent_ID = <cfqueryparam value="#Arguments.EmailInfo.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfinclude template="EmailTemplates/EventInquiryTemplateToFacilitator.cfm">
	</cffunction>

	<cffunction name="SendEventInquiryToIndividual" ReturnType="Any" Output="False">
		<cfargument name="EmailInfo" type="struct" Required="True">

		<cfquery name="getEvent" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, MemberCost, NonMemberCost,  EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealAvailable, MealIncluded, MealProvidedBy, MealCost, Meal_Notes, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Presenters, Facilitator
			From p_EventRegistration_Events
			Where Site_ID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar"> and
				TContent_ID = <cfqueryparam value="#Arguments.EmailInfo.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfinclude template="EmailTemplates/EventInquiryTemplateToIndividual.cfm">
	</cffunction>


	<cffunction name="SendLostPasswordVerifyFormToUser" returntype="Any" Output="false">
		<cfargument name="Email" type="String" Required="True">

		<cfquery name="GetAccountUsername" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select Fname, Lname, UserName, Email, created
			From tusers
			Where Email = <cfqueryparam value="#Arguments.Email#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfset ValueToEncrypt = "UserID=" & #GetAccountUsername.UserName# & "&" & "Created=" & #GetAccountUsername.created# & "&DateSent=" & #Now()#>
		<cfset EncryptedValue = #Tobase64(Variables.ValueToEncrypt)#>
		<cfset AccountVars = "Key=" & #Variables.EncryptedValue#>
		<cfset AccountActiveLink = "http://" & #CGI.Server_Name# & "/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.lostpassword&" & #Variables.AccountVars#>
		<cfinclude template="EmailTemplates/SendLostPasswordVerifyFormToUser.cfm">

	</cffunction>

	
	<cffunction name="SendWorkshopRequestFormToAdmin" ReturnType="Any" Output="True">
		<cfargument name="EmailInfo" type="struct" Required="True">

		<cfquery name="getAdminGroup" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select Email
			From tusers
			Where SiteID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar"> and
				UserName = <cfqueryparam value="admin" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfinclude template="EmailTemplates/SendWorkshopRequestFormToAdmin.cfm">
	</cffunction>


	<cffunction name="SendEventMessageToAllAttendedParticipants" returntype="Any" Output="false">
		<cfargument name="ParticipantInfo" type="struct" Required="True">
		<cfinclude template="EmailTemplates/SendEventMessageToAttendedParticipantsFromFacilitator.cfm">
	</cffunction>



	<cffunction name="SendNoticeToIndividualRegistrationRemovedFromWaitingList" returntype="Any" Output="false">
		<cfargument name="RegistrationRecordID" type="numeric" Required="True">

		<cfquery name="getRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select RegistrationID, RegistrationDate, User_ID, EventID, RequestsMeal, IVCParticipant, AttendeePrice, RegisterByUserID, OnWaitingList, Comments, WebinarParticipant
			From eRegistrations
			Where TContent_ID = <cfqueryparam value="#Arguments.RegistrationRecordID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getEvent" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, PGPPoints, MealAvailable, MealIncluded, AllowVideoConference, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, LocationType, LocationID, LocationRoomID, PGPAvailable, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
			From p_EventRegistration_Events
			Where TContent_ID = <cfqueryparam value="#getRegistration.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getEventLocation" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, GeoCode_Latitude, GeoCode_Longitude
			From eFacility
			Where TContent_ID = #getEvent.LocationID#
		</cfquery>

		<cfquery name="getRegisteredUserInfo" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select Fname, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getRegistration.User_ID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfinclude template="EmailTemplates/SendNoticeAboutRemovalFromWaitingList.cfm">
	</cffunction>
</cfcomponent>



