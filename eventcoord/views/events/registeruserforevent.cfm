<cfsilent>
	<!---
		This file is part of MuraFW1

		copyright 2010-2013 Stephen J. Withington, Jr.
		Licensed under the Apache License, Version v2.0
		http://www.apache.org/licenses/LICENSE-2.0
	--->
</cfsilent>
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
<cfoutput>
	<cfif not isDefined("URL.FormRetry") and not isDefined("URL.EventStatus")>
		<div class="panel panel-default">
			<cfform action="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif Session.getSelectedEvent.WebinarAvailable EQ 0><cfinput type="hidden" name="WebinarParticipant" value="0"></cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Register Participant for: #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="alert alert-info"><p>Complete this form to register users for the selected event</p></div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#</p></div>
					</div>
					<cfif Len(Session.getSelectedEvent.EventDate1)>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Second Event Date:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif Len(Session.getSelectedEvent.EventDate2)>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Third Event Date:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif Len(Session.getSelectedEvent.EventDate3)>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Fourth Event Date:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif Len(Session.getSelectedEvent.EventDate4)>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Fifth Event Date:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate4, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif Len(Session.getSelectedEvent.EventDate5)>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Sixth Event Date:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate5, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.LongDescription#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Location:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getEventLocation.FacilityName# (#Session.getEventLocation.PhysicalAddress# #Session.getEventLocation.PhysicalCity# #Session.getEventLocation.PhysicalState# #Session.getEventLocation.PhysicalZipCode#)</p></div>
					</div>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Participant via Webinar:&nbsp;</label>
							<div class="col-sm-8"><cfselect name="WebinarParticipant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant use Webinar Option for Event</option></cfselect></div>
						</div>
					</cfif>
					<cfif Session.getSelectedEvent.LocationID GT 0 and Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Participant via Facility:&nbsp;</label>
							<div class="col-sm-8"><cfselect name="FacilityParticipant" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant be at Facility for Event</option></cfselect></div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Send Email Confirmations:&nbsp;</label>
						<div class="col-sm-2"><cfinput type="checkbox" name="EmailConfirmations" class="form-control" checked="yes"></div>
						<div class="col-sm-7">&nbsp;</div>
					</div>
					<cfif Session.CheckExistingSentEmailsForEvent.RecordCount>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">ReSend Previous Sent Emails to new Participants:&nbsp;</label>
							<div class="col-sm-2"><cfinput type="checkbox" name="EmailConfirmations" class="form-control" checked="yes"></div>
							<div class="col-sm-7">&nbsp;</div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">School District:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="DistrictName" class="form-control" Required="Yes" Multiple="No" query="Session.GetMembershipOrganizations" value="TContent_ID" Display="OrganizationName"  queryposition="below"><option value="----">Select School District Participant Is From</option><option value="0">Participant is from a Business</option></cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register for Event"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry") and not isDefined("URL.EventStatus")>
		<div class="panel panel-default">
			<cfform action="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=ShowCorporations" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif Session.getSelectedEvent.WebinarAvailable EQ 0><cfinput type="hidden" name="WebinarParticipant" value="0"></cfif>
				<cfif isDefined("Session.FormErrors")>
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
				<div class="panel-body">
					<fieldset>
						<legend><h2>Register Participant for: #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="alert alert-info"><p>Complete this form to register users for the selected event</p></div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#</p></div>
					</div>
					<cfif Len(Session.getSelectedEvent.EventDate1)>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Second Event Date:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif Len(Session.getSelectedEvent.EventDate2)>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Third Event Date:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif Len(Session.getSelectedEvent.EventDate3)>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Fourth Event Date:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif Len(Session.getSelectedEvent.EventDate4)>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Fifth Event Date:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate4, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif Len(Session.getSelectedEvent.EventDate5)>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Sixth Event Date:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate5, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.LongDescription#</p></div>
					</div>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Participant via Webinar:&nbsp;</label>
							<div class="col-sm-8"><cfselect name="WebinarParticipant" class="form-control" selected="#Session.UserRegister.FirstStep.WebinarParticipant#" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant use Webinar Option for Event</option></cfselect></div>
						</div>
					</cfif>
					<cfif Session.getSelectedEvent.LocationID GT 0 and Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">Participant via Facility:&nbsp;</label>
							<div class="col-sm-8"><cfselect name="FacilityParticipant" class="form-control" Required="Yes" selected="#Session.UserRegister.FirstStep.FacilityParticipant#" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Participant be at Facility for Event</option></cfselect></div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Send Email Confirmations:&nbsp;</label>
						<div class="col-sm-2"><cfinput type="checkbox" name="EmailConfirmations" class="form-control" checked="yes"></div>
						<div class="col-sm-7">&nbsp;</div>
					</div>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">School District:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="DistrictName" class="form-control" Required="Yes" selected="#Session.UserRegister.FirstStep.DistrictName#" Multiple="No" query="Session.GetMembershipOrganizations" value="TContent_ID" Display="OrganizationName"  queryposition="below"><option value="----">Select School District Participant Is From</option><option value="0">Participant is from a Business</option></cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register for Event"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.EventID") and isDefined("URL.EventStatus")>
		<cfswitch expression="#URL.EventStatus#">
			<cfcase value="ShowCorporations">
				<div class="panel panel-default">
					<cfform action="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipants" method="post" id="AddEvent" class="form-horizontal">
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
						<div class="panel-body">
							<fieldset>
								<legend><h2>Register Participant for: #Session.getSelectedEvent.ShortTitle#</h2></legend>
							</fieldset>
							<div class="alert alert-warning"><p>To register individuals for this event, simply check individuals from the provided list. <span class="text-danger"><strong>If you are registering someone not on the provided list, please add them in the space below and click the Add button before checking the boxes to register participants.</strong></span></p></div>
						</div>
						<cfif LEN(Session.getSelectedEvent.EventDate1) or LEN(Session.getSelectedEvent.EventDate2) or LEN(Session.getSelectedEvent.EventDate3) or LEN(Session.getSelectedEvent.EventDate4) or LEN(Session.getSelectedEvent.EventDate5)>
							<div class="panel-body">
								<div class="alert alert-warning">
									<cfif LEN(Session.getSelectedEvent.EventDate1)>
										<p>Day 1: #DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#</p>
										<p>Day 2: #DateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yyyy")#</p>
									</cfif>
									<cfif LEN(Session.getSelectedEvent.EventDate2)>
										<p>Day 3: #DateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yyyy")#</p>
									</cfif>
									<cfif LEN(Session.getSelectedEvent.EventDate3)>
										<p>Day 4: #DateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yyyy")#</p>
									</cfif>
									<cfif LEN(Session.getSelectedEvent.EventDate4)>
										<p>Day 5: #DateFormat(Session.getSelectedEvent.EventDate4, "mm/dd/yyyy")#</p>
									</cfif>
									<cfif LEN(Session.getSelectedEvent.EventDate5)>
										<p>Day 6: #DateFormat(Session.getSelectedEvent.EventDate5, "mm/dd/yyyy")#</p>
									</cfif>
								</div>
							</div>
						</cfif>
						<div class="panel-body">
							<cfif Session.getSelectedEvent.MealAvailable EQ 1>
								<div class="form-group">
									<label for="EventDate" class="control-label col-sm-3">Each Participant Staying for Meal?:&nbsp;</label>
									<div class="col-sm-2"><cfinput type="checkbox" name="RegisterParticipantStayForMeal" class="form-control" checked="yes"></div>
									<div class="col-sm-7">&nbsp;</div>
								</div>
							<cfelse>
								<cfinput type="hidden" name="RegisterParticipantStayForMeal" value="0">
							</cfif>
							<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
								<div class="form-group">
									<label for="EventDate" class="control-label col-sm-3">Each Participant Utilizing Webinar Option?:&nbsp;</label>
									<div class="col-sm-8"><cfselect name="RegisterParticipantWebinarOption" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Everyone Participanting via Webinar</option></cfselect></div>
								</div>
							<cfelse>
								<cfinput type="hidden" name="RegisterParticipantWebinarOption" value="0">
							</cfif>
							<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
							<cfloop query="Session.GetSelectedAccountsWithinOrganization">
								<cfquery name="CheckUserAlreadyRegisteredDay1" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
									From p_EventRegistration_UserRegistrations
									Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
										and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
											RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset CurrentModRow = #Session.GetSelectedAccountsWithinOrganization.CurrentRow# MOD 4>
								<cfset NumberOfEventDates = 0>
								<cfif Len(Session.getSelectedEvent.EventDate)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfif Len(Session.getSelectedEvent.EventDate1)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfif Len(Session.getSelectedEvent.EventDate2)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfif Len(Session.getSelectedEvent.EventDate3)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfif Len(Session.getSelectedEvent.EventDate4)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfif Len(Session.getSelectedEvent.EventDate5)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfset ColWidth = #Variables.NumberOfEventDates# / 100>
								<cfswitch expression="#Variables.NumberOfEventDates#">
									<cfcase value="1">
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr><td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" disabled>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelseif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" >&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</cfif></td>
											</cfcase>
											<cfcase value="0">
												<td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" disabled>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelseif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" >&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</cfif></td></tr>
											</cfcase>
											<cfdefaultcase>
												<td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" disabled>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelseif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" >&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</cfif></td>
											</cfdefaultcase>
										</cfswitch>
									</cfcase>
									<cfdefaultcase>
										<cfquery name="CheckUserAlreadyRegisteredDay2" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
											From p_EventRegistration_UserRegistrations
											Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
												and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
													RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay3" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
											From p_EventRegistration_UserRegistrations
											Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
												and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
													RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay4" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
											From p_EventRegistration_UserRegistrations
											Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
												and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
													RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay5" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
											From p_EventRegistration_UserRegistrations
											Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
												and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
													RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay6" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
											From p_EventRegistration_UserRegistrations
											Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
												and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
													RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr>
												<td width="25%">
												<table class="table" width="25%" cellspacing="0" cellpadding="0">
												<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</td></th>
												<tr>
												<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6"></cfif></cfif></td>
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
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6"></cfif></cfif></td>
												</cfcase>
												</cfswitch>
												</tr>
												</table>
												</td></tr>
											</cfcase>
											<cfdefaultcase>
												<td width="25%">
												<table class="table" width="25%" cellspacing="0" cellpadding="0">
												<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</td></th>
												<tr>
												<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6"></cfif></cfif></td>
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
							<!--- <cfswitch expression="#Variables.CurrentModRow#">
								<cfcase value="0"></cfcase>
								<cfcase value="1"><td colspan="3">&nbsp;</td></tr></cfcase>
								<cfdefaultcase><td>&nbsp;</td></tr></cfdefaultcase>
							</cfswitch>
							--->
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
					</cfform>
				</div>
				<cfif not isDefined("Session.UserRegister.FirstStep.EmailConfirmations")><cfset Session.UserRegister.FirstStep.EmailConfirmations = false></cfif>
				<script type="text/javascript">
					function AddRow() {
						var msg;

						structvar = {
							Datasource: "#rc.$.globalConfig('datasource')#",
							DBUsername: "#rc.$.globalConfig('dbusername')#",
							DBPassword: "#rc.$.globalConfig('dbpassword')#",
							PackageName: "#rc.pc.getPackage()#",
							CGIScriptName: "#CGI.Script_name#",
							CGIPathInfo: "#CGI.path_info#",
							EmailConfirmations: "#Session.UserRegister.FirstStep.EmailConfirmations#",
							SiteID: "#rc.$.siteConfig('siteID')#",
							SiteName: "#rc.$.siteConfig('site')#",
							ContactName: "#rc.$.siteConfig('ContactName')#",
							ContactEmail: "#rc.$.siteConfig('ContactEmail')#",
							ContactPhone: "#rc.$.siteConfig('ContactPhone')#",
							EventID: "#URL.EventID#"
						};

						newuser = {
							Email: document.getElementById("ParticipantEmail").value,
							Fname: document.getElementById("ParticipantFirstName").value,
							Lname: document.getElementById("ParticipantLastName").value
						};

						$.ajax({
							url: "/plugins/#rc.pc.getPackage()#/library/components/EventServices.cfc?method=AddParticipantToDatabase",
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
			<cfcase value="RegisterParticipants">
				<div class="panel panel-default">
					<cfform action="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.registeruserforevent&EventID=#URL.EventID#&EventStatus=RegisterParticipants" method="post" id="AddEvent" class="form-horizontal">
						<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
						<cfinput type="hidden" name="formSubmit" value="true">
						<cfif isDefined("Session.FormErrors")>
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
						<div class="panel-body">
							<fieldset>
								<legend><h2>Register Participant for: #Session.getSelectedEvent.ShortTitle#</h2></legend>
							</fieldset>
							<div class="alert alert-warning"><p>To register individuals for this event, simply check individuals from the provided list. <span class="text-danger"><strong>If you are registering someone not on the provided list, please add them in the space below and click the Add button before checking the boxes to register participants.</strong></span></p></div>
						</div>
						<cfif LEN(Session.getSelectedEvent.EventDate1) or LEN(Session.getSelectedEvent.EventDate2) or LEN(Session.getSelectedEvent.EventDate3) or LEN(Session.getSelectedEvent.EventDate4) or LEN(Session.getSelectedEvent.EventDate5)>
							<div class="panel-body">
								<div class="alert alert-warning">
									<cfif LEN(Session.getSelectedEvent.EventDate1)>
										<p>Day 1: #DateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#</p>
										<p>Day 2: #DateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yyyy")#</p>
									</cfif>
									<cfif LEN(Session.getSelectedEvent.EventDate2)>
										<p>Day 3: #DateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yyyy")#</p>
									</cfif>
									<cfif LEN(Session.getSelectedEvent.EventDate3)>
										<p>Day 4: #DateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yyyy")#</p>
									</cfif>
									<cfif LEN(Session.getSelectedEvent.EventDate4)>
										<p>Day 5: #DateFormat(Session.getSelectedEvent.EventDate4, "mm/dd/yyyy")#</p>
									</cfif>
									<cfif LEN(Session.getSelectedEvent.EventDate5)>
										<p>Day 6: #DateFormat(Session.getSelectedEvent.EventDate5, "mm/dd/yyyy")#</p>
									</cfif>
								</div>
							</div>
						</cfif>
						<div class="panel-body">
							<cfif Session.getSelectedEvent.MealAvailable EQ 1>
								<div class="form-group">
									<label for="EventDate" class="control-label col-sm-3">Each Participant Staying for Meal?:&nbsp;</label>
									<div class="col-sm-8"><cfselect name="RegisterParticipantStayForMeal" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Everyone Staying for Meal Being Registered</option></cfselect></div>
								</div>
							<cfelse>
								<cfinput type="hidden" name="RegisterParticipantStayForMeal" value="0">
							</cfif>
							<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
								<div class="form-group">
									<label for="EventDate" class="control-label col-sm-3">Each Participant Utilizing Webinar Option?:&nbsp;</label>
									<div class="col-sm-8"><cfselect name="RegisterParticipantWebinarOption" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Everyone Participanting via Webinar</option></cfselect></div>
								</div>
							<cfelse>
								<cfinput type="hidden" name="RegisterParticipantWebinarOption" value="0">
							</cfif>
							<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
							<cfloop query="Session.GetSelectedAccountsWithinOrganization">
								<cfquery name="CheckUserAlreadyRegisteredDay1" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
									From p_EventRegistration_UserRegistrations
									Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
										and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
											RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								</cfquery>
								<cfset CurrentModRow = #Session.GetSelectedAccountsWithinOrganization.CurrentRow# MOD 4>
								<cfset NumberOfEventDates = 0>
								<cfif Len(Session.getSelectedEvent.EventDate)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfif Len(Session.getSelectedEvent.EventDate1)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfif Len(Session.getSelectedEvent.EventDate2)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfif Len(Session.getSelectedEvent.EventDate3)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfif Len(Session.getSelectedEvent.EventDate4)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfif Len(Session.getSelectedEvent.EventDate5)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
								<cfset ColWidth = #Variables.NumberOfEventDates# / 100>
								<cfswitch expression="#Variables.NumberOfEventDates#">
									<cfcase value="1">
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr><td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" disabled>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelseif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" >&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</cfif></td>
											</cfcase>
											<cfcase value="0">
												<td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" disabled>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelseif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" >&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</cfif></td></tr>
											</cfcase>
											<cfdefaultcase>
												<td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" disabled>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelseif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked>&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" >&nbsp;&nbsp;#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</cfif></td>
											</cfdefaultcase>
										</cfswitch>
									</cfcase>
									<cfdefaultcase>
										<cfquery name="CheckUserAlreadyRegisteredDay2" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
											From p_EventRegistration_UserRegistrations
											Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
												and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
													RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay3" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
											From p_EventRegistration_UserRegistrations
											Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
												and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
													RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay4" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
											From p_EventRegistration_UserRegistrations
											Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
												and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
													RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay5" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
											From p_EventRegistration_UserRegistrations
											Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
												and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
													RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfquery name="CheckUserAlreadyRegisteredDay6" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
											From p_EventRegistration_UserRegistrations
											Where User_ID = <cfqueryparam value="#Session.GetSelectedAccountsWithinOrganization.UserID#" cfsqltype="cf_sql_varchar">
												and EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
													RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										</cfquery>
										<cfswitch expression="#Variables.CurrentModRow#">
											<cfcase value="1">
												<tr>
												<td width="25%">
												<table class="table" width="25%" cellspacing="0" cellpadding="0">
												<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</td></th>
												<tr>
												<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6"></cfif></cfif></td>
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
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6"></cfif></cfif></td>
												</cfcase>
												</cfswitch>
												</tr>
												</table>
												</td></tr>
											</cfcase>
											<cfdefaultcase>
												<td width="25%">
												<table class="table" width="25%" cellspacing="0" cellpadding="0">
												<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetSelectedAccountsWithinOrganization.LName#, #Session.GetSelectedAccountsWithinOrganization.FName#</td></th>
												<tr>
												<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_1"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_2"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_3"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_4"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_5"></cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked disabled><cfelse><cfif Session.GetSelectedAccountsWithinOrganization.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetSelectedAccountsWithinOrganization.UserID#_6"></cfif></cfif></td>
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
							<!--- <cfswitch expression="#Variables.CurrentModRow#">
								<cfcase value="0"></cfcase>
								<cfcase value="1"><td colspan="3">&nbsp;</td></tr></cfcase>
								<cfdefaultcase><td>&nbsp;</td></tr></cfdefaultcase>
							</cfswitch>
							--->
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
					</cfform>
				</div>
				<script type="text/javascript">
		function AddRow() {
			var msg;

			structvar = {
				Datasource: "#rc.$.globalConfig('datasource')#",
				DBUsername: "#rc.$.globalConfig('dbusername')#",
				DBPassword: "#rc.$.globalConfig('dbpassword')#",
				PackageName: "#rc.pc.getPackage()#",
				CGIScriptName: "#CGI.Script_name#",
				CGIPathInfo: "#CGI.path_info#",
				SiteID: "#rc.$.siteConfig('siteID')#",
				SiteName: "#rc.$.siteConfig('site')#",
				ContactName: "#rc.$.siteConfig('ContactName')#",
				ContactEmail: "#rc.$.siteConfig('ContactEmail')#",
				ContactPhone: "#rc.$.siteConfig('ContactPhone')#",
				EventID: "#Session.FormInput.EventID#"
			};

			newuser = {
				Email: document.getElementById("ParticipantEmail").value,
				Fname: document.getElementById("ParticipantFirstName").value,
				Lname: document.getElementById("ParticipantLastName").value
			};

			$.ajax({
				url: "/plugins/#rc.pc.getPackage()#/library/components/EventServices.cfc?method=AddParticipantToDatabase",
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

				error: function(msg){
					alert('Error Message: ' +msg);
				}
			});
		};
	</script>
			</cfcase>
		</cfswitch>
	</cfif>
</cfoutput>
