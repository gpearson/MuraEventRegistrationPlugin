<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
	<cfquery name="getSelectedEvent" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, ShortTitle, EventDate, EventDate1, EventDate2, EventDate3, EventDate4, EventDate5, EventDate6, Event_HasMultipleDates, LongDescription, EventAgenda, EventTargetAudience, EventStrategies, EventSpecialInstructions, Event_SpecialMessage, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_StartDate, Featured_EndDate, Featured_SortOrder, EarlyBird_Available, EarlyBird_Deadline, EarlyBird_MemberCost, EarlyBird_NonMemberCost, GroupPrice_Available, GroupPrice_Requirements, GroupPrice_MemberCost, GroupPrice_NonMemberCost, PGPCertificate_Available, PGPCertificate_Points, Meal_Available, Meal_Included, Meal_Information, Meal_Cost, Meal_ProvidedBy, PresenterID, FacilitatorID, Webinar_Available, Webinar_ConnectInfo, Webinar_MemberCost, Webinar_NonMemberCost, Event_DailySessions, Event_Session1BeginTime, Event_Session1EndTime, Event_Session2BeginTime, Event_Session2EndTime, H323_Available, H323_ConnectInfo, H323_MemberCost, H323_NonMemberCost, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, PostedTo_Twitter, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
		From p_EventRegistration_Events
		Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		Order By EventDate DESC
	</cfquery>
	<cfset Session.getSelectedEvent = StructCopy(getSelectedEvent)>
	
	<cfif LEN(getSelectedEvent.PresenterID)>
		<cfquery name="getPresenter" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select FName, Lname, Email
			From tusers
			Where UserID = <cfqueryparam value="#getSelectedEvent.PresenterID#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cfif>

	<cfswitch expression="#application.configbean.getDBType()#">
		<cfcase value="mysql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, SUBSTRING_INDEX(tusers.Email,"@",-1) AS Domain, p_EventRegistration_Events.ShortTitle, Date_FORMAT(p_EventRegistration_Events.EventDate, "%a, %M %d, %Y") as EventDateFormat, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
		<cfcase value="mssql">
			<cfquery name="getRegisteredParticipants" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				SELECT p_EventRegistration_UserRegistrations.User_ID, p_EventRegistration_UserRegistrations.RequestsMeal, p_EventRegistration_UserRegistrations.H323Participant, p_EventRegistration_UserRegistrations.WebinarParticipant, tusers.Fname, tusers.Lname, tusers.Company, tusers.Email, Right(tusers.Email, LEN(tusers.Email) - CHARINDEX('@', tusers.email)) AS Domain, p_EventRegistration_Events.ShortTitle, p_EventRegistration_Events.EventDate, p_EventRegistration_UserRegistrations.RegisterForEventDate1, p_EventRegistration_UserRegistrations.RegisterForEventDate2, p_EventRegistration_UserRegistrations.RegisterForEventDate3, p_EventRegistration_UserRegistrations.RegisterForEventDate4, p_EventRegistration_UserRegistrations.RegisterForEventDate5, p_EventRegistration_UserRegistrations.RegisterForEventDate6, p_EventRegistration_UserRegistrations.RegisterForEventSessionAM, p_EventRegistration_UserRegistrations.RegisterForEventSessionPM, p_EventRegistration_UserRegistrations.AttendedEventDate1, p_EventRegistration_UserRegistrations.AttendedEventDate2, p_EventRegistration_UserRegistrations.AttendedEventDate3, p_EventRegistration_UserRegistrations.AttendedEventDate4, p_EventRegistration_UserRegistrations.AttendedEventDate5, p_EventRegistration_UserRegistrations.AttendedEventDate6, p_EventRegistration_UserRegistrations.AttendedEventSessionAM, p_EventRegistration_UserRegistrations.AttendedEventSessionPM
				FROM p_EventRegistration_UserRegistrations INNER JOIN tusers ON tusers.UserID = p_EventRegistration_UserRegistrations.User_ID INNER JOIN p_EventRegistration_Events ON p_EventRegistration_Events.TContent_ID = p_EventRegistration_UserRegistrations.Event_ID
				WHERE p_EventRegistration_UserRegistrations.Event_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer"> and p_EventRegistration_UserRegistrations.Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
				ORDER BY tusers.Lname ASC, tusers.Fname ASC
			</cfquery>
		</cfcase>
	</cfswitch>

	<cfquery name="GetMembershipOrganizations" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
		Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active
		From p_EventRegistration_Membership
		Order by OrganizationName
	</cfquery>

	<cfquery name="GetDistinctMembershipOrganizations" dbtype="Query">Select Distinct Domain From getRegisteredParticipants Order by Domain</cfquery>

	<cfswitch expression="#rc.$.siteConfig('siteID')#">
		<cfdefaultcase>
			<cfset LogoPathLoc = "/plugins/" & #rc.pc.getPackage()# & "/assets/images/NIESC_LogoSM.png">
		</cfdefaultcase>
	</cfswitch>

	<cffile action="readbinary" file="#ExpandPath(Variables.LogoPathLoc)#" variable="ImageBinaryString">
	<cfscript>FileMimeType = fileGetMimeType(ExpandPath(Variables.LogoPathLoc));</cfscript>
	<cfset ReportExportDirLoc = "/plugins/" & #rc.pc.getPackage()# & "/library/ReportExports/">
	<cfset ReportExportLoc = #ExpandPath(ReportExportDirLoc)# & #URL.EventID# & "-SignInSheet.pdf">
	<cfoutput>
		<cfdocument format="PDF" filename="#Variables.ReportExportLoc#" fontEmbed="yes" orientation="portrait" localurl="Yes" pageType="letter" overwrite="true" saveAsName="#URL.EventID#-SignInSheet.pdf">
			<cfdocumentitem type="header" evalAtPrint="true">
				<table border="0" colspacing="1" cellpadding="1" width="100%">
					<tr>
						<th width="30%"><img src="data:#Variables.FileMimeType#;base64,#ToBase64(Variables.ImageBinaryString)#"></th>
						<th width="70%">Northern Indiana Educational Services Center<br>56535 Magnetic Drive<br>Mishawaka IN 46545<br>(800) 326-5642 / (574) 254-0111<br>http://www.niesc.k12.in.us</th>
					</tr>
					<tr> <th colspan="2"><h1>Event Sign In Sheet</h1></th></tr>
					<tr><td colspan="2"><hr style="border-top: 1px solid ##8c8b8b;" /></td></tr>
					<tr><td colspan="2" align="center">#getSelectedEvent.ShortTitle#</td></tr>
					<tr><td colspan="2" align="center">#DateFormat(getSelectedEvent.EventDate, "full")#</td></tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2" align="center" style="font-family: Arial; font-size: 10px;">Please check of fthe participant's name when they have signed in to attend this event. If participants need to make changes to Name, Email they must update their account on the website.</td></tr>
				</table>
			</cfdocumentitem>
			<cfdocumentitem type="footer" evalAtPrint="true">
				<table border="0" colspacing="1" cellpadding="1" width="100%">
					<tr bgcolor="##000040">
						<td style="font-family: Arial; font-size: 10px; color: ##FFFFFF;" align="left">Page #cfdocument.currentpagenumber# of #cfdocument.totalpagecount#</td>
						<td style="font-family: Arial; font-size: 10px; color: ##FFFFFF;" align="right">Printed: #DateFormat(Now(), "short")#</td>
					</tr>
				</table>
			</cfdocumentitem>
			<cfdocumentsection>
				<table border="0" colspacing="1" cellpadding="1" width="100%">
					<cfloop query="GetDistinctMembershipOrganizations">
						<cfquery name="GetMembershipInfo" dbtype="Query">
							Select * from GetMembershipOrganizations Where OrganizationDomainName = <cfqueryparam value="#GetDistinctMembershipOrganizations.Domain#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 0>
							<tr>
								<td bgcolor="##000040" width="60%" style="font-family: Arial; font-size: 12px; color: ##FFFFFF;">#GetMembershipInfo.OrganizationName#</td>
								<td bgcolor="##000040" width="20%" style="font-family: Arial; font-size: 12px; color: ##FFFFFF;" align="center">Requests Meal</td>
								<td bgcolor="##000040" width="20%" style="font-family: Arial; font-size: 12px; color: ##FFFFFF;" align="center">Attendance</td>
							</tr>
						<cfelseif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 1>
							<tr>
								<td bgcolor="##000040" width="80%" style="font-family: Arial; font-size: 12px; color: ##FFFFFF;">#GetMembershipInfo.OrganizationName#</td>
								<td bgcolor="##000040" width="20%" style="font-family: Arial; font-size: 12px; color: ##FFFFFF;" align="center">Attendance</td>
							</tr>
						</cfif>
						<cfif not isDefined("URL.EventDatePOS")>
							<cfquery name="GetOrganizationRegisteredParticipants" dbtype="Query">
								Select *
								FROM getRegisteredParticipants
								Where Domain = <cfqueryparam value="#GetDistinctMembershipOrganizations.Domain#" cfsqltype="cf_sql_varchar"> and RegisterForEventDate1 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
								Order by Lname ASC, FName ASC
							</cfquery>
							<cfloop query="GetOrganizationRegisteredParticipants">
								<tr <cfif GetOrganizationRegisteredParticipants.currentRow Mod 2 EQ 0>bgColor="##DDDDDD"<cfelse>bgColor="##FFFFFF"</cfif>>
									<cfif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 0>
										<td width="60%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
										<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="Center"><cfswitch expression="#GetOrganizationRegisteredParticipants.RequestsMeal#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></td>
										<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
											<cfif GetOrganizationRegisteredParticipants.AttendedEventDate1 EQ 1>
												<input type="checkbox" checked />
											<cfelse>
												<input type="checkbox" />
											</cfif>
										</td>
									<cfelseif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 1>
										<td width="80%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
										<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
											<cfif GetOrganizationRegisteredParticipants.AttendedEventDate1 EQ 1>
												<input type="checkbox" checked />
											<cfelse>
												<input type="checkbox" />
											</cfif>
										</td>
									</cfif>
								</tr>
							</cfloop>
						<cfelse>
							<cfswitch expression="#URL.EventDatePOS#">
								<cfcase value="1">
									<cfquery name="GetOrganizationRegisteredParticipants" dbtype="Query">
										Select *
										FROM getRegisteredParticipants
										Where Domain = <cfqueryparam value="#GetDistinctMembershipOrganizations.Domain#" cfsqltype="cf_sql_varchar"> and RegisterForEventDate2 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										Order by Lname ASC, FName ASC
									</cfquery>
									<cfloop query="GetOrganizationRegisteredParticipants">
										<tr <cfif GetOrganizationRegisteredParticipants.currentRow Mod 2 EQ 0>bgColor="##DDDDDD"<cfelse>bgColor="##FFFFFF"</cfif>>
											<cfif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 0>
												<td width="60%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="Center"><cfswitch expression="#GetOrganizationRegisteredParticipants.RequestsMeal#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
													<cfif GetOrganizationRegisteredParticipants.AttendedEventDate2 EQ 1>
														<input type="checkbox" checked />
													<cfelse>
														<input type="checkbox" />
													</cfif>
												</td>
											<cfelseif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 1>
												<td width="80%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
													<cfif GetOrganizationRegisteredParticipants.AttendedEventDate2 EQ 1>
														<input type="checkbox" checked />
													<cfelse>
														<input type="checkbox" />
													</cfif>
												</td>
											</cfif>
										</tr>
									</cfloop>
								</cfcase>
								<cfcase value="2">
									<cfquery name="GetOrganizationRegisteredParticipants" dbtype="Query">
										Select *
										FROM getRegisteredParticipants
										Where Domain = <cfqueryparam value="#GetDistinctMembershipOrganizations.Domain#" cfsqltype="cf_sql_varchar"> and RegisterForEventDate3 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										Order by Lname ASC, FName ASC
									</cfquery>
									<cfloop query="GetOrganizationRegisteredParticipants">
										<tr <cfif GetOrganizationRegisteredParticipants.currentRow Mod 2 EQ 0>bgColor="##DDDDDD"<cfelse>bgColor="##FFFFFF"</cfif>>
											<cfif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 0>
												<td width="60%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="Center"><cfswitch expression="#GetOrganizationRegisteredParticipants.RequestsMeal#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
													<cfif GetOrganizationRegisteredParticipants.AttendedEventDate3 EQ 1>
														<input type="checkbox" checked />
													<cfelse>
														<input type="checkbox" />
													</cfif>
												</td>
											<cfelseif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 1>
												<td width="80%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
													<cfif GetOrganizationRegisteredParticipants.AttendedEventDate3 EQ 1>
														<input type="checkbox" checked />
													<cfelse>
														<input type="checkbox" />
													</cfif>
												</td>
											</cfif>
										</tr>
									</cfloop>
								</cfcase>
								<cfcase value="3">
									<cfquery name="GetOrganizationRegisteredParticipants" dbtype="Query">
										Select *
										FROM getRegisteredParticipants
										Where Domain = <cfqueryparam value="#GetDistinctMembershipOrganizations.Domain#" cfsqltype="cf_sql_varchar"> and RegisterForEventDate4 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										Order by Lname ASC, FName ASC
									</cfquery>
									<cfloop query="GetOrganizationRegisteredParticipants">
										<tr <cfif GetOrganizationRegisteredParticipants.currentRow Mod 2 EQ 0>bgColor="##DDDDDD"<cfelse>bgColor="##FFFFFF"</cfif>>
											<cfif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 0>
												<td width="60%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="Center"><cfswitch expression="#GetOrganizationRegisteredParticipants.RequestsMeal#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
													<cfif GetOrganizationRegisteredParticipants.AttendedEventDate4 EQ 1>
														<input type="checkbox" checked />
													<cfelse>
														<input type="checkbox" />
													</cfif>
												</td>
											<cfelseif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 1>
												<td width="80%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
													<cfif GetOrganizationRegisteredParticipants.AttendedEventDate4 EQ 1>
														<input type="checkbox" checked />
													<cfelse>
														<input type="checkbox" />
													</cfif>
												</td>
											</cfif>
										</tr>
									</cfloop>
								</cfcase>
								<cfcase value="4">
									<cfquery name="GetOrganizationRegisteredParticipants" dbtype="Query">
										Select *
										FROM getRegisteredParticipants
										Where Domain = <cfqueryparam value="#GetDistinctMembershipOrganizations.Domain#" cfsqltype="cf_sql_varchar"> and RegisterForEventDate5 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										Order by Lname ASC, FName ASC
									</cfquery>
									<cfloop query="GetOrganizationRegisteredParticipants">
										<tr <cfif GetOrganizationRegisteredParticipants.currentRow Mod 2 EQ 0>bgColor="##DDDDDD"<cfelse>bgColor="##FFFFFF"</cfif>>
											<cfif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 0>
												<td width="60%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="Center"><cfswitch expression="#GetOrganizationRegisteredParticipants.RequestsMeal#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
													<cfif GetOrganizationRegisteredParticipants.AttendedEventDate5 EQ 1>
														<input type="checkbox" checked />
													<cfelse>
														<input type="checkbox" />
													</cfif>
												</td>
											<cfelseif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 1>
												<td width="80%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
													<cfif GetOrganizationRegisteredParticipants.AttendedEventDate5 EQ 1>
														<input type="checkbox" checked />
													<cfelse>
														<input type="checkbox" />
													</cfif>
												</td>
											</cfif>
										</tr>
									</cfloop>
								</cfcase>
								<cfcase value="5">
									<cfquery name="GetOrganizationRegisteredParticipants" dbtype="Query">
										Select *
										FROM getRegisteredParticipants
										Where Domain = <cfqueryparam value="#GetDistinctMembershipOrganizations.Domain#" cfsqltype="cf_sql_varchar"> and RegisterForEventDate6 = <cfqueryparam value="1" cfsqltype="cf_sql_bit">
										Order by Lname ASC, FName ASC
									</cfquery>
									<cfloop query="GetOrganizationRegisteredParticipants">
										<tr <cfif GetOrganizationRegisteredParticipants.currentRow Mod 2 EQ 0>bgColor="##DDDDDD"<cfelse>bgColor="##FFFFFF"</cfif>>
											<cfif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 0>
												<td width="60%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="Center"><cfswitch expression="#GetOrganizationRegisteredParticipants.RequestsMeal#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
													<cfif GetOrganizationRegisteredParticipants.AttendedEventDate6 EQ 1>
														<input type="checkbox" checked />
													<cfelse>
														<input type="checkbox" />
													</cfif>
												</td>
											<cfelseif getSelectedEvent.Meal_Available EQ 1 and getSelectedEvent.Meal_Included EQ 1>
												<td width="80%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle">#GetOrganizationRegisteredParticipants.LName#, #GetOrganizationRegisteredParticipants.FName#&nbsp;&nbsp;&nbsp;&nbsp;(#GetOrganizationRegisteredParticipants.Email#)</td>
												<td width="20%" style="font-family: Arial; font-size: 10px; color: ##000000;" valign="middle" align="center">
													<cfif GetOrganizationRegisteredParticipants.AttendedEventDate6 EQ 1>
														<input type="checkbox" checked />
													<cfelse>
														<input type="checkbox" />
													</cfif>
												</td>
											</cfif>
										</tr>
									</cfloop>
								</cfcase>
							</cfswitch>
						</cfif>
						<tr>
							<td bgcolor="##FFFFFF" colspan="3"><br /></td>
						</tr>
					</cfloop>
				</table>
			</cfdocumentsection>
		</cfdocument>
	</cfoutput>
	<cfset Session.SignInReport = #Variables.ReportExportLoc#>
<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.EventID")>
	<cfif FORM.UserAction EQ "Back to Event Listing">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "SiteConfigSettings")>
		<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
		<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
		<cfset temp = StructDelete(Session, "GetMembershipOrganizations")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "JSMuraScope")>
		<cfset temp = StructDelete(Session, "SignInReport")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

</cfif>