<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and not isDefined("URL.EventStatus")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, Event_HasMultipleDates, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_Events
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order By EventDate DESC
	</cfquery>

	<cfquery name="getEventFacility" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_TimeZone, MailingAddress, MailingCity, MailingState, MailingZipCode, MailingZip4, Mailing_isAddressVerified, Mailing_USPSDeliveryPoint, Mailing_USPSCheckDigit, Mailing_USPSCarrierRoute, PrimaryVoiceNumber, PrimaryFaxNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, AdditionalNotes, Cost_HaveEventAt, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active
		From p_EventRegistration_Facility
		Where TContent_ID = <cfqueryparam value="#getSelectedEvent.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery name="CheckExistingSentEmailsForEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select MsgBody, LinksToInclude, DocsToInclude
		From p_EventRegistration_EventEmailLog
		Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and EmailType = <cfqueryparam value="EmailRegistered" cfsqltype="cf_sql_varchar">
	</cfquery>

	<cfif LEN(getSelectedEvent.PresenterID)>
		<cfquery name="getPresenter" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select FName, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset Session.getSelectedEventPresenter = StructCopy(getPresenter)>
	</cfif>

	<cfquery name="GetMembershipOrganizations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active
		From p_EventRegistration_Membership
		Order by OrganizationName
	</cfquery>

	<cfswitch expression="#application.configbean.getDBType()#">
		<cfcase value="mysql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
		<cfcase value="mssql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
	</cfswitch>
	<cfset Session.getSelectedEvent = StructCopy(getSelectedEvent)>
	<cfset Session.getRegisteredParticipants = StructCopy(getRegisteredParticipants)>
	<cfset Session.getSelectedEventFacility = StructCopy(getEventFacility)>
	<cfset Session.CheckExistingSentEmailsForEvent = StructCopy(CheckExistingSentEmailsForEvent)>
	<cfset Session.GetMembershipOrganizations = StructCopy(GetMembershipOrganizations)>
	<cfset Session.JSMuraScope = StructCopy(rc)>
