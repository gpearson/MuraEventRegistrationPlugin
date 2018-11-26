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
	<script type="text/javascript" src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/js/jquery-ui-1.9.2.custom.min.js"></script>
	<cfif isDefined("URL.UserAction")>
		<cfif URL.UserAction EQ "ResourceLinkAdded">
			<div id="modelWindowDialog" class="modal fade">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
							<h3>Event Resource Link(s) Added</h3>
						</div>
						<div class="modal-body">
							<p class="alert alert-success">You have sucessfully entered the website resources into the database for this event.</p>
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
		<div class="panel-heading">
			<fieldset>
				<legend><h2>Event Resources: #Session.getSelectedEvent.ShortTitle#</h2><p>Number of Registered Participants: #Session.EventNumberRegistrations#</p></legend>
			</fieldset>
		</div>
		<cfform action="" method="post" id="EventDocumentsForm" class="form-horizontal" enctype="multipart/form-data">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="EventID" value="#URL.EventID#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfif isDefined("URL.FormRetry")>
				<div class="panel-body">
				<cfif Session.GetSelectedEventWebLinks.RecordCount>
					<div id="modelWindowDialog" class="modal fade">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
							<h3>Missing Information to Enter Website Link</h3>
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
					<br>
					<fieldset>
						<legend><h2>Existing Event Website Link(s)</h2></legend>
					</fieldset>
					<div class="form-group">
						<div class="col-sm-12">
							<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
								<thead class="thead-default">
									<tr>
										<th width="75%">Website Resource Name</th>
										<th width="25%">Actions</th>
									</tr>
								</thead>
								<tbody>
									<cfloop query="#Session.GetSelectedEventWebLinks#">
										<tr>
											<td>#Session.GetSelectedEventWebLinks.ResourceLink#</td>
											<td><a href="#Session.GetSelectedEventWebLinks.ResourceLink#" class="btn btn-primary btn-small" target="_blank">View</a><a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.eventweblinks&EventID=#URL.EventID#&UserAction=DeleteEventWebLink&DocumentID=#Session.GetSelectedEventWebLinks.TContent_ID#" class="btn btn-primary btn-small">Delete</a></td>
										</tr>
									</cfloop>
								</tbody>
							</table>
						</div>
					</div>
				</cfif>
				<fieldset>
					<legend><h2>Upload New Event Website Link(s)</h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="FirstWebLink" class="control-label col-sm-3">First Website Link (if Any):&nbsp;</label>
					<div class="col-sm-8"><cfinput type="text" class="form-control" id="FirstWebLink" name="FirstWebLink" value="#Session.FormData.FirstWebLink#" required="no"></div>
				</div>
				<div class="form-group">
					<label for="SecondWebLink" class="control-label col-sm-3">Second Website Link (if Any):&nbsp;</label>
					<div class="col-sm-8"><cfinput type="text" class="form-control" id="SecondWebLink" name="SecondWebLink"  value="#Session.FormData.SecondWebLink#" required="no"></div>
				</div>
				<div class="form-group">
					<label for="ThirdWebLink" class="control-label col-sm-3">Third Website Link (if Any):&nbsp;</label>
					<div class="col-sm-8"><cfinput type="text" class="form-control" id="ThirdWebLink" name="ThirdWebLink"  value="#Session.FormData.ThirdWebLink#" required="no"></div>
				</div>
			<cfelse>
				<div class="panel-body">
				<cfif Session.GetSelectedEventWebLinks.RecordCount>
					<br>
					<fieldset>
						<legend><h2>Existing Event Website Link(s)</h2></legend>
					</fieldset>
					<div class="form-group">
						<div class="col-sm-12">
							<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
								<thead class="thead-default">
									<tr>
										<th width="75%">Website Resource Name</th>
										<th width="25%">Actions</th>
									</tr>
								</thead>
								<tbody>
									<cfloop query="#Session.GetSelectedEventWebLinks#">
										<tr>
											<td>#Session.GetSelectedEventWebLinks.ResourceLink#</td>
											<td><a href="#Session.GetSelectedEventWebLinks.ResourceLink#" class="btn btn-primary btn-small" target="_blank">View</a><a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.eventweblinks&EventID=#URL.EventID#&UserAction=DeleteEventWebLink&DocumentID=#Session.GetSelectedEventWebLinks.TContent_ID#" class="btn btn-primary btn-small">Delete</a></td>
										</tr>
									</cfloop>
								</tbody>
							</table>
						</div>
					</div>
				</cfif>
				<fieldset>
					<legend><h2>Upload New Event Website Link(s)</h2></legend>
				</fieldset>
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
			</cfif>

			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Upload Event Website Links"><br /><br />
			</div>
		</cfform>
	</div>
</cfoutput>


<!---
<cfcase value="ResourceWebsiteDeleted">
					<cfif isDefined("URL.Successful")>
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Event Resource Website Deleted</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully deleted a resource website from this event listing.</p>
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
				</cfcase>



<cfif Session.GetSelectedEventLinks.RecordCount>
						<br>
						<fieldset>
							<legend><h2>Existing Event Website Resource(s)</h2></legend>
						</fieldset>
						<div class="form-group">
							<div class="col-sm-12">
								<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
									<thead class="thead-default">
										<tr>
											<th width="50%">Resource Link</th>
											<th width="25%">Actions</th>
										</tr>
									</thead>
									<tbody>
										<cfloop query="#Session.GetSelectedEventLinks#">

											<tr>
												<td>#Session.GetSelectedEventLinks.ResourceLink#</td>
												<td><a href="#Session.GetSelectedEventLinks.ResourceLink#" class="btn btn-primary btn-small" target="_blank">View</a><a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.uploaddocs&EventID=#URL.EventID#&UserAction=DeleteEventWebsite&DocumentID=#Session.GetSelectedEventLinks.TContent_ID#" class="btn btn-primary btn-small">Delete</a></td>
											</tr>
										</cfloop>
									</tbody>
								</table>
							</div>
						</div>
					</cfif>
					<br>




<br>
					<fieldset>
						<legend><h2>New Event Website Resource(s)</h2></legend>
					</fieldset>
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

--->