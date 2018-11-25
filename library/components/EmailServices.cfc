<cfcomponent displayName="Event Registration Email Routines">
	<cffunction name="SendAccountActivationEmail" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="UserID" type="String" Required="True">

		<cfquery name="getUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, UserName, Email, created
			From tusers
			Where UserID = <cfqueryparam value="#Arguments.UserID#" cfsqltype="cf_sql_varchar"> and
				InActive = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
		</cfquery>
		<cfset ValueToEncrypt = "UserID=" & #Arguments.UserID# & "&" & "Created=" & #getUserAccount.created# & "&DateSent=" & #Now()#>
		<cfset EncryptedValue = #Tobase64(Variables.ValueToEncrypt)#>
		<cfset AccountVars = "Key=" & #Variables.EncryptedValue#>
		<cfset AccountActiveLink = "http://" & #CGI.Server_Name# & "#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:registeruser.activateaccount&" & #Variables.AccountVars#>
		<cfinclude template="EmailTemplates/SendAccountActivationEmailToIndividual.cfm">
	</cffunction>

	<cffunction name="SendAccountActivationEmailConfirmation" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="UserID" type="String" Required="True">

		<cfquery name="getUserAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, UserName, Email, created
			From tusers
			Where UserID = <cfqueryparam value="#Arguments.UserID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfinclude template="EmailTemplates/AccountActivationConfirmationEmailToIndividual.cfm">
	</cffunction>

	<cffunction name="SendCommentFormToAdmin" ReturnType="Any" Output="True">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="EmailInfo" type="struct" Required="True">

		<cfquery name="getAdminGroup" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Email
			From tusers
			Where SiteID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar"> and
				UserName = <cfqueryparam value="admin" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfinclude template="EmailTemplates/CommentFormInquiryTemplateToAdmin.cfm">
	</cffunction>

	<cffunction name="SendEventCancellationToSingleParticipant" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="Info" type="Struct" Required="True">

		<cfquery name="GetRegisteredEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			SELECT p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_UserRegistrations.AttendedEvent, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegistrationID,  p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.EventID, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.PGPPoints
			FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
			WHERE p_EventRegistration_UserRegistrations.RegistrationID = <cfqueryparam value="#Arguments.Info.RegistrationID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfquery name="getRegisteredUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#GetRegisteredEvent.User_ID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfquery name="DeleteRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Delete from p_EventRegistration_UserRegistrations
			Where RegistrationID = <cfqueryparam value="#Arguments.Info.RegistrationID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfinclude template="EmailTemplates/EventRegistrationCancellationToIndividual.cfm">

	</cffunction>

	<cffunction name="SendEventRegistrationToSingleParticipant" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="RegistrationRecordID" type="String" Required="True">

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
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, LocationID, LocationRoomID, PGPAvailable, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
			From p_EventRegistration_Events
			Where TContent_ID = <cfqueryparam value="#getRegistration.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getEventLocation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, GeoCode_Latitude, GeoCode_Longitude
			From p_EventRegistration_Facility
			Where TContent_ID = <cfqueryparam value="#getEvent.LocationID#" cfsqltype="cf_sql_integer">
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
		<cfset FileStoreLoc = #Variables.CurLoc# & "plugins/#HTMLEditFormat(rc.pc.getPackage())#">
		<cfset UserRegistrationPDFFilename = #getRegistration.RegistrationID# & ".pdf">
		<cfset UserRegistrationiCalFilename = #getRegistration.RegistrationID# & ".ics">
		<cfset FileStoreLoc = #Variables.FileStoreLoc# & "/temp/">
		<cfset UserRegistrationPDFAbsoluteFilename = #Variables.FileStoreLoc# & #Variables.UserRegistrationPDFFilename#>
		<cfset UserRegistrationiCalAbsoluteFilename = #Variables.FileStoreLoc# & #Variables.UserRegistrationiCalFilename#>
		<cfset PDFFormTemplateDir = #Variables.CurLoc# & "plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/PDFFormTemplates/">
		<cfset EventConfirmationTemplateLoc = #Variables.PDFFormTemplateDir# & "EventConfirmationPage.pdf">

		<cfif getRegistration.WebinarParticipant EQ 1 and getEvent.WebinarAvailable EQ 1>
			<cfset FacilityEventLocationText = "Online Webinar: Connection Details to follow in email from presenter.">
		<cfelseif getEvent.WebinarAvailable EQ 0>
			<cfset FacilityLocationMapURL = "https://maps.google.com/maps?q=#getEventLocation.GeoCode_Latitude#,#getEventLocation.GeoCode_Longitude#">
			<cfset FacilityLocationFileName = #reReplace(getEventLocation.FacilityName, "[[:space:]]", "", "ALL")#>
			<cfset FacilityLocationFileName = #reReplace(Variables.FacilityLocationFileName, "'", "", "ALL")#>
			<cfset FacilityURLAndImage = #EventServicesComponent.QRCodeImage(Variables.FacilityLocationMapURL,HTMLEditFormat(rc.pc.getPackage()),Variables.FacilityLocationFileName)#>
			<cfset FacilityFileDirAndImage = #Variables.CurLoc# & #Variables.FacilityURLAndImage#>
			<cfset FacilityEventLocationText = #getEventLocation.FacilityName# & " (" & #getEventLocation.PhysicalAddress# & " " & #getEventLocation.PhysicalCity# & ", " & #getEventLocation.PhysicalState# & " " & #getEventLocation.PhysicalZipCode# & ")">
		</cfif>

		<cfset UserRegistrationiCalData = #EventServicesComponent.iCalUS(rc, Arguments.RegistrationRecordID)#>

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
		<cfinclude template="EmailTemplates/EventRegistrationConfirmationToIndividual.cfm">
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
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, LocationID, LocationRoomID, PGPAvailable, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
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

	<cffunction name="SendEventMessageToAllParticipants" returntype="Any" Output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="ParticipantInfo" type="struct" Required="True">
		<cfinclude template="EmailTemplates/SendEventMessageToParticipantsFromFacilitator.cfm">
	</cffunction>



















	<cffunction name="SendEventInquiryToFacilitator" ReturnType="Any" Output="False">
		<cfargument name="EmailInfo" type="struct" Required="True">

		<cfquery name="getEvent" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, MemberCost, NonMemberCost,  EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Presenters, Facilitator
			From eEvents
			Where Site_ID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar"> and
				TContent_ID = <cfqueryparam value="#Arguments.EmailInfo.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfinclude template="EmailTemplates/EventInquiryTemplateToFacilitator.cfm">
	</cffunction>

	<cffunction name="SendEventInquiryToIndividual" ReturnType="Any" Output="False">
		<cfargument name="EmailInfo" type="struct" Required="True">

		<cfquery name="getEvent" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, MemberCost, NonMemberCost,  EarlyBird_RegistrationAvailable, EarlyBird_RegistrationDeadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Presenters, Facilitator
			From eEvents
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

	<cffunction name="SendTemporaryPasswordToUser" returntype="Any" Output="false">
		<cfargument name="Email" type="String" Required="True">

		<cfquery name="GetAccountUsername" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select UserID, Fname, Lname, UserName, Email, created
			From tusers
			Where Email = <cfqueryparam value="#Arguments.Email#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#Session.FormData.PluginInfo.SiteID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<!--- Setup Available Alphanumeric Values --->
		<cfset strLowerCaseAlpha = "abcdefghijlkmnopqrstuvwxyz">
		<cfset strUpperCaseAlpha = UCase(variables.strLowerCaseAlpha)>
		<cfset strNumbers = "0123456789">
		<cfset strOtherCharacters = "~!@$%^&*()-+">
		<cfset strAllValidCharacters = #variables.strLowerCaseAlpha# & #variables.strUpperCaseAlpha# & #variables.strNumbers#>
		<cfset arrPassword = ArrayNew(1)>
		<cfset arrPassword[1] = #Mid(variables.strNumbers, RandRange(1, Len(variables.strNumbers)), 1)#>
		<cfset arrPassword[2] = #Mid(variables.strLowerCaseAlpha, RandRange(1, Len(variables.strLowerCaseAlpha)), 1)#>
		<cfset arrPassword[3] = #Mid(variables.strUpperCaseAlpha, RandRange(1, Len(variables.strUpperCaseAlpha)), 1)#>
		<cfset arrPassword[4] = #Mid(variables.strOtherCharacters, RandRange(1, Len(variables.strOtherCharacters)), 1)#>

		<cfloop index="initChar" from="#(ArrayLen(arrPassword) + 1)#" to="8" step="1">
			<cfset arrPassword[initChar] = #Mid(variables.strAllValidCharacters, RandRange(1, Len(variables.strAllValidCharacters)), 1)#>
		</cfloop>

		<!--- Now that we have an array that has the proper number of characters, lets shuffle the array into a random order --->
		<cfset CreateObject("java", "java.util.Collections").Shuffle(variables.arrPassword)>

		<!--- Now we have a randomly suffled array, we just need to join all the characters into a single string. --->
		<cfset strPassword = #ArrayToList(variables.arrPassword, "")#>

		<cfquery name="setNewAccountPassword" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Update tusers
			Set Password = <cfqueryparam value="#Hash(Variables.strPassword)#" cfsqltype="cf_sql_varchar">
			Where UserID = <cfqueryparam value="#GetAccountUsername.UserID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<!---
			// Note: The following produced Error of: key [MURA] doesn't exist.
		<cfset UpdateUser = #Application.userManager.readByUsername(GetAccountUsername.UserName, Session.FormData.PluginInfo.SiteID)#>
		<cfset UpdateUser.setPassword(Variables.strPassword)>
		<cfset UpdateUser.setSiteID(Session.FormData.PluginInfo.SiteID)>
		<cfset UserAccountUpdated = #Application.userManager.save(UpdateUser)#>
		--->

		<cfinclude template="EmailTemplates/SendTemporaryPasswordToUser.cfm">
	</cffunction>

	<cffunction name="SendPGPCertificateToIndividual" returntype="Any" output="False">
		<cfargument name="ParticipantInfo" type="struct" Required="True">
		<cfinclude template="EmailTemplates/SendEventPGPCertificateToIndividual.cfm">
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


	<cffunction name="SendEventCancellationToSingleParticipant" returntype="Any" Output="false">
		<cfargument name="Info" type="Struct" Required="True">

		<cfquery name="GetRegisteredEvent" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			SELECT eEvents.ShortTitle, eEvents.EventDate, eRegistrations.AttendedEvent, eRegistrations.User_ID, eRegistrations.RegistrationID,  eRegistrations.OnWaitingList, eRegistrations.EventID, eEvents.PGPAvailable, eEvents.PGPPoints
			FROM eRegistrations INNER JOIN eEvents ON eEvents.TContent_ID = eRegistrations.EventID
			WHERE eRegistrations.RegistrationID = <cfqueryparam value="#Arguments.Info.RegistrationID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfquery name="getRegisteredUserInfo" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select Fname, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#GetRegisteredEvent.User_ID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfquery name="DeleteRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Delete from eRegistrations
			Where TContent_ID = <cfqueryparam value="#Arguments.Info.RegistrationID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfinclude template="EmailTemplates/EventRegistrationCancellationToIndividual.cfm">

	</cffunction>

	<cffunction name="SendEventCancellationByFacilitatorToSingleParticipant" returntype="Any" Output="false">
		<cfargument name="Info" type="Struct" Required="True">

		<cfquery name="GetRegisteredEvent" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			SELECT eEvents.ShortTitle, eEvents.EventDate, eRegistrations.AttendedEvent, eRegistrations.User_ID, eRegistrations.RegistrationID,  eRegistrations.OnWaitingList, eRegistrations.EventID, eEvents.PGPAvailable, eEvents.PGPPoints
			FROM eRegistrations INNER JOIN eEvents ON eEvents.TContent_ID = eRegistrations.EventID
			WHERE eRegistrations.RegistrationID = <cfqueryparam value="#Arguments.Info.RegistrationID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfquery name="getRegisteredUserInfo" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select Fname, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#GetRegisteredEvent.User_ID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfquery name="DeleteRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Delete from eRegistrations
			Where RegistrationID = <cfqueryparam value="#Arguments.Info.RegistrationID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfinclude template="EmailTemplates/EventRegistrationCancellationByFacilitatorToIndividual.cfm">

	</cffunction>

	<cffunction name="SendEventRegistrationToParticipantFromAnother" returntype="Any" Output="false">
		<cfargument name="RegistrationRecordID" type="string" Required="True">

		<cfset EventServicesComponent = createObject("component","plugins/#Session.FormData.PluginInfo.PackageName#/library/components/EventServices")>

		<cfquery name="getRegistration" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select RegistrationID, RegistrationDate, User_ID, EventID, RequestsMeal, IVCParticipant, AttendeePrice, RegisterByUserID, OnWaitingList, Comments, WebinarParticipant
			From eRegistrations
			Where TContent_ID = <cfqueryparam value="#Arguments.RegistrationRecordID#" cfsqltype="cf_sql_integer">
		</cfquery>

		<cfquery name="getRegisteredUserInfo" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select Fname, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getRegistration.User_ID#" cfsqltype="cf_sql_varchar">
		</cfquery>

		<cfif GetRegistration.User_ID EQ getRegistration.RegisterByUserID>
			<cfset RegisteredBy = "self">
		<cfelse>
			<cfquery name="getWhoRegisteredUserInfo" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
				Select Fname, Lname, Email
				From tusers
				Where UserID = <cfqueryparam value="#getRegistration.RegisterByUserID#" cfsqltype="cf_sql_varchar">
			</cfquery>
			<cfset RegisteredBy = #getWhoRegisteredUserInfo.Lname# & ", " & #getWhoRegisteredUserInfo.Fname#>
		</cfif>

		<cfquery name="getEvent" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, LocationType, LocationID, LocationRoomID, PGPAvailable, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
			From eEvents
			Where TContent_ID = <cfqueryparam value="#getRegistration.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>

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
			<cfquery name="getEventLocation" Datasource="#Session.FormData.PluginInfo.Datasource#" username="#Session.FormData.PluginInfo.DBUsername#" password="#Session.FormData.PluginInfo.DBPassword#">
				Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, GeoCode_Latitude, GeoCode_Longitude
				From eFacility
				Where TContent_ID = #getEvent.LocationID#
			</cfquery>
			<cfset FacilityLocationMapURL = "https://maps.google.com/maps?q=#getEventLocation.GeoCode_Latitude#,#getEventLocation.GeoCode_Longitude#">
			<cfset FacilityLocationFileName = #reReplace(getEventLocation.FacilityName, "[[:space:]]", "", "ALL")#>
			<cfset FacilityURLAndImage = #EventServicesComponent.QRCodeImage(Variables.FacilityLocationMapURL,HTMLEditFormat(Session.FormData.PluginInfo.PackageName),Variables.FacilityLocationFileName)#>
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

		<cfif getRegistration.WebinarParticipant EQ 0>
			<cfset FacilityURLAndImage = #Variables.CurLoc# & #Variables.FacilityURLAndImage#>
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
				img = QRCodeImage.getInstance(Variables.FacilityURLAndImage);
				img.setAbsolutePosition(javacast("float","500"),javacast("float", "277"));
				PDFContent.addImage(img);
			}


			PDFStamper.setFormFlattening(true);
			PDFStamper.close();
			PDFReader.close();
			FileIO.close();
		</cfscript>
		<cfinclude template="EmailTemplates/EventRegistrationConfirmationToIndividualFromAnother.cfm">

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
			Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, LocationType, LocationID, LocationRoomID, PGPAvailable, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost
			From eEvents
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



