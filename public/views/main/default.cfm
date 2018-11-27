<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2016 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
	<cfscript>
		request.layout = true;
	</cfscript>
</cfsilent>
<cfoutput>
	<cfif isDefined("URL.UserAction")>
		<cfswitch expression="#URL.UserAction#">
			<cfcase value="AccountPasswordChanged">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Account Password Changed</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">The Password has been updated for the account. You will now be able to login with your email address and the recent password entered to login to the account.</p>
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
			</cfcase>
			<cfcase value="PasswordResetTimeExpired">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Password Reset Request Time Expired</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-danger">The Password Reset Request Link has expired due to being longer than 45 minutes between the time someone requested it and it was clicked. No changes to the current account has been completed. If you would like to reset your password please visit the Forgot Password Link under Home and enter your email address.</p>
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
			</cfcase>
			<cfcase value="PasswordLinkSent">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Email Sent - Special Password Reset Request</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">This system is in the process of sending the email address entered a special link to verify you are the holder of this email address. Please check your 'Spam' or 'Junk' folders if you did not receive this message within 10 minutes. The email message will be from #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')#. When you receive this email message, simply click on the link for the system to generate a temporary password.</p>
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
			</cfcase>
			<cfcase value="VerifyAccount">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Invalid Email Address Entered</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully created an account on this website. The system is in the process of sending you a special link to activate your account. Please check your 'Spam' or 'Junk' folders if you did not receive this message within 10 minutes. The email message will be from #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')#.</p>
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
			</cfcase>
			<cfcase value="UserActivated">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Account Activated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully activated your account for this website. The system is in the process of sending you an confirmation of this action to your email address. Please check your 'Spam' or 'Junk' folders if you did not receive this message within 10 minutes. The email message will be from #rc.$.siteConfig('ContactName')# at #rc.$.siteConfig('ContactEmail')#.</p>
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
			</cfcase>
			<cfcase value="ShortLinkInvalid">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Link was not valid</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-danger">You have clicked on a link which was not valid for one reason or another. If this message was a result of an email message you received, please check your email again to make sure the link is correct. If you have any questions or concerns about this error message, please utilize the Contact Us link on our website to reach out to us.</p>
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
			</cfcase>
		</cfswitch>
	</cfif>

	<cfif isDefined("URL.SentInquiry")>
		<cfswitch expression="#URL.SentInquiry#">
			<cfcase value="True">
				<div class="panel panel-success">
					<div class="panel-heading"><h3>Your Inquiry has been sent</h3></div>
					<div class="panel-body alert alert-success">
						<p>Your Inquiry has been sent to someone that is able to answer it. Depending on your contact method, you should receive a repsonse to your inquiry within 3 business days.</p>
					</div>
				</div>
			</cfcase>
			<cfcase value="False">

			</cfcase>
		</cfswitch>
	</cfif>
	<cfif isDefined("URL.UserAction")>
		<cfswitch expression="#URL.UserAction#">
			<cfcase value="PasswordRequestSent">
				<div class="panel panel-success">
					<div class="panel-heading"><h3>Password Reset Request Submitted</h3></div>
					<div class="panel-body alert alert-success">
						<p>The password reset inquiry has been submitted. Within the next few minutes you will be receiving a special link to reset your password. If you do not receive this message please check your Junk or Spam folder for a message from our server. If you are having isuses with this password reset, please contact our office.</p>
					</div>
				</div>
			</cfcase>
			<cfcase value="PasswordResetSuccessfully">
				<div class="panel panel-success">
					<div class="panel-heading"><h3>Password Reset Successfully</h3></div>
					<div class="panel-body alert alert-success">
						<p>The password reset has been saved to the user account entered. You will now have the ability to login to this system with your username and current password. If you have any issues please contact our office.</p>
					</div>
				</div>
			</cfcase>
			<cfcase value="PasswordRequestFailed">
				<div class="panel panel-danger">
					<div class="panel-heading"><h3>Password Reset Request Failed</h3></div>
					<div class="panel-body alert">
						<p>#Session.FormErrors[1].Message#</p>
					</div>
				</div>
			</cfcase>
			<cfcase value="PasswordTimeExpired">
				<div class="panel panel-danger">
					<div class="panel-heading"><h3>Password Reset Request Expired</h3></div>
					<div class="panel-body alert">
						<p>#Session.FormErrors[1].Message#</p>
					</div>
				</div>
			</cfcase>
		</cfswitch>

	</cfif>
	<div class="panel panel-default">
		<div class="panel-heading"><h3>Available Events</h3></div>
		<div class="panel-body">
			
		</div>
	</div>
</cfoutput>