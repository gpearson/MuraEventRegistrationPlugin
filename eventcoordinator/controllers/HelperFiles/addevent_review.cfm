<cfif not isDefined("FORM.formSubmit")>
	<cfif Session.FormInput.EventStep1.Meal_Available CONTAINS 1>
		<cfquery name="getSelectedCatererInfo" dbtype="Query">
			Select *
			From Session.getActiveCaterers
			Where TContent_ID = <cfqueryparam value="#Session.FormInput.EventStep2.Meal_ProvidedBy#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset Session.getSelectedCatererInfo = StructCopy(getSelectedCatererInfo)>
	</cfif>

	<cfif isDefined("Session.FormInput.EventStep1.PresenterID")>
		<cfquery name="getSelectedPresenterInfo" dbtype="Query">
			Select *
			From Session.getAllPresenters
			Where UserID = <cfqueryparam value="#Session.FormInput.EventStep1.PresenterID#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfset Session.getSelectedPresenterInfo = StructCopy(getSelectedPresenterInfo)>
	</cfif>
	
	
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
		<cfset EventDate = #CreateDate(ListLast(Session.FormInput.EventStep1.EventDate, '/'), ListFirst(Session.FormInput.EventStep1.EventDate, '/'), ListGetAt(Session.FormInput.EventStep1.EventDate, 2, '/'))#>
		<cfset RegistrationDeadline = #CreateDate(ListLast(Session.FormInput.EventStep1.Registration_Deadline, '/'), ListFirst(Session.FormInput.EventStep1.Registration_Deadline, '/'), ListGetAt(Session.FormInput.EventStep1.Registration_Deadline, 2, '/'))#>

		<cfset RegistrationBeginTime = #CreateDateTime(ListLast(Session.FormInput.EventStep1.Registration_Deadline, '/'), ListFirst(Session.FormInput.EventStep1.Registration_Deadline, '/'), ListGetAt(Session.FormInput.EventStep1.Registration_Deadline, 2, '/'), Hour(Session.FormInput.EventStep1.Registration_BeginTime), Minute(Session.FormInput.EventStep1.Registration_BeginTime), 0)#>
		<cfset EventBeginTime = #CreateDateTime(ListLast(Session.FormInput.EventStep1.EventDate, '/'), ListFirst(Session.FormInput.EventStep1.EventDate, '/'), ListGetAt(Session.FormInput.EventStep1.EventDate, 2, '/'), Hour(Session.FormInput.EventStep1.Event_StartTime), Minute(Session.FormInput.EventStep1.Event_StartTime), 0)#>
		<cfset EventEndTime = #CreateDateTime(ListLast(Session.FormInput.EventStep1.EventDate, '/'), ListFirst(Session.FormInput.EventStep1.EventDate, '/'), ListGetAt(Session.FormInput.EventStep1.EventDate, 2, '/'), Hour(Session.FormInput.EventStep1.Event_EndTime), Minute(Session.FormInput.EventStep1.Event_EndTime), 0)#>

		
		<cfquery name="insertNewEvent" result="InsertNewRecord" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Insert into p_EventRegistration_Events(Site_ID, ShortTitle, EventDate, Event_StartTime, Event_EndTime, Event_MemberCost, Event_NonMemberCost, Event_HeldAtFacilityID, Event_FacilityRoomID, Event_MaxParticipants, Registration_Deadline, Registration_BeginTime, Registration_EndTime, Featured_Event, Featured_SortOrder, EarlyBird_Available, GroupPrice_Available, PGPCertificate_Available, Meal_Available, Meal_Included, Meal_ProvidedBy, FacilitatorID, Webinar_Available, Event_DailySessions, H323_Available, Active, AcceptRegistrations, EventCancelled, EventInvoicesGenerated, BillForNoShow, PGPCertificatesGenerated, EventPricePerDay, PostedTo_Facebook, Event_OptionalCosts, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID)
			Values(
				<cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#Session.FormInput.EventStep1.ShortTitle#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#Variables.EventDate#">,
				<cfqueryparam cfsqltype="cf_sql_time" value="#Variables.EventBeginTime#">,
				<cfqueryparam cfsqltype="cf_sql_time" value="#Variables.EventEndTime#">,
				<cfqueryparam value="#Session.FormInput.EventStep1.Event_MemberCost#" cfsqltype="cf_sql_double">,
				<cfqueryparam value="#Session.FormInput.EventStep1.Event_NonMemberCost#" cfsqltype="cf_sql_double">,
				<cfqueryparam value="#Session.FormInput.EventStep1.Event_HeldAtFacilityID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Session.FormInput.EventStep2.Event_FacilityRoomID#" cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Session.FormInput.EventStep3.EventMaxParticipants#" cfsqltype="cf_sql_integer">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#Variables.RegistrationDeadline#">,
				<cfqueryparam value="#Variables.RegistrationBeginTime#" cfsqltype="cf_sql_time">,
				<cfqueryparam value="#Variables.EventBeginTime#" cfsqltype="cf_sql_time">,
				<cfif Session.FormInput.EventStep1.Featured_Event CONTAINS 1>
					<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
				<cfelse>
					<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				</cfif>
				<cfqueryparam value="1" cfsqltype="cf_sql_integer">,
				<cfif Session.FormInput.EventStep1.EarlyBird_Available CONTAINS 1>
					<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
				<cfelse>
					<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				</cfif>
				<cfif Session.FormInput.EventStep1.GroupPrice_Available CONTAINS 1>
					<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
				<cfelse>
					<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				</cfif>
				<cfif Session.FormInput.EventStep1.PGPCertificate_Available	CONTAINS 1>
					<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
				<cfelse>
					<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				</cfif>
				<cfif Session.FormInput.EventStep1.Meal_Available CONTAINS 1>
					<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#Session.FormInput.EventStep2.Meal_Included#" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="#Session.FormInput.EventStep2.Meal_ProvidedBy#" cfsqltype="cf_sql_integer">,
				<cfelse>
					<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
					<cfqueryparam value="0" cfsqltype="cf_sql_integer">,
				</cfif>
				<cfqueryparam value="#Session.FormInput.EventStep1.FacilitatorID#" cfsqltype="cf_sql_varchar">,
				<cfif Session.FormInput.EventStep1.Webinar_Available CONTAINS 1><cfqueryparam value="1" cfsqltype="cf_sql_bit">,<cfelse><cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>			
				<cfif Session.FormInput.EventStep1.Event_DailySessions CONTAINS 1><cfqueryparam value="1" cfsqltype="cf_sql_bit">,<cfelse><cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>			
				<cfif Session.FormInput.EventStep1.H323_Available CONTAINS 1><cfqueryparam value="1" cfsqltype="cf_sql_bit">,<cfelse><cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>
				<cfqueryparam value="1" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="#Session.FormInput.EventStep3.AcceptRegistrations#" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				<cfif Session.FormInput.EventStep1.BillForNoShow CONTAINS 1><cfqueryparam value="1" cfsqltype="cf_sql_bit">,<cfelse><cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>
				<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				<cfif Session.FormInput.EventStep1.EventPricePerDay CONTAINS 1><cfqueryparam value="1" cfsqltype="cf_sql_bit">,<cfelse><cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>
				<cfif Session.FormInput.EventStep1.PostedTo_Facebook CONTAINS 1><cfqueryparam value="1" cfsqltype="cf_sql_bit">,<cfelse><cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>
				<cfif Session.FormInput.EventStep1.Event_OptionalCosts CONTAINS 1><cfqueryparam value="1" cfsqltype="cf_sql_bit">,<cfelse><cfqueryparam value="0" cfsqltype="cf_sql_bit">,</cfif>
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
			)
		</cfquery>

		<cfif isDefined("Session.FormInput.EventStep1.LongDescription")>
			<cfif LEN(Session.FormInput.EventStep1.LongDescription)>
				<cfswitch expression="#application.configbean.getDBType()#">
					<cfcase value="mysql">
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Events
							Set LongDescription = <cfqueryparam value="#Session.FormInput.EventStep1.LongDescription#" cfsqltype="cf_sql_varchar">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					</cfcase>
					<cfcase value="mssql">
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Events
							Set LongDescription = <cfqueryparam value="#Session.FormInput.EventStep1.LongDescription#" cfsqltype="cf_sql_varchar">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
						</cfquery>
					</cfcase>
				</cfswitch>
			</cfif>
		</cfif>

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
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('password')#">
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
		<cfif isDefined("Session.FormInput.EventStep1.Event_SpecialMessage")>
			<cfif LEN(Session.FormInput.EventStep1.Event_SpecialMessage)>
				<cfswitch expression="#application.configbean.getDBType()#">
					<cfcase value="mysql">
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Events
							Set Event_SpecialMessage = <cfqueryparam value="#Session.FormInput.EventStep1.Event_SpecialMessage#" cfsqltype="cf_sql_varchar">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					</cfcase>
					<cfcase value="mssql">
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Events
							Set Event_SpecialMessage = <cfqueryparam value="#Session.FormInput.EventStep1.Event_SpecialMessage#" cfsqltype="cf_sql_varchar">,
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
		<cfif Session.FormInput.EventStep1.Event_HasMultipleDates CONTAINS 1>
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
		<cfif Session.FormInput.EventStep1.Featured_Event CONTAINS 1>
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
		<cfif Session.FormInput.EventStep1.EarlyBird_Available CONTAINS 1>
			<cfswitch expression="#application.configbean.getDBType()#">
				<cfcase value="mysql">
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Events
						Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
							EarlyBird_Deadline = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EarlyBird_Deadline, '/'), ListFirst(Session.FormInput.EventStep2.EarlyBird_Deadline, '/'), ListGetAt(Session.FormInput.EventStep2.EarlyBird_Deadline, 2, '/'))#" cfsqltype="cf_sql_date">,
							EarlyBird_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.EarlyBird_MemberCost#" cfsqltype="cf_sql_double">,
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
							EarlyBird_Deadline = <cfqueryparam value="#CreateDate(ListLast(Session.FormInput.EventStep2.EarlyBird_Deadline, '/'), ListFirst(Session.FormInput.EventStep2.EarlyBird_Deadline, '/'), ListGetAt(Session.FormInput.EventStep2.EarlyBird_Deadline, 2, '/'))#" cfsqltype="cf_sql_date">,
							EarlyBird_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.EarlyBird_MemberCost#" cfsqltype="cf_sql_double">,
							EarlyBird_NonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.EarlyBird_NonMemberCost#" cfsqltype="cf_sql_double">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
					</cfquery>
				</cfcase>
			</cfswitch>
		</cfif>
		<cfif Session.FormInput.EventStep1.Event_DailySessions CONTAINS 1>
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
		<cfif Session.FormInput.EventStep1.GroupPrice_Available CONTAINS 1>
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
		<cfif Session.FormInput.EventStep1.Meal_Available Contains 1>
			<cfswitch expression="#application.configbean.getDBType()#">
				<cfcase value="mysql">
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Events
						Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
							Meal_Cost = <cfqueryparam value="#Session.FormInput.EventStep2.Meal_Cost#" cfsqltype="cf_sql_double">
							<cfif LEN(Session.FormInput.EventStep2.Meal_Information)>, Meal_Information = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.Meal_Information#"></cfif>
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfcase>
				<cfcase value="mssql">
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Events
						Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
							Meal_Cost = <cfqueryparam value="#Session.FormInput.EventStep2.Meal_Cost#" cfsqltype="cf_sql_double">
							<cfif LEN(Session.FormInput.EventStep2.Meal_Information)>, Meal_Information = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.Meal_Information#"></cfif>
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
					</cfquery>
				</cfcase>
			</cfswitch>
		</cfif>
		<cfif Session.FormInput.EventStep1.PGPCertificate_Available CONTAINS 1>
			<cfswitch expression="#application.configbean.getDBType()#">
				<cfcase value="mysql">
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Events
						Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
							PGPCertificate_Points = <cfqueryparam value="#Session.FormInput.EventStep2.PGPCertificate_Points#" cfsqltype="cf_sql_double">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfcase>
				<cfcase value="mssql">
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Events
						Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
							PGPCertificate_Points = <cfqueryparam value="#Session.FormInput.EventStep2.PGPCertificate_Points#" cfsqltype="cf_sql_double">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
					</cfquery>
				</cfcase>
			</cfswitch>
		</cfif>
		<cfif Session.FormInput.EventStep1.H323_Available CONTAINS 1>
			<cfswitch expression="#application.configbean.getDBType()#">
				<cfcase value="mysql">
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Events
						Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
							H323_ConnectInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.H323_ConnectInfo#">,
							H323_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.H323_MemberCost#" cfsqltype="cf_sql_double">,
							H323_NonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.H323_NonMemberCost#" cfsqltype="cf_sql_double">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfcase>
				<cfcase value="mssql">
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Events
						Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
							H323_ConnectInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.H323_ConnectInfo#">,
							H323_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.H323_MemberCost#" cfsqltype="cf_sql_double">,
							H323_NonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.H323_NonMemberCost#" cfsqltype="cf_sql_double">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
					</cfquery>
				</cfcase>
			</cfswitch>
		</cfif>
		<cfif Session.FormInput.EventStep1.Webinar_Available CONTAINS 1>
			<cfswitch expression="#application.configbean.getDBType()#">
				<cfcase value="mysql">
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Events
						Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
							Webinar_ConnectInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.Webinar_ConnectInfo#">,
							Webinar_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.Webinar_MemberCost#" cfsqltype="cf_sql_double">,
							Webinar_NonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.Webinar_NonMemberCost#" cfsqltype="cf_sql_double">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfcase>
				<cfcase value="mssql">
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Events
						Set lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
							Webinar_ConnectInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.EventStep2.Webinar_ConnectInfo#">,
							Webinar_MemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.Webinar_MemberCost#" cfsqltype="cf_sql_double">,
							Webinar_NonMemberCost = <cfqueryparam value="#Session.FormInput.EventStep2.Webinar_NonMemberCost#" cfsqltype="cf_sql_double">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
					</cfquery>
				</cfcase>
			</cfswitch>
		</cfif>

		<cfif Session.FormInput.EventStep1.Event_OptionalCosts EQ 1>

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