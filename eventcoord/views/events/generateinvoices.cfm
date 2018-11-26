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
		<div id="modelWindowDialog" class="modal fade">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
							<h3>Proceeding with Disable Entering Invoices and Expenses</h3>
						</div>
						<div class="modal-body">
							<p class="alert alert-danger">By clicking the 'Send Electronic Invoices for Event' Button you will disable any future changes to the Revenue and Expense sections for this event. You will only be able to view the Profit and Loss Report only going forward.</p>
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
		<cfform action="" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Invoice(s) For: #Session.getSelectedEvent.ShortTitle#</h2></legend>
				</fieldset>
				<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
				<cfset ReportDirectory = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")# >
				<cfset ReportExportLoc = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")# & #URL.EventID# & "InvoicesForEvent.pdf" >
				<jr:jasperreport jrxml="#ReportDirectory#/EventInvoice.jrxml" query="#Session.GetSelectedEventRegistrations#" exportfile="#ReportExportLoc#" exportType="pdf" />
				<embed src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/#URL.EventID#InvoicesForEvent.pdf" width="100%" height="650">
			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Send Electronic Invoices for Event"><br /><br />
			</div>
		</cfform>
	</div>
</cfoutput>