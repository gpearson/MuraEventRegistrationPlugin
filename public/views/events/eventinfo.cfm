<cfif not isDefined("URL.EventID")><cflocation addtoken="true" url="/index.cfm"></cfif>
<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Featured_StartDate, Featured_EndDate, Featured_SortOrder, MemberCost, NonMemberCost, EarlyBird_RegistrationDeadline, EarlyBird_RegistrationAvailable, EarlyBird_MemberCost, EarlyBird_NonMemberCost, ViewSpecialPricing, SpecialMemberCost, SpecialNonMemberCost, SpecialPriceRequirements, PGPAvailable, PGPPoints, MealProvided, MealProvidedBy, MealCost_Estimated, AllowVideoConference, VideoConferenceInfo, VideoConferenceCost, AcceptRegistrations, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, MaxParticipants, LocationType, LocationID, LocationRoomID, Facilitator, Active, EventCancelled, WebinarAvailable, WebinarConnectInfo, WebinarMemberCost, WebinarNonMemberCost, Presenters
	From eEvents
	Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
		TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
		Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit"> and
		EventCancelled = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
</cfquery>

<cfquery name="getCurrentRegistrationsbyEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select Count(TContent_ID) as CurrentNumberofRegistrations
	From eRegistrations
	Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
		EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="getEventFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PrimaryVoiceNumber, BusinessWebsite, GeoCode_Latitude, GeoCode_Longitude, GeoCode_StateLongName
	From eFacility
	Where FacilityType = <cfqueryparam value="#getSelectedEvent.LocationType#" cfsqltype="cf_sql_varchar"> and
		TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="getEventFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select RoomName, Capacity
	From eFacilityRooms
	Where TContent_ID = <cfqueryparam value="#getSelectedEvent.LocationRoomID#" cfsqltype="cf_sql_integer"> and
		Facility_ID = <cfqueryparam value="#getSelectedEvent.LocationID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="getFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select FName, Lname, Email
	From tusers
	Where UserID = <cfqueryparam value="#getSelectedEvent.Facilitator#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfoutput>
	<cfif not isDefined("URL.DrivingDirections")>
		<div class="art-blockheader">
			<h3 class="t">Viewing Event: #getSelectedEvent.ShortTitle#</h3>
		</div>
		<!--- <cfdump var="#getSelectedEvent#">
		<cfdump var="#getEventFacilityRoom#">
		<cfdump var="#getCurrentRegistrationsbyEvent#">
		<cfabort> --->
		<table class="art-article" style="width:100%;" border="1" cellpadding="1" cellspacing="1">
			<tbody>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;"><cfif LEN(getSelectedEvent.EventDate1) or LEN(getSelectedEvent.EventDate2) or LEN(getSelectedEvent.EventDate3) or LEN(getSelectedEvent.EventDate4)>Event Dates:<cfelse>Event Date:</cfif></span></td>
					<td colspan="3" rowspan="1">#DateFormat(getSelectedEvent.EventDate, "ddd mmm dd, yy")# <cfif LEN(getSelectedEvent.EventDate1)>, #DateFormat(getSelectedEvent.EventDate1, "ddd mmm dd, yy")#</cfif><cfif LEN(getSelectedEvent.EventDate2)>, #DateFormat(getSelectedEvent.EventDate2, "ddd mmm dd, yy")#</cfif><cfif LEN(getSelectedEvent.EventDate3)>, #DateFormat(getSelectedEvent.EventDate3, "ddd mmm dd, yy")#</cfif><cfif LEN(getSelectedEvent.EventDate4)>, #DateFormat(getSelectedEvent.EventDate4, "ddd mmm dd, yy")#</cfif></td>
				</tr>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Event Time:</span></td>
					<td style="width: 390px;">#TimeFormat(getSelectedEvent.Event_StartTime, "hh:mm t")# till #TimeFormat(getSelectedEvent.Event_EndTime, "hh:mm t")#</td>
					<td style="text-align: right; width: 175px;"><span style="font-weight: bold;">Registration Deadline:</span></td>
					<td style="width: 175px;">#DateFormat(getSelectedEvent.Registration_Deadline, "ddd mmm dd, yy")#</td>
				</tr>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Seats Available:</span></td>
					<td style="width: 390px;">
						<cfif getSelectedEvent.MaxParticipants EQ 0>
							<cfset SeatsLeft = #getEventFacilityRoom.Capacity# - #getCurrentRegistrationsbyEvent.CurrentNumberofRegistrations#>
							#Variables.SeatsLeft# out of #getEventFacilityRoom.Capacity# Seats Left
						<cfelse>
							<cfset SeatsLeft = #getSelectedEvent.MaxParticipants# - #getCurrentRegistrationsbyEvent.CurrentNumberofRegistrations#>
							#Variables.SeatsLeft# out of #getSelectedEvent.MaxParticipants# Seats Left
						</cfif>
					</td>
					<td style="text-align: right; width: 175px;"><span style="font-weight: bold;">onSite Registration:</span></td>
					<td style="width: 175px;">
						<cfif Len(getSelectedEvent.Registration_BeginTime) EQ 0>
						#TimeFormat(DateAdd("h", -1, getSelectedEvent.Event_StartTime), "hh:mm t")#
						<cfelse>
						#TimeFormat(getSelectedEvent.Registration_BeginTime, "hh:mm t")#
						</cfif>
						 - #TimeFormat(getSelectedEvent.Event_StartTime, "hh:mm t")#
					</td>
				</tr>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Description:</span></td>
					<td colspan="3">#getSelectedEvent.LongDescription#</td>
				</tr>
				<cfif LEN(getSelectedEvent.EventAgenda)>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Agenda:</span></td>
					<td colspan="3" style="width: 141px;">#getSelectedEvent.EventAgenda#</td>
				</tr>
				</cfif>
				<cfif LEN(getSelectedEvent.EventTargetAudience)>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Target Audience:</span></td>
					<td colspan="3" style="width: 141px;">#getSelectedEvent.EventTargetAudience#</td>
					</tr>
				</cfif>
				<cfif LEN(getSelectedEvent.EventStrategies)>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Strategies:</span></td>
					<td colspan="3" style="width: 141px;">#getSelectedEvent.EventStrategies#</td>
					</tr>
				</cfif>
				<cfif LEN(getSelectedEvent.EventSpecialInstructions)>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Special Instructions:</span></td>
					<td colspan="3">#getSelectedEvent.EventSpecialInstructions#</td>
					</tr>
				</cfif>
				<cfif getSelectedEvent.PGPAvailable GT 0 and getSelectedEvent.MealProvided EQ 1>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">PGP Points:</span></td>
					<td style="width: 390px;">#NumberFormat(getSelectedEvent.PGPPoints, "999.99")#</td>
					<td style="width: 175px;"><span style="font-weight: bold;">Meal Provided:</span></td>
					<td style="width: 175px;"><cfif getSelectedEvent.MealProvided EQ 1>Yes<cfelse>No</cfif></td>
					</tr>
				<cfelseif getSelectedEvent.PGPAvailable GT 0 and getSelectedEvent.MealProvided EQ 0>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">PGP Points:</span></td>
					<td colspan="3">&nbsp;&nbsp;#NumberFormat(getSelectedEvent.PGPPoints, "999.99")#</td>
					</tr>
				<cfelseif getSelectedEvent.PGPAvailable EQ 0 and getSelectedEvent.MealProvided EQ 1>
					<tr>
					<td colspan="2">&nbsp;</td>
					<td style="width: 175px;"><span style="font-weight: bold;">Meal Provided:</span></td>
					<td style="width: 175px;"><cfif getSelectedEvent.MealProvided EQ 1>Yes<cfelse>No</cfif></td>
					</tr>
				</cfif>
				<cfif getSelectedEvent.WebinarAvailable EQ 1>
					<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Webinar Information:</span></td>
					<td colspan="3">#getSelectedEvent.WebinarConnectInfo#</td>
					</tr>
					<tr>
					<td colspan="4">
					<table border="0" colspan="0" cellspan="0" align="center" width="100%">
					<tr>
					<td width="25%"><span style="font-weight: bold;">Webinar Member Cost:</span></td>
					<td width="25%">#DollarFormat(getSelectedEvent.WebinarMemberCost)#</td>
					<td width="25%"><span style="font-weight: bold;">Webinar NonMember Cost:</span></td>
					<td width="25%">#DollarFormat(getSelectedEvent.WebinarNonMemberCost)#</td>
					</tr>
					</table>
					</td>
					</tr>
				</cfif>
				<cfif getSelectedEvent.WebinarAvailable EQ 0 and getEventFacility.RecordCount NEQ 0>
					<tr>
					<td style="width: 141px;" colspan="4">
					<table class="art-article" style="width:100%;">
					<tbody>
					<tr>
					<td style="width: 225px;"><span style="font-weight: bold;">Event Location:</span></td>
					<td style="width: 300px;"><address><strong>#getEventFacility.FacilityName#</strong><br>
					#getEventFacility.PhysicalAddress#<BR>
					#getEventFacility.PhysicalCity#, #getEventFacility.PhysicalState# #getEventFacility.PhysicalZipCode#</address><br>
					<abbr title="Phone">P:</abbr> #getEventFacility.PrimaryVoiceNumber#
					</td>
					<td colspan="1" rowspan="4" style="width: 475px; text-align: center; vertical-align: top;">
					<link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.css" />
					<!--[if lte IE 8]> <link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.ie.css" /> <![endif]-->
					<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.js"></script>
					<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/KML.js"></script>
					<div id="map" style="width: 475px; height: 300px;"></div>
					<script>
						var facilitymarker;
						var map = L.map('map');
						map.setView(new L.LatLng(#getEventFacility.GeoCode_Latitude#, #getEventFacility.GeoCode_Longitude#), 12);
						L.tileLayer('http://tile.openstreetmap.org/{z}/{x}/{y}.png', { attribution: '', maxZoom: 18 }).addTo(map);
						var FacilityMarker = L.icon({
							iconUrl: '/plugins/#Variables.Framework.Package#/library/LeafLet/images/conference.png'
						});
						var marker = L.marker([#getEventFacility.GeoCode_Latitude#, #getEventFacility.GeoCode_Longitude#], {icon: FacilityMarker}).addTo(map);
						var kmlLayer = new L.KML("/plugins/#Variables.Framework.Package#/library/LeafLet/KMLFiles/gz_2010_us_050_00_20m.kml", {async: true});
						kmlLayer.on("loaded", function(e) {
							map.fitBounds(e.target.getBounds());
						});
						map.addLayer(kmlLayer);
					</script>
					</td>
					</tr>
					<tr>
					<td><span style="font-weight: bold;">Event Held In:</span></td>
					<td colspan="2" rowspan="1">#getEventFacilityRoom.RoomName#</td>
					</tr>
					<!--- <tr>
					<td><span style="font-weight: bold;">Driving Directions:</span></td>
					<td colspan="2" rowspan="1"><a href="/plugins/EventRegistration/?EventRegistrationaction=public:main.eventinfo&EventID=#URL.EventID#&DrivingDirections=True" target="_blank" class="art-button">Show Driving Directions</a></td>
					</tr> --->
					</tbody>
					</table>
					</td>
					</tr>
				<cfelseif getSelectedEvent.WebinarAvailable EQ 0 and getEventFacility.RecordCount EQ 0>
					<tr>
					<td style="width: 141px;" colspan="4">
						<h4><strong>Please contact us to find out where this event will be held as this information might not have been available when the event went live to see how much interest was generated.
					</td>
					</tr>
				</cfif>
			</tbody>
		</table>
		<table class="art-article" style="width:100%;" border="1" cellpadding="1" cellspacing="1">
			<tbody>
				<cfif getSelectedEvent.WebinarAvailable EQ 0>
					<tr>
						<td colspan="4"><big><big><span style="font-weight: bold;">Pricing Information:</span></big></big></td>
					</tr>
					<cfif getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1 and DateDiff("d", Now(), getSelectedEvent.EarlyBird_RegistrationDeadline) GT 0>
						<tr>
							<td colspan="4"><big><big><span style="font-weight: bold;">Early Bird Registration Pricing</span></big></big></td>
						</tr>
						<tr>
							<td>Registration Deadline:</td>
							<td colspan="3">#DateFormat(getSelectedEvent.EarlyBird_RegistrationDeadline, "ddd mmm dd, yy")#</td>
						</tr>
						<tr>
							<td style="width: 155px;">ESC Member Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.EarlyBird_MemberCost)#</td>
							<td style="width: 155px;">ESC NonMember Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.EarlyBird_NonMemberCost)#</td>
						</tr>
					<cfelseif getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1 and DateDiff("d", Now(), getSelectedEvent.EarlyBird_RegistrationDeadline) EQ 0>
						<tr>
							<td colspan="4"><big><big><span style="font-weight: bold;">Early Bird Registration Pricing</span></big></big></td>
						</tr>
						<tr>
							<td>Registration Deadline:</td>
							<td colspan="3">#DateFormat(getSelectedEvent.EarlyBird_RegistrationDeadline, "ddd mmm dd, yy")#</td>
						</tr>
						<tr>
							<td colspan="4"><big style="color: red;"><big><span style="font-weight: bold;">Early Bird Registration Ends Today</span></big></big></td>
						</tr>
						<tr>
							<td style="width: 155px;">ESC Member Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.EarlyBird_MemberCost)#</td>
							<td style="width: 155px;">ESC NonMember Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.EarlyBird_NonMemberCost)#</td>
						</tr>
					<cfelse>
						<tr>
							<td style="width: 155px;">ESC Member Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.MemberCost)#</td>
							<td style="width: 155px;">ESC NonMember Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.NonMemberCost)#</td>
						</tr>
					</cfif>
					<cfif getSelectedEvent.ViewSpecialPricing EQ 1>
						<tr>
							<td colspan="4"><big><big><span style="font-weight: bold;">Special Price (<small><small>if Requirements are Met</small></small>)</span></big></big></td>
						</tr>
						<tr>
							<td style="width: 155px;">Requirements:</td>
							<td colspan="3">#getSelectedEvent.SpecialPriceRequirements#</td>
						</tr>
						<tr>
							<td style="width: 155px;">ESC Member Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.SpecialMemberCost)#</td>
							<td style="width: 155px;">ESC NonMember Price:</td>
							<td style="width: 292px;">#DollarFormat(getSelectedEvent.SpecialNonMemberCost)#</td>
						</tr>
					</cfif>
					<cfif getSelectedEvent.AllowVideoConference EQ 1>
						<tr>
							<td colspan="4"><big><big><span style="font-weight: bold;">Video Conference Price</span></big></big></td>
						</tr>
						<tr>
							<td colspan="4" style="text-align: center;"><big style="color: red;"><span style="font-weight: bold;">Video Conference cost is based on a connection and does not reflect the number of participants at the remote location.</span></big></td>
						</tr>
						<tr>
							<td style="width: 155px;">Information Cost:</td>
							<td colspan="3">#getSelectedEvent.VideoConferenceInfo#</td>
						</tr>
						<tr>
							<td style="width: 155px;">Connection Cost:</td>
							<td colspan="3">#DollarFormat(getSelectedEvent.VideoConferenceCost)#</td>
						</tr>
					</cfif>
				</cfif>
				<tr>
					<td colspan="4"><big><big><span style="font-weight: bold;">Contact Information</span></big></big></td>
				</tr>
				<cfif Len(getSelectedEvent.Presenters)>
					<tr>
						<td style="width: 155px;"><span style="font-weight: bold;">Presenter(s)</span></td>
						<td colspan="3" style="width: 740px;"></td>
					</tr>
				</cfif>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Facilitator:</span></td>
					<td colspan="3" style="width: 740px;">#getFacilitator.FName# #getFacilitator.LName#</td>
				</tr>
				<tr>
					<td style="width: 155px;"><span style="font-weight: bold;">Still Have Questions</span></td>
					<td colspan="3"><a href="/plugins/#variables.Framework.package##buildURL('public:main.sendquestionform')#&EventID=#URL.EventID#" class="art-button">Send Questions</a></td>
				</tr>
				<tr align="right">
					<td colspan="4"><a href="/plugins/#variables.Framework.package##buildURL('public:events.viewavailableevents')#" class="art-button">Return to Event Listing</a>
						<cfif getSelectedEvent.AcceptRegistrations EQ 1>
							<cfif DateDiff("d", Now(), getSelectedEvent.Registration_Deadline) GTE 0>
								<cfif Variables.SeatsLeft GT 0>
									<cfif Session.Mura.isLoggedIn EQ 0>
										<a href="/plugins/#variables.Framework.package##buildURL('public:registerevent.default')#&EventID=#URL.EventID#" class="art-button">Register</a>
									<cfelse>
										<a href="/plugins/#variables.Framework.package##buildURL('public:registerevent.default')#&EventID=#URL.EventID#" class="art-button">Register</a>
									</cfif>
								</cfif>
							</cfif>
						</cfif>
					</td>
				</tr>
			</tbody>
		</table>
	<cfelseif isDefined("URL.DrivingDirections")>
		<div class="art-blockheader">
			<h3 class="t">Driving Directions to #getEventFacility.FacilityName#</h3>
		</div>
		<table class="art-article" style="width:100%;">
			<tbody>
				<tr>
					<td style="width: 225px;"><span style="font-weight: bold;">Event Location:</span></td>
					<td style="width: 300px;"><address><strong>#getEventFacility.FacilityName#</strong><br>
					#getEventFacility.PhysicalAddress#<BR>
					#getEventFacility.PhysicalCity#, #getEventFacility.PhysicalState# #getEventFacility.PhysicalZipCode#</address><br>
					<abbr title="Phone">P:</abbr> #getEventFacility.PrimaryVoiceNumber#
					</td>
					<td colspan="1" rowspan="4" style="width: 475px; text-align: center; vertical-align: top;">
					<link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.css" />
					<!--[if lte IE 8]> <link rel="stylesheet" href="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.ie.css" /> <![endif]-->
					<!--- <script src="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet-routing-machine.min.js"></script>
					<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/Control.Geocoder.js"></script>
					<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/KML.js"></script> --->
					<script src="/plugins/#Variables.Framework.Package#/library/LeafLet/leaflet.js"></script>

					<div id="map" style="width: 475px; height: 300px;"></div>

					</td>
				</tr>
			</tbody>
		</table>
	</cfif>
</cfoutput>