<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please review the information listed below and make any corrections which are needed complete the following information to add a new workshop or event so that individuals will be allowed to register for.</div>
					<fieldset>
						<legend><h3>Event Date(s) Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_eventdates&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate, "mm/dd/yyyy")#</p></div>
					</div>
					<cfif isDate(Session.getSelectedEvent.EventDate1)>
						<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Second Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate1, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif isDate(Session.getSelectedEvent.EventDate2)>
						<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Third Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate2, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif isDate(Session.getSelectedEvent.EventDate3)>
						<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Fourth Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate3, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif isDate(Session.getSelectedEvent.EventDate4)>
						<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Fifth Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate4, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<cfif isDate(Session.getSelectedEvent.EventDate5)>
						<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Sixth Event Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.EventDate5, "mm/dd/yyyy")#</p></div>
						</div>
					</cfif>
					<br>
					<fieldset>
						<legend><h3>Registration Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_eventtimes&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="RegistrationDeadline" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#dateFormat(Session.getSelectedEvent.Registration_Deadline, "mm/dd/yyyy")#</p></div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="control-label col-sm-3">Registration Start Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#timeFormat(Session.getSelectedEvent.Registration_BeginTime, "hh:mm tt")#</p></div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="control-label col-sm-3">Event Begin Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#timeFormat(Session.getSelectedEvent.Event_StartTime, "hh:mm tt")#</p></div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="control-label col-sm-3">Event Ending Time:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#TimeFormat(Session.getSelectedEvent.Event_EndTime, "hh:mm tt")#</p></div>
					</div>
					<br>
					<fieldset>
						<legend><h3>Event Description Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_descriptions&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="ShortTitle" class="control-label col-sm-3">Event Title:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.ShortTitle#</p></div>
					</div>
					<div class="form-group">
						<label for="LongDescription" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.LongDescription#</p></div>
					</div>
					<div class="form-group">
						<label for="EventAgenda" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventAgenda#</p></div>
					</div>
					<div class="form-group">
						<label for="EventTargetAudience" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventTargetAudience#</p></div>
					</div>
					<div class="form-group">
						<label for="EventStrategies" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventStrategies#</p></div>
					</div>
					<div class="form-group">
						<label for="EventSpecialInstructions" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.EventSpecialInstructions#</p></div>
					</div>
					<br>
					<fieldset>
						<legend><h3>Event Featured Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_featured&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventFeatured" class="control-label col-sm-3">Event Featured:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getSelectedEvent.EventFeatured#"><cfcase value="0">No</cfcase><cfcase value="1">Yes</cfcase></cfswitch></p></div>
					</div>
					<cfif Session.getSelectedEvent.EventFeatured EQ 1>
						<div class="form-group">
						<label for="Featured_StateDate" class="control-label col-sm-3">Start Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DateFormat(Session.getSelectedEvent.Featured_StartDate, 'mm/dd/yyyy')#</p></div>
						</div>
						<div class="form-group">
						<label for="Featured_EndDate" class="control-label col-sm-3">End Date:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DateFormat(Session.getSelectedEvent.Featured_EndDate, 'mm/dd/yyyy')#</p></div>
						</div>
						<div class="form-group">
						<label for="Featured_SortOrder" class="control-label col-sm-3">Sort Order:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.Featured_SortOrder#</p></div>
						</div>
					</cfif>
					<br>
					<fieldset>
						<legend><h3>Event Daily Session Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_dailysessions&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventHasDailySessions" class="control-label col-sm-3">Event has Daily Sessions:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getSelectedEvent.EventHasDailySessions#"><cfcase value="0">No</cfcase><cfcase value="1">Yes</cfcase></cfswitch></p></div>
					</div>
					<cfif Session.getSelectedEvent.EventHasDailySessions EQ 1>
						<div class="form-group">
							<label for="EventSession1_StartTime" class="control-label col-sm-3">First Session Begin Time:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#timeFormat(Session.getSelectedEvent.Session1BeginTime, "hh:mm tt")#</p></div>
						</div>
						<div class="form-group">
							<label for="EventSession1_EndTime" class="control-label col-sm-3">First Session End Time:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#timeFormat(Session.getSelectedEvent.Session1EndTime, "hh:mm tt")#</p></div>
						</div>
						<div class="form-group">
							<label for="EventSession2_StartTime" class="control-label col-sm-3">Second Session Begin Time:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#timeFormat(Session.getSelectedEvent.Session2BeginTime, "hh:mm tt")#</p></div>
						</div>
						<div class="form-group">
							<label for="EventSession2_EndTime" class="control-label col-sm-3">Second Session End Time:&nbsp;</label>
							<div class="col-sm-8"><p class="form-control-static">#timeFormat(Session.getSelectedEvent.Session2EndTime, "hh:mm tt")#</p></div>
						</div>
					</cfif>
					<br>
					<fieldset>
						<legend><h3>Event Standard Pricing Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_pricing&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="MemberCost" class="control-label col-sm-3">Member Price:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.getSelectedEvent.MemberCost)#</p></div>
					</div>
					<div class="form-group">
						<label for="NonMemberCost" class="control-label col-sm-3">NonMember Price:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.getSelectedEvent.NonMemberCost)#</p></div>
					</div>
					<br>
					<fieldset>
						<legend><h3>Event Early Bird Registration Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_earlybird&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Early Bird Available:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getSelectedEvent.EarlyBird_RegistrationAvailable#"><cfcase value="0">No</cfcase><cfcase value="1">Yes</cfcase></cfswitch></p></div>
					</div>
					<cfif Session.getSelectedEvent.EarlyBird_RegistrationAvailable EQ 1>
						<div class="form-group">
						<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DateFormat(Session.getSelectedEvent.EarlyBird_RegistrationDeadline, 'mm/dd/yyyy')#</p></div>
						</div>
						<div class="form-group">
						<label for="EarlyBird_MemberCost" class="control-label col-sm-3">NonMember Price:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.getSelectedEvent.EarlyBird_MemberCost)#</p></div>
						</div>
						<div class="form-group">
						<label for="EarlyBird_NonMemberCost" class="control-label col-sm-3">NonMember Price:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.getSelectedEvent.EarlyBird_NonMemberCost)#</p></div>
						</div>
					</cfif>
					<br>
					<fieldset>
						<legend><h3>Event Group Pricing Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_grouppricing&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="ViewSpecialPricing" class="control-label col-sm-3">Group Price Available:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getSelectedEvent.ViewGroupPricing#"><cfcase value="0">No</cfcase><cfcase value="1">Yes</cfcase></cfswitch></p></div>
					</div>
					<cfif Session.getSelectedEvent.ViewGroupPricing EQ 1>
						<div class="form-group">
						<label for="SpecialPriceRequirements" class="control-label col-sm-3">Requirements:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.GroupPriceRequirements#</p></div>
						</div>
						<div class="form-group">
						<label for="SpecialMemberCost" class="control-label col-sm-3">Speical Member Price:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.getSelectedEvent.GroupMemberCost)#</p></div>
						</div>
						<div class="form-group">
						<label for="SpecialNonMemberCost" class="control-label col-sm-3">Special NonMember Price:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.getSelectedEvent.GroupNonMemberCost)#</p></div>
						</div>
					</cfif>
					<br>
					<fieldset>
						<legend><h3>PGP Certificate Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_pgps&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="PGPAvailable" class="control-label col-sm-3">PGP Certificate:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getSelectedEvent.PGPAvailable#"><cfcase value="0">No</cfcase><cfcase value="1">Yes</cfcase></cfswitch></p></div>
					</div>
					<cfif Session.getSelectedEvent.PGPAvailable EQ 1>
						<div class="form-group">
						<label for="PGPPoints" class="control-label col-sm-3">PGP Points Available:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.PGPPoints#</p></div>
						</div>
					</cfif>
					<br>
					<fieldset>
						<legend><h3>Meal Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_mealinfo&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="MealAvailable" class="control-label col-sm-3">Meal Avaialble:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getSelectedEvent.MealAvailable#"><cfcase value="0">No</cfcase><cfcase value="1">Yes</cfcase></cfswitch></p></div>
					</div>
					<cfif Session.getSelectedEvent.MealAvailable EQ 1>
						<div class="form-group">
						<label for="MealIncluded" class="control-label col-sm-3">Meal Included in Registration Fee:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getSelectedEvent.MealIncluded#"><cfcase value="0">No</cfcase><cfcase value="1">Yes</cfcase></cfswitch></p></div>
						</div>
						<div class="form-group">
						<label for="MealProvidedBy" class="control-label col-sm-3">Meal Provided By:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedMealProvider.FacilityName# (#Session.getSelectedMealProvider.PhysicalAddress# #Session.getSelectedMealProvider.PhysicalCity# #Session.getSelectedMealProvider.PhysicalState# #Session.getSelectedMealProvider.PhysicalZipCode#)</p></div>
						</div>
						<div class="form-group">
						<label for="MealCost" class="control-label col-sm-3">Meal Cost:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.getSelectedEvent.MealCost)#</p></div>
						</div>
						<div class="form-group">
						<label for="MealCost" class="control-label col-sm-3">Meal Information:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.Meal_Notes#</p></div>
						</div>
					</cfif>
					<br>
					<fieldset>
						<legend><h3>Video Conference Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_videoconference&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="AllowVideoConference" class="control-label col-sm-3">Video Conference Available:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getSelectedEvent.AllowVideoConference#"><cfcase value="0">No</cfcase><cfcase value="1">Yes</cfcase></cfswitch></p></div>
					</div>
					<cfif Session.getSelectedEvent.AllowVideoConference EQ 1>
						<div class="form-group">
						<label for="VideoConferenceInfo" class="control-label col-sm-3">Video Information:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.VideoConferenceInfo#</p></div>
						</div>
						<div class="form-group">
						<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Participate:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.getSelectedEvent.VideoConferenceCost)#</p></div>
						</div>
					</cfif>
					<br>
					<fieldset>
						<legend><h3>Webinar Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_webinar&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="WebinarAvailable" class="control-label col-sm-3">Webinar Available:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getSelectedEvent.WebinarAvailable#"><cfdefaultcase>No</cfdefaultcase><cfcase value="0">No</cfcase><cfcase value="1">Yes</cfcase></cfswitch></p></div>
					</div>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
						<label for="WebinarConnectInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.WebinarConnectInfo#</p></div>
						</div>
						<div class="form-group">
						<label for="WebinarMemberCost" class="control-label col-sm-3">Member Cost to Participate:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.getSelectedEvent.WebinarMemberCost)#</p></div>
						</div>
						<div class="form-group">
						<label for="WebinarNonMemberCost" class="control-label col-sm-3">NonMember Cost to Participate:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#DollarFormat(Session.getSelectedEvent.WebinarNonMemberCost)#</p></div>
						</div>
					</cfif>
					<br>
					<fieldset>
						<legend><h3>Location Information <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_locationinfo&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="LocationID" class="control-label col-sm-3">Location:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedLocation.FacilityName# (#Session.getSelectedLocation.PhysicalAddress# #Session.getSelectedLocation.PhysicalCity# #Session.getSelectedLocation.PhysicalState# #Session.getSelectedLocation.PhysicalZipCode#)</p></div>
					</div>
					<div class="form-group">
						<label for="LocationRoomID" class="control-label col-sm-3">Room Information:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedRoomInfo.RoomName#</p></div>
					</div>
					<div class="form-group">
						<label for="MaxParticipants" class="control-label col-sm-3">Max Participants:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedEvent.MaxParticipants#</p></div>
					</div>
					<br>
					<fieldset>
						<legend><h3>Presenter <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_presenter&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="Presenter" class="control-label col-sm-3">Presenter:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static">#Session.getSelectedPresenter.FName# #Session.getSelectedPresenter.Lname#</p></div>
					</div>
					<br>
					<fieldset>
						<legend><h3>Registrations <a href="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.updateevent_acceptregistrations&EventID=#URL.EventID#"><span class="glyphicon glyphicon-pencil pull-right" aria-hidden="true"></span></a></h3></legend>
					</fieldset>
					<div class="form-group">
						<label for="AcceptRegistrations" class="control-label col-sm-3">Accept Registrations:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getSelectedEvent.AcceptRegistrations#"><cfcase value="0">No</cfcase><cfcase value="1">Yes</cfcase></cfswitch></p></div>
					</div>
					<div class="form-group">
						<label for="DisplayEvent" class="control-label col-sm-3">Display Event:&nbsp;</label>
						<div class="col-sm-8"><p class="form-control-static"><cfswitch expression="#Session.getSelectedEvent.Active#"><cfcase value="0">No</cfcase><cfcase value="1">Yes</cfcase></cfswitch></p></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Submit Event Changes"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
