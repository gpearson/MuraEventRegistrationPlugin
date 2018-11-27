<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
<cfif LEN(cgi.path_info)><cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# ><cfelse><cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action#></cfif>
</cfsilent>
<cfoutput>
	<cfif not isDefined("URL.FormRetry") and not isDefined("URL.EventStatus")>
		<cfform action="#Variables.newurl#=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfif Session.getSelectedEvent.WebinarAvailable EQ 0><cfinput type="hidden" name="WebinarParticipant" value="0"></cfif>
			<div class="panel panel-default">
				<fieldset>
					<legend><h3>Registering Participants: #Session.getSelectedEvent.ShortTitle# <cfif Len(Session.getSelectedEvent.PresenterID)>(#Session.getSelectedEventPresenter.FName# #Session.getSelectedEventPresenter.Lname#)</cfif></h3></legend>
				</fieldset>
				<div class="panel-body">
					<div class="alert alert-info"><p>Complete this form to register users for the selected event</p></div>
					<div class="form-group">
						<label for="EventDate" class="col-lg-5 col-md-5">Event Date(s):&nbsp;</label>
						<div class="col-lg-7 col-md-7 form-control-static">
							#DateFormat(Session.getSelectedEvent.EventDate, "full")#
							<cfif LEN(Session.getSelectedEvent.EventDate1)>, #DateFormat(Session.getSelectedEvent.EventDate1, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate2)>, #DateFormat(Session.getSelectedEvent.EventDate2, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate3)>, #DateFormat(Session.getSelectedEvent.EventDate3, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate4)>, #DateFormat(Session.getSelectedEvent.EventDate4, "full")#</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventDescription" class="col-lg-5 col-md-5">Event Description:&nbsp;</label>
						<div class="col-lg-7 col-md-7 form-control-static">#Session.getSelectedEvent.LongDescription#</div>
					</div>
					<div class="form-group">
						<label for="EventLocation" class="col-lg-5 col-md-5">Event Location:&nbsp;</label>
						<div class="col-lg-7 col-md-7 form-control-static">#Session.getSelectedEventFacility.FacilityName# (#Session.getSelectedEventFacility.PhysicalAddress# #Session.getSelectedEventFacility.PhysicalCity# #Session.getSelectedEventFacility.PhysicalState# #Session.getSelectedEventFacility.PhysicalZipCode#)</div>
					</div>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
							<label for="WebinarParticipant" class="col-lg-5 col-md-5">Participate via Webinar:&nbsp;</label>
							<div class="col-lg-7 col-md-7"><cfselect name="WebinarParticipant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant use Webinar Option for Event</option></cfselect></div>
						</div>
					</cfif>
					<cfif Session.getSelectedEvent.AllowVideoConference EQ 1>
						<div class="form-group">
							<label for="H323Participant" class="col-lg-5 col-md-5">Participate via Video Conference:&nbsp;</label>
							<div class="col-lg-7 col-md-7"><cfselect name="H323Participant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant use Video Conference Option for Event</option></cfselect></div>
						</div>
					</cfif>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1 or Session.getSelectedEvent.AllowVideoConference EQ 1>
						<div class="form-group">
							<label for="FacilityParticipant" class="col-lg-5 col-md-5">Participate at Facility:&nbsp;</label>
							<div class="col-lg-7 col-md-7"><cfselect name="FacilityParticipant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant be at Faciity for Event</option></cfselect></div>
						</div>
					<cfelse>
						<cfinput type="hidden" name="FacilityParticipant" value="1">
					</cfif>
					<div class="form-group">
						<label for="EmailConfirmations" class="col-lg-5 col-md-5">Send Email Confirmation:&nbsp;</label>
						<div class="col-lg-7 col-md-7"><cfselect name="EmailConfirmations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Send Email Registration Confirmation</option></cfselect></div>
					</div>
					<cfif Session.CheckExistingSentEmailsForEvent.RecordCount>
						<div class="form-group">
							<label for="SendPreviousEmailCommunications" class="col-lg-5 col-md-5">Send Previous Email Communication:&nbsp;</label>
							<div class="col-lg-7 col-md-7"><cfselect name="SendPreviousEmailCommunications" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Send Previous Email Communications to New Participants</option></cfselect></div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="SchoolDistricts" class="col-lg-5 col-md-5">School District:&nbsp;</label>
						<div class="col-lg-7 col-md-7"><cfselect name="SchoolDistricts" class="form-control" Required="Yes" Multiple="No" query="Session.GetMembershipOrganizations" value="TContent_ID" Display="OrganizationName"  queryposition="below"><option value="----">Select School District Participant Is From</option><option value="0">Participant is from a Business</option></cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register for Event"><br /><br />
				</div>
			</div>
		</cfform>
	<cfelseif isDefined("URL.FormRetry") and not isDefined("URL.EventStatus")>
		<cfform action="#Variables.newurl#=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfif Session.getSelectedEvent.WebinarAvailable EQ 0><cfinput type="hidden" name="WebinarParticipant" value="0"></cfif>
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
			<div class="panel panel-default">
				<fieldset>
					<legend><h3>Registering Participants: #Session.getSelectedEvent.ShortTitle# <cfif Len(Session.getSelectedEvent.PresenterID)>(#Session.getSelectedEventPresenter.FName# #Session.getSelectedEventPresenter.Lname#)</cfif></h3></legend>
				</fieldset>
				<div class="panel-body">
					<div class="alert alert-info"><p>Complete this form to register users for the selected event</p></div>
					<div class="form-group">
						<label for="EventDate" class="col-lg-5 col-md-5">Event Date(s):&nbsp;</label>
						<div class="col-lg-7 col-md-7 form-control-static">
							#DateFormat(Session.getSelectedEvent.EventDate, "full")#
							<cfif LEN(Session.getSelectedEvent.EventDate1)>, #DateFormat(Session.getSelectedEvent.EventDate1, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate2)>, #DateFormat(Session.getSelectedEvent.EventDate2, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate3)>, #DateFormat(Session.getSelectedEvent.EventDate3, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate4)>, #DateFormat(Session.getSelectedEvent.EventDate4, "full")#</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventDescription" class="col-lg-5 col-md-5">Event Description:&nbsp;</label>
						<div class="col-lg-7 col-md-7 form-control-static">#Session.getSelectedEvent.LongDescription#</div>
					</div>
					<div class="form-group">
						<label for="EventLocation" class="col-lg-5 col-md-5">Event Location:&nbsp;</label>
						<div class="col-lg-7 col-md-7 form-control-static">#Session.getSelectedEventFacility.FacilityName# (#Session.getSelectedEventFacility.PhysicalAddress# #Session.getSelectedEventFacility.PhysicalCity# #Session.getSelectedEventFacility.PhysicalState# #Session.getSelectedEventFacility.PhysicalZipCode#)</div>
					</div>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
							<label for="WebinarParticipant" class="col-lg-5 col-md-5">Participate via Webinar:&nbsp;</label>
							<div class="col-lg-7 col-md-7"><cfselect name="WebinarParticipant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.WebinarParticipant#" queryposition="below"><option value="----">Will Participant use Webinar Option for Event</option></cfselect></div>
						</div>
					</cfif>
					<cfif Session.getSelectedEvent.AllowVideoConference EQ 1>
						<div class="form-group">
							<label for="H323Participant" class="col-lg-5 col-md-5">Participate via Video Conference:&nbsp;</label>
							<div class="col-lg-7 col-md-7"><cfselect name="H323Participant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.H323Participant#" queryposition="below"><option value="----">Will Participant use Video Conference Option for Event</option></cfselect></div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="FacilityParticipant" class="col-lg-5 col-md-5">Participate at Facility:&nbsp;</label>
						<div class="col-lg-7 col-md-7"><cfselect name="FacilityParticipant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.FacilityParticipant#" queryposition="below"><option value="----">Will Participant be at Faciity for Event</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="EmailConfirmations" class="col-lg-5 col-md-5">Send Email Confirmation:&nbsp;</label>
						<div class="col-lg-7 col-md-7"><cfselect name="EmailConfirmations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.EmailConfirmations#" queryposition="below"><option value="----">Send Email Registration Confirmation</option></cfselect></div>
					</div>
					<cfif Session.CheckExistingSentEmailsForEvent.RecordCount>
						<div class="form-group">
							<label for="SendPreviousEmailCommunications" class="col-lg-5 col-md-5">Send Previous Email Communication:&nbsp;</label>
							<div class="col-lg-7 col-md-7"><cfselect name="SendPreviousEmailCommunications" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.SendPreviousEmailCommunications#" queryposition="below"><option value="----">Send Previous Email Communications to New Participants</option></cfselect></div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="SchoolDistricts" class="col-lg-5 col-md-5">School District:&nbsp;</label>
						<div class="col-lg-7 col-md-7"><cfselect name="SchoolDistricts" class="form-control" Required="Yes" Multiple="No" query="Session.GetMembershipOrganizations" value="TContent_ID" Display="OrganizationName" selected="#Session.FormInput.SchoolDistricts#" queryposition="below"><option value="----">Select School District Participant Is From</option><option value="0">Participant is from a Business</option></cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register for Event"><br /><br />
				</div>
			</div>
		</cfform>
	<cfelseif isDefined("URL.EventID") and isDefined("URL.EventStatus")>
		<cfswitch expression="#URL.EventStatus#">
			<cfcase value="ShowCorporations">
				<cfform action="#Variables.newurl#=eventcoordinator:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipants" method="post" id="AddEvent" class="form-horizontal">
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
					<div class="panel panel-default">
						<fieldset>
							<legend><h3>Registering Participants: #Session.getSelectedEvent.ShortTitle# <cfif Len(Session.getSelectedEvent.PresenterID)>(#Session.getSelectedEventPresenter.FName# #Session.getSelectedEventPresenter.Lname#)</cfif></h3></legend>
						</fieldset>
						<div class="panel-body">
							<div class="alert alert-warning"><p>To register individuals for this event, simply check individuals from the provided list. <span class="text-danger"><strong>If you are registering someone not on the provided list, please add them in the space below and click the Add button before checking the boxes to register participants. <span class="text-danger"><strong>Individuals listed in Green have already registered for this event.</strong></span><br /> <br />If you are not attending this event, simply uncheck your name</strong></span></p></div>

							<div class="form-group">
								<label for="EventDate" class="col-lg-5 col-md-5">Event Date(s):&nbsp;</label>
								<div class="col-lg-7 col-md-7 form-control-static">
									#DateFormat(Session.getSelectedEvent.EventDate, "full")#
									<cfif LEN(Session.getSelectedEvent.EventDate1)>, #DateFormat(Session.getSelectedEvent.EventDate1, "full")#</cfif>
									<cfif LEN(Session.getSelectedEvent.EventDate2)>, #DateFormat(Session.getSelectedEvent.EventDate2, "full")#</cfif>
									<cfif LEN(Session.getSelectedEvent.EventDate3)>, #DateFormat(Session.getSelectedEvent.EventDate3, "full")#</cfif>
									<cfif LEN(Session.getSelectedEvent.EventDate4)>, #DateFormat(Session.getSelectedEvent.EventDate4, "full")#</cfif>
								</div>
							</div>
							<cfif Session.getSelectedEvent.Meal_Available EQ 1>
								<div class="form-group">
									<label for="RegisterParticipantStayForMeal" class="col-lg-5 col-md-5">Each Participant Staying for Meal?:&nbsp;<div class="form-check-label" style="Color: ##CCCCCC;">(For This Registration Only)</div></label></label>
									<div class="col-lg-7 col-md-7"><cfselect name="RegisterParticipantStayForMeal" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Each Registered Participant Staying for Meal?</option></cfselect></div>
								</div>
							<cfelse>
								<cfinput type="hidden" name="RegisterParticipantStayForMeal" value="0">
							</cfif>
							<cfif Session.getSelectedEvent.AllowVideoConference EQ 1>
								<div class="form-group">
									<label for="H323Participant" class="col-lg-5 col-md-5">Each Participant Participating by Video Conference?:&nbsp;<div class="form-check-label" style="Color: ##CCCCCC;">(For This Registration Only)</div>7</label>
									<div class="col-lg-7 col-md-7"><cfselect name="H323Participant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Each Registered Participant participating through Video Conference?</option></cfselect></div>
								</div>
							<cfelse>
								<cfinput type="hidden" name="H323Participant" value="0">
							</cfif>
							<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
								<div class="form-group">
									<label for="WebinarParticipant" class="col-lg-5 col-md-5">Each Participant Participating by Webinar?:&nbsp;<div class="form-check-label" style="Color: ##CCCCCC;">(For This Registration Only)</div>7</label></label>
									<div class="col-lg-7 col-md-7"><cfselect name="WebinarParticipant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Each Registered Participant Staying for Meal?</option></cfselect></div>
								</div>
							<cfelse>
								<cfinput type="hidden" name="WebinarParticipant" value="0">
							</cfif>
							<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
								<cfloop query="Session.GetSelectedAccountsWithinOrganization">
									<cfquery name="CheckUserAlreadyRegisteredForDays" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
										Select User_ID, Event_ID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
										From p_EventRegistration_UserRegistrations
										Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar"> and Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
									</cfquery>
									<cfset CurrentModRow = #Session.GetSelectedAccountsWithinOrganization.CurrentRow# MOD 4>
									<cfset NumberOfEventDates = 0>
									<cfif Len(Session.getSelectedEvent.EventDate)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
									<cfif Len(Session.getSelectedEvent.EventDate1)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
									<cfif Len(Session.getSelectedEvent.EventDate2)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
									<cfif Len(Session.getSelectedEvent.EventDate3)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
									<cfif Len(Session.getSelectedEvent.EventDate4)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
									<cfset ColWidth = 100 / #Variables.NumberOfEventDates#>
									<cfswitch expression="#Variables.NumberOfEventDates#">
										<cfcase value="1">
											<cfswitch expression="#Variables.CurrentModRow#">
												<cfcase value="1">
													<tr>
													<cfif LEN(Session.GetSelectedAccountsWithinOrganization.UserID)>
														<cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1>
															<td width="25%" Style="Color: ##009900;"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled>
														<cfelse>
															<td width="25%"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" >
														</cfif>
														&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#
													<cfelse>
														<td width="25%">&nbsp;&nbsp;
													</cfif>
													</td>
												</cfcase>
												<cfcase value="0">
													<cfif LEN(Session.GetSelectedAccountsWithinOrganization.UserID)>
														<cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1>
															<td width="25%" Style="Color: ##009900;"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled>
														<cfelse>
															<td width="25%"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" >
														</cfif>
														&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#
													<cfelse>
														<td width="25%">&nbsp;&nbsp;
													</cfif>
													</td>
													</tr>
												</cfcase>
												<cfdefaultcase>
													<cfif LEN(Session.GetSelectedAccountsWithinOrganization.UserID)>
														<cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1>
															<td width="25%" Style="Color: ##009900;"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled>
														<cfelse>
															<td width="25%"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" >
														</cfif>
														&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#
													<cfelse>
														<td width="25%">&nbsp;&nbsp;
													</cfif>
													</td>
												</cfdefaultcase>
											</cfswitch>
										</cfcase>
										<cfdefaultcase>
											<cfswitch expression="#Variables.CurrentModRow#">
												<cfcase value="1">
													<tr>
														<td width="25%">
															<table class="table" width="25%" cellspacing="0" cellpadding="0">
																<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</td></th>
																<tr>
																	<cfswitch expression="#Variables.NumberOfEventDates#">
																		<cfcase value="1">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="2">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="3">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																			<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="4">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
																			<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="5">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
																			<td  width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
																		</cfcase>
																	</cfswitch>
																</tr>
															</table>
														</td>
												</cfcase>
												<cfcase value="0">
														<td width="25%">
															<table class="table" width="25%" cellspacing="0" cellpadding="0">
																<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</td></th>
																<tr>
																	<cfswitch expression="#Variables.NumberOfEventDates#">
																		<cfcase value="1">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="2">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="3">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																			<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="4">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
																			<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="5">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
																			<td  width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
																		</cfcase>
																	</cfswitch>
																</tr>
															</table>
														</td>
													</tr>
												</cfcase>
												<cfdefaultcase>
													<td width="25%">
															<table class="table" width="25%" cellspacing="0" cellpadding="0">
																<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</td></th>
																<tr>
																	<cfswitch expression="#Variables.NumberOfEventDates#">
																		<cfcase value="1">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="2">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="3">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																			<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="4">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
																			<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
																		</cfcase>
																		<cfcase value="5">
																			<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
																			<td  width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
																			<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredForDays.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
																		</cfcase>
																	</cfswitch>
																</tr>
															</table>
														</td>
												</cfdefaultcase>
											</cfswitch>
										</cfdefaultcase>
									</cfswitch>
								</cfloop>
							</table>
							<hr>
							<table id="NewParticipantRows" class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
								<thead>
									<tr>
										<td>Row</td>
										<td class="col-sm-3">Participant First Name</td>
										<td class="col-sm-4">Participant Last Name</td>
										<td class="col-sm-3">Participant Email</td>
										<td class="col-sm-3">Actions</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>1</td>
										<td><cfinput type="text" class="form-control" id="ParticipantFirstName" name="ParticipantFirstName" required="no"></td>
										<td><cfinput type="text" class="form-control" id="ParticipantLastName" name="ParticipantLastName" required="no"></td>
										<td><cfinput type="text" class="form-control" id="ParticipantEmail" name="ParticipantEmail" required="no"></td>
										<td><input type="button" id="addParticipantRow" class="btn btn-primary btn-sm" value="Add" onclick="AddRow()"></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="panel-footer">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register Participants"><br /><br />
						</div>

							<!--- 



							<div class="form-group">
								<label for="EventDate" class="col-lg-5 col-md-5">Event Date(s):&nbsp;</label>
								<div class="col-lg-7 col-md-7 form-control-static">
									
								</div>
							</div>
							<div class="form-group">
								<label for="EventDescription" class="col-lg-5 col-md-5">Event Description:&nbsp;</label>
								<div class="col-lg-7 col-md-7 form-control-static">#Session.getSelectedEvent.LongDescription#</div>
							</div>
							<div class="form-group">
								<label for="EventLocation" class="col-lg-5 col-md-5">Event Location:&nbsp;</label>
								<div class="col-lg-7 col-md-7 form-control-static">#Session.getSelectedEventFacility.FacilityName# (#Session.getSelectedEventFacility.PhysicalAddress# #Session.getSelectedEventFacility.PhysicalCity# #Session.getSelectedEventFacility.PhysicalState# #Session.getSelectedEventFacility.PhysicalZipCode#)</div>
							</div>
							<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
								<div class="form-group">
									<label for="WebinarParticipant" class="col-lg-5 col-md-5">Participate via Webinar:&nbsp;</label>
									<div class="col-lg-7 col-md-7"><cfselect name="WebinarParticipant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant use Webinar Option for Event</option></cfselect></div>
								</div>
							</cfif>
							<cfif Session.getSelectedEvent.AllowVideoConference EQ 1>
								<div class="form-group">
									<label for="H323Participant" class="col-lg-5 col-md-5">Participate via Video Conference:&nbsp;</label>
									<div class="col-lg-7 col-md-7"><cfselect name="H323Participant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant use Video Conference Option for Event</option></cfselect></div>
								</div>
							</cfif>
							<div class="form-group">
								<label for="FacilityParticipant" class="col-lg-5 col-md-5">Participate at Facility:&nbsp;</label>
								<div class="col-lg-7 col-md-7"><cfselect name="FacilityParticipant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant be at Faciity for Event</option></cfselect></div>
							</div>
							<div class="form-group">
								<label for="EmailConfirmations" class="col-lg-5 col-md-5">Send Email Confirmation:&nbsp;</label>
								<div class="col-lg-7 col-md-7"><cfselect name="EmailConfirmations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Send Email Registration Confirmation</option></cfselect></div>
							</div>
							<cfif Session.CheckExistingSentEmailsForEvent.RecordCount>
								<div class="form-group">
									<label for="SendPreviousEmailCommunications" class="col-lg-5 col-md-5">Send Previous Email Communication:&nbsp;</label>
									<div class="col-lg-7 col-md-7"><cfselect name="SendPreviousEmailCommunications" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Send Previous Email Communications to New Participants</option></cfselect></div>
								</div>
							</cfif>
							<div class="form-group">
								<label for="SchoolDistricts" class="col-lg-5 col-md-5">School District:&nbsp;</label>
								<div class="col-lg-7 col-md-7"><cfselect name="SchoolDistricts" class="form-control" Required="Yes" Multiple="No" query="Session.GetMembershipOrganizations" value="TContent_ID" Display="OrganizationName"  queryposition="below"><option value="----">Select School District Participant Is From</option><option value="0">Participant is from a Business</option></cfselect></div>
							</div> --->
						
					</div>
				</cfform>
				
				<script type="text/javascript">
					function AddRow() {
						var msg;

						structvar = {
							Datasource: "#$.globalConfig('datasource')#",
							DBUsername: "#$.globalConfig('dbusername')#",
							DBPassword: "#$.globalConfig('dbpassword')#",
							PackageName: "#Session.PluginFramework.CFCBase#",
							CGIScriptName: "#CGI.Script_name#",
							CGIPathInfo: "#CGI.path_info#",
							EmailConfirmations: "#Session.FormInput.RegisterStep1.EmailConfirmations#",
							SiteID: "#$.siteConfig('siteID')#",
							SiteName: "#$.siteConfig('site')#",
							ContactName: "#$.siteConfig('ContactName')#",
							ContactEmail: "#$.siteConfig('ContactEmail')#",
							ContactPhone: "#$.siteConfig('ContactPhone')#",
							EventID: "#URL.EventID#"
						};

						newuser = {
							Email: document.getElementById("ParticipantEmail").value,
							Fname: document.getElementById("ParticipantFirstName").value,
							Lname: document.getElementById("ParticipantLastName").value
						};

						$.ajax({
							url: "/plugins/#Session.PluginFramework.CFCBase#/eventcoordinator/controllers/events.cfc?method=AddParticipantToDatabase",
							type: "POST",
							dataType: "json",
							data: {
								returnFormat: "json",
								jrStruct: JSON.stringify({"DBInfo": structvar, "UserInfo": newuser})
							},
							success: function(data){
								setTimeout(function(){
									window.location.reload();
								},100);
							},
							error: function(){
							}
						});
					};
				</script>
			</cfcase>
		</cfswitch>
	</cfif>
</cfoutput>