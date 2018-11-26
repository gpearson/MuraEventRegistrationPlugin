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
						<legend><h2>Signin Participant who attended the event titled:<br>#Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<cfif LEN(Session.getSelectedEvent.EventDate1) or LEN(Session.getSelectedEvent.EventDate2) or LEN(Session.getSelectedEvent.EventDate3) or LEN(Session.getSelectedEvent.EventDate4) or LEN(Session.getSelectedEvent.EventDate5)>
						<div class="panel-body">
							<div class="alert alert-warning">
								<cfif LEN(Session.getSelectedEvent.EventDate1)>
									<p>Day 1: #DateFormat(Session.getSelectedEvent.EventDate, "full")#</p>
									<p>Day 2: #DateFormat(Session.getSelectedEvent.EventDate1, "full")#</p>
								</cfif>
								<cfif LEN(Session.getSelectedEvent.EventDate2)>
									<p>Day 3: #DateFormat(Session.getSelectedEvent.EventDate2, "full")#</p>
								</cfif>
								<cfif LEN(Session.getSelectedEvent.EventDate3)>
									<p>Day 4: #DateFormat(Session.getSelectedEvent.EventDate3, "full")#</p>
								</cfif>
								<cfif LEN(Session.getSelectedEvent.EventDate4)>
									<p>Day 5: #DateFormat(Session.getSelectedEvent.EventDate4, "full")#</p>
								</cfif>
								<cfif LEN(Session.getSelectedEvent.EventDate5)>
									<p>Day 6: #DateFormat(Session.getSelectedEvent.EventDate5, "full")#</p>
								</cfif>
							</div>
						</div>
					</cfif>
					<cfset NumberOfEventDates = 0>
					<cfif Len(Session.getSelectedEvent.EventDate)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate1)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate2)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate3)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate4)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate5)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfset ColWidth = #Variables.NumberOfEventDates# / 100>
					<cfif Session.getRegisteredParticipants.RecordCount>
						<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
							<cfloop query="Session.getRegisteredParticipants">
								<cfquery name="CheckUserAlreadyRegisteredDay1" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate1
									From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
									Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
										p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
										p_EventRegistration_UserRegistrations.RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset CurrentModRow = #Session.getRegisteredParticipants.CurrentRow# MOD 4>
								<cfswitch expression="#Variables.NumberOfEventDates#">
									<cfcase value="1">
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr><td width="25%">
													<cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1>
														<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#
													<cfelse>
														<cfif isDefined("URL.Action")>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#
														<cfelse>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#
														</cfif>
													</cfif>
												</td>
											</cfcase>
											<cfcase value="0">
												<td width="25%">
													<cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1>
														<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#
													<cfelse>
														<cfif isDefined("URL.Action")>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#
														<cfelse>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#
														</cfif>
													</cfif>
												</td>
											</cfcase>
											<cfdefaultcase>
												<td width="25%">
													<cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1>
														<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#
													<cfelse>
														<cfif isDefined("URL.Action")>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#
														<cfelse>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#
														</cfif>
													</cfif>
												</td>
											</cfdefaultcase>
										</cfswitch>
									</cfcase>
									<cfdefaultcase>
										<cfquery name="CheckUserAlreadyRegisteredDay2" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate2
											From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
											Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
												p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
												p_EventRegistration_UserRegistrations.RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay3" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate3
											From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
											Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
												p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
												p_EventRegistration_UserRegistrations.RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay4" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate4
											From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
											Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
												p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
												p_EventRegistration_UserRegistrations.RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay5" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate5
											From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
											Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
												p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
												p_EventRegistration_UserRegistrations.RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay6" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.AttendedEventDate6
											From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
											Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
												p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
												p_EventRegistration_UserRegistrations.RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr>
												<td width="25%">
												<table class="table" width="25%" cellspacing="0" cellpadding="0">
												<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#</td></th>
												<tr>
												<cfswitch expression="#Variables.NumberOfEventDates#">
													<cfcase value="1">
													<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="2">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="3">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="4">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="5">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="6">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RegisterForEventDate6 EQ 1><cfif CheckUserAlreadyRegisteredDay6.AttendedEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
												</cfswitch>
												</tr>
												</table>
												</td>
											</cfcase>
											<cfcase value="0">
												<td width="25%">
												<table class="table" width="25%" cellspacing="0" cellpadding="0">
												<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#</td></th>
												<tr>
												<cfswitch expression="#Variables.NumberOfEventDates#">
													<cfcase value="1">
													<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="2">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="3">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="4">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="5">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="6">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RegisterForEventDate6 EQ 1><cfif CheckUserAlreadyRegisteredDay6.AttendedEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
												</cfswitch>
												</tr>
												</table>
												</td></tr>
											</cfcase>
											<cfdefaultcase>
												<td width="25%">
												<table class="table" width="25%" cellspacing="0" cellpadding="0">
												<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#</td></th>
												<tr>
												<cfswitch expression="#Variables.NumberOfEventDates#">
													<cfcase value="1">
													<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="2">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="3">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="4">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="5">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													</cfcase>
													<cfcase value="6">
													<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></cfif></td>
													<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RegisterForEventDate6 EQ 1><cfif CheckUserAlreadyRegisteredDay6.AttendedEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6" checked disabled>&nbsp;&nbsp;<cfelse><cfif isDefined("URL.Action")><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6" checked>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6">&nbsp;&nbsp;</cfif></cfif></cfif></td>
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
					<cfelse>
						<div id="modelWindowDialog" class="modal fade">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
										<h3>All Registered Participants Marked as Attended to Event</h3>
									</div>
									<div class="modal-body">
										<p class="alert alert-success">You have marked everyone who was registered for this event as attending this event.  Click the Return to Event Listing button to continue your work within this application.</p>
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