<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.EventID") and isDefined("URL.EventStatus")>
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

	<cfswitch expression="#URL.EventStatus#">
		<cfcase value="ShowCorporations">
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput.RegisterStep1 = #StructCopy(FORM)#>
			</cflock>
			<cfif Session.getSelectedEvent.Webinar_Available EQ 1>
				<cfif FORM.WebinarParticipant EQ "----">
					<cfscript>
						errormsg = {property="EmailMsg",message="Please select whether the individuals you are registering will be attending the event via the webinar option."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True">
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
			</cfif>
			<cfif Session.getSelectedEvent.H323_Available EQ 1>
				<cfif FORM.H323Participant EQ "----">
					<cfscript>
						errormsg = {property="EmailMsg",message="Please select whether the individuals you are registering will be attending the event via the video confernecing option."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True">
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
			</cfif>
			<cfif Session.getSelectedEvent.Webinar_Available EQ 1 or Session.getSelectedEvent.H323_Available EQ 1>
				<cfif FORM.FacilityParticipant EQ "----">
					<cfscript>
						errormsg = {property="EmailMsg",message="Please select whether the individuals you are registering will be attending the event at the physical location specified."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True">
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
			</cfif>
			<cfif FORM.EmailConfirmations EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please select whether the individuals you are registering will be receiving email confirmation of this registration."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True">
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif Session.CheckExistingSentEmailsForEvent.RecordCount>
				<cfif FORM.SendPreviousEmailCommunications EQ "----">
					<cfscript>
						errormsg = {property="EmailMsg",message="Please select whether you would like the previous email communication to registered participants to be sent to these individuals you are registering at this time."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True">
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
			</cfif>
			<cfif FORM.SchoolDistricts EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please select the school district the individuals you are registering are from."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True">
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfquery name="GetSelectedOrganizationDomainame" dbtype="Query">
				Select * from Session.GetMembershipOrganizations
				Where TContent_ID = <cfqueryparam value="#Session.FormInput.RegisterStep1.SchoolDistricts#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfquery name="GetSelectedAccountsWithinOrganization" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select UserID, Fname, Lname, Email
				From tusers
				WHERE 1 = 1 AND Email LIKE '%#GetSelectedOrganizationDomainame.OrganizationDomainName#%'
				Order by Lname ASC, Fname ASC
			</cfquery>
			<cfset temp = #QueryAddColumn(GetSelectedAccountsWithinOrganization, "SortOrder", "integer")#>
			<cfset temp = #QueryAddColumn(GetSelectedAccountsWithinOrganization, "TempColumn", "integer")#>
			<cfset temp = #QueryAddColumn(GetSelectedAccountsWithinOrganization, "TempRow", "integer")#>
			<cfset DisplayQueryRows = Ceiling(GetSelectedAccountsWithinOrganization.RecordCount / 4)>
			<cfset DisplayBlankRecords = (4 * Variables.DisplayQueryRows) - #GetSelectedAccountsWithinOrganization.RecordCount#>
			<cfset temp = #QueryAddRow(GetSelectedAccountsWithinOrganization, variables.DisplayBlankRecords)#>
			<cfloop query="GetSelectedAccountsWithinOrganization">
				<cfset tempColumn = ((GetSelectedAccountsWithinOrganization.CurrentRow - 1) \ Variables.DisplayQueryRows) + 1>
				<cfset temp = #QuerySetCell(GetSelectedAccountsWithinOrganization, "TempColumn", variables.tempColumn, GetSelectedAccountsWithinOrganization.CurrentRow)#>
				<cfset TempCalc = GetSelectedAccountsWithinOrganization.CurrentRow MOD Variables.DisplayQueryRows>
				<cfif TempCalc EQ 0><cfset TempRow = Variables.DisplayQueryRows><cfelse><cfset TempRow = Variables.TempCalc></cfif>
				<cfset temp = #QuerySetCell(GetSelectedAccountsWithinOrganization, "TempRow", variables.TempRow, GetSelectedAccountsWithinOrganization.CurrentRow)#>	
			</cfloop>
			<cfquery name="GetSelectedAccountsWithinOrganizationReSorted" dbtype="Query">
				Select * from GetSelectedAccountsWithinOrganization
				Order by TempRow ASC, TempColumn ASC
			</cfquery>
			<cfset Session.GetSelectedAccountsWithinOrganization = StructCopy(GetSelectedAccountsWithinOrganizationReSorted)>
		</cfcase>
		<cfcase value="SelectParticipants">
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput.RegisterStep2 = #StructCopy(FORM)#>
			</cflock>

			<cfif Session.getSelectedEvent.Meal_Available EQ 1 and Session.getSelectedEvent.Meal_Included EQ 1>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipants" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipants">
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfset EventServicesCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
			<cfset RegisteredParticipantsUserID = ArrayNew()>

			<cfloop list="#FORM.ParticipantEmployee#" delimiters="," index="i">
				<cfset ParticipantUserID = ListFirst(i, "_")>
				<cfset temp = #ArrayAppend(RegisteredParticipantsUserID, Variables.ParticipantUserID)#>
				<cfset DayNumber = ListLast(i, "_")>
				<cfquery name="CheckUserRegisteredForEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Select RegistrationID
					From p_EventRegistration_UserRegistrations
					Where Site_ID = <cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif CheckUserRegisteredForEvent.RecordCount EQ 0>
					<cfset RegistrationUUID = #CreateUUID()#>
					<cfquery name="GetCurrentRegistrationsForEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Select TContent_ID
						From p_EventRegistration_UserRegistrations
						Where Site_ID = <cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif GetCurrentRegistrationsForEvent.RecordCount LTE Session.getSelectedEvent.Event_MaxParticipants>
						<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Insert into p_EventRegistration_UserRegistrations(Site_ID, User_ID, Event_ID, RegistrationID, RegistrationDate, OnWaitingList, RequestsMeal, WebinarParticipant, H323Participant, RegistrationIPAddr, RegisteredByUserID, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID)
							Values(
								<cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
						</cfquery>
					<cfelse>
						<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Insert into p_EventRegistration_UserRegistrations(Site_ID, User_ID, Event_ID, RegistrationID, RegistrationDate, OnWaitingList, RequestsMeal, WebinarParticipant, H323Participant, RegistrationIPAddr, RegisteredByUserID, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID)
							Values(
								<cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
						</cfquery>
					</cfif>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								update p_EventRegistration_UserRegistrations
								Set 
									<cfif Variables.DayNumber EQ 1>RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									<cfif Variables.DayNumber EQ 2>RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									<cfif Variables.DayNumber EQ 3>RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									<cfif Variables.DayNumber EQ 4>RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									<cfif Variables.DayNumber EQ 5>RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									<cfif Variables.DayNumber EQ 6>RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATED_KEY#">
							</cfquery>
							<cfif Session.FormInput.RegisterStep2.RegisterParticipantStayForMeal Contains 1>
								<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set RequestsMeal = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
										lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATED_KEY#">
								</cfquery>
							</cfif>
							<cfquery name="GetSelectedDistrict" dbtype="Query">
								Select * From Session.GetMembershipOrganizations
								Where TContent_ID = <cfqueryparam value="#Session.FormInput.RegisterStep1.SchoolDistricts#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif  GetSelectedDistrict.Active EQ 1>
								<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
									<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_Deadline, "yyyy-mm-dd")) GTE 0>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.EarlyBird_MemberCost#>
									<cfelse>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_MemberCost#>
									</cfif>
								<cfelseif Session.getSelectedEvent.EarlyBird_Available EQ 0 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_MemberCost#>
								</cfif>
								<cfif Session.getSelectedEvent.Webinar_Available EQ 1 and Session.FormInput.RegisterStep1.WebinarParticipant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.Webinar_MemberCost#>
									<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set WebinarParticipant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
											lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
											lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>
								<cfif Session.getSelectedEvent.H323_Available EQ 1 and Session.FormInput.RegisterStep1.H323Participant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.H323_MemberCost#>
									<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set H323Participant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
											lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
											lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>
								<cfset NewMember_Cost = #EventServicesCFC.ConvertCurrencyToDecimal(Variables.AttendeeEventPrice)#>
								<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Update p_EventRegistration_UserRegistrations
									Set AttendeePrice = <cfqueryparam value="#NumberFormat(Variables.NewMember_Cost, '999999.99')#" cfsqltype="cf_sql_decimal">,
										lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
									Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							<cfelse>
								<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
									<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_Deadline, "yyyy-mm-dd")) GTE 0>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.EarlyBird_NonMemberCost#>
									<cfelse>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_NonMemberCost#>
									</cfif>
								<cfelseif Session.getSelectedEvent.EarlyBird_Available EQ 0 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_NonMemberCost#>
								</cfif>

								<cfif Session.getSelectedEvent.Webinar_Available EQ 1 and Session.FormInput.RegisterStep1.WebinarParticipant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.Webinar_NonMemberCost#>
									<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set WebinarParticipant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
											lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
											lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>
								<cfif Session.getSelectedEvent.H323_Available EQ 1 and Session.FormInput.RegisterStep1.H323Participant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.H323_NonMemberCost#>
									<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set H323Participant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
											lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
											lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>
								<cfset EventServicesCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
								<cfset NewMember_Cost = #EventServicesCFC.ConvertCurrencyToDecimal(Variables.AttendeeEventPrice)#>
								<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Update p_EventRegistration_UserRegistrations
									Set AttendeePrice = <cfqueryparam value="#NumberFormat(Variables.NewMember_Cost, '999999.99')#" cfsqltype="cf_sql_decimal">,
										lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
									Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif Session.FormInput.RegisterStep1.EmailConfirmations Contains 1>
								<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
									<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, "127.0.0.1")#>
								<cfelse>
									<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
										<cfif rc.$.siteConfig('mailserverssl') EQ "True">
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
										<cfelse>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
										</cfif>
									<cfelse>
										<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'))#>
									</cfif>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="mssql">

						</cfcase>
					</cfswitch>
				<cfelse>
					
				</cfif>
			</cfloop>

			<cfset NumberNewParticipants = 0>
			<cfloop list="#form.fieldnames#" index="i" delimiters=",">
				<cfif i contains "ParticipantFirstName">
					<cfset Variables.NumberNewParticipants = #Right(i, 1)#>
				</cfif>
			</cfloop>
			<cfloop from="1" to="#Variables.NumberNewParticipants#" index="i" step="1">
				<cfif LEN(FORM["ParticipantFirstName" & i]))>
					<cfset userRecord = $.getBean('user').loadBy(username='#FORM["ParticipantEmail" & i]#', siteid='#$.siteConfig("siteid")#')>
					<cfset temp = #userRecord.set('siteid', $.siteConfig("siteid"))#>
					<cfset temp = #userRecord.set('fname', '#Trim(FORM["ParticipantFirstName" & i])#')#>
					<cfset temp = #userRecord.set('lname', '#Trim(FORM["ParticipantLastName" & i])#')#>
					<cfset temp = #userRecord.set('username', '#Trim(FORM["ParticipantEmail" & i])#')#>
					<cfset temp = #userRecord.set('email', '#Trim(FORM["ParticipantEmail" & i])#')#>					
					<cfset temp = #userRecord.set('InActive', 1)#>
					<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
					<cfset temp = #userRecord.set('lastupdateby', '#Session.Mura.Fname# #Session.Mura.LName#')#>
					<cfset temp = #userRecord.set('lastupdatebyid', '#Session.Mura.UserID#')#>
					<cfset temp = #userRecord.setPasswordNoCache('Ev3ntR3g15tr@t10n')#>

					<cfif userRecord.checkUsername() EQ "false">
						<cfdump var="#Variables.userRecord#" abort="true">
					<cfelse>
						<cfset AddNewAccount = #userRecord.save()#>
						<cfset RegistrationUUID = #CreateUUID()#>
						<cfset temp = #ArrayAppend(RegisteredParticipantsUserID, AddNewAccount.getUserID())#>
						<cfquery name="InsertRegistration" result="insertNewPersonRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Insert into p_EventRegistration_UserRegistrations(Site_ID, User_ID, Event_ID, RegistrationID, RegistrationDate, OnWaitingList, RequestsMeal, WebinarParticipant, H323Participant, RegistrationIPAddr, RegisteredByUserID, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID)
							Values(
								<cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#AddNewAccount.getUserID()#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							)
						</cfquery>
						<cfswitch expression="#application.configbean.getDBType()#">
							<cfcase value="mysql">
								<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set 
										<cfif Variables.DayNumber EQ 1>RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
										<cfif Variables.DayNumber EQ 2>RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
										<cfif Variables.DayNumber EQ 3>RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
										<cfif Variables.DayNumber EQ 4>RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
										<cfif Variables.DayNumber EQ 5>RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
										<cfif Variables.DayNumber EQ 6>RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
										lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewPersonRegistration.GENERATED_KEY#">
								</cfquery>
								<cfif Session.FormInput.RegisterStep2.RegisterParticipantStayForMeal Contains 1>
									<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										update p_EventRegistration_UserRegistrations
										Set RequestsMeal = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
											lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
											lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
										Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewPersonRegistration.GENERATED_KEY#">
									</cfquery>
								</cfif>
								<cfquery name="GetSelectedDistrict" dbtype="Query">
									Select * From Session.GetMembershipOrganizations
									Where TContent_ID = <cfqueryparam value="#Session.FormInput.RegisterStep1.SchoolDistricts#" cfsqltype="cf_sql_integer">
								</cfquery>
								<cfif  GetSelectedDistrict.Active EQ 1>
									<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
										<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_Deadline, "yyyy-mm-dd")) GTE 0>
											<cfset AttendeeEventPrice = #Session.getSelectedEvent.EarlyBird_MemberCost#>
										<cfelse>
											<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_MemberCost#>
										</cfif>
									<cfelseif Session.getSelectedEvent.EarlyBird_Available EQ 0 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_MemberCost#>
									</cfif>
									<cfif Session.getSelectedEvent.Webinar_Available EQ 1 and Session.FormInput.RegisterStep1.WebinarParticipant Contains 1>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.Webinar_MemberCost#>
										<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set WebinarParticipant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
												lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
												lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
												lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
											Where TContent_ID = <cfqueryparam value="#insertNewPersonRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
										</cfquery>
									</cfif>
									<cfif Session.getSelectedEvent.H323_Available EQ 1 and Session.FormInput.RegisterStep1.H323Participant Contains 1>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.H323_MemberCost#>
										<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set H323Participant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
												lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
												lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
												lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
											Where TContent_ID = <cfqueryparam value="#insertNewPersonRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
										</cfquery>
									</cfif>
									<cfset NewMember_Cost = #EventServicesCFC.ConvertCurrencyToDecimal(Variables.AttendeeEventPrice)#>
									<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set AttendeePrice = <cfqueryparam value="#NumberFormat(Variables.NewMember_Cost, '999999.99')#" cfsqltype="cf_sql_decimal">,
											lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
											lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
										WHERe TContent_ID = <cfqueryparam value="#insertNewPersonRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
									</cfquery>
								<cfelse>
									<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
										<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_Deadline, "yyyy-mm-dd")) GTE 0>
											<cfset AttendeeEventPrice = #Session.getSelectedEvent.EarlyBird_NonMemberCost#>
										<cfelse>
											<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_NonMemberCost#>
										</cfif>
									<cfelseif Session.getSelectedEvent.EarlyBird_Available EQ 0 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_NonMemberCost#>
									</cfif>
									<cfif Session.getSelectedEvent.Webinar_Available EQ 1 and Session.FormInput.RegisterStep1.WebinarParticipant Contains 1>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.Webinar_NonMemberCost#>
										<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set WebinarParticipant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
												lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
												lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
												lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
											Where TContent_ID = <cfqueryparam value="#insertNewPersonRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
										</cfquery>
									</cfif>
									<cfif Session.getSelectedEvent.H323_Available EQ 1 and Session.FormInput.RegisterStep1.H323Participant Contains 1>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.H323_NonMemberCost#>
										<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
											Update p_EventRegistration_UserRegistrations
											Set H323Participant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
												lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
												lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
												lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
											Where TContent_ID = <cfqueryparam value="#insertNewPersonRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
										</cfquery>
									</cfif>
									<cfset EventServicesCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
									<cfset NewMember_Cost = #EventServicesCFC.ConvertCurrencyToDecimal(Variables.AttendeeEventPrice)#>
									<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set AttendeePrice = <cfqueryparam value="#NumberFormat(Variables.NewMember_Cost, '999999.99')#" cfsqltype="cf_sql_decimal">,
											lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
											lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
										Where TContent_ID = <cfqueryparam value="#insertNewPersonRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>
								<cfif Session.FormInput.RegisterStep1.EmailConfirmations Contains 1>
									<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
										<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewPersonRegistration.GENERATED_KEY, "127.0.0.1")#>
									<cfelse>
										<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
											<cfif rc.$.siteConfig('mailserverssl') EQ "True">
												<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewPersonRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
											<cfelse>
												<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewPersonRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
											</cfif>
										<cfelse>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewPersonRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'))#>
										</cfif>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="mssql">

							</cfcase>
						</cfswitch>

					</cfif>
          		</cfif>
			</cfloop>

			<cfset RegisterIndividuals = #ArrayToList(RegisteredParticipantsUserID, ",")#>
			<cfif ListLen(Variables.RegisterIndividuals) EQ 1>
				<cfif Variables.RegisterIndividuals NEQ Session.Mura.UserID>
					<!--- Send Email to User Logged In --->
					<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
						<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, "127.0.0.1")#>
					<cfelse>
						<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
							<cfif rc.$.siteConfig('mailserverssl') EQ "True">
								<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
							<cfelse>
								<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
							</cfif>
						<cfelse>
							<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'))#>
						</cfif>
					</cfif>
				</cfif>
			<cfelse>
				<!--- Send Email to User Logged In with a list of everyone registered --->
				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
					<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, "127.0.0.1")#>
				<cfelse>
					<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
						<cfif rc.$.siteConfig('mailserverssl') EQ "True">
							<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
						<cfelse>
							<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
						</cfif>
					<cfelse>
						<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'))#>
					</cfif>
				</cfif>
			</cfif>

			<cfset temp = StructDelete(Session, "EventInfo")>
			<cfset temp = StructDelete(Session, "FormErrors")>
			<cfset temp = StructDelete(Session, "FormInput")>
			<cfset temp = StructDelete(Session, "getAllEvents")>
			<cfset temp = StructDelete(Session, "getMembership")>
			<cfset temp = StructDelete(Session, "getMemberhipOrganizations")>
			<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
			<cfset temp = StructDelete(Session, "getSelectedAccountsWithinOrganization")>
			<cfset temp = StructDelete(Session, "getSelectedEvent")>
			<cfset temp = StructDelete(Session, "getSelectedEventFacility")>
			<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
			<cfset temp = StructDelete(Session, "getSelectedMember")>
			
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=ParticipantsRegistered&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=ParticipantsRegistered&Successful=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfcase>
		<cfcase value="RegisterParticipants">
			

		</cfcase>

	</cfswitch>
