<cfif isDefined("URL.formSubmit") and isDefined("URL.RegistrationID")>
	<cfquery name="GetCertificateForSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		SELECT eEvents.ShortTitle, eEvents.EventDate, eRegistrations.RequestsMeal, eRegistrations.IVCParticipant, eRegistrations.AttendeePrice, tusers.Fname,
			tusers.Lname, tusers.Email, tusers.Company, eEvents.TContent_ID, eEvents.PGPAvailable, eEvents.PGPPoints, eRegistrations.WebinarParticipant, eRegistrations.User_ID,
			eRegistrations.RegistrationID,  eRegistrations.RegistrationDate, eEvents.EventDate1, eEvents.EventDate2, eEvents.EventDate3, eEvents.EventDate4, eEvents.EventDate5,
			eEvents.LongDescription, eEvents.Event_StartTime, eEvents.Event_EndTime, eEvents.MealProvided, eEvents.AllowVideoConference, eEvents.EventAgenda, eEvents.EventTargetAudience,
			eEvents.EventStrategies, eEvents.EventSpecialInstructions, eEvents.LocationType, eEvents.LocationID, eEvents.LocationRoomID, eEvents.Presenters, eEvents.WebinarAvailable,
			eEvents.WebinarConnectInfo, eEvents.WebinarMemberCost, eEvents.WebinarNonMemberCost, eRegistrations.RegisterByUserID
		FROM eRegistrations INNER JOIN eEvents ON eEvents.TContent_ID = eRegistrations.EventID INNER JOIN tusers ON tusers.UserID = eRegistrations.User_ID AND tusers.UserID = eRegistrations.User_ID
		WHERE eRegistrations.Site_ID = <cfqueryparam value="#Session.Mura.SiteID#" cfsqltype="cf_sql_varchar"> AND
			eRegistrations.TContent_ID = <cfqueryparam value="#URL.RegistrationID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery name="getEventLocation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, GeoCode_Latitude, GeoCode_Longitude
		From eFacility
		Where TContent_ID = #GetCertificateForSelectedEvent.LocationID#
	</cfquery>

	<cfif GetCertificateForSelectedEvent.User_ID NEQ GetCertificateForSelectedEvent.RegisterByUserID>
		<cfquery name="getRegisteredByUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select Fname, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#GetCertificateForSelectedEvent.RegisterByUserID#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset RegisteredBy = #getRegisteredByUserInfo.Lname# & ", " & #getRegisteredByUserInfo.Fname#>
	<cfelse>
		<cfset RegisteredBy = "self">
	</cfif>

	<cfset RegisteredDateFormatted = #DateFormat(GetCertificateForSelectedEvent.RegistrationDate, "full")#>

	<cfif GetCertificateForSelectedEvent.RequestsMeal EQ "1">
		<cfset UserRequestMeal = "Yes">
	<cfelse>
		<cfset UserRequestMeal = "No">
	</cfif>

	<cfif GetCertificateForSelectedEvent.IVCParticipant EQ "1">
		<cfset UserRequestDistanceEducation = "Yes">
	<cfelse>
		<cfset UserRequestDistanceEducation = "No">
	</cfif>

	<cfif GetCertificateForSelectedEvent.WebinarParticipant EQ "1">
		<cfset UserRequestWebinar = "Yes">
	<cfelse>
		<cfset UserRequestWebinar = "No">
	</cfif>

	<cfif GetCertificateForSelectedEvent.PGPAvailable EQ 1>
		<cfset PGPPointsFormatted = #NumberFormat(GetCertificateForSelectedEvent.PGPPoints, "99.99")#>
	<cfelse>
		<cfset NumberPGPPoints = 0>
		<cfset PGPPointsFormatted = #NumberFormat(Variables.NumberPGPPoints, "99.99")#>
	</cfif>

	<cfset DisplayEventDateInfo = #DateFormat(GetCertificateForSelectedEvent.EventDate, "ddd, mmm dd, yy")#>
	<cfif LEN(GetCertificateForSelectedEvent.EventDate1)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(GetCertificateForSelectedEvent.EventDate1, "ddd, mmm dd, yy")#></cfif>
	<cfif LEN(GetCertificateForSelectedEvent.EventDate2)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(GetCertificateForSelectedEvent.EventDate2, "ddd, mmm dd, yy")#></cfif>
	<cfif LEN(GetCertificateForSelectedEvent.EventDate3)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(GetCertificateForSelectedEvent.EventDate3, "ddd, mmm dd, yy")#></cfif>
	<cfif LEN(GetCertificateForSelectedEvent.EventDate4)><cfset DisplayEventDateInfo = #Variables.DisplayEventDateInfo# & ", " & #DateFormat(GetCertificateForSelectedEvent.EventDate4, "ddd, mmm dd, yy")#></cfif>

	<cfif GetCertificateForSelectedEvent.WebinarParticipant EQ 1 and GetCertificateForSelectedEvent.WebinarAvailable EQ 1>
		<cfset FacilityEventLocationText = "Online Webinar: Connection Details to follow in email from presenter.">
	<cfelse>
		<cfset FacilityLocationMapURL = "https://maps.google.com/maps?q=#getEventLocation.GeoCode_Latitude#,#getEventLocation.GeoCode_Longitude#">
		<cfset FacilityLocationFileName = #reReplace(getEventLocation.FacilityName, "[[:space:]]", "", "ALL")#>
		<cfset FacilityEventLocationText = #getEventLocation.FacilityName# & " (" & #getEventLocation.PhysicalAddress# & " " & #getEventLocation.PhysicalCity# & ", " & #getEventLocation.PhysicalState# & " " & #getEventLocation.PhysicalZipCode# & ")">
	</cfif>


	<cfset CurLoc = #ExpandPath("/")#>
	<cfset FileStoreLoc = #Variables.CurLoc# & "plugins/EventRegistration">
	<cfset UserRegistrationPDFFilename = #GetCertificateForSelectedEvent.RegistrationID# & ".pdf">
	<cfset FileStoreLoc = #Variables.FileStoreLoc# & "/temp/">
	<cfset UserRegistrationPDFAbsoluteFilename = #Variables.FileStoreLoc# & #Variables.UserRegistrationPDFFilename#>
	<cfset UserRegistrationPDFWebFilename = "/" & "plugins/EventRegistration/temp/" & #Variables.UserRegistrationPDFFilename#>
	<cfset PDFFormTemplateDir = #Variables.CurLoc# & "plugins/EventRegistration/library/components/PDFFormTemplates/">
	<cfset EventConfirmationTemplateLoc = #Variables.PDFFormTemplateDir# & "EventConfirmationPage.pdf">

	<cfif GetCertificateForSelectedEvent.WebinarParticipant EQ 1 and GetCertificateForSelectedEvent.WebinarAvailable EQ 1>
		<cfset FacilityEventLocationText = "Online Webinar: Connection Details to follow in email from presenter.">
	<cfelseif GetCertificateForSelectedEvent.WebinarAvailable EQ 0>
		<cfset FacilityLocationMapURL = "https://maps.google.com/maps?q=#getEventLocation.GeoCode_Latitude#,#getEventLocation.GeoCode_Longitude#">
		<cfset FacilityLocationFileName = #reReplace(getEventLocation.FacilityName, "[[:space:]]", "", "ALL")#>
		<cfset FacilityLocationFileName = #reReplace(Variables.FacilityLocationFileName, "'", "", "ALL")#>
		<cfset FacilityEventLocationText = #getEventLocation.FacilityName# & " (" & #getEventLocation.PhysicalAddress# & " " & #getEventLocation.PhysicalCity# & ", " & #getEventLocation.PhysicalState# & " " & #getEventLocation.PhysicalZipCode# & ")">
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
		PDFForm.setField("RegistrationNumber", "#GetCertificateForSelectedEvent.RegistrationID#");
		PDFForm.setField("ParticipantFirstName", "#GetCertificateForSelectedEvent.Fname#");
		PDFForm.setField("ParticipantLastName", "#GetCertificateForSelectedEvent.LName#");
		PDFForm.setField("RegisteredDate", "#variables.RegisteredDateFormatted#");
		PDFForm.setField("RegisteredBy", "#Variables.RegisteredBy#");
		PDFForm.setField("EventTitle", "#GetCertificateForSelectedEvent.ShortTitle#");
		PDFForm.setField("RequestMeal", "#Variables.UserRequestMeal#");
		PDFForm.setField("DistanceEducation", "#Variables.UserRequestDistanceEducation#");
		PDFForm.setField("PGPPoints", "#Variables.PGPPointsFormatted#");
		PDFForm.setField("EventCost", "#DollarFormat(GetCertificateForSelectedEvent.AttendeePrice)#");
		PDFForm.setField("EventLocationInformation", "#Variables.FacilityEventLocationText#");
		PDFForm.setField("EventDates", "#Variables.DisplayEventDateInfo#");
		PDFForm.setField("EventDescription", "#GetCertificateForSelectedEvent.LongDescription#");

		PDFStamper.setFormFlattening(true);
		PDFStamper.close();
		PDFReader.close();
		FileIO.close();
	</cfscript>

	<cfoutput>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Viewing Event Registration</h3>
			</div>
			<div class="art-blockcontent">
				<div align="Center"><a href="http://events.niesc.k12.in.us/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.manageregistrations" class="art-button">Return to Registration Listing</a></div>
				<table class="art-article" border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
					<tbody>
						<tr>
							<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 99%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
								<embed src="#Variables.UserRegistrationPDFWebFilename#" width="800" height="900">
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</cfoutput>
<cfelseif not isDefined("FORM.formSubmit") and not isDefined("FORM.CertificatelEventID")>
	<cflocation url="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.manageregistrations" addtoken="false">
