<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>

<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
</cflock>

<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4
	From eEvents
	Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
		TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfset EventDateQuery = #QueryNew("EventDate")#>
<cfif LEN(getSelectedEvent.EventDate) and LEN(getSelectedEvent.EventDate1) EQ 0 and LEN(getSelectedEvent.EventDate2) EQ 0 and LEN(getSelectedEvent.EventDate3) EQ 0 and LEN(getSelectedEvent.EventDate4) EQ 0>
	<cfset temp = #QueryAddRow(EventDateQuery, 1)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate)#>
<cfelseif LEN(getSelectedEvent.EventDate) and LEN(getSelectedEvent.EventDate1) and LEN(getSelectedEvent.EventDate2) EQ 0 and LEN(getSelectedEvent.EventDate3) EQ 0 and LEN(getSelectedEvent.EventDate4) EQ 0>
	<cfset temp = #QueryAddRow(EventDateQuery, 2)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate, 1)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate1, 2)#>
<cfelseif LEN(getSelectedEvent.EventDate) and LEN(getSelectedEvent.EventDate1) and LEN(getSelectedEvent.EventDate2) and LEN(getSelectedEvent.EventDate3) EQ 0 and LEN(getSelectedEvent.EventDate4) EQ 0>
	<cfset temp = #QueryAddRow(EventDateQuery, 3)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate, 1)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate1, 2)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate2, 3)#>
<cfelseif LEN(getSelectedEvent.EventDate) and LEN(getSelectedEvent.EventDate1) and LEN(getSelectedEvent.EventDate2) and LEN(getSelectedEvent.EventDate3) and LEN(getSelectedEvent.EventDate4) EQ 0>
	<cfset temp = #QueryAddRow(EventDateQuery, 4)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate, 1)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate1, 2)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate2, 3)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate3, 4)#>
<cfelseif LEN(getSelectedEvent.EventDate) and LEN(getSelectedEvent.EventDate1) and LEN(getSelectedEvent.EventDate2) and LEN(getSelectedEvent.EventDate3) and LEN(getSelectedEvent.EventDate4)>
	<cfset temp = #QueryAddRow(EventDateQuery, 5)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate, 1)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate1, 2)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate2, 3)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate3, 4)#>
	<cfset temp = #QuerySetCell(EventDateQuery, "EventDate", getSelectedEvent.EventDate4, 5)#>
</cfif>
<cfset EventDates = ValueList(EventDateQuery.EventDate, ",")>

<cfoutput>
	<div class="art-blockheader">
		<h3 class="t">Event Signin Document</h3>
	</div>
	<div class="alert-box notice">Below is the sign in sheet for the selected report. Click <A href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:events.default" class="art-button">here</a> to return to the listing of available events.</div>
	<hr>
	<cfif ListLen(Variables.EventDates) GTE 2 and not isDefined("URL.EventDatePOS")>
		<Table style="border-width: 3px; border-spacing: 1px; border-style: outset; border-color: gray; border-collapse: separate; background-color: ##EDEDED;" Align="Center" Width="100%">
			<tr>
				<cfif ListLen(Variables.EventDates) GTE 1><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('admin:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 2><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('admin:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 3><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('admin:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 4><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('admin:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=4">SignIn Sheet Day 4</a></td></cfif>
				<cfif ListLen(Variables.EventDates) GTE 5><td Style="border-width: 0px; padding: 1px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Normal;"><A Href="#buildURL('admin:events.eventsigninsheet')#&EventID=#URL.EventID#&EventDatePos=5">SignIn Sheet Day 5</a></td></cfif>
			</tr>
			<tr>
				<td Style="border-width: thin; padding: 0px; border-style: inset; border-color: gray; background-color: ##EDEDED; -moz-border-radius: ; Font-Family: Arial; Font-Size: 14px; Font-Weight: Bold;" colspan="5"></td>
			</tr>
		</Table>
	<cfelse>
		<cfquery name="getRegisteredParticipants" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			SELECT eRegistrations.RequestsMeal, eRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, eEvents.ShortTitle, Date_FORMAT(eEvents.EventDate, "%a, %M %d, %Y") as EventDateFormat
			FROM eRegistrations INNER JOIN tusers ON tusers.UserID = eRegistrations.User_ID INNER JOIN eEvents ON eEvents.TContent_ID = eRegistrations.EventID
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