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
		<cfset Session.getPresenter = StructCopy(getPresenter)>
	</cfif>

	<cfswitch expression="#application.configbean.getDBType()#">
		<cfcase value="mysql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM, p_EventRegistration_UserRegistrations.AttendeePrice, p_EventRegistration_UserRegistrations.RegistrationDate
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
			<cfset Session.getRegisteredParticipants = StructCopy(getRegisteredParticipants)>
		</cfcase>
		<cfcase value="mssql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM, p_EventRegistration_UserRegistrations.AttendeePrice, p_EventRegistration_UserRegistrations.RegistrationDate
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
			<cfset Session.getRegisteredParticipants = StructCopy(getRegisteredParticipants)>
		</cfcase>
	</cfswitch>

	<cfquery name="getFacilitator" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select FName, Lname, Email
		From tusers
		Where UserID = <cfqueryparam value="#getSelectedEvent.FacilitatorID#" cfsqltype="cf_sql_varchar">
	</cfquery>
	<cfset Session.getEventFacilitator = StructCopy(getFacilitator)>

	<cfquery name="GetMembershipOrganizations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, OrganizationName, OrganizationDomainName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, StateDOE_IDNumber, StateDOE_State, Active, AccountsPayable_ContactName, AccountsPayable_EmailAddress, ReceiveInvoicesByEmail
		From p_EventRegistration_Membership
		Order by OrganizationName
	</cfquery>
	<cfset Session.GetMembershipOrganizations = StructCopy(GetMembershipOrganizations)>
