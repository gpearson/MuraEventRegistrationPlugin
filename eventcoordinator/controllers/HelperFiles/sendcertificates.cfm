<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, Event_HasMultipleDates, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
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

	<cfquery name="getEventFacilitator" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select FName, Lname, Email
		From tusers
		Where UserID = <cfqueryparam value="#getSelectedEvent.FacilitatorID#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfset Session.getEventFacilitator = StructCopy(getEventFacilitator)>

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
	<cfset Session.EventNumberRegistrationsForCertificates = #StructCopy(getRegisteredParticipants)#>
	<cfset temp = #QueryAddColumn(Session.EventNumberRegistrationsForCertificates, "EventDateDisplay")#>
	<cfset temp = #QueryAddColumn(Session.EventNumberRegistrationsForCertificates, "EventNumberOfDays")#>
	<cfset temp = #QueryAddColumn(Session.EventNumberRegistrationsForCertificates, "PGPPoints")#>
	<cfset temp = QueryAddColumn(Session.EventNumberRegistrationsForCertificates,"ParticipantDaysAttended")>
	
	<cfset EventDateQuery = #QueryNew("EventDate")#>
	<cfif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) EQ 0 and LEN(Session.getSelectedEvent.EventDate2) EQ 0 and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
		<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yy"))#>
	<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) EQ 0 and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
		<cfset temp = #QueryAddRow(EventDateQuery, 2)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yy"), 1)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yy"), 2)#>
	<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) EQ 0 and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
		<cfset temp = #QueryAddRow(EventDateQuery, 3)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yy"), 1)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yy"), 2)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yy"), 3)#>
	<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) and LEN(Session.getSelectedEvent.EventDate4) EQ 0>
		<cfset temp = #QueryAddRow(EventDateQuery, 4)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yy"), 1)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yy"), 2)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yy"), 3)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yy"), 4)#>
	<cfelseif LEN(Session.getSelectedEvent.EventDate) and LEN(Session.getSelectedEvent.EventDate1) and LEN(Session.getSelectedEvent.EventDate2) and LEN(Session.getSelectedEvent.EventDate3) and LEN(Session.getSelectedEvent.EventDate4)>
		<cfset temp = #QueryAddRow(EventDateQuery, 5)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yy"), 1)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yy"), 2)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yy"), 3)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yy"), 4)#>
		<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", DateFormat(Session.getSelectedEvent.EventDate4, "mm/dd/yy"), 5)#>
	</cfif>
	<cfset Session.SignInSheet = #StructNew()#>
	<cfset Session.SignInSheet.EventDates = ValueList(EventDateQuery.EventDate, ",")>
	<cfset Session.SignInSheet.NumberOfDays = ListLen(Session.SignInSheet.EventDates, ",")>
	<cfset ParticipantsGettingCertificate = 0>
	<cfloop query="#getRegisteredParticipants#">
		<cfset ParticipantNumberOfPGPCertificatePoints = 0>
		<cfset ParticipantNumberOfDaysAttended = 0>

		<cfif getRegisteredParticipants.RegisterForEventDate1 EQ 1 and getRegisteredParticipants.AttendedEventDate1 EQ 1>
			<cfif LEN(Session.getSelectedEvent.PGPCertificate_Points)>
				<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPCertificate_Points#>
				<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
			</cfif>	
		</cfif>

		<cfif getRegisteredParticipants.RegisterForEventDate2 EQ 1 and getRegisteredParticipants.AttendedEventDate2 EQ 1>
			<cfif LEN(Session.getSelectedEvent.PGPCertificate_Points)>
				<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPCertificate_Points#>
				<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
			</cfif>	
		</cfif>

		<cfif getRegisteredParticipants.RegisterForEventDate3 EQ 1 and getRegisteredParticipants.AttendedEventDate3 EQ 1>
			<cfif LEN(Session.getSelectedEvent.PGPCertificate_Points)>
				<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPCertificate_Points#>
				<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
			</cfif>	
		</cfif>

		<cfif getRegisteredParticipants.RegisterForEventDate4 EQ 1 and getRegisteredParticipants.AttendedEventDate4 EQ 1>
			<cfif LEN(Session.getSelectedEvent.PGPCertificate_Points)>
				<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPCertificate_Points#>
				<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
			</cfif>	
		</cfif>

		<cfif getRegisteredParticipants.RegisterForEventDate5 EQ 1 and getRegisteredParticipants.AttendedEventDate5 EQ 1>
			<cfif LEN(Session.getSelectedEvent.PGPCertificate_Points)>
				<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPCertificate_Points#>
				<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
			</cfif>	
		</cfif>

		<cfif getRegisteredParticipants.RegisterForEventDate6 EQ 1 and getRegisteredParticipants.AttendedEventDate6 EQ 1>
			<cfif LEN(Session.getSelectedEvent.PGPCertificate_Points)>
				<cfset ParticipantNumberOfPGPCertificatePoints = #Variables.ParticipantNumberOfPGPCertificatePoints# + #Session.getSelectedEvent.PGPCertificate_Points#>
				<cfset ParticipantNumberOfDaysAttended = #Variables.ParticipantNumberOfDaysAttended# + 1>
			</cfif>	
		</cfif>

		<cfset temp = #QuerySetCell(Session.EventNumberRegistrationsForCertificates,"ParticipantDaysAttended", Variables.ParticipantNumberOfDaysAttended, getRegisteredParticipants.CurrentRow)#>

		<cfif Session.getSelectedEvent.EventPricePerDay EQ 0>
			<cfset temp = #QuerySetCell(Session.EventNumberRegistrationsForCertificates,"PGPPoints", NumberFormat(Variables.ParticipantNumberOfPGPCertificatePoints, "99.9"), getRegisteredParticipants.CurrentRow)#>
		<cfelse>
			<cfset UpdatedPGPPoints = #Variables.ParticipantNumberOfPGPCertificatePoints# * #Variables.ParticipantNumberOfDaysAttended#>
			<cfset temp = #QuerySetCell(Session.EventNumberRegistrationsForCertificates,"PGPPoints", NumberFormat(Variables.UpdatedPGPPoints, "99.9"), getRegisteredParticipants.CurrentRow)#>
		</cfif>
		<cfset temp = #QuerySetCell(Session.EventNumberRegistrationsForCertificates,"EventNumberOfDays", NumberFormat(Session.SignInSheet.NumberOfDays, "99"), getRegisteredParticipants.CurrentRow)#>
		<cfset temp = #QuerySetCell(Session.EventNumberRegistrationsForCertificates,"EventDateDisplay", Session.SignInSheet.EventDates, getRegisteredParticipants.CurrentRow)#>
	</cfloop>
