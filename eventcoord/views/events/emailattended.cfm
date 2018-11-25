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
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
<cfoutput>
	<script type="text/javascript" src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/js/field-wordcounter.js"></script>
	<div class="panel panel-default">
		<div class="panel-heading"><h2>Send Attended Participants Email: #Session.getSelectedEvent.ShortTitle#</h2><br><p>Number of Attended Participants: #Session.EventNumberRegistrations#</p></div>
		<cfform action="" method="post" id="AddEvent" class="form-horizontal" enctype="multipart/form-data">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="EventID" value="#URL.EventID#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfif not isDefined("URL.FormRetry")>
				<div class="panel-body">
					<div class="panel-heading"><h1>Message to Participants</h1></div>
					<div class="form-group">
						<label for="MsgToparticipants" class="control-label col-sm-3">Message to Attended Participants:&nbsp;</label>
						<div class="col-sm-8">
							<textarea height="15" width="250" class="form-control" id="EmailMsg" name="EmailMsg"></textarea><br>
							<script type="text/javascript">
								$("textarea").textareaCounter({limit: 250});
							</script>
						</div>
					</div>
					<div class="panel-heading"><h1>Event Website Resource Links</h1></div>
					<div class="form-group">
						<label for="FirstWebLink" class="control-label col-sm-3">First Website Link (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FirstWebLink" name="FirstWebLink" required="no"></div>
					</div>
					<div class="form-group">
						<label for="SecondWebLink" class="control-label col-sm-3">Second Website Link (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="SecondWebLink" name="SecondWebLink" required="no"></div>
					</div>
					<div class="form-group">
						<label for="ThirdWebLink" class="control-label col-sm-3">Third Website Link (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ThirdWebLink" name="ThirdWebLink" required="no"></div>
					</div>
					<cfif Session.EventDocuments.RecordCount>
						<div class="panel-heading"><h1>Previous Event Document Resources</h1></div>
						<div class="form-group">
							<label for="FirstDocument" class="control-label col-sm-3">Previous Documents (if Any):&nbsp;</label>
							<div class="col-sm-8">
								<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
									<thead class="thead-default">
										<tr>
											<th width="50%">Document Name</th>
											<th  width="25%">Size</th>
											<th width="25%">Actions</th>
										</tr>
									</thead>
									<tbody>
										<cfloop query="#Session.EventDocuments#">
											<tr>
												<td>#Session.EventDocuments.name#</td>
												<td>#Session.EventDocuments.size#</td>
												<td><a href="#Session.WebEventDirectory##Session.EventDocuments.name#" class="btn btn-primary btn-small" target="_blank">View</a><a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailattended&EventID=#URL.EventID#&UserAction=DeleteEventDocument&DocumentName=#HTMLEditFormat(Session.EventDocuments.name)#" class="btn btn-primary btn-small" target="_blank">Delete</a></td>
											</tr>
										</cfloop>
									</tbody>
								</table>
							</div>
						</div>
						<div class="form-group">
						<label for="IncludePreviousDocumentsInEmail" class="control-label col-sm-3">Include These Documents in Email:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="IncludePreviousDocumentsInEmail" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Include These Documents in Email?</option>
							</cfselect>
						</div>
					</div>
					</cfif>
					<div class="panel-heading"><h1>New Event Document Resources</h1></div>
					<div class="form-group">
						<label for="FirstDocument" class="control-label col-sm-3">First Document (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="file" class="form-control" id="FirstDocument" name="FirstDocument" required="no"></div>
					</div>
					<div class="form-group">
						<label for="SecondDocument" class="control-label col-sm-3">Second Document (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="file" class="form-control" id="SecondDocument" name="SecondDocument" required="no"></div>
					</div>
					<div class="form-group">
						<label for="ThirdDocument" class="control-label col-sm-3">Third Document (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="file" class="form-control" id="ThirdDocument" name="ThirdDocument" required="no"></div>
					</div>
					<div class="form-group">
						<label for="FourthDocument" class="control-label col-sm-3">Fourth Document (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="file" class="form-control" id="FourthDocument" name="FourthDocument" required="no"></div>
					</div>
					<div class="form-group">
						<label for="FifthDocument" class="control-label col-sm-3">Fifth Document (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="file" class="form-control" id="FifthDocument" name="FifthDocument" required="no"></div>
					</div>
					<div class="form-group">
						<label for="SendEmail" class="control-label col-sm-3">Send Email to Participants:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="SendEmail" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Send Email?</option>
							</cfselect>
						</div>
					</div>
				</div>
			<cfelseif isDefined("URL.FormRetry")>
				<cfif isDefined("Session.FormErrors")>
					<div class="panel-body">
						<cfif ArrayLen(Session.FormErrors) GTE 1>
							<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
						</cfif>
					</div>
				</cfif>
				<div class="panel-body">
					<div class="panel-heading"><h1>Message to Participants</h1></div>
					<div class="form-group">
						<label for="MsgToparticipants" class="control-label col-sm-3">Message to Registered Participants:&nbsp;</label>
						<div class="col-sm-8">
							<textarea height="15" width="250" class="form-control" id="EmailMsg" name="EmailMsg">#Session.FormInput.EmailMsg#</textarea><br>
							<script type="text/javascript">
								$("textarea").textareaCounter({limit: 250});
							</script>
						</div>
					</div>
					<div class="panel-heading"><h1>Event Website Resource Links</h1></div>
					<div class="form-group">
						<label for="FirstWebLink" class="control-label col-sm-3">First Website Link (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" value="#Session.FormInput.FirstWebLink#" id="FirstWebLink" name="FirstWebLink" required="no"></div>
					</div>
					<div class="form-group">
						<label for="SecondWebLink" class="control-label col-sm-3">Second Website Link (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" value="#Session.FormInput.SecondWebLink#" id="SecondWebLink" name="SecondWebLink" required="no"></div>
					</div>
					<div class="form-group">
						<label for="ThirdWebLink" class="control-label col-sm-3">Third Website Link (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" value="#Session.FormInput.ThirdWebLink#" id="ThirdWebLink" name="ThirdWebLink" required="no"></div>
					</div>
					<cfif Session.EventDocuments.RecordCount>
						<div class="panel-heading"><h1>Previous Event Document Resources</h1></div>
						<div class="form-group">
							<label for="FirstDocument" class="control-label col-sm-3">Previous Documents (if Any):&nbsp;</label>
							<div class="col-sm-8">
								<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
									<thead class="thead-default">
										<tr>
											<th width="50%">Document Name</th>
											<th  width="25%">Size</th>
											<th width="25%">Actions</th>
										</tr>
									</thead>
									<tbody>
										<cfloop query="#Session.EventDocuments#">
											<tr>
												<td>#Session.EventDocuments.name#</td>
												<td>#Session.EventDocuments.size#</td>
												<td><a href="#Session.WebEventDirectory##Session.EventDocuments.name#" class="btn btn-primary btn-small" target="_blank">View</a><a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.emailattended&EventID=#URL.EventID#&UserAction=DeleteEventDocument&DocumentName=#HTMLEditFormat(Session.EventDocuments.name)#" class="btn btn-primary btn-small" target="_blank">Delete</a></td>
											</tr>
										</cfloop>
									</tbody>
								</table>
							</div>
						</div>
						<div class="form-group">
						<label for="IncludePreviousDocumentsInEmail" class="control-label col-sm-3">Include These Documents in Email:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="IncludePreviousDocumentsInEmail" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Include These Documents in Email?</option>
							</cfselect>
						</div>
					</div>
					</cfif>
					<div class="panel-heading"><h1>New Event Document Resources</h1></div>
					<div class="form-group">
						<label for="FirstDocument" class="control-label col-sm-3">First Document (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="file" class="form-control" value="#Session.FormInput.FirstDocument#" id="FirstDocument" name="FirstDocument" required="no"></div>
					</div>
					<div class="form-group">
						<label for="SecondDocument" class="control-label col-sm-3">Second Document (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="file" class="form-control" value="#Session.FormInput.SecondDocument#" id="SecondDocument" name="SecondDocument" required="no"></div>
					</div>
					<div class="form-group">
						<label for="ThirdDocument" class="control-label col-sm-3">Third Document (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="file" class="form-control" value="#Session.FormInput.ThirdDocument#" id="ThirdDocument" name="ThirdDocument" required="no"></div>
					</div>
					<div class="form-group">
						<label for="FourthDocument" class="control-label col-sm-3">Fourth Document (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="file" class="form-control" value="#Session.FormInput.FourthDocument#" id="FourthDocument" name="FourthDocument" required="no"></div>
					</div>
					<div class="form-group">
						<label for="FifthDocument" class="control-label col-sm-3">Fifth Document (if Any):&nbsp;</label>
						<div class="col-sm-8"><cfinput type="file" class="form-control" value="#Session.FormInput.FifthDocument#" id="FifthDocument" name="FifthDocument" required="no"></div>
					</div>
					<div class="form-group">
						<label for="SendEmail" class="control-label col-sm-3">Send Email to Participants:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="SendEmail" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Send Email?</option>
							</cfselect>
						</div>
					</div>
				</div>
			</cfif>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Send Email Message"><br /><br />
				</div>
		</cfform>
	</div>
</cfoutput>