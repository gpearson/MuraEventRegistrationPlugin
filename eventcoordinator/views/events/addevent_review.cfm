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
				<cfinput type="hidden" name="PerformAction" value="Step2">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step Review - Add New Event/Workshop</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for it.</div>
					<fieldset>
						<legend><h2>Date and Time Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="col-lg-5 col-md-5">Primary Event Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.FormInput.EventStep1.EventDate, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="EventSpanDates" class="col-lg-5 col-md-5">Event has Multiple Dates:&nbsp;</label>
						<div class="col-lg-7">
							<cfif Session.FormInput.EventStep1.Event_HasMultipleDates CONTAINS 1><p class="form-control-static">Yes</p><cfelse><p class="form-control-static">No</p></cfif>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.Event_HasMultipleDates CONTAINS 1>
						<div class="form-group">
							<label for="EventDate1" class="col-lg-5 col-md-5">Second Event Date:&nbsp;</label>
							<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.FormInput.EventStep2.EventDate1, "full")#</p></div>
						</div>
						<div class="form-group">
							<label for="EventDate2" class="col-lg-5 col-md-5">Third Event Date:&nbsp;</label>
							<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.FormInput.EventStep2.EventDate2, "full")#</p></div>
						</div>
						<div class="form-group">
							<label for="EventDate3" class="col-lg-5 col-md-5">Fourth Event Date:&nbsp;</label>
							<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.FormInput.EventStep2.EventDate3, "full")#</p></div>
						</div>
						<div class="form-group">
							<label for="EventDate4" class="col-lg-5 col-md-5">Fifth Event Date:&nbsp;</label>
							<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.FormInput.EventStep2.EventDate4, "full")#</p></div>
						</div>
					</cfif>
					<div class="form-group">
						<label for="Registration_Deadline" class="col-lg-5 col-md-5">Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7"><p class="form-control-static">#DateFormat(Session.FormInput.EventStep1.Registration_Deadline, "full")#</p></div>
					</div>
					<div class="form-group">
						<label for="Registration_BeginTime" class="col-lg-5 col-md-5">Registration Start Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7">
							<p class="form-control-static">#TimeFormat(Session.FormInput.EventStep1.Registration_BeginTime, "hh:mm tt")#</p>
						</div>
					</div>
					<div class="form-group">
						<label for="Event_StartTime" class="col-lg-5 col-md-5">Event Start Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7">							
							<p class="form-control-static">#TimeFormat(Session.FormInput.EventStep1.Event_StartTime, "hh:mm tt")#</p>
						</div>
					</div>
					<div class="form-group">
						<label for="Event_EndTime" class="col-lg-5 col-md-5">Event End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7">
							<p class="form-control-static">#TimeFormat(Session.FormInput.EventStep1.Event_EndTime, "hh:mm tt")#</p>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Description Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ShortTitle" class="col-lg-5 col-md-5">Short Title:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7"><p class="form-control-static">#Session.FormInput.EventStep1.ShortTitle#</p></div>
					</div>
					<div class="form-group">
						<label for="LongDescription" class="col-lg-5 col-md-5">Description:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7"><p class="form-control-static">#Session.FormInput.EventStep1.LongDescription#</p></div>
					</div>
					<div class="form-group">
						<label for="EventAgenda" class="col-lg-5 col-md-5">Agenda:&nbsp;</label>
						<div class="col-lg-7">
							<cfif isDefined("Session.FormInput.EventStep1.EventAgenda")>
								<p class="form-control-static">#Session.FormInput.EventStep1.EventAgenda#</p>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventTargetAudience" class="col-lg-5 col-md-5">Target Audience:&nbsp;</label>
						<div class="col-lg-7">
							<cfif isDefined("Session.FormInput.EventStep1.EventTargetAudience")>
								<p class="form-control-static">#Session.FormInput.EventStep1.EventTargetAudience#</p>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventStrategies" class="col-lg-5 col-md-5">Strategies:&nbsp;</label>
						<div class="col-lg-7">
							<cfif isDefined("Session.FormInput.EventStep1.EventStrategies")>
								<p class="form-control-static">#Session.FormInput.EventStep1.EventStrategies#</p>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventSpecialInstructions" class="col-lg-5 col-md-5">Special Instructions:&nbsp;</label>
						<div class="col-lg-7">
							<cfif isDefined("Session.FormInput.EventStep1.EventSpecialInstructions")>
								<p class="form-control-static">#Session.FormInput.EventStep1.EventSpecialInstructions#</p>
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EventSpecialAlertMessage" class="col-lg-5 col-md-5">Special Alert Message:&nbsp;</label>
						<div class="col-lg-7">
							<cfif isDefined("Session.FormInput.EventStep1.Event_SpecialMessage")>
								<p class="form-control-static">#Session.FormInput.EventStep1.Event_SpecialMessage#</p>
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event At Location Pricing</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Event_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 form-control-static">#DollarFormat(Session.FormInput.EventStep1.Event_MemberCost)# </div>
					</div>
					<div class="form-group">
						<label for="Event_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 form-control-static">#DollarFormat(Session.FormInput.EventStep1.Event_NonMemberCost)#</div>
					</div>
					<div class="form-group">
						<label for="EventCostPerDay" class="col-lg-5 col-md-5">Bill Per Event Date:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.EventPricePerDay Contains 1>
								Yes <div class="form-check-label" style="Color: ##CCCCCC;">(Bill Participants Per Day instead of by Event)</div>
							<cfelse>
								No <div class="form-check-label" style="Color: ##CCCCCC;">(Bill Participants Per Day instead of by Event)</div>
							</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Held At Location</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="LocationID" class="col-lg-5 col-md-5">Location for Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-7 form-control-static">#Session.getSelectedFacility.FacilityName#</div>
					</div>
					<div class="form-group">
						<label for="LocationID" class="col-lg-5 col-md-5">Meeting Room at Facility:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-7 form-control-static">#Session.GetSelectedFacilityRoomInfo.RoomName#</div>
					</div>
					<div class="form-group">
						<label for="LocationID" class="col-lg-5 col-md-5">Maximum Participants:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-7 form-control-static">#Session.FormInput.EventStep3.EventMaxParticipants#</div>
					</div>
					<div class="form-group">
						<label for="LocationID" class="col-lg-5 col-md-5">Primary Presenter:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-7 form-control-static">
							<cfif LEN(Session.FormInput.EventStep1.PresenterID) EQ 1>Nobody Selected<cfelse>#Session.getSelectedPresenterInfo.Fname# #Session.getSelectedPresenterInfo.Lname#</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Featured Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventFeatured" class="col-lg-5 col-md-5">Event is Featured:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.Event_DailySessions CONTAINS 1>Yes<cfelse>No</cfif>
							<div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.Featured_Event CONTAINS 1>
						<div class="form-group">
							<label for="Featured_StartDate" class="col-lg-5 col-md-5">Featured Start Date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">#Session.FormInput.EventStep2.Featured_StartDate#</div>
						</div>
						<div class="form-group">
							<label for="Featured_EndDate" class="col-lg-5 col-md-5">Featured End date:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">#Session.FormInput.EventStep2.Featured_EndDate#</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Event Sessions Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="Event_DailySessions" class="col-lg-5 col-md-5">Event has Daily Sessions:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.Event_DailySessions CONTAINS 1>Yes<cfelse>No</cfif>
							<div class="form-check-label" style="Color: ##CCCCCC;">(Allow Event to have AM and PM Sessions)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.Event_DailySessions CONTAINS 1>
						<div class="form-group">
							<label for="Event_Session1BeginTime" class="col-lg-5 col-md-5">First Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.FormInput.EventStep2.Event_Session1BeginTime, "hh:mm tt")#</div>
						</div>
						<div class="form-group">
							<label for="Event_Session1EndTime" class="col-lg-5 col-md-5">First Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.FormInput.EventStep2.Event_Session1EndTime, "hh:mm tt")#</div>
						</div>
						<div class="form-group">
							<label for="Event_Session2BeginTime" class="col-lg-5 col-md-5">Second Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.FormInput.EventStep2.Event_Session2BeginTime, "hh:mm tt")#</div>
						</div>
						<div class="form-group">
							<label for="Event_Session2EndTime" class="col-lg-5 col-md-5">Seocnd Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.FormInput.EventStep2.Event_Session2EndTime, "hh:mm tt")#</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Event Early Bird Reservations</h2></legend>
					</fieldset>	
					<div class="form-group">
						<label for="EarlyBird_RegistrationAvailable" class="col-lg-5 col-md-5">Earlybird Registration Available:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.EarlyBird_Available CONTAINS 1>Yes<cfelse>No</cfif>
							<div class=form-check-label" style="Color: ##CCCCCC;">(Enable Early Bird Registrations for Event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.EarlyBird_Available CONTAINS 1>
						<div class="form-group">
							<label for="EarlyBird_Deadline" class="col-lg-5 col-md-5">Early Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.EarlyBird_Deadline#
							</div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.EarlyBird_MemberCost#
							</div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.EarlyBird_NonMemberCost#
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Event Group Pricing Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="ViewGroupPricing" class="col-lg-5 col-md-5">Group Pricing Available:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.GroupPrice_Available CONTAINS 1>Yes<cfelse>No</cfif>
							<div class="form-check-label" style="Color: ##CCCCCC;">(Enable Group Pricing for Event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.GroupPrice_Available CONTAINS 1>
						<div class="form-group">
							<label for="GroupPriceRequirements" class="col-lg-5 col-md-5">Group Requirements:&nbsp;</label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.GroupPrice_Requirements#
							</div>
						</div>
						<div class="form-group">
							<label for="GroupMemberCost" class="col-lg-5 col-md-5">Group Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.GroupPrice_MemberCost#
							</div>
						</div>
						<div class="form-group">
							<label for="GroupNonMemberCost" class="col-lg-5 col-md-5">Group NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.GroupPrice_NonMemberCost#
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Professional Growth Point Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PGPAvailable" class="col-lg-5 col-md-5">PGP Certificate Available:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.PGPCertificate_Available CONTAINS 1>Yes<cfelse>No</cfif>
							<div class="form-check-label" style="Color: ##CCCCCC;">(Enable Professional Growth Points for Event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.PGPCertificate_Available CONTAINS 1>
						<cfif Session.FormInput.EventStep1.EventPricePerDay EQ 1>
							<div class="form-group">
								<label for="PGPPoints" class="col-lg-5 col-md-5">Number of PGP Points Per Day:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
								<div class="form-control-static col-lg-7 col-md-7">
									#Session.FormInput.EventStep2.PGPCertificate_Points#
								</div>
							</div>
						<cfelse>
							<div class="form-group">
								<label for="PGPPoints" class="col-lg-5 col-md-5">Number of PGP Points Per Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
								<div class="form-control-static col-lg-7 col-md-7">
									#Session.FormInput.EventStep2.PGPCertificate_Points#
								</div>
							</div>
						</cfif>
					</cfif>
					<fieldset>
						<legend><h2>Meal Availability</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MealAvailable" class="col-lg-5 col-md-5">Meal Available:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.Meal_Available CONTAINS 1>Yes<cfelse>No</cfif>
							<div class="form-check-label" style="Color: ##CCCCCC;">(Enable a Meal to those who attend this event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.Meal_Available CONTAINS 1>
						<div class="form-group">
							<label for="Meal_Included" class="col-lg-5 col-md-5">Meal Included in Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="form-control-static col-lg-7 col-md-7">
								<cfswitch expression="#Session.FormInput.EventStep2.Meal_Included#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							</div>
						</div>
						<div class="form-group">
							<label for="Meal_ProvidedBy" class="col-lg-5 col-md-5">Meal Provided By:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.getSelectedCatererInfo.FacilityName#
							</div>
						</div>
						<div class="form-group">
							<label for="MealInformation" class="col-lg-5 col-md-5">Meal Information:&nbsp;</label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.Meal_Information#
							</div>
						</div>
						<div class="form-group">
							<label for="MealCost" class="col-lg-5 col-md-5">Meal Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#DollarFormat(Session.FormInput.EventStep2.Meal_Cost)#
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Allow Video Conference (H323)</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AllowVideoConference" class="col-lg-5 col-md-5">Is Distance Education Available:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.H323_Available CONTAINS 1>Yes<cfelse>No</cfif>
							<div class="form-check-label" style="Color: ##CCCCCC;">(Enable Distance Education for this event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.H323_Available CONTAINS 1>
						<div class="form-group">
							<label for="H323ConnectionInfo" class="col-lg-5 col-md-5">Connection Information:&nbsp;</label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.H323_ConnectInfo#
							</div>
						</div>
						<div class="form-group">
							<label for="H323ConnectionMemberCost" class="col-lg-5 col-md-5">Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#DollarFormat(Session.FormInput.EventStep2.H323_MemberCost)#
							</div>
						</div>
						<div class="form-group">
							<label for="H323ConnectionNonMemberCost" class="col-lg-5 col-md-5">NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#DollarFormat(Session.FormInput.EventStep2.H323_NonMemberCost)#
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Allow Webinar Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="WebinarEvent" class="col-lg-5 col-md-5">Webinar Only Event:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.Webinar_Available CONTAINS 1>Yes<cfelse>No</cfif>
							<div class="form-check-label" style="Color: ##CCCCCC;">(Enable Webinar Participants to this event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.Webinar_Available CONTAINS 1>
						<div class="form-group">
							<label for="Webinar_ConnectInfo" class="col-lg-5 col-md-5">Connection Information:&nbsp;</label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.Webinar_ConnectInfo#
							</div>
						</div>
						<div class="form-group">
							<label for="WebinarMemberCost" class="col-lg-5 col-md-5">Member Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.Webinar_MemberCost#
							</div>
						</div>
						<div class="form-group">
							<label for="WebinarNonMemberCost" class="col-lg-5 col-md-5">NonMember Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.Webinar_NonMemberCost#
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Event Has Optional Costs</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventHasOptionalCosts" class="col-lg-5 col-md-5">Has Optional Costs:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.Event_OptionalCosts CONTAINS 1>Yes<cfelse>No</cfif>
							<div class="form-check-label" style="Color: ##CCCCCC;">(Enable Optional Costs to Registration Fee to Event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.Event_OptionalCosts CONTAINS 1>

					</cfif>
					
					<cfif Session.SiteConfigSettings.Facebook_Enabled EQ 1>
						<div class="form-group">
						<label for="PostEventToFB" class="col-lg-5 col-md-5">Post to Facebook Fan Page:&nbsp;&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.PostedTo_Facebook CONTAINS 1>Yes<cfelse>No</cfif>
							<div class="form-check-label" style="Color: ##CCCCCC;">(Post this Event to Facebook Fan Page)</div></div>
						</div>
					</cfif>
					<cfif Session.SiteConfigSettings.Twitter_Enabled EQ 1>
						<div class="form-group">
						<label for="PostEventToFB" class="col-lg-5 col-md-5">Post to Companies Twitter Account:&nbsp;&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.PostedTo_Twitter CONTAINS 1>Yes<cfelse>No</cfif>
							<div class="form-check-label" style="Color: ##CCCCCC;">(Post this Event to Twitter Handle)</div></div>
						</div>
					</cfif>
					<cfif Session.SiteConfigSettings.BillForNoShowRegistrations EQ 1>
						<div class="form-group">
						<label for="BillForNoSHow" class="col-lg-5 col-md-5">Bill For NoShow:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.BillForNoShow CONTAINS 1>Yes<cfelse>No</cfif>
							<div class="form-check-label" style="Color: ##CCCCCC;">(Enable billing of participants who do not show to this event)</div></div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Estimated Workshop/Event Expenses</h2></legend>
					</fieldset>
					<cfif Session.FormInput.EventStep1.WhatIf_PresenterCostTotal GT 0 and FormInput.EventStep1.WhatIf_FacilityCostTotal GT 0>
						<cfset TotalEstimatedExpenses = #Session.FormInput.EventStep1.WhatIf_PresenterCostTotal# + #Session.FormInput.EventStep1.WhatIf_FacilityCostTotal#>
						<cfset EstimatedNumberMembers = #Variables.TotalEstimatedExpenses# / #Session.FormInput.EventStep1.Event_MemberCost#>
						<cfset TotalEstimatedExpensesWithMeals = #Variables.TotalEstimatedExpenses# + (#Variables.EstimatedNumberMembers# * #Session.FormInput.EventStep1.WhatIf_MealCostPerAttendee#)>
						<div class="form-group">
							<label for="WhatIf_MealCostPerAttendee" class="col-lg-5 col-md-5">Estimated Meal Cost Per Attendee:&nbsp;</label>
							<div class="checkbox col-lg-7 col-md-7">
								<cfif Session.FormInput.EventStep1.WhatIf_MealCostPerAttendee GT 0>
									#DollarFormat(Session.FormInput.EventStep1.WhatIf_MealCostPerAttendee)#
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="WhatIf_PresenterCostTotal" class="col-lg-5 col-md-5">Estimated Total Presenter Costs:&nbsp;</label>
							<div class="checkbox col-lg-7 col-md-7">
								#DollarFormat(Session.FormInput.EventStep1.WhatIf_PresenterCostTotal)#
							</div>
						</div>
						<div class="form-group">
							<label for="WhatIf_FacilityCostTotal" class="col-lg-5 col-md-5">Estimated Total Facility Costs:&nbsp;</label>
							<div class="checkbox col-lg-7 col-md-7">
								<cfif Session.FormInput.EventStep1.WhatIf_FacilityCostTotal GT 0>
									#DollarFormat(Session.FormInput.EventStep1.WhatIf_FacilityCostTotal)#
								</cfif>
							</div>
						</div>
						<div class="form-group">
							<label for="WhatIf_TotalMembers" class="col-lg-5 col-md-5">Total Members To BreakEven:&nbsp;</label>
							<div class="form-control-static col-lg-7 col-md-7">
								<cfset NumberOfMembers = #Variables.TotalEstimatedExpensesWithMeals# / #Session.FormInput.EventStep1.Event_MemberCost#>
								#Ceiling(Variables.NumberOfMembers)#
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Allow Participants Registrations</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AcceptRegistrations" class="col-lg-5 col-md-5">Accept Registrations:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.EventStep3.AcceptRegistrations")>
								<cfswitch expression="#Session.FormInput.EventStep3.AcceptRegistrations#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							<cfelse>
								No
							</cfif>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Make Changes to Event">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Event to System"><br /><br />
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
				<div class="panel-body">
					<fieldset>
						<legend><h2>Step 3 of 5 - Add New Event/Workshop</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new workshop or event so that individuals will be allowed to register for it.</div>
					<fieldset>
						<legend><h2>Event Facility Room Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="LocationID" class="col-lg-5 col-md-5">Location for Event:&nbsp;</label>
						<div class="col-lg-7 col-form-label">#Session.getActiveFacilities.FacilityName#</div>
					</div>
					<div class="form-group">
						<label for="LocationRoomID" class="col-lg-5 col-md-5">Room Information:&nbsp;</label>
						<div class="col-lg-7 col-form-label">#Session.getSelectedFacilityRoomInfo.RoomName#</div>
					</div>
					<div class="form-group">
						<label for="EventMaxParticipants" class="col-lg-5 col-md-5">Maximum Participants:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7"><cfinput type="text" class="form-control" id="EventMaxParticipants" name="EventMaxParticipants" value="#Session.getSelectedFacilityRoomInfo.Capacity#" required="no"></div>
					</div>
					<fieldset>
						<legend><h2>Event can Accept Registrations</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AcceptRegistrations" class="col-lg-5 col-md-5">Enable Registrations:&nbsp;</label>
						<div class="col-lg-1 col-md-1">&nbsp;</div>
						<div class="checkbox col-lg-7 col-md-7"><cfinput type="checkbox" class="form-check-input" name="AcceptRegistrations" id="AcceptRegistrations" value="Yes"> <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Participant Registrations)</div></div>
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