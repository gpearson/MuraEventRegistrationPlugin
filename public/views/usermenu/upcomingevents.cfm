<cfif not isDefined("URL.EventID")>
	<cfoutput>
		<div class="panel panel-default">
			<div class="panel-body">
				<fieldset>
					<legend>List of Upcoming Events</legend>
				</fieldset>
				<cfif isDefined("URL.UserAction")>
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="RegistrationUpdated">
							<cfif URL.Successful EQ "True">
								<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Registration Updated</h3>
										</div>
										<div class="modal-body">
											<div class="alert alert-success">The registration for #Session.GetRegistrationInfo.ShortTitle# was updated due to your request.</div>
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
							<cfset temp = StructDelete(Session, "FormErrors")>
							<cfset temp = StructDelete(Session, "FormData")>
							<cfset temp = StructDelete(Session, "GetSelectedEvent")>
							<cfset temp = StructDelete(Session, "GetEventFacility")>
							<cfset temp = StructDelete(Session, "GetEventFacilityRoom")>
							<cfelse>

							</cfif>
						</cfcase>
					</cfswitch>
				</cfif>
				<cfif isDefined("URL.RegistrationCancelled")>
					<cfswitch expression="#URL.RegistrationCancelled#">
						<cfcase value="True">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Registration cancelled</h3>
										</div>
										<div class="modal-body">
											<div class="alert alert-danger">The registration for #Session.GetSelectedEvent.ShortTitle# was cancelled due to your request.</div>
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
							<cfset temp = StructDelete(Session, "FormErrors")>
							<cfset temp = StructDelete(Session, "FormData")>
							<cfset temp = StructDelete(Session, "GetSelectedEvent")>
							<cfset temp = StructDelete(Session, "GetEventFacility")>
							<cfset temp = StructDelete(Session, "GetEventFacilityRoom")>
						</cfcase>
					</cfswitch>
				</cfif>
				<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td width="50%">Event Title</td>
						<td width="15%">Primary Date</td>
						<td>&nbsp;</td>
					</tr>
					<cfif Session.GetRegisteredEvents.RecordCount GTE 1>
						<cfloop query="Session.GetRegisteredEvents">
							<tr>
							<td>#Session.GetRegisteredEvents.ShortTitle#</td>
							<td>
								<cfif LEN(Session.GetRegisteredEvents.EventDate) and LEN(Session.GetRegisteredEvents.EventDate1) or LEN(Session.GetRegisteredEvents.EventDate2) or LEN(Session.GetRegisteredEvents.EventDate3) or LEN(Session.GetRegisteredEvents.EventDate4)>
									<cfif DateDiff("d", Now(), Session.GetRegisteredEvents.EventDate) LT 0>
										<div style="Color: ##CCCCCC;">#DateFormat(Session.GetRegisteredEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate, "ddd")#)</div>
									<cfelse>
										#DateFormat(Session.GetRegisteredEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate, "ddd")#)<br>
									</cfif>
									<cfif LEN(Session.GetRegisteredEvents.EventDate1)>
										<cfif DateDiff("d", Now(), Session.GetRegisteredEvents.EventDate1) LT 0>
											<div style="Color: ##AAAAAA;">#DateFormat(Session.GetRegisteredEvents.EventDate1, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate1, "ddd")#)</div>
										<cfelse>
											#DateFormat(Session.GetRegisteredEvents.EventDate1, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate1, "ddd")#)<br>
										</cfif>
									</cfif>
									<cfif LEN(Session.GetRegisteredEvents.EventDate2)>
										<cfif DateDiff("d", Now(), Session.GetRegisteredEvents.EventDate2) LT 0>
											<div class="text-danger">#DateFormat(Session.GetRegisteredEvents.EventDate2, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate2, "ddd")#)</div>
										<cfelse>
											#DateFormat(Session.GetRegisteredEvents.EventDate2, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate2, "ddd")#)<br>
										</cfif>
									</cfif>
									<cfif LEN(Session.GetRegisteredEvents.EventDate3)>
										<cfif DateDiff("d", Now(), Session.GetRegisteredEvents.EventDate3) LT 0>
											<div class="text-danger">#DateFormat(Session.GetRegisteredEvents.EventDate3, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate3, "ddd")#)</div>
										<cfelse>
											#DateFormat(Session.GetRegisteredEvents.EventDate3, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate3, "ddd")#)<br>
										</cfif>
									</cfif>
									<cfif LEN(Session.GetRegisteredEvents.EventDate4)>
										<cfif DateDiff("d", Now(), Session.GetRegisteredEvents.EventDate4) LT 0>
											<div class="text-danger">#DateFormat(Session.GetRegisteredEvents.EventDate4, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate4, "ddd")#)</div>
										<cfelse>
											#DateFormat(Session.GetRegisteredEvents.EventDate4, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate4, "ddd")#)
										</cfif>
									</cfif>
								<cfelse>
									#DateFormat(Session.GetRegisteredEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate, "ddd")#)
								</cfif>
							</td>
							<td>
								<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.GetRegisteredEvents.EventID#" class="btn btn-primary btn-small pull-right" alt="View Event Info">View Event Info</a>
								<div class="pull-right">&nbsp;</div>
								<cfif DateDiff("d", Now(), Session.GetRegisteredEvents.Registration_Deadline) GTE 0>
									<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.cancelregistration&EventID=#Session.GetRegisteredEvents.EventID#" class="btn btn-primary btn-small pull-right" alt="Cancel Registration">Cancel Registration</a>
									<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.updateregistration&RegistrationID=#Session.GetRegisteredEvents.RegistrationID#" class="btn btn-primary btn-small pull-right" alt="Update Registration">Update Registration</a>
								<cfelse>
									<button type="button" class="btn btn-secondary btn-small pull-right">Cancel Deadline Passed</button>
									<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.updateregistration&RegistrationID=#Session.GetRegisteredEvents.RegistrationID#" class="btn btn-primary btn-small pull-right" alt="Update Registration">Update Registration</a>
								</cfif>

							</td>
							</tr>
						</cfloop>
					<cfelse>
						<tr>
							<td colspan="3" align="center">To view available events you can register for <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.default" class="btn btn-primary btn-small" alt="Event Listing Button">click here</a></td>
						</tr>
					</cfif>

				</table>
			</div>
		</div>
	</cfoutput>
