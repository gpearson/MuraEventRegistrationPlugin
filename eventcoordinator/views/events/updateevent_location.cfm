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
	<script src="/requirements/ckeditor/ckeditor.js"></script>
	<cfif not isDefined("Session.FormInput")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="EventPricePerDay" value="0">
				<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="PerformAction" value="Step2">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Event Location</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Event_HeldAtFacilityID" class="col-lg-5 col-md-5">Location for Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep1.Event_HeldAtFacilityID")>
								<cfselect name="Event_HeldAtFacilityID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilities" value="TContent_ID" Display="FacilityName" selected="#Session.FormInput.EventStep1.Event_HeldAtFacilityID#"  queryposition="below"><option value="----">Select Location where Event will be held</option></cfselect>
							<cfelse>
								<cfselect name="Event_HeldAtFacilityID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilities" value="TContent_ID" Display="FacilityName" selected="#Session.getSelectedEvent.Event_HeldAtFacilityID#" queryposition="below"><option value="----">Select Location where Event will be held</option></cfselect>
							</cfif>
						</div>
					</div>
					<div class="panel-footer">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Update Event">
						<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Proceed To Step 2"><br /><br />
					</div>
				</div>
			</cfform>
		</div>
	<cfelse>
		<cfif isDefined("Session.FormInput.EventStep1") and not isDefined("Session.FormInput.EventStep2")>
			<div class="panel panel-default">
				<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
					<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
					<cfinput type="hidden" name="formSubmit" value="true">
					<cfinput type="hidden" name="EventPricePerDay" value="0">
					<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
					<cfinput type="hidden" name="PerformAction" value="Step3">
					<div class="panel-body">
						<fieldset>
							<legend><h2>Update Event Location</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="LocationID" class="col-lg-5 col-md-5">Location for Event:&nbsp;</label>
							<div class="col-sm-7 col-form-label">#Session.getSelectedFacility.FacilityName#</div>
						</div>
						<div class="form-group">
							<label for="Event_FacilityRoomID" class="col-lg-5 col-md-5">Room Location for Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Event_FacilityRoomID")>
									<cfselect name="Event_FacilityRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilityRooms" value="TContent_ID" Display="RoomName" selected="#Session.FormInput.EventStep2.Event_FacilityRoomID#" queryposition="below"><option value="----">Select Room at Location where Event will be held</option></cfselect>
								<cfelse>
									<cfselect name="Event_FacilityRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilityRooms" value="TContent_ID" Display="RoomName" selected="#Session.getSelectedEvent.Event_HeldAtFacilityID#" queryposition="below"><option value="----">Select Room at Location where Event will be held</option></cfselect>
								</cfif>
							</div>
						</div>
						<div class="panel-footer">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Update Event">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Proceed To Step 3"><br /><br />
						</div>
					</div>
				</cfform>
			</div>
		<cfelseif isDefined("Session.FormInput.EventStep1") and isDefined("Session.FormInput.EventStep2") and not isDefined("Session.FormInput.EventStep3")>
			<div class="panel panel-default">
				<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
					<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
					<cfinput type="hidden" name="formSubmit" value="true">
					<cfinput type="hidden" name="EventPricePerDay" value="0">
					<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
					<cfinput type="hidden" name="PerformAction" value="UpdateEvent">
					<cfif isDefined("Session.FormErrors")>
					<cfif ArrayLen(Session.FormErrors)>
						<div id="modelWindowDialog" class="modal fade">
							<div class="modal-dialog">
								<div class="modal-content">
									<div class="modal-header">
										<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
										<h3>Entered Room Capacity Larger than Room Avilibility</h3>
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
							<legend><h2>Update Event Location</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="LocationID" class="col-lg-5 col-md-5">Location for Event:&nbsp;</label>
							<div class="col-sm-7 col-form-label">#Session.getSelectedFacility.FacilityName#</div>
						</div>
						<div class="form-group">
							<label for="LocationID" class="col-lg-5 col-md-5">Room Name at Facility:&nbsp;</label>
							<div class="col-sm-7 col-form-label">#Session.getSelectedFacilityRoom.RoomName#</div>
						</div>
						<div class="form-group">
							<label for="EventMaxParticipants" class="col-lg-5 col-md-5">Maximum Participants:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-sm-7">
								<cfif isDefined("Session.FormInput.EventStep3.EventMaxParticipants")>
									<cfinput type="text" class="form-control" id="EventMaxParticipants" name="EventMaxParticipants" value="#Session.FormInput.EventStep3.EventMaxParticipants#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventMaxParticipants" name="EventMaxParticipants" value="#Session.getSelectedEvent.Event_MaxParticipants#" required="no">
								</cfif>
							</div>
						</div>
						<div class="panel-footer">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Update Event">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event"><br /><br />
						</div>
					</div>
				</cfform>
			</div>
		</cfif>
	</cfif>
</cfoutput>