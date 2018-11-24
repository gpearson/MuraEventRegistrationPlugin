<!--- 
		#HTMLEditFormat(rc.pc.getPackage())# = EventRegistration
		/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_Logo.png
	--->

<cfset RegistrationID = "2565F7B5-9F96-450A-8D1A343BE983F3F1">

<cfquery name="getRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select RegistrationID, RegistrationDate, UserID, EventID, RequestsMeal, IVCParticipant, AttendeePrice, RegisterByUserID, OnWaitingList, Comments
	From eRegistrations
	Where RegistrationID = <cfqueryparam value="#Variables.RegistrationID#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfquery name="getRegisteredUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select Fname, Lname, Email
	From tusers
	Where UserID = <cfqueryparam value="#getRegistration.UserID#" cfsqltype="cf_sql_varchar">
</cfquery>
		
<cfif getRegistration.UserID NEQ getRegistration.RegisterByUserID>
	<cfquery name="getRegisteredByUserInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Select Fname, Lname, Email
		From tusers
		Where UserID = <cfqueryparam value="#getRegistration.RegisterByUserID#" cfsqltype="cf_sql_varchar">
	</cfquery>
</cfif>
		
<cfquery name="getEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, LongDescription, Event_StartTime, Event_EndTime, PGPAvailable, PGPPoints, MealProvided, AllowVideoConference, VideoConferenceInfo, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, LocationType, LocationID, LocationRoomID, Registration_BeginTime, Registration_EndTime
	From eEvents
	Where TContent_ID = <cfqueryparam value="#getRegistration.EventID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="getEventLocation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, GeoCode_Latitude, GeoCode_Longitude
	From eFacility
	Where FacilityType = '#getEvent.LocationType#' and TContent_ID = #getEvent.LocationID#
</cfquery>


<cfif GetRegistration.UserID EQ getRegistration.RegisterByUserID>
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



<cfset EventServicesComponent = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
<cfset FacilityLocationMapURL = "https://maps.google.com/maps?q=#getEventLocation.GeoCode_Latitude#,#getEventLocation.GeoCode_Longitude#">
<cfset FacilityLocationFileName = #reReplace(getEventLocation.FacilityName, "[[:space:]]", "", "ALL")#>
<cfset FacilityURLAndImage = #EventServicesComponent.QRCodeImage(Variables.FacilityLocationMapURL,HTMLEditFormat(rc.pc.getPackage()),Variables.FacilityLocationFileName)#>
<cfset FacilityURLAndImage = #Variables.BaseDir# & #Variables.FacilityURLAndImage#>
<cfset FacilityEventLocationText = #getEventLocation.FacilityName# & " (" & #getEventLocation.PhysicalAddress# & " " & #getEventLocation.PhysicalCity# & ", " & #getEventLocation.PhysicalState# & " " & #getEventLocation.PhysicalZipCode# & ")">

<cfset CurLoc = #ExpandPath("/")#>
<cfset FileStoreLoc = #Variables.CurLoc# & "plugins/#HTMLEditFormat(rc.pc.getPackage())#/temp">
<cfset ImageFilename = #getRegistration.RegistrationID# & ".pdf">
<cfset FileWritePathWithName = #Variables.FileStoreLoc# & "/" & #Variables.ImageFilename#>
<cfset ImageStoreLoc = "http://" & #CGI.SERVER_NAME# & "/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images" & "/NIESC_Logo.png">

<cfscript>
	ReadPDF = ExpandPath("EventConfirmationPage.pdf");
	WritePDF = Variables.FileWritePathWithName;
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
	img = QRCodeImage.getInstance(Variables.FacilityURLAndImage);
	img.setAbsolutePosition(javacast("float","500"),javacast("float", "277"));
	PDFContent.addImage(img);
	
	PDFStamper.setFormFlattening(true);
	PDFStamper.close();
	PDFReader.close();
	FileIO.close();
</cfscript>
<cfcontent type="application/pdf" deleteFile="yes" file="#WritePDF#">
<cfdump var="#img#">
<cfabort>

