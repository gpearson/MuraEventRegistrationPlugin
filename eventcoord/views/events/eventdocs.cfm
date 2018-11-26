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
	<link rel="stylesheet" href="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/js/plupload-v3/js/jquery.ui.plupload/css/jquery.ui.plupload.css" type="text/css" />
	<script type="text/javascript" src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/js/jquery-ui-1.9.2.custom.min.js"></script>
	<script type="text/javascript" src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/js/plupload-v3/js/plupload.min.js"></script>
	<script type="text/javascript" src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/js/plupload-v3/js/jquery.ui.plupload/jquery.ui.plupload.js"></script>
	<cfif isDefined("URL.UserAction")>
		<div class="panel-body">
			<cfswitch expression="#URL.UserAction#">
				<cfcase value="ResourceDocumentDeleted">
					<cfif isDefined("URL.Successful")>
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Event Resource Document Deleted</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully deleted a resource document from this event listing.</p>
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
			</cfswitch>
		</div>
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
			<div class="panel-body">
				<cfif Session.GetSelectedEventDocuments.RecordCount>
					<br>
					<fieldset>
						<legend><h2>Existing Event Document(s)</h2></legend>
					</fieldset>
					<div class="form-group">
						<div class="col-sm-12">
							<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
								<thead class="thead-default">
									<tr>
										<th width="50%">Document Name</th>
										<th  width="25%">Size</th>
										<th width="25%">Actions</th>
									</tr>
								</thead>
								<tbody>
									<cfloop query="#Session.GetSelectedEventDocuments#">
										<tr>
											<td>#Session.GetSelectedEventDocuments.ResourceDocument#</td>
											<cfset FileMBSize = NumberFormat(((#Session.GetSelectedEventDocuments.ResourceDocumentSize# / 1024) / 1024), "99.99999") />
											<td>#Variables.FileMBSize# MB</td>
											<!--- <td>#Session.GetSelectedEventDocuments.ResourceDocumentSize#</td> --->
											<td><a href="#Session.WebEventDirectory##Session.GetSelectedEventDocuments.ResourceDocument#" class="btn btn-primary btn-small" target="_blank">View</a><a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.eventdocs&EventID=#URL.EventID#&UserAction=DeleteEventDocument&DocumentID=#Session.GetSelectedEventDocuments.TContent_ID#" class="btn btn-primary btn-small">Delete</a></td>
										</tr>
									</cfloop>
								</tbody>
							</table>
						</div>
					</div>
				</cfif>
				<fieldset>
					<legend><h2>Upload New Event Document(s)</h2></legend>
				</fieldset>
				<div class="form-group">
					<div class="col-sm-12">
						<div id="uploader">
							<p>Your Browser does not have Flash, Silverlight or HTML5 Support.</p>
						</div>
					</div>
				</div>
			</div>
			<div class="panel-footer">
				<A href="#buildURL('eventcoord:events.default')#" class="btn btn-primary pull-left">Back to Event Listing</A>
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Upload Event Documents"><br /><br />
			</div>
		</cfform>
		<script type="text/javascript">
			// Initialize the widget when the DOM is ready
			$(function() {
				$("##uploader").plupload({
					// General settings
					runtimes : 'html5,flash,silverlight,html4',
					url : '#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.eventdocs&EventID=#URL.EventID#&UserAction=FileUpload',

					// User can upload no more then 20 files in one go (sets multiple_queues to false)
					max_file_count: 20,

					// Resize images on clientside if we can
					resize : {
						width : 200,
						height : 200,
						quality : 90,
						crop: true // crop to exact dimensions
					},
					filters : {
						// Maximum file size
						max_file_size : '1000mb',
						// Specify what files to browse for
						mime_types: [
							{title : "Image files", extensions : "jpg,gif,png"},
							{title : "Zip files", extensions : "zip"},
							{title : "Document files", extensions : "doc,docx,pdf,xls,xlsx,ppt,pptx"}
						]
					},
					// Rename files by clicking on their titles
					rename: true,
					// Sort files
					sortable: true,
					// Enable ability to drag'n'drop files onto the widget (currently only HTML5 supports that)
					dragdrop: true,
					// Views to activate
					views: {
						list: true,
						thumbs: false, // Show thumbs
						active: 'list'
					},
					// Flash settings
					flash_swf_url : '/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/js/plupload-v3/js/Moxie.swf',
					// Silverlight settings
					silverlight_xap_url : '/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/js/plupload-v3/js/Moxie.xap'
				});
				// Handle the case when form was submitted before uploading has finished
				$('##EventDocumentsForm').submit(function(e) {
					// Files in queue upload them first
					if ($('##uploader').plupload('getFiles').length > 0) {
						// When all files are uploaded submit form
						$('##uploader').on('complete', function() {
							$('##EventDocumentsForm')[0].submit();
						});
						$('##uploader').plupload('start');
					}
					return false; // Keep the form from submitting
				});
			});
		</script>
	</div>
</cfoutput>
