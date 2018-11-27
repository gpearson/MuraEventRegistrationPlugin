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
						<legend><h2>Event Links for: #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>

					<br>
					<fieldset>
						<legend><h2>Existing Event Links(s)</h2></legend>
					</fieldset>
					<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
						<thead class="thead-default">
							<tr>
								<th width="75%">Website Link URL</th>
								<th width="25%">Actions</th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="#Session.getSelectedEventLinks#">
								<tr>
									<td>#Session.getSelectedEventLinks.ResourceDocument#</td>
									<td><a href="#Session.getSelectedEventLinks.ResourceDocument#" class="btn btn-primary btn-small" target="_blank">View</a><a href="#buildURL('eventcoordinator:events.eventweblinks')#&EventID=#URL.EventID#&UserAction=DeleteEventLink&LinkID=#Session.getSelectedEventLinks.TContent_ID#" class="btn btn-primary btn-small">Delete</a></td>
								</tr>
							</cfloop>
						</tbody>
					</table>
					<br>
					<fieldset>
						<legend><h2>Upload new Event Link(s)</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventLink" class="col-lg-5 col-md-5">Event Link:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="EventLink" name="EventLink" required="no" value="http://"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back To Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Upload Event Link"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="EventDocumentsForm" class="form-horizontal" enctype="multipart/form-data">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
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
				<div class="panel-body">
					<fieldset>
						<legend><h2>Event Links for: #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<br>
					<fieldset>
						<legend><h2>Existing Event Links(s)</h2></legend>
					</fieldset>
					<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
						<thead class="thead-default">
							<tr>
								<th width="75%">Website Link URL</th>
								<th width="25%">Actions</th>
							</tr>
						</thead>
						<tbody>
							<cfloop query="#Session.getSelectedEventLinks#">
								<tr>
									<td>#Session.getSelectedEventLinks.ResourceDocument#</td>
									<td><a href="#Session.getSelectedEventLinks.ResourceDocument#" class="btn btn-primary btn-small" target="_blank">View</a><a href="#buildURL('eventcoordinator:events.eventweblinks')#&EventID=#URL.EventID#&UserAction=DeleteEventLink&LinkID=#Session.getSelectedEventLinks.TContent_ID#" class="btn btn-primary btn-small">Delete</a></td>
								</tr>
							</cfloop>
						</tbody>
					</table>
					<br>
					<fieldset>
						<legend><h2>Upload new Event Link(s)</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventLink" class="col-lg-5 col-md-5">Event Link:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="EventLink" name="EventLink" required="no" value="#Session.FormInput.EventLink#"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back To Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Upload Event Link"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>