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
		<cfform action="" method="post" id="AddEvent" class="form-horizontal" enctype="multipart/form-data">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="EventID" value="#URL.EventID#">
			<cfinput type="hidden" name="EmailType" value="#URL.EmailType#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfif not isDefined("URL.FormRetry")>
				<div class="panel-heading">
					<h2>Send <cfif URL.EmailType EQ "EmailRegistered">Registered<cfelseif URL.EmailType EQ "EmailAttended">Attended</cfif> Participants Email: #Session.getSelectedEvent.ShortTitle#</h2><br><p>Number of Registered Participants: #Session.EventNumberRegistrations#</p></h2>
				</div>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Message to Participants</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MsgToparticipants" class="control-label col-sm-3">Message to Registered Participants:&nbsp;</label>
						<div class="col-sm-8">
							<textarea height="15" width="250" class="form-control" id="EmailMsg" name="EmailMsg"></textarea><br>
							<script type="text/javascript">
								$("textarea").textareaCounter({limit: 250});
							</script>
						</div>
					</div>
					<cfif Session.GetSelectedEventLinks.RecordCount>
						<fieldset>
							<legend><h2>Event Website Resource Links</h2></legend>
						</fieldset>
						<div class="alert alert-info">Select the Event Website Resource Links from the list below that you would like to send to participants who are registered for this event.</div>
						<div class="form-group">
							<div class="col-sm-12">
								<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
									<thead class="thead-default">
										<tr>
											<th width="50%">Resource Link</th>
											<th width="25%">Include In Email</th>
											<th width="25%">Actions</th>
										</tr>
									</thead>
									<tbody>
										<cfloop query="#Session.GetSelectedEventLinks#">
											<tr>
												<td>#Session.GetSelectedEventLinks.ResourceLink#</td>
												<td><cfinput type="checkbox" name="IncludeWebLinkInEmail" class="form-control" value="#Session.GetSelectedEventLinks.TContent_ID#"></td>
												<td><a href="#Session.GetSelectedEventLinks.ResourceLink#" class="btn btn-primary btn-small" target="_blank">View</a></td>
											</tr>
										</cfloop>
									</tbody>
								</table>
							</div>
						</div>
					</cfif>
					<cfif Session.GetSelectedEventDocuments.RecordCount>
						<fieldset>
							<legend><h2>Event Website Documents</h2></legend>
						</fieldset>
						<div class="alert alert-info">Select the Event Website Documents from the list below that you would like to send to participants who are registered for this event.</div>
						<div class="form-group">
							<div class="col-sm-12">
								<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
									<thead class="thead-default">
										<tr>
											<th width="50%">Document Name</th>
											<th width="25%">Include In Email</th>
											<th width="25%">Actions</th>
										</tr>
									</thead>
									<tbody>
										<cfloop query="#Session.GetSelectedEventDocuments#">
											<tr>
												<td>#Session.GetSelectedEventDocuments.ResourceDocument#</td>
												<td><cfinput type="checkbox" name="IncludeDocumentLinkInEmail" class="form-control" value="#Session.GetSelectedEventDocuments.TContent_ID#"></td>
												<td><a href="#Session.WebEventDirectory##Session.GetSelectedEventDocuments.ResourceDocument#" class="btn btn-primary btn-small" target="_blank">View</a></td>
											</tr>
										</cfloop>
									</tbody>
								</table>
							</div>
						</div>
					</cfif>
				</div>
			<cfelseif isDefined("URL.FormRetry")>
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Missing Email Message to send to participants</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-danger">Please enter a message that you want to send to participants of this event.</p>
							</div>
							<div class="modal-footer">
								<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
							</div>
						</div>
					</div>
				</div>
				<script type='text/javascript'>
					(function() {
						'use strict';
						function remoteModal(idModal){
							var vm = this;
							vm.modal = $(idModal);
							if( vm.modal.length == 0 ) { return false; } else { openModal(); }
							if( window.location.hash == idModal ){ openModal(); }
							var services = { open: openModal, close: closeModal };
							return services;
							function openModal(){
								vm.modal.modal('show');
							}
							function closeModal(){
								vm.modal.modal('hide');
							}
						}
						Window.prototype.remoteModal = remoteModal;
					})();
					$(function(){
						window.remoteModal('##modelWindowDialog');
					});
				</script>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Send <cfif URL.EmailType EQ "EmailRegistered">Registered<cfelseif URL.EmailType EQ "EmailAttended">Attended</cfif> Participants Email: #Session.getSelectedEvent.ShortTitle#</h2><br><p>Number of Registered Participants: #Session.EventNumberRegistrations#</p></h2></legend>
					</fieldset>
					<br>
					<fieldset>
						<legend><h2>Message to Participants</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MsgToparticipants" class="control-label col-sm-3">Message to Registered Participants:&nbsp;</label>
						<div class="col-sm-8">
							<textarea height="15" width="250" class="form-control" id="EmailMsg" name="EmailMsg">#Session.FormData.EMailMsg#</textarea><br>
							<script type="text/javascript">
								$("textarea").textareaCounter({limit: 250});
							</script>
						</div>
					</div>
					<cfif Session.GetSelectedEventLinks.RecordCount>
						<fieldset>
							<legend><h2>Event Website Resource Links</h2></legend>
						</fieldset>
						<div class="alert alert-info">Select the Event Website Resource Links from the list below that you would like to send to participants who are registered for this event.</div>
						<div class="form-group">
							<div class="col-sm-12">
								<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
									<thead class="thead-default">
										<tr>
											<th width="50%">Resource Link</th>
											<th width="25%">Include In Email</th>
											<th width="25%">Actions</th>
										</tr>
									</thead>
									<tbody>
										<cfloop query="#Session.GetSelectedEventLinks#">
											<tr>
												<td>#Session.GetSelectedEventLinks.ResourceLink#</td>
												<td><cfif ListFind(Session.FormData.IncludeWebLinkInEmail, Session.GetSelectedEventLinks.TContent_ID, ",")>
													<cfinput type="checkbox" name="IncludeWebLinkInEmail" class="form-control" value="#Session.GetSelectedEventLinks.TContent_ID#" checked>
												<cfelse>
													<cfinput type="checkbox" name="IncludeWebLinkInEmail" class="form-control" value="#Session.GetSelectedEventLinks.TContent_ID#">
												</cfif>
												</td>
												<td><a href="#Session.GetSelectedEventLinks.ResourceLink#" class="btn btn-primary btn-small" target="_blank">View</a></td>
											</tr>
										</cfloop>
									</tbody>
								</table>
							</div>
						</div>
					</cfif>
					<cfif Session.GetSelectedEventDocuments.RecordCount>
						<fieldset>
							<legend><h2>Event Website Documents</h2></legend>
						</fieldset>
						<div class="alert alert-info">Select the Event Website Documents from the list below that you would like to send to participants who are registered for this event.</div>
						<div class="form-group">
							<div class="col-sm-12">
								<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
									<thead class="thead-default">
										<tr>
											<th width="50%">Document Name</th>
											<th width="25%">Include In Email</th>
											<th width="25%">Actions</th>
										</tr>
									</thead>
									<tbody>
										<cfloop query="#Session.GetSelectedEventDocuments#">
											<tr>
												<td>#Session.GetSelectedEventDocuments.ResourceDocument#</td>
												<td><cfif ListFind(Session.FormData.IncludeDocumentLinkInEmail, Session.GetSelectedEventDocuments.TContent_ID, ",")>
													<cfinput type="checkbox" name="IncludeDocumentLinkInEmail" class="form-control" value="#Session.GetSelectedEventDocuments.TContent_ID#" checked>
												<cfelse>
													<cfinput type="checkbox" name="IncludeDocumentLinkInEmail" class="form-control" value="#Session.GetSelectedEventDocuments.TContent_ID#">
												</cfif>
												</td>
												<td><a href="#Session.WebEventDirectory##Session.GetSelectedEventDocuments.ResourceDocument#" class="btn btn-primary btn-small" target="_blank">View</a></td>
											</tr>
										</cfloop>
									</tbody>
								</table>
							</div>
						</div>
					</cfif>
					<cfdump var="#Session.FORMData#">
				</div>
			</cfif>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Send Email Message"><br /><br />
				</div>
		</cfform>
	</div>
</cfoutput>
