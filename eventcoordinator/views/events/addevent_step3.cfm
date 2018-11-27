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
</cfsilent>

<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 3 of 3 - Add New Event/Workshop</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for it.</div>
					<fieldset>
						<legend><h2>Event Facility Room Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="LocationID" class="col-lg-5 col-md-5">Location for Event:&nbsp;</label>
						<div class="col-sm-7 col-form-label">#Session.getActiveFacilities.FacilityName#</div>
					</div>
					<div class="form-group">
						<label for="LocationRoomID" class="col-lg-5 col-md-5">Room Information:&nbsp;</label>
						<div class="col-sm-7 col-form-label">#Session.getSelectedFacilityRoomInfo.RoomName#</div>
					</div>
					<div class="form-group">
						<label for="EventMaxParticipants" class="col-lg-5 col-md-5">Maximum Participants:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7">
							<cfif isDefined("Session.FormInput.EventStep3.EventMaxParticipants")>
								<cfinput type="text" class="form-control" id="EventMaxParticipants" name="EventMaxParticipants" value="#Session.FormInput.EventStep3.EventMaxParticipants#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="EventMaxParticipants" name="EventMaxParticipants" value="#Session.getSelectedFacilityRoomInfo.Capacity#" required="no">
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event can Accept Registrations</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AcceptRegistrations" class="col-lg-3 col-md-3">Enable Registrations:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif isDefined("Session.FormInput.EventStep3.AcceptRegistrations")>
								<cfif Session.FormInput.EventStep3.AcceptRegistrations EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="AcceptRegistrations" id="AcceptRegistrations" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Participant Registrations)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="AcceptRegistrations" id="AcceptRegistrations" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Participant Registrations)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="AcceptRegistrations" id="AcceptRegistrations" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Participant Registrations)</div>
							</cfif>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Step 2">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Proceed to Review Event"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
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
						<legend><h2>Step 3 of 3 - Add New Event/Workshop</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for it.</div>
					<fieldset>
						<legend><h2>Event Facility Room Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="LocationID" class="col-lg-5 col-md-5">Location for Event:&nbsp;</label>
						<div class="col-sm-7 col-form-label">#Session.getActiveFacilities.FacilityName#</div>
					</div>
					<div class="form-group">
						<label for="LocationRoomID" class="col-lg-5 col-md-5">Room Information:&nbsp;</label>
						<div class="col-sm-7 col-form-label">#Session.getSelectedFacilityRoomInfo.RoomName#</div>
					</div>
					<div class="form-group">
						<label for="EventMaxParticipants" class="col-lg-5 col-md-5">Maximum Participants:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-7">
							<cfif isDefined("Session.FormInput.EventStep3.EventMaxParticipants")>
								<cfinput type="text" class="form-control" id="EventMaxParticipants" name="EventMaxParticipants" value="#Session.FormInput.EventStep3.EventMaxParticipants#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="EventMaxParticipants" name="EventMaxParticipants" value="#Session.getSelectedFacilityRoomInfo.Capacity#" required="no">
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event can Accept Registrations</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AcceptRegistrations" class="col-lg-3 col-md-3">Enable Registrations:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-8 col-md-8">
							<cfif isDefined("Session.FormInput.EventStep3.AcceptRegistrations")>
								<cfif Session.FormInput.EventStep3.AcceptRegistrations EQ 1>
									<cfinput type="checkbox" class="form-check-input" name="AcceptRegistrations" id="AcceptRegistrations" checked value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Participant Registrations)</div>
								<cfelse>
									<cfinput type="checkbox" class="form-check-input" name="AcceptRegistrations" id="AcceptRegistrations" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Participant Registrations)</div>
								</cfif>
							<cfelse>
								<cfinput type="checkbox" class="form-check-input" name="AcceptRegistrations" id="AcceptRegistrations" value="1"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Participant Registrations)</div>
							</cfif>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Step 2">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Proceed to Review Event"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>