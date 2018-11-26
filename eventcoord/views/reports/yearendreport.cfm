<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<script>
		$(function() {
			$("##BegYearDate").datepicker();
			$("##EndYearDate").datepicker();
		});
	</script>
	<cfif not isDefined("URL.FormRetry") and not isDefined("URL.DisplayReport")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Year End Report</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to display this report for the selected year period.</div>
					<div class="form-group">
						<label for="BeginYearDate" class="control-label col-sm-3">Year Start Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="BegYearDate" name="BegYearDate" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EndYearDate" class="control-label col-sm-3">Year End Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EndYearDate" name="EndYearDate" required="no"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="View Report"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry") and not isDefined("URL.DisplayReport")>
		<cfif isDefined("Session.FormErrors")>
			<div id="modelWindowDialog" class="modal fade">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
							<h3>Missing Information</h3>
						</div>
						<div class="modal-body">
							<p class="alert alert-danger">#Session.FormErrors[1].Message#<br><hr>Events that need updated before report can be ran are:<br><cfloop array="#Session.FormErrors[2]#" index="i"><p>#i.TContent_ID# - #i.Message#</p></cfloop></p>
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
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Year End Report</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to display this report for the selected year period.</div>
					<div class="form-group">
						<label for="BeginYearDate" class="control-label col-sm-3">Year Start Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="BegYearDate" value="#Session.FormData.BegYearDate#" name="BegYearDate" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EndYearDate" class="control-label col-sm-3">Year End Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EndYearDate" value="#Session.FormData.EndYearDate#" name="EndYearDate" required="no"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="View Report"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelse>
		<div class="panel panel-default">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Year End Report</h2></legend>
				</fieldset>
				<cfimport taglib="/plugins/EventRegistration/library/cfjasperreports/tag/cfjasperreport" prefix="jr">
				<cfset ReportDirectory = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/reports/")# >
				<cfset ReportName = #DateFormat(Session.FormData.BegYearDate, "yyyy")# & "-" & #DateFormat(Session.FormData.EndYearDate, "yyyy")# & "-YearEndReport.pdf">
				<cfset ReportExportLoc = #ExpandPath("/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/")# & #Variables.ReportName#>
				<jr:jasperreport jrxml="#ReportDirectory#/YearEndEventReport.jrxml" query="#Session.QueryForReport#" exportfile="#ReportExportLoc#" exportType="pdf" />
				<embed src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/ReportExports/#Variables.ReportName#" width="100%" height="650">
			</div>
		</div>
		<div class="panel-footer">
			<a href="" class="btn btn-primary pull-left">Back to Main Menu</a><br /><br />
		</div>
	</cfif>
</cfoutput>