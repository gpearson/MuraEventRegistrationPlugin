<cfsilent>
	<!---
		This file is part of MuraFW1

		Copyright 2010-2015 Stephen J. Withington, Jr.
		Licensed under the Apache License, Version v2.0
		http://www.apache.org/licenses/LICENSE-2.0
	--->
	<cfif Session.Mura.IsLoggedIn EQ True>
		<cfparam name="Session.Mura.EventCoordinatorRole" default="0" type="boolean">
		<cfparam name="Session.Mura.EventPresenterRole" default="0" type="boolean">
		<cfparam name="Session.Mura.SuperAdminRole" default="0" type="boolean">
		<cfset UserMembershipQuery = #$.currentUser().getMembershipsQuery()#>
		<cfloop query="#Variables.UserMembershipQuery#">
			<cfif UserMembershipQuery.GroupName EQ "Event Facilitator"><cfset Session.Mura.EventCoordinatorRole = true></cfif>
			<cfif UserMembershipQuery.GroupName EQ "Event Presentator"><cfset Session.Mura.EventPresenterRole = true></cfif>
		</cfloop>
		<cfif Session.Mura.Username EQ "admin"><cfset Session.Mura.SuperAdminRole = true></cfif>
		<cfif Session.Mura.EventCoordinatorRole EQ "True"><cfoutput>#Variables.this.redirect("eventcoord:main.default")#</cfoutput></cfif>
		<cfif Session.Mura.SuperAdminRole EQ "true"><cfoutput>#Variables.this.redirect("siteadmin:main.default")#</cfoutput></cfif>

		<cfif isDefined("Session.UserRegistrationInfo")>
			<cfif DateDiff("n", Session.UserRegistrationInfo.DateRegistered, Now()) LTE 15>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&EventID=#Session.UserRegistrationInfo.EventID#" addtoken="false">
			<cfelse>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.UserRegistrationInfo.EventID#" addtoken="false">
			</cfif>
		</cfif>
	<cfelse>
		<cfparam name="Session.Mura.EventCoordinatorRole" default="0" type="boolean">
		<cfparam name="Session.Mura.EventPresenterRole" default="0" type="boolean">
		<cfparam name="Session.Mura.SuperAdminRole" default="0" type="boolean">
	</cfif>
