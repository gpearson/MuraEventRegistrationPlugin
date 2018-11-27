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
<cfif LEN(cgi.path_info)><cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# ><cfelse><cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action#></cfif>
</cfsilent>
<cfoutput>
	<script src="/requirements/ckeditor/ckeditor.js"></script>
	<cfif not isDefined("URL.FormRetry")>
		<cfform action="#Variables.newurl#=eventcoordinator:events.emailparticipants&EventID=#URL.EventID#&EmailType=#URL.EmailType#" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="EventID" value="#URL.EventID#">
			<cfinput type="hidden" name="EmailType" value="#URL.EmailType#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<div class="panel panel-default">
				<fieldset>
					<legend><h2>Send <cfif URL.EmailType EQ "EmailRegistered">Registered<cfelseif URL.EmailType EQ "EmailAttended">Attended</cfif> Participants Email: #Session.getSelectedEvent.ShortTitle#</h2><br><p>Number of Registered Participants: #Session.GetParticipantsForEvent.RecordCount#</p></h2></legend>
				</fieldset>
				<div class="panel-body">
					<div class="alert alert-info"><p>Complete this form to email the selected group of participants for this event.</p></div>
					<fieldset>
						<legend><h2>Message to Participants</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDescription" class="col-lg-3 col-md-3">Message to Participants:&nbsp;</label>
						<div class="col-lg-9 col-md-9">
							<textarea height="15" width="100%" class="form-control" id="EmailMsg" name="EmailMsg"></textarea>
							<script type="text/javascript">
								CKEDITOR.replace('EmailMsg', {
									// Define the toolbar groups as it is a more accessible solution.
									toolbarGroups: [
										{"name":"basicstyles","groups":["basicstyles"]},
										{"name":"links","groups":["links"]},
										{"name":"paragraph","groups":["list","blocks"]},
										{"name":"document","groups":["mode"]},
										{"name":"insert","groups":["insert"]},
										{"name":"styles","groups":["styles"]},
										{"name":"about","groups":["about"]}
									],
									// Remove the redundant buttons from toolbar groups defined above.
									removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
								} );
							</script>
						</div>
					</div>
					<cfif Session.GetSelectedEventLinks.RecordCount>
						<fieldset>
							<legend><h2>Event Website Resource Links</h2></legend>
						</fieldset>
						<div class="alert alert-info">Select the Event Website Resource Links from the list below that you would like to send to participants who are registered for this event.</div>
						<div class="form-group">
							<label for="EventDescription" class="col-lg-5 col-md-5">Previous Sent Event Links:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
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
												<td>#Session.GetSelectedEventLinks.ResourceDocument#</td>
												<td><cfinput type="checkbox" name="IncludeWebLinkInEmail" class="form-control" value="#Session.GetSelectedEventLinks.TContent_ID#"></td>
												<td><a href="#Session.GetSelectedEventLinks.ResourceDocument#" class="btn btn-primary btn-small" target="_blank">View</a></td>
											</tr>
										</cfloop>
									</tbody>
								</table>
							</div>
						</div>
					</cfif>
					<cfif Session.GetSelectedEventDocuments.RecordCount>
						<fieldset>
							<legend><h2>Event Website Resource Documents</h2></legend>
						</fieldset>
						<div class="alert alert-info">Select the Event Website Resource Documents from the list below that you would like to send to participants who are registered for this event.</div>
						<div class="form-group">
							<label for="EventDescription" class="col-lg-5 col-md-5">Previous Sent Event Documents:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
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
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Email Participants List"><br /><br />
				</div>
			</div>
		</cfform>
	<cfelseif isDefined("URL.FormRetry")>
		<cfform action="#Variables.newurl#=eventcoordinator:events.emailparticipants&EventID=#URL.EventID#&EmailType=#URL.EmailType#" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="EventID" value="#URL.EventID#">
			<cfinput type="hidden" name="EmailType" value="#URL.EmailType#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfif isDefined("Session.FormErrors")>
				<cfif ArrayLen(Session.FormErrors)>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Missing Information</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">#Session.FormErrors[1].Message#</p>
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
				</cfif>
			</cfif>
			<div class="panel panel-default">
				<fieldset>
					<legend><h2>Send <cfif URL.EmailType EQ "EmailRegistered">Registered<cfelseif URL.EmailType EQ "EmailAttended">Attended</cfif> Participants Email: #Session.getSelectedEvent.ShortTitle#</h2><br><p>Number of Registered Participants: #Session.GetParticipantsForEvent.RecordCount#</p></h2></legend>
				</fieldset>
				<div class="panel-body">
					<div class="alert alert-info"><p>Complete this form to email the selected group of participants for this event.</p></div>
					<fieldset>
						<legend><h2>Message to Participants</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDescription" class="col-lg-3 col-md-3">Message to Participants:&nbsp;</label>
						<div class="col-lg-9 col-md-9">
							<textarea height="15" width="100%" class="form-control" id="EmailMsg" name="EmailMsg"></textarea>
							<script type="text/javascript">
								CKEDITOR.replace('EmailMsg', {
									// Define the toolbar groups as it is a more accessible solution.
									toolbarGroups: [
										{"name":"basicstyles","groups":["basicstyles"]},
										{"name":"links","groups":["links"]},
										{"name":"paragraph","groups":["list","blocks"]},
										{"name":"document","groups":["mode"]},
										{"name":"insert","groups":["insert"]},
										{"name":"styles","groups":["styles"]},
										{"name":"about","groups":["about"]}
									],
									// Remove the redundant buttons from toolbar groups defined above.
									removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
								} );
							</script>
						</div>
					</div>
					<cfif Session.GetSelectedEventLinks.RecordCount>
						<fieldset>
							<legend><h2>Event Website Resource Links</h2></legend>
						</fieldset>
						<div class="alert alert-info">Select the Event Website Resource Links from the list below that you would like to send to participants who are registered for this event.</div>
						<div class="form-group">
							<label for="EventDescription" class="col-lg-5 col-md-5">Previous Sent Event Links:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
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
							<legend><h2>Event Website Resource Documents</h2></legend>
						</fieldset>
						<div class="alert alert-info">Select the Event Website Resource Documents from the list below that you would like to send to participants who are registered for this event.</div>
						<div class="form-group">
							<label for="EventDescription" class="col-lg-5 col-md-5">Previous Sent Event Documents:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
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
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Email Participants List"><br /><br />
				</div>
			</div>
		</cfform>
	</cfif>
</cfoutput>