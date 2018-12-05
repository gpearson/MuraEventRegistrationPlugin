<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
<cfif not isDefined("Session.ReportJars")><cfset Session.ReportJars = #this.javaSettings.Loadpaths[1]#></cfif>
</cfsilent>
<cfif not isDefined("Session.PluginFramework")><cflocation url="/" addtoken="false"></cfif>
<cfsavecontent variable="htmlhead"><cfoutput>
	<link rel="stylesheet" href="/plugins/#Session.PluginFramework.Package#/assets/js/jqGrid_5.1.0/css/ui.jqgrid-bootstrap.css" />
	<script type="text/ecmascript" src="/plugins/#Session.PluginFramework.Package#/assets/js/jqGrid_5.1.0/js/i18n/grid.locale-en.js"></script>
	<script type="text/ecmascript" src="/plugins/#Session.PluginFramework.Package#/assets/js/jqGrid_5.1.0/js/jquery.jqGrid.min.js"></script>
</cfoutput></cfsavecontent>
<cfhtmlhead text="#htmlhead#" />
<cfoutput>	    
	<script>
		$.jgrid.defaults.responsive = true;
		$.jgrid.defaults.styleUI = 'Bootstrap';
	</script>
	<div class="panel panel-default">
		<div class="panel-body">
			<fieldset>
				<legend><h2>Available Events or Workshops</h2></legend>
			</fieldset>
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="EventInvoicesGenerated">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Event Invoices Generated</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully sent event invoices to individuals responsible in paying the invoice.</p>
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
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
					<cfcase value="SentPGPCertificates">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Event Certificates Sent to Attendees</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully sent attended participants their certificates of completion.</p>
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
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
					<cfcase value="EventCopied">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Event Cancelled</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully copied an event to a new event.</p>
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
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
					<cfcase value="EventCancelled">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Event Cancelled</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully cancelled the event. If you selected to notify registered partiicpants an email is being sent to those individuals.</p>
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
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
					<cfcase value="ParticipantsRegistered">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Participants Registered for Event</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully registered participants for the event you selected. If you selected the option to send email confirmations, those are on the process to be delivered to the selected participants.</p>
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
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
					<cfcase value="EventExpensesCostVerified">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Event Expenses Cost Verified</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully verified the expenses for the event within the database.</p>
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
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
					<cfcase value="EventAdded">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Event Added</h3>
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
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
					<cfcase value="ParticipantDeRegistered">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Participant Registration Removed</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully removed participant from the event.</p>
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
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
					<cfcase value="ParticipantRegistered">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Participant Registration Added</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully added participant to the event.</p>
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
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
					<cfcase value="EmailSentToParticipants">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Email Sending to Participants</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">The system is in process of sending your message to the participants of the event.</p>
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
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
				</cfswitch>
			</cfif>
			<table class="table table-striped">
				<thead>
					<tr>
						<th scope="col" width="50%">Event Title</th>
						<th scope="col" width="15%">Event Date</th>
						<th scope="col">Actions</th>
					</tr>
				</thead>
				<tbody>
					<cfloop query="Session.getAllEvents">
						<cfquery name="getRegisteredParticipantsForEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							SELECT p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, p_EventRegistration_UserRegistrations.OnWaitingList, tusers.Fname, tusers.Lname, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, tusers.Company, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM
							FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
							WHERE
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR 
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.RegisterForEventSessionAM = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.RegisterForEventSessionPM = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> )
							ORDER BY Domain ASC, tusers.LName ASC, tusers.Fname ASC
						</cfquery>

						<cfquery name="getAttendedParticipantsForEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							SELECT p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, p_EventRegistration_UserRegistrations.OnWaitingList, tusers.Fname, tusers.Lname, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, tusers.Company, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
							FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
							WHERE
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.AttendedEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR 
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.AttendedEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.AttendedEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.AttendedEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.AttendedEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.AttendedEventSessionAM = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> ) OR
								( p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> AND p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">  AND p_EventRegistration_UserRegistrations.AttendedEventSessionPM = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> )
							ORDER BY Domain ASC, tusers.LName ASC, tusers.Fname ASC
						</cfquery>
						<cfquery name="getEventExpenses" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Select TContent_ID
							From p_EventRegistration_EventExpenses
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer">
						</cfquery>
						<cfquery name="checkIncomeVerified" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Select AttendeePriceVerified
							From p_EventRegistration_UserRegistrations
							Where Event_ID = <cfqueryparam value="#Session.getAllEvents.TContent_ID#" cfsqltype="cf_sql_integer"> and Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
							Group by AttendeePriceVerified
						</cfquery>
						<tr>
						<th scope="row">(<a href="http://#cgi.server_name#/?Info=#Session.getAllEvents.TContent_ID#">#Session.getAllEvents.TContent_ID#</a>) / #Session.getAllEvents.ShortTitle#<cfif LEN(Session.getAllEvents.PresenterID)><cfquery name="getPresenter" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">Select FName, LName From tusers where UserID = <cfqueryparam value="#Session.getAllEvents.PresenterID#" cfsqltype="cf_sql_varchar"></cfquery><br><em>Presenter: #getPresenter.FName# #getPresenter.Lname#</em></cfif>
									<cfif Session.getAllEvents.PGPCertificatesGenerated EQ 1><br><font color="Green">PGP Certificates Sent</font></cfif>
									<cfif Session.getAllEvents.EventInvoicesGenerated EQ 1><br><font color="Blue">Invoices Sent</font></cfif></th>
						<td>
							<cfset ValidDate = 0>
							<cfif LEN(Session.getAllEvents.EventDate) and LEN(Session.getAllEvents.EventDate1) or LEN(Session.getAllEvents.EventDate2) or LEN(Session.getAllEvents.EventDate3) or LEN(Session.getAllEvents.EventDate4)>
								<cfif DateDiff("d", Now(), Session.getAllEvents.EventDate) LT 0>
									<div style="Color: ##CCCCCC;">#DateFormat(Session.getAllEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.getAllEvents.EventDate, "ddd")#)</div>
								<cfelse>
									<cfset ValidDate = 1>
									#DateFormat(Session.getAllEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.getAllEvents.EventDate, "ddd")#)<br>
								</cfif>
								<cfif LEN(Session.getAllEvents.EventDate1)>
									<cfif DateDiff("d", Now(), Session.getAllEvents.EventDate1) LT 0>
										<div style="Color: ##AAAAAA;">#DateFormat(Session.getAllEvents.EventDate1, "mm/dd/yyyy")# (#DateFormat(Session.getAllEvents.EventDate1, "ddd")#)</div>
									<cfelse>
										<cfset ValidDate = 1>
										#DateFormat(Session.getAllEvents.EventDate1, "mm/dd/yyyy")# (#DateFormat(Session.getAllEvents.EventDate1, "ddd")#)<br>
									</cfif>
								</cfif>
								<cfif LEN(Session.getAllEvents.EventDate2)>
									<cfif DateDiff("d", Now(), Session.getAllEvents.EventDate2) LT 0>
										<div class="text-danger">#DateFormat(Session.getAllEvents.EventDate2, "mm/dd/yyyy")# (#DateFormat(Session.getAllEvents.EventDate2, "ddd")#)</div>
									<cfelse>
										<cfset ValidDate = 1>
										#DateFormat(Session.getAllEvents.EventDate2, "mm/dd/yyyy")# (#DateFormat(Session.getAllEvents.EventDate2, "ddd")#)<br>
									</cfif>
								</cfif>
								<cfif LEN(Session.getAllEvents.EventDate3)>
									<cfif DateDiff("d", Now(), Session.getAllEvents.EventDate3) LT 0>
										<div class="text-danger">#DateFormat(Session.getAllEvents.EventDate3, "mm/dd/yyyy")# (#DateFormat(Session.getAllEvents.EventDate3, "ddd")#)</div>
									<cfelse>
										<cfset ValidDate = 1>
										#DateFormat(Session.getAllEvents.EventDate3, "mm/dd/yyyy")# (#DateFormat(Session.getAllEvents.EventDate3, "ddd")#)<br>
									</cfif>
								</cfif>
								<cfif LEN(Session.getAllEvents.EventDate4)>
									<cfif DateDiff("d", Now(), Session.getAllEvents.EventDate4) LT 0>
										<div class="text-danger">#DateFormat(Session.getAllEvents.EventDate4, "mm/dd/yyyy")# (#DateFormat(Session.getAllEvents.EventDate4, "ddd")#)</div>
									<cfelse>
										<cfset ValidDate = 1>
										#DateFormat(Session.getAllEvents.EventDate4, "mm/dd/yyyy")# (#DateFormat(Session.getAllEvents.EventDate4, "ddd")#)
									</cfif>
								</cfif>
							<cfelse>
								<cfif DateDiff("d", Now(), Session.getAllEvents.EventDate) LT 0>
								<cfelse>
									<cfset ValidDate = 1>
								</cfif>
								#DateFormat(Session.getAllEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.getAllEvents.EventDate, "ddd")#)
							</cfif>
							<cfif Session.getAllEvents.Active EQ 0><div class="alert alert-danger small">Event not displayed<br><cfif Session.getAllEvents.EventCancelled EQ 1>Event Cancelled</cfif>
								<hr>Click Update Event to change settings</div>
							<cfelseif Session.getAllEvents.AcceptRegistrations EQ 0>
								<div class="alert alert-warning small">Registration Closed<hr>Click Update Event to change settings</div>
							<cfelse>
								<cfif ValidDate EQ 1>
									<cfif DateDiff("d", Session.getAllEvents.Registration_Deadline, Now()) GT 0>
										<div class="alert alert-warning small">Registration Passed<hr>Click Update Event to change settings</div>
									<cfelse>
										<cfquery name="WaitingListCount" dbtype="query">
											Select OnWaitingList
											From getRegisteredParticipantsForEvent
											Where OnWaitingList = <cfqueryparam value="1" cfsqltype="cf_sql_integer">
										</cfquery>
										<cfif Session.getAllEvents.Event_MaxParticipants EQ getRegisteredParticipantsForEvent.RecordCount>
											<div class="alert alert-success small">Event Full<hr></div>
										<cfelseif WaitingListCount.RecordCount>
											<div class="alert alert-danger small">Event Full<br>#WaitingListCount.RecordCount# on Waiting List<hr>Click Update Event to change settings</div>
										</cfif>
									</cfif>
								</cfif>
							</cfif>
						</td>
						<td>
							<cfif Session.getAllEvents.EventCancelled EQ 0>
								<a href="#buildURL('eventcoordinator:events.geteventinfo')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Info</small></a>
								<a href="#buildURL('eventcoordinator:events.registeruserforevent')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Register</small></a>
								<cfif getRegisteredParticipantsForEvent.RecordCount><a href="#buildURL('eventcoordinator:events.deregisteruserforevent')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>De-Register</small></a><cfelse><button type="button" class="btn btn-secondary btn-small BtnSameSize"><small>De-Register</small></button></cfif>
								<cfif Session.SiteConfigSettings.Facebook_Enabled EQ 1><a href="#buildURL('eventcoordinator:events.publishtofb')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize small"><small>Post Facebook</small></a></cfif><br>
								<cfif getRegisteredParticipantsForEvent.RecordCount><a href="#buildURL('eventcoordinator:events.emailparticipants')#&EventID=#Session.getAllEvents.TContent_ID#&EmailType=EmailRegistered" class="btn btn-primary btn-small BtnSameSize"><small>Email Registered</small></a><cfelse><button type="button" class="btn btn-secondary btn-small BtnSameSize"><small>Email Registered</small></button></cfif>
								<cfif getAttendedParticipantsForEvent.RecordCount><a href="#buildURL('eventcoordinator:events.emailparticipants')#&EventID=#Session.getAllEvents.TContent_ID#&EmailType=EmailAttended" class="btn btn-primary btn-small BtnSameSize"><small>Email Attended</small></a><cfelse><button type="button" class="btn btn-secondary btn-small BtnSameSize"><small>Email Attended</small></button></cfif>
								<cfif getAttendedParticipantsForEvent.RecordCount><cfif Session.getAllEvents.PGPCertificate_Available EQ 1><a href="#buildURL('eventcoordinator:events.sendcertificates')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Send Certificates</small></a><cfelse><button type="button" class="btn btn-secondary btn-small BtnSameSize"><small>Send Certificates</small></button></cfif><cfelse><button type="button" class="btn btn-secondary btn-small BtnSameSize"><small>Send Certificates</small></button></CFIF><br>
								<cfif getRegisteredParticipantsForEvent.RecordCount><a href="#buildURL('eventcoordinator:events.signinsheet')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Sign-In Sheet</small></a><cfelse><button type="button" class="btn btn-secondary btn-small BtnSameSize"><small>Sign-In Sheet</small></button></cfif>
								<cfif getRegisteredParticipantsForEvent.RecordCount><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Name Tags</small></a><cfelse><button type="button" class="btn btn-secondary btn-small BtnSameSize"><small>Name Tags</small></button></cfif>
								<cfif getRegisteredParticipantsForEvent.RecordCount and DateDiff("d", Now(), Session.getAllEvents.EventDate) LT 1><a href="#buildURL('eventcoordinator:events.signinparticipant')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Sign-In Participant</small></a><cfelse><button type="button" class="btn btn-secondary btn-small BtnSameSize"><small>Sign-In Participant</small></button></cfif>
								<a href="#buildURL('eventcoordinator:events.updateevent')#&EventID=#Session.getAllEvents.TContent_ID#" role="button" class="btn btn-primary btn-small BtnSameSize"><small>Update Event</small></a>
								<a href="#buildURL('eventcoordinator:events.cancelevent')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Cancel Event</small></a>
								<a href="#buildURL('eventcoordinator:events.copyevent')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Copy Event</small></a><br>
								<a href="#buildURL('eventcoordinator:events.eventdocs')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Event Documents</small></a>
								<a href="#buildURL('eventcoordinator:events.eventweblinks')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Event Web Links</small></a><br>
								<a href="#buildURL('eventcoordinator:events.enterexpenses')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Expenses</small></a>
								<cfif Session.getAllEvents.EventInvoicesGenerated EQ 0><a href="#buildURL('eventcoordinator:events.eventrevenue')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Revenue</small></a><cfelse><button type="button" class="btn btn-secondary btn-small BtnSameSize"><small>Revenue</small></button></cfif>
								<cfset IncomeCompleted = 0>
								<cfif checkIncomeVerified.RecordCount EQ 1 and CheckIncomeVerified.AttendeePriceVerified EQ 1><cfset IncomeCompleted = 1></cfif>
								<cfif getEventExpenses.RecordCount and Variables.IncomeCompleted EQ 1><a href="#buildURL('eventcoordinator:events.viewprofitlossreport')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>View P & L Report</small></a><cfelse><button type="button" class="btn btn-secondary btn-small BtnSameSize"><small>View P & L Report</small></button></cfif><br />
							<cfelse>
								<a href="#buildURL('eventcoordinator:events.copyevent')#&EventID=#Session.getAllEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize"><small>Copy Event</small></a>
							</cfif>
						</td>
					</tr>
					</cfloop>
				</tbody>
			</table>
		</div>
	</div>
</cfoutput>