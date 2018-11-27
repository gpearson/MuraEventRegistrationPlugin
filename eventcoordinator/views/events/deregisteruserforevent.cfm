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
<cfif LEN(cgi.path_info)><cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# ><cfelse><cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action#></cfif>
</cfsilent>
<cfoutput>
	<cfif not isDefined("URL.FormRetry") and not isDefined("URL.EventStatus")>
		<cfform action="#Variables.newurl#=eventcoordinator:events.deregisteruserforevent&EventID=#URL.EventID#" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<div class="panel panel-default">
				<fieldset>
					<legend><h3>Deregistering Participants: #Session.getSelectedEvent.ShortTitle# <cfif Len(Session.getSelectedEvent.PresenterID)>(#Session.getSelectedEventPresenter.FName# #Session.getSelectedEventPresenter.Lname#)</cfif></h3></legend>
				</fieldset>
				<div class="panel-body">
					<div class="alert alert-info"><p>Complete this form to remove participant(s) from this event</p></div>
					<div class="form-group">
						<label for="EventDate" class="col-lg-5 col-md-5">Event Date(s):&nbsp;</label>
						<div class="col-lg-7 col-md-7 form-control-static">
							#DateFormat(Session.getSelectedEvent.EventDate, "full")#
							<cfif LEN(Session.getSelectedEvent.EventDate1)>, #DateFormat(Session.getSelectedEvent.EventDate1, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate2)>, #DateFormat(Session.getSelectedEvent.EventDate2, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate3)>, #DateFormat(Session.getSelectedEvent.EventDate3, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate4)>, #DateFormat(Session.getSelectedEvent.EventDate4, "full")#</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EmailConfirmations" class="col-lg-5 col-md-5">Send Email Confirmations:&nbsp;</label>
						<div class="col-lg-7 col-md-7"><cfselect name="EmailConfirmations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Send Email Confirmation of Request</option></cfselect></div>
					</div>
					<cfset NumberOfEventDates = 0>
					<cfif Len(Session.getSelectedEvent.EventDate)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate1)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate2)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate3)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate4)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfset ColWidth = 100 / #Variables.NumberOfEventDates#>
					<br /><br />
					<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
						<cfloop query="Session.getRegisteredParticipants">
							<cfset CurrentModRow = #Session.getRegisteredParticipants.CurrentRow# MOD 4>
							<cfswitch expression="#Variables.NumberOfEventDates#">
								<cfcase value="1">
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr>
												<cfif LEN(Session.getRegisteredParticipants.User_ID)>
													<td width="25%"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small>(#Session.getRegisteredParticipants.Email#)</small></td>
												<cfelse>
													<td width="25%">&nbsp;&nbsp;<br><small>&nbsp;&nbsp;</small></td>
												</cfif>
										</cfcase>
										<cfcase value="0">
											<cfif LEN(Session.getRegisteredParticipants.User_ID)>
												<td width="25%"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small>(#Session.getRegisteredParticipants.Email#)</small></td>
											<cfelse>
												<td width="25%">&nbsp;&nbsp;<br><small>&nbsp;&nbsp;</small></td>
											</cfif>
											</tr>
										</cfcase>
										<cfdefaultcase>
											<cfif LEN(Session.getRegisteredParticipants.User_ID)>
												<td width="25%">
													<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">&nbsp;&nbsp;#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small>(#Session.getRegisteredParticipants.Email#)</small></td>
											<cfelse>
												<td width="25%">&nbsp;&nbsp;<br><small>&nbsp;&nbsp;</small></td>
											</cfif>
										</cfdefaultcase>
									</cfswitch>
								</cfcase>
								<cfdefaultcase>
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr>
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small>(#Session.getRegisteredParticipants.Email#)</small></td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td colspan="5">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td colspan="4">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td colspan="3">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td colspan="2">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif Session.getRegisteredParticipants.RegisterForEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6"></cfif></td>
												</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td>
										</cfcase>
										<cfcase value="0">
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small>(#Session.getRegisteredParticipants.Email#)</small></td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td colspan="5">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td colspan="4">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td colspan="3">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td colspan="2">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif Session.getRegisteredParticipants.RegisterForEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6"></cfif></td>
												</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td></tr>
										</cfcase>
										<cfdefaultcase>
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small>(#Session.getRegisteredParticipants.Email#)</small></td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td colspan="5">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td colspan="4">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td colspan="3">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td colspan="2">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif Session.getRegisteredParticipants.RegisterForEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6"></cfif></td>
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
					</table>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Remove Participants from Event"><br /><br />
				</div>
			</div>
		</cfform>
	<cfelseif isDefined("URL.FormRetry") and not isDefined("URL.EventStatus")>
		<cfform action="#Variables.newurl#=eventcoordinator:events.deregisteruserforevent&EventID=#URL.EventID#" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfif isDefined("Session.FormErrors")>
				<cfif ArrayLen(Session.FormErrors)>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Missing Information</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">#Session.FormErrors[1].Message#</p>
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
								function openModal(){
									vm.modal.modal('show');
								}
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
			<div class="panel panel-default">
				<fieldset>
					<legend><h3>Deregistering Participants: #Session.getSelectedEvent.ShortTitle# <cfif Len(Session.getSelectedEvent.PresenterID)>(#Session.getSelectedEventPresenter.FName# #Session.getSelectedEventPresenter.Lname#)</cfif></h3></legend>
				</fieldset>
				<div class="panel-body">
					<div class="alert alert-info"><p>Complete this form to remove participant(s) from this event</p></div>
					<div class="form-group">
						<label for="EventDate" class="col-lg-5 col-md-5">Event Date(s):&nbsp;</label>
						<div class="col-lg-7 col-md-7 form-control-static">
							#DateFormat(Session.getSelectedEvent.EventDate, "full")#
							<cfif LEN(Session.getSelectedEvent.EventDate1)>, #DateFormat(Session.getSelectedEvent.EventDate1, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate2)>, #DateFormat(Session.getSelectedEvent.EventDate2, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate3)>, #DateFormat(Session.getSelectedEvent.EventDate3, "full")#</cfif>
							<cfif LEN(Session.getSelectedEvent.EventDate4)>, #DateFormat(Session.getSelectedEvent.EventDate4, "full")#</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="EmailConfirmations" class="col-lg-5 col-md-5">Send Email Confirmations:&nbsp;</label>
						<div class="col-lg-7 col-md-7"><cfselect name="EmailConfirmations" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Send Email Confirmation of Request</option></cfselect></div>
					</div>
					<cfset NumberOfEventDates = 0>
					<cfif Len(Session.getSelectedEvent.EventDate)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate1)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate2)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate3)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfif Len(Session.getSelectedEvent.EventDate4)><cfset NumberOfEventDates = #Variables.NumberOfEventDates# + 1></cfif>
					<cfset ColWidth = 100 / #Variables.NumberOfEventDates#>
					<br /><br />
					<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
						<cfloop query="Session.getRegisteredParticipants">
							<cfset CurrentModRow = #Session.getRegisteredParticipants.CurrentRow# MOD 4>
							<cfquery name="GetOrgName" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								Select OrganizationName
								From p_EventRegistration_Membership
								Where OrganizationDomainName = <cfqueryparam value="#Session.getRegisteredparticipants.Domain#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfswitch expression="#Variables.NumberOfEventDates#">
								<cfcase value="1">
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr>
												<cfif LEN(Session.getRegisteredParticipants.User_ID)>
													<td width="25%">
														<cfif ListContains(ListFirst(Session.FormInput.ParticipantEmployee, "_"), Session.getRegisteredParticipants.User_ID, ",")>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>
														<cfelse>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">
														</cfif>	
														&nbsp;&nbsp;#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small><cfif GetOrgName.RecordCount GT 0>(#GetOrgName.OrganizationName#)<cfelse>(#Session.getRegisteredparticipants.Domain#)</cfif></small></td>
												<cfelse>
													<td width="25%">&nbsp;&nbsp;<br><small>&nbsp;&nbsp;</small></td>
												</cfif>
										</cfcase>
										<cfcase value="0">
											<cfif LEN(Session.getRegisteredParticipants.User_ID)>
												<td width="25%">
													<cfif ListContains(ListFirst(Session.FormInput.ParticipantEmployee, "_"), Session.getRegisteredParticipants.User_ID, ",")>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>
														<cfelse>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">
														</cfif>	
														&nbsp;&nbsp;#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small><cfif GetOrgName.RecordCount GT 0>(#GetOrgName.OrganizationName#)<cfelse>(#Session.getRegisteredparticipants.Domain#)</cfif></small></td>
											<cfelse>
												<td width="25%">&nbsp;&nbsp;<br><small>&nbsp;&nbsp;</small></td>
											</cfif>
											</tr>
										</cfcase>
										<cfdefaultcase>
											<cfif LEN(Session.getRegisteredParticipants.User_ID)>
												<td width="25%">
													<cfif ListContains(ListFirst(Session.FormInput.ParticipantEmployee, "_"), Session.getRegisteredParticipants.User_ID, ",")>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>
														<cfelse>
															<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1">
														</cfif>	&nbsp;&nbsp;#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small><cfif GetOrgName.RecordCount GT 0>(#GetOrgName.OrganizationName#)<cfelse>(#Session.getRegisteredparticipants.Domain#)</cfif></small></td>
											<cfelse>
												<td width="25%">&nbsp;&nbsp;<br><small>&nbsp;&nbsp;</small></td>
											</cfif>
										</cfdefaultcase>
									</cfswitch>
								</cfcase>
								<cfdefaultcase>
									<cfswitch expression="#Variables.CurrentModRow#">
										<cfcase value="1">
											<tr>
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small><cfif GetOrgName.RecordCount GT 0>(#GetOrgName.OrganizationName#)<cfelse>(#Session.getRegisteredparticipants.Domain#)</cfif></small></td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td colspan="5">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td colspan="4">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td colspan="3">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td colspan="2">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif Session.getRegisteredParticipants.RegisterForEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6"></cfif></td>
												</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td>
										</cfcase>
										<cfcase value="0">
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small><cfif GetOrgName.RecordCount GT 0>(#GetOrgName.OrganizationName#)<cfelse>(#Session.getRegisteredparticipants.Domain#)</cfif></small></td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td colspan="5">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td colspan="4">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td colspan="3">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td colspan="2">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif Session.getRegisteredParticipants.RegisterForEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6"></cfif></td>
												</cfcase>
											</cfswitch>
											</tr>
											</table>
											</td></tr>
										</cfcase>
										<cfdefaultcase>
											<td width="25%">
											<table class="table" width="25%" cellspacing="0" cellpadding="0">
											<th><td colspan="#Variables.NumberOfEventDates#">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small><cfif GetOrgName.RecordCount GT 0>(#GetOrgName.OrganizationName#)<cfelse>(#Session.getRegisteredparticipants.Domain#)</cfif></small></td></th>
											<tr>
											<cfswitch expression="#Variables.NumberOfEventDates#">
												<cfcase value="1">
												<td width="#Variables.ColWidth#" colspan="6">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												</cfcase>
												<cfcase value="2">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td colspan="5">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												</cfcase>
												<cfcase value="3">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td colspan="4">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												</cfcase>
												<cfcase value="4">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td colspan="3">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												</cfcase>
												<cfcase value="5">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td colspan="2">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												</cfcase>
												<cfcase value="6">
												<td width="#Variables.ColWidth#">Day 1<br><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif></td>
												<td width="#Variables.ColWidth#">Day 2<br><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif></td>
												<td width="#Variables.ColWidth#">Day 3<br><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif></td>
												<td width="#Variables.ColWidth#">Day 4<br><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif></td>
												<td width="#Variables.ColWidth#">Day 5<br><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif></td>
												<td width="#Variables.ColWidth#">Day 6<br><cfif Session.getRegisteredParticipants.RegisterForEventDate6 EQ 1><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6"></cfif></td>
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
					</table>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Remove Participants from Event"><br /><br />
				</div>
			</div>
		</cfform>
	</cfif>
</cfoutput>