<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.CertificatelEventID")>
	<cfquery name="GetCertificateForSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		SELECT eEvents.ShortTitle, eEvents.EventDate, eRegistrations.RequestsMeal, eRegistrations.IVCParticipant, eRegistrations.AttendeePrice, tusers.Fname,
			tusers.Lname, tusers.Email,  tusers.Company,eEvents.TContent_ID, eEvents.PGPAvailable, eEvents.PGPPoints, eRegistrations.WebinarParticipant
		FROM eRegistrations INNER JOIN eEvents ON eEvents.TContent_ID = eRegistrations.EventID INNER JOIN tusers ON tusers.UserID = eRegistrations.UserID
		WHERE eRegistrations.Site_ID = <cfqueryparam value="#Session.Mura.SiteID#" cfsqltype="cf_sql_varchar"> AND
			eEvents.TContent_ID = <cfqueryparam value="#FORM.CertificatelEventID#" cfsqltype="cf_sql_integer">
	</cfquery>
	<cfset CertificateTemplateDir = #Left(ExpandPath("*"), Find("*", ExpandPath("*")) - 1)#>
	<cfset ParticipantName = #GetCertificateForSelectedEvent.FName# & " " & #GetCertificateForSelectedEvent.LName#>
	<cfset ParticipantFilename = #Replace(Variables.ParticipantName, " ", "", "all")#>
	<cfset ParticipantFilename = #Replace(Variables.ParticipantFilename, ".", "", "all")#>
	<cfset PGPEarned = "PGP Earned: " & #NumberFormat(GetCertificateForSelectedEvent.PGPPoints, "99.9")#>
	<cfset CertificateMasterTemplate = #Variables.CertificateTemplateDir# & "library/reports/" & "NIESCRisePGPCertificateTemplate.pdf">
	<cfset CertificateCompletedFile = #Variables.CertificateTemplateDir# & "library/ReportExports/" & #Variables.ParticipantFilename# & ".pdf">
	<cfscript>
		PDFCompletedCertificate = CreateObject("java", "java.io.FileOutputStream").init(CertificateCompletedFile);
		PDFMasterCertificateTemplate = CreateObject("java", "com.itextpdf.text.pdf.PdfReader").init(CertificateMasterTemplate);
		PDFStamper = CreateObject("java", "com.itextpdf.text.pdf.PdfStamper").init(PDFMasterCertificateTemplate, PDFCompletedCertificate);
		PDFStamper.setFormFlattening(true);
		PDFFormFields = PDFStamper.getAcroFields();
		PDFFormFields.setField("PGPEarned", Variables.PGPEarned);
		PDFFormFields.setField("ParticipantName", Variables.ParticipantName);
		PDFFormFields.setField("EventTitle", GetCertificateForSelectedEvent.ShortTitle);
		PDFFormFields.setField("EventDate", DateFormat(GetCertificateForSelectedEvent.EventDate, "full"));
		PDFFormFields.setField("SignDate", DateFormat(GetCertificateForSelectedEvent.EventDate, "mm/dd/yyyy"));
		PDFStamper.close();
	</cfscript>
	<cfoutput>
		<div align="center"><h4>Viewing Requested Certificate</h4></div>
		<div class="alert-box notice">Click <a href="" class="art-button">here</a> to return to the listing of events for a different certificate.</div>
		<hr>
		<table class="art-article" border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
			<tbody>
				<tr>
					<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 99%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
						<embed src="/plugins/EventRegistration/library/ReportExports/#Variables.ParticipantFilename#.pdf" width="850" height="900">
					</td>
				</tr>
			</tbody>
		</table>
	</cfoutput>
</cfif>





<!---







--->