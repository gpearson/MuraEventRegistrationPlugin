<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
Line 42: Change to the Plugin Name for the cfimport line
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-body">
			<fieldset>
				<legend><h2>Event Signin Sheet: #Session.getSelectedEvent.ShortTitle#</h2></legend>
			</fieldset>
			<div class="alert alert-info">Below is the PDF Document with Registered Participants who have signed up for this event</div>
			<cfif ListLen(Session.SignInSheet.EventDates) GTE 2 and not isDefined("URL.EventDatePOS")>
				<table class="table" width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<cfif ListLen(Session.SignInSheet.EventDates) GTE 1><td><A Href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td></cfif>
						<cfif ListLen(Session.SignInSheet.EventDates) GTE 2><td><A Href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td></cfif>
						<cfif ListLen(Session.SignInSheet.EventDates) GTE 3><td><A Href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td></cfif>
						<cfif ListLen(Session.SignInSheet.EventDates) GTE 4><td><A Href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=4">SignIn Sheet Day 4</a></td></cfif>
						<cfif ListLen(Session.SignInSheet.EventDates) GTE 5><td><A Href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=5">SignIn Sheet Day 5</a></td></cfif>
					</tr>
					<tr>
						<td colspan="5"></td>
					</tr>
				</table>
			<cfelse>
				<cfif not isDefined("URL.EventDatePOS")>
					<cfset getParticipants = #StructCopy(Session.getRegisteredParticipants)#>
					<cfset StructClear(getParticipants)>
					<cfloop query="Session.getRegisteredParticipants">
						<cfset temp = QueryAddRow(getParticipants)>
						<cfset temp = QuerySetCell(getParticipants, "Fname", Session.getRegisteredparticipants.Fname)>
						<cfset temp = QuerySetCell(getParticipants, "Lname", Session.getRegisteredparticipants.Lname)>
						<cfset temp = QuerySetCell(getParticipants, "Email", Session.getRegisteredparticipants.Email)>
							<cfset temp = QuerySetCell(getParticipants, "Domain", Session.getRegisteredparticipants.Domain)>
						<cfset temp = QuerySetCell(getParticipants, "ShortTitle", Session.getRegisteredparticipants.ShortTitle)>
						<cfset temp = QuerySetCell(getParticipants, "EventDateFormat", Session.getRegisteredparticipants.EventDateFormat)>
						<cfif Session.getRegisteredParticipants.RequestsMeal EQ 1><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "No")></cfif>
						<cfif Session.getRegisteredParticipants.IVCParticipant EQ 1><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "No")></cfif>
						<cfset temp = QuerySetCell(getParticipants, "RegisterForEventDate1", Session.getRegisteredparticipants.RegisterForEventDate1)>
						<cfset temp = QuerySetCell(getParticipants, "RegisterForEventDate2", Session.getRegisteredparticipants.RegisterForEventDate2)>
						<cfset temp = QuerySetCell(getParticipants, "RegisterForEventDate3", Session.getRegisteredparticipants.RegisterForEventDate3)>
						<cfset temp = QuerySetCell(getParticipants, "RegisterForEventDate4", Session.getRegisteredparticipants.RegisterForEventDate4)>
						<cfset temp = QuerySetCell(getParticipants, "RegisterForEventDate5", Session.getRegisteredparticipants.RegisterForEventDate5)>
						<cfset temp = QuerySetCell(getParticipants, "RegisterForEventDate6", Session.getRegisteredparticipants.RegisterForEventDate6)>
						<cfset temp = QuerySetCell(getParticipants, "RegisterForEventSessionAM", Session.getRegisteredparticipants.RegisterForEventSessionAM)>
						<cfset temp = QuerySetCell(getParticipants, "RegisterForEventSessionPM", Session.getRegisteredparticipants.RegisterForEventSessionPM)>
					</cfloop>

					<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
					<cfset LogoPath = ArrayNew(1)>
					<cfloop from="1" to="#getParticipants.RecordCount#" step="1" index="i">
						<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_Logo.png")#>
					</cfloop>
					<cfset temp = QueryAddColumn(getParticipants, "NIESCLogoPath", "VarChar", Variables.LogoPath)>
					<cfset ReportDirectory = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")# >
					<cfset ReportExportLoc = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")# & #URL.EventID# & "EventSignInSheet.pdf" >
					<jr:jasperreport jrxml="#ReportDirectory#/EventSignInSheet.jrxml" query="#getParticipants#" exportfile="#ReportExportLoc#" exportType="pdf" />
					<embed src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/#URL.EventID#EventSignInSheet.pdf" width="100%" height="650">
				<cfelseif isDefined("URL.EventDatePOS")>
					<cfswitch expression="#URL.EventDatePOS#">
						<cfcase value="1">
							<cfset getParticipants = #StructCopy(Session.getRegisteredParticipants)#>
							<cfset StructClear(getParticipants)>
							<cfloop query="Session.getRegisteredParticipants">
								<cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1>
									<cfset temp = QueryAddRow(getParticipants)>
									<cfset temp = QuerySetCell(getParticipants, "Fname", Session.getRegisteredparticipants.Fname)>
									<cfset temp = QuerySetCell(getParticipants, "Lname", Session.getRegisteredparticipants.Lname)>
									<cfset temp = QuerySetCell(getParticipants, "Email", Session.getRegisteredparticipants.Email)>
									<cfset temp = QuerySetCell(getParticipants, "Domain", Session.getRegisteredparticipants.Domain)>
									<cfset temp = QuerySetCell(getParticipants, "ShortTitle", Session.getRegisteredparticipants.ShortTitle)>
									<cfset temp = QuerySetCell(getParticipants, "EventDateFormat", DateFormat(ListGetAt(Session.SignInSheet.EventDates, 1), 'ddd, mmmm dd, yyyy'))>
									<cfif Session.getRegisteredParticipants.RequestsMeal EQ 1><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "No")></cfif>
									<cfif Session.getRegisteredParticipants.IVCParticipant EQ 1><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "No")></cfif>
								</cfif>
							</cfloop>
						</cfcase>
						<cfcase value="2">
							<cfset getParticipants = #StructCopy(Session.getRegisteredParticipants)#>
							<cfset StructClear(getParticipants)>
							<cfloop query="Session.getRegisteredParticipants">
								<cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1>
									<cfset temp = QueryAddRow(getParticipants)>
									<cfset temp = QuerySetCell(getParticipants, "Fname", Session.getRegisteredparticipants.Fname)>
									<cfset temp = QuerySetCell(getParticipants, "Lname", Session.getRegisteredparticipants.Lname)>
									<cfset temp = QuerySetCell(getParticipants, "Email", Session.getRegisteredparticipants.Email)>
									<cfset temp = QuerySetCell(getParticipants, "Domain", Session.getRegisteredparticipants.Domain)>
									<cfset temp = QuerySetCell(getParticipants, "ShortTitle", Session.getRegisteredparticipants.ShortTitle)>
									<cfset temp = QuerySetCell(getParticipants, "EventDateFormat", DateFormat(ListGetAt(Session.SignInSheet.EventDates, 2), 'ddd, mmmm dd, yyyy'))>
									<cfif Session.getRegisteredParticipants.RequestsMeal EQ 1><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "No")></cfif>
									<cfif Session.getRegisteredParticipants.IVCParticipant EQ 1><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "No")></cfif>
								</cfif>
							</cfloop>
						</cfcase>
						<cfcase value="3">
							<cfset getParticipants = #StructCopy(Session.getRegisteredParticipants)#>
							<cfset StructClear(getParticipants)>
							<cfloop query="Session.getRegisteredParticipants">
								<cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1>
									<cfset temp = QueryAddRow(getParticipants)>
									<cfset temp = QuerySetCell(getParticipants, "Fname", Session.getRegisteredparticipants.Fname)>
									<cfset temp = QuerySetCell(getParticipants, "Lname", Session.getRegisteredparticipants.Lname)>
									<cfset temp = QuerySetCell(getParticipants, "Email", Session.getRegisteredparticipants.Email)>
									<cfset temp = QuerySetCell(getParticipants, "Domain", Session.getRegisteredparticipants.Domain)>
									<cfset temp = QuerySetCell(getParticipants, "ShortTitle", Session.getRegisteredparticipants.ShortTitle)>
									<cfset temp = QuerySetCell(getParticipants, "EventDateFormat", DateFormat(ListGetAt(Session.SignInSheet.EventDates, 3), 'ddd, mmmm dd, yyyy'))>
									<cfif Session.getRegisteredParticipants.RequestsMeal EQ 1><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "No")></cfif>
									<cfif Session.getRegisteredParticipants.IVCParticipant EQ 1><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "No")></cfif>
								</cfif>
							</cfloop>
						</cfcase>
						<cfcase value="4">
							<cfset getParticipants = #StructCopy(Session.getRegisteredParticipants)#>
							<cfset StructClear(getParticipants)>
							<cfloop query="Session.getRegisteredParticipants">
								<cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1>
									<cfset temp = QueryAddRow(getParticipants)>
									<cfset temp = QuerySetCell(getParticipants, "Fname", Session.getRegisteredparticipants.Fname)>
									<cfset temp = QuerySetCell(getParticipants, "Lname", Session.getRegisteredparticipants.Lname)>
									<cfset temp = QuerySetCell(getParticipants, "Email", Session.getRegisteredparticipants.Email)>
									<cfset temp = QuerySetCell(getParticipants, "Domain", Session.getRegisteredparticipants.Domain)>
									<cfset temp = QuerySetCell(getParticipants, "ShortTitle", Session.getRegisteredparticipants.ShortTitle)>
									<cfset temp = QuerySetCell(getParticipants, "EventDateFormat", DateFormat(ListGetAt(Session.SignInSheet.EventDates, 4), 'ddd, mmmm dd, yyyy'))>
									<cfif Session.getRegisteredParticipants.RequestsMeal EQ 1><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "No")></cfif>
									<cfif Session.getRegisteredParticipants.IVCParticipant EQ 1><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "No")></cfif>
								</cfif>
							</cfloop>
						</cfcase>
						<cfcase value="5">
							<cfset getParticipants = #StructCopy(Session.getRegisteredParticipants)#>
							<cfset StructClear(getParticipants)>
							<cfloop query="Session.getRegisteredParticipants">
								<cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1>
									<cfset temp = QueryAddRow(getParticipants)>
									<cfset temp = QuerySetCell(getParticipants, "Fname", Session.getRegisteredparticipants.Fname)>
									<cfset temp = QuerySetCell(getParticipants, "Lname", Session.getRegisteredparticipants.Lname)>
									<cfset temp = QuerySetCell(getParticipants, "Email", Session.getRegisteredparticipants.Email)>
									<cfset temp = QuerySetCell(getParticipants, "Domain", Session.getRegisteredparticipants.Domain)>
									<cfset temp = QuerySetCell(getParticipants, "ShortTitle", Session.getRegisteredparticipants.ShortTitle)>
									<cfset temp = QuerySetCell(getParticipants, "EventDateFormat", DateFormat(ListGetAt(Session.SignInSheet.EventDates, 5), 'ddd, mmmm dd, yyyy'))>
									<cfif Session.getRegisteredParticipants.RequestsMeal EQ 1><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "No")></cfif>
									<cfif Session.getRegisteredParticipants.IVCParticipant EQ 1><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "No")></cfif>
								</cfif>
							</cfloop>
						</cfcase>
					</cfswitch>
					<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
					<cfset LogoPath = ArrayNew(1)>
					<cfloop from="1" to="#getParticipants.RecordCount#" step="1" index="i">
						<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_Logo.png")#>
					</cfloop>
					<cfset temp = QueryAddColumn(getParticipants, "NIESCLogoPath", "VarChar", Variables.LogoPath)>
					<cfset ReportDirectory = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")# >
					<cfset ReportExportLoc = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")# & #URL.EventID# & "EventSignInSheet.pdf" >
					<jr:jasperreport jrxml="#ReportDirectory#/EventSignInSheet.jrxml" query="#getParticipants#" exportfile="#ReportExportLoc#" exportType="pdf" />
					<embed src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/#URL.EventID#EventSignInSheet.pdf" width="100%" height="650">
				</cfif>
			</cfif>
		</div>
		<cfif isDefined("URL.EventDatePOS")>
			<div class="panel-footer">
				<a href="#buildurl('eventcoord:events.default')#" class="btn btn-primary pull-left">Back to Event Listing</a>
				<a href="#buildurl('eventcoord:events.eventsigninsheet&EventID=#URL.EventID#')#" class="btn btn-primary pull-right">View Another Day's SignIn Sheet</a><br /><br />
			</div>
		<cfelse>
			<div class="panel-footer">
				<a href="#buildurl('eventcoord:events.default')#" class="btn btn-primary pull-left">Back to Event Listing</a><br /><br />
			</div>
		</cfif>
	</div>
