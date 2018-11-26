<cfsilent>
	<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
	<cfset temp = QueryAddRow(YesNoQuery, 1)>
	<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
	<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
	<cfset temp = QueryAddRow(YesNoQuery, 1)>
	<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
	<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>

	<cfif Session.getActiveMembership.RecordCount EQ 1>
		<cfset UserActiveMembership = "Yes">
	<cfelse>
		<cfset UserActiveMembership = "No">
	</cfif>
</cfsilent>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h2>Registering Additional Participants for Event: #Session.getSelectedEvent.ShortTitle#</h2></div>
			<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="EventID" value="#Session.UserRegistrationInfo.EventID#">
				<div class="panel-body">
					<cfif Session.getSelectedEvent.MealProvided EQ 1>
						<div class="form-group">
						<label for="StayForMeal" class="control-label col-sm-4">Will All New Participants be Staying for Meal?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="StayForMeal" class="form-control" Selected="#Session.FormInput.StayForMeal#" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Everyone Registering be staying for Meal</option></cfselect></div>
						</div>
					</cfif>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
						<label for="AttendViaWebinar" class="control-label col-sm-4">Will All New Participants be Attending via Webinar?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="AttendViaWebinar" class="form-control" Selected="#Session.FormInput.AttendViaWebinar#" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Everyone Registering attend via Webinar Option</option></cfselect></div>
						</div>
					</cfif>
					<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
						<div class="form-group">
						<label for="AttendViaIVC" class="control-label col-sm-4">Will All New Participants be Attending via Video Conference?:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-8"><cfselect name="AttendViaIVC" class="form-control" Selected="#Session.FormInput.AttendViaIVC#" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Will Everyone Registering attend via Video Conferencing Equipment</option></cfselect></div>
						</div>
					</cfif>
					<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
						<cfloop query="Session.GetUsersWithinCorporation">
							<cfquery name="CheckUserAlreadyRegisteredDay1" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
								From p_EventRegistration_UserRegistrations
								Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
									and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
										RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
							</cfquery>
							<cfset CurrentModRow = #Session.GetUsersWithinCorporation.CurrentRow# MOD 4>
							<cfset NumberOfEventDates = 0>
							<cfif Len(Session.getSelectedEvent.EventDate)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfif Len(Session.getSelectedEvent.EventDate1)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfif Len(Session.getSelectedEvent.EventDate2)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfif Len(Session.getSelectedEvent.EventDate3)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfif Len(Session.getSelectedEvent.EventDate4)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfif Len(Session.getSelectedEvent.EventDate5)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfset ColWidth = #Variables.NumberOfEventDates# / 100>
							<cfset Session.UserRegistrationInfo.EventNumDays = #Variables.NumberOfEventDates#>
							<cfswitch expression="#Variables.NumberOfEventDates#">
								<cfcase value="1">
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr><td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelseif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" >&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</cfif></td>
										</cfcase>
										<cfcase value="0">
											<td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelseif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" >&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</cfif></td></tr>
										</cfcase>
										<cfdefaultcase>
											<td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelseif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" >&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</cfif></td>
										</cfdefaultcase>
									</cfswitch>
								</cfcase>
								<cfdefaultcase>
									<cfquery name="CheckUserAlreadyRegisteredDay2" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
										From p_EventRegistration_UserRegistrations
										Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
											and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
												RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay3" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
										From p_EventRegistration_UserRegistrations
										Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
											and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
												RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay4" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
										From p_EventRegistration_UserRegistrations
										Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
											and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
												RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay5" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
										From p_EventRegistration_UserRegistrations
										Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
											and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
												RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay6" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
										From p_EventRegistration_UserRegistrations
										Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
											and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
												RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr>
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
											<cfcase value="1">
											<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											</cfcase>
											<cfcase value="2">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											</cfcase>
											<cfcase value="3">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											</cfcase>
											<cfcase value="4">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											</cfcase>
											<cfcase value="5">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											</cfcase>
											<cfcase value="6">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6"></cfif></cfif></td>
											</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td>
										</cfcase>
										<cfcase value="0">
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
											<cfcase value="1">
											<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											</cfcase>
											<cfcase value="2">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											</cfcase>
											<cfcase value="3">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											</cfcase>
											<cfcase value="4">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											</cfcase>
											<cfcase value="5">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											</cfcase>
											<cfcase value="6">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6"></cfif></cfif></td>
											</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td></tr>
										</cfcase>
										<cfdefaultcase>
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
											<cfcase value="1">
											<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											</cfcase>
											<cfcase value="2">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											</cfcase>
											<cfcase value="3">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											</cfcase>
											<cfcase value="4">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											</cfcase>
											<cfcase value="5">
											<td width="#Variables.ColWidth#">Day 1<br><br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											</cfcase>
											<cfcase value="6">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6"></cfif></cfif></td>
											</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td>
										</cfdefaultcase>
									</cfswitch>
								</cfdefaultcase>
							</cfswitch>
						</cfloop>
						<cfswitch expression="#Variables.CurrentModRow#">
							<cfcase value="0"></cfcase>
							<cfcase value="1"><td colspan="3">&nbsp;</td></tr></cfcase>
							<cfdefaultcase><td>&nbsp;</td></tr></cfdefaultcase>
						</cfswitch>
					</table>
					<hr>
					<div class="alert alert-info"><p>Complete the form below to add anyone in your organization who is not listed above. Please make sure the information entered is accurate as this system will communicate to individuals electronically. After clicking the Add Button, you will need to select their name above to register them for the event.</p></div>
					<table id="NewParticipantRows" class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
						<thead>
							<tr>
								<td>Row</td>
								<td class="col-sm-3">Participant First Name</td>
								<td class="col-sm-4">Participant Last Name</td>
								<td class="col-sm-3">Participant Email</td>
								<td class="col-sm-3">Actions</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>1</td>
								<td><cfinput type="text" class="form-control" id="ParticipantFirstName" name="ParticipantFirstName" required="no"></td>
								<td><cfinput type="text" class="form-control" id="ParticipantLastName" name="ParticipantLastName" required="no"></td>
								<td><cfinput type="text" class="form-control" id="ParticipantEmail" name="ParticipantEmail" required="no"></td>
								<td><input type="button" id="addParticipantRow" class="btn btn-primary btn-sm" value="Add" onclick="AddRow()"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register For Event"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Registering Additional Participants for Event: #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="EventID" value="#Session.UserRegistrationInfo.EventID#">
				<cfif isDefined("Session.FormErrors")>
					<div class="panel-body">
						<cfif ArrayLen(Session.FormErrors) GTE 1>
							<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
						</cfif>
					</div>
				</cfif>
				<div class="panel-body">
					<cfif Session.getSelectedEvent.MealProvided EQ 1>
						<div class="form-group">
						<label for="StayForMeal" class="control-label col-sm-4">Will All New Participants be Staying for Meal?:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="StayForMeal" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Everyone Registering be staying for Meal</option></cfselect></div>
						</div>
					</cfif>
					<cfif Session.getSelectedEvent.WebinarAvailable EQ 1>
						<div class="form-group">
						<label for="AttendViaWebinar" class="control-label col-sm-4">Will All New Participants be Attending via Webinar?:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="AttendViaWebinar" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName"  queryposition="below"><option value="----">Will Everyone Registering attend via Webinar Option</option></cfselect></div>
						</div>
					</cfif>
					<cfif Session.UserRegistrationInfo.VideoConferenceOption EQ "True">
						<div class="form-group">
						<label for="AttendViaIVC" class="control-label col-sm-4">Will All New Participants be Attending via Video Conference?:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="AttendViaIVC" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Will Everyone Registering attend via Video Conferencing Equipment</option></cfselect></div>
						</div>
					</cfif>
					<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
						<cfloop query="Session.GetUsersWithinCorporation">
							<cfquery name="CheckUserAlreadyRegisteredDay1" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
								From p_EventRegistration_UserRegistrations
								Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
									and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
										RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
							</cfquery>
							<cfset CurrentModRow = #Session.GetUsersWithinCorporation.CurrentRow# MOD 4>
							<cfset NumberOfEventDates = 0>
							<cfif Len(Session.getSelectedEvent.EventDate)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfif Len(Session.getSelectedEvent.EventDate1)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfif Len(Session.getSelectedEvent.EventDate2)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfif Len(Session.getSelectedEvent.EventDate3)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfif Len(Session.getSelectedEvent.EventDate4)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfif Len(Session.getSelectedEvent.EventDate5)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
							<cfset Session.UserRegistrationInfo.EventNumDays = #Variables.NumberOfEventDates#>
							<cfset ColWidth = #Variables.NumberOfEventDates# / 100>
							<cfswitch expression="#Variables.NumberOfEventDates#">
								<cfcase value="1">
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr><td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelseif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" >&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</cfif></td>
										</cfcase>
										<cfcase value="0">
											<td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelseif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" >&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</cfif></td></tr>
										</cfcase>
										<cfdefaultcase>
											<td width="25%" <cfif CheckUserAlreadyRegisteredDay1.RecordCount>Style="Color: ##009900;"</cfif>><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelseif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked>&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" >&nbsp;&nbsp;#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</cfif></td>
										</cfdefaultcase>
									</cfswitch>
								</cfcase>
								<cfdefaultcase>
									<cfquery name="CheckUserAlreadyRegisteredDay2" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
										From p_EventRegistration_UserRegistrations
										Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
											and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
												RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay3" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
										From p_EventRegistration_UserRegistrations
										Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
											and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
												RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay4" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
										From p_EventRegistration_UserRegistrations
										Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
											and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
												RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay5" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
										From p_EventRegistration_UserRegistrations
										Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
											and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
												RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay6" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select User_ID, EventID, RegisterForEventDate1, RegisterForEventDate2, RegisterForEventDate3, RegisterForEventDate4, RegisterForEventDate5, RegisterForEventDate6, RegisterForEventSessionAM, RegisterForEventSessionPM
										From p_EventRegistration_UserRegistrations
										Where User_ID = <cfqueryparam value="#Session.GetUsersWithinCorporation.UserID#" cfsqltype="cf_sql_varchar">
											and EventID = <cfqueryparam value="#Session.UserRegistrationInfo.EventID#" cfsqltype="cf_sql_integer"> and
												RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr>
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
											<cfcase value="1">
											<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											</cfcase>
											<cfcase value="2">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											</cfcase>
											<cfcase value="3">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											</cfcase>
											<cfcase value="4">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											</cfcase>
											<cfcase value="5">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											</cfcase>
											<cfcase value="6">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6"></cfif></cfif></td>
											</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td>
										</cfcase>
										<cfcase value="0">
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
											<cfcase value="1">
											<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											</cfcase>
											<cfcase value="2">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											</cfcase>
											<cfcase value="3">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											</cfcase>
											<cfcase value="4">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											</cfcase>
											<cfcase value="5">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											</cfcase>
											<cfcase value="6">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6"></cfif></cfif></td>
											</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td></tr>
										</cfcase>
										<cfdefaultcase>
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.GetUsersWithinCorporation.LName#, #Session.GetUsersWithinCorporation.FName#</td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
											<cfcase value="1">
											<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											</cfcase>
											<cfcase value="2">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											</cfcase>
											<cfcase value="3">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											</cfcase>
											<cfcase value="4">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											</cfcase>
											<cfcase value="5">
											<td width="#Variables.ColWidth#">Day 1<br><br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											</cfcase>
											<cfcase value="6">
											<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_1"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_2"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_3"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_4"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_5"></cfif></cfif></td>
											<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RecordCount><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked disabled><cfelse><cfif Session.GetUsersWithinCorporation.UserID EQ Session.Mura.UserID><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.GetUsersWithinCorporation.UserID#_6"></cfif></cfif></td>
											</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td>
										</cfdefaultcase>
									</cfswitch>
								</cfdefaultcase>
							</cfswitch>
						</cfloop>
						<cfswitch expression="#Variables.CurrentModRow#">
							<cfcase value="0"></cfcase>
							<cfcase value="1"><td colspan="3">&nbsp;</td></tr></cfcase>
							<cfdefaultcase><td>&nbsp;</td></tr></cfdefaultcase>
						</cfswitch>
					</table>
					<hr>
					<div class="alert alert-info"><p>Complete the form below to add anyone in your organization who is not listed above. Please make sure the information entered is accurate as this system will communicate to individuals electronically. After clicking the Add Button, you will need to select their name above to register them for the event.</p></div>
					<table id="NewParticipantRows" class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
						<thead>
							<tr>
								<td>Row</td>
								<td class="col-sm-3">Participant First Name</td>
								<td class="col-sm-4">Participant Last Name</td>
								<td class="col-sm-3">Participant Email</td>
								<td class="col-sm-3">Actions</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td>1</td>
								<td><cfinput type="text" class="form-control" id="ParticipantFirstName" name="ParticipantFirstName" required="no"></td>
								<td><cfinput type="text" class="form-control" id="ParticipantLastName" name="ParticipantLastName" required="no"></td>
								<td><cfinput type="text" class="form-control" id="ParticipantEmail" name="ParticipantEmail" required="no"></td>
								<td><input type="button" id="addParticipantRow" class="btn btn-primary btn-sm" value="Add" onclick="AddRow()"></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Register For Event"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
	<script type="text/javascript">
		function AddRow() {
			var msg;

			structvar = {
				Datasource: "#rc.$.globalConfig('datasource')#",
				DBUsername: "#rc.$.globalConfig('dbusername')#",
				DBPassword: "#rc.$.globalConfig('dbpassword')#",
				PackageName: "#rc.pc.getPackage()#",
				CGIScriptName: "#CGI.Script_name#",
				CGIPathInfo: "#CGI.path_info#",
				SiteID: "#rc.$.siteConfig('siteID')#",
				SiteName: "#rc.$.siteConfig('site')#",
				ContactName: "#rc.$.siteConfig('ContactName')#",
				ContactEmail: "#rc.$.siteConfig('ContactEmail')#",
				ContactPhone: "#rc.$.siteConfig('ContactPhone')#",
				EventID: "#Session.FormInput.EventID#"
			};

			newuser = {
				Email: document.getElementById("ParticipantEmail").value,
				Fname: document.getElementById("ParticipantFirstName").value,
				Lname: document.getElementById("ParticipantLastName").value
			};

			$.ajax({
				url: "/plugins/#rc.pc.getPackage()#/library/components/EventServices.cfc?method=AddParticipantToDatabase",
				type: "POST",
				dataType: "json",
				data: {
					returnFormat: "json",
					jrStruct: JSON.stringify({"DBInfo": structvar, "UserInfo": newuser})
				},
				success: function(data){
					setTimeout(function(){
						window.location.reload();
					},100);
				},

				error: function(){
				}
			});
		};
	</script>
</cfoutput>