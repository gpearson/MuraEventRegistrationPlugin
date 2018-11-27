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
						<legend><h2>Add New Catering Facility</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Account Holder</div>
					<div class="form-group">
						<label for="FacilityName" class="col-lg-5 col-md-5">Facility Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="FacilityName" name="FacilityName" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalAddress" class="col-lg-5 col-md-5">Physical Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="col-lg-5 col-md-5">Address City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="col-lg-5 col-md-5">Address State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="col-lg-5 col-md-5">Address ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="col-lg-5 col-md-5">Voice Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="col-lg-5 col-md-5">Website:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Contact Person's Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ContactName" class="col-lg-5 col-md-5">Contact Person:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactName" name="ContactName" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneNumber" class="col-lg-5 col-md-5">Phone Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactPhoneNumber" name="ContactPhoneNumber" required="no"></div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="col-lg-5 col-md-5">Contact Email:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Catering Facility Notes</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PaymentTerms" class="col-lg-5 col-md-5">Payment Terms:&nbsp;</label>
						<div class="col-sm-7"><textarea class="form-control" name="PaymentTerms" id="PaymentTerms" height="45"></textarea></div>
					</div>
					<div class="form-group">
						<label for="GuaranteeInformation" class="col-lg-5 col-md-5">Guarantee Information:&nbsp;</label>
						<div class="col-sm-7"><textarea class="form-control" name="GuaranteeInformation" id="GuaranteeInformation" height="45"></textarea></div>
					</div>
					<div class="form-group">
						<label for="DeliveryInformation" class="col-lg-5 col-md-5">Delivery Information:&nbsp;</label>
						<div class="col-sm-7"><textarea class="form-control" name="DeliveryInformation" id="DeliveryInformation" height="45"></textarea></div>
					</div>
					
					<div class="form-group">
						<label for="Active" class="col-lg-5 col-md-5">Caterer Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfselect name="Active" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below">
							<option value="----">Caterer Active?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Catering Listing">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add New Caterer"><br /><br />
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
						<legend><h2>Add New Catering Facility</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Account Holder</div>
					<div class="form-group">
						<label for="FacilityName" class="col-lg-5 col-md-5">Facility Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="FacilityName" name="FacilityName" value="#Session.FormInput.FacilityName#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalAddress" class="col-lg-5 col-md-5">Physical Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.FormInput.PhysicalAddress#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="col-lg-5 col-md-5">Address City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.FormInput.PhysicalCity#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="col-lg-5 col-md-5">Address State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.FormInput.PhysicalState#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="col-lg-5 col-md-5">Address ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.FormInput.PhysicalZipCode#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="col-lg-5 col-md-5">Voice Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" value="#Session.FormInput.PrimaryVoiceNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="col-lg-5 col-md-5">Website:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" value="#Session.FormInput.BusinessWebsite#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Contact Person's Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ContactName" class="col-lg-5 col-md-5">Contact Person:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactName" name="ContactName" value="#Session.FormInput.ContactName#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneNumber" class="col-lg-5 col-md-5">Phone Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactPhoneNumber" name="ContactPhoneNumber" value="#Session.FormInput.ContactPhoneNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="col-lg-5 col-md-5">Contact Email:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" value="#Session.FormInput.ContactEmail#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Catering Facility Notes</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PaymentTerms" class="col-lg-5 col-md-5">Payment Terms:&nbsp;</label>
						<div class="col-sm-7"><textarea class="form-control" name="PaymentTerms" id="PaymentTerms" height="45">#Session.FormInput.PaymentTerms#</textarea></div>
					</div>
					<div class="form-group">
						<label for="GuaranteeInformation" class="col-lg-5 col-md-5">Guarantee Information:&nbsp;</label>
						<div class="col-sm-7"><textarea class="form-control" name="GuaranteeInformation" id="GuaranteeInformation" height="45">#Session.FormInput.GuaranteeInformation#</textarea></div>
					</div>
					<div class="form-group">
						<label for="DeliveryInformation" class="col-lg-5 col-md-5">Delivery Information:&nbsp;</label>
						<div class="col-sm-7"><textarea class="form-control" name="DeliveryInformation" id="DeliveryInformation" height="45">#Session.FormInput.DeliveryInformation#</textarea></div>
					</div>
					<div class="form-group">
						<label for="Active" class="col-lg-5 col-md-5">Caterer Active:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfselect name="Active" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.Active#" queryposition="below">
							<option value="----">Caterer Active?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Catering Listing">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add New Caterer"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
