<cfif not isDefined("FORM.formSubmit") and not isDefined("FORM.EventID")>
	<cfquery name="GetRegisteredEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		SELECT eEvents.TContent_ID, eEvents.ShortTitle, eEvents.EventDate, eRegistrations.RequestsMeal, eEvents.PGPAvailable, eEvents.PGPPoints, eRegistrations.IVCParticipant, eRegistrations.AttendeePrice, eRegistrations.WebinarParticipant
		FROM eRegistrations INNER JOIN eEvents ON eEvents.TContent_ID = eRegistrations.EventID
		WHERE eRegistrations.Site_ID = <cfqueryparam value="#Session.Mura.SiteID#" cfsqltype="cf_sql_varchar"> AND
			eRegistrations.UserID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
		ORDER BY eRegistrations.RegistrationDate DESC
	</cfquery>
	<cfparam name="HaveCertificatesAvailable" default="false">
	<cfoutput>
		<div align="center"><h4>List of current events you have registered for</h4></div>
		<hr>
		<Form method="Post" action="" id="">
			<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<input type="hidden" name="formSubmit" value="true">
			<table class="art-article" border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 99%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
							<table class="art-article" style="width: 100%;">
								<thead>
									<tr>
										<td width="200" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Event Title</td>
										<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Event Date</td>
										<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Requests Meal</td>
										<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Distance Learning</td>
										<td width="70" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Webinar</td>
										<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Event Price</td>
										<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">Actions</td>
									</tr>
								</thead>
								<tbody>
									<cfloop query="GetRegisteredEvents">
										<tr>
											<td width="200" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">#GetRegisteredEvents.ShortTitle#</td>
											<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">#DateFormat(GetRegisteredEvents.EventDate, "mmm dd, yyyy")#</td>
											<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;"><cfif GetRegisteredEvents.RequestsMeal EQ 0>No<cfelse>Yes</cfif></td>
											<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;"><cfif GetRegisteredEvents.IVCParticipant EQ 0>No<cfelse>Yes</cfif></td>
											<td width="70" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;"><cfif GetRegisteredEvents.WebinarParticipant EQ 0>No<cfelse>Yes</cfif></td>
											<td width="100" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">#DollarFormat(GetRegisteredEvents.AttendeePrice)#</td>
											<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
												<Input type="Radio" name="CancelEventID" value="#GetRegisteredEvents.TContent_ID#" >Cancel Registration<br>
												<cfif GetRegisteredEvents.PGPAvailable EQ 1>
													<Input type="Radio" name="CertificatelEventID" value="#GetRegisteredEvents.TContent_ID#" >View Certificate
												</cfif>
											</td>
										</tr>
									</cfloop>
								</tbody>
								<tfoot>
									<tr>
										<td colspan="7" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;"><input type="Submit" Name="GetCertificate" Value="Perform Selected Action"></td>
									</tr>
								</tfoot>
							</table>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</cfoutput>
<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.EventID")>
	<cfquery name="GetCertificateForSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		SELECT eEvents.ShortTitle, eEvents.EventDate, eRegistrations.RequestsMeal, eRegistrations.IVCParticipant, eRegistrations.AttendeePrice, tusers.Fname,
			tusers.Lname, tusers.Email,  tusers.Company,eEvents.TContent_ID, eEvents.PGPAvailable, eEvents.PGPPoints, eRegistrations.WebinarParticipant
		FROM eRegistrations INNER JOIN eEvents ON eEvents.TContent_ID = eRegistrations.EventID INNER JOIN tusers ON tusers.UserID = eRegistrations.UserID
		WHERE eRegistrations.Site_ID = <cfqueryparam value="#Session.Mura.SiteID#" cfsqltype="cf_sql_varchar"> AND
			eEvents.TContent_ID = <cfqueryparam value="#FORM.EventID#" cfsqltype="cf_sql_integer">
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