</cfoutput>
<!---

<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
</cflock>

<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4
	From p_EventRegistration_Events
	Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
		TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
</cfquery>



<cfoutput>
	<div class="art-blockheader">
		<h3 class="t">Event Signin Document</h3>
	</div>
	<div class="alert-box notice">Below is the sign in sheet for the selected report. Click <A href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=eventcoord:events.default" class="art-button">here</a> to return to the listing of available events.</div>
	<hr>
	<cfif ListLen(Variables.EventDates) GTE 2 and not isDefined("URL.EventDatePOS")>
		<Table style="border-width: 3px; border-spacing: 1px; border-style: outset; border-color: gray; border-collapse: separate; background-color: ##EDEDED;" Align="Center" Width="100%">
			<tr>
				<cfif ListLen(Variables.EventDates) GTE 1><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 2><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 3><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 4><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=4">SignIn Sheet Day 4</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 5><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=5">SignIn Sheet Day 5</a></td></cfif>
			</tr>
			<tr>
				<td Style="border-width: thin; padding: 0px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Bold;" colspan="5"></td>
			</tr>
		</Table>
	<cfelse>
		<cfquery name="getRegisteredParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			SELECT eRegistrations.RequestsMeal, eRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat
			FROM eRegistrations INNER JOIN tusers ON tusers.UserID = eRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = eRegistrations.EventID
			WHERE eRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
				eRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
		</cfquery>
		<cfset getParticipants = #StructCopy(getRegisteredParticipants)#>
		<cfset StructClear(getParticipants)>
		<cfloop query="getRegisteredParticipants">
			<cfset temp = QueryAddRow(getParticipants)>
			<cfset temp = QuerySetCell(getParticipants, "Fname", getRegisteredparticipants.Fname)>
			<cfset temp = QuerySetCell(getParticipants, "Lname", getRegisteredparticipants.Lname)>
			<cfset temp = QuerySetCell(getParticipants, "Email", getRegisteredparticipants.Email)>
			<cfset temp = QuerySetCell(getParticipants, "Domain", getRegisteredparticipants.Domain)>
			<cfset temp = QuerySetCell(getParticipants, "ShortTitle", getRegisteredparticipants.ShortTitle)>
			<cfset temp = QuerySetCell(getParticipants, "EventDateFormat", getRegisteredparticipants.EventDateFormat)>
			<cfif getRegisteredParticipants.RequestsMeal EQ 1>
				<cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "Yes")>
			<cfelse>
				<cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "No")>
			</cfif>

			<cfif getRegisteredParticipants.IVCParticipant EQ 1>
				<cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "Yes")>
			<cfelse>
				<cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "No")>
			</cfif>
		</cfloop>

