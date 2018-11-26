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
			<cfif isDefined("URL.UserAction")>
				<div class="panel-body">
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="RoomCreated">
							<cfif URL.Successful EQ "true">
								<div id="modelWindowDialog" class="modal fade">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
												<h3>Facility Room Information Added</h3>
											</div>
											<div class="modal-body">
												<p class="alert alert-success">You have successfully created a new room within Facility for upcoming meetings or events.</p>
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
							<cfelse>
								<div class="alert alert-danger">
								</div>
							</cfif>
						</cfcase>
						<cfcase value="RoomUpdated">
							<cfif URL.Successful EQ "true">
								<div id="modelWindowDialog" class="modal fade">
									<div class="modal-dialog">
										<div class="modal-content">
											<div class="modal-header">
												<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
												<h3>Facility Room Information Updated</h3>
											</div>
											<div class="modal-body">
												<p class="alert alert-success">You have successfully updated a room within Facility for upcoming meetings or events.</p>
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
							<cfelse>
								<div class="alert alert-danger">
								</div>
							</cfif>
						</cfcase>
					</cfswitch>
				</div>
			</cfif>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Add New Facility</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Facility</div>
					<div class="form-group">
						<label for="FacilityName" class="control-label col-sm-3">Facility Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FacilityName" name="FacilityName" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Physical Location Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PhysicalAddress" class="control-label col-sm-3">Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="control-label col-sm-3">City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="control-label col-sm-3">State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="control-label col-sm-3">ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="control-label col-sm-3">Voice Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="control-label col-sm-3">Website:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" required="NO"></div>
					</div>
					<fieldset>
						<legend><h2>Contact Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ContactName" class="control-label col-sm-3">Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactName" name="ContactName" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneNumber" class="control-label col-sm-3">Phone Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactPhoneNumber" name="ContactPhoneNumber" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="Active" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below">
							<option value="----">Is facility Active?</option>
						</cfselect></div>
					</div>

				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Facility"><br /><br />
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
						<legend><h2>Add New Facility</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Caterering Facility</div>
					<div class="form-group">
						<label for="FacilityName" class="control-label col-sm-3">Business Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FacilityName" name="FacilityName" value="#Session.FormInput.FacilityName#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Physical Location Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PhysicalAddress" class="control-label col-sm-3">Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.FormInput.PhysicalAddress#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="control-label col-sm-3">City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.FormInput.PhysicalCity#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="control-label col-sm-3">State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.FormInput.PhysicalState#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="control-label col-sm-3">ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.FormInput.PhysicalZipCode#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="control-label col-sm-3">Voice Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" value="#Session.FormInput.PrimaryVoiceNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="control-label col-sm-3">Website:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" value="#Session.FormInput.BusinessWebsite#" required="NO"></div>
					</div>
					<fieldset>
						<legend><h2>Contact Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ContactName" class="control-label col-sm-3">Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactName" name="ContactName" value="#Session.FormInput.ContactName#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneNumber" class="control-label col-sm-3">Phone Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactPhoneNumber" name="ContactPhoneNumber" value="#Session.FormInput.ContactPhoneNumber#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" value="#Session.FormInput.ContactEmail#" required="NO"></div>
					</div>
					<fieldset>
						<legend><h2>Optional Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PaymentTerms" class="control-label col-sm-3">Payment Terms:&nbsp;</label>
						<div class="col-sm-8"><textarea name="PaymentTerms" id="PaymentTerms" class="form-control" ><cfif isDefined("Session.FormInput.PaymentTerms")>#Session.FormInput.PaymentTerms#</cfif></textarea></div>
					</div>
					<div class="form-group">
						<label for="DeliveryInfo" class="control-label col-sm-3">Delivery Information:&nbsp;</label>
						<div class="col-sm-8"><textarea name="DeliveryInfo" id="DeliveryInfo" class="form-control" ><cfif isDefined("Session.FormInput.DeliveryInfo")>#Session.FormInput.DeliveryInfo#</cfif></textarea></div>
					</div>
					<div class="form-group">
						<label for="GuaranteeInformation" class="control-label col-sm-3">Guarantee Information:&nbsp;</label>
						<div class="col-sm-8"><textarea name="GuaranteeInformation" id="GuaranteeInformation" class="form-control" ><cfif isDefined("Session.FormInput.GuaranteeInformation")>#Session.FormInput.GuaranteeInformation#</cfif></textarea></div>
					</div>
					<div class="form-group">
						<label for="AdditionalNotes" class="control-label col-sm-3">Additional Notes:&nbsp;</label>
						<div class="col-sm-8"><textarea name="AdditionalNotes" id="AdditionalNotes" class="form-control" ><cfif isDefined("Session.FormInput.AdditionalNotes")>#Session.FormInput.AdditionalNotes#</cfif></textarea></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="Active" class="form-control" required="no" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.FormInput.Active#" Display="OptionName" queryposition="below">
							<option value="----">Is Caterer Active?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Facility"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
