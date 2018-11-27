<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getFacilitySelectedRoom" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, Facility_ID, RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
				From p_EventRegistration_FacilityRooms
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and Facility_ID = <cfqueryparam value="#Session.FormInput.EventStep1.LocationID#" cfsqltype="cf_sql_integer"> and TContent_ID = <cfqueryparam value="#Session.FormInput.EventStep2.LocationRoomID#" cfsqltype="cf_sql_integer">
				Order by RoomName
			</cfquery>
			<cfset Session.getSelectedFacilityRoomInfo = StructCopy(getFacilitySelectedRoom)>
			<cfquery name="getSelectedCatererInfo" dbtype="Query">
				Select *
				From Session.getActiveCaterers
				Where TContent_ID = <cfqueryparam value="#Session.FormInput.EventStep2.MealProvidedBy#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfset Session.getSelectedCatererInfo = #StructCopy(getSelectedCatererInfo)#>
		<cfelse>
			<cfif FORM.UserAction EQ "Make Changes to Event">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.getActiveCaterers")><cfset temp = StructDelete(Session, "getActiveCaterers")></cfif>
				<cfif isDefined("Session.getMembership")><cfset temp = StructDelete(Session, "getMembership")></cfif>
				<cfif isDefined("Session.getFacilities")><cfset temp = StructDelete(Session, "getFacilities")></cfif>
				<cfif isDefined("Session.getUsers")><cfset temp = StructDelete(Session, "getUsers")></cfif>
				<cfif isDefined("Session.GetEventGroups")><cfset temp = StructDelete(Session, "GetEventGroups")></cfif>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.addevent" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfquery name="insertNewEvent" result="InsertNewRecord" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Insert into p_EventRegistration_Events(Site_ID, ShortTitle, EventDate, LongDescription, Event_StartTime, Event_EndTime, Registration_Deadline, Registration_BeginTime, Registration_EndTime, EventFeatured, Member_Cost, NonMember_Cost, EarlyBird_Available, ViewGroupPricing, PGPAvailable, Meal_Available, Meal_Included, AllowVideoConference, AcceptRegistrations, MaxParticipants, LocationID, LocationRoomID, FacilitatorID, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active, WebinarAvailable, PostedTo_Facebook, PostedTo_Twitter, EventHasDailySessions, EventInvoicesGenerated, PGPCertificatesGenerated, BillForNoShow, EventHasOptionalCosts)
					Values(
						<cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Session.FormInput.EventStep1.ShortTitle#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep1.EventDate, '/'), ListFirst(Session.FormInput.EventStep1.EventDate, '/'), ListGetAt(Session.FormInput.EventStep1.EventDate, 2, '/'))#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#Session.FormInput.EventStep1.LongDescription#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#Session.FormInput.EventStep1.Event_StartTime#" cfsqltype="cf_sql_time">,
						<cfqueryparam value="#Session.FormInput.EventStep1.Event_EndTime#" cfsqltype="cf_sql_time">,
						<cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep1.Registration_Deadline, '/'), ListFirst(Session.FormInput.EventStep1.Registration_Deadline, '/'), ListGetAt(Session.FormInput.EventStep1.Registration_Deadline, 2, '/'))#" cfsqltype="cf_sql_date">,
						<cfqueryparam value="#Session.FormInput.EventStep1.Registration_BeginTime#" cfsqltype="cf_sql_time">,
						<cfqueryparam value="#Session.FormInput.EventStep1.Event_StartTime#" cfsqltype="cf_sql_time">,
						<cfqueryparam value="#Session.FormInput.EventStep1.EventFeatured#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.FormInput.EventStep1.MemberCost#" cfsqltype="cf_sql_double">,
						<cfqueryparam value="#Session.FormInput.EventStep1.NonMemberCost#" cfsqltype="cf_sql_double">,
						<cfqueryparam value="#Session.FormInput.EventStep1.EarlyBird_RegistrationAvailable#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.FormInput.EventStep1.ViewGroupPricing#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.FormInput.EventStep1.PGPAvailable#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.FormInput.EventStep1.MealAvailable#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.FormInput.EventStep1.AllowVideoConference#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.FormInput.EventStep3.AcceptRegistrations#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.FormInput.EventStep3.EventMaxParticipants#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Session.FormInput.EventStep1.LocationID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Session.FormInput.EventStep2.LocationRoomID#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Session.FormInput.EventStep1.Facilitator#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.FormInput.EventStep1.WebinarEvent#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.FormInput.EventStep1.EventHaveSessions#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.FormInput.EventStep1.BillForNoShow#" cfsqltype="cf_sql_bit">,
						<cfqueryparam value="#Session.FormInput.EventStep1.EventHasOptionalCosts#" cfsqltype="cf_sql_bit">
						)
				</cfquery>

				<cfif isDefined("Session.FormInput.EventStep1.EventAgenda")>
					<cfif LEN(Session.FormInput.EventStep1.EventAgenda)>
						<cfswitch expression="#application.configbean.getDBType()#">
							<cfcase value="mysql">
								<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_Events
									Set EventAgenda = <cfqueryparam value="#Session.FormInput.EventStep1.EventAgenda#" cfsqltype="cf_sql_varchar">,
										lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
								</cfquery>
							</cfcase>
							<cfcase value="mssql">
								<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_Events
									Set EventAgenda = <cfqueryparam value="#Session.FormInput.EventStep1.EventAgenda#" cfsqltype="cf_sql_varchar">,
										lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
								</cfquery>
							</cfcase>
						</cfswitch>
					</cfif>
				</cfif>

				<cfif isDefined("Session.FormInput.EventStep1.EventTargetAudience")>
					<cfif LEN(Session.FormInput.EventStep1.EventTargetAudience)>
						<cfswitch expression="#application.configbean.getDBType()#">
							<cfcase value="mysql">
								<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_Events
									Set EventTargetAudience = <cfqueryparam value="#Session.FormInput.EventStep1.EventTargetAudience#" cfsqltype="cf_sql_varchar">,
										lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
									where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
								</cfquery>
							</cfcase>
							<cfcase value="mssql">
								<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_Events
									Set EventTargetAudience = <cfqueryparam value="#Session.FormInput.EventStep1.EventTargetAudience#" cfsqltype="cf_sql_varchar">,
										lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
								</cfquery>
							</cfcase>
						</cfswitch>
					</cfif>
				</cfif>

				<cfif isDefined("Session.FormInput.EventStep1.EventStrategies")>
					<cfif LEN(Session.FormInput.EventStep1.EventStrategies)>
						<cfswitch expression="#application.configbean.getDBType()#">
							<cfcase value="mysql">
								<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_Events
									Set EventStrategies = <cfqueryparam value="#Session.FormInput.EventStep1.EventStrategies#" cfsqltype="cf_sql_varchar">,
										lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
								</cfquery>
							</cfcase>
							<cfcase value="mssql">
								<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_Events
									Set EventStrategies = <cfqueryparam value="#Session.FormInput.EventStep1.EventStrategies#" cfsqltype="cf_sql_varchar">,
										lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
								</cfquery>
							</cfcase>
						</cfswitch>
					</cfif>
				</cfif>

				<cfif isDefined("Session.FormInput.EventStep1.EventSpecialInstructions")>
					<cfif LEN(Session.FormInput.EventStep1.EventSpecialInstructions)>
						<cfswitch expression="#application.configbean.getDBType()#">
							<cfcase value="mysql">
								<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_Events
									Set EventSpecialInstructions = <cfqueryparam value="#Session.FormInput.EventStep1.EventSpecialInstructions#" cfsqltype="cf_sql_varchar">,
										lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
									where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
								</cfquery>
							</cfcase>
							<cfcase value="mssql">
								<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
									update p_EventRegistration_Events
									Set EventSpecialInstructions = <cfqueryparam value="#Session.FormInput.EventStep1.EventSpecialInstructions#" cfsqltype="cf_sql_varchar">,
										lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
										lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
										lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
									Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
								</cfquery>
							</cfcase>
						</cfswitch>
					</cfif>
				</cfif>
				<cfif Session.FormInput.EventStep1.PresenterID NEQ 0>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set PresenterID = <cfqueryparam value="#Session.FormInput.EventStep1.PresenterID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set PresenterID = <cfqueryparam value="#Session.FormInput.EventStep1.PresenterID#" cfsqltype="cf_sql_varchar">,
									lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>

				<cfif Session.FormInput.EventStep1.EventSpandates EQ 1>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									EventPricePerDay = <cfqueryparam value="#Session.FormInput.EventStep1.EventCostPerDay#" cfsqltype="cf_sql_bit">
									<cfif LEN(Session.FormInput.EventStep2.EventDate1)>, EventDate1 = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EventDate1, '/'), ListFirst(Session.FormInput.EventStep2.EventDate1, '/'), ListGetAt(Session.FormInput.EventStep2.EventDate1, 2, '/'))#" cfsqltype="cf_sql_date"></cfif>
									<cfif LEN(Session.FormInput.EventStep2.EventDate2)>, EventDate2 = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EventDate2, '/'), ListFirst(Session.FormInput.EventStep2.EventDate2, '/'), ListGetAt(Session.FormInput.EventStep2.EventDate2, 2, '/'))#" cfsqltype="cf_sql_date"></cfif>
									<cfif LEN(Session.FormInput.EventStep2.EventDate3)>, EventDate3 = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EventDate3, '/'), ListFirst(Session.FormInput.EventStep2.EventDate3, '/'), ListGetAt(Session.FormInput.EventStep2.EventDate3, 2, '/'))#" cfsqltype="cf_sql_date"></cfif>
									<cfif LEN(Session.FormInput.EventStep2.EventDate4)>, EventDate4 = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EventDate4, '/'), ListFirst(Session.FormInput.EventStep2.EventDate4, '/'), ListGetAt(Session.FormInput.EventStep2.EventDate4, 2, '/'))#" cfsqltype="cf_sql_date"></cfif>
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									EventPricePerDay = <cfqueryparam value="#Session.FormInput.EventStep1.EventCostPerDay#" cfsqltype="cf_sql_bit">
									<cfif LEN(Session.FormInput.EventStep2.EventDate1)>, EventDate1 = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EventDate1, '/'), ListFirst(Session.FormInput.EventStep2.EventDate1, '/'), ListGetAt(Session.FormInput.EventStep2.EventDate1, 2, '/'))#" cfsqltype="cf_sql_date"></cfif>
									<cfif LEN(Session.FormInput.EventStep2.EventDate2)>, EventDate2 = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EventDate2, '/'), ListFirst(Session.FormInput.EventStep2.EventDate2, '/'), ListGetAt(Session.FormInput.EventStep2.EventDate2, 2, '/'))#" cfsqltype="cf_sql_date"></cfif>
									<cfif LEN(Session.FormInput.EventStep2.EventDate3)>, EventDate3 = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EventDate3, '/'), ListFirst(Session.FormInput.EventStep2.EventDate3, '/'), ListGetAt(Session.FormInput.EventStep2.EventDate3, 2, '/'))#" cfsqltype="cf_sql_date"></cfif>
									<cfif LEN(Session.FormInput.EventStep2.EventDate4)>, EventDate4 = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EventDate4, '/'), ListFirst(Session.FormInput.EventStep2.EventDate4, '/'), ListGetAt(Session.FormInput.EventStep2.EventDate4, 2, '/'))#" cfsqltype="cf_sql_date"></cfif>
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>

				<cfif Session.FormInput.EventStep1.EventFeatured EQ 1>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									Featured_StartDate = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.Featured_StartDate, '/'), ListFirst(Session.FormInput.EventStep2.Featured_StartDate, '/'), ListGetAt(Session.FormInput.EventStep2.Featured_StartDate, 2, '/'))#" cfsqltype="cf_sql_date">,
									Featured_EndDate = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.Featured_EndDate, '/'), ListFirst(Session.FormInput.EventStep2.Featured_EndDate, '/'), ListGetAt(Session.FormInput.EventStep2.Featured_EndDate, 2, '/'))#" cfsqltype="cf_sql_date">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									Featured_StartDate = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.Featured_StartDate, '/'), ListFirst(Session.FormInput.EventStep2.Featured_StartDate, '/'), ListGetAt(Session.FormInput.EventStep2.Featured_StartDate, 2, '/'))#" cfsqltype="cf_sql_date">,
									Featured_EndDate = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.Featured_EndDate, '/'), ListFirst(Session.FormInput.EventStep2.Featured_EndDate, '/'), ListGetAt(Session.FormInput.EventStep2.Featured_EndDate, 2, '/'))#" cfsqltype="cf_sql_date">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>

				<cfif Session.FormInput.EventStep1.EarlyBird_RegistrationAvailable EQ 1>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									EarlyBird_Deadline = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EarlyBird_RegistrationDeadline, '/'), ListFirst(Session.FormInput.EventStep2.EarlyBird_RegistrationDeadline, '/'), ListGetAt(Session.FormInput.EventStep2.EarlyBird_RegistrationDeadline, 2, '/'))#" cfsqltype="cf_sql_date">,
									EarlyBird_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.EarlyBird_Member#" cfsqltype="cf_sql_double">,
									EarlyBird_NonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.EarlyBird_NonMemberCost#" cfsqltype="cf_sql_double">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									EarlyBird_Deadline = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EarlyBird_RegistrationDeadline, '/'), ListFirst(Session.FormInput.EventStep2.EarlyBird_RegistrationDeadline, '/'), ListGetAt(Session.FormInput.EventStep2.EarlyBird_RegistrationDeadline, 2, '/'))#" cfsqltype="cf_sql_date">,
									EarlyBird_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.EarlyBird_Member#" cfsqltype="cf_sql_double">,
									EarlyBird_NonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.EarlyBird_NonMemberCost#" cfsqltype="cf_sql_double">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>

				<cfif Session.FormInput.EventStep1.EventHaveSessions EQ 1>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									Session1BeginTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession1_StartTime#" cfsqltype="cf_sql_time">,
									Session1EndTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession1_EndTime#" cfsqltype="cf_sql_time">,
									Session2BeginTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession2_StartTime#" cfsqltype="cf_sql_time">,
									Session2EndTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession2_EndTime#" cfsqltype="cf_sql_time">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									Session1BeginTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession1_StartTime#" cfsqltype="cf_sql_time">,
									Session1EndTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession1_EndTime#" cfsqltype="cf_sql_time">,
									Session2BeginTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession2_StartTime#" cfsqltype="cf_sql_time">,
									Session2EndTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession2_EndTime#" cfsqltype="cf_sql_time">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>

				<cfif Session.FormInput.EventStep1.ViewGroupPricing EQ 1>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									GroupPrice_Requirements = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.GroupPriceRequirements#">,
									GroupPrice_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.GroupMemberCost#" cfsqltype="cf_sql_double">,
									GroupPrice_NonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.GroupNonMemberCost#" cfsqltype="cf_sql_double">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									GroupPrice_Requirements = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.GroupPriceRequirements#">,
									GroupPrice_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.GroupMemberCost#" cfsqltype="cf_sql_double">,
									GroupPrice_NonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.GroupNonMemberCost#" cfsqltype="cf_sql_double">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>
				
				<cfif Session.FormInput.EventStep1.MealAvailable EQ 1>
					<cfset newEvent = #Session.FormInput.FilePath# & #Session.FormInput.EventIDConfig#>
					<cfif not isDefined("Session.FormInput.EventStep1.MealAvailable")><cfset Session.FormInput.EventStep1.MealAvailable = #GetProfileString(variables.newEvent, "NewEvent", "MealAvailable")#></cfif>
					<cfif not isDefined("Session.FormInput.EventStep2.MealCost")><cfset Session.FormInput.EventStep2.MealCost = #GetProfileString(variables.newEvent, "NewEvent", "MealCost")#></cfif>
					<cfif not isDefined("Session.FormInput.EventStep2.MealIncluded")><cfset Session.FormInput.EventStep2.MealIncluded = #GetProfileString(variables.newEvent, "NewEvent", "MealIncluded")#></cfif>
					<cfif not isDefined("Session.FormInput.EventStep2.MealInformation")><cfset Session.FormInput.EventStep2.MealInformation = #GetProfileString(variables.newEvent, "NewEvent", "MealInformation")#></cfif>
					<cfif not isDefined("Session.FormInput.EventStep2.MealProvidedBy")><cfset Session.FormInput.EventStep2.MealProvidedBy = #GetProfileString(variables.newEvent, "NewEvent", "MealProvidedBy")#></cfif>

					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									Meal_Available = <cfqueryparam value="#Session.FormInput.EventStep1.MealAvailable#" cfsqltype="cf_sql_bit">,
									Meal_Included = <cfqueryparam value="#Session.FormInput.EventStep2.MealIncluded#" cfsqltype="cf_sql_bit">,
									Meal_Cost = <cfqueryparam value="#Session.FormInput.EventStep2.MealCost#" cfsqltype="cf_sql_double">,
									Meal_ProvidedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.FormInput.EventStep2.MealProvidedBy#">
									<cfif LEN(Session.FormInput.EventStep2.MealInformation)>, Meal_Notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#"></cfif>
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									Meal_Available = <cfqueryparam value="#Session.FormInput.EventStep1.MealAvailable#" cfsqltype="cf_sql_bit">,
									Meal_Included = <cfqueryparam value="#Session.FormInput.EventStep2.MealIncluded#" cfsqltype="cf_sql_bit">,
									Meal_Cost = <cfqueryparam value="#Session.FormInput.EventStep2.MealCost#" cfsqltype="cf_sql_double">,
									Meal_ProvidedBy = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.FormInput.EventStep2.MealProvidedBy#">
									<cfif LEN(Session.FormInput.EventStep2.MealInformation)>, Meal_Notes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#"></cfif>
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>

				<cfif Session.FormInput.EventStep1.PGPAvailable EQ 1>
					<cfset newEvent = #Session.FormInput.FilePath# & #Session.FormInput.EventIDConfig#>
					<cfif not isDefined("Session.FormInput.EventStep2.PGPPoints")><cfset Session.FormInput.EventStep2.PGPPoints = #GetProfileString(variables.newEvent, "NewEvent", "PGPPoints")#></cfif>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									PGPPoints = <cfqueryparam value="#Session.FormInput.EventStep2.PGPPoints#" cfsqltype="cf_sql_double">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									PGPPoints = <cfqueryparam value="#Session.FormInput.EventStep2.PGPPoints#" cfsqltype="cf_sql_double">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>

				<cfif Session.FormInput.EventStep1.AllowVideoConference EQ 1>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									VideoConferenceInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.H323ConnectionInfo#">,
									VideoConferenceMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.H323ConnectionMemberCost#" cfsqltype="cf_sql_double">,
									VideoConferenceNonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.H323ConnectionNonMemberCost#" cfsqltype="cf_sql_double">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									VideoConferenceInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.H323ConnectionInfo#">,
									VideoConferenceMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.H323ConnectionMemberCost#" cfsqltype="cf_sql_double">,
									VideoConferenceNonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.H323ConnectionNonMemberCost#" cfsqltype="cf_sql_double">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>

				<cfif Session.FormInput.EventStep1.WebinarEvent EQ 1>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									WebinarConnectInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.WebinarConnectWebInfo#">,
									Webinar_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.WebinarMemberCost#" cfsqltype="cf_sql_double">,
									Webinar_NonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.WebinarNonMemberCost#" cfsqltype="cf_sql_double">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Events
								Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
									lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
									WebinarConnectInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.WebinarConnectWebInfo#">,
									Webinar_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.WebinarMemberCost#" cfsqltype="cf_sql_double">,
									Webinar_NonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.WebinarNonMemberCost#" cfsqltype="cf_sql_double">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>

				<cfif Session.FormInput.EventStep1.EventHasOptionalCosts EQ 1>

				</cfif>
			</cflock>

			<cfset temp = StructDelete(Session, "FormErrors")>
			<cfset temp = StructDelete(Session, "FormInput")>
			<cfset temp = StructDelete(Session, "getActiveCaterers")>
			<cfset temp = StructDelete(Session, "getActiveFacilities")>
			<cfset temp = StructDelete(Session, "getActiveFacilityRooms")>
			<cfset temp = StructDelete(Session, "getAllPresenters")>
			<cfset temp = StructDelete(Session, "getCaterers")>
			<cfset temp = StructDelete(Session, "getSelectedCatererInfo")>
			<cfset temp = StructDelete(Session, "getSelectedFacility")>
			<cfset temp = StructDelete(Session, "getSelectedFacilityRoomInfo")>

			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=EventAdded&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.default&UserAction=EventAdded&Successful=True">
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>