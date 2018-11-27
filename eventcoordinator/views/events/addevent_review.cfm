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
							<cfif Session.FormInput.EventStep1.EventSpanDates EQ 1><p class="form-control-static">Yes</p><cfelse><p class="form-control-static">No</p></cfif>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.EventSpanDates EQ 1>
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
					<fieldset>
						<legend><h2>Event At Location Pricing</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="MemberCost" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 form-control-static">#DollarFormat(Session.FormInput.EventStep1.MemberCost)# <div class="form-control-static" style="Color: ##CCCCCC;">(Cost is Per Event)</div></div>
					</div>
					<div class="form-group">
						<label for="NonMemberCost" class="col-lg-5 col-md-5">NonMembership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 form-control-static">#DollarFormat(Session.FormInput.EventStep1.NonMemberCost)# <div class="form-control-static" style="Color: ##CCCCCC;">(Cost is Per Event)</div></div>
					</div>
					<div class="form-group">
						<label for="EventCostPerDay" class="col-lg-5 col-md-5">Bill Per Event Date:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfif Session.FormInput.EventStep1.EventCostPerDay EQ 1>
								Yes <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
							<cfelse>
								No <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Bill Participants Per Day instead of by Event)</div>
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
						<div class="col-lg-7 form-control-static">#Session.getSelectedFacilityRoomInfo.RoomName#</div>
					</div>
					<div class="form-group">
						<label for="LocationID" class="col-lg-5 col-md-5">Maximum Participants:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-7 form-control-static">#Session.FormInput.EventStep3.EventMaxParticipants#</div>
					</div>
					<div class="form-group">
						<label for="LocationID" class="col-lg-5 col-md-5">Primary Presenter:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-lg-7 form-control-static">
							<cfif LEN(Session.FormInput.EventStep1.PresenterID) EQ 1>Nobody Selected<cfelse>#Session.FormInput.EventStep1.PresenterID#</cfif>
						</div>
					</div>
					<fieldset>
						<legend><h2>Event Featured Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventFeatured" class="col-lg-5 col-md-5">Event is Featured:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfswitch expression="#Session.FormInput.EventStep1.EventFeatured#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Feature Event at top of Current Events Page)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.EventFeatured EQ 1>
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
						<label for="EventHaveSessions" class="col-lg-5 col-md-5">Event has Daily Sessions:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfswitch expression="#Session.FormInput.EventStep1.EventHaveSessions#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Allow Event to have AM and PM Sessions)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.EventHaveSessions EQ 1>
						<div class="form-group">
							<label for="EventSession1_StartTime" class="col-lg-5 col-md-5">First Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.FormInput.EventStep2.EventSession1_StartTime, "hh:mm tt")#</div>
						</div>
						<div class="form-group">
							<label for="EventSession1_EndTime" class="col-lg-5 col-md-5">First Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.FormInput.EventStep2.EventSession1_EndTime, "hh:mm tt")#</div>
						</div>
						<div class="form-group">
							<label for="EventSession2_StartTime" class="col-lg-5 col-md-5">Second Session Begin Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.FormInput.EventStep2.EventSession2_StartTime, "hh:mm tt")#</div>
						</div>
						<div class="form-group">
							<label for="EventSession2_EndTime" class="col-lg-5 col-md-5">Seocnd Session End Time:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">#TimeFormat(Session.FormInput.EventStep2.EventSession2_EndTime, "hh:mm tt")#</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Event Early Bird Reservations</h2></legend>
					</fieldset>	
					<div class="form-group">
						<label for="EarlyBird_RegistrationAvailable" class="col-lg-5 col-md-5">Earlybird Registration Available:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfswitch expression="#Session.FormInput.EventStep1.EarlyBird_RegistrationAvailable#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							 <div class=form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Early Bird Registrations for Event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.EarlyBird_RegistrationAvailable EQ 1>
						<div class="form-group">
							<label for="EarlyBird_RegistrationDeadline" class="col-lg-5 col-md-5">Early Registration Deadline:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.EarlyBird_RegistrationDeadline#
							</div>
						</div>
						<div class="form-group">
							<label for="EarlyBird_Member" class="col-lg-5 col-md-5">Membership Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.EarlyBird_Member#
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
							<cfswitch expression="#Session.FormInput.EventStep1.ViewGroupPricing#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Group Pricing for Event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.ViewGroupPricing EQ 1>
						<div class="form-group">
							<label for="GroupPriceRequirements" class="col-lg-5 col-md-5">Group Requirements:&nbsp;</label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.GroupPriceRequirements#
							</div>
						</div>
						<div class="form-group">
							<label for="GroupMemberCost" class="col-lg-5 col-md-5">Group Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.GroupMemberCost#
							</div>
						</div>
						<div class="form-group">
							<label for="GroupNonMemberCost" class="col-lg-5 col-md-5">Group NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.GroupNonMemberCost#
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Professional Growth Point Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="PGPAvailable" class="col-lg-5 col-md-5">PGP Certificate Available:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfswitch expression="#Session.FormInput.EventStep1.PGPAvailable#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Professional Growth Points for Event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.PGPAvailable EQ 1>
						<cfif Session.FormInput.EventStep1.EventCostPerDay EQ 1>
							<div class="form-group">
								<label for="PGPPoints" class="col-lg-5 col-md-5">Number of PGP Points Per Day:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
								<div class="form-control-static col-lg-7 col-md-7">
									#Session.FormInput.EventStep2.PGPPoints#
								</div>
							</div>
						<cfelse>
							<div class="form-group">
								<label for="PGPPoints" class="col-lg-5 col-md-5">Number of PGP Points Per Event:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
								<div class="form-control-static col-lg-7 col-md-7">
									#Session.FormInput.EventStep2.PGPPoints#
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
							<cfswitch expression="#Session.FormInput.EventStep1.MealAvailable#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable a Meal to those who attend this event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.MealAvailable EQ 1>
						<div class="form-group">
							<label for="MealIncluded" class="col-lg-5 col-md-5">Meal Included in Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="form-control-static col-lg-7 col-md-7">
								<cfswitch expression="#Session.FormInput.EventStep2.MealIncluded#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							</div>
						</div>
						<div class="form-group">
							<label for="MealProvidedBy" class="col-lg-5 col-md-5">Meal Provided By:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.getSelectedCatererInfo.FacilityName#
							</div>
						</div>
						<div class="form-group">
							<label for="MealInformation" class="col-lg-5 col-md-5">Meal Information:&nbsp;</label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.MealInformation#
							</div>
						</div>
						<div class="form-group">
							<label for="MealCost" class="col-lg-5 col-md-5">Meal Cost:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#DollarFormat(Session.FormInput.EventStep2.MealCost)#
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Allow Video Conference (H323)</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="AllowVideoConference" class="col-lg-5 col-md-5">Is Distance Education Available:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfswitch expression="#Session.FormInput.EventStep1.AllowVideoConference#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Enable Distance Education for this event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.AllowVideoConference EQ 1>
						<div class="form-group">
							<label for="H323ConnectionInfo" class="col-lg-5 col-md-5">Connection Information:&nbsp;</label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.H323ConnectionInfo#
							</div>
						</div>
						<div class="form-group">
							<label for="H323ConnectionMemberCost" class="col-lg-5 col-md-5">Member Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.H323ConnectionMemberCost#
							</div>
						</div>
						<div class="form-group">
							<label for="H323ConnectionNonMemberCost" class="col-lg-5 col-md-5">NonMember Pricing:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.H323ConnectionNonMemberCost#
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Allow Webinar Information</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="WebinarEvent" class="col-lg-5 col-md-5">Webinar Only Event:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfswitch expression="#Session.FormInput.EventStep1.WebinarEvent#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to only allow Webinar Participants to this event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.WebinarEvent EQ 1>
						<div class="form-group">
							<label for="WebinarConnectWebInfo" class="col-lg-5 col-md-5">Connection Information:&nbsp;</label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.WebinarConnectWebInfo#
							</div>
						</div>
						<div class="form-group">
							<label for="WebinarMemberCost" class="col-lg-5 col-md-5">Member Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.WebinarMemberCost#
							</div>
						</div>
						<div class="form-group">
							<label for="WebinarNonMemberCost" class="col-lg-5 col-md-5">NonMember Cost to Attend via this:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
							<div class="form-control-static col-lg-7 col-md-7">
								#Session.FormInput.EventStep2.WebinarNonMemberCost#
							</div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Event Has Optional Costs</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventHasOptionalCosts" class="col-lg-5 col-md-5">Has Optional Costs:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfswitch expression="#Session.FormInput.EventStep1.EventHasOptionalCosts#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Add Optional Costs to Registration Fee to Event)</div>
						</div>
					</div>
					<cfif Session.FormInput.EventStep1.EventHasOptionalCosts EQ 1>





					</cfif>
					<cfif Session.SiteConfigSettings.Facebook_Enabled EQ 1>
						<div class="form-group">
						<label for="PostEventToFB" class="col-lg-5 col-md-5">Post to FB Fan Page:&nbsp;&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfswitch expression="#Session.FormInput.EventStep1.PostEventToFB#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to Post this Event to Facebook Fan Page)</div></div>
						</div>
					</cfif>
					<cfif Session.SiteConfigSettings.BillForNoShowRegistrations EQ 1>
						<div class="form-group">
						<label for="BillForNoSHow" class="col-lg-5 col-md-5">Bill For NoShow:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfswitch expression="#Session.FormInput.EventStep1.BillForNoShowRegistrations#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
							 <div class="form-check-label" style="Color: ##CCCCCC;">(Check Box to enable billing participants who do not show to this event)</div></div>
						</div>
					</cfif>
					<fieldset>
						<legend><h2>Allow Participants Registrations</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="WebinarEvent" class="col-lg-5 col-md-5">Accept Registrations:&nbsp;</label>
						<div class="form-control-static col-lg-7 col-md-7">
							<cfswitch expression="#Session.FormInput.EventStep3.AcceptRegistrations#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Make Changes to Event">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Event to System"><br /><br />
				</div>
			</cfform>
			<cfdump var="#Session#">
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