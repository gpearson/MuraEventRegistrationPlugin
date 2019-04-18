<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2016 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<cfif isDefined("URL.SiteConfigUpdated")>
		<cfswitch expression="#URL.SiteConfigUpdated#">
			<cfcase value="True">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Site Configuration Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully updated site configuration settings of this plugin</p>
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
			</cfcase>
			<cfcase value="False">

			</cfcase>
		</cfswitch>
	</cfif>
	<h2>Home</h2>
	<p>Hello there! Welcome to the Home view of the FW/1's Main section.</p>
	<p>This is just a FW/1 sub-application. You could create your own admin interface here, or simply provide instructions on how to use your plugin. It's entirely up to you.</p>
</cfoutput>
