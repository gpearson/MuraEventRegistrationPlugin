<cfif not isDefined("URL.FormRetry") and not isDefined("URL.Key")>
	<cfoutput>
		<cfset captcha = #Session.Captcha#>
		<cfset captchaHash = Hash(captcha)>
		<cfform action="" method="post" id="ForgotPasswordForm" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="CaptchaEncrypted" value="#Variables.CaptchaHash#">
			<cfinput type="hidden" name="HumanValidation" value="#Variables.Captcha#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<legend>Retrieve Lost Password</legend>
					</fieldset>
					<div class="well">Please enter your school/business email address and this system will send a special link to you.</div>
					<div class="form-group">
						<label for="EmailAddress" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="Email" name="Email" required="yes"></div>
					</div>
					<div class="panel-heading"><h2>Account Security</h2></div>
					<div class="form-group">
						<label for="HumanChecker" class="control-label col-sm-3">In order to prevent abuse from automatic systems, please type the letters or numbers in the box below:&nbsp;</label>
						<div class="col-sm-6">
							<cfimage action="captcha" difficulty="medium" text="#captcha#" fonts="arial,times roman, tahoma" height="150" width="500" /><br><br />
							<cfinput name="ValidateCaptcha" type="text" required="yes" message="Input Captcha Text" />
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Retrieve Password"><br /><br />
				</div>
			</div>
		</cfform>
	</cfoutput>
<cfelseif isDefined("URL.FormRetry") and not isDefined("URL.Key")>
	<cfoutput>
		<cfform action="" method="post" id="ForgotPasswordForm" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="CaptchaEncrypted" value="#Session.FormData.CaptchaEncrypted#">
			<cfinput type="hidden" name="HumanValidation" value="#Session.FormData.HumanValidation#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfif isDefined("Session.FormErrors")>
					<cfif ArrayLen(Session.FormErrors)>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Missing Information to Request Password Reset</h3>
								</div>
								<div class="modal-body">
									<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
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
								///////////////

								// method to open modal
								function openModal(){
									vm.modal.modal('show');
								}

								// method to close modal
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
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<legend>Retrieve Lost Password</legend>
					</fieldset>
					<div class="well">Please enter your school/business email address and this system will send a special link to you.</div>
					<div class="form-group">
						<label for="EmailAddress" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="Email" name="Email" required="yes" value="#Session.FormData.Email#"></div>
					</div>
					<div class="panel-heading"><h2>Account Security</h2></div>
					<div class="form-group">
						<label for="HumanChecker" class="control-label col-sm-3">In order to prevent abuse from automatic systems, please type the letters or numbers in the box below:&nbsp;</label>
						<div class="col-sm-6">
							<cfimage action="captcha" difficulty="medium" text="#Session.FormData.HumanValidation#" fonts="arial,times roman, tahoma" height="150" width="500" /><br><br />
							<cfinput name="ValidateCaptcha" type="text" required="yes" message="Input Captcha Text" />
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Retrieve Password"><br /><br />
				</div>
			</div>
		</cfform>
		<div id="eventPGPCertificate" class="modal fade">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
						<h3>Event Attribute</h3>
					</div>
					<div class="modal-body">
						<p>Upon successfull completion of this event, Professional Growth Certificates will be sent to you via the registered email address this system has on file for you.</p>
					</div>
					<div class="modal-footer">
						<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
					</div>
				</div><!-- /.modal-content -->
			</div><!-- /.modal-dialog -->
		</div><!-- /.modal -->
	</cfoutput>
<cfelseif not isDefined("URL.FormRetry") and isDefined("URL.Key")>
	<cfoutput>
		<cfform action="" method="post" id="ForgotPasswordForm" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="UserID" value="#Session.PasswordKey.UserID#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="submitPasswordChange" value="true">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<legend>Create New Password</legend>
					</fieldset>
					<div class="well">Please enter a new password in the fields below and click the Change Password Button</div>
					<div class="form-group">
						<label for="DesiredPassword" class="control-label col-sm-3">Desired Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="DesiredPassword" name="DesiredPassword" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" required="yes"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Change Password"><br /><br />
				</div>
			</div>
		</cfform>
	</cfoutput>
<cfelseif isDefined("URL.FormRetry") and isDefined("URL.Key")>
	<cfoutput>
		<cfform action="" method="post" id="ForgotPasswordForm" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="UserID" value="#Session.PasswordKey.UserID#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="submitPasswordChange" value="true">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<legend>Create New Password</legend>
					</fieldset>
					<div class="well">Please enter a new password in the fields below and click the Change Password Button</div>
					<div class="form-group">
						<label for="DesiredPassword" class="control-label col-sm-3">Desired Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="DesiredPassword" name="DesiredPassword" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" required="yes"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Change Password"><br /><br />
				</div>
			</div>
		</cfform>
	</cfoutput>
</cfif>