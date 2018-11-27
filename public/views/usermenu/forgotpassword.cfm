<cfsilent>
	<cfset BestContactMethodQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
	<cfset temp = QueryAddRow(BestContactMethodQuery, 1)>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "ID", 0)#>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "OptionName", "By Email")#>
	<cfset temp = QueryAddRow(BestContactMethodQuery, 1)>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "ID", 1)#>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "OptionName", "By Telephone")#>
	<cfif not isDefined("Session.PluginFramework")>
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cfset Session.PluginFramework = StructCopy(Variables.Framework)>
		</cflock>
	</cfif>
</cfsilent>
<cfoutput>
	<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
		<cfscript>lang = 'en';</cfscript>
		<cfsavecontent variable="htmlhead"><cfoutput><script src='https://www.google.com/recaptcha/api.js?h1=#lang#'></script></cfoutput></cfsavecontent>
		<cfhtmlhead text="#htmlhead#" />
	</cfif>
	<cfif Session.Mura.IsLoggedIn EQ True><cfset userRecord = #rc.$.getBean('user').loadBy(username='#Session.Mura.Username#', siteid='#rc.$.siteConfig("siteid")#').getAllValues()#></cfif>

	<cfform action="" method="post" id="ContactUsForm" class="form-horizontal">
		<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
		<cfinput type="hidden" name="formSubmit" value="true">
		<cfif isDefined("URL.FormRetry")>
			<cfswitch expression="#URL.UserAction#">
				<cfcase value="PasswordMissing">
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Password Fields Missing</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">Please enter the password which you would like to use for your account. It appears that the password fields were left blank and did not have any characters entered within it.</p>
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
				<cfcase value="PasswordMismatch">
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Password Fields Mismatch</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">The password field and the verify password field did not match each other. Please make the necessary changes so your account can be updated with a verified password.</p>
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
				<cfcase value="CaptchaWrong">

				</cfcase>
				<cfcase value="InvalidEmailAddress">
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Email Address wrong format</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">Please check the email address entered as it appears to not be in the correct email format.</p>
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
				<cfcase value="UserAccountNotFound">
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Account Not Located</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">Please check the email address entered as an account was not located within the users table of this system.</p>
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
		<cfif not isDefined("URL.Key")>
			<div class="panel panel-default">
				<div class="panel-heading"><h2>Request New Temporary Password</h2></div>
				<br />
				<div class="alert alert-info">Please enter the email address which was used to register for an account on this system. An email will be sent with a special link before the system will generate a new temporary password for this account.</div>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Your Contact Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EmailAddress" class="control-label col-sm-3">Email Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-9">
							<cfif isDefined("URL.FormRetry")>
								<cfinput type="text" class="form-control" id="UserEmailAddress" name="UserEmailAddress" value="#Session.FormInput.USerEmailAddress#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="UserEmailAddress" name="UserEmailAddress" required="no">
							</cfif>
						</div>
					</div>
					<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
						<fieldset>
							<legend><h2>Human Detection</h2></legend>
						</fieldset>
						<div class="form-group">
							<div class="col-sm-12">
								<div class="g-recaptcha" data-sitekey="#Session.SiteConfigSettings.Google_ReCaptchaSiteKey#"></div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-left" value="Back to Current Events">&nbsp;
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-right" value="Send Temporary Password"><br /><br />
				</div>
			</div>
		<cfelseif isDefined("URL.Key") and isDefined("Session.PasswordKey")>
			<cfinput type="hidden" name="UserID" value="#Session.PasswordKey.UserID#">
			<div class="panel panel-default">
				<div class="panel-heading"><h2>Set New Account Password</h2></div>
				<br />
				<div class="alert alert-info">Please enter the password which you would like to use for your account.</div>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Contact Password Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Password" class="control-label col-sm-4">Desired Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6">
							<cfif isDefined("URL.FormRetry")>
								<cfinput type="password" class="form-control" id="Password" name="Password" value="#Session.FormInput.Password#" required="no">
							<cfelse>
								<cfinput type="password" class="form-control" id="Password" name="Password" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-4">Verify Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6">
							<cfif isDefined("URL.FormRetry")>
								<cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" value="#Session.FormInput.VerifyPassword#" required="no">
							<cfelse>
								<cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" required="no">
							</cfif>
						</div>
					</div>
					<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
						<fieldset>
							<legend><h2>Human Detection</h2></legend>
						</fieldset>
						<div class="form-group">
							<div class="col-sm-12">
								<div class="g-recaptcha" data-sitekey="#Session.SiteConfigSettings.Google_ReCaptchaSiteKey#"></div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-left" value="Back to Current Events">&nbsp;
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-right" value="Change Account Password"><br /><br />
				</div>
			</div>
		</cfif>
	</cfform>

	<!--- 

	<cfif not isDefined("URL.FormRetry") and not isDefined("URL.ShortURL") and not isDefined("URL.Key")>
		
			
				
				
					
					
						
					</cfif>
				
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry") and not isDefined("URL.ShortURL") and not isDefined("URL.Key")>
		<div class="panel panel-default">
			<div class="panel-heading"><h2>Request Forgot Password</h2></div>
			<cfform action="" method="post" id="ContactUsForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
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
				<br />
				<div class="alert alert-info">Please enter the email address registered for your account to request a temporary password to be sent to you.</div>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Your Contact Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EmailAddress" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-9">
							<cfinput type="text" class="form-control" id="UserEmailAddress" name="UserEmailAddress" value="#Session.FormInput.UserEmailAddress#" required="no">
						</div>
					</div>
					<cfif Session.SiteConfigSettings.Google_ReCaptchaEnabled EQ 1>
						<fieldset>
							<legend><h2>Human Detection</h2></legend>
						</fieldset>
						<div class="form-group">
							<div class="col-sm-12">
								<div class="g-recaptcha" data-sitekey="#Session.SiteConfigSettings.Google_ReCaptchaSiteKey#"></div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-left" value="Back to Current Events">&nbsp;
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-right" value="Send Temporary Password"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif not isDefined("URL.FormRetry") and not isDefined("URL.ShortURL") and isDefined("URL.Key")>
		<div class="panel panel-default">
			<div class="panel-heading"><h2>User Account Desired Password</h2></div>
			<cfform action="" method="post" id="ContactUsForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="UserID" value="#Session.PasswordKey.UserID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="formUpdateAccountPassword" value="true">
				<br />
				<div class="alert alert-info">Please enter the desired password which you would like to use for your account.</div>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Your New Account Password Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="NewPassword" class="control-label col-sm-3">Desired Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-9">
							<cfinput type="password" class="form-control" id="NewPassword" name="NewPassword" required="no">
						</div>
					</div>
					<div class="form-group">
						<label for="NewVerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-9">
							<cfinput type="password" class="form-control" id="NewVerifyPassword" name="NewVerifyPassword" required="no">
						</div>
					</div>
					<cfif Session.SiteConfigSettings.Google_ReCaptchaEnabled EQ 1>
						<fieldset>
							<legend><h2>Human Detection</h2></legend>
						</fieldset>
						<div class="form-group">
							<div class="col-sm-12">
								<div class="g-recaptcha" data-sitekey="#Session.SiteConfigSettings.Google_ReCaptchaSiteKey#"></div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-left" value="Back to Current Events">&nbsp;
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-right" value="Update Account Password"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry") and not isDefined("URL.ShortURL") and isDefined("URL.Key")>
		<div class="panel panel-default">
			<div class="panel-heading"><h2>User Account Desired Password</h2></div>
			<cfform action="" method="post" id="ContactUsForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="UserID" value="#Session.PasswordKey.UserID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="formUpdateAccountPassword" value="true">
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
				<br />
				<div class="alert alert-info">Please enter the desired password which you would like to use for your account.</div>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Your New Account Password Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="NewPassword" class="control-label col-sm-3">Desired Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-9">
							<cfinput type="password" class="form-control" id="NewPassword" name="NewPassword" value="#Session.FormInput.NewPassword#" required="no">
						</div>
					</div>
					<div class="form-group">
						<label for="NewVerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-9">
							<cfinput type="password" class="form-control" id="NewVerifyPassword" name="NewVerifyPassword" value="#Session.FormInput.NewVerifyPassword#" required="no">
						</div>
					</div>
					<cfif Session.SiteConfigSettings.Google_ReCaptchaEnabled EQ 1>
						<fieldset>
							<legend><h2>Human Detection</h2></legend>
						</fieldset>
						<div class="form-group">
							<div class="col-sm-12">
								<div class="g-recaptcha" data-sitekey="#Session.SiteConfigSettings.Google_ReCaptchaSiteKey#"></div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-left" value="Back to Current Events">&nbsp;
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-right" value="Update Account Password"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
--->
</cfoutput>