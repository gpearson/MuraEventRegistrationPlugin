<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-body">
			<fieldset>
				<legend><h2>Welcome #Session.Mura.FName# #Session.Mura.LName# (Event Presenter)</h2></legend>
			</fieldset>
			<div>Please use the navigation toolbar above to complete the task you logged in to do.</div>
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="UserProfileUpdated">
						<div id="modelWindowDialog" class="modal fade">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
										<h3>User Account Updated</h3>
									</div>
									<div class="modal-body">
										<p class="alert alert-success">The account changed which you have made where updated successfully. We appriciate you keeping your information up to date and current.</p>
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
									///////////////

									// method to open modal
									function openModal(){
										vm.modal.modal('show');
									}

									// method to close modal
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
					</cfcase>
					<cfcase value="EventAdded">
						<cfif URL.Successful EQ "False">
							<cfif ArrayLen(Session.FormErrors) GTE 1>
								<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="EventCopied">
						<cfif URL.Successful EQ "False">
							<cfif ArrayLen(Session.FormErrors) GTE 1>
								<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
								<cfdump var="#Session.FormErrors#">
							</cfif>
						</cfif>
					</cfcase>
				</cfswitch>
			</cfif>
		</div>
	</div>
</cfoutput>