<cfelseif isDefined("URL.EventID")>
	<cfoutput>
		<div class="panel panel-default">
			<div class="panel-body">
				<fieldset>
					<legend>List of Registered Events</legend>
				</fieldset>
				<cfif isDefined("URL.RegistrationCancelled")>
					<cfswitch expression="#URL.RegistrationCancelled#">
						<cfcase value="False">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Registration not cancelled</h3>
										</div>
										<div class="modal-body">
											<div class="alert alert-danger">The registration for #Session.GetSelectedEvent.ShortTitle# was not cancelled due to your selection.</div>
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
							<cfset temp = StructDelete(Session, "FormErrors")>
							<cfset temp = StructDelete(Session, "FormData")>
							<cfset temp = StructDelete(Session, "GetSelectedEvent")>
							<cfset temp = StructDelete(Session, "GetEventFacility")>
							<cfset temp = StructDelete(Session, "GetEventFacilityRoom")>
						</cfcase>
					</cfswitch>
				</cfif>
				<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
					<tr>
						<td>Event Title</td>
						<td>Primary Date</td>
						<td width="15%"></td>
					</tr>
					<cfloop query="Session.GetRegisteredEvents">
						<tr>
						<td>#Session.GetRegisteredEvents.ShortTitle#</td>
						<td>#dateFormat(Session.GetRegisteredEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate, "ddd")#)</td>
						<td width="15%">

							<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.cancelregistration&EventID=#Session.GetRegisteredEvents.EventID#" class="btn btn-primary btn-small" alt="Event Information">Cancel</a> | <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.GetRegisteredEvents.EventID#" class="btn btn-primary btn-small" alt="Event Information">View Event Info</a></td>
						</tr>
					</cfloop>
				</table>
			</div>
		</div>
	</cfoutput>
</cfif>