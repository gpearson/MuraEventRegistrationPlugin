<cfoutput>
	<div class="panel panel-default">
		<div class="panel-body">
			<fieldset>
				<legend><h2>#Session.EventInfo.SelectedEvent.ShortTitle# <cfif Len(Session.EventInfo.SelectedEvent.Presenters)>(#Session.EventInfo.EventPresenter.FName# #Session.EventInfo.EventPresenter.Lname#)</cfif></h2></legend>
			</fieldset>
			<table class="table" width="100%" cellspacing="0" cellpadding="0">
				<tbody>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;"><cfif LEN(Session.EventInfo.SelectedEvent.EventDate1) or LEN(Session.EventInfo.SelectedEvent.EventDate2) or LEN(Session.EventInfo.SelectedEvent.EventDate3) or LEN(Session.EventInfo.SelectedEvent.EventDate4)>Event Dates:<cfelse>Event Date:</cfif></span></td>
						<td colspan="3" rowspan="1">#DateFormat(Session.EventInfo.SelectedEvent.EventDate, "mm/dd/yyyy")# <cfif LEN(Session.EventInfo.SelectedEvent.EventDate1)>, #DateFormat(Session.EventInfo.SelectedEvent.EventDate1, "mm/dd/yyyy")#</cfif><cfif LEN(Session.EventInfo.SelectedEvent.EventDate2)>, #DateFormat(Session.EventInfo.SelectedEvent.EventDate2, "mm/dd/yyyy")#</cfif><cfif LEN(Session.EventInfo.SelectedEvent.EventDate3)>, #DateFormat(Session.EventInfo.SelectedEvent.EventDate3, "mm/dd/yyyy")#</cfif><cfif LEN(Session.EventInfo.SelectedEvent.EventDate4)>, #DateFormat(Session.EventInfo.SelectedEvent.EventDate4, "mm/dd/yyyy")#</cfif></td>
					</tr>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Event Time:</span></td>
						<td style="width: 390px;">#TimeFormat(Session.EventInfo.SelectedEvent.Event_StartTime, "hh:mm tt")# till #TimeFormat(Session.EventInfo.SelectedEvent.Event_EndTime, "hh:mm tt")#</td>
						<td style="text-align: right; width: 175px;"><span style="font-weight: bold;">Registration Deadline:</span></td>
						<td style="width: 175px;">#DateFormat(Session.EventInfo.SelectedEvent.Registration_Deadline, "mm/dd/yyyy")#</td>
					</tr>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Seats Available:</span></td>
						<td style="width: 390px;">
							<cfif Session.EventInfo.SelectedEvent.MaxParticipants EQ 0>
								<cfset SeatsLeft = #Session.EventInfo.EventFacilityRoom.Capacity# - #Session.EventInfo.EventRegistrations.CurrentNumberofRegistrations#>
								#Variables.SeatsLeft# (#Session.EventInfo.EventRegistrations.CurrentNumberofRegistrations# Registered)
							<cfelse>
								<cfset SeatsLeft = #Session.EventInfo.SelectedEvent.MaxParticipants# - #Session.EventInfo.EventRegistrations.CurrentNumberofRegistrations#>
								#Variables.SeatsLeft# (#Session.EventInfo.EventRegistrations.CurrentNumberofRegistrations# Registered)
							</cfif>
						</td>
						<td style="text-align: right; width: 175px;"><span style="font-weight: bold;">onSite Registration:</span></td>
						<td style="width: 175px;">
							<cfif Len(Session.EventInfo.SelectedEvent.Registration_BeginTime) EQ 0>
								#TimeFormat(DateAdd("h", -1, Session.EventInfo.SelectedEvent.Event_StartTime), "hh:mm tt")#
							<cfelse>
								#TimeFormat(Session.EventInfo.SelectedEvent.Registration_BeginTime, "hh:mm tt")#
							</cfif>
								- #TimeFormat(Session.EventInfo.SelectedEvent.Event_StartTime, "hh:mm tt")#
						</td>
					</tr>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Description:</span></td>
						<td colspan="3">#Session.EventInfo.SelectedEvent.LongDescription#</td>
					</tr>
					<cfif LEN(Session.EventInfo.SelectedEvent.EventAgenda)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Agenda:</span></td>
						<td colspan="3" style="width: 141px;">#Session.EventInfo.SelectedEvent.EventAgenda#</td>
						</tr>
					</cfif>
					<cfif LEN(Session.EventInfo.SelectedEvent.EventTargetAudience)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Target Audience:</span></td>
						<td colspan="3" style="width: 141px;">#Session.EventInfo.SelectedEvent.EventTargetAudience#</td>
						</tr>
					</cfif>
					<cfif LEN(Session.EventInfo.SelectedEvent.EventStrategies)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Strategies:</span></td>
						<td colspan="3" style="width: 141px;">#Session.EventInfo.SelectedEvent.EventStrategies#</td>
						</tr>
					</cfif>
					<cfif LEN(Session.EventInfo.SelectedEvent.EventSpecialInstructions)>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Special Instructions:</span></td>
						<td colspan="3">#Session.EventInfo.SelectedEvent.EventSpecialInstructions#</td>
						</tr>
					</cfif>
					<cfif Session.EventInfo.SelectedEvent.PGPAvailable GT 0 and Session.EventInfo.SelectedEvent.MealProvided EQ 1>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">PGP Points:</span></td>
						<td style="width: 390px;">#NumberFormat(Session.EventInfo.SelectedEvent.PGPPoints, "999.99")#</td>
						<td style="width: 175px;"><span style="font-weight: bold;">Meal Provided:</span></td>
						<td style="width: 175px;"><cfif Session.EventInfo.SelectedEvent.MealProvided EQ 1>Yes<cfelse>No</cfif></td>
						</tr>
					<cfelseif Session.EventInfo.SelectedEvent.PGPAvailable GT 0 and Session.EventInfo.SelectedEvent.MealProvided EQ 0>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">PGP Points:</span></td>
						<td colspan="3">&nbsp;&nbsp;#NumberFormat(Session.EventInfo.SelectedEvent.PGPPoints, "999.99")#</td>
						</tr>
					<cfelseif Session.EventInfo.SelectedEvent.PGPAvailable EQ 0 and Session.EventInfo.SelectedEvent.MealProvided EQ 1>
						<tr>
						<td colspan="2">&nbsp;</td>
						<td style="width: 175px;"><span style="font-weight: bold;">Meal Provided:</span></td>
						<td style="width: 175px;"><cfif Session.EventInfo.SelectedEvent.MealProvided EQ 1>Yes<cfelse>No</cfif></td>
						</tr>
					</cfif>
					<cfif Session.EventInfo.SelectedEvent.WebinarAvailable EQ 1>
						<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Webinar Information:</span></td>
						<td colspan="3">#Session.EventInfo.SelectedEvent.WebinarConnectInfo#</td>
						</tr>
						<tr>
						<td colspan="4">
						<table border="0" colspan="0" cellspan="0" align="center" width="100%">
						<tr>
						<td width="25%"><span style="font-weight: bold;">Webinar Member Cost:</span></td>
						<td width="25%">#DollarFormat(Session.EventInfo.SelectedEvent.WebinarMemberCost)#</td>
						<td width="25%"><span style="font-weight: bold;">Webinar NonMember Cost:</span></td>
						<td width="25%">#DollarFormat(Session.EventInfo.SelectedEvent.WebinarNonMemberCost)#</td>
						</tr>
						</table>
						</td>
						</tr>
					</cfif>
					<cfif Session.EventInfo.EventFacility.RecordCount NEQ 0>
						<tr>
						<td style="width: 141px;" colspan="4">
						<table class="art-article" style="width:100%;">
						<tbody>
						<tr>
						<td style="width: 225px;"><span style="font-weight: bold;">Event Location:</span></td>
						<td style="width: 300px;"><address><strong>#Session.EventInfo.EventFacility.FacilityName#</strong><br>
						#Session.EventInfo.EventFacility.PhysicalAddress#<BR>
						#Session.EventInfo.EventFacility.PhysicalCity#, #Session.EventInfo.EventFacility.PhysicalState# #Session.EventInfo.EventFacility.PhysicalZipCode#</address><br>
						<abbr title="Phone">P:</abbr> #Session.EventInfo.EventFacility.PrimaryVoiceNumber#
						</td>
						<td colspan="1" rowspan="4" style="width: 475px; text-align: center; vertical-align: top;">
						<link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.css" />
						<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.js"></script>
						<div id="map" style="width: 475px; height: 300px;"></div>
						<script>
							var facilitymarker;
							var map = L.map('map');
							map.setView(new L.LatLng(#Session.EventInfo.EventFacility.GeoCode_Latitude#, #Session.EventInfo.EventFacility.GeoCode_Longitude#), 12);
							L.tileLayer('http://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '', maxZoom: 16 }).addTo(map);
							var FacilityMarker = L.icon({
								iconUrl: '/plugins/#Variables.Framework.Package#/library/LeafLet/images/conference.png'
							});
							var marker = L.marker([#Session.EventInfo.EventFacility.GeoCode_Latitude#, #Session.EventInfo.EventFacility.GeoCode_Longitude#], {icon: FacilityMarker}).addTo(map);
						</script>
						</td>
						</tr>
						<tr>
						<td><span style="font-weight: bold;">Event Held In:</span></td>
						<td colspan="2" rowspan="1">#Session.EventInfo.EventFacilityRoom.RoomName#</td>
						</tr>
						<!--- <tr>
						<td><span style="font-weight: bold;">Driving Directions:</span></td>
						<td colspan="2" rowspan="1"><a href="/plugins/EventRegistration/?EventRegistrationaction=public:main.eventinfo&EventID=#URL.EventID#&DrivingDirections=True" target="_blank" class="art-button">Show Driving Directions</a></td>
						</tr> --->
						</tbody>
						</table>
						</td>
						</tr>
					<cfelseif Session.EventInfo.SelectedEvent.WebinarAvailable EQ 0 and Session.EventInfo.EventFacility.RecordCount EQ 0>
						<tr>
						<td style="width: 141px;" colspan="4">
						<h4><strong>Please contact us to find out where this event will be held as this information might not have been available when the event went live to see how much interest was generated.
						</td>
						</tr>
					</cfif>
				</tbody>
			</table>
			<table class="table"  width="100%" cellspacing="0" cellpadding="0">
				<tbody>
					<cfif Session.EventInfo.SelectedEvent.WebinarAvailable EQ 0>
						<tr>
							<td colspan="4"><big><big><span style="font-weight: bold;">Pricing Information:</span></big></big></td>
						</tr>
						<cfif Session.EventInfo.SelectedEvent.EarlyBird_RegistrationAvailable EQ 1 and DateDiff("d", Now(), Session.EventInfo.SelectedEvent.EarlyBird_RegistrationDeadline) GT 0>
							<tr>
								<td colspan="4"><big><big><span style="font-weight: bold;">Early Bird Registration Pricing</span></big></big></td>
							</tr>
							<tr>
								<td>Registration Deadline:</td>
								<td colspan="3">#DateFormat(Session.EventInfo.SelectedEvent.EarlyBird_RegistrationDeadline, "mm/dd/yyyy")#</td>
							</tr>
							<tr>
								<td style="width: 155px;">ESC Member Price:</td>
								<td style="width: 292px;">#DollarFormat(Session.EventInfo.SelectedEvent.EarlyBird_MemberCost)# <cfif isDate(Session.EventInfo.SelectedEvent.EventDate1) or isDate(Session.EventInfo.SelectedEvent.EventDate2) or isDate(Session.EventInfo.SelectedEvent.EventDate3) or isDate(Session.EventInfo.SelectedEvent.EventDate4) or isDate(Session.EventInfo.SelectedEvent.EventDate5)> Per Event Date</cfif></td>
								<td style="width: 155px;">NonMember Price:</td>
								<td style="width: 292px;">#DollarFormat(Session.EventInfo.SelectedEvent.EarlyBird_NonMemberCost)# <cfif isDate(Session.EventInfo.SelectedEvent.EventDate1) or isDate(Session.EventInfo.SelectedEvent.EventDate2) or isDate(Session.EventInfo.SelectedEvent.EventDate3) or isDate(Session.EventInfo.SelectedEvent.EventDate4) or isDate(Session.EventInfo.SelectedEvent.EventDate5)> Per Event Date</cfif></td>
							</tr>
						<cfelseif Session.EventInfo.SelectedEvent.EarlyBird_RegistrationAvailable EQ 1 and DateDiff("d", Now(), Session.EventInfo.SelectedEvent.EarlyBird_RegistrationDeadline) EQ 0>
							<tr>
								<td colspan="4"><big><big><span style="font-weight: bold;">Early Bird Registration Pricing</span></big></big></td>
							</tr>
							<tr>
								<td>Registration Deadline:</td>
								<td colspan="3">#DateFormat(Session.EventInfo.SelectedEvent.EarlyBird_RegistrationDeadline, "mm/dd/yyyy")#</td>
							</tr>
							<tr>
								<td colspan="4"><big style="color: red;"><big><span style="font-weight: bold;">Early Bird Registration Ends Today</span></big></big></td>
							</tr>
							<tr>
								<td style="width: 155px;">ESC Member Price:</td>
								<td style="width: 292px;">#DollarFormat(Session.EventInfo.SelectedEvent.EarlyBird_MemberCost)# <cfif isDate(Session.EventInfo.SelectedEvent.EventDate1) or isDate(Session.EventInfo.SelectedEvent.EventDate2) or isDate(Session.EventInfo.SelectedEvent.EventDate3) or isDate(Session.EventInfo.SelectedEvent.EventDate4) or isDate(Session.EventInfo.SelectedEvent.EventDate5)> Per Event Date</cfif></td>
								<td style="width: 155px;">NonMember Price:</td>
								<td style="width: 292px;">#DollarFormat(Session.EventInfo.SelectedEvent.EarlyBird_NonMemberCost)# <cfif isDate(Session.EventInfo.SelectedEvent.EventDate1) or isDate(Session.EventInfo.SelectedEvent.EventDate2) or isDate(Session.EventInfo.SelectedEvent.EventDate3) or isDate(Session.EventInfo.SelectedEvent.EventDate4) or isDate(Session.EventInfo.SelectedEvent.EventDate5)> Per Event Date</cfif></td>
							</tr>
						<cfelse>
							<tr>
								<td style="width: 155px;">ESC Member Price:</td>
								<td style="width: 292px;">#DollarFormat(Session.EventInfo.SelectedEvent.MemberCost)# <cfif isDate(Session.EventInfo.SelectedEvent.EventDate1) or isDate(Session.EventInfo.SelectedEvent.EventDate2) or isDate(Session.EventInfo.SelectedEvent.EventDate3) or isDate(Session.EventInfo.SelectedEvent.EventDate4) or isDate(Session.EventInfo.SelectedEvent.EventDate5)> Per Event Date</cfif></td>
								<td style="width: 155px;">NonMember Price:</td>
								<td style="width: 292px;">#DollarFormat(Session.EventInfo.SelectedEvent.NonMemberCost)# <cfif isDate(Session.EventInfo.SelectedEvent.EventDate1) or isDate(Session.EventInfo.SelectedEvent.EventDate2) or isDate(Session.EventInfo.SelectedEvent.EventDate3) or isDate(Session.EventInfo.SelectedEvent.EventDate4) or isDate(Session.EventInfo.SelectedEvent.EventDate5)> Per Event Date</cfif></td>
							</tr>
						</cfif>
						<cfif Session.EventInfo.SelectedEvent.ViewGroupPricing EQ 1>
							<tr>
								<td colspan="4"><big><big><span style="font-weight: bold;">Group Price (<small><small>if Requirements are Met</small></small>)</span></big></big></td>
							</tr>
							<tr>
								<td style="width: 155px;">Requirements:</td>
								<td colspan="3">#Session.EventInfo.SelectedEvent.GroupPriceRequirements#</td>
							</tr>
							<tr>
								<td style="width: 155px;">ESC Member Price:</td>
								<td style="width: 292px;">#DollarFormat(Session.EventInfo.SelectedEvent.GroupMemberCost)# <cfif isDate(Session.EventInfo.SelectedEvent.EventDate1) or isDate(Session.EventInfo.SelectedEvent.EventDate2) or isDate(Session.EventInfo.SelectedEvent.EventDate3) or isDate(Session.EventInfo.SelectedEvent.EventDate4) or isDate(Session.EventInfo.SelectedEvent.EventDate5)> Per Event Date per Participant</cfif></td>
								<td style="width: 155px;">NonMember Price:</td>
								<td style="width: 292px;">#DollarFormat(Session.EventInfo.SelectedEvent.GroupNonMemberCost)# <cfif isDate(Session.EventInfo.SelectedEvent.EventDate1) or isDate(Session.EventInfo.SelectedEvent.EventDate2) or isDate(Session.EventInfo.SelectedEvent.EventDate3) or isDate(Session.EventInfo.SelectedEvent.EventDate4) or isDate(Session.EventInfo.SelectedEvent.EventDate5)> Per Event Date per Participant</cfif></td>
							</tr>
						</cfif>
						<cfif Session.EventInfo.SelectedEvent.AllowVideoConference EQ 1>
							<tr>
								<td colspan="4"><big><big><span style="font-weight: bold;">Video Conference Price</span></big></big></td>
							</tr>
							<tr>
								<td colspan="4" style="text-align: center;"><big style="color: red;"><span style="font-weight: bold;">Video Conference cost is based on a connection and does not reflect the number of participants at the remote location.</span></big></td>
							</tr>
							<tr>
								<td style="width: 155px;">Information Cost:</td>
								<td colspan="3">#Session.EventInfo.SelectedEvent.VideoConferenceInfo#</td>
							</tr>
							<tr>
								<td style="width: 155px;">Connection Cost:</td>
								<td colspan="3">#DollarFormat(Session.EventInfo.SelectedEvent.VideoConferenceCost)#</td>
							</tr>
						</cfif>
					</cfif>
					<tr>
						<td colspan="4"><big><big><span style="font-weight: bold;">Contact Information</span></big></big></td>
					</tr>
					<cfif Len(Session.EventInfo.SelectedEvent.Presenters)>
						<tr>
							<td style="width: 155px;"><span style="font-weight: bold;">Presenter</span></td>
							<td colspan="3" style="width: 740px;">#Session.EventInfo.EventPresenter.Fname# #Session.EventInfo.EventPresenter.Lname#</td>
						</tr>
					</cfif>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Facilitator:</span></td>
						<td colspan="3" style="width: 740px;">#Session.EventInfo.EventFacilitator.FName# #Session.EventInfo.EventFacilitator.LName#</td>
					</tr>
				</tbody>
			</table>
		</div>
		<div class="panel-footer">
			<a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.default" class="btn btn-primary pull-left">Return to Event Listing</a><br /><br />
		</div>
	</div>
</cfoutput>