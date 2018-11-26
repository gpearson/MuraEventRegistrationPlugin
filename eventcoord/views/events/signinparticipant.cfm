<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.signinparticipant&EventID=#URL.EventID#" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfif isDefined("URL.UserAction")>
				<div class="panel-body">
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="ParticipantsChecked">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div id="modelWindowDialog" class="modal fade">
										<div class="modal-dialog">
											<div class="modal-content">
												<div class="modal-header">
													<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
													<h3>Participants Checked In to Event</h3>
												</div>
												<div class="modal-body">
													<p class="alert alert-success">You have successfully checked participants who has attended this Event. If additional participants are shown you can check them off if they attended or click the Return to Main Menu button to continue your work within this application.</p>
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
					</cfswitch>
				</div>
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Signin Participant who attended the event titled:</h2><br><h3>#Session.getSelectedEvent.ShortTitle#</h3></legend>
					</fieldset>
					<cfif LEN(Session.getSelectedEvent.EventDate1) or LEN(Session.getSelectedEvent.EventDate2) or LEN(Session.getSelectedEvent.EventDate3) or LEN(Session.getSelectedEvent.EventDate4) or LEN(Session.getSelectedEvent.EventDate5)>
						<div class="panel-body"><div class="alert alert-warning"><cfif LEN(Session.getSelectedEvent.EventDate1)><p>Day 1: #DateFormat(Session.getSelectedEvent.EventDate, "full")#</p><p>Day 2: #DateFormat(Session.getSelectedEvent.EventDate1, "full")#</p></cfif><cfif LEN(Session.getSelectedEvent.EventDate2)><p>Day 3: #DateFormat(Session.getSelectedEvent.EventDate2, "full")#</p></cfif><cfif LEN(Session.getSelectedEvent.EventDate3)><p>Day 4: #DateFormat(Session.getSelectedEvent.EventDate3, "full")#</p></cfif><cfif LEN(Session.getSelectedEvent.EventDate4)><p>Day 5: #DateFormat(Session.getSelectedEvent.EventDate4, "full")#</p></cfif><cfif LEN(Session.getSelectedEvent.EventDate5)><p>Day 6: #DateFormat(Session.getSelectedEvent.EventDate5, "full")#</p></cfif></div></div>
					</cfif>
					<cfset NumberOfEventDates = 0>
					<cfif Len(Session.getSelectedEvent.EventDate)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate1)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate2)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate3)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate4)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate5)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfset ColWidth = 100 / #Variables.NumberOfEventDates# >
					<cfif Session.getRegisteredParticipants.RecordCount>
						<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
							<cfloop query="Session.getRegisteredParticipants">
								<cfset CurrentModRow = #Session.getRegisteredParticipants.CurrentRow# MOD 4>
								<cfquery name="GetOrgName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select OrganizationName
									From p_EventRegistration_Membership
									Where OrganizationDomainName = <cfqueryparam value="#Session.getRegisteredparticipants.Domain#" cfsqltype="cf_sql_varchar">
								</cfquery>
								<cfswitch expression="#Variables.NumberOfEventDates#">
									<cfcase value="1">
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr>
													<td width="25%">
														<cfinclude template="signinparticipant_tablelayout.cfm">
													</td>
											</cfcase>
											<cfcase value="0">
												<td width="25%">
													<cfinclude template="signinparticipant_tablelayout.cfm">
												</td>
												</tr>
											</cfcase>
											<cfdefaultcase>
												<td width="25%">
													<cfinclude template="signinparticipant_tablelayout.cfm">
												</td>
											</cfdefaultcase>
										</cfswitch>
									</cfcase>
									<cfdefaultcase>
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr>
												<td width="25%">
													<cfinclude template="signinparticipant_tablelayout.cfm">
												</td>
											</cfcase>
											<cfcase value="0">
												<td width="25%">
													<cfinclude template="signinparticipant_tablelayout.cfm">
												</td>
												</tr>
											</cfcase>
											<cfdefaultcase>
												<td width="25%">
													<cfinclude template="signinparticipant_tablelayout.cfm">
												</td>
											</cfdefaultcase>
										</cfswitch>
									</cfdefaultcase>
								</cfswitch>
							</cfloop>
						</table>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="Back to Event Listing">&nbsp; | &nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary" value="SignIn All Participants">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="SignIn Participants"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>