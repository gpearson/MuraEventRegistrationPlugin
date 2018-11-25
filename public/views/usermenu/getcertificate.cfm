<cfif isDefined("URL.formSubmit") and isDefined("URL.CertificateEventID")>

	<cfquery name="GetCertificateForSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		SELECT eEvents.ShortTitle, eEvents.EventDate, eRegistrations.RequestsMeal, eRegistrations.IVCParticipant, eRegistrations.AttendeePrice, tusers.Fname,
			tusers.Lname, tusers.Email,  tusers.Company,eEvents.TContent_ID, eEvents.PGPAvailable, eEvents.PGPPoints, eRegistrations.WebinarParticipant
		FROM eRegistrations INNER JOIN eEvents ON eEvents.TContent_ID = eRegistrations.EventID INNER JOIN tusers ON tusers.UserID = eRegistrations.User_ID
		WHERE eRegistrations.Site_ID = <cfqueryparam value="#Session.Mura.SiteID#" cfsqltype="cf_sql_varchar"> AND
			eRegistrations.TContent_ID = <cfqueryparam value="#URL.CertificateEventID#" cfsqltype="cf_sql_integer">
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
		<div class="alert-box notice">Click <a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:usermenu.manageregistrations" class="art-button">here</a> to return to the listing of events for a different certificate.</div>
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