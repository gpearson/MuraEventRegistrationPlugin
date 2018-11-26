<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->

</cfsilent>
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "To Yourself")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Internal Mailing Lists")#>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Email Marketing of Upcoming Events</h2></legend>
					</fieldset>
					<cfif Session.EmailMarketing.QueryResults.RecordCount>
						<div class="alert alert-info">Please complete the following information to market upcoming events to indivduals and/or mailing lists.<br>Currently #Session.EmailMarketing.QueryResults.RecordCount# event(s) are eligible for participants to register for.</div>
						<div class="form-group">
							<label for="WhoToSendTo" class="control-label col-sm-3">Send Event Marketing To:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-sm-8">
								<cfselect name="WhoToSendTo" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
									<option value="----">Who To Send To?</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<div class="col-sm-12">
								<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
								<jr:jasperreport jrxml="#Session.EmailMarketing.MasterTemplate#" query="#Session.EmailMarketing.QueryResults#" exportfile="#Session.EmailMarketing.CompletedFile#" exportType="pdf" />
								<embed src="#Session.EmailMarketing.WebExportCompletedFile#" width="100%" height="650">
							</div>
						</div>
						<div class="panel-footer">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Send Email"><br /><br />
						</div>
					<cfelse>
						<div class="alert alert-info">No Events are available in the Database to generate this report on upcoming events.</div>
					</cfif>
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif ArrayLen(Session.FormErrors) GTE 1>
					<br /><br />
					<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Email Marketing of Upcoming Events</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to market upcoming events to indivduals and/or mailing lists.<br>Currently #Session.EmailMarketing.QueryResults.RecordCount# event(s) are eligible for participants to register for.</div>
					<div class="form-group">
						<label for="WhoToSendTo" class="control-label col-sm-3">Send Event Marketing To:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8">
							<cfselect name="WhoToSendTo" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Who To Send To?</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<div class="col-sm-12">
							<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
							<cfset LogoPath = ArrayNew(1)>
							<cfloop from="1" to="#Session.EmailMarketing.QueryResults.RecordCount#" step="1" index="i">
								<cfset LogoPath[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/NIESC_Logo.png")#>
								<cfset ButtonMoreInfo[i] = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/images/MoreInfoButton_SM.png")#>
							</cfloop>
							<cfset temp = QueryAddColumn(Session.EmailMarketing.QueryResults, "NIESCLogoPath", "VarChar", Variables.LogoPath)>
							<cfset temp = QueryAddColumn(Session.EmailMarketing.QueryResults, "EventDateFormat")>
							<cfset temp = QueryAddColumn(Session.EmailMarketing.QueryResults, "MoreInfoImage", "VarChar", Variables.ButtonMoreInfo)>
							<cfset temp = QueryAddColumn(Session.EmailMarketing.QueryResults, "LinkURL")>
							<cfloop query="#Session.EmailMarketing.QueryResults#">
								<cfset temp = QuerySetCell(Session.EmailMarketing.QueryResults, "EventDateFormat", DateFormat(Session.EmailMarketing.QueryResults.EventDate, "ddd, mmm dd, yyyy"), Session.EmailMarketing.QueryResults.CurrentRow)>
								<cfset BaseURL = "http://" & #CGI.Server_Name# & #CGI.Script_name# & #CGI.path_info# & "?" & #HTMLEditFormat(rc.pc.getPackage())# & "action=public:main.eventinfo&EventID=" & #Session.EmailMarketing.QueryResults.TContent_ID#>
								<cfset temp = QuerySetCell(Session.EmailMarketing.QueryResults, "LinkURL", Variables.BaseURL, Session.EmailMarketing.QueryResults.CurrentRow)>
							</cfloop>
							<jr:jasperreport jrxml="#Session.EmailMarketing.MasterTemplate#" query="#Session.EmailMarketing.QueryResults#" exportfile="#Session.EmailMarketing.CompletedFile#" exportType="pdf" />
							<embed src="#Session.EmailMarketing.WebExportCompletedFile#" width="100%" height="650">
						</div>
					</div>
					<div class="panel-footer">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Send Email"><br /><br />
					</div>
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>