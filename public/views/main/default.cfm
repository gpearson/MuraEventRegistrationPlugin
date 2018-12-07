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
	<cfif isDefined("URL.RegistrationCancelled")>
		<div id="modelWindowDialog" class="modal fade">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
						<h3>Registraton Cancelled</h3>
					</div>
					<div class="modal-body">
						<p class="alert alert-success">Registration for the Event/Workshop has been cancelled. Within the next few minutes an email will be sent to the email address we have on file outlining this action. If user has not received it, please check the Spam/Junk Folders.</p>
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
	<cfif isDefined("URL.UserAction")>
		<cfswitch expression="#URL.UserAction#">
			<cfcase value="UserRegistered">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Registered for Event/Workshop</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">Registration for the Event/Workshop was successful. Within the next few minutes those registered will be receiving an email confirmation at the email address on file. If user has not received it, please check the Spam/Junk Folders.</p>
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
								<h3>Email Address Registered</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully created an account on this website. The system is in the process of sending you a special link to activate your account. Please check your 'Spam' or 'Junk' folders if you did not receive this message within 10 minutes. The email message will be from #rc.$.siteConfig('ContactEmail')#.</p>
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
								<p class="alert alert-success">You have successfully activated your account for this website. The system is in the process of sending you a confirmation to your email address. Please check your 'Spam' or 'Junk' folders if you do not receive this message within 10 minutes. The email message will be from #rc.$.siteConfig('ContactEmail')#.</p>
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
			<cfif Session.getNonFeaturedEvents.RecordCount>
				<table class="table table-striped table-bordered">
					<thead class="thead-default">
						<tr>
							<th width="50%">Event Title</th>
							<th width="12%">Event Date</th>
							<th width="26%">Event Actions</th>
							<th width="12%">Event Attributes</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="#Session.getNonFeaturedEvents#">
							<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select Count(TContent_ID) as CurrentNumberofRegistrations
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									Event_ID = <cfqueryparam value="#Session.getNonFeaturedEvents.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfset EventSeatsLeft = #Session.getNonFeaturedEvents.Event_MaxParticipants# - #getCurrentRegistrationsbyEvent.CurrentNumberofRegistrations#>
							<tr>
								<td>#Session.getNonFeaturedEvents.ShortTitle#<cfif LEN(Session.getNonFeaturedEvents.PresenterID)><cfquery name="getPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select FName, LName From tusers where UserID = <cfqueryparam value="#Session.getNonFeaturedEvents.PresenterID#" cfsqltype="cf_sql_varchar"></cfquery><br><em>Presenter: #getPresenter.FName# #getPresenter.Lname#</em></cfif></td>
								<td>
									<cfif LEN(Session.getNonFeaturedEvents.EventDate) and LEN(Session.getNonFeaturedEvents.EventDate1) or LEN(Session.getNonFeaturedEvents.EventDate2) or LEN(Session.getNonFeaturedEvents.EventDate3) or LEN(Session.getNonFeaturedEvents.EventDate4)>
										<cfif DateDiff("d", Now(), Session.getNonFeaturedEvents.EventDate) LT 0>
											<div style="Color: ##CCCCCC;">#DateFormat(Session.getNonFeaturedEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.getNonFeaturedEvents.EventDate, "ddd")#)</div>
										<cfelse>
											#DateFormat(Session.getNonFeaturedEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.getNonFeaturedEvents.EventDate, "ddd")#)<br>
										</cfif>
										<cfif LEN(Session.getNonFeaturedEvents.EventDate1)>
											<cfif DateDiff("d", Now(), Session.getNonFeaturedEvents.EventDate1) LT 0>
												<div style="Color: ##AAAAAA;">#DateFormat(Session.getNonFeaturedEvents.EventDate1, "mm/dd/yyyy")# (#DateFormat(Session.getNonFeaturedEvents.EventDate1, "ddd")#)</div>
											<cfelse>
												#DateFormat(Session.getNonFeaturedEvents.EventDate1, "mm/dd/yyyy")# (#DateFormat(Session.getNonFeaturedEvents.EventDate1, "ddd")#)<br>
											</cfif>
										</cfif>
										<cfif LEN(Session.getNonFeaturedEvents.EventDate2)>
											<cfif DateDiff("d", Now(), Session.getNonFeaturedEvents.EventDate2) LT 0>
												<div class="text-danger">#DateFormat(Session.getNonFeaturedEvents.EventDate2, "mm/dd/yyyy")# (#DateFormat(Session.getNonFeaturedEvents.EventDate2, "ddd")#)</div>
											<cfelse>
												#DateFormat(Session.getNonFeaturedEvents.EventDate2, "mm/dd/yyyy")# (#DateFormat(Session.getNonFeaturedEvents.EventDate2, "ddd")#)<br>
											</cfif>
										</cfif>
										<cfif LEN(Session.getNonFeaturedEvents.EventDate3)>
											<cfif DateDiff("d", Now(), Session.getNonFeaturedEvents.EventDate3) LT 0>
												<div class="text-danger">#DateFormat(Session.getNonFeaturedEvents.EventDate3, "mm/dd/yyyy")# (#DateFormat(Session.getNonFeaturedEvents.EventDate3, "ddd")#)</div>
											<cfelse>
												#DateFormat(Session.getNonFeaturedEvents.EventDate3, "mm/dd/yyyy")# (#DateFormat(Session.getNonFeaturedEvents.EventDate3, "ddd")#)<br>
											</cfif>
										</cfif>
										<cfif LEN(Session.getNonFeaturedEvents.EventDate4)>
											<cfif DateDiff("d", Now(), Session.getNonFeaturedEvents.EventDate4) LT 0>
												<div class="text-danger">#DateFormat(Session.getNonFeaturedEvents.EventDate4, "mm/dd/yyyy")# (#DateFormat(Session.getNonFeaturedEvents.EventDate4, "ddd")#)</div>
											<cfelse>
												#DateFormat(Session.getNonFeaturedEvents.EventDate4, "mm/dd/yyyy")# (#DateFormat(Session.getNonFeaturedEvents.EventDate4, "ddd")#)
											</cfif>
										</cfif>
									<cfelse>
										#DateFormat(Session.getNonFeaturedEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.getNonFeaturedEvents.EventDate, "ddd")#)
									</cfif>
								</td>
								<td>
									<cfif Session.getNonFeaturedEvents.AcceptRegistrations EQ 1 and Session.getNonFeaturedEvents.EventCancelled EQ 0>
										<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize" alt="Event Information">More Info</a>
										<cfif Variables.EventSeatsLeft GTE 1 and DateDiff("d", Now(), Session.getNonFeaturedEvents.Registration_Deadline) GTE 0>
											| <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize" alt="Register Event">Register</a>
										</cfif>
									<CFELSEif Session.getNonFeaturedEvents.EventCancelled EQ 0>
										<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize" alt="Event Information">More Info</a>
									<cfelseif Session.getNonFeaturedEvents.EventCancelled EQ 1>
										<div style="Color: Red; font-weight: bold;">Event Cancelled</div>
									</cfif>
								</td>
								<td><cfif Session.getNonFeaturedEvents.PGPCertificate_Available EQ 1><a href="##eventPGPCertificate" data-toggle="modal"><img src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/images/award.png" alt="PGP Certificate" border="0"></cfif><cfif Session.getNonFeaturedEvents.H323_Available EQ 1 or Session.getNonFeaturedEvents.Webinar_Available EQ 1><img src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/images/wifi.png" "Online Learning" border="0"></a></cfif></td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</cfif>
		</div>
	</div>
</cfoutput>