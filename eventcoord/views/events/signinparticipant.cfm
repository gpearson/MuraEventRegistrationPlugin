<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Signin Participant who attended the event titled:<br>#Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:events.signinparticipant&EventID=#URL.EventID#" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfif isDefined("URL.UserAction")>
				<div class="panel-body">
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="ParticipantsChecked">
							<cfif isDefined("URL.Successful")>
								<cfif URL.Successful EQ "true">
									<div class="alert alert-success"><p>You have successfully checked participants who has attended this Event. If additional participants are shown you can check them off if they attended or click the Return to Main Menu button to continue your work within this application.</p></div>
								</cfif>
							</cfif>
						</cfcase>
					</cfswitch>
				</div>
				</cfif>
				<div class="panel-body">
					<cfif LEN(Session.getSelectedEvent.EventDate1) or LEN(Session.getSelectedEvent.EventDate2) or LEN(Session.getSelectedEvent.EventDate3) or LEN(Session.getSelectedEvent.EventDate4) or LEN(Session.getSelectedEvent.EventDate5)>
						<div class="panel-body">
							<div class="alert alert-warning">
								<cfif LEN(Session.getSelectedEvent.EventDate1)>
									<p>Day 1: #DateFormat(Session.getSelectedEvent.EventDate, "full")#</p>
									<p>Day 2: #DateFormat(Session.getSelectedEvent.EventDate1, "full")#</p>
								</cfif>
								<cfif LEN(Session.getSelectedEvent.EventDate2)>
									<p>Day 3: #DateFormat(Session.getSelectedEvent.EventDate2, "full")#</p>
								</cfif>
								<cfif LEN(Session.getSelectedEvent.EventDate3)>
									<p>Day 4: #DateFormat(Session.getSelectedEvent.EventDate3, "full")#</p>
								</cfif>
								<cfif LEN(Session.getSelectedEvent.EventDate4)>
									<p>Day 5: #DateFormat(Session.getSelectedEvent.EventDate4, "full")#</p>
								</cfif>
								<cfif LEN(Session.getSelectedEvent.EventDate5)>
									<p>Day 6: #DateFormat(Session.getSelectedEvent.EventDate5, "full")#</p>
								</cfif>
							</div>
						</div>
					</cfif>
					<cfset NumberOfEventDates = 0>
					<cfif Len(Session.getSelectedEvent.EventDate)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate1)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate2)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate3)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate4)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate5)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfset ColWidth = #Variables.NumberOfEventDates# / 100>
					<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
						<cfloop query="Session.getRegisteredParticipants">
							<cfquery name="CheckUserAlreadyRegisteredDay1" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate1
								From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
								Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
									p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
									p_EventRegistration_UserRegistrations.RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
							</cfquery>
							<cfset CurrentModRow = #Session.getRegisteredParticipants.CurrentRow# MOD 4>
							<cfswitch expression="#Variables.NumberOfEventDates#">
								<cfcase value="1">
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr><td width="25%"><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#</cfif></td>
										</cfcase>
										<cfcase value="0">
											<td width="25%"><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#</cfif></td>
										</cfcase>
										<cfdefaultcase>
											<td width="25%"><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;#CheckUserAlreadyRegisteredDay1.LName#, #CheckUserAlreadyRegisteredDay1.FName#</cfif></td>
										</cfdefaultcase>
									</cfswitch>
								</cfcase>
								<cfdefaultcase>
									<cfquery name="CheckUserAlreadyRegisteredDay2" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate2
										From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
										Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
											p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
											p_EventRegistration_UserRegistrations.RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay3" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate3
										From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
										Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
											p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
											p_EventRegistration_UserRegistrations.RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay4" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate4
										From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
										Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
											p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
											p_EventRegistration_UserRegistrations.RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay5" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate5
										From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
										Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
											p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
											p_EventRegistration_UserRegistrations.RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfquery name="CheckUserAlreadyRegisteredDay6" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
										Select tusers.Fname, tusers.Lname, tusers.UserName, p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.AttendedEventDate6
										From p_EventRegistration_UserRegistrations INNER JOIN tusers on tusers.UserID = p_EventRegistration_UserRegistrations.User_ID
										Where p_EventRegistration_UserRegistrations.User_ID = <cfqueryparam value="#Session.getRegisteredParticipants.User_ID#" cfsqltype="cf_sql_varchar"> and
											p_EventRegistration_UserRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and
											p_EventRegistration_UserRegistrations.RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
									</cfquery>
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr>
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#</td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RegisterForEventDate6 EQ 1><cfif CheckUserAlreadyRegisteredDay6.AttendedEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td>
										</cfcase>
										<cfcase value="0">
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#</td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RegisterForEventDate6 EQ 1><cfif CheckUserAlreadyRegisteredDay6.AttendedEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td></tr>
										</cfcase>
										<cfdefaultcase>
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#</td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="5">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="4">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="3">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></td>
												<td colspan="2">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif CheckUserAlreadyRegisteredDay1.RegisterForEventDate1 EQ 1><cfif CheckUserAlreadyRegisteredDay1.AttendedEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif CheckUserAlreadyRegisteredDay2.RegisterForEventDate2 EQ 1><cfif CheckUserAlreadyRegisteredDay2.AttendedEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif CheckUserAlreadyRegisteredDay3.RegisterForEventDate3 EQ 1><cfif CheckUserAlreadyRegisteredDay3.AttendedEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif CheckUserAlreadyRegisteredDay4.RegisterForEventDate4 EQ 1><cfif CheckUserAlreadyRegisteredDay4.AttendedEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif CheckUserAlreadyRegisteredDay5.RegisterForEventDate5 EQ 1><cfif CheckUserAlreadyRegisteredDay5.AttendedEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5">&nbsp;&nbsp;</cfif></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif CheckUserAlreadyRegisteredDay6.RegisterForEventDate6 EQ 1><cfif CheckUserAlreadyRegisteredDay6.AttendedEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6" checked disabled>&nbsp;&nbsp;<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6">&nbsp;&nbsp;</cfif></cfif></td>
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
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="SignIn Participants"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
<!---
<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfif not isDefined("Session.FormErrors")><cfset Session.FormErrors = #ArrayNew()#></cfif>
</cflock>

