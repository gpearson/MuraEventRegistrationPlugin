<cfsilent>
<!---

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
	<script src="/requirements/ckeditor/ckeditor.js"></script>
	<cfset pluginPath = rc.$.globalConfig('context') & '/plugins/' & rc.pluginConfig.getPackage() />
	<script type="text/javascript" src="#pluginPath#/includes/assets/js/jquery.formatCurrency-1.4.0.js"></script>
	<script type="text/javascript" src="#pluginPath#/includes/assets/js/jquery.formatCurrency.all.js"></script>
	<script type="text/javascript">
		$(document).ready(function()
			{
				$('##RoomFees').blur(function() {
					$('##RoomFees').formatCurrency();
				});
		});
	</script>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Add Meeting Room within Facility</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding the Facility Room</div>
					<div class="form-group">
						<label for="RoomName" class="col-lg-3 col-md-3">Room Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="RoomName" name="RoomName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomCapacity" class="col-lg-3 col-md-3">Seating Capacity:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="RoomCapacity" name="RoomCapacity" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomFees" class="col-lg-3 col-md-3">Room Fee:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="RoomFees" name="RoomFees" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="col-lg-3 col-md-3">Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfselect name="Active" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below">
							<option value="----">Is Room Active?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Facility Room Information"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif isDefined("Session.FormErrors")>
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
				<div class="panel-body">
					<fieldset>
						<legend><h2>Add Meeting Room within Facility</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding the Facility Room</div>
					<div class="form-group">
						<label for="RoomName" class="col-lg-3 col-md-3">Room Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="RoomName" name="RoomName" value="#Session.FormInput.RoomName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomCapacity" class="col-lg-3 col-md-3">Seating Capacity:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="RoomCapacity" name="RoomCapacity" value="#Session.FormInput.RoomCapacity#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomFees" class="col-lg-3 col-md-3">Room Fee:&nbsp;</label>
						<div class="col-lg-9 col-md-9"><cfinput type="text" class="form-control" id="RoomFees" name="RoomFees" value="#Session.FormInput.RoomFees#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="col-lg-3 col-md-3">Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-9 col-md-9"><cfselect name="Active" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.FormInput.Active#" Display="OptionName" queryposition="below">
							<option value="----">Is Room Active?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Facility Room Information"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
