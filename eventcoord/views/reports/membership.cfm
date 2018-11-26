<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
<cfset ReportDirectory = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")# >
<cfset ReportExportLoc = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")# & "CorporationsByMembershipReport.pdf" >
<jr:jasperreport jrxml="#ReportDirectory#/CorporationMembership.jrxml" query="#Session.ReportQuery#" exportfile="#ReportExportLoc#" exportType="pdf" />
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-body">
			<fieldset>
				<legend><h2>Corporation by Membership Affiliation Report</h2></legend>
			</fieldset>
			<embed src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/CorporationsByMembershipReport.pdf" width="100%" height="650">
		</div>
		<div class="panel-footer">
			<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:main.default" class="btn btn-primary pull-left">Back to Main Menu</a><br /><br />
		</div>
	</div>
</cfoutput>
