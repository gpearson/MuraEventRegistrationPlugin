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
<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>
<cfoutput>
	<script src="/requirements/ckeditor/ckeditor.js"></script>
	<script>
		$(function() {
			$("##EventDate1").datepick();
			$("##EventDate2").datepick();
			$("##EventDate3").datepick();
			$("##EventDate4").datepick();
			$("##Featured_StartDate").datepick();
			$("##Featured_EndDate").datepick();
			$("##EarlyBird_Deadline").datepick();

			$('##EventSession1_StartTime').timepicker({ 'scrollDefault': 'now' });
			$('##EventSession1_EndTime').timepicker({ 'scrollDefault': 'now' });
			$('##EventSession2_StartTime').timepicker({ 'scrollDefault': 'now' });
			$('##EventSession2_EndTime').timepicker({ 'scrollDefault': 'now' });
		});
	</script>
	<cfif Session.getActiveFacilityRooms.RecordCount EQ 0>
		<div id="modelWindowDialog" class="modal fade">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
						<h3>Add Missing Room with #Session.getSelectedFacility.FacilityName#</h3>
					</div>
					<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
						<div class="modal-body">
							<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
							<cfinput type="hidden" name="LocationID" value="#Session.getActiveFacilities.TContent_ID#">
							<cfinput type="hidden" name="formSubmit" value="True">
							<cfinput type="hidden" name="PerformAction" value="AddFacilityRoom">
							<div class="panel-body">
								<div class="form-group">
									<label for="RoomName" class="col-lg-5 col-md-5">Room Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
									<div class="col-sm-7"><cfinput type="text" class="form-control" id="RoomName" name="RoomName" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="RoomCapacity" class="col-lg-5 col-md-5">Maximum Room Capacity:&nbsp;</label>
									<div class="col-sm-7"><cfinput type="text" class="form-control" id="RoomCapacity" name="RoomCapacity" required="yes"></div>
								</div>
								<div class="form-group">
									<label for="RoomFees" class="col-lg-5 col-md-5">Room Fees:&nbsp;</label>
									<div class="col-sm-7"><cfinput type="text" class="form-control" id="RoomFees" name="RoomFees" required="no"></div>
								</div>
							</div>
						</div>
						<div class="modal-footer">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Room Information">
							<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
						</div>
					</cfform>
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
	
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="PerformAction" value="Step2">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 2 of 3 - Add New Event/Workshop</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for it.</div>
					<cfif Session.FormInput.EventStep1.Event_HasMultipleDates CONTAINS 1>
						<fieldset>
							<legend><h2>Additional Dates for Event or Workshop</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="EventDate1" class="col-lg-5 col-md-5">Second Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate1")>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#Session.FormInput.EventStep2.EventDate1#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate2" class="col-lg-5 col-md-5">Third Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate2")>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#Session.FormInput.EventStep2.EventDate2#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate3" class="col-lg-5 col-md-5">Fourth Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate3")>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#Session.FormInput.EventStep2.EventDate3#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate4" class="col-lg-5 col-md-5">Fifth Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate4")>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#Session.FormInput.EventStep2.EventDate4#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Event Facility Room Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Event_HeldAtFacilityID" class="col-lg-5 col-md-5">Location for Event:&nbsp;</label>
						<div class="col-lg-7 col-md-7 col-form-label">#Session.getActiveFacilities.FacilityName#</div>
					</div>
					<div class="form-group">
						<label for="Event_FacilityRoomID" class="col-lg-5 col-md-5">Room Location for Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep2.Event_FacilityRoomID")>
								<cfselect name="Event_FacilityRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilityRooms" value="TContent_ID" Display="RoomName" selected="#Session.FormInput.EventStep2.Event_FacilityRoomID#" queryposition="below"><option value="----">Select Room at Location where Event will be held</option></cfselect>
							<cfelse>
								<cfselect name="Event_FacilityRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilityRooms" value="TContent_ID" Display="RoomName"  queryposition="below"><option value="----">Select Room at Location where Event will be held</option></cfselect>
							</cfif>
						</div>
					</div>

					<cfif Session.FormInput.EventStep1.Featured_Event CONTAINS 1>
						<fieldset>
							<legend><h2>Event Featured Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="Featured_StartDate" class="col-lg-5 col-md-5">Featured Start Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Featured_StartDate")>
									<cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" value="#Session.FormInput.EventStep2.Featured_StartDate#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Featured_EndDate" class="col-lg-5 col-md-5">Featured End date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Featured_EndDate")>
									<cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" value="#Session.FormInput.EventStep2.Featured_EndDate#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<cfif Session.FormInput.EventStep1.Event_DailySessions CONTAINS 1>
						<fieldset>
							<legend><h2>Event Sessions Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="Event_Session1BeginTime" class="col-lg-5 col-md-5">First Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Event_Session1BeginTime")>
									<cfinput type="text" class="form-control" id="Event_Session1BeginTime" name="Event_Session1BeginTime" value="#Session.FormInput.EventStep2.Event_Session1BeginTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session1BeginTime" name="Event_Session1BeginTime" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Event_Session1EndTime" class="col-lg-5 col-md-5">First Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep1.Event_Session1EndTime")>
									<cfinput type="text" class="form-control" id="Event_Session1EndTime" name="Event_Session1EndTime" value="#Session.FormInput.EventStep2.Event_Session1EndTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session1EndTime" name="Event_Session1EndTime" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Event_Session2BeginTime" class="col-lg-5 col-md-5">Second Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Event_Session2BeginTime")>
									<cfinput type="text" class="form-control" id="Event_Session2BeginTime" name="Event_Session2BeginTime" value="#Session.FormInput.EventStep2.Event_Session2BeginTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session2BeginTime" name="Event_Session2BeginTime" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Event_Session2EndTime" class="col-lg-5 col-md-5">Second Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Event_Session2EndTime")>
									<cfinput type="text" class="form-control" id="Event_Session2EndTime" name="Event_Session2EndTime" value="#Session.FormInput.EventStep2.Event_Session2EndTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session2EndTime" name="Event_Session2EndTime" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<cfif Session.FormInput.EventStep1.EarlyBird_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Event Early Bird Reservations</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="EarlyBird_Deadline" class="col-lg-5 col-md-5">Early Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EarlyBird_Deadline")>
									<cfinput type="text" class="form-control" id="EarlyBird_Deadline" name="EarlyBird_Deadline" value="#Session.FormInput.EventStep2.EarlyBird_Deadline#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EarlyBird_Deadline" name="EarlyBird_Deadline" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EarlyBird_MemberCost")>
									<cfinput type="text" class="form-control" id="EarlyBird_MemberCost" name="EarlyBird_MemberCost" value="#Session.FormInput.EventStep2.EarlyBird_MemberCost#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EarlyBird_MemberCost" name="EarlyBird_MemberCost" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EarlyBird_NonMemberCost")>
									<cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#Session.FormInput.EventStep2.EarlyBird_NonMemberCost#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<cfif Session.FormInput.EventStep1.GroupPrice_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Event Group Pricing Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="GroupPrice_Requirements" class="col-lg-5 col-md-5">Group Requirements:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.GroupPrice_Requirements")>
									<textarea name="GroupPrice_Requirements" id="GroupPrice_Requirements" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep2.GroupPrice_Requirements#</textarea>
								<cfelse>
									<textarea name="GroupPrice_Requirements" id="GroupPrice_Requirements" class="form-control form-control-lg" cols="80" rows="10"></textarea>
								</cfif>
								<script>CKEDITOR.replace('GroupPrice_Requirements', {
									// Define the toolbar groups as it is a more accessible solution.
									toolbarGroups: [
										{"name":"basicstyles","groups":["basicstyles"]},
										{"name":"links","groups":["links"]},
										{"name":"paragraph","groups":["list","blocks"]},
										{"name":"document","groups":["mode"]},
										{"name":"insert","groups":["insert"]},
										{"name":"styles","groups":["styles"]},
										{"name":"about","groups":["about"]}
									],
									// Remove the redundant buttons from toolbar groups defined above.
									removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
								} );
								</script>
							</div>
						</div>
						<div class="form-group">
							<label for="GroupPrice_MemberCost" class="col-lg-5 col-md-5">Group Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.GroupPrice_MemberCost")>
									<cfinput type="text" class="form-control" id="GroupPrice_MemberCost" name="GroupPrice_MemberCost" value="#Session.FormInput.EventStep2.GroupPrice_MemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is by Per Day Per Participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="GroupPrice_MemberCost" name="GroupPrice_MemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is by Per Day Per Participant)</div>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="GroupPrice_NonMemberCost" class="col-lg-5 col-md-5">Group NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.GroupPrice_NonMemberCost")>
									<cfinput type="text" class="form-control" id="GroupPrice_NonMemberCost" name="GroupPrice_NonMemberCost" value="#Session.FormInput.EventStep2.GroupPrice_NonMemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is by Per Day Per Participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="GroupPrice_NonMemberCost" name="GroupPrice_NonMemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is by Per Day Per Participant)</div>
								</cfif>
							</div>
						</div>
					</cfif>
					<cfif Session.FormInput.EventStep1.PGPCertificate_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Professional Growth Point Information</h2></legend>
						</fieldset>
						<cfif Session.FormInput.EventStep1.EventPricePerDay EQ 1>
							<div class="form-group">
								<label for="PGPCertificate_Points" class="col-lg-5 col-md-5">Number of PGP Points Per Day:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
								<div class="col-lg-7 col-md-7">
									<cfif isDefined("Session.FormInput.EventStep2.PGPCertificate_Points")>
										<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" value="#Session.FormInput.EventStep2.PGPCertificate_Points#" required="yes">
									<cfelse>
										<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" required="yes">
									</cfif>
								</div>
							</div>
						<cfelse>
							<div class="form-group">
								<label for="PGPCertificate_Points" class="col-lg-5 col-md-5">Number of PGP Points Per Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
								<div class="col-lg-7 col-md-7">
									<cfif isDefined("Session.FormInput.EventStep2.PGPCertificate_Points")>
										<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" value="#Session.FormInput.EventStep2.PGPCertificate_Points#" required="yes">
									<cfelse>
										<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" required="yes">
									</cfif>
								</div>
							</div>
						</cfif>
					</cfif>
					<cfif Session.FormInput.EventStep1.Meal_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Meal Availability</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="Meal_Included" class="col-lg-5 col-md-5">Meal Included in Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Meal_Included")>
									<cfselect name="Meal_Included" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.EventStep2.Meal_Included#" queryposition="below"><option value="----">Is Meal Included in cost of event?</option></cfselect>
								<cfelse>
									<cfselect name="Meal_Included" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Is Meal Included in cost of event?</option></cfselect>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Meal_ProvidedBy" class="col-lg-5 col-md-5">Meal Provided By:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Meal_ProvidedBy")>
									<cfselect name="Meal_ProvidedBy" class="form-control" Required="no" Multiple="No" query="Session.getActiveCaterers" value="TContent_ID" Display="FacilityName" selected="#Session.FormInput.EventStep2.Meal_ProvidedBy#" queryposition="below"><option value="----">Select Who Is Providing the Meal?</option></cfselect>
								<cfelse>
									<cfselect name="Meal_ProvidedBy" class="form-control" Required="no" Multiple="No" query="Session.getActiveCaterers" value="TContent_ID" Display="FacilityName" queryposition="below"><option value="----">Select Who Is Providing the Meal?</option></cfselect>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Meal_Information" class="col-lg-5 col-md-5">Meal Information:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Meal_Information")>
									<textarea name="Meal_Information" id="Meal_Information" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep2.Meal_Information#</textarea>
								<cfelse>
									<textarea name="Meal_Information" id="Meal_Information" class="form-control form-control-lg" cols="80" rows="10"></textarea>
								</cfif>
								<script>CKEDITOR.replace('Meal_Information', {
									// Define the toolbar groups as it is a more accessible solution.
									toolbarGroups: [
										{"name":"basicstyles","groups":["basicstyles"]},
										{"name":"links","groups":["links"]},
										{"name":"paragraph","groups":["list","blocks"]},
										{"name":"document","groups":["mode"]},
										{"name":"insert","groups":["insert"]},
										{"name":"styles","groups":["styles"]},
										{"name":"about","groups":["about"]}
									],
									// Remove the redundant buttons from toolbar groups defined above.
									removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
								} );
								</script>
							</div>
						</div>
						<div class="form-group">
							<label for="Meal_Cost" class="col-lg-5 col-md-5">Meal Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Meal_Cost")>
									<cfinput type="text" class="form-control" id="Meal_Cost" name="Meal_Cost" value="#Session.FormInput.EventStep2.Meal_Cost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost Per Person for Profit/Loss and if Participant Pays Cost)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="Meal_Cost" name="Meal_Cost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost Per Person for Profit/Loss and if Participant Pays Cost)</div>
								</cfif>
							</div>
						</div>
					</cfif>

					<cfif Session.FormInput.EventStep1.H323_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Allow Video Conference (H323)</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="H323_ConnectInfo" class="col-lg-5 col-md-5">Connection Information:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.H323_ConnectInfo")>
									<textarea name="H323_ConnectInfo" id="H323_ConnectInfo" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep2.H323_ConnectInfo#</textarea>
								<cfelse>
									<textarea name="H323_ConnectInfo" id="H323_ConnectInfo" class="form-control form-control-lg" cols="80" rows="10"></textarea>
								</cfif>
								<script>CKEDITOR.replace('H323_ConnectInfo', {
									// Define the toolbar groups as it is a more accessible solution.
									toolbarGroups: [
										{"name":"basicstyles","groups":["basicstyles"]},
										{"name":"links","groups":["links"]},
										{"name":"paragraph","groups":["list","blocks"]},
										{"name":"document","groups":["mode"]},
										{"name":"insert","groups":["insert"]},
										{"name":"styles","groups":["styles"]},
										{"name":"about","groups":["about"]}
									],
									// Remove the redundant buttons from toolbar groups defined above.
									removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
								} );
								</script>
							</div>
						</div>
						<div class="form-group">
							<label for="H323_MemberCost" class="col-lg-5 col-md-5">Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.H323_MemberCost")>
									<cfinput type="text" class="form-control" id="H323_MemberCost" name="H323_MemberCost" value="#Session.FormInput.EventStep2.H323_MemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="H323_MemberCost" name="H323_MemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="H323_NonMemberCost" class="col-lg-5 col-md-5">NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.H323_NonMemberCost")>
									<cfinput type="text" class="form-control" id="H323_NonMemberCost" name="H323_NonMemberCost" value="#Session.FormInput.EventStep2.H323_NonMemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="H323_NonMemberCost" name="H323_NonMemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								</cfif>
							</div>
						</div>
					</cfif>

					<cfif Session.FormInput.EventStep1.Webinar_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Allow Webinar Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="Webinar_ConnectInfo" class="col-lg-5 col-md-5">Connection Information:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Webinar_ConnectInfo")>
									<textarea name="Webinar_ConnectInfo" id="Webinar_ConnectInfo" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep2.Webinar_ConnectInfo#</textarea>
								<cfelse>
									<textarea name="Webinar_ConnectInfo" id="Webinar_ConnectInfo" class="form-control form-control-lg" cols="80" rows="10"></textarea>
								</cfif>
								<script>CKEDITOR.replace('Webinar_ConnectInfo', {
									// Define the toolbar groups as it is a more accessible solution.
									toolbarGroups: [
										{"name":"basicstyles","groups":["basicstyles"]},
										{"name":"links","groups":["links"]},
										{"name":"paragraph","groups":["list","blocks"]},
										{"name":"document","groups":["mode"]},
										{"name":"insert","groups":["insert"]},
										{"name":"styles","groups":["styles"]},
										{"name":"about","groups":["about"]}
									],
									// Remove the redundant buttons from toolbar groups defined above.
									removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
								} );
								</script>
							</div>
						</div>
						<div class="form-group">
							<label for="Webinar_MemberCost" class="col-lg-5 col-md-5">Member Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Webinar_MemberCost")>
									<cfinput type="text" class="form-control" id="Webinar_MemberCost" name="Webinar_MemberCost" value="#Session.FormInput.EventStep2.Webinar_MemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="Webinar_MemberCost" name="Webinar_MemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Webinar_NonMemberCost" class="col-lg-5 col-md-5">NonMember Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Webinar_NonMemberCost")>
									<cfinput type="text" class="form-control" id="Webinar_NonMemberCost" name="Webinar_NonMemberCost" value="#Session.FormInput.EventStep2.Webinar_NonMemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="Webinar_NonMemberCost" name="Webinar_NonMemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								</cfif>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Step 1">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Proceed to Step 3"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddNewEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="Facilitator" value="#Session.Mura.UserID#">
				<cfinput type="hidden" name="PerformAction" value="Step2">
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
						<legend><h2>Step 2 of 3 - Add New Event/Workshop</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for it.</div>
					<cfif Session.FormInput.EventStep1.Event_HasMultipleDates CONTAINS 1>
						<fieldset>
							<legend><h2>Additional Dates for Event or Workshop</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="EventDate1" class="col-lg-5 col-md-5">Second Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate1")>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#Session.FormInput.EventStep2.EventDate1#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate2" class="col-lg-5 col-md-5">Third Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate2")>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#Session.FormInput.EventStep2.EventDate2#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate3" class="col-lg-5 col-md-5">Fourth Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate3")>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#Session.FormInput.EventStep2.EventDate3#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate4" class="col-lg-5 col-md-5">Fifth Event Date:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EventDate4")>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#Session.FormInput.EventStep2.EventDate4#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Event Facility Room Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Event_HeldAtFacilityID" class="col-lg-5 col-md-5">Location for Event:&nbsp;</label>
						<div class="col-lg-7 col-md-7 col-form-label">#Session.getActiveFacilities.FacilityName#</div>
					</div>
					<div class="form-group">
						<label for="Event_FacilityRoomID" class="col-lg-5 col-md-5">Room Location for Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep2.Event_FacilityRoomID")>
								<cfselect name="Event_FacilityRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilityRooms" value="TContent_ID" Display="RoomName" selected="#Session.FormInput.EventStep2.Event_FacilityRoomID#" queryposition="below"><option value="----">Select Room at Location where Event will be held</option></cfselect>
							<cfelse>
								<cfselect name="Event_FacilityRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getActiveFacilityRooms" value="TContent_ID" Display="RoomName"  queryposition="below"><option value="----">Select Room at Location where Event will be held</option></cfselect>
							</cfif>
						</div>
					</div>

					<cfif Session.FormInput.EventStep1.Featured_Event CONTAINS 1>
						<fieldset>
							<legend><h2>Event Featured Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="Featured_StartDate" class="col-lg-5 col-md-5">Featured Start Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Featured_StartDate")>
									<cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" value="#Session.FormInput.EventStep2.Featured_StartDate#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Featured_EndDate" class="col-lg-5 col-md-5">Featured End date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Featured_EndDate")>
									<cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" value="#Session.FormInput.EventStep2.Featured_EndDate#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<cfif Session.FormInput.EventStep1.Event_DailySessions CONTAINS 1>
						<fieldset>
							<legend><h2>Event Sessions Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="Event_Session1BeginTime" class="col-lg-5 col-md-5">First Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Event_Session1BeginTime")>
									<cfinput type="text" class="form-control" id="Event_Session1BeginTime" name="Event_Session1BeginTime" value="#Session.FormInput.EventStep2.Event_Session1BeginTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session1BeginTime" name="Event_Session1BeginTime" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Event_Session1EndTime" class="col-lg-5 col-md-5">First Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep1.Event_Session1EndTime")>
									<cfinput type="text" class="form-control" id="Event_Session1EndTime" name="Event_Session1EndTime" value="#Session.FormInput.EventStep2.Event_Session1EndTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session1EndTime" name="Event_Session1EndTime" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Event_Session2BeginTime" class="col-lg-5 col-md-5">Second Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Event_Session2BeginTime")>
									<cfinput type="text" class="form-control" id="Event_Session2BeginTime" name="Event_Session2BeginTime" value="#Session.FormInput.EventStep2.Event_Session2BeginTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session2BeginTime" name="Event_Session2BeginTime" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Event_Session2EndTime" class="col-lg-5 col-md-5">Second Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Event_Session2EndTime")>
									<cfinput type="text" class="form-control" id="Event_Session2EndTime" name="Event_Session2EndTime" value="#Session.FormInput.EventStep2.Event_Session2EndTime#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="Event_Session2EndTime" name="Event_Session2EndTime" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<cfif Session.FormInput.EventStep1.EarlyBird_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Event Early Bird Reservations</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="EarlyBird_Deadline" class="col-lg-5 col-md-5">Early Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EarlyBird_Deadline")>
									<cfinput type="text" class="form-control" id="EarlyBird_Deadline" name="EarlyBird_Deadline" value="#Session.FormInput.EventStep2.EarlyBird_Deadline#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EarlyBird_Deadline" name="EarlyBird_Deadline" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EarlyBird_MemberCost")>
									<cfinput type="text" class="form-control" id="EarlyBird_MemberCost" name="EarlyBird_MemberCost" value="#Session.FormInput.EventStep2.EarlyBird_MemberCost#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EarlyBird_MemberCost" name="EarlyBird_MemberCost" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.EarlyBird_NonMemberCost")>
									<cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#Session.FormInput.EventStep2.EarlyBird_NonMemberCost#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<cfif Session.FormInput.EventStep1.GroupPrice_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Event Group Pricing Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="GroupPrice_Requirements" class="col-lg-5 col-md-5">Group Requirements:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.GroupPrice_Requirements")>
									<textarea name="GroupPrice_Requirements" id="GroupPrice_Requirements" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep2.GroupPrice_Requirements#</textarea>
								<cfelse>
									<textarea name="GroupPrice_Requirements" id="GroupPrice_Requirements" class="form-control form-control-lg" cols="80" rows="10"></textarea>
								</cfif>
								<script>CKEDITOR.replace('GroupPrice_Requirements', {
									// Define the toolbar groups as it is a more accessible solution.
									toolbarGroups: [
										{"name":"basicstyles","groups":["basicstyles"]},
										{"name":"links","groups":["links"]},
										{"name":"paragraph","groups":["list","blocks"]},
										{"name":"document","groups":["mode"]},
										{"name":"insert","groups":["insert"]},
										{"name":"styles","groups":["styles"]},
										{"name":"about","groups":["about"]}
									],
									// Remove the redundant buttons from toolbar groups defined above.
									removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
								} );
								</script>
							</div>
						</div>
						<div class="form-group">
							<label for="GroupPrice_MemberCost" class="col-lg-5 col-md-5">Group Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.GroupPrice_MemberCost")>
									<cfinput type="text" class="form-control" id="GroupPrice_MemberCost" name="GroupPrice_MemberCost" value="#Session.FormInput.EventStep2.GroupPrice_MemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is by Per Day Per Participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="GroupPrice_MemberCost" name="GroupPrice_MemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is by Per Day Per Participant)</div>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="GroupPrice_NonMemberCost" class="col-lg-5 col-md-5">Group NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.GroupPrice_NonMemberCost")>
									<cfinput type="text" class="form-control" id="GroupPrice_NonMemberCost" name="GroupPrice_NonMemberCost" value="#Session.FormInput.EventStep2.GroupPrice_NonMemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is by Per Day Per Participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="GroupPrice_NonMemberCost" name="GroupPrice_NonMemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost is by Per Day Per Participant)</div>
								</cfif>
							</div>
						</div>
					</cfif>
					<cfif Session.FormInput.EventStep1.PGPCertificate_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Professional Growth Point Information</h2></legend>
						</fieldset>
						<cfif Session.FormInput.EventStep1.EventPricePerDay EQ 1>
							<div class="form-group">
								<label for="PGPCertificate_Points" class="col-lg-5 col-md-5">Number of PGP Points Per Day:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
								<div class="col-lg-7 col-md-7">
									<cfif isDefined("Session.FormInput.EventStep2.PGPCertificate_Points")>
										<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" value="#Session.FormInput.EventStep2.PGPCertificate_Points#" required="yes">
									<cfelse>
										<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" required="yes">
									</cfif>
								</div>
							</div>
						<cfelse>
							<div class="form-group">
								<label for="PGPCertificate_Points" class="col-lg-5 col-md-5">Number of PGP Points Per Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
								<div class="col-lg-7 col-md-7">
									<cfif isDefined("Session.FormInput.EventStep2.PGPCertificate_Points")>
										<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" value="#Session.FormInput.EventStep2.PGPCertificate_Points#" required="yes">
									<cfelse>
										<cfinput type="text" class="form-control" id="PGPCertificate_Points" name="PGPCertificate_Points" required="yes">
									</cfif>
								</div>
							</div>
						</cfif>
					</cfif>
					<cfif Session.FormInput.EventStep1.Meal_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Meal Availability</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="Meal_Included" class="col-lg-5 col-md-5">Meal Included in Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Meal_Included")>
									<cfselect name="Meal_Included" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" selected="#Session.FormInput.EventStep2.Meal_Included#" queryposition="below"><option value="----">Is Meal Included in cost of event?</option></cfselect>
								<cfelse>
									<cfselect name="Meal_Included" class="form-control" Required="no" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Is Meal Included in cost of event?</option></cfselect>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Meal_ProvidedBy" class="col-lg-5 col-md-5">Meal Provided By:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Meal_ProvidedBy")>
									<cfselect name="Meal_ProvidedBy" class="form-control" Required="no" Multiple="No" query="Session.getActiveCaterers" value="TContent_ID" Display="FacilityName" selected="#Session.FormInput.EventStep2.Meal_ProvidedBy#" queryposition="below"><option value="----">Select Who Is Providing the Meal?</option></cfselect>
								<cfelse>
									<cfselect name="Meal_ProvidedBy" class="form-control" Required="no" Multiple="No" query="Session.getActiveCaterers" value="TContent_ID" Display="FacilityName" queryposition="below"><option value="----">Select Who Is Providing the Meal?</option></cfselect>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Meal_Information" class="col-lg-5 col-md-5">Meal Information:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Meal_Information")>
									<textarea name="Meal_Information" id="Meal_Information" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep2.Meal_Information#</textarea>
								<cfelse>
									<textarea name="Meal_Information" id="Meal_Information" class="form-control form-control-lg" cols="80" rows="10"></textarea>
								</cfif>
								<script>CKEDITOR.replace('Meal_Information', {
									// Define the toolbar groups as it is a more accessible solution.
									toolbarGroups: [
										{"name":"basicstyles","groups":["basicstyles"]},
										{"name":"links","groups":["links"]},
										{"name":"paragraph","groups":["list","blocks"]},
										{"name":"document","groups":["mode"]},
										{"name":"insert","groups":["insert"]},
										{"name":"styles","groups":["styles"]},
										{"name":"about","groups":["about"]}
									],
									// Remove the redundant buttons from toolbar groups defined above.
									removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
								} );
								</script>
							</div>
						</div>
						<div class="form-group">
							<label for="Meal_Cost" class="col-lg-5 col-md-5">Meal Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Meal_Cost")>
									<cfinput type="text" class="form-control" id="Meal_Cost" name="Meal_Cost" value="#Session.FormInput.EventStep2.Meal_Cost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost Per Person for Profit/Loss and if Participant Pays Cost)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="Meal_Cost" name="Meal_Cost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost Per Person for Profit/Loss and if Participant Pays Cost)</div>
								</cfif>
							</div>
						</div>
					</cfif>

					<cfif Session.FormInput.EventStep1.H323_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Allow Video Conference (H323)</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="H323_ConnectInfo" class="col-lg-5 col-md-5">Connection Information:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.H323_ConnectInfo")>
									<textarea name="H323_ConnectInfo" id="H323_ConnectInfo" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep2.H323_ConnectInfo#</textarea>
								<cfelse>
									<textarea name="H323_ConnectInfo" id="H323_ConnectInfo" class="form-control form-control-lg" cols="80" rows="10"></textarea>
								</cfif>
								<script>CKEDITOR.replace('H323_ConnectInfo', {
									// Define the toolbar groups as it is a more accessible solution.
									toolbarGroups: [
										{"name":"basicstyles","groups":["basicstyles"]},
										{"name":"links","groups":["links"]},
										{"name":"paragraph","groups":["list","blocks"]},
										{"name":"document","groups":["mode"]},
										{"name":"insert","groups":["insert"]},
										{"name":"styles","groups":["styles"]},
										{"name":"about","groups":["about"]}
									],
									// Remove the redundant buttons from toolbar groups defined above.
									removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
								} );
								</script>
							</div>
						</div>
						<div class="form-group">
							<label for="H323_MemberCost" class="col-lg-5 col-md-5">Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.H323_MemberCost")>
									<cfinput type="text" class="form-control" id="H323_MemberCost" name="H323_MemberCost" value="#Session.FormInput.EventStep2.H323_MemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="H323_MemberCost" name="H323_MemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="H323_NonMemberCost" class="col-lg-5 col-md-5">NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.H323_NonMemberCost")>
									<cfinput type="text" class="form-control" id="H323_NonMemberCost" name="H323_NonMemberCost" value="#Session.FormInput.EventStep2.H323_NonMemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="H323_NonMemberCost" name="H323_NonMemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								</cfif>
							</div>
						</div>
					</cfif>

					<cfif Session.FormInput.EventStep1.Webinar_Available CONTAINS 1>
						<fieldset>
							<legend><h2>Allow Webinar Information</h2></legend>
						</fieldset>
						<div class="form-group">
							<label for="Webinar_ConnectInfo" class="col-lg-5 col-md-5">Connection Information:&nbsp;</label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Webinar_ConnectInfo")>
									<textarea name="Webinar_ConnectInfo" id="Webinar_ConnectInfo" class="form-control form-control-lg" cols="80" rows="10">#Session.FormInput.EventStep2.Webinar_ConnectInfo#</textarea>
								<cfelse>
									<textarea name="Webinar_ConnectInfo" id="Webinar_ConnectInfo" class="form-control form-control-lg" cols="80" rows="10"></textarea>
								</cfif>
								<script>CKEDITOR.replace('Webinar_ConnectInfo', {
									// Define the toolbar groups as it is a more accessible solution.
									toolbarGroups: [
										{"name":"basicstyles","groups":["basicstyles"]},
										{"name":"links","groups":["links"]},
										{"name":"paragraph","groups":["list","blocks"]},
										{"name":"document","groups":["mode"]},
										{"name":"insert","groups":["insert"]},
										{"name":"styles","groups":["styles"]},
										{"name":"about","groups":["about"]}
									],
									// Remove the redundant buttons from toolbar groups defined above.
									removeButtons: 'Underline,Strike,Subscript,Superscript,Anchor,Styles,Specialchar'
								} );
								</script>
							</div>
						</div>
						<div class="form-group">
							<label for="Webinar_MemberCost" class="col-lg-5 col-md-5">Member Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Webinar_MemberCost")>
									<cfinput type="text" class="form-control" id="Webinar_MemberCost" name="Webinar_MemberCost" value="#Session.FormInput.EventStep2.Webinar_MemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="Webinar_MemberCost" name="Webinar_MemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="Webinar_NonMemberCost" class="col-lg-5 col-md-5">NonMember Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="col-lg-7 col-md-7">
								<cfif isDefined("Session.FormInput.EventStep2.Webinar_NonMemberCost")>
									<cfinput type="text" class="form-control" id="Webinar_NonMemberCost" name="Webinar_NonMemberCost" value="#Session.FormInput.EventStep2.Webinar_NonMemberCost#" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								<cfelse>
									<cfinput type="text" class="form-control" id="Webinar_NonMemberCost" name="Webinar_NonMemberCost" required="yes"><div class="form-check-label" style="Color: ##CCCCCC;">(Cost to attend per participant)</div>
								</cfif>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Step 1">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Proceed to Step 3"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>