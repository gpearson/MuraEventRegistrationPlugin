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
						<legend><h2>Edit Membership Organization</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit membership organization</div>
					<div class="form-group">
						<label for="OrganizationName" class="col-lg-5 col-md-5">Organization Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="OrganizationName" name="OrganizationName" value="#Session.getSelectedMember.OrganizationName#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="OrganizationDomainName" class="col-lg-5 col-md-5">Organization Domain Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="OrganizationDomainName" name="OrganizationDomainName" value="#Session.getSelectedMember.OrganizationDomainName#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="col-lg-5 col-md-5">Primary Voice Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" value="#Session.getSelectedMember.PrimaryVoiceNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryFaxNumber" class="col-lg-5 col-md-5">Primary Fax Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PrimaryFaxNumber" name="PrimaryFaxNumber" value="#Session.getSelectedMember.PrimaryFaxNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="col-lg-5 col-md-5">Website:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" value="#Session.getSelectedMember.BusinessWebsite#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="col-lg-5 col-md-5">Active Membership:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfselect name="Active" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.getSelectedMember.Active#" queryposition="below">
							<option value="----">Hold Current Membership Status?</option>
						</cfselect></div>
					</div>
					<fieldset>
						<legend><h2>Physical Address Location</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PhysicalAddress" class="col-lg-5 col-md-5">Physical Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.getSelectedMember.PhysicalAddress#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="col-lg-5 col-md-5">Address City:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.getSelectedMember.PhysicalCity#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="col-lg-5 col-md-5">Address State:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.getSelectedMember.PhysicalState#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="col-lg-5 col-md-5">Address ZipCode:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfif LEN(Session.getSelectedMember.PhysicalZip4)>
							<cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.getSelectedMember.PhysicalZipCode#-#Session.getSelectedMember.PhysicalZip4#" required="no">
						<cfelse>
							<cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.getSelectedMember.PhysicalZipCode#" required="no">
						</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Mailing Address (if applicible)</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MailingAddress" class="col-lg-5 col-md-5">Mailing Address:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="MailingAddress" name="MailingAddress" value="#Session.getSelectedMember.MailingAddress#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingCity" class="col-lg-5 col-md-5">Mailing City:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="MailingCity" name="MailingCity" value="#Session.getSelectedMember.MailingCity#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingState" class="col-lg-5 col-md-5">Mailing State:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="MailingState" name="MailingState" value="#Session.getSelectedMember.MailingState#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="MailingZipCode" class="col-lg-5 col-md-5">Mailing ZipCode:&nbsp;</label>
						<div class="col-sm-7"><cfif LEN(Session.getSelectedMember.MailingZip4)>
							<cfinput type="text" class="form-control" id="MailingZipCode" name="MailingZipCode" value="#Session.getSelectedMember.MailingZipCode#-#Session.getSelectedMember.MailingZip4#" required="no">
						<cfelse>
							<cfinput type="text" class="form-control" id="MailingZipCode" name="MailingZipCode" value="#Session.getSelectedMember.MailingZipCode#" required="no">
						</cfif></div>
					</div>
					<fieldset>
						<legend><h2>Account Payable Individual Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="APContactName" class="col-lg-5 col-md-5">Contact Person's Name:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="APContactName" name="APContactName" value="#Session.getSelectedMember.AccountsPayable_ContactName#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="APContactEmail" class="col-lg-5 col-md-5">Contact Email:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="APContactEmail" name="APContactEmail" value="#Session.getSelectedMember.AccountsPayable_EmailAddress#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="ReceiveInvoicesByEmail" class="col-lg-5 col-md-5">Receive Invoices By Email:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfselect name="ReceiveInvoicesByEmail" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.getSelectedMember.ReceiveInvoicesByEmail#" queryposition="below">
							<option value="----">Send Invoices by Email?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Membership Listing">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Member Information"><br /><br />
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
						<legend><h2>Add New Membership Organization</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add new membership organization</div>
					<div class="form-group">
						<label for="OrganizationName" class="col-lg-5 col-md-5">Organization Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="OrganizationName" name="OrganizationName" value="#Session.FormInput.OrganizationName#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="OrganizationDomainName" class="col-lg-5 col-md-5">Organization Domain Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="OrganizationDomainName" name="OrganizationDomainName" value="#Session.FormInput.OrganizationDomainName#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="col-lg-5 col-md-5">Primary Voice Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" value="#Session.FormInput.PrimaryVoiceNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryFaxNumber" class="col-lg-5 col-md-5">Primary Fax Number:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="PrimaryFaxNumber" name="PrimaryFaxNumber" value="#Session.FormInput.PrimaryFaxNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="col-lg-5 col-md-5">Website:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" value="#Session.FormInput.BusinessWebsite#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="col-lg-5 col-md-5">Active Membership:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfselect name="Active" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.Active#" queryposition="below">
							<option value="----">Hold Current Membership Status?</option>
						</cfselect></div>
					</div>
					<fieldset>
						<legend><h2>Physical Address Location</h2></legend>
					</fieldset>
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
					<fieldset>
						<legend><h2>Mailing Address (if applicible)</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MailingAddress" class="col-lg-5 col-md-5">Mailing Address:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="MailingAddress" name="MailingAddress" value="#Session.FormInput.MailingAddress#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingCity" class="col-lg-5 col-md-5">Mailing City:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="MailingCity" name="MailingCity" value="#Session.FormInput.MailingCity#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="MailingState" class="col-lg-5 col-md-5">Mailing State:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="MailingState" name="MailingState" value="#Session.FormInput.MailingState#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="MailingZipCode" class="col-lg-5 col-md-5">Mailing ZipCode:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="MailingZipCode" name="MailingZipCode" value="#Session.FormInput.MailingZipCode#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Account Payable Individual Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="APContactName" class="col-lg-5 col-md-5">Contact Person's Name:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="APContactName" name="APContactName" value="#Session.FormInput.APContactName#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="APContactEmail" class="col-lg-5 col-md-5">Contact Email:&nbsp;</label>
						<div class="col-sm-7"><cfinput type="text" class="form-control" id="APContactEmail" name="APContactEmail" value="#Session.FormInput.APContactEmail#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="ReceiveInvoicesByEmail" class="col-lg-5 col-md-5">Receive Invoices By Email:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7"><cfselect name="ReceiveInvoicesByEmail" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.FormInput.ReceiveInvoicesByEmail#" Display="OptionName" queryposition="below">
							<option value="----">Send Invoices by Email?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Membership Listing">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Member Information"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
