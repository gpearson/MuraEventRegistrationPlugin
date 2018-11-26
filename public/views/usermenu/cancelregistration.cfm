<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
<cfoutput>
<cfif isDefined("URL.EventID") and Session.Mura.IsLoggedIn EQ "True" and not isDefined("URL.FormRetry")>
	<div class="panel panel-default">
		<div class="panel-body">
			<fieldset>
				<legend>Cancel Registration for #Session.GetSelectedEvent.ShortTitle# <cfif Len(Session.GetSelectedEvent.Presenters)><br>(#Session.EventPresenter.FName# #Session.EventPresenter.Lname#)</cfif></legend>
			</fieldset>
			<table class="table" width="100%" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;"><cfif LEN(Session.GetSelectedEvent.EventDate1) or LEN(Session.GetSelectedEvent.EventDate2) or LEN(Session.GetSelectedEvent.EventDate3) or LEN(Session.GetSelectedEvent.EventDate4)>Event Dates:<cfelse>Event Date:</cfif></span></td>
						<td colspan="1" rowspan="1">#DateFormat(Session.GetSelectedEvent.EventDate, "mm/dd/yyyy")# <cfif LEN(Session.GetSelectedEvent.EventDate1)>, #DateFormat(Session.GetSelectedEvent.EventDate1, "mm/dd/yyyy")#</cfif><cfif LEN(Session.GetSelectedEvent.EventDate2)>, #DateFormat(Session.GetSelectedEvent.EventDate2, "mm/dd/yyyy")#</cfif><cfif LEN(Session.GetSelectedEvent.EventDate3)>, #DateFormat(Session.GetSelectedEvent.EventDate3, "mm/dd/yyyy")#</cfif><cfif LEN(Session.GetSelectedEvent.EventDate4)>, #DateFormat(Session.GetSelectedEvent.EventDate4, "mm/dd/yyyy")#</cfif></td>
						<TD colspan="2"><p class="text-primary text-center">All times reflect local time at Event Location</p></TD>
					</tr>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Event Time:</span></td>
						<td style="width: 390px;">#TimeFormat(Session.GetSelectedEvent.Event_StartTime, "hh:mm tt")# till #TimeFormat(Session.GetSelectedEvent.Event_EndTime, "hh:mm tt")#</td>
						<td style="text-align: right; width: 175px;"><span style="font-weight: bold;">Registration Deadline:</span></td>
						<td style="width: 175px;">#DateFormat(Session.GetSelectedEvent.Registration_Deadline, "mm/dd/yyyy")#</td>
					</tr>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Description:</span></td>
						<td colspan="3">#Session.GetSelectedEvent.LongDescription#</td>
					</tr>
					<cfif LEN(Session.GetSelectedEvent.EventAgenda)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Agenda:</span></td>
						<td colspan="3" style="width: 141px;">#Session.GetSelectedEvent.EventAgenda#</td>
						</tr>
					</cfif>
					<cfif LEN(Session.GetSelectedEvent.EventTargetAudience)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Target Audience:</span></td>
						<td colspan="3" style="width: 141px;">#Session.GetSelectedEvent.EventTargetAudience#</td>
						</tr>
					</cfif>
					<cfif LEN(Session.GetSelectedEvent.EventStrategies)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Strategies:</span></td>
						<td colspan="3" style="width: 141px;">#Session.GetSelectedEvent.EventStrategies#</td>
						</tr>
					</cfif>
					<cfif LEN(Session.GetSelectedEvent.EventSpecialInstructions)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Special Instructions:</span></td>
						<td colspan="3">#Session.GetSelectedEvent.EventSpecialInstructions#</td>
						</tr>
					</cfif>
					<cfif Session.GetSelectedEvent.PGPAvailable GT 0 and Session.GetSelectedEvent.MealProvided EQ 1>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">PGP Points:</span></td>
						<td style="width: 390px;">#NumberFormat(Session.GetSelectedEvent.PGPPoints, "999.99")#</td>
						<td style="width: 175px;"><span style="font-weight: bold;">Meal Provided:</span></td>
						<td style="width: 175px;"><cfif Session.GetSelectedEvent.MealProvided EQ 1>Yes<cfelse>No</cfif></td>
						</tr>
					<cfelseif Session.GetSelectedEvent.PGPAvailable GT 0 and Session.GetSelectedEvent.MealProvided EQ 0>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">PGP Points:</span></td>
						<td colspan="3">&nbsp;&nbsp;#NumberFormat(Session.GetSelectedEvent.PGPPoints, "999.99")#</td>
						</tr>
					<cfelseif Session.GetSelectedEvent.PGPAvailable EQ 0 and Session.GetSelectedEvent.MealProvided EQ 1>
						<tr>
						<td colspan="2">&nbsp;</td>
						<td style="width: 175px;"><span style="font-weight: bold;">Meal Provided:</span></td>
						<td style="width: 175px;"><cfif Session.GetSelectedEvent.MealProvided EQ 1>Yes<cfelse>No</cfif></td>
						</tr>
					</cfif>
					<cfif Session.GetSelectedEvent.WebinarAvailable EQ 1>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Webinar Information:</span></td>
						<td colspan="3">#Session.GetSelectedEvent.WebinarConnectInfo#</td>
						</tr>
						<tr>
						<td colspan="4">
						<table border="0" colspan="0" cellspan="0" align="center" width="100%">
						<tr>
						<td width="25%"><span style="font-weight: bold;">Webinar Member Cost:</span></td>
						<td width="25%">#DollarFormat(Session.GetSelectedEvent.WebinarMemberCost)#</td>
						<td width="25%"><span style="font-weight: bold;">Webinar NonMember Cost:</span></td>
						<td width="25%">#DollarFormat(Session.GetSelectedEvent.WebinarNonMemberCost)#</td>
						</tr>
						</table>
						</td>
						</tr>
					</cfif>
					<cfif Session.GetSelectedEvent.WebinarAvailable EQ 0 and Session.GetEventFacility.RecordCount NEQ 0 OR LEN(Session.GetSelectedEvent.WebinarAvailable) EQ 0 and Session.GetEventFacility.RecordCount NEQ 0>
						<tr>
						<td style="width: 141px;" colspan="4">
						<table class="art-article" style="width:100%;">
						<tbody>
						<tr>
						<td style="width: 225px;"><span style="font-weight: bold;">Event Location:</span></td>
						<td style="width: 300px;"><address><strong>#Session.GetEventFacility.FacilityName#</strong><br>
						#Session.GetEventFacility.PhysicalAddress#<BR>
						#Session.GetEventFacility.PhysicalCity#, #Session.GetEventFacility.PhysicalState# #Session.GetEventFacility.PhysicalZipCode#</address><br>
						<abbr title="Phone">P:</abbr> #Session.GetEventFacility.PrimaryVoiceNumber#
						</td>
						<td colspan="1" rowspan="4" style="width: 475px; text-align: center; vertical-align: top;">
						<link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.css" />
						<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.js"></script>
						<div id="map" style="width: 475px; height: 300px;"></div>
						<script>
							var facilitymarker;
							var map = L.map('map');
							map.setView(new L.LatLng(#Session.GetEventFacility.GeoCode_Latitude#, #Session.GetEventFacility.GeoCode_Longitude#), 12);
							L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '', maxZoom: 16 }).addTo(map);
							var FacilityMarker = L.icon({
								iconUrl: '/plugins/#Variables.Framework.Package#/library/LeafLet/images/conference.png'
							});
							var marker = L.marker([#Session.GetEventFacility.GeoCode_Latitude#, #Session.GetEventFacility.GeoCode_Longitude#], {icon: FacilityMarker}).addTo(map);
						</script>
						</td>
						</tr>
						<tr>
						<td><span style="font-weight: bold;">Event Held In:</span></td>
						<td colspan="2" rowspan="1">#Session.GetEventFacilityRoom.RoomName#</td>
						</tr>
						</tbody>
						</table>
						</td>
						</tr>
					<cfelseif Session.GetSelectedEvent.WebinarAvailable EQ 0 and Session.GetEventFacility.RecordCount EQ 0>
						<tr>
						<td style="width: 141px;" colspan="4">
						<h4><strong>Please contact us to find out where this event will be held as this information might not have been available when the event went live to see how much interest was generated.
						</td>
						</tr>
					</cfif>
				</tbody>
			</table>
		</div>
		<div class="panel-footer">
			<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="form-group">
					<label for="CancelRegistration" class="control-label col-sm-3">Really Cancel Registration:&nbsp;</label>
					<div class="col-sm-8"><cfselect name="CancelRegistration" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Do you want to Cancel Registration</option></cfselect></div>
				</div>
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Manage Registrations">
				<cfif DateDiff("d", Now(), Session.GetSelectedEvent.EventDate) GTE 1>
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Cancel Registration">
				</cfif><br /><br />
			</cfform>
		</div>
	</div>
<cfelseif isDefined("URL.EventID") and Session.Mura.IsLoggedIn EQ "True" and isDefined("URL.FormRetry")>
	<div class="panel panel-default">
		<div class="panel-body">
			<fieldset>
				<legend>Cancel Registration for #Session.GetSelectedEvent.ShortTitle# <cfif Len(Session.GetSelectedEvent.Presenters)><br>(#Session.EventPresenter.FName# #Session.EventPresenter.Lname#)</cfif></legend>
			</fieldset>
			<cfif isDefined("Session.FormErrors")>
				<cfif ArrayLen(Session.FormErrors)>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Missing Information to cancel registration</h3>
								</div>
								<div class="modal-body">
									<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
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
				</cfif>
			</cfif>
			<table class="table" width="100%" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;"><cfif LEN(Session.GetSelectedEvent.EventDate1) or LEN(Session.GetSelectedEvent.EventDate2) or LEN(Session.GetSelectedEvent.EventDate3) or LEN(Session.GetSelectedEvent.EventDate4)>Event Dates:<cfelse>Event Date:</cfif></span></td>
						<td colspan="1" rowspan="1">#DateFormat(Session.GetSelectedEvent.EventDate, "mm/dd/yyyy")# <cfif LEN(Session.GetSelectedEvent.EventDate1)>, #DateFormat(Session.GetSelectedEvent.EventDate1, "mm/dd/yyyy")#</cfif><cfif LEN(Session.GetSelectedEvent.EventDate2)>, #DateFormat(Session.GetSelectedEvent.EventDate2, "mm/dd/yyyy")#</cfif><cfif LEN(Session.GetSelectedEvent.EventDate3)>, #DateFormat(Session.GetSelectedEvent.EventDate3, "mm/dd/yyyy")#</cfif><cfif LEN(Session.GetSelectedEvent.EventDate4)>, #DateFormat(Session.GetSelectedEvent.EventDate4, "mm/dd/yyyy")#</cfif></td>
						<TD colspan="2"><p class="text-primary text-center">All times reflect local time at Event Location</p></TD>
					</tr>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Event Time:</span></td>
						<td style="width: 390px;">#TimeFormat(Session.GetSelectedEvent.Event_StartTime, "hh:mm tt")# till #TimeFormat(Session.GetSelectedEvent.Event_EndTime, "hh:mm tt")#</td>
						<td style="text-align: right; width: 175px;"><span style="font-weight: bold;">Registration Deadline:</span></td>
						<td style="width: 175px;">#DateFormat(Session.GetSelectedEvent.Registration_Deadline, "mm/dd/yyyy")#</td>
					</tr>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Description:</span></td>
						<td colspan="3">#Session.GetSelectedEvent.LongDescription#</td>
					</tr>
					<cfif LEN(Session.GetSelectedEvent.EventAgenda)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Agenda:</span></td>
						<td colspan="3" style="width: 141px;">#Session.GetSelectedEvent.EventAgenda#</td>
						</tr>
					</cfif>
					<cfif LEN(Session.GetSelectedEvent.EventTargetAudience)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Target Audience:</span></td>
						<td colspan="3" style="width: 141px;">#Session.GetSelectedEvent.EventTargetAudience#</td>
						</tr>
					</cfif>
					<cfif LEN(Session.GetSelectedEvent.EventStrategies)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Strategies:</span></td>
						<td colspan="3" style="width: 141px;">#Session.GetSelectedEvent.EventStrategies#</td>
						</tr>
					</cfif>
					<cfif LEN(Session.GetSelectedEvent.EventSpecialInstructions)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Special Instructions:</span></td>
						<td colspan="3">#Session.GetSelectedEvent.EventSpecialInstructions#</td>
						</tr>
					</cfif>
					<cfif Session.GetSelectedEvent.PGPAvailable GT 0 and Session.GetSelectedEvent.MealProvided EQ 1>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">PGP Points:</span></td>
						<td style="width: 390px;">#NumberFormat(Session.GetSelectedEvent.PGPPoints, "999.99")#</td>
						<td style="width: 175px;"><span style="font-weight: bold;">Meal Provided:</span></td>
						<td style="width: 175px;"><cfif Session.GetSelectedEvent.MealProvided EQ 1>Yes<cfelse>No</cfif></td>
						</tr>
					<cfelseif Session.GetSelectedEvent.PGPAvailable GT 0 and Session.GetSelectedEvent.MealProvided EQ 0>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">PGP Points:</span></td>
						<td colspan="3">&nbsp;&nbsp;#NumberFormat(Session.GetSelectedEvent.PGPPoints, "999.99")#</td>
						</tr>
					<cfelseif Session.GetSelectedEvent.PGPAvailable EQ 0 and Session.GetSelectedEvent.MealProvided EQ 1>
						<tr>
						<td colspan="2">&nbsp;</td>
						<td style="width: 175px;"><span style="font-weight: bold;">Meal Provided:</span></td>
						<td style="width: 175px;"><cfif Session.GetSelectedEvent.MealProvided EQ 1>Yes<cfelse>No</cfif></td>
						</tr>
					</cfif>
					<cfif Session.GetSelectedEvent.WebinarAvailable EQ 1>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Webinar Information:</span></td>
						<td colspan="3">#Session.GetSelectedEvent.WebinarConnectInfo#</td>
						</tr>
						<tr>
						<td colspan="4">
						<table border="0" colspan="0" cellspan="0" align="center" width="100%">
						<tr>
						<td width="25%"><span style="font-weight: bold;">Webinar Member Cost:</span></td>
						<td width="25%">#DollarFormat(Session.GetSelectedEvent.WebinarMemberCost)#</td>
						<td width="25%"><span style="font-weight: bold;">Webinar NonMember Cost:</span></td>
						<td width="25%">#DollarFormat(Session.GetSelectedEvent.WebinarNonMemberCost)#</td>
						</tr>
						</table>
						</td>
						</tr>
					</cfif>
					<cfif Session.GetSelectedEvent.WebinarAvailable EQ 0 and Session.GetEventFacility.RecordCount NEQ 0 OR LEN(Session.GetSelectedEvent.WebinarAvailable) EQ 0 and Session.GetEventFacility.RecordCount NEQ 0>
						<tr>
						<td style="width: 141px;" colspan="4">
						<table class="art-article" style="width:100%;">
						<tbody>
						<tr>
						<td style="width: 225px;"><span style="font-weight: bold;">Event Location:</span></td>
						<td style="width: 300px;"><address><strong>#Session.GetEventFacility.FacilityName#</strong><br>
						#Session.GetEventFacility.PhysicalAddress#<BR>
						#Session.GetEventFacility.PhysicalCity#, #Session.GetEventFacility.PhysicalState# #Session.GetEventFacility.PhysicalZipCode#</address><br>
						<abbr title="Phone">P:</abbr> #Session.GetEventFacility.PrimaryVoiceNumber#
						</td>
						<td colspan="1" rowspan="4" style="width: 475px; text-align: center; vertical-align: top;">
						<link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.css" />
						<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.js"></script>
						<div id="map" style="width: 475px; height: 300px;"></div>
						<script>
							var facilitymarker;
							var map = L.map('map');
							map.setView(new L.LatLng(#Session.GetEventFacility.GeoCode_Latitude#, #Session.GetEventFacility.GeoCode_Longitude#), 12);
							L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '', maxZoom: 16 }).addTo(map);
							var FacilityMarker = L.icon({
								iconUrl: '/plugins/#Variables.Framework.Package#/library/LeafLet/images/conference.png'
							});
							var marker = L.marker([#Session.GetEventFacility.GeoCode_Latitude#, #Session.GetEventFacility.GeoCode_Longitude#], {icon: FacilityMarker}).addTo(map);
						</script>
						</td>
						</tr>
						<tr>
						<td><span style="font-weight: bold;">Event Held In:</span></td>
						<td colspan="2" rowspan="1">#Session.GetEventFacilityRoom.RoomName#</td>
						</tr>
						</tbody>
						</table>
						</td>
						</tr>
					<cfelseif Session.GetSelectedEvent.WebinarAvailable EQ 0 and Session.GetEventFacility.RecordCount EQ 0>
						<tr>
						<td style="width: 141px;" colspan="4">
						<h4><strong>Please contact us to find out where this event will be held as this information might not have been available when the event went live to see how much interest was generated.
						</td>
						</tr>
					</cfif>
				</tbody>
			</table>
		</div>
		<div class="panel-footer">
			<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="form-group">
					<label for="CancelRegistration" class="control-label col-sm-3">Really Cancel Registration:&nbsp;</label>
					<div class="col-sm-8"><cfselect name="CancelRegistration" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Do you want to Cancel Registration</option></cfselect></div>
				</div>
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Manage Registrations">
				<cfif DateDiff("d", Now(), Session.GetSelectedEvent.EventDate) GTE 1>
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Cancel Registration">
				</cfif><br /><br />
			</cfform>
		</div>
	</div>
<cfelseif Session.Mura.IsLoggedIn EQ "False" and isDefined("URL.EventID")>
	<cflocation url="/index.cfm?EventRegistrationaction=public:events.viewavailableevents" addtoken="false">
</cfif>

</cfoutput>
