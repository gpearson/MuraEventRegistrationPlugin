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
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="MembershipID" value="#URL.MembershipID#">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Edit Membership Organization</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Organization's Membership</div>
					<div class="form-group">
						<label for="OrganizationName" class="control-label col-sm-3">Organization Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="OrganizationName" name="OrganizationName" value="#Session.getSelectedMembership.OrganizationName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="OrganizationDomainName" class="control-label col-sm-3">Organization Domain Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="OrganizationDomainName" name="OrganizationDomainName" value="#Session.getSelectedMembership.OrganizationDomainName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Active Membership:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="Active" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedMembership.Active#" Display="OptionName" queryposition="below">
							<option value="----">Active Membership?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="StateDOEIDNumber" class="control-label col-sm-3">State DOE ID Number:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="StateDOEIDNumber" name="StateDOEIDNumber" value="#Session.getSelectedMembership.StateDOE_IDNumber#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="StateDOEState" class="control-label col-sm-3">State DOE State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="StateDOEState" name="StateDOEState" value="#Session.getSelectedMembership.StateDOE_State#" required="yes"></div>
					</div>
					<fieldset>
						<legend><h2>Mailing Address Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MailingAddress" class="control-label col-sm-3">Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingAddress" name="MailingAddress" value="#Session.getSelectedMembership.Mailing_Address#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingCity" class="control-label col-sm-3">City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingCity" name="MailingCity" value="#Session.getSelectedMembership.Mailing_City#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingState" class="control-label col-sm-3">State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingState" name="MailingState" value="#Session.getSelectedMembership.Mailing_State#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingZipCode" class="control-label col-sm-3">ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingZipCode" name="MailingZipCode" value="#Session.getSelectedMembership.Mailing_ZipCode#" required="yes"></div>
					</div>
					<fieldset>
						<legend><h2>Physical Address Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PhysicalAddress" class="control-label col-sm-3">Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.getSelectedMembership.Physical_Address#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="control-label col-sm-3">City:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.getSelectedMembership.Physical_City#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="control-label col-sm-3">State:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.getSelectedMembership.Physical_State#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="control-label col-sm-3">ZipCode:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.getSelectedMembership.Physical_ZipCode#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Phone Organization</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PrimaryPhoneNumber" class="control-label col-sm-3">Voice Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryPhoneNumber" name="PrimaryPhoneNumber" value="#Session.getSelectedMembership.Primary_PhoneNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryFaxNumber" class="control-label col-sm-3">Fax Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryFaxNumber" name="PrimaryFaxNumber" value="#Session.getSelectedMembership.Primary_FaxNumber#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Accounts Payable Contact Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AccountsPayableContactName" class="control-label col-sm-3">Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="AccountsPayableContactName" name="AccountsPayableContactName" value="#Session.getSelectedMembership.AccountsPayable_ContactName#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="AccountsPayableEmailAddress" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="AccountsPayableEmailAddress" name="AccountsPayableEmailAddress" value="#Session.getSelectedMembership.AccountsPayable_EmailAddress#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Send Invoices Electronically:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="ReceiveInvoicesByEmail" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedMembership.ReceiveInvoicesByEmail#" Display="OptionName" queryposition="below">
							<option value="----">Send Invoices Electronically?</option>
						</cfselect></div>
					</div>

				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Edit Membership Information"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="MembershipID" value="#Session.FormInput.MembershipID#">
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
						<legend><h2>Edit Membership Organization</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Organization's Membership</div>
					<div class="form-group">
						<label for="OrganizationName" class="control-label col-sm-3">Organization Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="OrganizationName" name="OrganizationName" value="#Session.FormInput.OrganizationName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="OrganizationDomainName" class="control-label col-sm-3">Organization Domain Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="OrganizationDomainName" name="OrganizationDomainName" value="#Session.FormInput.OrganizationDomainName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Active Membership:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="Active" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.FormInput.Active#" Display="OptionName" queryposition="below">
							<option value="----">Active Membership?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="StateDOEIDNumber" class="control-label col-sm-3">State DOE ID Number:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="StateDOEIDNumber" name="StateDOEIDNumber" value="#Session.FormInput.StateDOEIDNumber#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="StateDOEState" class="control-label col-sm-3">State DOE State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="StateDOEState" name="StateDOEState" value="#Session.FormInput.StateDOEState#" required="yes"></div>
					</div>
					<fieldset>
						<legend><h2>Mailing Address Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MailingAddress" class="control-label col-sm-3">Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingAddress" name="MailingAddress" value="#Session.FormInput.MailingAddress#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingCity" class="control-label col-sm-3">City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingCity" name="MailingCity" value="#Session.FormInput.MailingCity#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingState" class="control-label col-sm-3">State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingState" name="MailingState" value="#Session.FormInput.MailingState#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingZipCode" class="control-label col-sm-3">ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingZipCode" name="MailingZipCode" value="#Session.FormInput.MailingZipCode#" required="yes"></div>
					</div>
					<fieldset>
						<legend><h2>Physical Address Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PhysicalAddress" class="control-label col-sm-3">Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.FormInput.PhysicalAddress#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="control-label col-sm-3">City:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.FormInput.PhysicalCity#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="control-label col-sm-3">State:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.FormInput.PhysicalState#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="control-label col-sm-3">ZipCode:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.FormInput.PhysicalZipCode#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Phone Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PrimaryPhoneNumber" class="control-label col-sm-3">Voice Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryPhoneNumber" name="PrimaryPhoneNumber" value="#Session.FormInput.PrimaryPhoneNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryFaxNumber" class="control-label col-sm-3">Fax Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryFaxNumber" name="PrimaryFaxNumber" value="#Session.FormInput.PrimaryFaxNumber#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Accounts Payable Contact Information/h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AccountsPayableContactName" class="control-label col-sm-3">Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="AccountsPayableContactName" name="AccountsPayableContactName" value="#Session.FormInput.AccountsPayableContactName#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="AccountsPayableEmailAddress" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="AccountsPayableEmailAddress" name="AccountsPayableEmailAddress" value="#Session.FormInput.AccountsPayableEmailAddress#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Send Invoices Electronically:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="ReceiveInvoicesByEmail" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.FormInput.ReceiveInvoicesByEmail#" Display="OptionName" queryposition="below">
							<option value="----">Send Invoices Electronically?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Edit Membership Information"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
