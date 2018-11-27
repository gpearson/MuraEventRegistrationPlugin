<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
</cfsilent>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="EventDocumentsForm" class="form-horizontal" enctype="multipart/form-data">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Event Documents for: #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>

					<br>
					<fieldset>
						<legend><h2>Existing Event Document(s)</h2></legend>
					</fieldset>
					<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
						<thead class="thead-default">
							<tr>
								<th width="50%">Document Name</th>
								<th  width="25%">Size</th>
								<th width="25%">Actions</th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="#Session.getSelectedEventDocuments#">
								<tr>
									<td>#Session.getSelectedEventDocuments.ResourceDocument#</td>
									<cfset FileMBSize = NumberFormat(((#Session.getSelectedEventDocuments.ResourceDocumentSize# / 1024) / 1024), "99.99999") />
									<td>#Variables.FileMBSize# MB</td>
									<td><a href="#Session.WebEventDocuments##Session.GetSelectedEventDocuments.ResourceDocument#" class="btn btn-primary btn-small" target="_blank">View</a><a href="#buildURL('eventcoordinator:events.eventdocs')#&EventID=#URL.EventID#&UserAction=DeleteEventDocument&DocumentID=#Session.GetSelectedEventDocuments.TContent_ID#" class="btn btn-primary btn-small">Delete</a></td>
								</tr>
							</cfloop>
						</tbody>
					</table>
					<br>
					<fieldset>
						<legend><h2>Upload new Event Document(s)</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDocument" class="col-lg-5 col-md-5">Event Document:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="file" class="form-control" id="EventDocument" name="EventDocument" required="no"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back To Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Upload Event Document"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>