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
				<cfinput type="hidden" name="UserID" value="#Session.FormInput.UserID#">
				<cfinput type="hidden" name="UserName" value="#Session.getSelectedUser.UserName#">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Change Account Holder's Password</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Account Holder</div>
					<div class="form-group">
						<label for="FirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FName" name="FName" value="#Session.getSelectedUser.FName#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="LName" name="LName" value="#Session.getSelectedUser.LName#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Email" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Email" name="Email" value="#Session.getSelectedUser.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Username" class="control-label col-sm-3">Username:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="UserName" name="UserName" value="#Session.getSelectedUser.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Company" class="control-label col-sm-3">Company:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Company" name="Company" value="#Session.getSelectedUser.Company#" disabled="No"></div>
					</div>
					<div class="form-group">
						<label for="JobTitle" class="control-label col-sm-3">Job Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="JobTitle" name="JobTitle" value="#Session.getSelectedUser.JobTitle#" disabled="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-3">Mobile Phone:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" value="#Session.getSelectedUser.mobilePhone#" disabled="no"></div>
					</div>
					<div class="form-group">
						<label for="InActive" class="control-label col-sm-3">Account InActive:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="InActive" class="form-control" disabled="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedUser.InActive#" Display="OptionName" queryposition="below">
							<option value="----">Account InActive?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="Password" class="control-label col-sm-3">Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="Password" name="Password" required="no"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" required="no"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Change Account Password"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="UserID" value="#Session.FormInput.UserID#">
				<cfinput type="hidden" name="UserName" value="#Session.getSelectedUser.UserName#">
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
						<legend><h2>Change Account Holder's Password</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Account Holder</div>
					<div class="form-group">
						<label for="FirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FName" name="FName" value="#Session.getSelectedUser.FName#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="LName" name="LName" value="#Session.getSelectedUser.LName#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Email" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Email" name="Email" value="#Session.getSelectedUser.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Username" class="control-label col-sm-3">Username:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="UserName" name="UserName" value="#Session.getSelectedUser.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Company" class="control-label col-sm-3">Company:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Company" name="Company" value="#Session.getSelectedUser.Company#" disabled="No"></div>
					</div>
					<div class="form-group">
						<label for="JobTitle" class="control-label col-sm-3">Job Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="JobTitle" name="JobTitle" value="#Session.getSelectedUser.JobTitle#" disabled="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-3">Mobile Phone:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" value="#Session.getSelectedUser.mobilePhone#" disabled="no"></div>
					</div>
					<div class="form-group">
						<label for="InActive" class="control-label col-sm-3">Account InActive:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="InActive" class="form-control" disabled="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedUser.InActive#" Display="OptionName" queryposition="below">
							<option value="----">Account InActive?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="Password" class="control-label col-sm-3">Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="Password" name="Password" value="#Session.FormInput.Password#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" value="#Session.FormInput.VerifyPassword#" required="no"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Change Account Password"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
