<cfscript>
	timeConfig = structNew();
	timeConfig['show24Hours'] = false;
	timeConfig['showSeconds'] = false;
</cfscript>
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>

<cfoutput>
	<script>
		$(function() {
			$("##EventDate").datepicker();
			$("##EventDate1").datepicker();
			$("##EventDate2").datepicker();
			$("##EventDate3").datepicker();
			$("##EventDate4").datepicker();
			$("##Featured_StartDate").datepicker();
			$("##Featured_EndDate").datepicker();
			$("##Registration_Deadline").datepicker();
			$("##Registration_BeginTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##Event_StartTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
			$("##Event_EndTime").timepicker({
				timeFormat: 'h:i A',
				controlType: 'select'
			});
		});
	</script>

	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Add New Event or Workshop - Review All Information</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="alert alert-info">Please review the information listed below and make any corrections which are needed complete the following information to add a new workshop or event so that individuals will be allowed to register for.</div>
					<h2 class="panel-title">Event Date and Time Information</h2>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate" name="EventDate" value="#Session.UserSuppliedInfo.FirstStep.EventDate#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventSpanDates" class="control-label col-sm-3">Event has Multiple Dates:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="EventSpanDates" class="form-control" Required="Yes" Multiple="No" selected="#Session.UserSuppliedInfo.FirstStep.EventSpanDates#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Does Event have multiple dates</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.EventSpanDates EQ 1>
						<h2 class="panel-title">Additional Dates for Event or Workshop</h2>
						<div class="form-group">
							<label for="EventDate1" class="control-label col-sm-3">2nd Event Date:&nbsp;</label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventDate1")>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#Session.UserSuppliedInfo.SecondStep.EventDate1#" required="yes">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" required="yes">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">3rd Event Date:&nbsp;</label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventDate2")>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#Session.UserSuppliedInfo.SecondStep.EventDate2#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">4th Event Date:&nbsp;</label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventDate3")>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#Session.UserSuppliedInfo.SecondStep.EventDate3#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" required="no">
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="EventDate" class="control-label col-sm-3">5th Event Date:&nbsp;</label>
							<div class="col-sm-8">
								<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventDate4")>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#Session.UserSuppliedInfo.SecondStep.EventDate4#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" required="no">
								</cfif>
							</div>
						</div>
					</cfif>
					<br />
					<h2 class="panel-title">Registration Information for Event or Workshop</h2>
					<div class="form-group">
						<label for="Registration_Deadline" class="control-label col-sm-3">Registration Deadline:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#Session.UserSuppliedInfo.FirstStep.Registration_Deadline#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="control-label col-sm-3">Registration Start Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_BeginTime" name="Registration_BeginTime" value="#Session.UserSuppliedInfo.FirstStep.Registration_BeginTime#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="control-label col-sm-3">Event Begin Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_StartTime" name="Event_StartTime" value="#Session.UserSuppliedInfo.FirstStep.Event_StartTime#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="control-label col-sm-3">Event Ending Time:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Event_EndTime" name="Event_EndTime" value="#Session.UserSuppliedInfo.FirstStep.Event_EndTime#" required="yes"></div>
					</div>
					<br />
					<h2 class="panel-title">Event Description Information</h2>
					<div class="form-group">
						<label for="ShortTitle" class="control-label col-sm-3">Event Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" value="#Session.UserSuppliedInfo.FirstStep.ShortTitle#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LongDescription" class="control-label col-sm-3">Event Description:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.FirstStep.LongDescription")>
								<textarea name="LongDescription" id="LongDescription" class="form-control" >#Session.UserSuppliedInfo.FirstStep.LongDescription#</textarea>
							<cfelse>
								<textarea name="LongDescription" id="LongDescription" class="form-control" ></textarea>
							</cfif>
							<span id="LongDescriptionCharacters"></span> Characters
						</div>
					</div>
					<div class="form-group">
						<label for="EventAgenda" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventAgenda")>
								<textarea name="EventAgenda" id="EventAgenda" class="form-control">#Session.UserSuppliedInfo.SecondStep.EventAgenda#</textarea>
							<cfelse>
								<textarea name="EventAgenda" id="EventAgenda" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventTargetAudience" class="control-label col-sm-3">Event Target Audience:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventTargetAudience")>
								<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control">#Session.UserSuppliedInfo.SecondStep.EventTargetAudience#</textarea>
							<cfelse>
								<textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventStrategies" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventStrategies")>
								<textarea name="EventStrategies" id="EventStrategies" class="form-control">#Session.UserSuppliedInfo.SecondStep.EventStrategies#</textarea>
							<cfelse>
								<textarea name="EventStrategies" id="EventStrategies" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventSpecialInstructions" class="control-label col-sm-3">Event Special Instructions:&nbsp;</label>
						<div class="col-sm-8">
							<cfif isDefined("Session.UserSuppliedInfo.SecondStep.EventSpecialInstructions")>
								<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control">#Session.UserSuppliedInfo.SecondStep.EventSpecialInstructions#</textarea>
							<cfelse>
								<textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control"></textarea>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="PostEventToFB" class="control-label col-sm-3">Post to FB Fan Page:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="PostEventToFB" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.PostEventToFB#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Post Event to FB Page</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<label for="AcceptRegistrations" class="control-label col-sm-3">Accept Registrations:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="AcceptRegistrations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FourthStep.AcceptRegistrations#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Allow Individuals To Register</option>
							</cfselect>
						</div>
					</div>
					<br />
					<h2 class="panel-title">Event Specific Feature Information</h2>
					<div class="form-group">
						<label for="EventFeatured" class="control-label col-sm-3">Event is Featured:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="EventFeatured" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.EventFeatured#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event be Featured on Website</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.EventFeatured EQ 1>
						<div class="form-group">
							<label for="Featured_StartDate" class="control-label col-sm-3">Start Date to be Featured:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_StartDate" name="Featured_StartDate" value="#Session.UserSuppliedInfo.SecondStep.Featured_StartDate#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_EndDate" class="control-label col-sm-3">End Date to be Featured:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_EndDate" name="Featured_EndDate" value="#Session.UserSuppliedInfo.SecondStep.Featured_EndDate#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="Featured_SortOrder" class="control-label col-sm-3">Featured Sort order:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="Featured_SortOrder" name="Featured_SortOrder" value="#Session.UserSuppliedInfo.SecondStep.Featured_SortOrder#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<h2 class="panel-title">Event Early Bird Registration Information</h2>
					<div class="form-group">
						<label for="EarlyBird_RegistrationAvailable" class="control-label col-sm-3">Earlybird Registration Available:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="EarlyBird_RegistrationAvailable" class="form-control" Required="Yes" Multiple="No" selected="#Session.UserSuppliedInfo.FirstStep.EarlyBird_RegistrationAvailable#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event allow Early Bird Registrations</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.EarlyBird_RegistrationAvailable EQ 1>
						<div class="form-group">
							<label for="EarlyBird_RegistrationDeadline" class="control-label col-sm-3">Featured Sort order:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_RegistrationDeadline" name="EarlyBird_RegistrationDeadline" value="#Session.UserSuppliedInfo.SecondStep.EarlyBird_RegistrationDeadline#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_Member" class="control-label col-sm-3">EarlyBird Member Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_Member" name="EarlyBird_Member" value="#Session.UserSuppliedInfo.SecondStep.EarlyBird_Member#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_NonMemberCost" class="control-label col-sm-3">EarlyBird NonMember Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="EarlyBird_NonMemberCost" name="EarlyBird_NonMemberCost" value="#Session.UserSuppliedInfo.SecondStep.EarlyBird_NonMemberCost#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<h2 class="panel-title">Special Pricing Availibility for Event Information</h2>
					<div class="form-group">
						<label for="ViewSpecialPricing" class="control-label col-sm-3">Special Pricing Available:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="ViewSpecialPricing" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.ViewSpecialPricing#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event have special pricing avialable</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.ViewSpecialPricing EQ 1 and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<div class="form-group">
							<label for="SpecialPriceRequirements" class="control-label col-sm-3">Requirements to Meet Special Pricing:&nbsp;</label>
							<div class="col-sm-8"><textarea name="SpecialPriceRequirements" id="SpecialPriceRequirements" class="form-control">#Session.UserSuppliedInfo.SecondStep.SpecialPriceRequirements#</textarea><span id="SpecialPricingRequirementsCharacters"></span> Characters</div>
						</div>
						<div class="form-group">
							<label for="SpecialMemberCost" class="control-label col-sm-3">Special Member Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="SpecialMemberCost" name="SpecialMemberCost" value="#Session.UserSuppliedInfo.SecondStep.SpecialMemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="SpecialNonMemberCost" class="control-label col-sm-3">Special NonMember Pricing:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="SpecialNonMemberCost" name="SpecialNonMemberCost" value="#Session.UserSuppliedInfo.SecondStep.SpecialNonMemberCost#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<h2 class="panel-title">Professional Growth Point Certificate for Event Information</h2>
					<div class="form-group">
						<label for="PGPAvailable" class="control-label col-sm-3">PGP Certificate Available:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="PGPAvailable" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.PGPAvailable#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Event issue PGP Certificates</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.PGPAvailable EQ 1>
						<div class="form-group">
							<label for="PGPPoints" class="control-label col-sm-3">Number of PGP Points Per Day:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="PGPPoints" name="PGPPoints" value="#Session.UserSuppliedInfo.SecondStep.PGPPoints#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<h1 class="panel-title">Meal Provided to Participants attending Event</h1>
					<div class="form-group">
						<label for="MealProvided" class="control-label col-sm-3">Meal Provided:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="MealProvided" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.MealProvided#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Will Meal be provided to Participants</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.MealProvided EQ 1  and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<div class="form-group">
							<label for="MealCost_Estimated" class="control-label col-sm-3">Meal Cost Estimated:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="MealCost_Estimated" name="MealCost_Estimated" value="#Session.UserSuppliedInfo.SecondStep.MealCost_Estimated#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="MealProvidedBy" class="control-label col-sm-3">Provided By:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="MealProvidedBy" class="form-control" Required="Yes" Multiple="No" query="Session.getCatererInformation" selected="#Session.UserSuppliedInfo.SecondStep.MealProvidedBy#" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Who Provides Meal</option>
								</cfselect>
							</div>
						</div>
					</cfif>
					<br />
					<h1 class="panel-title">Distance Education Allowed for Event</h1>
					<div class="form-group">
						<label for="AllowVideoConference" class="control-label col-sm-3">Is Distance Education Available:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="AllowVideoConference" class="form-control" Required="Yes" Multiple="No" selected="#Session.UserSuppliedInfo.FirstStep.AllowVideoConference#" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Can Participants participate via Distance Education</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.AllowVideoConference EQ 1  and Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<div class="form-group">
							<label for="VideoConferenceInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8"><textarea name="VideoConferenceInfo" id="VideoConferenceInfo" class="form-control">#Session.UserSuppliedInfo.SecondStep.VideoConferenceInfo#</textarea><span id="VideoConferenceInfoCharacters"></span> Characters</div>
						</div>
						<div class="form-group">
							<label for="VideoConferenceCost" class="control-label col-sm-3">Cost to Attend via this:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="VideoConferenceCost" name="VideoConferenceCost" value="#Session.UserSuppliedInfo.SecondStep.VideoConferenceCost#" required="yes"></div>
						</div>
					</cfif>
					<br />
					<h1 class="panel-title">WebEx/Webinar Only Event</h1>
					<div class="form-group">
						<label for="WebinarEvent" class="control-label col-sm-3">Webinar Only Event:&nbsp;</label>
						<div class="col-sm-8">
							<cfselect name="WebinarEvent" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.UserSuppliedInfo.FirstStep.WebinarEvent#" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Webinar Only Event</option>
							</cfselect>
						</div>
					</div>
					<cfif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 1>
						<div class="form-group">
							<label for="WebinarConnectWebInfo" class="control-label col-sm-3">Connection Information:&nbsp;</label>
							<div class="col-sm-8"><textarea name="WebinarConnectWebInfo" id="WebinarConnectWebInfo" class="form-control">#Session.UserSuppliedInfo.SecondStep.WebinarConnectWebInfo#</textarea><span id="WebinarConnectWebInfoCharacters"></span> Characters</div>
						</div>
						<div class="form-group">
							<label for="WebinarMemberCost" class="control-label col-sm-3">Member Cost to Attend via this:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarMemberCost" name="WebinarMemberCost" value="#Session.UserSuppliedInfo.SecondStep.WebinarMemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="WebinarNonMemberCost" class="control-label col-sm-3">NonMember Cost to Attend via this:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control" id="WebinarNonMemberCost" name="WebinarNonMemberCost" value="#Session.UserSuppliedInfo.SecondStep.WebinarNonMemberCost#" required="yes"></div>
						</div>
					<cfelseif Session.UserSuppliedInfo.FirstStep.WebinarEvent EQ 0>
						<br />
						<h1 class="panel-title">Event Location Information</h1>
						<div class="form-group">
							<label for="LocationID" class="control-label col-sm-3">Location of Event:&nbsp;</label>
							<div class="col-sm-8">
								<cfselect name="LocationID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityInformation" selected="#Session.UserSuppliedInfo.SecondStep.LocationID#" value="TContent_ID" Display="FacilityName"  queryposition="below">
									<option value="----">Select Location of Event</option>
								</cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="LocationRoomID" class="control-label col-sm-3">Which Room at Facility:&nbsp;</label>
							<div class="col-sm-8"><cfselect name="LocationRoomID" class="form-control" Required="Yes" Multiple="No" query="Session.getFacilityRoomInfo" selected="#Session.UserSuppliedInfo.ThirdStep.LocationRoomID#" value="RoomID" Display="RoomName"  queryposition="below">
								<option value="----">Select Which Room at Facility this event is held in</option></cfselect>
							</div>
						</div>
						<div class="form-group">
							<label for="RoomMaxParticipants" class="control-label col-sm-3">Maximum Particpants:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control MemberCost" id="RoomMaxParticipants" name="RoomMaxParticipants" value="#Session.UserSuppliedInfo.FourthStep.RoomMaxParticipants#" required="yes">
							</div>
						</div>

						<div class="form-group">
							<label for="MemberCost" class="control-label col-sm-3">Member Pricing To Attend:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control MemberCost" id="MemberCost" name="MemberCost" value="#Session.UserSuppliedInfo.SecondStep.MemberCost#" required="yes"></div>
						</div>
						<div class="form-group">
							<label for="NonMemberCost" class="control-label col-sm-3">NonMember Pricing To Attend:&nbsp;</label>
							<div class="col-sm-8"><cfinput type="text" class="form-control NonMemberCost" id="NonMemberCost" name="NonMemberCost" value="#Session.UserSuppliedInfo.SecondStep.NonMemberCost#" required="yes"></div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-left" value="Back to Step 4">
					<cfinput type="Submit" name="AddNewEventStep" class="btn btn-primary pull-right" value="Add Event"><br /><br />
				</div>
			</cfform>
		</div>
		<script type="text/javascript">
			$('##LongDescription').keyup(LongDescriptionupdateCounter);
			$('##LongDescription').keydown(LongDescriptionupdateCounter);

			function LongDescriptionupdateCounter() {
				var cs = $(this).val().length;
				$('##LongDescriptionCharacters').text(cs);
			}

			$('##SpecialPriceRequirements').keyup(SpecialPriceRequirementsupdateCounter);
			$('##SpecialPriceRequirements').keydown(SpecialPriceRequirementsupdateCounter);

			function SpecialPriceRequirementsupdateCounter() {
				var cs = $(this).val().length;
				$('##SpecialPriceRequirementsCharacters').text(cs);
			}

			$('##VideoConferenceInfo').keyup(VideoConferenceInfoupdateCounter);
			$('##VideoConferenceInfo').keydown(VideoConferenceInfoupdateCounter);

			function VideoConferenceInfoupdateCounter() {
				var cs = $(this).val().length;
				$('##VideoConferenceInfoCharacters').text(cs);
			}

			$('##WebinarConnectWebInfo').keyup(WebinarConnectWebInfoupdateCounter);
			$('##WebinarConnectWebInfo').keydown(WebinarConnectWebInfoupdateCounter);

			function WebinarConnectWebInfoupdateCounter() {
				var cs = $(this).val().length;
				$('##WebinarConnectWebInfoCharacters').text(cs);
			}
		</script>
	</cfif>
</cfoutput>
