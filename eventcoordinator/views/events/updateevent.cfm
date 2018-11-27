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
	<cfif isDefined("URL.UserAction")>
		<cfswitch expression="#URL.UserAction#">
			<cfcase value="EventRegistrations">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Event Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully updated the event's participant's registration for this event.</p>
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
			</cfcase>			
			<cfcase value="EventOptions">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Event Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully updated the event's options for this event.</p>
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
			</cfcase>			
			<cfcase value="EventPresenter">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Event Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully updated the event's primary presenter who can login and check various options of this event.</p>
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
			</cfcase>			
			<cfcase value="EventWebinar">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Event Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully updated this event's webinar availability for participants to attend the event</p>
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
			</cfcase>			
			<cfcase value="EventPGP">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Event Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully updated this event's professional growth points for participants who attended the event</p>
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
			</cfcase>			
			<cfcase value="EventGroupPrice">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Event Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully updated this event's group pricing requirement discount that participants can take advantage who attend at the physical location</p>
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
			</cfcase>
			<cfcase value="EventEarlyBird">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Event Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully updated this event's early bird discount options that a participant can take advantage to attend at the physical location</p>
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
			</cfcase>
			<cfcase value="EventPrices">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Event Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully updated this event's pricing information for a participant to attend at the physical location</p>
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
			</cfcase>
			<cfcase value="EventDescriptions">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Event Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully updated this event's descriptions with new information</p>
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
			</cfcase>
			<cfcase value="EventDates">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Event Updated</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully updated this event with new information regarding the event's date and times</p>
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
			</cfcase>
		</cfswitch>
	</cfif>
				
	<div class="panel panel-default">
		<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
			<cfinput type="hidden" name="PerformAction" value="Step2">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Update Event</h2></legend>
				</fieldset>
				<fieldset>
					<legend><h2>Date and Time Information <a href="#buildURL('eventcoordinator:events.updateevent_dates')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="EventDate" class="col-lg-5 col-md-5">Primary Event Date:&nbsp;</label>
					<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.getSelectedEvent.EventDate, "full")#</p></div>
				</div>
				<div class="form-group">
					<label for="EventSpanDates" class="col-lg-5 col-md-5">Event has Multiple Dates:&nbsp;</label>
					<div class="col-lg-7">
						<cfif Session.getSelectedEvent.Event_HasMultipleDates CONTAINS 1><p class="form-control-static">Yes</p><cfelse><p class="form-control-static">No</p></cfif>
					</div>
				</div>
				<cfif Session.getSelectedEvent.Event_HasMultipleDates CONTAINS 1>
					<div class="form-group">
						<label for="EventDate1" class="col-lg-5 col-md-5">Second Event Date:&nbsp;</label>
						<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.getSelectedEvent.EventDate1, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate2" class="col-lg-5 col-md-5">Third Event Date:&nbsp;</label>
						<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.getSelectedEvent.EventDate2, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate3" class="col-lg-5 col-md-5">Fourth Event Date:&nbsp;</label>
						<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.getSelectedEvent.EventDate3, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventDate4" class="col-lg-5 col-md-5">Fifth Event Date:&nbsp;</label>
						<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.getSelectedEvent.EventDate4, "full")#</p></div>
					</div>
				</cfif>
				<div class="form-group">
					<label for="Registration_Deadline" class="col-lg-5 col-md-5">Registration Deadline:&nbsp;</label>
					<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.getSelectedEvent.Registration_Deadline, "full")#</p></div>
				</div>
				<div class="form-group">
					<label for="Registration_BeginTime" class="col-lg-5 col-md-5">Registration Start Time:&nbsp;</label>
					<div class="col-lg-7">
						<p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Registration_BeginTime, "hh:mm tt")#</p>
					</div>
				</div>
				<div class="form-group">
					<label for="Event_StartTime" class="col-lg-5 col-md-5">Event Start Time:&nbsp;</label>
					<div class="col-lg-7">							
						<p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Event_StartTime, "hh:mm tt")#</p>
					</div>
				</div>
				<div class="form-group">
					<label for="Event_EndTime" class="col-lg-5 col-md-5">Event End Time:&nbsp;</label>
					<div class="col-lg-7">
						<p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Event_EndTime, "hh:mm tt")#</p>
						</div>
				</div>
				<div class="form-group">
					<label for="Event_DailySessions" class="col-lg-5 col-md-5">Event has Daily Sessions:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.Event_DailySessions CONTAINS 1>Yes<cfelse>No</cfif>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Allow Event to have AM and PM Sessions)</div>
					</div>
				</div>
				<cfif Session.getSelectedEvent.Event_DailySessions CONTAINS 1>
					<div class="form-group">
						<label for="Event_Session1BeginTime" class="col-lg-5 col-md-5">First Session Begin Time:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.getSelectedEvent.Event_Session1BeginTime, "hh:mm tt")#</div>
					</div>
					<div class="form-group">
						<label for="Event_Session1EndTime" class="col-lg-5 col-md-5">First Session End Time:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.getSelectedEvent.Event_Session1EndTime, "hh:mm tt")#</div>
					</div>
					<div class="form-group">
						<label for="Event_Session2BeginTime" class="col-lg-5 col-md-5">Second Session Begin Time:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.getSelectedEvent.Event_Session2BeginTime, "hh:mm tt")#</div>
					</div>
					<div class="form-group">
						<label for="Event_Session2EndTime" class="col-lg-5 col-md-5">Seocnd Session End Time:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.getSelectedEvent.Event_Session2EndTime, "hh:mm tt")#</div>
					</div>
				</cfif>
				<fieldset>
					<legend><h2>Event Description Information <a href="#buildURL('eventcoordinator:events.updateevent_description')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="ShortTitle" class="col-lg-5 col-md-5">Short Title:&nbsp;</label>
					<div class="col-lg-7"><p class="form-control-static">#Session.getSelectedEvent.ShortTitle#</p></div>
				</div>
				<div class="form-group">
					<label for="LongDescription" class="col-lg-5 col-md-5">Description:&nbsp;</label>
					<div class="col-lg-7"><p class="form-control-static">#Session.getSelectedEvent.LongDescription#</p></div>
				</div>
				<div class="form-group">
					<label for="EventAgenda" class="col-lg-5 col-md-5">Agenda:&nbsp;</label>
					<div class="col-lg-7"><p class="form-control-static">#Session.getSelectedEvent.EventAgenda#</p></div>
				</div>
				<div class="form-group">
					<label for="EventTargetAudience" class="col-lg-5 col-md-5">Target Audience:&nbsp;</label>
					<div class="col-lg-7"><p class="form-control-static">#Session.getSelectedEvent.EventTargetAudience#</p></div>
				</div>
				<div class="form-group">
					<label for="EventStrategies" class="col-lg-5 col-md-5">Strategies:&nbsp;</label>
					<div class="col-lg-7"><p class="form-control-static">#Session.getSelectedEvent.EventStrategies#</p></div>
				</div>
				<div class="form-group">
					<label for="EventSpecialInstructions" class="col-lg-5 col-md-5">Special Instructions:&nbsp;</label>
					<div class="col-lg-7"><p class="form-control-static">#Session.getSelectedEvent.EventSpecialInstructions#</p></div>
				</div>
				<div class="form-group">
					<label for="EventSpecialAlertMessage" class="col-lg-5 col-md-5">Special Alert Message:&nbsp;</label>
					<div class="col-lg-7"><p class="form-control-static">#Session.getSelectedEvent.Event_SpecialMessage#</p></div>
				</div>
				<fieldset>
					<legend><h2>Event At Location Pricing <a href="#buildURL('eventcoordinator:events.updateevent_pricing')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="Event_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;</label>
					<div class="col-lg-7 form-control-static">#DollarFormat(Session.getSelectedEvent.Event_MemberCost)#</div>
				</div>
				<div class="form-group">
					<label for="Event_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;</label>
					<div class="col-lg-7 form-control-static">#DollarFormat(Session.getSelectedEvent.Event_NonMemberCost)#</div>
				</div>
				<div class="form-group">
					<label for="EventCostPerDay" class="col-lg-5 col-md-5">Bill Per Event Date:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.EventPricePerDay Contains 1>Yes <div class="form-check-label" style="Color: ##CCCCCC;">(Bill Participants Per Day instead of by Event)</div>
						<cfelse>
						No <div class="form-check-label" style="Color: ##CCCCCC;">(Bill Participants Per Day instead of by Event)</div>
						</cfif>
					</div>
				</div>
				<fieldset>
					<legend><h2>Event Held At Location <a href="#buildURL('eventcoordinator:events.updateevent_location')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="LocationID" class="col-lg-5 col-md-5">Location for Event:&nbsp;</label>
					<div class="col-lg-7 form-control-static">#Session.getSelectedFacility.FacilityName#</div>
				</div>
				<div class="form-group">
					<label for="LocationID" class="col-lg-5 col-md-5">Meeting Room at Facility:&nbsp;</label>
					<div class="col-lg-7 form-control-static">#Session.GetSelectedFacilityRoomInfo.RoomName#</div>
				</div>
				<div class="form-group">
					<label for="LocationID" class="col-lg-5 col-md-5">Maximum Participants:&nbsp;</label>
					<div class="col-lg-7 form-control-static">#Session.getSelectedEvent.Event_MaxParticipants#</div>
				</div>
				<div class="form-group">
					<label for="LocationID" class="col-lg-5 col-md-5">Primary Presenter:&nbsp;</label>
					<div class="col-lg-7 form-control-static">
						<cfif LEN(Session.getSelectedEvent.PresenterID) EQ 1>Nobody Selected<cfelse>#Session.getSelectedPresenterInfo.Fname# #Session.getSelectedPresenterInfo.Lname#</cfif>
					</div>
				</div>
				<fieldset>
					<legend><h2>Event Featured Information <a href="#buildURL('eventcoordinator:events.updateevent_featured')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="EventFeatured" class="col-lg-5 col-md-5">Event is Featured:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.Featured_Event CONTAINS 1>Yes<cfelse>No</cfif>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div>
					</div>
				</div>
				<cfif Session.getSelectedEvent.Featured_Event CONTAINS 1>
					<div class="form-group">
						<label for="Featured_StartDate" class="col-lg-5 col-md-5">Featured Start Date:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DateFormat(Session.getSelectedEvent.Featured_StartDate, "full")#</div>
					</div>
					<div class="form-group">
						<label for="Featured_EndDate" class="col-lg-5 col-md-5">Featured End date:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DateFormat(Session.getSelectedEvent.Featured_EndDate, "full")#</div>
					</div>
				</cfif>
				<fieldset>
					<legend><h2>Event Early Bird Reservations <a href="#buildURL('eventcoordinator:events.updateevent_earlybird')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>	
				<div class="form-group">
					<label for="EarlyBird_RegistrationAvailable" class="col-lg-5 col-md-5">Earlybird Registration Available:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.EarlyBird_Available CONTAINS 1>Yes<cfelse>No</cfif>
						<div class=form-check-label" style="Color: ##CCCCCC;">(Enable Early Bird Registrations for Event)</div>
					</div>
				</div>
				<cfif Session.getSelectedEvent.EarlyBird_Available CONTAINS 1>
					<div class="form-group">
						<label for="EarlyBird_Deadline" class="col-lg-5 col-md-5">Early Registration Deadline:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DateFormat(Session.getSelectedEvent.EarlyBird_Deadline, "full")#</div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DollarFormat(Session.getSelectedEvent.EarlyBird_MemberCost)#</div>
					</div>
					<div class="form-group">
						<label for="EarlyBird_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DollarFormat(Session.getSelectedEvent.EarlyBird_NonMemberCost)#</div>
					</div>
				</cfif>
				<fieldset>
					<legend><h2>Event Group Pricing Information <a href="#buildURL('eventcoordinator:events.updateevent_groupprice')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="ViewGroupPricing" class="col-lg-5 col-md-5">Group Pricing Available:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.GroupPrice_Available CONTAINS 1>Yes<cfelse>No</cfif>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Enable Group Pricing for Event)</div>
					</div>
				</div>
				<cfif Session.getSelectedEvent.GroupPrice_Available CONTAINS 1>
					<div class="form-group">
						<label for="GroupPriceRequirements" class="col-lg-5 col-md-5">Group Requirements:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#Session.getSelectedEvent.GroupPrice_Requirements#</div>
					</div>
					<div class="form-group">
						<label for="GroupMemberCost" class="col-lg-5 col-md-5">Group Member Pricing:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DollarFormat(Session.getSelectedEvent.GroupPrice_MemberCost)#</div>
					</div>
					<div class="form-group">
						<label for="GroupNonMemberCost" class="col-lg-5 col-md-5">Group NonMember Pricing:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DollarFormat(Session.getSelectedEvent.GroupPrice_NonMemberCost)#</div>
					</div>
				</cfif>
				<fieldset>
					<legend><h2>Professional Growth Point Information <a href="#buildURL('eventcoordinator:events.updateevent_pgp')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="PGPAvailable" class="col-lg-5 col-md-5">PGP Certificate Available:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.PGPCertificate_Available CONTAINS 1>Yes<cfelse>No</cfif>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Enable Professional Growth Points for Event)</div>
					</div>
				</div>
				<cfif Session.getSelectedEvent.PGPCertificate_Available CONTAINS 1>
					<cfif Session.getSelectedEvent.EventPricePerDay EQ 1>
						<div class="form-group">
							<label for="PGPPoints" class="col-lg-5 col-md-5">Number of PGP Points Per Day:&nbsp;</label>
							<div class="form-control-static col-lg-7 col-md-7">#NumberFormat(Session.getSelectedEvent.PGPCertificate_Points, "99.99")#</div>
						</div>
					<cfelse>
						<div class="form-group">
							<label for="PGPPoints" class="col-lg-5 col-md-5">Number of PGP Points Per Event:&nbsp;</label>
							<div class="form-control-static col-lg-7 col-md-7">#NumberFormat(Session.getSelectedEvent.PGPCertificate_Points, "99.99")#</div>
						</div>
					</cfif>
				</cfif>
				<fieldset>
					<legend><h2>Meal Availability <a href="#buildURL('eventcoordinator:events.updateevent_meal')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="MealAvailable" class="col-lg-5 col-md-5">Meal Available:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.Meal_Available CONTAINS 1>Yes<cfelse>No</cfif>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Enable a Meal to those who attend this event)</div>
					</div>
				</div>
				<cfif Session.getSelectedEvent.Meal_Available CONTAINS 1>
					<div class="form-group">
						<label for="Meal_Included" class="col-lg-5 col-md-5">Meal Included in Cost:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfswitch expression="#Session.getSelectedEvent.Meal_Included#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
						</div>
					</div>
					<div class="form-group">
						<label for="Meal_ProvidedBy" class="col-lg-5 col-md-5">Meal Provided By:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#Session.getSelectedCatererInfo.FacilityName#</div>
					</div>
					<div class="form-group">
						<label for="MealInformation" class="col-lg-5 col-md-5">Meal Information:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#Session.getSelectedEvent.Meal_Information#</div>
					</div>
					<div class="form-group">
						<label for="MealCost" class="col-lg-5 col-md-5">Meal Cost:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DollarFormat(Session.getSelectedEvent.Meal_Cost)#</div>
					</div>
				</cfif>
				<fieldset>
					<legend><h2>Allow Video Conference (H323) <a href="#buildURL('eventcoordinator:events.updateevent_h323')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="AllowVideoConference" class="col-lg-5 col-md-5">Is Distance Education Available:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.H323_Available CONTAINS 1>Yes<cfelse>No</cfif>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Enable Distance Education for this event)</div>
					</div>
				</div>
				<cfif Session.getSelectedEvent.H323_Available CONTAINS 1>
					<div class="form-group">
						<label for="H323ConnectionInfo" class="col-lg-5 col-md-5">Connection Information:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#Session.getSelectedEvent.H323_ConnectInfo#</div>
					</div>
					<div class="form-group">
						<label for="H323ConnectionMemberCost" class="col-lg-5 col-md-5">Member Pricing:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DollarFormat(Session.getSelectedEvent.H323_MemberCost)#</div>
					</div>
					<div class="form-group">
						<label for="H323ConnectionNonMemberCost" class="col-lg-5 col-md-5">NonMember Pricing:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DollarFormat(Session.getSelectedEvent.H323_NonMemberCost)#</div>
					</div>
				</cfif>
				<fieldset>
					<legend><h2>Allow Webinar Information <a href="#buildURL('eventcoordinator:events.updateevent_webinar')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></h2></a></legend>
				</fieldset>
				<div class="form-group">
					<label for="WebinarEvent" class="col-lg-5 col-md-5">Webinar Only Event:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.Webinar_Available CONTAINS 1>Yes<cfelse>No</cfif>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Enable Webinar Participants to this event)</div>
					</div>
				</div>
				<cfif Session.getSelectedEvent.Webinar_Available CONTAINS 1>
					<div class="form-group">
						<label for="Webinar_ConnectInfo" class="col-lg-5 col-md-5">Connection Information:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#Session.getSelectedEvent.Webinar_ConnectInfo#</div>
					</div>
					<div class="form-group">
						<label for="WebinarMemberCost" class="col-lg-5 col-md-5">Member Cost to Attend via this:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DollarFormat(Session.getSelectedEvent.Webinar_MemberCost)#</div>
					</div>
					<div class="form-group">
						<label for="WebinarNonMemberCost" class="col-lg-5 col-md-5">NonMember Cost to Attend via this:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">#DollarFormat(Session.getSelectedEvent.Webinar_NonMemberCost)#</div>
					</div>
				</cfif>
				<fieldset>
					<legend><h2>Primary Presenter <a href="#buildURL('eventcoordinator:events.updateevent_presenter')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></h2></a></legend>
				</fieldset>
				<div class="form-group">
					<label for="EventPresenter" class="col-lg-5 col-md-5">Primary Presenter:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif LEN(Session.getSelectedEvent.PresenterID)>#Session.getSelectedPresenterInfo.FName# #Session.getSelectedPresenterInfo.LName#<cfelse>Nobody Selected</cfif>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Primary Presenter of this event)</div>
					</div>
				</div>

				<fieldset>
					<legend><h2>Event Has Optional Settings <a href="#buildURL('eventcoordinator:events.updateevent_options')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="EventHasOptionalCosts" class="col-lg-5 col-md-5">Has Optional Costs:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.Event_OptionalCosts CONTAINS 1>Yes<cfelse>No</cfif>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Enable Optional Costs to Registration Fee for Event)</div>
					</div>
				</div>
				<cfif Session.getSelectedEvent.Event_OptionalCosts CONTAINS 1>

				</cfif>
				<div class="form-group">
					<label for="PostEventToFB" class="col-lg-5 col-md-5">Post to FB Fan Page:&nbsp;&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.PostedTo_Facebook CONTAINS 1>Yes<cfelse>No</cfif>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Post this Event to Facebook Fan Page)</div>
					</div>
				</div>
				<div class="form-group">
					<label for="BillForNoSHow" class="col-lg-5 col-md-5">Bill For NoShow:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfif Session.getSelectedEvent.BillForNoShow CONTAINS 1>Yes<cfelse>No</cfif>
						<div class="form-check-label" style="Color: ##CCCCCC;">(Enable billing of participants who do not show to this event)</div>
					</div>
				</div>
				<fieldset>
					<legend><h2>Allow Participants Registrations <a href="#buildURL('eventcoordinator:events.updateevent_registrations')#&EventID=#URL.EventID#"><span class="pull-right glyphicon glyphicon-pencil" aria-hidden="true"></span></a></h2></legend>
				</fieldset>
				<div class="form-group">
					<label for="AcceptRegistrations" class="col-lg-5 col-md-5">Accept Registrations:&nbsp;</label>
					<div class="form-control-static col-lg-7 col-md-7">
						<cfswitch expression="#Session.getSelectedEvent.AcceptRegistrations#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
					</div>
				</div>
				<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Return to Event Listing"><br /><br />
			</div>
			</div>
			
		</cfform>
	</div>
</cfoutput>