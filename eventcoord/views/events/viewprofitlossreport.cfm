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
		<div class="panel-body">
			<embed src="#Session.PLReport.URLReportExportLoc#" width="100%" height="650">
		</div>
		<div class="panel-footer">
			<a href="#buildURL('eventcoord:events.default')#" class="btn btn-primary pull-left">Back to Event Listing</a>
			<cfif Session.PLReport.GetSelectedEventRegistrations.RecordCount and Session.PLReport.EventInvoicesGenerated EQ 0><a href="#buildURL('eventcoord:events.generateinvoices')#&EventID=#URL.EventID#" class="btn btn-primary  pull-right">Generate Invoices</a></cfif><br /><br />
		</div>
	</div>
</cfoutput>