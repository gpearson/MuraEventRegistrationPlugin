<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
Line 42: Change to the Plugin Name for the cfimport line
</cfsilent>
<cfset PaperTemplateQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(PaperTemplateQuery, 1)>
<cfset temp = #QuerySetCell(PaperTemplateQuery, "ID", 5395)#>
<cfset temp = #QuerySetCell(PaperTemplateQuery, "OptionName", "Avery 5395")#>
<cfoutput>
	<div class="panel panel-default">
		<cfif not isDefined("Session.FormInput.StepOne.PaperTemplate")>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal" enctype="multipart/form-data">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Event Name Badges: #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PaperTemplate" class="control-label col-sm-3">Paper Template Number:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="PaperTemplate" class="form-control" Required="Yes" Multiple="No" query="PaperTemplateQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Select Paper Template to Print Name Badges on?</option>
							</cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Display Name Badges"><br /><br />
				</div>
			</cfform>
		<cfelseif isDefined("Session.FormInput.StepOne.PaperTemplate")>
			<div class="panel-body">
				<fieldset>
						<legend><h2>Event Name Badges: #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
			<div class="alert alert-info">Below is the PDF Document with Registered Participants who have signed up for this event</div>
			<cfif ListLen(Session.SignInSheet.EventDates) GTE 2 and not isDefined("URL.EventDatePOS")>
				<table class="table" width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<cfif ListLen(Session.SignInSheet.EventDates) GTE 1><td><A Href="#buildURL('eventcoord:events.namebadges')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td></cfif>
						<cfif ListLen(Session.SignInSheet.EventDates) GTE 2><td><A Href="#buildURL('eventcoord:events.namebadges')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td></cfif>
						<cfif ListLen(Session.SignInSheet.EventDates) GTE 3><td><A Href="#buildURL('eventcoord:events.namebadges')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td></cfif>
						<cfif ListLen(Session.SignInSheet.EventDates) GTE 4><td><A Href="#buildURL('eventcoord:events.namebadges')#&EventID=#URL.EventID#&EventDatePos=4">SignIn Sheet Day 4</a></td></cfif>
						<cfif ListLen(Session.SignInSheet.EventDates) GTE 5><td><A Href="#buildURL('eventcoord:events.namebadges')#&EventID=#URL.EventID#&EventDatePos=5">SignIn Sheet Day 5</a></td></cfif>
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
						<cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1>
							<cfset temp = QueryAddRow(getParticipants)>
							<cfset temp = QuerySetCell(getParticipants, "Fname", Session.getRegisteredparticipants.Fname)>
							<cfset temp = QuerySetCell(getParticipants, "Lname", Session.getRegisteredparticipants.Lname)>
							<cfset temp = QuerySetCell(getParticipants, "Email", Session.getRegisteredparticipants.Email)>
							<cfset temp = QuerySetCell(getParticipants, "Domain", Session.getRegisteredparticipants.Domain)>
							<cfset temp = QuerySetCell(getParticipants, "ShortTitle", Session.getRegisteredparticipants.ShortTitle)>
							<cfset temp = QuerySetCell(getParticipants, "EventDateFormat", Session.getRegisteredparticipants.EventDateFormat)>
							<cfif Session.getRegisteredParticipants.RequestsMeal EQ 1><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "RequestsMeal", "No")></cfif>
							<cfif Session.getRegisteredParticipants.IVCParticipant EQ 1><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "Yes")><cfelse><cfset temp = QuerySetCell(getParticipants, "IVCParticipant", "No")></cfif>
						</cfif>
					</cfloop>
					<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
					<cfset LogoPath = ArrayNew(1)>
					<cfloop from="1" to="#getParticipants.RecordCount#" step="1" index="i">
						<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_Logo_Transparent.png")#>
					</cfloop>
					<cfset temp = QueryAddColumn(getParticipants, "NIESCLogoPath", "VarChar", Variables.LogoPath)>
					<cfset ReportDirectory = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")# >
					<cfset ReportExportLoc = #ExpandPath("/plugins/EventRegistration/library/ReportExports/")# & #URL.EventID# & "EventNameBadges.pdf" >
					<jr:jasperreport jrxml="#ReportDirectory#EventNameBadges_5395.jrxml" query="#getParticipants#" exportfile="#ReportExportLoc#" exportType="pdf" />
					<embed src="/plugins/EventRegistration/library/ReportExports/#URL.EventID#EventNameBadges.pdf" width="100%" height="650">
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
						<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_Logo_Transparent.png")#>
					</cfloop>
					<cfset temp = QueryAddColumn(getParticipants, "NIESCLogoPath", "VarChar", Variables.LogoPath)>
					<cfset ReportDirectory = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")# >
					<cfset ReportExportLoc = #ExpandPath("/plugins/EventRegistration/library/ReportExports/")# & #URL.EventID# & "EventNameBadges.pdf" >
					<jr:jasperreport jrxml="#ReportDirectory#EventNameBadges_5395.jrxml" query="#getParticipants#" exportfile="#ReportExportLoc#" exportType="pdf" />
					<embed src="/plugins/EventRegistration/library/ReportExports/#URL.EventID#EventNameBadges.pdf" width="100%" height="650">
				</cfif>
				</div>
				<cfif isDefined("URL.EventDatePOS")>
					<div class="panel-footer">
						<a href="#buildurl('eventcoord:events.default')#" class="btn btn-primary pull-left">Back to Event Listing</a>
						<a href="#buildurl('eventcoord:events.namebadges&EventID=#URL.EventID#')#" class="btn btn-primary pull-right">View Another Day's SignIn Sheet</a><br /><br />
					</div>
				<cfelse>
					<div class="panel-footer">
						<a href="#buildurl('eventcoord:events.default')#" class="btn btn-primary pull-left">Back to Event Listing</a><br /><br />
					</div>
				</cfif>
			</cfif>
		</cfif>
	</div>
</cfoutput>