<cfsavecontent variable="EventConfirmationPage">
<cfoutput>
<table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
	<tr>
		<td width="350"><img src="#Variables.ImageStoreLoc#"></td>
		<td valign="middle" align="center"><address><strong>Northern Indiana Educational Services Center</strong><br>56535 Magnetic Drive<br>Mishawaka IN 46545<br>V: (574) 254-0111 / (800) 326-5642</address></td>
	</tr>
	<tr><th colspan="2"><h3>&nbsp;</h3></th></tr>
	<tr><th colspan="2"><h3>Event Confirmation Receipt for #getRegisteredUserInfo.FName# #getRegisteredUserInfo.LName#</h3></th></tr>
	<tr class="well">
		<td colspan="2">
			<table border="0" align="center" width="75%" cellspacing="0" cellpadding="0">
				<tr>
					<td style="font-family: Arial; font-style: normal; font-size: 14px; font-weight: bold;">Registration Number</td>
					<td style="font-family: Arial; font-style: normal; font-size: 14px; font-weight: normal;">#getRegistration.RegistrationID#</td>
				</tr>
				<tr>
					<td colspan="2" style="font-family: Arial; font-style: normal; font-size: 14px; font-weight: bold;">&nbsp;</td>
				</tr>
				<tr>
					<td style="font-family: Arial; font-size: 14px; font-weight: bold;">Participant's First Name</td>
					<td>#getRegisteredUserInfo.FName#</td>
				</tr>
				<tr>
					<td style="font-family: Arial; font-size: 14px; font-weight: bold;">Participant's Last Name</td>
					<td>#getRegisteredUserInfo.LName#</td>
				</tr>
				<tr>
					<td style="font-family: Arial; font-size: 14px; font-weight: bold;">Registered Date</td>
					<td>#DateFormat(getRegistration.RegistrationDate, "full")#</td>
				</tr>
				<cfif getRegistration.UserID NEQ getRegistration.RegisterByUserID>
					<tr>
						<td style="font-family: Arial; font-size: 14px; font-weight: bold;">Registered By</td>
						<td>#getRegisteredByUserInfo.Lname# #getRegisteredByUserInfo.Fname#</td>
					</tr>
				</cfif>
				<tr>
					<td style="font-family: Arial; font-size: 14px; font-weight: bold;">Event Title</td>
					<td>#getEvent.ShortTitle#</td>
				</tr>
				<tr>
					<td style="font-family: Arial; font-size: 14px; font-weight: bold;">Request's Meal</td>
					<td><cfif getRegistration.RequestsMeal EQ 1>Yes<cfelse>No</cfif></td>
				</tr>
				<tr>
					<td style="font-family: Arial; font-size: 14px; font-weight: bold;">Distance Education</td>
					<td><cfif getRegistration.IVCParticipant EQ 1>Yes<cfelse>No</cfif></td>
				</tr>
				<cfif getEvent.PGPAvailable EQ 1>
					<tr>
						<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Professional Growth Points</td>
						<td style="font-family: Arial; font-size: 14px; font-weight: normal;">#NumberFormat(getEvent.PGPPoints, "99.99")#</td>
					</tr>
				</cfif>
				<tr>
					<td style="font-family: Arial; font-size: 14px; font-weight: bold;">Event Cost</td>
					<td style="font-family: Arial; font-size: 14px; font-weight: bold;">#DollarFormat(getRegistration.AttendeePrice)#</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2" style="font-family: Arial; font-size: 24px; font-weight: bold;" Align="Center">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="2" style="font-family: Arial; font-size: 24px; font-weight: bold;" Align="Center">Event Information</td>
	</tr>
	<tr>
		<td colspan="2">
			<table class="table table-bordered" border="0" align="center" width="90%" cellspacing="0" cellpadding="0">
				<tr>
					<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Event Date(s)</td>
					<td style="font-family: Arial; font-size: 14px; font-weight: normal;">#DateFormat(getEvent.EventDate, "mmm dd, yyyy")#<cfif isDate(getEvent.EventDate1)>, #DateFormat(getEvent.EventDate1, "mmm dd, yyyy")#</cfif><cfif isDate(getEvent.EventDate2)>, #DateFormat(getEvent.EventDate2, "mmm dd, yyyy")#</cfif><cfif isDate(getEvent.EventDate3)>, #DateFormat(getEvent.EventDate3, "mmm dd, yyyy")#</cfif><cfif isDate(getEvent.EventDate4)>, #DateFormat(getEvent.EventDate4, "mmm dd, yyyy")#</cfif></td>
				</tr>
				<tr>
					<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Event Time</td>
					<td style="font-family: Arial; font-size: 14px; font-weight: normal;">#TimeFormat(getEvent.Event_StartTime, "long")# till #TimeFormat(getEvent.Event_EndTime, "long")#</td>
				</tr>
				<tr>
					<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Registration CheckIn</td>
					<td style="font-family: Arial; font-size: 14px; font-weight: normal;">#TimeFormat(getEvent.Registration_BeginTime, "long")# till #TimeFormat(getEvent.Registration_EndTime, "long")#</td>
				</tr>
				<tr>
					<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Event Description</td>
					<td style="font-family: Arial; font-size: 14px; font-weight: normal;">#getEvent.LongDescription#</td>
				</tr>
				<cfif Len(getEvent.EventAgenda)>
					<tr>
						<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Event Agenda</td>
						<td style="font-family: Arial; font-size: 14px; font-weight: normal;">#getEvent.EventAgenda#</td>
					</tr>
				</cfif>
				<cfif Len(getEvent.EventTargetAudience)>
				<tr>
						<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Target Audience</td>
						<td style="font-family: Arial; font-size: 14px; font-weight: normal;">#getEvent.EventTargetAudience#</td>
					</tr>
				</cfif>
				<cfif Len(getEvent.EventStrategies)>
				<tr>
						<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Event Strategies</td>
						<td style="font-family: Arial; font-size: 14px; font-weight: normal;">#getEvent.EventStrategies#</td>
					</tr>
				</cfif>
				<cfif Len(getEvent.EventSpecialInstructions)>
				<tr>
						<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Special Instructions</td>
						<td style="font-family: Arial; font-size: 14px; font-weight: normal;">#getEvent.EventSpecialInstructions#</td>
					</tr>
				</cfif>
				<cfif getEvent.PGPAvailable EQ 1>
					<tr>
						<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Professional Growth Points</td>
						<td style="font-family: Arial; font-size: 14px; font-weight: normal;">#NumberFormat(getEvent.PGPPoints, "99.99")#</td>
					</tr>
				</cfif>
				<cfif getEvent.MealProvided EQ 1>
					<tr>
						<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Meal Provided</td>
						<td style="font-family: Arial; font-size: 14px; font-weight: normal;">Yes</td>
					</tr>
				</cfif>
				<cfif getEvent.AllowVideoConference EQ 1>
					<tr>
						<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Distance Education</td>
						<td style="font-family: Arial; font-size: 14px; font-weight: normal;">#getEvent.VideoConferenceInfo#</td>
					</tr>
				</cfif>
				<cfset FacilityURLAndImage = #EventServicesComponent.QRCodeImage(Variables.FacilityLocationMapURL,HTMLEditFormat(rc.pc.getPackage()),Variables.FacilityLocationFileName)#>
				<tr>
					<td width="20%" style="font-family: Arial; font-size: 14px; font-weight: bold;">Event Location</td>
					<td style="font-family: Arial; font-size: 14px; font-weight: normal;">
						<table class="table table-bordered" border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
							<tr>
								<td rowspan="2" width="50%" align="center"><address><strong>#getEventLocation.FacilityName#</strong><br>#getEventLocation.PhysicalAddress#<br>#getEventLocation.PhysicalCity#, #getEventLocation.PhysicalState# #getEventLocation.PhysicalZipCode#</address><br>P: #getEventLocation.PrimaryVoiceNumber#</td>
								<td>{Static Google Map}</td>
							</tr>
							<tr>
								<td><table border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
									<tr>
										<td valign="middle"><a href="https://itunes.apple.com/us/app/qr-reader-for-iphone/id368494609?mt=8&uo=4" target="itunes_store" style="display:inline-block;overflow:hidden;background:url(https://linkmaker.itunes.apple.com/htmlResources/assets/en_us//images/web/linkmaker/badge_appstore-lrg.png) no-repeat;width:135px;height:45px;@media only screen{background-image:url(https://linkmaker.itunes.apple.com/htmlResources/assets/en_us//images/web/linkmaker/badge_appstore-lrg.svg);}"></a></td>
										<td valign="middle"><a href="https://play.google.com/store/apps/details?id=me.scan.android.client"><img alt="Get it on Google Play" src="https://developer.android.com/images/brand/en_generic_rgb_wo_45.png" /></a></td>
									</tr>
									<tr>
										<td colspan="2" align="center" valign="middle"><img src="http://#cgi.server_name##Variables.FacilityURLAndImage#"></td>
									</tr>
								</table></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="2">#CGI.Server_Name#</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</cfoutput>
</cfsavecontent>
<cfdocument format="pdf" saveAsName="#getRegisteredUserInfo.FName#_#getRegisteredUserInfo.LName#-#getRegistration.RegistrationID#.pdf" name="PDFEventConfirmation" localurl="Yes">
<cfoutput>#Variables.EventConfirmationPage#</cfoutput>
</cfdocument>
<cfoutput>#Variables.FileWritePathWithName#</cfoutput><br>
<cfoutput>#Variables.EventConfirmationPage#</cfoutput>
<cffile action="write" file="#Variables.FileWritePathWithName#" output="#Variables.PDFEventConfirmation#">