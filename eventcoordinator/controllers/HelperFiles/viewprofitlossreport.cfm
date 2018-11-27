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

	<cfswitch expression="#application.configbean.getDBType()#">
		<cfcase value="mysql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, tusers.Fname, tusers.Lname, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_UserRegistrations.AttendeePrice, p_EventRegistration_UserRegistrations.RegistrationDate, p_EventRegistration_UserRegistrations.AttendeePriceVerified
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID 
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
		<cfcase value="mssql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, tusers.Fname, tusers.Lname, tusers.Email, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain, p_EventRegistration_UserRegistrations.AttendeePrice, p_EventRegistration_UserRegistrations.RegistrationDate, p_EventRegistration_UserRegistrations.AttendeePriceVerified
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID 
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
	</cfswitch>

	<cfquery name="getEventExpenses" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		SELECT p_EventRegistration_EventExpenses.TContent_ID, p_EventRegistration_EventExpenses.Site_ID, p_EventRegistration_EventExpenses.Event_ID, p_EventRegistration_EventExpenses.Cost_Amount, p_EventRegistration_EventExpenses.Expense_ID, p_EventRegistration_EventExpenses.dateCreated, p_EventRegistration_EventExpenses.lastUpdated, p_EventRegistration_EventExpenses.lastUpdateBy, p_EventRegistration_EventExpenses.lastUpdateByID, p_EventRegistration_EventExpenses.Active, p_EventRegistration_EventExpenses.Cost_Verified, p_EventRegistration_ExpenseList.Expense_Name
		FROM p_EventRegistration_EventExpenses INNER JOIN p_EventRegistration_ExpenseList ON p_EventRegistration_ExpenseList.TContent_ID = p_EventRegistration_EventExpenses.Expense_ID
		WHERE p_EventRegistration_EventExpenses.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
	</cfquery>

	<cfquery name="getFacilitator" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select FName, Lname, Email
		From tusers
		Where UserID = <cfqueryparam value="#getSelectedEvent.FacilitatorID#" cfsqltype="cf_sql_varchar">
	</cfquery>
	
	<cfquery name="GetMembershipOrganizations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, OrganizationName, OrganizationDomainName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, StateDOE_IDNumber, StateDOE_State, Active, AccountsPayable_ContactName, AccountsPayable_EmailAddress, ReceiveInvoicesByEmail
		From p_EventRegistration_Membership
		Order by OrganizationName
	</cfquery>

	<cfswitch expression="#rc.$.siteConfig('siteID')#">
		<cfdefaultcase>
			<cfset LogoPathLoc = "/plugins/" & #rc.pc.getPackage()# & "/assets/images/NIESC_LogoSM.png">
		</cfdefaultcase>
	</cfswitch>

	<cffile action="readbinary" file="#ExpandPath(Variables.LogoPathLoc)#" variable="ImageBinaryString">
	<cfscript>FileMimeType = fileGetMimeType(ExpandPath(Variables.LogoPathLoc));</cfscript>
	<cfset ReportExportDirLoc = "/plugins/" & #rc.pc.getPackage()# & "/library/ReportExports/">
	<cfset ReportExportLoc = #ExpandPath(ReportExportDirLoc)# & #URL.EventID# & "-ProfitLossReport.pdf">
	<cfoutput>
		<cfdocument format="PDF" filename="#Variables.ReportExportLoc#" fontEmbed="yes" orientation="portrait" localurl="Yes" pageType="letter" overwrite="true" saveAsName="#URL.EventID#-ProfitLossReport.pdf">
			<cfdocumentitem type="header" evalAtPrint="true">
				<table border="0" colspacing="1" cellpadding="1" width="100%">
					<tr>
						<th width="30%"><img src="data:#Variables.FileMimeType#;base64,#ToBase64(Variables.ImageBinaryString)#"></th>
						<th width="70%">Northern Indiana Educational Services Center<br>56535 Magnetic Drive<br>Mishawaka IN 46545<br>(800) 326-5642 / (574) 254-0111<br>http://www.niesc.k12.in.us</th>
					</tr>
					<tr> <th colspan="2"><h1>Event Profit/Loss Report</h1></th></tr>
					<tr><td colspan="2"><hr style="border-top: 1px solid ##8c8b8b;" /></td></tr>
					<tr><td colspan="2" align="center">#getSelectedEvent.ShortTitle#</td></tr>
					<tr><td colspan="2" align="center">#DateFormat(getSelectedEvent.EventDate, "full")#</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
				</table>
			</cfdocumentitem>
			<cfdocumentsection>
				<cfset TotalEventExpenses = 0>
				<cfset TotalIncomeGenerated = 0>
				<table border="0" colspacing="1" cellpadding="1" width="100%">
					<thead>
						<tr><th colspan="2" style="font-family: Arial; font-size: 18px; color: ##000000; font-weight: bold; text-align: left;">Event Expenses</th></tr>
						<tr><th style="font-family: Arial; font-size: 12px; color: ##000000; font-weight: bold; text-align: left;">Expense Name</th><th style="font-family: Arial; font-size: 12px; color: ##000000; font-weight: bold; text-align: left;">Expense Cost</th></tr>
					</thead>
					<tbody>
						<cfloop query="getEventExpenses">
							<tr>
							<td style="font-family: Arial; font-size: 12px; color: ##000000; text-align: left;">#getEventExpenses.Expense_Name#</td>
							<td style="font-family: Arial; font-size: 12px; color: ##000000; text-align: left;">#DollarFormat(getEventExpenses.Cost_Amount)#</td>
							</tr>
							<cfset TotalEventExpenses = #Variables.TotalEventExpenses# + #getEventExpenses.Cost_Amount#>
						</cfloop>
					</tbody>
					<tfoot>
						<tr>
							<td width="100%" colspan="2" style="font-family: Arial; font-size: 18px; color: ##FF0000; font-weight: bold; text-align: right;"><br /></td>
						</tr>
						<tr>
							<td width="75%" style="font-family: Arial; font-size: 18px; color: ##FF0000; font-weight: bold; text-align: right;">Expense Total:</td>
							<td width="25%" style="font-family: Arial; font-size: 18px; color: ##FF0000; font-weight: bold; text-align: left;">#DollarFormat(Variables.TotalEventExpenses)#</td>
						</tr>
					</tfoot>
				</table>
				<br>
				<table border="0" colspacing="1" cellpadding="1" width="100%">
					<thead>
						<tr><th colspan="3" style="font-family: Arial; font-size: 18px; color: ##000000; font-weight: bold; text-align: left;">Event Income</th></tr>
						<tr>
							<th width="40%" style="font-family: Arial; font-size: 12px; color: ##000000; font-weight: bold; text-align: left;">Participant Name</th>
							<th width="40%" style="font-family: Arial; font-size: 12px; color: ##000000; font-weight: bold; text-align: left;">Membership District</th>
							<th width="20%" style="font-family: Arial; font-size: 12px; color: ##000000; font-weight: bold; text-align: left;">Participant Cost</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="getRegisteredParticipants">
							<cfquery name="GetParticipantMembership" dbtype="Query">
								Select *
								From GetMembershipOrganizations
								Where OrganizationDomainName = <cfqueryparam value="#getRegisteredParticipants.Domain#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<tr>
							<td>#getRegisteredParticipants.FName# #getRegisteredParticipants.Lname#</td>
							<td>#GetParticipantMembership.OrganizationName# (<cfswitch expression="#GetParticipantMembership.Active#"><cfcase value="1">Yes</cfcase><cfdefaultcase>No</cfdefaultcase></cfswitch>)</td>
							<td>#DollarFormat(getRegisteredParticipants.AttendeePrice)#</td>
							</tr>
							<cfset TotalIncomeGenerated = #Variables.TotalIncomeGenerated# + #getRegisteredParticipants.AttendeePrice#>
						</cfloop>
					</tbody>
					<tfoot>
						<tr>
							<td width="100%" colspan="2" style="font-family: Arial; font-size: 18px; color: ##FF0000; font-weight: bold; text-align: right;"><br /></td>
						</tr>
						<tr>
							<td colspan="2" width="75%" style="font-family: Arial; font-size: 18px; color: ##FF0000; font-weight: bold; text-align: right;">Income Total:</td>
							<td width="25%" style="font-family: Arial; font-size: 18px; color: ##FF0000; font-weight: bold; text-align: left;">#DollarFormat(Variables.TotalIncomeGenerated)#</td>
						</tr>
					</tfoot>
				</table>
			</cfdocumentsection>
			<cfdocumentitem type="footer" evalAtPrint="true">
				<cfset EventBalance = #Variables.TotalIncomeGenerated# - #Variables.TotalEventExpenses#>
				<table border="0" colspacing="1" cellpadding="1" width="100%">
					<tr><td width="75%" style="font-family: Arial; font-size: 18px; color: ##FF0000; font-weight: bold; text-align: right;">Profit / (Loss)</td><td width="25%" style="font-family: Arial; font-size: 18px; color: ##FF0000; font-weight: bold; text-align: left;">#DollarFormat(Variables.EventBalance)#</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr bgcolor="##000040">
						<td style="font-family: Arial; font-size: 10px; color: ##FFFFFF;" align="left">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
						<td style="font-family: Arial; font-size: 10px; color: ##FFFFFF;" align="right">Printed: #DateFormat(Now(), "short")#</td>
					</tr>
				</table>
			</cfdocumentitem>	
		</cfdocument>
	</cfoutput>
	<cfset Session.ReportLocation = #Variables.ReportExportLoc#>
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
</cfif>