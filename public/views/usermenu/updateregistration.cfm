<cfif not isDefined("URL.RegistrationID") and Session.Mura.IsLoggedIn EQ "True">
	<cflocation url="/index.cfm?EventRegistrationaction=public:events.viewavailableevents" addtoken="false">
<cfelseif Session.Mura.IsLoggedIn EQ "False">
	<cflocation url="/index.cfm?EventRegistrationaction=public:events.viewavailableevents" addtoken="false">
<cfelseif Session.Mura.IsLoggedIn EQ "True" and isDefined("URL.RegistrationID")>
	<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
	<cfset temp = QueryAddRow(YesNoQuery, 1)>
	<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
	<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
	<cfset temp = QueryAddRow(YesNoQuery, 1)>
	<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
	<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>

	<cfoutput>
	<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
		<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
		<cfinput type="hidden" name="RegistrationID" value="#URL.RegistrationID#">
		<cfinput type="hidden" name="formSubmit" value="true">
		<div class="panel panel-default">
			<div class="panel-body">
				<fieldset>
					<legend>Update Registration for Event</legend>
				</fieldset>
				<fieldset>
					<legend>Your Information</legend>
				</fieldset>
				<div class="form-group">
					<label for="YourFirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
					<div class="col-sm-8"><p class="form-control-static">#Session.Mura.FName#</p></div>
				</div>
				<div class="form-group">
					<label for="YourLastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
					<div class="col-sm-8"><p class="form-control-static">#Session.Mura.LName#</p></div>
				</div>
				<div class="form-group">
					<label for="YourEmail" class="control-label col-sm-3">School/Business Email:&nbsp;</label>
					<div class="col-sm-8"><p class="form-control-static">#Session.Mura.Email#</p></div>
				</div>
				<fieldset>
					<legend>Event Information</legend>
				</fieldset>
				<div class="form-group">
					<label for="EventTitle" class="control-label col-sm-3">Event Title:&nbsp;</label>
					<div class="col-sm-8"><p class="form-control-static">#Session.GetRegistrationInfo.ShortTitle#</p></div>
				</div>
				<div class="form-group">
					<label for="EventTitle" class="control-label col-sm-3">Event Date(s):&nbsp;</label>
					<div class="col-sm-8"><p class="form-control-static">#DateFormat(Session.GetRegistrationInfo.EventDate, "mm/dd/yyyy")# (#DateFormat(Session.GetRegistrationInfo.EventDate, "ddd")#)
						<cfif LEN(Session.GetRegistrationInfo.EventDate1)><br>#DateFormat(Session.GetRegistrationInfo.EventDate1, "mm/dd/yyyy")# (#DateFormat(Session.GetRegistrationInfo.EventDate1, "ddd")#)</cfif>
						<cfif LEN(Session.GetRegistrationInfo.EventDate2)><br>#DateFormat(Session.GetRegistrationInfo.EventDate2, "mm/dd/yyyy")# (#DateFormat(Session.GetRegistrationInfo.EventDate2, "ddd")#)</cfif>
						<cfif LEN(Session.GetRegistrationInfo.EventDate3)><br>#DateFormat(Session.GetRegistrationInfo.EventDate3, "mm/dd/yyyy")# (#DateFormat(Session.GetRegistrationInfo.EventDate3, "ddd")#)</cfif>
						<cfif LEN(Session.GetRegistrationInfo.EventDate4)><br>#DateFormat(Session.GetRegistrationInfo.EventDate4, "mm/dd/yyyy")# (#DateFormat(Session.GetRegistrationInfo.EventDate4, "ddd")#)</cfif>
						<cfif LEN(Session.GetRegistrationInfo.EventDate5)><br>#DateFormat(Session.GetRegistrationInfo.EventDate5, "mm/dd/yyyy")# (#DateFormat(Session.GetRegistrationInfo.EventDate5, "ddd")#)</cfif>
					</p></div>
				</div>
				<cfif Session.GetRegistrationInfo.MealAvailable EQ 1>
					<div class="form-group">
						<label for="StayForMeal" class="control-label col-sm-3">Staying for Meal?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="StayForMeal" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.GetRegistrationInfo.RequestsMeal#" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will you be staying for Meal</option></cfselect></div>
					</div>
					<cfif Session.GetRegistrationInfo.MealIncluded EQ 0>
						<div class="form-group">
							<label for="RegisterAllDates" class="control-label col-sm-3">Participants wanting lunch<br>will pay the caterer directly:</label>
							<div class="col-sm-8">
								<strong>Caterer:</strong> #Session.getEventCaterer.FacilityName# <cfif LEN(Session.getEventCaterer.ContactName) or LEN(Session.getEventCaterer.ContactPhoneNumber)>(<cfif LEN(Session.getEventCaterer.ContactName)>#Session.getEventCaterer.ContactName# - </cfif>#Session.getEventCaterer.ContactPhoneNumber#)<br></cfif>
								<strong>Meal Information:</strong> #DollarFormat(Session.GetRegistrationInfo.MealCost)# (#Session.GetRegistrationInfo.Meal_Notes#)
							</div>
						</div>
					</cfif>
				</cfif>
			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="RegisterAccount" class="btn btn-primary pull-right" value="Update Registration"><br /><br />
			</div>
		</div>
	</cfform>
	</cfoutput>
</cfif>
