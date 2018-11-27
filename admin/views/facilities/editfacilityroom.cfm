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
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddNewUser" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Edit Facility Room Information</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Facility</div>
					<div class="form-group">
						<label for="FacilityName" class="col-lg-5 col-md-5">Facility Name:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="FacilityName" name="FacilityName" value="#Session.getSelectedFacility.FacilityName#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalAddress" class="col-lg-5 col-md-5">Physical Address:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.getSelectedFacility.PhysicalAddress#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="col-lg-5 col-md-5">Address City:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.getSelectedFacility.PhysicalCity#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="col-lg-5 col-md-5">Address State:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.getSelectedFacility.PhysicalState#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="col-lg-5 col-md-5">Address ZipCode:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.getSelectedFacility.PhysicalZipCode#" disabled="yes"></div>
					</div>
					<fieldset>
						<legend><h2>Room Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="RoomName" class="col-lg-5 col-md-5">Room Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="RoomName" name="RoomName" value="#Session.getSelectedFacilityRoom.RoomName#" Required="Yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomCapacity" class="col-lg-5 col-md-5">Room Capacity:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="RoomCapacity" name="RoomCapacity" value="#Session.getSelectedFacilityRoom.Capacity#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomFees" class="col-lg-5 col-md-5">Room Fees:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="RoomFees" name="RoomFees" value="#NumberFormat(Session.getSelectedFacilityRoom.RoomFees, '999.99')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="col-lg-5 col-md-5">Room Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfselect name="Active" class="form-control" Required="no" Multiple="No" selected="#Session.getSelectedFacilityRoom.Active#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below">
							<option value="----">Room Active?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Facility Listing">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Facility Room Information"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddNewUser" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
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
						<legend><h2>Add New Facility Room</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Facility</div>
					<div class="form-group">
						<label for="FacilityName" class="col-lg-5 col-md-5">Facility Name:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="FacilityName" name="FacilityName" value="#Session.getSelectedFacility.FacilityName#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalAddress" class="col-lg-5 col-md-5">Physical Address:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.getSelectedFacility.PhysicalAddress#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="col-lg-5 col-md-5">Address City:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.getSelectedFacility.PhysicalCity#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="col-lg-5 col-md-5">Address State:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.getSelectedFacility.PhysicalState#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="col-lg-5 col-md-5">Address ZipCode:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.getSelectedFacility.PhysicalZipCode#" disabled="yes"></div>
					</div>
					<fieldset>
						<legend><h2>Room Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="RoomName" class="col-lg-5 col-md-5">Room Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="RoomName" name="RoomName" value="#Session.FormInput.RoomName#" Required="Yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomCapacity" class="col-lg-5 col-md-5">Room Capacity:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="RoomCapacity" name="RoomCapacity" value="#Session.FormInput.RoomCapacity#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomFees" class="col-lg-5 col-md-5">Room Fees:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="RoomFees" name="RoomFees" value="#NumberFormat(Session.FormInput.RoomFees, '999.99')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="col-lg-5 col-md-5">Room Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfselect name="Active" class="form-control" Required="no" Multiple="No" selected="#Session.FormInput.Active#" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below">
							<option value="----">Room Active?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Facility Listing">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Facility Room Information"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
