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
	<cfif not isDefined("URL.EventID")>
		<div class="panel panel-default">
			<div class="panel-heading"><h3>List of Upcoming Events</h3></div>
			<div class="panel-body">
				<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
					<thead>
						<tr>
							<td width="50%">Event Title</td>
							<td width="20%">Primary Date</td>
							<td width="30%">&nbsp;</td>
						</tr>
					</thead>
					<tbody>
						<cfloop query="Session.GetRegisteredEvents">
							<cfif DateDiff("d", Now(), Session.GetRegisteredEvents.EventDate) GTE 0>
								<tr>
								<td>#Session.GetRegisteredEvents.ShortTitle#</td>
								<td>#dateFormat(Session.GetRegisteredEvents.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.GetRegisteredEvents.EventDate, "ddd")#)</td>
								<td>
									<cfif DateDiff("d", Session.GetRegisteredEvents.Registration_Deadline, Now()) LTE 0>
										<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.cancelregistration&EventID=#Session.GetRegisteredEvents.Event_ID#" class="btn btn-primary btn-small BtnSameSize" alt="Event Information">DeRegister</a> | 
									</cfif> <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.GetRegisteredEvents.Event_ID#" class="btn btn-primary btn-small BtnSameSize" alt="Event Information">View Event Info</a></td>
								</tr>
							</cfif>
						</cfloop>
					</tbody>
				</table>
			</div>
		</div>
	</cfif>
</cfoutput>


	<!--- 

	
	<div class="panel panel-default">
		<div class="panel-heading"><h3>Available Events</h3></div>
		<div class="panel-body">
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
									Event_ID = <cfqueryparam value="#Session.getNonFeaturedEvents.TContent_ID#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfset EventSeatsLeft = #Session.getNonFeaturedEvents.Event_MaxParticipants# - #getCurrentRegistrationsbyEvent.CurrentNumberofRegistrations#>
							<tr>
								<td>#Session.getNonFeaturedEvents.ShortTitle#<cfif LEN(Session.getNonFeaturedEvents.PresenterID)><cfquery name="getPresenter" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">Select FName, LName From tusers where UserID = <cfqueryparam value="#Session.getNonFeaturedEvents.Presenters#" cfsqltype="cf_sql_varchar"></cfquery><br><em>Presenter: #getPresenter.FName# #getPresenter.Lname#</em></cfif></td>
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
										<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize" alt="Event Information">More Info</a>
										<cfif Variables.EventSeatsLeft GTE 1 and DateDiff("d", Now(), Session.getNonFeaturedEvents.Registration_Deadline) GTE 0>
											| <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:registerevent.default&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize" alt="Register Event">Register</a>
										</cfif>
									<CFELSE>
										<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#Session.getNonFeaturedEvents.TContent_ID#" class="btn btn-primary btn-small BtnSameSize" alt="Event Information">More Info</a>
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
--->