<cfoutput>
	<cfif Session.UserSuppliedInfo.RegisteredParticipants.RecordCount EQ 0>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Sign In Participant for Workshop/Event: #Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h3>
			</div>
			<div class="art-blockcontent">
				<div class="alert-box notice">You have electronically signed in everyone who has registrered for this event. Please click on one of the navigation menu items above to perform another action.</div>
				<hr>
	<cfelseif not isDefined("URL.UserAction") and not isDefined("URL.Records")>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Sign In Participant for Workshop/Event: #Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h3>
			</div>
			<div class="art-blockcontent">
				<div class="alert-box notice">Please check each participant who was in attendance for this workshop or event. Once this process has been completed they will be able to retrieve a course certificate if one was made available during the creation of this event.</div>
				<hr>
				<cfif ArrayLen(Session.FormErrors)>
					<div class="alert-box error">Please select atleast one participant that needs to be electronically signin to this event.</div>
					<cfset Session.FormErrors = #ArrayNew()#>
				</cfif>
				<cfif isDefined("URL.Successful") and isDefined("URL.UserAction")>
					<cfif URL.Successful EQ "True" and URL.UserAction EQ "SignInParticipant">
						<div class="alert-box success">You have successfully electronically signed in participants for this event. Below are still participants who are currently not in attendance.</div>
					</cfif>
				</cfif>
				<Form method="Post" action="" id="">
					<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
					<input type="hidden" name="EventID" value="#URL.EventID#">
					<input type="hidden" name="formSubmit" value="true">
					<table class="art-article" border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
						<tbody>
							<tr>
								<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 99%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
									<cfif Session.UserSuppliedInfo.RegisteredParticipants.RecordCount>
										<table class="art-article" style="width: 100%;">
											<thead>
												<tr>
													<td colspan="4" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
														<strong>Registered User Accounts</strong>
													</td>
												</tr>
											</thead>
											<tbody>
												<cfloop query="Session.UserSuppliedInfo.RegisteredParticipants">
													<cfset CurrentModRow = #Session.UserSuppliedInfo.RegisteredParticipants.CurrentRow# MOD 4>
													<cfswitch expression="#Variables.CurrentModRow#">
														<cfcase value="1">
															<tr width="25%"><td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#Session.UserSuppliedInfo.RegisteredParticipants.User_ID#">&nbsp;&nbsp;#Session.UserSuppliedInfo.RegisteredParticipants.Lname#, #Session.UserSuppliedInfo.RegisteredParticipants.Fname#</cfoutput></td>
														</cfcase>
														<cfcase value="0">
															<td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#Session.UserSuppliedInfo.RegisteredParticipants.User_ID#">&nbsp;&nbsp;#Session.UserSuppliedInfo.RegisteredParticipants.Lname#, #Session.UserSuppliedInfo.RegisteredParticipants.Fname#</cfoutput></td></tr>
														</cfcase>
														<cfdefaultcase>
															<td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#Session.UserSuppliedInfo.RegisteredParticipants.User_ID#">&nbsp;&nbsp;#Session.UserSuppliedInfo.RegisteredParticipants.Lname#, #Session.UserSuppliedInfo.RegisteredParticipants.Fname#</cfoutput></td>
														</cfdefaultcase>
													</cfswitch>
												</cfloop>
												<cfswitch expression="#Variables.CurrentModRow#">
													<cfcase value="0"></cfcase>
													<cfcase value="1"><td colspan="3">&nbsp;</td></tr></cfcase>
													<cfdefaultcase><td width="25%">&nbsp;</td></tr></cfdefaultcase>
												</cfswitch>
											</tbody>
										</table>
									</cfif>
								</td>
							</tr>
							<tr>
								<td><input type="Submit" Name="PerformAction" class="art-button" value="SignIn Participant(s)"></td>
							</tr>
						</tbody>
					</table>
				</form>
			<cfelseif isDefined("URL.UserAction") and isDefined("URL.Successful")>
				<h2 align="Center">Sign In Participant for Workshop/Event:<br>#Session.UserSuppliedInfo.PickedEvent.ShortTitle#</h2>
				<div class="alert-box notice">Please complete this form to electronically signin a participant for this event.</div>
				<hr>
				<cfif ArrayLen(Session.FormErrors)>
					<div class="alert-box error">Please select atleast one participant that needs to be electronically signin to this event.</div>
					<cfset Session.FormErrors = #ArrayNew()#>
				</cfif>
				<cfif isDefined("URL.Successful") and isDefined("URL.UserAction")>
					<cfif URL.Successful EQ "True" and URL.UserAction EQ "SignInParticipant">
						<div class="alert-box success">You have successfully electronically signed in participants for this event. Below are still participants who are currently not in attendance.</div>
					</cfif>
				</cfif>
				<Form method="Post" action="" id="">
					<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
					<input type="hidden" name="EventID" value="#URL.EventID#">
					<input type="hidden" name="formSubmit" value="true">
					<table class="art-article" border="0" align="center" width="100%" cellspacing="0" cellpadding="0">
						<tbody>
							<tr>
								<td style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 99%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
									<cfif Session.UserSuppliedInfo.RegisteredParticipants.RecordCount>
										<table class="art-article" style="width: 100%;">
											<thead>
												<tr>
													<td colspan="4" style="border-top-width: 1px; border-right-width: 1px; border-bottom-width: 1px; border-left-width: 1px; width: 100%; padding-top: 1px; padding-right: 1px; padding-bottom: 1px; padding-left: 1px;">
														<strong>Registered User Accounts</strong>
													</td>
												</tr>
											</thead>
											<tbody>
												<cfloop query="Session.UserSuppliedInfo.RegisteredParticipants">
													<cfset CurrentModRow = #Session.UserSuppliedInfo.RegisteredParticipants.CurrentRow# MOD 4>
													<cfswitch expression="#Variables.CurrentModRow#">
														<cfcase value="1">
															<tr width="25%"><td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#Session.UserSuppliedInfo.RegisteredParticipants.User_ID#">&nbsp;&nbsp;#Session.UserSuppliedInfo.RegisteredParticipants.Lname#, #Session.UserSuppliedInfo.RegisteredParticipants.Fname#</cfoutput></td>
														</cfcase>
														<cfcase value="0">
															<td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#Session.UserSuppliedInfo.RegisteredParticipants.User_ID#">&nbsp;&nbsp;#Session.UserSuppliedInfo.RegisteredParticipants.Lname#, #Session.UserSuppliedInfo.RegisteredParticipants.Fname#</cfoutput></td></tr>
														</cfcase>
														<cfdefaultcase>
															<td width="25%"><cfoutput><input type="CheckBox" Name="SignInParticipant" Value="#Session.UserSuppliedInfo.RegisteredParticipants.User_ID#">&nbsp;&nbsp;#Session.UserSuppliedInfo.RegisteredParticipants.Lname#, #Session.UserSuppliedInfo.RegisteredParticipants.Fname#</cfoutput></td>
														</cfdefaultcase>
													</cfswitch>
												</cfloop>
												<cfswitch expression="#Variables.CurrentModRow#">
													<cfcase value="0"></cfcase>
													<cfcase value="1"><td colspan="3">&nbsp;</td></tr></cfcase>
													<cfdefaultcase><td width="25%">&nbsp;</td></tr></cfdefaultcase>
												</cfswitch>
											</tbody>
										</table>
									</cfif>
								</td>
							</tr>
							<tr>
								<td><input type="Submit" Name="PerformAction" class="art-button" value="SignIn Participant(s)"></td>
							</tr>
						</tbody>
					</table>
				</form>
			</cfif>
		</div>
	</div>
</cfoutput>
--->