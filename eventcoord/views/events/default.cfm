<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-body">
		<fieldset>
			<legend><h2>Available Events and/or Workshops</h2></legend>
		</fieldset>
			<cfif isDefined("Session.FormErrors")>
				<cfif ArrayLen(Session.FormErrors) GTE 1>
					<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
					<cfdump var="#Session.FormErrors#">
				</cfif>
			</cfif>
			<cfif isDefined("URL.UserAction")>
				<div class="panel-body">
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="EmailInvoicesSent">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Event Invoices Sent Electronically</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have successfully sent invoices electronically for the selected event to the responsible individuals to process the payments.</p>
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
						</cfcase>
						<cfcase value="EmailUpComingEvents">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Upcoming Event Marketing Email Sent</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have successfully sent an email with the PDF Attachment of all upcoming events currently active in the system. Depending on the number of participants, this process can take a few minutes before the email shows up in the user's inbox.</p>
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
						</cfcase>
						<cfcase value="SentPGPCertificates">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div class="alert alert-success"><p>You have successfully scheduled PGP Certificates to be sent to anyone who has attended the event. Depending on the number of PGP Certificates will depend on how fast they are electronically tramsferred to the participants inbox.</p></div>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="RemovedParticipants">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Participants have been deregistered from Event</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have successfully removed participants from the event. If you selected the option to send confirmation email messages the participant will be receiving this communication within the next few minutes.</p>
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
						</cfcase>
						<cfcase value="EmailRegistered">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Email to Participants Being Sent</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have successfully sent registered participants an email message regarding the event. The system in in process of delivering these messages and depending on how many registered participants will depend on how much time will pass</p>
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
								<cfelseif URL.Successful EQ "NotSent">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Email Participants Not Sent</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have not sent the email to those participants who were registered for the event due to selecting 'No' on the Send Email Question</p>
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
						</cfcase>
						<cfcase value="EmailAttended">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Email to Attended Participants Being Sent</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have successfully sent attended participants an email message regarding the event. The system in in process of delivering these messages and depending on how many attended participants will depend on how much time will pass</p>
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
								<cfelseif URL.Successful EQ "NotSent">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Email Attended Participants Not Sent</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have not sent the email to those participants who attended the event due to selecting 'No' on the Send Email Question</p>
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
						</cfcase>
						<cfcase value="ParticipantsRegistered">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Participants have been registered for Event</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have successfully registered participants to the event. If you selected the option to send confirmation emails they are in process to be delivered to the participants at this time.</p>
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
						</cfcase>
						<cfcase value="PostToFB">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div class="alert alert-success"><p>You have successfully posted the event to the Organization's Facebook Page</p></div>
								</cfif>
							</cfif>
						</cfcase>
						<cfcase value="EventCancelled">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "False">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Event Has Not Been Cancelled</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-info">Event was not cancelled due to selecting the 'No' option when asked if you really want to cancel this event.</p>
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
								<cfelseif URL.Successful EQ "True">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Event Has Been Cancelled</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have successfully cancelled this event and anyone who was registered for this event is receiving an email message letting them know of this action.</p>
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
						</cfcase>
						<cfcase value="EventCopied">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "False">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Event Has Not Been Copied</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-info">Event was not copied due to selecting the 'No' option when asked if you really want to copy this event to a new event.</p>
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
								<cfelseif URL.Successful EQ "True">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Event Has Been Copied</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have successfully copied the event to a new event. Make the necessary changes to the new event as necessary.</p>
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
						</cfcase>
						<cfcase value="AddedEvent">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Event Has Been Added</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have successfully added a new event to the database.</p>
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
									<cfif isDefined("URL.FacebookPost")>
										<div class="alert alert-warning"><p>The event was not posted to Facebook even though the option was selected to post this event to Facebook. Within the Site Configuration, the necessary information needed to post to Facebook was not entered.</p></div>
									</cfif>
								</cfif>
							</cfif>
						</cfcase>
					</cfswitch>
				</div>
			</cfif>
			<table class="table table-bordered table-striped">
				<cfif Session.getAvailableEvents.RecordCount>
					<thead class="thead-default">
						<tr>
							<th width="50%">Event Title</th>
							<th  width="15%">Event Date</th>
							<th>Actions</th>
						</tr>
					</thead>
					<tfoot>
						<tr>
							<td colspan="3">Add a new Event or Workshop to allow registrations not listed above by clicking <a href="#buildURL('eventcoord:events.addevent')#" class="btn btn-primary btn-small">here</a></td>
						</tr>
					</tfoot>
					<tbody>
						<cfloop query="Session.getAvailableEvents">

							<cfquery name="getRegisteredParticipantsForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								SELECT p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
									p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.OnWaitingList
								FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
								WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.RegisterForEventSessionAM = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.RegisterForEventSessionPM = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
							</cfquery>
							<cfquery name="getAttendedParticipantsForEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								SELECT p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.IVCParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4,
									p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4,
									p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
								FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.EventID
								WHERE p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.AttendedEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.AttendedEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.AttendedEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.AttendedEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.AttendedEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.AttendedEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.AttendedEventSessionAM = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> or
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.AttendedEventSessionPM = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								ORDER BY Domain ASC, tusers.Lname ASC, tusers.Fname ASC
							</cfquery>
							<cfquery name="getEventExpenses" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select TContent_ID
								From p_EventRegistration_EventExpenses
								Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
									Event_ID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfquery name="checkIncomeVerified" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select AttendeePriceVerified
								From p_EventRegistration_UserRegistrations
								Where EventID = <cfqueryparam value="#Session.getAvailableEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and
									Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
								Group by AttendeePriceVerified
							</cfquery>
							<tr <cfif Session.getAvailableEvents.Active EQ 0></cfif>>
								<td width="50%">(<a href="http://#cgi.server_name#/?Info=#Session.getAvailableEvents.TContent_ID#">#Session.getAvailableEvents.TContent_ID#</a>) / #Session.getAvailableEvents.ShortTitle#<cfif LEN(Session.getAvailableEvents.Presenters)><cfquery name="getPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select FName, LName From tusers where UserID = <cfqueryparam value="#Session.getAvailableEvents.Presenters#" cfsqltype="cf_sql_varchar"></cfquery><br><em>Presenter: #getPresenter.FName# #getPresenter.Lname#</em></cfif></td>
								<td width="15%">
									<cfset ValidDate = 0>
									<cfif LEN(Session.getAvailableEvents.EventDate) and LEN(Session.getAvailableEvents.EventDate1) or LEN(Session.getAvailableEvents.EventDate2) or LEN(Session.getAvailableEvents.EventDate3) or LEN(Session.getAvailableEvents.EventDate4)>
										<cfif DateDiff("d", Now(), Session.getAvailableEvents.EventDate) LT 0>
											<div style="Color: ##CCCCCC;">#DateFormat(Session.getAvailableEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.getAvailableEvents.EventDate, "ddd")#)</div>
										<cfelse>
											<cfset ValidDate = 1>
											#DateFormat(Session.getAvailableEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.getAvailableEvents.EventDate, "ddd")#)<br>
										</cfif>
										<cfif LEN(Session.getAvailableEvents.EventDate1)>
											<cfif DateDiff("d", Now(), Session.getAvailableEvents.EventDate1) LT 0>
												<div style="Color: ##AAAAAA;">#DateFormat(Session.getAvailableEvents.EventDate1, "mm/dd/yyyy")# (#DateFormat(Session.getAvailableEvents.EventDate1, "ddd")#)</div>
											<cfelse>
												<cfset ValidDate = 1>
												#DateFormat(Session.getAvailableEvents.EventDate1, "mm/dd/yyyy")# (#DateFormat(Session.getAvailableEvents.EventDate1, "ddd")#)<br>
											</cfif>
										</cfif>
										<cfif LEN(Session.getAvailableEvents.EventDate2)>
											<cfif DateDiff("d", Now(), Session.getAvailableEvents.EventDate2) LT 0>
												<div class="text-danger">#DateFormat(Session.getAvailableEvents.EventDate2, "mm/dd/yyyy")# (#DateFormat(Session.getAvailableEvents.EventDate2, "ddd")#)</div>
											<cfelse>
												<cfset ValidDate = 1>
												#DateFormat(Session.getAvailableEvents.EventDate2, "mm/dd/yyyy")# (#DateFormat(Session.getAvailableEvents.EventDate2, "ddd")#)<br>
											</cfif>
										</cfif>
										<cfif LEN(Session.getAvailableEvents.EventDate3)>
											<cfif DateDiff("d", Now(), Session.getAvailableEvents.EventDate3) LT 0>
												<div class="text-danger">#DateFormat(Session.getAvailableEvents.EventDate3, "mm/dd/yyyy")# (#DateFormat(Session.getAvailableEvents.EventDate3, "ddd")#)</div>
											<cfelse>
												<cfset ValidDate = 1>
												#DateFormat(Session.getAvailableEvents.EventDate3, "mm/dd/yyyy")# (#DateFormat(Session.getAvailableEvents.EventDate3, "ddd")#)<br>
											</cfif>
										</cfif>
										<cfif LEN(Session.getAvailableEvents.EventDate4)>
											<cfif DateDiff("d", Now(), Session.getAvailableEvents.EventDate4) LT 0>
												<div class="text-danger">#DateFormat(Session.getAvailableEvents.EventDate4, "mm/dd/yyyy")# (#DateFormat(Session.getAvailableEvents.EventDate4, "ddd")#)</div>
											<cfelse>
												<cfset ValidDate = 1>
												#DateFormat(Session.getAvailableEvents.EventDate4, "mm/dd/yyyy")# (#DateFormat(Session.getAvailableEvents.EventDate4, "ddd")#)
											</cfif>
										</cfif>
									<cfelse>
										<cfif DateDiff("d", Now(), Session.getAvailableEvents.EventDate) LT 0>
										<cfelse>
											<cfset ValidDate = 1>
										</cfif>
										#DateFormat(Session.getAvailableEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.getAvailableEvents.EventDate, "ddd")#)
									</cfif>
									<cfif Session.getAvailableEvents.Active EQ 0><div class="alert alert-danger small">Event not displayed<hr>Click Update Event to change settings</div>
									<cfelseif Session.getAvailableEvents.AcceptRegistrations EQ 0>
										<div class="alert alert-warning small">Registration Closed<hr>Click Update Event to change settings</div>
									<cfelse>
										<cfif ValidDate EQ 1>
											<cfif DateDiff("d", Session.getAvailableEvents.Registration_Deadline, Now()) GT 0>
												<div class="alert alert-warning small">Registration Passed<hr>Click Update Event to change settings</div>
											<cfelse>
												<cfquery name="WaitingListCount" dbtype="query">
													Select OnWaitingList
													From getRegisteredParticipantsForEvent
													Where OnWaitingList = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
												</cfquery>
												<cfif Session.getAvailableEvents.MaxParticipants EQ getRegisteredParticipantsForEvent.RecordCount>
													<div class="alert alert-success small">Event Full<hr></div>
												<cfelseif WaitingListCount.RecordCount>
													<div class="alert alert-danger small">Event Full<br>#WaitingListCount.RecordCount# on Waiting List<hr>Click Update Event to change settings</div>
												</cfif>
											</cfif>
										</cfif>
									</cfif>
								</td>
								<td>
									<!---
										After Event has Passed on All Dates, Grey Out De-Register and Post Facebook

									--->
									<a href="#buildURL('eventcoord:events.geteventinfo')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Info</small></a>
									<a href="#buildURL('eventcoord:events.registeruserforevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Register</small></a>
									<cfif getRegisteredParticipantsForEvent.RecordCount><a href="#buildURL('eventcoord:events.deregisteruserforevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>De-Register</small></a><cfelse><button type="button" class="btn btn-secondary btn-small"><small>De-Register</small></button></cfif>
									<a href="#buildURL('eventcoord:events.publishtofb')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small small"><small>Post Facebook</small></a><br>
									<cfif getRegisteredParticipantsForEvent.RecordCount><a href="#buildURL('eventcoord:events.emailparticipants')#&EventID=#Session.getAvailableEvents.TContent_ID#&EmailType=EmailRegistered" class="btn btn-primary btn-small"><small>Email Registered</small></a><cfelse><button type="button" class="btn btn-secondary btn-small"><small>Email Registered</small></button></cfif>
									<cfif getAttendedParticipantsForEvent.RecordCount><a href="#buildURL('eventcoord:events.emailparticipants')#&EventID=#Session.getAvailableEvents.TContent_ID#&EmailType=EmailAttended" class="btn btn-primary btn-small"><small>Email Attended</small></a><cfelse><button type="button" class="btn btn-secondary btn-small"><small>Email Attended</small></button></cfif>
									<cfif getAttendedParticipantsForEvent.RecordCount><cfif Session.getAvailableEvents.PGPAvailable EQ 1><a href="#buildURL('eventcoord:events.sendpgpcertificates')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Send Certificates</small></a><cfelse><button type="button" class="btn btn-secondary btn-small"><small>Send Certificates</small></button></cfif><cfelse><button type="button" class="btn btn-secondary btn-small"><small>Send Certificates</small></button></CFIF><br>
									<cfif getRegisteredParticipantsForEvent.RecordCount><a href="#buildURL('eventcoord:events.eventsigninsheet')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Sign-In Sheet</small></a><cfelse><button type="button" class="btn btn-secondary btn-small"><small>Sign-In Sheet</small></button></cfif>
									<cfif getRegisteredParticipantsForEvent.RecordCount><a href="#buildURL('eventcoord:events.namebadges')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Name Badges</small></a><cfelse><button type="button" class="btn btn-secondary btn-small"><small>Name Badges</small></button></cfif>
									<cfif getRegisteredParticipantsForEvent.RecordCount and DateDiff("d", Now(), Session.getAvailableEvents.EventDate) LT 1><a href="#buildURL('eventcoord:events.signinparticipant')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Sign-In Participant</small></a><cfelse><button type="button" class="btn btn-secondary btn-small"><small>Sign-In Participant</small></button></cfif>
									<a href="#buildURL('eventcoord:events.updateevent_review')#&EventID=#Session.getAvailableEvents.TContent_ID#" role="button" class="btn btn-primary btn-small"><small>Update Event</small></a>
									<a href="#buildURL('eventcoord:events.cancelevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Cancel Event</small></a>
									<a href="#buildURL('eventcoord:events.copyevent')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Copy Event</small></a><br>
									<a href="#buildURL('eventcoord:events.eventdocs')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Event Documents</small></a>
									<a href="#buildURL('eventcoord:events.eventweblinks')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Event Web Links</small></a><br>
									<cfif getAttendedParticipantsForEvent.RecordCount and Session.getAvailableEvents.EventInvoicesGenerated EQ 0><a href="#buildURL('eventcoord:events.enterexpenses')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Expenses</small></a><cfelse><button type="button" class="btn btn-secondary btn-small"><small>Expenses</small></button></cfif>
									<cfif getAttendedParticipantsForEvent.RecordCount and Session.getAvailableEvents.EventInvoicesGenerated EQ 0><a href="#buildURL('eventcoord:events.enterrevenue')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>Revenue</small></a><cfelse><button type="button" class="btn btn-secondary btn-small"><small>Revenue</small></button></cfif>
									<cfset IncomeCompleted = 0>
									<cfif checkIncomeVerified.RecordCount EQ 1 and CheckIncomeVerified.AttendeePriceVerified EQ 1><cfset IncomeCOmpleted = 1></cfif>
									<cfif getEventExpenses.RecordCount and Variables.IncomeCompleted EQ 1><a href="#buildURL('eventcoord:events.viewprofitlossreport')#&EventID=#Session.getAvailableEvents.TContent_ID#" class="btn btn-primary btn-small"><small>View Profit/Loss Report</small></a><cfelse><button type="button" class="btn btn-secondary btn-small"><small>View Profit/Loss Report</small></button></cfif><br />
								</td>
							</tr>
						</cfloop>
					</tbody>
				</cfif>
			</table>
		</div>
	</div>
</cfoutput>