<!--- 877-395-5535 --->
		<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
		<cfset LogoPath = ArrayNew(1)>
		<cfloop from="1" to="#getRegisteredParticipants.RecordCount#" step="1" index="i">
			<cfset LogoPath[i] = #ExpandPath("/plugins/EventRegistration/library/images/NIESC_Logo.png")#>
		</cfloop>
		<cfset temp = QueryAddColumn(getParticipants, "NIESCLogoPath", "VarChar", Variables.LogoPath)>
		<cfset ReportDirectory = #ExpandPath("/plugins/EventRegistration/library/reports/")# >
		<cfset ReportExportLoc = #ExpandPath("/plugins/EventRegistration/library/ReportExports/")# & #URL.EventID# & "EventSignInSheet.pdf" >
		<jr:jasperreport jrxml="#ReportDirectory#/EventSignInSheet.jrxml" query="#getParticipants#" exportfile="#ReportExportLoc#" exportType="pdf" />
		<!---
			<cf_jasperreport jrxml="#ReportDirectory#/EventSignInSheet.jrxml" filename="#ReportExportLoc#" exporttype="pdf" query="#getRegisteredParticipants#" />
		--->
		<embed src="/plugins/EventRegistration/library/ReportExports/#URL.EventID#EventSignInSheet.pdf" width="850" height="650">
	</cfif>
</cfoutput>

--->