</cfsilent>
<cfoutput>
	<cfif isDefined("URL.UserAction")>
		<cfswitch expression="#URL.UserAction#">
			<cfcase value="PasswordChanged">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Password Changed Successfully</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">The password on the selected account has been changed sucessfully. You can now login with the username and new password to register for upcoming events/workshops.</p>
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
			</cfcase>
			<cfcase value="UserProfileUpdated">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>User Account Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">The account changed which you have made where updated successfully. We appriciate you keeping your information up to date and current.</p>
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
			</cfcase>
			<cfcase value="PasswordNotChanged">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Password Not Changed</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">The password on the selected account has not been changed due to an error.</p>
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
			</cfcase>
			<cfcase value="PasswordTimeExpired">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Password Reset Request Expired</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">Time has expired on the password reset request and no changes to the account has been done.</p>
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
			</cfcase>
			<cfcase value="WrongInformationRequest">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Invalid Information Passed</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">Something went wrong with the Link which was clicked on. Please visit the link again</p>
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
			</cfcase>
			<cfcase value="PasswordRequestSent">
				<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Password Request Sent</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-success">The special link to request password request has been sent to the email address we have on file for the account you entered.</p>
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
			</cfcase>
			<cfcase value="UserRegistration">
				<cfif URL.Successfull EQ "true">
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Account Successfully Created</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-success">You have successfully registered an account on this system. Within a few minutes, you will receive an email with a link to activate your account. You will not be able to login to this system or register for events until your account has been activated.</p>
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
				<cfelse>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Account Error - Not Created</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">Something happened during the registration process. Please contact us so that we can resolve the system error</p>
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
			</cfcase>
			<cfcase value="UserActivated">
				<cfif URL.Successfull EQ "true">
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Account Activated</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-success">You have successfully activated your account on this system. You may now login and register for any upcoming events or workshops.</p>
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
				<cfelse>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Account Error - Not Activated</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">Something happened during the registration process. Please contact us so that we can resolve the system error</p>
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
			</cfcase>
			<cfcase value="UserRegistered">
				<cfif isDefined("URL.SingleRegistration")>
					<cfif URL.SingleRegistration EQ "True">
						<div id="modelWindowDialog" class="modal fade">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
										<h3>Account Registered Successfully</h3>
									</div>
									<div class="modal-body">
										<p class="alert alert-success">You have successfully registered for '#Session.getSelectedEvent.ShortTitle#' (#dateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#) . You will receive a registration confirmation email shortly.</p>
									</div>
									<div class="modal-footer">
										<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
									</div>
								</div>
							</div>
						</div>
					</cfif>
				</cfif>
				<cfif isDefined("URL.MultipleRegistration")>
					<cfif URL.MultipleRegistration EQ "True">
						<div id="modelWindowDialog" class="modal fade">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
										<h3>Selected Individual(s) Registered Successfully</h3>
									</div>
									<div class="modal-body">
										<p class="alert alert-success">You have successfully registered the selected individual(s) for '#Session.getSelectedEvent.ShortTitle#' (#dateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#). Each individual will receive a registration confirmation email shortly.</p>
									</div>
									<div class="modal-footer">
										<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
									</div>
								</div>
							</div>
						</div>
					</cfif>
				</cfif>
				<cfset temp = StructDelete(Session, "getSelectedEvent")>
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
			</cfcase>
		</cfswitch>
	</cfif>


	<div class="panel panel-default">
		<div class="panel-body">
			<fieldset>
				<legend><h2>Calendar of Events</h2></legend>
			</fieldset>
			<cfif Session.getFeaturedEvents.RecordCount>
				<cfdump var="#Session.getFeaturedEvents#">
			</cfif>

			<cfif Session.getNonFeaturedEvents.RecordCount>
				<table class="table table-striped table-bordered">
					<thead class="thead-default">
						<tr>
							<th width="50%">Event Title</th>
							<th width="15%">Event Date</th>
							<th width="20%">Event Actions</th>
							<th width="15%">Event Attributes</th>
						</tr>
					</thead>
					<tbody>
						<cfloop query="#Session.getNonFeaturedEvents#">
							<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select Count(TContent_ID) as CurrentNumberofRegistrations
								From p_EventRegistration_UserRegistrations
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									EventID = <cfqueryparam value="#Session.getNonFeaturedEvents.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfset EventSeatsLeft = #Session.getNonFeaturedEvents.MaxParticipants# - #getCurrentRegistrationsbyEvent.CurrentNumberofRegistrations#>
							<tr>
								<td>#Session.getNonFeaturedEvents.ShortTitle#<cfif LEN(Session.getNonFeaturedEvents.Presenters)><cfquery name="getPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select FName, LName From tusers where UserID = <cfqueryparam value="#Session.getNonFeaturedEvents.Presenters#" cfsqltype="cf_sql_varchar"></cfquery><br><em>Presenter: #getPresenter.FName# #getPresenter.Lname#</em></cfif></td>
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
									<cfif Session.getNonFeaturedEvents.AcceptRegistrations EQ 1>
										<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-small" alt="Event Information">More Info</a>
										<cfif Variables.EventSeatsLeft GTE 1 and DateDiff("d", Now(), Session.getNonFeaturedEvents.Registration_Deadline) GTE 0>
											| <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-small" alt="Register Event">Register</a>
										</cfif>
									<CFELSE>
										<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-small" alt="Event Information">More Info</a>
									</cfif>
								</td>
								<td><cfif Session.getNonFeaturedEvents.PGPAvailable EQ 1><a href="##eventPGPCertificate" data-toggle="modal"><img src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/images/award.png" alt="PGP Certificate" border="0"></cfif><cfif Session.getNonFeaturedEvents.AllowVideoConference EQ 1 or Session.getNonFeaturedEvents.WebinarAvailable EQ 1><img src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/images/wifi.png" "Online Learning" border="0"></a></cfif></td>
							</tr>
						</cfloop>
					</tbody>
					<tfoot>
						<tr>
							<td></td>
							<td></td>
						</tr>
					</tfoot>
				</table>
			</cfif>
		</div>
		<div class="panel-footer">
			<table class="table">
				<tr>
					<td style="vertical-align:top; font-family: Arial; font-size:24px; font-weight:bold;">Legend:</td>
					<td>Greyed out Event Dates have already passed. If event does not display a Register button, the online registration deadline has passed.<br><br>Please contact #rc.$.siteConfig('site')# at #rc.$.siteConfig('ContactEmail')# or #rc.$.siteConfig('ContactPhone')# to check availablity for the event.<hr><a href="##eventPGPCertificate" data-toggle="modal"><img src="/plugins/#HTMLEditFormat(rc.pc.getPackage())#/includes/assets/images/award.png" alt="PGP Certificate" border="0"></a> = PGP Certificate Available</td>
				</tr>
			</table>
		</div>
	</div>

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