<cfelseif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and isDefined("URL.EventStatus")>
	<cfswitch expression="#URL.EventStatus#">
		<cfcase value="RegisterParticipants">
			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>
			<cfset EventServicesCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
			<cfset RegisteredParticipantsUserID = ArrayNew()>
			<cfloop list="#Session.FormInput.RegisterStep2.ParticipantEmployee#" delimiters="," index="i">
				<cfset ParticipantUserID = ListFirst(i, "_")>
				<cfset temp = #ArrayAppend(RegisteredParticipantsUserID, Variables.ParticipantUserID)#>
				<cfset DayNumber = ListLast(i, "_")>
				<cfquery name="CheckUserRegisteredForEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Select RegistrationID
					From p_EventRegistration_UserRegistrations
					Where Site_ID = <cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif CheckUserRegisteredForEvent.RecordCount EQ 0>
					<cfset RegistrationUUID = #CreateUUID()#>
					<cfquery name="GetCurrentRegistrationsForEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Select TContent_ID
						From p_EventRegistration_UserRegistrations
						Where Site_ID = <cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfif GetCurrentRegistrationsForEvent.RecordCount LTE Session.getSelectedEvent.Event_MaxParticipants>
						<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Insert into p_EventRegistration_UserRegistrations(Site_ID, User_ID, Event_ID, RegistrationID, RegistrationDate, OnWaitingList, RequestsMeal, WebinarParticipant, H323Participant, RegistrationIPAddr, RegisteredByUserID, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID)
							Values(
								<cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
						</cfquery>
					<cfelse>
						<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Insert into p_EventRegistration_UserRegistrations(Site_ID, User_ID, Event_ID, RegistrationID, RegistrationDate, OnWaitingList, RequestsMeal, WebinarParticipant, H323Participant, RegistrationIPAddr, RegisteredByUserID, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID)
							Values(
								<cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
								<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
						</cfquery>
					</cfif>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								update p_EventRegistration_UserRegistrations
								Set 
									<cfif Variables.DayNumber EQ 1>RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									<cfif Variables.DayNumber EQ 2>RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									<cfif Variables.DayNumber EQ 3>RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									<cfif Variables.DayNumber EQ 4>RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									<cfif Variables.DayNumber EQ 5>RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									<cfif Variables.DayNumber EQ 6>RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
									lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATED_KEY#">
							</cfquery>
							<cfif Session.FormInput.RegisterStep2.RegisterParticipantStayForMeal Contains 1>
								<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set RequestsMeal = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
										lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATED_KEY#">
								</cfquery>
							</cfif>
							<cfquery name="GetSelectedDistrict" dbtype="Query">
								Select * From Session.GetMembershipOrganizations
								Where TContent_ID = <cfqueryparam value="#Session.FormInput.RegisterStep1.SchoolDistricts#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif  GetSelectedDistrict.Active EQ 1>
								<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
									<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_Deadline, "yyyy-mm-dd")) GTE 0>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.EarlyBird_MemberCost#>
									<cfelse>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_MemberCost#>
									</cfif>
								<cfelseif Session.getSelectedEvent.EarlyBird_Available EQ 0 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_MemberCost#>
								</cfif>

								<cfif Session.getSelectedEvent.Webinar_Available EQ 1 and Session.FormInput.RegisterStep1.WebinarParticipant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.Webinar_MemberCost#>
									<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set WebinarParticipant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
											lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
											lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>

								<cfif Session.getSelectedEvent.H323_Available EQ 1 and Session.FormInput.RegisterStep1.H323Participant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.H323_MemberCost#>
									<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set H323Participant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
											lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
											lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>
								<cfset NewMember_Cost = #EventServicesCFC.ConvertCurrencyToDecimal(Variables.AttendeeEventPrice)#>
								<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Update p_EventRegistration_UserRegistrations
									Set AttendeePrice = <cfqueryparam value="#NumberFormat(Variables.NewMember_Cost, '999999.99')#" cfsqltype="cf_sql_decimal">,
										lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
									Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							<cfelse>
								<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
									<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_Deadline, "yyyy-mm-dd")) GTE 0>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.EarlyBird_NonMemberCost#>
									<cfelse>
										<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_NonMemberCost#>
									</cfif>
								<cfelseif Session.getSelectedEvent.EarlyBird_Available EQ 0 and Session.FormInput.RegisterStep1.FacilityParticipant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.Event_NonMemberCost#>
								</cfif>

								<cfif Session.getSelectedEvent.Webinar_Available EQ 1 and Session.FormInput.RegisterStep1.WebinarParticipant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.Webinar_NonMemberCost#>
									<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set WebinarParticipant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
											lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
											lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>

								<cfif Session.getSelectedEvent.H323_Available EQ 1 and Session.FormInput.RegisterStep1.H323Participant Contains 1>
									<cfset AttendeeEventPrice = #Session.getSelectedEvent.H323_NonMemberCost#>
									<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set H323Participant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
											lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
											lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
											lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
										Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
									</cfquery>
								</cfif>
								<cfset EventServicesCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
								<cfset NewMember_Cost = #EventServicesCFC.ConvertCurrencyToDecimal(Variables.AttendeeEventPrice)#>
								<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Update p_EventRegistration_UserRegistrations
									Set AttendeePrice = <cfqueryparam value="#NumberFormat(Variables.NewMember_Cost, '999999.99')#" cfsqltype="cf_sql_decimal">,
										lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
									Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>

							<cfif Session.FormInput.RegisterStep1.EmailConfirmations Contains 1>
								<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
									<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, "127.0.0.1")#>
								<cfelse>
									<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
										<cfif rc.$.siteConfig('mailserverssl') EQ "True">
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
										<cfelse>
											<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
										</cfif>
									<cfelse>
										<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY, rc.$.siteConfig('mailserverip'))#>
									</cfif>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="mssql">

						</cfcase>
					</cfswitch>
				<cfelse>
					
				</cfif>
			</cfloop>

			<cfset RegisterIndividuals = #ArrayToList(RegisteredParticipantsUserID, ",")#>

			<cfif ListLen(Variables.RegisterIndividuals) EQ 1>
				<cfif Variables.RegisterIndividuals NEQ Session.Mura.UserID>
					<!--- Send Email to User Logged In --->
					<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
						<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, "127.0.0.1")#>
					<cfelse>
						<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
							<cfif rc.$.siteConfig('mailserverssl') EQ "True">
								<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
							<cfelse>
								<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
							</cfif>
						<cfelse>
							<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'))#>
						</cfif>
					</cfif>
				</cfif>
			<cfelse>
				<!--- Send Email to User Logged In with a list of everyone registered --->
				<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
					<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, "127.0.0.1")#>
				<cfelse>
					<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
						<cfif rc.$.siteConfig('mailserverssl') EQ "True">
							<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
						<cfelse>
							<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
						</cfif>
					<cfelse>
						<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationConfirmationSummaryToSingleParticipant(rc, URL.EventID, Variables.RegisterIndividuals, rc.$.siteConfig('mailserverip'))#>
					</cfif>
				</cfif>
			</cfif>

			<cfset temp = StructDelete(Session, "EventInfo")>
			<cfset temp = StructDelete(Session, "FormErrors")>
			<cfset temp = StructDelete(Session, "FormInput")>
			<cfset temp = StructDelete(Session, "getAllEvents")>
			<cfset temp = StructDelete(Session, "getMembership")>
			<cfset temp = StructDelete(Session, "getMemberhipOrganizations")>
			<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
			<cfset temp = StructDelete(Session, "getSelectedAccountsWithinOrganization")>
			<cfset temp = StructDelete(Session, "getSelectedEvent")>
			<cfset temp = StructDelete(Session, "getSelectedEventFacility")>
			<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
			<cfset temp = StructDelete(Session, "getSelectedMember")>
			
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=ParticipantsRegistered&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=ParticipantsRegistered&Successful=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfcase>
	</cfswitch>