<cfelse>
	<cfif FORM.UserAction EQ "Back to Events Menu">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "SiteConfigSettings")>
		<cfset temp = StructDelete(Session, "getPresenter")>
		<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cfset EventServicesCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EventServices")>
	<cfset SendEmailCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/EmailServices")>

	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.FormInput = #StructCopy(FORM)#>
	</cflock>

	<cfset Participant = StructNew()>
	<cfloop list="#FORM.fieldnames#" index="i" delimiters=",">
		<cfif ListContains(i, "ParticipantCost", "_")>
			<cfset Participant[i] = StructNew()>
			<cfset Participant[i]['RecordID'] = #ListLast(i, "_")#>
			<cfset Participant[i]['Amount'] = #FORM[i]#>
		</cfif>
	</cfloop>

	<cfloop collection=#Variables.Participant# item="RecNo">
		<cfset NewMemberCost = #EventServicesCFC.ConvertCurrencyToDecimal(Variables.Participant[RecNo]['Amount'])#>
		<cfquery name="UpdateAttendeePrice" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Update p_EventRegistration_UserRegistrations
			Set AttendeePrice = <cfqueryparam value="#NumberFormat(Variables.NewMemberCost, '99999999.9999')#" cfsqltype="cf_sql_decimal">,
				AttendeePriceVerified = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
				lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				lastpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
				lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
			Where User_ID = <cfqueryparam value="#Variables.Participant[RecNo]['RecordID']#" cfsqltype="cf_sql_varchar"> and 
				Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		</cfquery>
	</cfloop>
	
	<cfset ReportExportDirLoc = "/plugins/" & #rc.pc.getPackage()# & "/library/ReportExports/">
	<cfset EmailSummaryLinks = ArrayNew(2)>

	<cfquery name="GetParticipantOrganizations" dbtype="query">
		Select Domain
		From Session.getRegisteredParticipants
		Group By Domain
	</cfquery>

	<cfset LogoPath = ArrayNew(1)>
	<cfloop from="1" to="#GetParticipantOrganizations.RecordCount#" step="1" index="i">
		<cfswitch expression="#rc.$.siteConfig('siteID')#">
			<cfdefaultcase>
				<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/assets/images/NIESC_LogoSM.png")#>
			</cfdefaultcase>
		</cfswitch>
	</cfloop>
	<cfset temp = QueryAddColumn(GetParticipantOrganizations, "ReportLogoPath", "VarChar", Variables.LogoPath)>

	<cfloop query="GetParticipantOrganizations">
		<cfquery name="GetOrganizationInfo" dbtype="Query">
			Select *
			From Session.GetMembershipOrganizations
			Where OrganizationDomainName = <cfqueryparam value="#GetParticipantOrganizations.Domain#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfquery name="GetParticipantsFromOrganization" dbtype="Query">
			Select *
			From Session.getRegisteredParticipants
			Where Domain = <cfqueryparam value="#GetParticipantOrganizations.Domain#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset OrgFileName = #Replace(GetOrganizationInfo.OrganizationName, " ", "", "ALL")#>
		<cfset ReportExportLoc = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")# & #URL.EventID# & "-" & #Variables.OrgFileName# & "_Invoice.pdf" >
		<cfset ReportExportURL = "http://" & #cgi.server_name# & "/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/" & #URL.EventID# & "-" & #Variables.OrgFileName# & "_Invoice.pdf" >
		<cffile action="readbinary" file="#GetParticipantOrganizations.ReportLogoPath#" variable="ImageBinaryString">
		<cfscript>FileMimeType = fileGetMimeType(GetParticipantOrganizations.ReportLogoPath);</cfscript>

		<cfset Temp = EmailSummaryLinks[GetParticipantOrganizations.CurrentRow][1] = #Variables.ReportExportURL#>
		<cfset Temp = EmailSummaryLinks[GetParticipantOrganizations.CurrentRow][2] = #GetOrganizationInfo.OrganizationName#>
		<cfset EventShortTitle = #Session.getSelectedEvent.ShortTitle#>
		<cfset InvoiceTotal = 0>
		<cfoutput>
			<cfdocument format="PDF" filename="#Variables.ReportExportLoc#" fontEmbed="yes" orientation="portrait" localurl="Yes" pageType="letter" overwrite="true" saveAsName="#URL.EventID#-#Variables.OrgFileName#_Invoice.pdf">
				<cfdocumentitem type="header" evalAtPrint="true">
					<table border="0" colspacing="1" cellpadding="1" width="100%">
						<tr>
							<th width="50%" align="left" colspan="2"><img src="data:#Variables.FileMimeType#;base64,#ToBase64(Variables.ImageBinaryString)#"></th>
							<th width="50%" colspan="2" style="font-family: Arial; font-size: 12px;">Northern Indiana Educational Services Center<br>56535 Magnetic Drive<br>Mishawaka IN 46545<br>(800) 326-5642 / (574) 254-0111<br>http://www.niesc.k12.in.us</th>
						</tr>
						<tr><th colspan="4"><h1>INVOICE STATEMENT</h1></th></tr>
						<tr><td colspan="4"><hr style="border-top: 1px solid ##8c8b8b;" /></td></tr>
						<tr><td colspan="4" align="center">#Session.getSelectedEvent.ShortTitle#</td></tr>
						<tr><td colspan="4" align="center">#DateFormat(Session.getSelectedEvent.EventDate, "full")#</td></tr>
						<tr><td colspan="4"><hr /></td></tr>
						<tr><td colspan="2" width="50%" style="font-family: Arial; font-size: 12px;">Bill To:</td><td width="25%" style="font-family: Arial; font-size: 12px;" align="Right" valign="Top">Invoice ##:</td><td width="25%" style="font-family: Arial; font-size: 12px;" align="Left" valign="Top">#GetOrganizationInfo.TContent_ID#-#URL.EventID#</td></tr>
						<tr><td colspan="2" width="50%" style="font-family: Arial; font-size: 10px;">#GetOrganizationInfo.OrganizationName#<br>#GetOrganizationInfo.PhysicalAddress#<br>#GetOrganizationInfo.PhysicalCity#, #GetOrganizationInfo.PhysicalState# #GetOrganizationInfo.PhysicalZipCode#</td><td width="25%" style="font-family: Arial; font-size: 12px;" align="Right" valign="Top">&nbsp;</td><td width="25%" style="font-family: Arial; font-size: 12px;" align="Left" valign="Top">&nbsp;</td></td>
						</tr>
						<tr><td colspan="4"><hr /></td></tr>
					</table>
				</cfdocumentitem>
				<cfdocumentsection>
					<table border="0" colspacing="1" cellpadding="1" width="100%">
						<thead>
							<tr>
								<th align="left" width="30%" style="font-family: Arial; font-size: 12px; color: ##000000;">Participant's Name</th>
								<th align="left" width="40%" style="font-family: Arial; font-size: 12px; color: ##000000;">Email</th>
								<th align="left" width="30%" style="font-family: Arial; font-size: 12px; color: ##000000;">Cost</th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="GetParticipantsFromOrganization">
								<cfset InvoiceTotal = #Variables.InvoiceTotal# + #GetParticipantsFromOrganization.AttendeePrice#>
								<tr>
									<th align="left" style="font-family: Arial; font-size: 12px; color: ##000000;">#GetParticipantsFromOrganization.Fname# #GetParticipantsFromOrganization.LName#</th>
									<th align="left" width="20%" style="font-family: Arial; font-size: 12px; color: ##000000;">#GetParticipantsFromOrganization.Email#</th>
									<th align="left" width="20%" style="font-family: Arial; font-size: 12px; color: ##000000;">#DollarFormat(GetParticipantsFromOrganization.AttendeePrice)#</th>
								</tr>
							</cfloop>
						</tbody>
					</table>
				</cfdocumentsection>
				<cfdocumentitem type="footer" evalAtPrint="true">
					<table border="0" colspacing="1" cellpadding="1" width="100%">
						<tr>
							<th align="Right" style="font-family: Arial; font-size: 24px; color: ##FF0000;">Invoice Total:</th>
							<th align="Left" style="font-family: Arial; font-size: 24px; color: ##FF0000;">#DollarFormat(Variables.InvoiceTotal)#</th>
						</tr>
					</table>
					<table border="0" colspacing="0" cellpadding="0" width="100%" bgcolor="##000040">
						<tr bgcolor="##000040">
							<td colspan="3" style="font-family: Arial; font-size: 10px; color: ##FFFFFF; text-align: center;" align="center">Please Remit to:<br>Northern Indiana Educational Services Center<br>56535 Magnetic Drive Mishawaka IN 46545<br>Attn: Sherry Emery sherry@niesc.k12.in.us</td>
						</tr>
						<tr bgcolor="##000040"><td colspan="3"><hr></td></tr>
						<tr bgcolor="##000040">
							<td style="font-family: Arial; font-size: 10px; color: ##FFFFFF;" align="left">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
							<td style="font-family: Arial; font-size: 10px; color: ##FFFFFF;" align="center">THANK YOU FOR YOUR BUSINESS</td>
							<td style="font-family: Arial; font-size: 10px; color: ##FFFFFF;" align="right">Printed: #DateFormat(Now(), "short")#</td>
						</tr>
					</table>
				</cfdocumentitem>
				
			</cfdocument>
		</cfoutput>

		<cfswitch expression="#rc.$.siteConfig('siteID')#">
			<cfdefaultcase>
				<cfif GetOrganizationInfo.ReceiveInvoicesByEmail EQ 1>
					<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
						<cfset temp = #Variables.SendEmailCFC.SendStatementofInvoiceToMembership(rc, Variables.ReportExportLoc, Session.getSelectedEvent.ShortTitle, GetOrganizationInfo.AccountsPayable_ContactName, "gpearson@niesc.k12.in.us", "127.0.0.1")#>
					<cfelse>
						<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
							<cfif rc.$.siteConfig('mailserverssl') EQ "True">
								<cfset temp = #Variables.SendEMailCFC.SendStatementofInvoiceToMembership(rc, Variables.ReportExportLoc, GetOrganizationRegistrations.ShortTitle, GetOrganizationInfo.AccountsPayable_ContactName, "gpearson@niesc.k12.in.us", rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
							<cfelse>
								<cfset temp = #Variables.SendEMailCFC.SendStatementofInvoiceToMembership(rc, Variables.ReportExportLoc, GetOrganizationRegistrations.ShortTitle, GetOrganizationInfo.AccountsPayable_ContactName, "gpearson@niesc.k12.in.us", rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
							</cfif>
						<cfelse>
							<cfset temp = #Variables.SendEMailCFC.SendStatementofInvoiceToMembership(rc, Variables.ReportExportLoc, GetOrganizationRegistrations.ShortTitle, GetOrganizationInfo.AccountsPayable_ContactName, "gpearson@niesc.k12.in.us", rc.$.siteConfig('mailserverip'))#>
						</cfif>
					</cfif>
				</cfif>
			</cfdefaultcase>
		</cfswitch>
	</cfloop>

	<cfswitch expression="#rc.$.siteConfig('siteID')#">
		<cfdefaultcase>
			<cfset FacilitatorName = #Session.getEventFacilitator.Fname# & " " & #Session.getEventFacilitator.Lname#>
			<cfif LEN(rc.$.siteConfig('mailserverip')) EQ 0>
				<cfset temp = #Variables.SendEmailCFC.SendStatementofInvoiceToSiteAccountsPayableAdmin(rc, Variables.EmailSummaryLinks, Variables.EventShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", "127.0.0.1")#>
			<cfelse>
				<cfif LEN(rc.$.siteConfig('mailserverusername')) and LEN(rc.$.siteConfig('mailserverpassword'))>
					<cfif rc.$.siteConfig('mailserverssl') EQ "True">
						<cfset temp = #Variables.SendEMailCFC.SendStatementofInvoiceToSiteAccountsPayableAdmin(rc, Variables.EmailSummaryLinks, Variables.EventShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'), "True")#>
					<cfelse>
						<cfset temp = #Variables.SendEMailCFC.SendStatementofInvoiceToSiteAccountsPayableAdmin(rc, Variables.EmailSummaryLinks, Variables.EventShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", rc.$.siteConfig('mailserverip'), rc.$.siteConfig('mailserverusername'), rc.$.siteConfig('mailserverpassword'))#>
						</cfif>
				<cfelse>
					<cfset temp = #Variables.SendEMailCFC.SendStatementofInvoiceToSiteAccountsPayableAdmin(rc, Variables.EmailSummaryLinks, Variables.EventShortTitle, Variables.FacilitatorName, "gpearson@niesc.k12.in.us", rc.$.siteConfig('mailserverip'))#>
				</cfif>
			</cfif>
		</cfdefaultcase>
	</cfswitch>

	<cfquery name="UpdateEventInvoiceGenerateFlag" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		Update p_EventRegistration_Events
		Set EventInvoicesGenerated = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
			lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			lastpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
			lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
		Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">
	</cfquery>

	<cfif LEN(cgi.path_info)>
		<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=EventInvoicesGenerated&Successful=True" >
	<cfelse>
		<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=EventInvoicesGenerated&Successful=True" >
	</cfif>
	<cflocation url="#variables.newurl#" addtoken="false">

</cfif>