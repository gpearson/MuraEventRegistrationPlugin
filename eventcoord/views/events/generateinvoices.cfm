<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-heading"><h2>Invoice(s) For: #Session.getSelectedEvent.ShortTitle#</h2></div>
		<cfform action="" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<div class="panel-body">
				<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
				<cfset ReportDirectory = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")# >
				<cfset ReportExportLoc = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")# & #URL.EventID# & "InvoicesForEvent.pdf" >
				<jr:jasperreport jrxml="#ReportDirectory#/EventInvoice.jrxml" query="#Session.GetSelectedEventRegistrations#" exportfile="#ReportExportLoc#" exportType="pdf" />
				<embed src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/#URL.EventID#InvoicesForEvent.pdf" width="100%" height="650">
			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Send Electronic Invoices for Event"><br /><br />
			</div>
		</cfform>
	</div>
</cfoutput>