<!--- 
		<cfswitch expression="#URL.EventStatus#">
		<cfcase value="RegisterParticipants">
						
			<cfif Session.getSelectedEvent.AllowVideoConference EQ 1>
				<cfif not isDefined("FORM.H323Participant")>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please Select whether the participants for this registration will participte with video conferencing."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				<cfelse>
					<cfif FORM.H323Participant EQ "----">
						<cfscript>
							errormsg = {property="EmailMsg",message="Please Select whether the participants for this registration will participte with video conferencing."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
				</cfif>
			</cfif>

			<cfif Session.getSelectedEvent.Meal_Available EQ 1>
				<cfif not isDefined("FORM.RegisterParticipantStayForMeal")>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please Select whether the participants for this registration will participte in the meal."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				<cfelse>
					<cfif FORM.RegisterParticipantStayForMeal EQ "----">
						<cfscript>
							errormsg = {property="EmailMsg",message="Please Select whether the participants for this registration will participte in the meal."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
				</cfif>
			</cfif>

			<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
				<cfif not isDefined("FORM.WebinarParticipant")>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please Select whether the participants for this registration will participte with webex/webinar."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				<cfelse>
					<cfif FORM.WebinarParticipant EQ "----">
						<cfscript>
							errormsg = {property="EmailMsg",message="Please Select whether the participants for this registration will participte with webex/webinar."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
				</cfif>
			</cfif>
			

			<cfloop list="#Session.FormInput.RegisterStep2.ParticipantEmployee#" delimiters="," index="i">
				<cfset ParticipantUserID = ListFirst(i, "_")>
				<cfset DayNumber = ListLast(i, "_")>
				<cfquery name="CheckRegisteredAlready" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Select RegistrationID
					From p_EventRegistration_UserRegistrations
					Where Site_ID = <cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif CheckRegisteredAlready.RecordCount EQ 0>
					<cfset RegistrationUUID = #CreateUUID()#>
					<cfquery name="GetCurrentRegistrationsForEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Select TContent_ID
						From p_EventRegistration_UserRegistrations
						Where Site_ID = <cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
					</cfquery>

					<cfif GetCurrentRegistrationsForEvent.RecordCount LTE Session.GetSelectedEvent.MaxParticipants>
						<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Insert into p_EventRegistration_UserRegistrations(Site_ID, User_ID, Event_ID, RegistrationID, RegistrationDate, RegistrationIPAddr, RegisterByUserID)
							Values(
								<cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
								)
						</cfquery>
					<cfelse>
						<cfquery name="InsertRegistration" result="insertNewRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Insert into p_EventRegistration_UserRegistrations(Site_ID, User_ID, Event_ID, RegistrationID, RegistrationDate, RegistrationIPAddr, RegisterByUserID, OnWaitingList)
							Values(
								<cfqueryparam value="#$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">,
								<cfqueryparam value="#Variables.RegistrationUUID#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								<cfqueryparam value="#CGI.Remote_Addr#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">.
								<cfqueryparam value="1" cfsqltype="cf_sql_bit">
								)
						</cfquery>
					</cfif>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								update p_EventRegistration_UserRegistrations
								Set 
									<cfif Variables.DayNumber EQ 1>RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
									<cfif Variables.DayNumber EQ 2>RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
									<cfif Variables.DayNumber EQ 3>RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
									<cfif Variables.DayNumber EQ 4>RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
									<cfif Variables.DayNumber EQ 5>RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
									<cfif Variables.DayNumber EQ 6>RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATED_KEY#">
							</cfquery>
							<cfif Session.FormInput.RegisterStep2.RegisterParticipantStayForMeal EQ 1>
								<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set RequestsMeal = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATED_KEY#">
								</cfquery>
							</cfif>
							<cfif Session.FormInput.RegisterStep2.H323Participant EQ 1>
								<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set IVCParticipant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATED_KEY#">
								</cfquery>
							</cfif>
							<cfif Session.FormInput.RegisterStep2.WebinarParticipant EQ 1>
								<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set WebinarParticipant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATED_KEY#">
								</cfquery>
							</cfif>
							<cfquery name="GetSelectedDistrict" dbtype="Query">
								Select * From Session.GetMembershipOrganizations
								Where TContent_ID = <cfqueryparam value="#Session.FormInput.RegisterStep1.SchoolDistricts#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif  GetSelectedDistrict.Active EQ 1>
								<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1 and Session.FormInput.RegisterStep1.FacilityParticipant EQ 1>
									<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
										<cfset AttendeePrice = #Session.getSelectedEvent.EarlyBird_MemberCost#>
									<cfelse>
										<cfset AttendeePrice = #Session.getSelectedEvent.Member_Cost#>
									</cfif>
								<cfelseif Session.FormInput.RegisterStep1.FacilityParticipant EQ 0>
									<cfif Session.FormInput.RegisterStep2.WebinarParticipant EQ 1>
										<cfset AttendeePrice = #Session.getSelectedEvent.Webinar_MemberCost#>
									<cfelseif Session.FormInput.RegisterStep2.H323Participant EQ 1>
										<cfset AttendeePrice = #Session.getSelectedEvent.VideoConferenceMemberCost#>
									</cfif>
								<cfelse>
									<cfset AttendeePrice = #Session.getSelectedEvent.Member_Cost#>
								</cfif>
								<cfset NewMember_Cost = #EventServicesCFC.ConvertCurrencyToDecimal(Variables.AttendeePrice)#>
								<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Update p_EventRegistration_UserRegistrations
									Set AttendeePrice = <cfqueryparam value="#NumberFormat(Variables.NewMember_Cost, '99999999.9999')#" cfsqltype="cf_sql_decimal">
									Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							<cfelse>
								<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1 and Session.FormInput.RegisterStep1.FacilityParticipant EQ 1>
									<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
										<cfset AttendeePrice = #Session.getSelectedEvent.EarlyBird_NonMemberCost#>
									<cfelse>
										<cfset AttendeePrice = #Session.getSelectedEvent.NonMember_Cost#>
									</cfif>
								<cfelseif Session.FormInput.RegisterStep1.FacilityParticipant EQ 0>
									<cfif Session.FormInput.RegisterStep2.WebinarParticipant EQ 1>
										<cfset AttendeePrice = #Session.getSelectedEvent.Webinar_NonMemberCost#>
									<cfelseif Session.FormInput.RegisterStep2.H323Participant EQ 1>
										<cfset AttendeePrice = #Session.getSelectedEvent.VideoConferenceNonMemberCost#>
									</cfif>
								<cfelse>
									<cfset AttendeePrice = #Session.getSelectedEvent.Member_Cost#>
								</cfif>
								<cfset NewMember_Cost = #EventServicesCFC.ConvertCurrencyToDecimal(Variables.AttendeePrice)#>
								<cfquery name="UpdateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Update p_EventRegistration_UserRegistrations
									Set AttendeePrice = <cfqueryparam value="#NumberFormat(Variables.NewMember_Cost, '99999999.9999')#" cfsqltype="cf_sql_decimal">
									Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATED_KEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif Session.FormInput.RegisterStep1.EmailConfirmations EQ 1>
								<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATED_KEY)#>
							</cfif>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								update p_EventRegistration_UserRegistrations
								Set 
									<cfif Variables.DayNumber EQ 1>RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
									<cfif Variables.DayNumber EQ 2>RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
									<cfif Variables.DayNumber EQ 3>RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
									<cfif Variables.DayNumber EQ 4>RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
									<cfif Variables.DayNumber EQ 5>RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
									<cfif Variables.DayNumber EQ 6>RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"></cfif>
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATEDKEY#">
							</cfquery>
							<cfif Session.FormInput.RegisterStep2.RegisterParticipantStayForMeal EQ 1>
								<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set RequestsMeal = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATEDKEY#">
								</cfquery>
							</cfif>
							<cfif Session.FormInput.RegisterStep2.H323Participant EQ 1>
								<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set IVCParticipant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATEDKEY#">
								</cfquery>
							</cfif>
							<cfif Session.FormInput.RegisterStep2.WebinarParticipant EQ 1>
								<cfquery name="updateUserRegistrations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									update p_EventRegistration_UserRegistrations
									Set WebinarParticipant = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#insertNewRegistration.GENERATEDKEY#">
								</cfquery>
							</cfif>
							<cfquery name="GetSelectedDistrict" dbtype="Query">
								Select * From Session.GetMembershipOrganizations
								Where TContent_ID = <cfqueryparam value="#Session.FormInput.RegisterStep1.SchoolDistircts#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfif  GetSelectedDistrict.Active EQ 1>
								<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1 and Session.FormInput.RegisterStep1.FacilityParticipant EQ 1>
									<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
										<cfset AttendeePrice = #Session.getSelectedEvent.EarlyBird_MemberCost#>
									<cfelse>
										<cfset AttendeePrice = #Session.getSelectedEvent.Member_Cost#>
									</cfif>
								<cfelseif Session.FormInput.RegisterStep1.FacilityParticipant EQ 0>
									<cfif Session.FormInput.RegisterStep2.WebinarParticipant EQ 1>
										<cfset AttendeePrice = #Session.getSelectedEvent.Webinar_MemberCost#>
									<cfelseif Session.FormInput.RegisterStep2.H323Participant EQ 1>
										<cfset AttendeePrice = #Session.getSelectedEvent.VideoConferenceMemberCost#>
									</cfif>
								<cfelse>
									<cfset AttendeePrice = #Session.getSelectedEvent.Member_Cost#>
								</cfif>
								<cfset NewMember_Cost = #EventServicesCFC.ConvertCurrencyToDecimal(Variables.AttendeePrice)#>
								<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_UserRegistrations
									Set AttendeePrice = <cfqueryparam value="#NumberFormat(Variables.NewMember_Cost, '99999999.9999')#" cfsqltype="cf_sql_decimal">
									Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATEDKEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							<cfelse>
								<cfif Session.getSelectedEvent.EarlyBird_Available EQ 1 and Session.FormInput.RegisterStep1.FacilityParticipant EQ 1>
									<cfif DateDiff("d", DateFormat(Now(), "yyyy-mm-dd"), DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, "yyyy-mm-dd")) GTE 0>
										<cfset AttendeePrice = #Session.getSelectedEvent.EarlyBird_NonMemberCost#>
									<cfelse>
										<cfset AttendeePrice = #Session.getSelectedEvent.NonMember_Cost#>
									</cfif>
								<cfelseif Session.FormInput.RegisterStep1.FacilityParticipant EQ 0>
									<cfif Session.FormInput.RegisterStep2.WebinarParticipant EQ 1>
										<cfset AttendeePrice = #Session.getSelectedEvent.Webinar_NonMemberCost#>
									<cfelseif Session.FormInput.RegisterStep2.H323Participant EQ 1>
										<cfset AttendeePrice = #Session.getSelectedEvent.VideoConferenceNonMemberCost#>
									</cfif>
								<cfelse>
									<cfset AttendeePrice = #Session.getSelectedEvent.Member_Cost#>
								</cfif>
								<cfset NewMember_Cost = #EventServicesCFC.ConvertCurrencyToDecimal(Variables.AttendeePrice)#>
								<cfquery name="UpdateRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Update p_EventRegistration_UserRegistrations
									Set AttendeePrice = <cfqueryparam value="#NumberFormat(Variables.NewMember_Cost, '99999999.9999')#" cfsqltype="cf_sql_decimal">
									Where TContent_ID = <cfqueryparam value="#insertNewRegistration.GENERATEDKEY#" cfsqltype="cf_sql_integer">
								</cfquery>
							</cfif>
							<cfif Session.FormInput.RegisterStep1.EmailConfirmations EQ 1>
								<cfset temp = #Variables.SendEmailCFC.SendEventRegistrationToSingleParticipant(rc, insertNewRegistration.GENERATEDKEY)#>
							</cfif>
						</cfcase>
					</cfswitch>
					<cfif Session.FormInput.RegisterStep1.SendPreviousEmailCommunications EQ 1>
						
						<cfif Session.CheckExistingSentEmailsForEvent.RecordCount>
							<cfquery name="GetParticipantInfo" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select FName, LName, Email
								From tusers
								Where UserID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfset ParticipantInfo = StructNew()>
							<cfset ParticipantInfo.FName = #GetParticipantInfo.Fname#>
							<cfset ParticipantInfo.LName = #GetParticipantInfo.Lname#>
							<cfset ParticipantInfo.EmailType = "EmailRegistered">
							<cfset ParticipantInfo.Email = #GetParticipantInfo.Email#>
							<cfset ParticipantInfo.EventShortTitle = #Session.getSelectedEvent.ShortTitle#>
							<cfset ParticipantInfo.EmailMessageBody = #Session.CheckExistingSentEmailsForEvent.MsgBody#>
							<cfset ParticipantInfo.WebEventDirectory = "/plugins/" & #HTMLEditFormat(rc.pc.getPackage())# & "/includes/assets/documents/" & #URL.EventID# & "/">
							<cfset ParticipantInfo.EventDocsDirectory = #rc.pc.getFullPath()# & "/includes/assets/documents/" & #FORM.EventID# & "/">
							<cfif LEN(Session.CheckExistingSentEmailsForEvent.DocsToInclude)>
								<cfquery name="GetSelectedEventDocuments" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
									From p_EventRegistration_EventResources
									Where TContent_ID IN (#FORM.IncludeDocumentLinkInEmail#)
								</cfquery>
								<cfset ParticipantInfo.DocumentLinksInEmail = #StructCopy(GetSelectedEventDocuments)#>
							</cfif>
							<cfif LEN(Session.CheckExistingSentEmailsForEvent.LinksToInclude)>
								<cfquery name="GetSelectedEventWebLinks" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Select TContent_ID, ResourceType, ResourceLink, dateCreated, lastUpdated, lastUpdateBy, ResourceDocument, ResourceDocumentType
									From p_EventRegistration_EventResources
									Where TContent_ID IN (#FORM.IncludeWebLinkInEmail#)
								</cfquery>
								<cfset ParticipantInfo.WebLinksInEmail = #StructCopy(GetSelectedEventWebLinks)#>
							</cfif>
							<cfset temp = #Variables.SendEMailCFC.SendEventMessageToAllParticipants(rc, Variables.ParticipantInfo)#>
						</cfif>
					</cfif>
				<cfelse>
					<cfswitch expression="#Variables.DayNumber#">
						<cfcase value="1">
							<cfquery name="updateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfcase>
						<cfcase value="2">
							<cfquery name="updateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfcase>
						<cfcase value="3">
							<cfquery name="updateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfcase>
						<cfcase value="4">
							<cfquery name="updateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfcase>
						<cfcase value="5">
							<cfquery name="updateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfcase>
						<cfcase value="6">
							<cfquery name="updateRegistration" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								update p_EventRegistration_UserRegistrations
								Set RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Where RegistrationID = <cfqueryparam value="#CheckRegisteredAlready.RegistrationID#" cfsqltype="cf_sql_varchar">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>
			</cfloop>
			<cfset temp = StructDelete(Session, "getSelectedEvent")>
			<cfset temp = StructDelete(Session, "getAlLEvents")>
			<cfset temp = StructDelete(Session, "getSelectedAccountsWithinOrganization")>
			<cfset temp = StructDelete(Session, "JSMuraScope")>
			<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
			<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
			<cfset temp = StructDelete(Session, "getSelectedEventFacility")>
			<cfset temp = StructDelete(Session, "CheckExistingSentEmailsForEvent")>
			<cfset temp = StructDelete(Session, "GetMembershipOrganizations")>
			<cfset temp = StructDelete(Session, "FormErrors")>
			<cfset temp = StructDelete(Session, "FormInput")>

			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=ParticipantRegistered&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=ParticipantRegistered&Successful=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">	
		</cfcase>
		<cfcase value="ShowCorporations">
			

			<cfif FORM.SchoolDistricts EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select the School District which the person is employed by."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.EmailConfirmations EQ "----"><cfset FORM.EmailConfirmations = 1></cfif>

			<cfif not isDefined("FORM.H323Participant") and FORM.WebinarParticipant EQ 0 and FORM.FacilityParticipant EQ "----"><cfset FORM.FacilityParticipant = 1></cfif>

			<cfif isDefined("FORM.SendPreviousEmailCommunications")><cfif FORM.SendPreviousEmailCommunications EQ "----"><cfset FORM.SendPreviousEmailCommunications = 1></cfif><cfelse><cfset FORM.SendPreviousEmailCommunications = 0></cfif>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput.RegisterStep1 = #StructCopy(FORM)#>
			</cflock>

			<cfquery name="GetSelectedOrganizationDomainame" dbtype="Query">
				Select * from Session.GetMembershipOrganizations
				Where TContent_ID = <cfqueryparam value="#Session.FormInput.RegisterStep1.SchoolDistricts#" cfsqltype="CF_SQL_INTEGER">
			</cfquery>

			<cfquery name="GetSelectedAccountsWithinOrganization" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select UserID, Fname, Lname, Email
				From tusers
				WHERE 1 = 1 AND Email LIKE '%#GetSelectedOrganizationDomainame.OrganizationDomainName#%'
				Order by Lname ASC, Fname ASC
			</cfquery>
			<cfset temp = #QueryAddColumn(GetSelectedAccountsWithinOrganization, "SortOrder", "integer")#>
			<cfset temp = #QueryAddColumn(GetSelectedAccountsWithinOrganization, "TempColumn", "integer")#>
			<cfset temp = #QueryAddColumn(GetSelectedAccountsWithinOrganization, "TempRow", "integer")#>
			<cfset DisplayQueryRows = Ceiling(GetSelectedAccountsWithinOrganization.RecordCount / 4)>
			<cfset DisplayBlankRecords = (4 * Variables.DisplayQueryRows) - #GetSelectedAccountsWithinOrganization.RecordCount#>
			<cfset temp = #QueryAddRow(GetSelectedAccountsWithinOrganization, variables.DisplayBlankRecords)#>
						
			<cfloop query="GetSelectedAccountsWithinOrganization">
				<cfset tempColumn = ((GetSelectedAccountsWithinOrganization.CurrentRow - 1) \ Variables.DisplayQueryRows) + 1>
				<cfset temp = #QuerySetCell(GetSelectedAccountsWithinOrganization, "TempColumn", variables.tempColumn, GetSelectedAccountsWithinOrganization.CurrentRow)#>
				<cfset TempCalc = GetSelectedAccountsWithinOrganization.CurrentRow MOD Variables.DisplayQueryRows>
				<cfif TempCalc EQ 0><cfset TempRow = Variables.DisplayQueryRows><cfelse><cfset TempRow = Variables.TempCalc></cfif>
				<cfset temp = #QuerySetCell(GetSelectedAccountsWithinOrganization, "TempRow", variables.TempRow, GetSelectedAccountsWithinOrganization.CurrentRow)#>	
				<!--- 
				<cfset SortOrderNumber = ((Variables.TempRow - 1) * Variables.DisplayQueryRows) + Variables.TempColumn>
				<cfset temp = #QuerySetCell(GetSelectedAccountsWithinOrganization, "SortOrder", variables.SortOrderNumber, GetSelectedAccountsWithinOrganization.CurrentRow)#>
				--->
			</cfloop>
			<cfquery name="GetSelectedAccountsWithinOrganizationReSorted" dbtype="Query">
				Select * from GetSelectedAccountsWithinOrganization
				Order by TempRow ASC, TempColumn ASC
			</cfquery>
			
			<cfset Session.GetSelectedAccountsWithinOrganization = StructCopy(GetSelectedAccountsWithinOrganizationReSorted)>
		</cfcase>
	</cfswitch>
--->
</cfif>

	<!--- 

			
		
			<cfif not isDefined("FORM.ParticipantEmployee")>
				<cfscript>
					eventdate = {property="EventDate",message="You will need to select at least one participant from the list below to remove them from the registration of this event"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.deregisteruserforevent&EventID=#URL.EventID#&FormRetry=True" addtoken="false">
			</cfif>

			<cfif isDefined("FORM.SendConfirmation")>
				<cfif FORM.SendConfirmation EQ "on">
					<cfset FORM.SendConfirmation = 1>
				</cfif>
			<cfelse>
				<cfset FORM.SendConfirmation = 0>
			</cfif>

			<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

			<cfloop list="#FORM.ParticipantEmployee#" delimiters="," index="i">
				<cfset ParticipantUserID = ListFirst(i, "_")>
				<cfset DayNumber = ListLast(i, "_")>
				<cfswitch expression="#Variables.DayNumber#">
					<cfcase value="1">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 1 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate1 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
									WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 1>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 1 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate1 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
					<cfcase value="2">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 1 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate2 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
									WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 2>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 1 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate2 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
					<cfcase value="3">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 1 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate3 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
									WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 3>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 1 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate3 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
					<cfcase value="4">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 1 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate4 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
									WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 4>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 1 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate4 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
					<cfcase value="5">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 1 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate5 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
									WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 5>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 1 AND GetSelectedRegistration.RegisterForEventDate6 EQ 0>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate5 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
					<cfcase value="6">
						<cfswitch expression="#FORM.SendConfirmation#">
							<cfcase value="0">
								<cfquery name="CheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select RegistrationID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
									From p_EventRegistration_UserRegistrations
									Where EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfif CheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and CheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND CheckRegistrationNumberDays.RegisterForEventDate6 EQ 1>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate6 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#CheckRegistrationNumberDays.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
							<cfcase value="1">
								<cfquery name="GetSelectedRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									SELECT p_EventRegistration_UserRegistrations.RegistrationID, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
										p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
									FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
									WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Variables.ParticipantUserID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset ParticipantInfo = StructNew()>
								<cfset ParticipantInfo.Registration = #StructCopy(GetSelectedRegistration)#>
								<cfset ParticipantInfo.RegistrationDay = 6>
								<cfset temp = #SendEMailCFC.SendEventCancellationByFacilitatorToSingleParticipant(rc, Variables.ParticipantInfo)#>
								<cfif GetSelectedRegistration.RegisterForEventDate1 EQ 0 and GetSelectedRegistration.RegisterForEventDate2 EQ 0 AND GetSelectedRegistration.RegisterForEventDate3 EQ 0 AND GetSelectedRegistration.RegisterForEventDate4 EQ 0 AND GetSelectedRegistration.RegisterForEventDate5 EQ 0 AND GetSelectedRegistration.RegisterForEventDate6 EQ 1>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Delete from p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
								<cfelse>
									<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Update p_EventRegistration_UserRegistrations
										Set RegisterForEventDate6 = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfquery name="ReCheckRegistrationNumberDays" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6
										From p_EventRegistration_UserRegistrations
										Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
									</cfquery>
									<cfif ReCheckRegistrationNumberDays.RegisterForEventDate1 EQ 0 and ReCheckRegistrationNumberDays.RegisterForEventDate2 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate3 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate4 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate5 EQ 0 AND ReCheckRegistrationNumberDays.RegisterForEventDate6 EQ 0>
										<cfquery name="RemoveRegistration" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Delete from p_EventRegistration_UserRegistrations
											Where RegistrationID = <cfqueryparam value="#GetSelectedRegistration.RegistrationID#" cfsqltype="cf_sql_varchar">
										</cfquery>
									</cfif>
								</cfif>
							</cfcase>
						</cfswitch>
					</cfcase>
				</cfswitch>
			</cfloop>

			<cfset temp = StructDelete(Session, "getSelectedEvent")>
			<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
			<cfset temp = StructDelete(Session, "FormErrors")>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default&UserAction=RemovedParticipants&Successful=True" addtoken="false">
		</cfif>
		--->