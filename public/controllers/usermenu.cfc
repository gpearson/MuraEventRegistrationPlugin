/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

	</cffunction>

	<cffunction name="eventhistory" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.GetPastRegisteredEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5,
					p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.RegistrationDate, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.PGPPoints, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.OnWaitingList,
					p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.WebinarParticipant, p_EventRegistration_UserRegistrations.AttendeePriceVerified, p_EventRegistration_UserRegistrations.AttendeePrice,
					p_EventRegistration_UserRegistrations.EventID
				FROM p_EventRegistration_Events INNER JOIN p_EventRegistration_UserRegistrations on p_EventRegistration_UserRegistrations.EventID = p_EventRegistration_Events.TContent_ID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
					DateDiff(EventDate, Now()) < <cfqueryparam value="0" cfsqltype="cf_sql_integer">
				ORDER BY p_EventRegistration_Events.EventDate DESC
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="upcomingevents" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.GetRegisteredEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5,
					p_EventRegistration_Events.Presenters, p_EventRegistration_Events.Event_StartTime, p_EventRegistration_Events.Event_EndTime, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.LongDescription, p_EventRegistration_Events.EventAgenda,
					p_EventRegistration_Events.EventTargetAudience, p_EventRegistration_Events.EventStrategies, p_EventRegistration_Events.EventSpecialInstructions, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.MealProvided, p_EventRegistration_Events.WebinarAvailable,
					p_EventRegistration_Events.WebinarConnectInfo, p_EventRegistration_Events.WebinarMemberCost, p_EventRegistration_Events.WebinarNonMemberCost, p_EventRegistration_Events.LocationID, p_EventRegistration_Events.LocationRoomID,
					p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.RegistrationID,  p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.EventID, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.PGPPoints
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
				ORDER BY p_EventRegistration_UserRegistrations.RegistrationDate DESC
			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="cancelregistration" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5,
					p_EventRegistration_Events.Presenters, p_EventRegistration_Events.Event_StartTime, p_EventRegistration_Events.Event_EndTime, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.LongDescription, p_EventRegistration_Events.EventAgenda,
					p_EventRegistration_Events.EventTargetAudience, p_EventRegistration_Events.EventStrategies, p_EventRegistration_Events.EventSpecialInstructions, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.MealProvided, p_EventRegistration_Events.WebinarAvailable,
					p_EventRegistration_Events.WebinarConnectInfo, p_EventRegistration_Events.WebinarMemberCost, p_EventRegistration_Events.WebinarNonMemberCost, p_EventRegistration_Events.LocationID, p_EventRegistration_Events.LocationRoomID,
					p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.RegistrationID,  p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.EventID, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.PGPPoints
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
					p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				ORDER BY p_EventRegistration_UserRegistrations.RegistrationDate DESC
			</cfquery>
			<cfif LEN(Session.GetSelectedEvent.Presenters)>
				<cfquery name="Session.EventPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select FName, LName
					From tusers
					Where UserID = <cfqueryparam value="#Session.GetSelectedEvent.Presenters#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>
			<cfif Session.GetSelectedEvent.LocationID GT 0>
				<cfquery name="Session.GetEventFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, GeoCode_Latitude, GeoCode_Longitude
					From p_EventRegistration_Facility
					Where TContent_ID = <cfqueryparam value="#Session.GetSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfquery name="Session.GetEventFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Select RoomName
					From p_EventRegistration_FacilityRooms
					Where Facility_ID = <cfqueryparam value="#Session.GetSelectedEvent.LocationID#" cfsqltype="cf_sql_integer"> and
						TContent_ID = <cfqueryparam value="#Session.GetSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif FORM.UserAction EQ "Back to Manage Registrations">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "GetSelectedEvent")>
				<cfset temp = StructDelete(Session, "GetEventFacility")>
				<cfset temp = StructDelete(Session, "GetEventFacilityRoom")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.manageregistrations" addtoken="false">
			</cfif>

			<cfif FORM.CancelRegistration EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Do you want to cancel your registration for this event? Select Yes or No below."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.cancelregistration&EventID=#FORM.EventID#&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.CancelRegistration EQ 1>
				<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
				<cfset Info = StructNew()>
				<cfset Info.RegistrationID = #Session.GetSelectedEvent.RegistrationID#>
				<cfset Info.FormData = #StructCopy(Session.FormData)#>
				<cfset temp = #SendEmailCFC.SendEventCancellationToSingleParticipant(rc, Variables.Info)#>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.manageregistrations&RegistrationCancelled=True" addtoken="false">
			<cfelse>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.manageregistrations&EventID=#FORM.EventID#&RegistrationCancelled=False" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="getcertificate" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("URL.EventID")>
			<cfquery name="Session.GetRegisteredEvents" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.EventDate1, p_EventRegistration_Events.EventDate2, p_EventRegistration_Events.EventDate3, p_EventRegistration_Events.EventDate4, p_EventRegistration_Events.EventDate5,
					p_EventRegistration_Events.Presenters, p_EventRegistration_Events.Event_StartTime, p_EventRegistration_Events.Event_EndTime, p_EventRegistration_Events.Registration_Deadline, p_EventRegistration_Events.LongDescription, p_EventRegistration_Events.EventAgenda,
					p_EventRegistration_Events.EventTargetAudience, p_EventRegistration_Events.EventStrategies, p_EventRegistration_Events.EventSpecialInstructions, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.MealProvided, p_EventRegistration_Events.WebinarAvailable,
					p_EventRegistration_Events.WebinarConnectInfo, p_EventRegistration_Events.WebinarMemberCost, p_EventRegistration_Events.WebinarNonMemberCost, p_EventRegistration_Events.LocationID, p_EventRegistration_Events.LocationRoomID,
					p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6,
					p_EventRegistration_UserRegistrations.RegistrationID,  p_EventRegistration_UserRegistrations.OnWaitingList, p_EventRegistration_UserRegistrations.EventID, p_EventRegistration_Events.PGPAvailable, p_EventRegistration_Events.PGPPoints
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
					p_EventRegistration_Events.PGPAvailable = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
				ORDER BY p_EventRegistration_UserRegistrations.RegistrationDate DESC
			</cfquery>
		<cfelseif isDefined("URL.EventID") and isDefined("URL.DisplayCertificate")>
			<cfquery name="GetSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_Events.TContent_ID, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_Events.PGPPoints, tusers.Fname, tusers.Lname
				FROM p_EventRegistration_UserRegistrations INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
				INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
				WHERE p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
					p_EventRegistration_Events.PGPAvailable = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
					p_EventRegistration_Events.TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfset CurLoc = #ExpandPath("/")#>
			<cfset CertificateTemplateDir = #Variables.CurLoc# & "plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/">
			<cfset CertificateExportTemplateDir = #Variables.CurLoc# & "plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/">
			<cfset CertificateMasterTemplate = #Variables.CertificateTemplateDir# & "NIESCRisePGPCertificateTemplate.pdf">
			<cfset ParticipantName = #GetSelectedEvent.FName# & " " & #GetSelectedEvent.LName#>
			<cfset ParticipantFilename = #Replace(Variables.ParticipantName, " ", "", "all")#>
			<cfset ParticipantFilename = #Replace(Variables.ParticipantFilename, ".", "", "all")#>
			<cfset PGPEarned = "PGP Earned: " & #NumberFormat(GetSelectedEvent.PGPPoints, "99.9")#>
			<cfset CertificateCompletedFile = #Variables.CertificateExportTemplateDir# & #GetSelectedEvent.TContent_ID# & "-" & #Variables.ParticipantFilename# & ".pdf">
			<cfset Session.CertificateCompletedFile = "/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/" & #GetSelectedEvent.TContent_ID# & "-" & #Variables.ParticipantFilename# & ".pdf">
			<cfset Session.GetSelectedEvent = StructCopy(GetSelectedEvent)>
			<cfscript>
				PDFCompletedCertificate = CreateObject("java", "java.io.FileOutputStream").init(CertificateCompletedFile);
				PDFMasterCertificateTemplate = CreateObject("java", "com.itextpdf.text.pdf.PdfReader").init(CertificateMasterTemplate);
				PDFStamper = CreateObject("java", "com.itextpdf.text.pdf.PdfStamper").init(PDFMasterCertificateTemplate, PDFCompletedCertificate);
				PDFStamper.setFormFlattening(true);
				PDFFormFields = PDFStamper.getAcroFields();
				PDFFormFields.setField("PGPEarned", Variables.PGPEarned);
				PDFFormFields.setField("ParticipantName", Variables.ParticipantName);
				PDFFormFields.setField("EventTitle", GetSelectedEvent.ShortTitle);
				PDFFormFields.setField("EventDate", DateFormat(GetSelectedEvent.EventDate, "full"));
				PDFFormFields.setField("SignDate", DateFormat(GetSelectedEvent.EventDate, "mm/dd/yyyy"));
				PDFStamper.close();
			</cfscript>
		</cfif>
	</cffunction>

	<cffunction name="forgotpassword" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
		<cfif not isDefined("FORM.formSubmit") and not isDefined("URL.Key") and not isDefined("FORM.submitPasswordChange")>
			<cfset Session.Captcha = #makeRandomString()#>
		<cfelseif not isDefined("FORM.formSubmit") and isDefined("URL.Key") and not isDefined("FORM.submitPasswordChange")>
			<cfset KeyAsString = #ToString(ToBinary(URL.Key))#>
			<cfset Session.PasswordKey = StructNew()>
			<cfset Session.PasswordKey.UserID = #ListLast(ListFirst(Variables.KeyAsString, "&"), "=")#>
			<cfset Session.PasswordKey.DateCreated = #ListLast(ListLast(Variables.KeyAsString, "&"), "=")#>

			<cfif DateDiff("n", Session.PasswordKey.DateCreated, Now()) GT 45>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default&UserAction=PasswordTimeExpired">
			<cfelse>

			</cfif>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.submitPasswordChange")>
			<cfquery name="CheckAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, UserName, FName, Lname, Email, created
				From tusers
				Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and
					SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
			</cfquery>

			<cfif FORM.DesiredPassword NEQ FORM.VerifyPassword>
				<cfscript>
					InvalidPassword = {property="VerifyPassword",message="The Password and the Verify Password Fields do not match each other. Please make sure these fields match."};
					arrayAppend(Session.FormErrors, InvalidPassword);
				</cfscript>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.forgotpassword&Key=#URL.Key#&FormRetry=True">
			</cfif>

			<!--- Initiates the User Bean --->
			<cfset NewUser = #Application.userManager.readByUsername(CheckAccount.UserName, rc.$.siteConfig('siteID'))#>
			<cfset NewUser.setPassword(FORM.DesiredPassword)>
			<cfset updateAccountPassword = #Application.userManager.save(NewUser)#>

			<cfif LEN(updateAccountPassword.getErrors()) EQ 0>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default&UserAction=PasswordChanged">
			<cfelse>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default&UserAction=PasswordNotChanged">
			</cfif>

		<cfelseif isDefined("FORM.formSubmit") and not isDefined("FORM.submitPasswordChange")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif not isValid("email", FORM.Email)>
				<cfscript>
					UsernameNotValid = {property="UserName",message="The Email Address is not a valid email address. We use this email address as the communication method to get you information regarding events that you signup for."};
					arrayAppend(Session.FormErrors, UsernameNotValid);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:usermenu.forgotpassword&FormRetry=True" addtoken="false">
			</cfif>

			<cfif #HASH(FORM.ValidateCaptcha)# NEQ FORM.CaptchaEncrypted>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="The Characters entered within the Account Security Box did not match the Characters within the image displayed"};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.forgotpassword&FormRetry=True">
			</cfif>

			<cfquery name="CheckAccount" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select UserID, UserName, FName, Lname, Email, created
				From tusers
				Where UserName = <cfqueryparam value="#FORM.Email#" cfsqltype="cf_sql_varchar"> and
					SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
			</cfquery>

			<cfif CheckAccount.RecordCount EQ 0>
				<cflock timeout="60" scope="SESSION" type="Exclusive">
					<cfscript>
						errormsg = {property="HumanChecker",message="We did not locate an account for the email address you entered. Please check the entered email address."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
				</cflock>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.forgotpassword&FormRetry=True">
			<cfelse>
				<cfset ValueToEncrypt = "UserID=" & #CheckAccount.UserID# & "&" & "Created=" & #CheckAccount.created# & "&DateSent=" & #Now()#>
				<cfset EncryptedValue = #Tobase64(Variables.ValueToEncrypt)#>
				<cfset AccountVars = "Key=" & #Variables.EncryptedValue#>
				<cfset AccountPasswordLink = "http://" & #CGI.Server_Name# & "#CGI.Script_name##CGI.path_info#?#rc.pc.getPackage()#action=public:usermenu.forgotpassword&" & #Variables.AccountVars#>
				<cfset temp = SendEmailCFC.SendForgotPasswordRequest(rc, CheckAccount, AccountPasswordLink)>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default&UserAction=PasswordRequestSent">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="makeRandomString" ReturnType="String" output="False">
		<cfset var chars = "23456789ABCDEFGHJKMNPQRSTUVWXYZ">
		<cfset var length = RandRange(4,7)>
		<cfset var result = "">
		<cfset var i = "">
		<cfset var char = "">
		<cfscript>
			for (i = 1; i < length; i++) {
				char = mid(chars, randRange(1, len(chars)), 1);
				result &= char;
			}
		</cfscript>
		<cfreturn result>
	</cffunction>

	<cffunction name="editprofile" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getUserProfile" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select tusers.UserName, tusers.FName, tusers.Lname, tusers.Email, tusers.Company, tusers.JobTitle, tusers.mobilePhone, tusers.Website, tusers.LastLogin, tusers.LastUpdate, tusers.LastUpdateBy, tusers.LastUpdateByID, tusers.InActive, tusers.created, p_EventRegistration_UserMatrix.School_District, p_EventRegistration_UserMatrix.TeachingGrade, p_EventRegistration_UserMatrix.TeachingSubject
				From tusers INNER JOIN p_EventRegistration_UserMatrix ON p_EventRegistration_UserMatrix.User_ID = tusers.UserID
				Where tusers.UserID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar"> and
					tusers.SiteID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
			</cfquery>
			<cfquery name="Session.getGradeLevels" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, GradeLevel
				From p_EventRegistration_GradeLevels
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				Order by GradeLevel
			</cfquery>
			<cfquery name="Session.getGradeSubjects" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, GradeSubject
				From p_EventRegistration_GradeSubjects
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				Order by GradeSubject
			</cfquery>

			<cfset Session.getUserProfile = #StructCopy(getUserProfile)#>
		<cfelseif isDefined("FORM.formSubmit")>
			<cfset Session.FormErrors = #ArrayNew()#>
			<cfset Session.FormData = #StructCopy(FORM)#>

			<cfif FORM.UserAction EQ "Back to Event Listing">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "getUserProfile")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default" addtoken="false">
			</cfif>

			<cfif FORM.UserAction EQ "My Event History">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "getUserProfile")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.eventhistory" addtoken="false">
			</cfif>

			<cfif FORM.UserAction EQ "My Upcoming Events">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormData")>
				<cfset temp = StructDelete(Session, "getUserProfile")>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.upcomingevents" addtoken="false">
			</cfif>

			<cfif LEN(FORM.Password) OR LEN(FORM.VerifyPassword)>
				<cfif FORM.Password NEQ FORM.VerifyPassword>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							errormsg = {property="HumanChecker",message="The Password and Verify Password Fields did not match. Please correct."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
					</cflock>
					<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.editprofile&FormRetry=True">
				<cfelse>
					<cfset NewUser = #Application.userManager.readByUsername(form.UserID, rc.$.siteConfig('siteID'))#>
					<cfset NewUser.setPassword(FORM.Password)>
					<cfset NewUser.setSiteID(rc.$.siteConfig('siteID'))>
					<cfset AddNewAccount = #Application.userManager.save(NewUser)#>
				</cfif>
			</cfif>

			<cfquery name="getOrigionalUserValues" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select fName, LName, Email, Company, JobTitle, mobilePhone, website
				From tusers
				Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfquery name="getOrigionalUserMatrixValues" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TeachingGrade, TeachingSubject
				From p_EventRegistration_UserMatrix
				Where User_ID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfparam name="UserEditProfile" type="boolean" default="0">

			<cfif Session.FormData.fName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update tusers
					Set fName = <cfqueryparam value="#Session.FormData.FName#" cfsqltype="cf_sql_varchar">,
						lastUpdate = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="#Session.FormData.UserID#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.lName NEQ getOrigionalUserValues.FName>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update tusers
					Set lName = <cfqueryparam value="#Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdate = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="#Session.FormData.UserID#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.JobTitle NEQ getOrigionalUserValues.JobTitle>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update tusers
					Set JobTitle = <cfqueryparam value="#Session.FormData.JobTitle#" cfsqltype="cf_sql_varchar">,
						lastUpdate = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="#Session.FormData.UserID#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.mobilePhone NEQ getOrigionalUserValues.mobilePhone>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update tusers
					Set mobilePhone = <cfqueryparam value="#Session.FormData.mobilePhone#" cfsqltype="cf_sql_varchar">,
						lastUpdate = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="#Session.FormData.UserID#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.website NEQ getOrigionalUserValues.website>
				<cfset UserEditProfile = 1>
				<cfquery name="setNewAccountPassword" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update tusers
					Set website = <cfqueryparam value="#Session.FormData.website#" cfsqltype="cf_sql_varchar">,
						lastUpdate = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="#Session.FormData.UserID#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.GradeLevel NEQ "----" and  Session.FormData.GradeLevel NEQ getOrigionalUserMatrixValues.TeachingGrade>
				<cfset UserEditProfile = 1>
				<cfquery name="updateTeachingGrade" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_UserMatrix
					Set TeachingGrade = <cfqueryparam value="#Session.FormData.GradeLevel#" cfsqltype="cf_sql_integer">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Session.FormData.GradeSubjects NEQ "----" and  Session.FormData.GradeSubjects NEQ getOrigionalUserMatrixValues.TeachingSubject>
				<cfset UserEditProfile = 1>
				<cfquery name="updateTeachingSubject" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_UserMatrix
					Set TeachingSubject = <cfqueryparam value="#Session.FormData.GradeSubjects#" cfsqltype="cf_sql_integer">,
						lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						lastUpdateBy = <cfqueryparam value="#Session.FormData.FName# #Session.FormData.LName#" cfsqltype="cf_sql_varchar">
					Where UserID = <cfqueryparam value="#Form.UserID#" cfsqltype="cf_sql_varchar">
				</cfquery>
			</cfif>

			<cfif Variables.UserEditProfile EQ 1>
				<cfset Session.Mura.fName = #Session.FormData.fName#>
				<cfset Session.Mura.lName = #Session.FormData.lName#>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default&UserAction=UserProfileUpdated">
			<cfelse>
				<cflocation addtoken="true" url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default">
			</cfif>



		</cfif>
	</cffunction>










</cfcomponent>