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
	<cfset CurrentYear = #Year(Now())#>
	<cfset PreviousYear = #Year(Now())# - 1>
	<cfset ReportStartDate = #CreateDate(Variables.PreviousYear, 7, 1)#>
	<cfset ReportEndDate = #CreateDate(Variables.CurrentYear, 6, 30)#>
	<cfif not isDefined("URL.FormRetry") and not isDefined("URL.DisplayReport")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Year End Report</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to display this report for the selected year period. This will create a CSV (Comma Seperated Value) file that can be read by Microsoft Excell or compatible program to view the information.</div>
					<div class="form-group">
						<label for="BeginYearDate" class="control-label col-sm-3">Year Start Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="BegYearDate" name="BegYearDate" value="#DateFormat(Variables.ReportStartDate, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EndYearDate" class="control-label col-sm-3">Year End Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EndYearDate" name="EndYearDate" value="#DateFormat(Variables.ReportEndDate, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Membership" class="control-label col-sm-3">Membership Agency:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="MembershipID" class="form-control" Required="Yes" Multiple="No" query="Session.QueryForReport.GetMembershipAgencies" value="TContent_ID" Display="OrganizationName"  queryposition="below">
							<option value="----">Select Which Membership Agency you want to base report on</option>
							<option value="0">Not a Member of ESC/ESA</option></cfselect>
						</div>
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
					<div class="alert alert-info">Please complete the following information to display this report for the selected year period. The report will only show events that have not been cancelled.</div>
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
				<p>Your report has been generated and ready to be downloaded. Please click <a href="#Session.ReportQuery.ReportURLLocation##Session.ReportQuery.ReportFileName#" target="_blank">#Session.ReportQuery.ReportFileName#</a> to download your report</p>
				<p>Your report header file has been generated and ready to be downloaded. Please click <a href="#Session.ReportQuery.ReportURLLocation##Session.ReportQuery.ReportHeaderFileName#" target="_blank">#Session.ReportQuery.ReportHeaderFileName#</a> to download your report</p>
			</div>
		</div>
		<div class="panel-footer">
			<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:main.default" class="btn btn-primary pull-left">Back to Main Menu</a><br /><br />
		</div>
	</cfif>
</cfoutput>