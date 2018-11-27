<cfoutput>
	<cfif LEN(Session.getRegisteredParticipants.User_ID)>
		<table class="table" cellspacing="0" cellpadding="0" width="100%" align="center">
			<thead>
				<tr>
					<td colspan="#Session.EventNumberOfDays#" style="font-family: Arial; font-size: 14px; text-align: center">
						#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br>
						<small><cfif LEN(Session.getRegisteredParticipants.OrganizationName)>(#Session.getRegisteredParticipants.OrganizationName#)<cfelse>(#Session.getRegisteredparticipants.Domain#)</cfif></small>
					</td>
				</tr>
				<cfswitch expression="#Session.EventNumberOfDays#">
					<cfcase value="1">
						<cfif Session.getSelectedEvent.Event_DailySessions EQ 1>
							<tr><td><table class="table" cellspacing="0" cellpadding="0"><tr><td Align="Center">Session AM</td><td Align="Center">Session PM</td></tr></table></td></tr>
						</cfif>
					</cfcase>
					<cfcase value="2"><tr><td width="50%" Align="Center">Day 1</td><td width="50%" Align="Center">Day 2</td></tr></cfcase>
					<cfcase value="3"><tr><td width="33%" Align="Center">Day 1</td><td width="33%" Align="Center">Day 2</td><td Align="Center">Day 3</td></tr></cfcase>
					<cfcase value="4"><tr><td width="25%" Align="Center">Day 1</td><td width="25%" Align="Center">Day 2</td><td width="25%" Align="Center">Day 3</td><td width="25%" Align="Center">Day 4</td></tr></cfcase>
					<cfcase value="5"><tr><td width="20%" Align="Center">Day 1</td><td width="20%" Align="Center">Day 2</td><td width="20%" Align="Center">Day 3</td><td width="20%" Align="Center">Day 4</td><td width="20%" Align="Center">Day 5</td></tr></cfcase>
					<cfcase value="6"><tr><td width="16%" Align="Center">Day 1</td><td width="16%" Align="Center">Day 2</td><td width="16%" Align="Center">Day 3</td><td width="16%" Align="Center">Day 4</td><td width="16%" Align="Center">Day 5</td><td>Day 6</td></tr></cfcase>
				</cfswitch>
			</thead>
			<tbody>
				<cfswitch expression="#Session.EventNumberOfDays#">
					<cfcase value="1">
						<tr>
							<td style="font-family: Arial; font-size: 14px; text-align: center">
								<cfif Session.getSelectedEvent.Event_DailySessions EQ 1>
									<table class="table" cellspacing="0" cellpadding="0"><tr>
										<td width="50%"><cfif Session.getRegisteredParticipants.RegisterForEventSessionAM EQ 1 and Session.getRegisteredParticipants.AttendedEventSessionAM EQ 0><cfinput type="CheckBox" Name="ParticipantEmployee" id="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_AM"><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" id="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_AM" checked disabled></cfif></td>
										<td Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventSessionPM EQ 1 and Session.getRegisteredParticipants.AttendedEventSessionPM EQ 0><cfinput type="CheckBox" Name="ParticipantEmployee" id="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_PM"><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" id="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_PM" checked disabled></cfif></td>
									</tr></table>
								<cfelse>
									<cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1 and Session.getRegisteredParticipants.AttendedEventDate1 EQ 0>
										<cfif isDefined("URL.Action")>
											<cfif URL.Action EQ "CheckAll">
												<cfinput type="CheckBox" id="ParticipantEmployee" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>
											<cfelse>
												<cfinput type="CheckBox" id="ParticipantEmployee" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"><cfinput type="hidden" id="ParticipantUserID" Name="ParticipantUserID" Value="#Session.getRegisteredParticipants.User_ID#_1">
											</cfif>
										<cfelse>
											<cfinput type="CheckBox" id="ParticipantEmployee" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"><cfinput type="hidden" id="ParticipantUserID" Name="ParticipantUserID" Value="#Session.getRegisteredParticipants.User_ID#_1">
										</cfif>
									<cfelse>
										<cfinput type="CheckBox" id="ParticipantEmployee" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked>
									</cfif>
								</cfif>
							</td>
						</tr>
					</cfcase>
					<cfcase value="2">
						<tr>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="50%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="50%"></td>
						</tr>
					</cfcase>
					<cfcase value="3">
						<tr>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="33%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="34%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="33%"></td>
						</tr>
					</cfcase>
					<cfcase value="4">
						<tr>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="25%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="25%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="25%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="25%"></td>
						</tr>
					</cfcase>
					<cfcase value="5">
						<tr>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="20%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="20%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="20%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="20%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="20%"></td>
						</tr>
					</cfcase>
					<cfcase value="6">
						<tr>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="16%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="16%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="16%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="16%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="16%"></td>
							<td style="font-family: Arial; font-size: 14px; text-align: center" width="16%"></td>
						</tr>
					</cfcase>
				</cfswitch>
			</tbody>
		</table>
		

		<!--- 
		<table class="table" cellspacing="0" cellpadding="0">
			<tr><td colspan="#Variables.NumberOfEventDates#" Align="Center">#Session.getRegisteredParticipants.LName#, #Session.getRegisteredParticipants.FName#<br><small><cfif LEN(Session.getRegisteredParticipants.OrganizationName)>(#Session.getRegisteredParticipants.OrganizationName#)<cfelse>(#Session.getRegisteredparticipants.Domain#)</cfif></small></td></tr>
			<tr>
				<cfswitch expression="#Variables.NumberOfEventDates#">
					<cfcase value="1"><td Align="Center"><cfif Session.getSelectedEvent.Event_DailySessions EQ 1><table class="table" cellspacing="0" cellpadding="0"><tr><td Align="Center">Session AM</td><td Align="Center">Session PM</td></tr></table></cfif></td></cfcase>
					<cfcase value="2"><td width="50%" Align="Center">Day 1</td><td width="50%" Align="Center">Day 2</td></cfcase>
					<cfcase value="3"><td width="33%" Align="Center">Day 1</td><td width="33%" Align="Center">Day 2</td><td Align="Center">Day 3</td></cfcase>
					<cfcase value="4"><td width="25%" Align="Center">Day 1</td><td width="25%" Align="Center">Day 2</td><td width="25%" Align="Center">Day 3</td><td width="25%" Align="Center">Day 4</td></cfcase>
					<cfcase value="5"><td width="20%" Align="Center">Day 1</td><td width="20%" Align="Center">Day 2</td><td width="20%" Align="Center">Day 3</td><td width="20%" Align="Center">Day 4</td><td width="20%" Align="Center">Day 5</td></cfcase>
					<cfcase value="6"><td width="16%" Align="Center">Day 1</td><td width="16%" Align="Center">Day 2</td><td width="16%" Align="Center">Day 3</td><td width="16%" Align="Center">Day 4</td><td width="16%" Align="Center">Day 5</td><td>Day 6</td></cfcase>
				</cfswitch>
			</tr>
			<tr>

			<cfswitch expression="#Variables.NumberOfEventDates#">
				<cfcase value="1">
					<td Align="Center"><cfif Session.getSelectedEvent.Event_DailySessions EQ 0><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate1 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll">


					<cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif>
					<cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled></cfif><cfelse>&nbsp;</cfif><cfelse><table class="table" cellspacing="0" cellpadding="0"><tr><td Align="Center">

					<cfif Session.getRegisteredParticipants.AttendedEventSessionAM EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_AM" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_AM"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_AM"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_AM" checked disabled></cfif></td><td Align="Center"><cfif Session.getRegisteredParticipants.AttendedEventSessionPM EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_PM" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_PM"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_PM"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_PM" checked disabled></cfif></td></tr></table></cfif></td>
				</cfcase>
				<cfcase value="2">
					<td width="50%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate1 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="50%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate2 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
				</cfcase>
				<cfcase value="3">
					<td width="33%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate1 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="33%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate2 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate3 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
				</cfcase>
				<cfcase value="4">
					<td width="25%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate1 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="25%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate2 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="25%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate3 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="25%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate4 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
				</cfcase>
				<cfcase value="5">
					<td width="20%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate1 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="20%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate2 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="20%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate3 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="20%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate4 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="20%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate5 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
				</cfcase>
				<cfcase value="6">
					<td width="16%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate1 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate1 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_1" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="16%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate2 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate2 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_2" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="16%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate3 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate3 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_3" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="16%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate4 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate4 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_4" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td width="16%" Align="Center"><cfif Session.getRegisteredParticipants.RegisterForEventDate5 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate5 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_5" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
					<td><cfif Session.getRegisteredParticipants.RegisterForEventDate6 EQ 1><cfif Session.getRegisteredParticipants.AttendedEventDate6 EQ 0><cfif isDefined("URL.Action")><cfif URL.Action EQ "CheckAll"><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6" checked><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6"></cfif><cfelse><cfinput type="CheckBox" Name="ParticipantEmployee" Value="#Session.getRegisteredParticipants.User_ID#_6" checked disabled></cfif><cfelse>&nbsp;</cfif></td>
				</cfcase>
			</cfswitch>
		</tr>
	</table>
--->
	<cfelse>
		<table class="table" cellspacing="0" cellpadding="0">
			<tr><td>&nbsp;<br>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</cfif>
</cfoutput>