<cfelse>
	<cfif FORM.UserAction EQ "Back to Event Listing">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "SiteConfigSettings")>
		<cfset temp = StructDelete(Session, "getAllEvents")>
		<cfset temp = StructDelete(Session, "getAvailableExpenseList")>
		<cfset temp = StructDelete(Session, "getEventExpenses")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.FormInput = #StructCopy(FORM)#>
	</cflock>

	<cfif LEN(FORM.EmailMsg) EQ 0>
		<cfscript>
			errormsg = {property="EmailMsg",message="Please enter a message that will be sent to participants who is receiving these certificates."};
			arrayAppend(Session.FormErrors, errormsg);
		</cfscript>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.sendcertificates&EventID=#URL.EventID#&FormRetry=True" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.sendcertificates&EventID=#URL.EventID#&FormRetry=True" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cfset CertificateExportTemplateDir = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")#>
	<cfset CertificateTemplateDir = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")#>
	<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

	<cfswitch expression="#rc.$.siteConfig('siteID')#">
		<cfdefaultcase>
			<cfset CertificateMasterTemplate = #Variables.CertificateTemplateDir# & "NIESCPGPCertificateTemplate.pdf">
		</cfdefaultcase>
	</cfswitch>

	<cfquery name="getFacilitator" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select FName, Lname, Email
		From tusers
		Where UserID = <cfqueryparam value="#Session.getSelectedEvent.FacilitatorID#" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfloop query="#Session.EventNumberRegistrationsForCertificates#">
		<cfset ParticipantName = #Session.EventNumberRegistrationsForCertificates.FName# & " " & #Session.EventNumberRegistrationsForCertificates.LName#>
		<cfset ParticipantFilename = #Replace(Variables.ParticipantName, " ", "", "all")#>
		<cfset ParticipantFilename = #Replace(Variables.ParticipantFilename, ".", "", "all")#>
		<cfset PGPEarned = "PGP Earned: " & #NumberFormat(Session.EventNumberRegistrationsForCertificates.PGPPoints, "99.9")#>
		<cfset CertificateCompletedFile = #Variables.CertificateExportTemplateDir# & #URL.EventID# & "-" & #Variables.ParticipantFilename# & ".pdf">
		<cfscript>
			PDFCompletedCertificate = CreateObject("java", "java.io.FileOutputStream").init(CertificateCompletedFile);
			PDFMasterCertificateTemplate = CreateObject("java", "com.itextpdf.text.pdf.PdfReader").init(CertificateMasterTemplate);
			PDFStamper = CreateObject("java", "com.itextpdf.text.pdf.PdfStamper").init(PDFMasterCertificateTemplate, PDFCompletedCertificate);
			PDFStamper.setFormFlattening(true);
			PDFFormFields = PDFStamper.getAcroFields();
			PDFFormFields.setField("PGPEarned", Variables.PGPEarned);
			PDFFormFields.setField("ParticipantName", Variables.ParticipantName);
			PDFFormFields.setField("EventTitle", Session.EventNumberRegistrationsForCertificates.ShortTitle);
			PDFFormFields.setField("EventDates", Session.EventNumberRegistrationsForCertificates.EventDateDisplay);
			PDFFormFields.setField("SignDate", DateFormat(Now(), "mm/dd/yyyy"));
			PDFStamper.close();
		</cfscript>

		<cfset ParticipantInfo = StructNew()>
		<cfset ParticipantInfo.FName = #Session.EventNumberRegistrationsForCertificates.Fname#>
		<cfset ParticipantInfo.LName = #Session.EventNumberRegistrationsForCertificates.Lname#>
		<cfset ParticipantInfo.Email = #Session.EventNumberRegistrationsForCertificates.Email#>
		<cfset ParticipantInfo.FacilitatorFName = #getFacilitator.FName#>
		<cfset ParticipantInfo.FacilitatorLName = #getFacilitator.LName#>
		<cfset ParticipantInfo.FacilitatorEmail = #getFacilitator.Email#>
		<cfset ParticipantInfo.EventShortTitle = #Session.EventNumberRegistrationsForCertificates.ShortTitle#>
		<cfset ParticipantInfo.EmailMessageBody = #FORM.EmailMsg#>
		<cfset ParticipantInfo.NumberPGPPoints = #NumberFormat(Session.EventNumberRegistrationsForCertificates.PGPPoints, "99.9")#>
		<cfset ParticipantInfo.PGPCertificateFilename = #Variables.CertificateCompletedFile#>

		<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
			<cfset temp = #Variables.SendEmailCFC.SendPGPCertificateToIndividual(rc, Variables.ParticipantInfo, "127.0.0.1")#>
		<cfelse>
			<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
				<cfif rc.$.siteConfig('mailserverssl') EQ "True">
					<cfset temp = #Variables.SendEMailCFC.SendPGPCertificateToIndividual(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
				<cfelse>
					<cfset temp = #Variables.SendEMailCFC.SendPGPCertificateToIndividual(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
				</cfif>
			<cfelse>
				<cfset temp = #Variables.SendEMailCFC.SendPGPCertificateToIndividual(rc, Variables.ParticipantInfo, rc.$.siteConfig('mailserverip'))#>
			</cfif>
		</cfif>
	</cfloop>

	<cfquery name="GetOrganizations" dbtype="query">
		Select Domain
		From Session.EventNumberRegistrationsForCertificates
		Group By Domain
	</cfquery>

	<cfset EmailSummaryLinks = ArrayNew(2)>

	<cfset LogoPath = ArrayNew(1)>
	<cfloop from="1" to="#Session.EventNumberRegistrationsForCertificates.RecordCount#" step="1" index="i">
		<cfswitch expression="#rc.$.siteConfig('siteID')#">
			<cfdefaultcase>
				<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/assets/images/NIESC_LogoSM.png")#>
			</cfdefaultcase>
		</cfswitch>
	</cfloop>
	<cfset temp = QueryAddColumn(Session.EventNumberRegistrationsForCertificates, "ReportLogoPath", "VarChar", Variables.LogoPath)>

	<cfloop query="GetOrganizations">
		<cfquery name="GetOrganizationRegistrations" dbtype="query">
			Select *
			From Session.EventNumberRegistrationsForCertificates
			Where Domain = <cfqueryparam value="#GetOrganizations.Domain#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery name="GetOrganizationInformation" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select OrganizationName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4
			From p_EventRegistration_Membership
			Where OrganizationDomainName = <cfqueryparam value="#GetOrganizations.Domain#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cffile action="readbinary" file="#ExpandPath(Session.EventNumberRegistrationsForCertificates.ReportLogoPath)#" variable="ImageBinaryString">
		<cfscript>FileMimeType = fileGetMimeType(ExpandPath(Session.EventNumberRegistrationsForCertificates.ReportLogoPath));</cfscript>
		<cfset ReportExportDirLoc = "/plugins/" & #rc.pc.getPackage()# & "/library/ReportExports/">
		<cfset OrgFileName = #Replace(GetOrganizationInformation.OrganizationName, " ", "", "ALL")#>
		<cfset ReportExportLoc = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")# & #URL.EventID# & "-" & #Variables.OrgFileName# & "EventStatementOfAttendance.pdf" >
		<cfset ReportExportURL = "http://" & #cgi.server_name# & "/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/" & #URL.EventID# & "-" & #Variables.OrgFileName# & "EventStatementOfAttendance.pdf" >
		<cfset Temp = EmailSummaryLinks[GetOrganizations.CurrentRow][1] = #Variables.ReportExportURL#>
		<cfset Temp = EmailSummaryLinks[GetOrganizations.CurrentRow][2] = #GetOrganizationInformation.OrganizationName#>
		<cfset EventShortTitle = #GetOrganizationRegistrations.ShortTitle#>
		<cfoutput>
			<cfdocument format="PDF" filename="#Variables.ReportExportLoc#" fontEmbed="yes" orientation="portrait" localurl="Yes" pageType="letter" overwrite="true" saveAsName="#URL.EventID#-#Variables.OrgFileName#EventStatementOfAttendance.pdf">
				<cfdocumentitem type="header" evalAtPrint="true">
					<table border="0" colspacing="1" cellpadding="1" width="100%">
						<tr>
							<th width="50%" align="left" colspan="2"><img src="data:#Variables.FileMimeType#;base64,#ToBase64(Variables.ImageBinaryString)#"></th>
							<th width="50%" colspan="2" style="font-family: Arial; font-size: 12px;">Northern Indiana Educational Services Center<br>56535 Magnetic Drive<br>Mishawaka IN 46545<br>(800) 326-5642 / (574) 254-0111<br>http://www.niesc.k12.in.us</th>
						</tr>
						<tr><th colspan="4"><h1>STATEMENT OF ATTENDANCE</h1></th></tr>
						<tr><td colspan="4"><hr style="border-top: 1px solid ##8c8b8b;" /></td></tr>
						<tr><td colspan="4" align="center">#GetOrganizationRegistrations.ShortTitle#</td></tr>
						<tr><td colspan="4" align="center">#DateFormat(Session.getSelectedEvent.EventDate, "full")#</td></tr>
						<tr><td colspan="4"><hr /></td></tr>
						<tr><td colspan="2" width="50%" style="font-family: Arial; font-size: 12px;">Corporation Info:</td><td width="25%" style="font-family: Arial; font-size: 12px;" align="Right" valign="Top">Number Days:</td><td width="25%" style="font-family: Arial; font-size: 12px;" align="Left" valign="Top">1.0</td></tr>
						<tr><td colspan="2" width="50%" style="font-family: Arial; font-size: 10px;">#GetOrganizationInformation.OrganizationName#<br>#GetOrganizationInformation.PhysicalAddress#<br>#GetOrganizationInformation.PhysicalCity#, #GetOrganizationInformation.PhysicalState# #GetOrganizationInformation.PhysicalZipCode#</td><td width="25%" style="font-family: Arial; font-size: 12px;" align="Right" valign="Top">Event ID:</td><td width="25%" style="font-family: Arial; font-size: 12px;" align="Left" valign="Top">16</td></td>
						</tr>
						<tr><td colspan="4"><hr /></td></tr>
					</table>
				</cfdocumentitem>
				<cfdocumentitem type="footer" evalAtPrint="true">
					<table border="0" colspacing="1" cellpadding="1" width="100%">
						<tr bgcolor="##000040">
							<td style="font-family: Arial; font-size: 10px; color: ##FFFFFF;" align="left">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
							<td style="font-family: Arial; font-size: 10px; color: ##FFFFFF;" align="center">THANK YOU FOR YOUR BUSINESS</td>
							<td style="font-family: Arial; font-size: 10px; color: ##FFFFFF;" align="right">Printed: #DateFormat(Now(), "short")#</td>
						</tr>
					</table>
				</cfdocumentitem>
				<cfdocumentsection>
					<table border="0" colspacing="1" cellpadding="1" width="100%">
						<thead>
							<tr>
								<th align="left" style="font-family: Arial; font-size: 12px; color: ##000000;">Participant's Name</th>
								<th align="left" width="20%" style="font-family: Arial; font-size: 12px; color: ##000000;">Email</th>
								<th align="center" width="15%" style="font-family: Arial; font-size: 12px; color: ##000000;">Days Attended</th>
								<th align="center" width="12%" style="font-family: Arial; font-size: 12px; color: ##000000;">PGP Points</th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="GetOrganizationRegistrations">
							<tr>
								<td align="left" style="font-family: Arial; font-size: 10px; color: ##000000;">#GetOrganizationRegistrations.Fname# #GetOrganizationRegistrations.LName#</td>
								<td align="left" width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;">#GetOrganizationRegistrations.Email#</td>
								<td align="center" width="15%" style="font-family: Arial; font-size: 10px; color: ##000000;">#GetOrganizationRegistrations.ParticipantDaysAttended#</td>
								<td align="center" width="12%" style="font-family: Arial; font-size: 10px; color: ##000000;">#GetOrganizationRegistrations.PGPPoints#</td>
							</tr>
						</cfloop>
						</tbody>
					</table>
				</cfdocumentsection>
			</cfdocument>
		</cfoutput>

		<cfswitch expression="#rc.$.siteConfig('siteID')#">
			<cfdefaultcase>
				<cfset FacilitatorName = #Session.getEventFacilitator.Fname# & " " & #Session.getEventFacilitator.Lname#>
				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
					<cfset temp = #Variables.SendEmailCFC.SendStatementofAttendanceToMembership(rc, Variables.ReportExportLoc, GetOrganizationRegistrations.ShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", GetOrganizationInformation.OrganizationName, "127.0.0.1")#>
				<cfelse>
					<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
						<cfif rc.$.siteConfig('mailserverssl') EQ "True">
							<cfset temp = #Variables.SendEMailCFC.SendStatementofAttendanceToMembership(rc, Variables.ReportExportLoc, GetOrganizationRegistrations.ShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", GetOrganizationInformation.OrganizationName, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
						<cfelse>
							<cfset temp = #Variables.SendEMailCFC.SendStatementofAttendanceToMembership(rc, Variables.ReportExportLoc, GetOrganizationRegistrations.ShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", GetOrganizationInformation.OrganizationName, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
						</cfif>
					<cfelse>
						<cfset temp = #Variables.SendEMailCFC.SendStatementofAttendanceToMembership(rc, Variables.ReportExportLoc, GetOrganizationRegistrations.ShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", GetOrganizationInformation.OrganizationName, rc.$.siteConfig('mailserverip'))#>
					</cfif>
				</cfif>
			</cfdefaultcase>
		</cfswitch>
	</cfloop>

	<cfswitch expression="#rc.$.siteConfig('siteID')#">
		<cfdefaultcase>
			<cfset FacilitatorName = #Session.getEventFacilitator.Fname# & " " & #Session.getEventFacilitator.Lname#>
			<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
				<cfset temp = #Variables.SendEmailCFC.SendStatementofAttendanceSummaryToFacilitator(rc, Variables.EmailSummaryLinks, Variables.EventShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", "127.0.0.1")#>
			<cfelse>
				<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
					<cfif rc.$.siteConfig('mailserverssl') EQ "True">
						<cfset temp = #Variables.SendEMailCFC.SendStatementofAttendanceSummaryToFacilitator(rc, Variables.EmailSummaryLinks, Variables.EventShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
					<cfelse>
						<cfset temp = #Variables.SendEMailCFC.SendStatementofAttendanceSummaryToFacilitator(rc, Variables.EmailSummaryLinks, Variables.EventShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
					</cfif>
				<cfelse>
					<cfset temp = #Variables.SendEMailCFC.SendStatementofAttendanceSummaryToFacilitator(rc, Variables.EmailSummaryLinks, Variables.EventShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", rc.$.siteConfig('mailserverip'))#>
				</cfif>
			</cfif>
		</cfdefaultcase>
	</cfswitch>

	<cfquery name="UpdateEventPGPCertificateFlag" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Update p_EventRegistration_Events
		Set PGPCertificatesGenerated = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">
	</cfquery>

	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=SentPGPCertificates&Successful=True" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=SentPGPCertificates&Successful=True" >
	</cfif>
	<cflocation url="#variables.newurl#" addtoken="false">
</cfif>