<cfif not isDefined("FORM.formSubmit") and isDefined("URL.EventID") and not isDefined("FORM.PerformAction")>

<cfelseif isDefined("FORM.formSubmit") and isDefined("URL.EventID") and isDefined("FORM.PerformAction")>
	<cfif FORM.UserAction EQ "Back to Update Event">
		<cfset temp = StructDelete(Session, "FormErrors")>
		<cfset temp = StructDelete(Session, "FormInput")>
		<cfset temp = StructDelete(Session, "getRegisteredParticipants")>
		<cfset temp = StructDelete(Session, "getSelectedEventPresenter")>
		<cfset temp = StructDelete(Session, "GetMembershipOrganizations")>
		<cfset temp = StructDelete(Session, "getSelectedEvent")>
		<cfset temp = StructDelete(Session, "JSMuraScope")>
		<cfset temp = StructDelete(Session, "SignInReport")>
		<cfif LEN(cgi.path_info)>
			<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&EventID=#URL.EventID#" >
		<cfelse>
			<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&EventID=#URL.EventID#" >
		</cfif>
		<cflocation url="#variables.newurl#" addtoken="false">
	</cfif>

	<cflock timeout="60" scope="Session" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
	</cflock>
	<cfif not isDefined("Session.PluginFramework")>
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cflocation url="/" addtoken="false">
		</cflock>
	</cfif>

	<cfswitch expression="#FORM.PerformAction#">
		<cfcase value="Step2">
			<cfset Session.FormInput.EventStep1 = #StructCopy(FORM)#>
		</cfcase>
		<cfcase value="UpdateEvent">
			<cfset Session.FormInput.EventStep2 = #StructCopy(FORM)#>

			<cfif LEN(FORM.EventDate) LT 10 or not isDate(FORM.EventDate)>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the date of this new event or workshop."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.Registration_Deadline) LT 10 or not isDate(FORM.Registration_Deadline)>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the date of this event's registration deadline."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.Registration_BeginTime) LT 6 or LEN(FORM.Registration_BeginTime) GT 7>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid time on when participants are able to register onsite for the event or workshop."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.Event_StartTime) LT 6 or LEN(FORM.Event_StartTime) GT 7>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid time on when this event or workshop will begin."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.Event_EndTime) LT 6 or LEN(FORM.Event_EndTime) GT 7>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid time on when this event or workshop will end."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif Session.FormInput.EventStep1.Event_HasMultipleDates CONTAINS 1>
				<cfif LEN(FORM.EventDate1)>
					<cfif LEN(FORM.EventDate1) LT 10 or not isDate(FORM.EventDate1)>
						<cfscript>
							errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the second date of this event or workshop."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
					<cfset EventDate1 = #CreateDate(ListLast(FORM.EventDate1, '/'), ListFirst(FORM.EventDate1, '/'), ListGetAt(FORM.EventDate1, 2, '/'))#>
					<cfset FORM.EventDate1 = #Variables.EventDate1#>
					<cfset Session.FormInput.EventStep2.EventDate1 = #Variables.EventDate1#>
				</cfif>
				<cfif LEN(FORM.EventDate2)>
					<cfif LEN(FORM.EventDate2) LT 10 or not isDate(FORM.EventDate2)>
						<cfscript>
							errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the third date of this event or workshop."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
					<cfset EventDate2 = #CreateDate(ListLast(FORM.EventDate2, '/'), ListFirst(FORM.EventDate2, '/'), ListGetAt(FORM.EventDate2, 2, '/'))#>
					<cfset FORM.EventDate2 = #Variables.EventDate2#>
					<cfset Session.FormInput.EventStep2.EventDate2 = #Variables.EventDate2#>
				</cfif>
				<cfif LEN(FORM.EventDate3)>
					<cfif LEN(FORM.EventDate3) LT 10 or not isDate(FORM.EventDate3)>
						<cfscript>
							errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the fourth date of this event or workshop."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
					<cfset EventDate3 = #CreateDate(ListLast(FORM.EventDate3, '/'), ListFirst(FORM.EventDate3, '/'), ListGetAt(FORM.EventDate3, 2, '/'))#>
					<cfset FORM.EventDate3 = #Variables.EventDate3#>
					<cfset Session.FormInput.EventStep2.EventDate3 = #Variables.EventDate3#>
				</cfif>
				<cfif LEN(FORM.EventDate4)>
					<cfif LEN(FORM.EventDate4) LT 10 or not isDate(FORM.EventDate4)>
						<cfscript>
							errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the fifth date of this event or workshop."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
					<cfset EventDate4 = #CreateDate(ListLast(FORM.EventDate4, '/'), ListFirst(FORM.EventDate4, '/'), ListGetAt(FORM.EventDate4, 2, '/'))#>
					<cfset FORM.EventDate4 = #Variables.EventDate4#>
					<cfset Session.FormInput.EventStep2.EventDate4 = #Variables.EventDate4#>
				</cfif>
				<cfif LEN(FORM.EventDate5)>
					<cfif LEN(FORM.EventDate5) LT 10 or not isDate(FORM.EventDate5)>
						<cfscript>
							errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the sixth date of this event or workshop."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
					<cfset EventDate5 = #CreateDate(ListLast(FORM.EventDate5, '/'), ListFirst(FORM.EventDate5, '/'), ListGetAt(FORM.EventDate5, 2, '/'))#>
					<cfset FORM.EventDate5 = #Variables.EventDate5#>
					<cfset Session.FormInput.EventStep2.EventDate5 = #Variables.EventDate5#>
				</cfif>
				<cfif LEN(FORM.EventDate6)>
					<cfif LEN(FORM.EventDate6) LT 10 or not isDate(FORM.EventDate6)>
						<cfscript>
							errormsg = {property="EmailMsg",message="Please enter a valid date in the format of mm/dd/yyyy for the seventh date of this event or workshop."};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfif>
					<cfset EventDate6 = #CreateDate(ListLast(FORM.EventDate6, '/'), ListFirst(FORM.EventDate6, '/'), ListGetAt(FORM.EventDate6, 2, '/'))#>
					<cfset FORM.EventDate6 = #Variables.EventDate6#>
					<cfset Session.FormInput.EventStep2.EventDate6 = #Variables.EventDate6#>
				</cfif>
			</cfif>

			<cfif Session.FormInput.EventStep1.Event_DailySessions CONTAINS 1>
				<cfif LEN(FORM.Event_Session1BeginTime) LT 6 or LEN(FORM.Event_Session1BeginTime) GT 7>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please enter a valid begin time for this event's AM session."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
				<cfif LEN(FORM.Event_Session1EndTime) LT 6 or LEN(FORM.Event_Session1EndTime) GT 7>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please enter a valid end time for this event's AM session."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
				<cfif LEN(FORM.Event_Session2BeginTime) LT 6 or LEN(FORM.Event_Session2BeginTime) GT 7>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please enter a valid begin time for this event's PM session."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
				<cfif LEN(FORM.Event_Session2EndTime) LT 6 or LEN(FORM.Event_Session2EndTime) GT 7>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please enter a valid end time for this event's PM session."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent_dates&EventID=#URL.EventID#&FormRetry=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>

				<cfset TimeHours = #ListFirst(FORM.Event_Session1BeginTime, ":")#>
				<cfset TimeMinutes = #Left(ListLast(FORM.Event_Session1BeginTime, ":"), 2)#>
				<cfset TimeAMPM = #Right(ListLast(FORM.Event_Session1BeginTime, ":"), 2)#>
				<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
				<cfset FORM.Event_Session1BeginTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
				<cfset Session.FormInput.EventStep2.Event_Session1BeginTime = #FORM.Event_Session1BeginTime#>

				<cfset TimeHours = #ListFirst(FORM.Event_Session1EndTime, ":")#>
				<cfset TimeMinutes = #Left(ListLast(FORM.Event_Session1EndTime, ":"), 2)#>
				<cfset TimeAMPM = #Right(ListLast(FORM.Event_Session1EndTime, ":"), 2)#>
				<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
				<cfset FORM.Event_Session1EndTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
				<cfset Session.FormInput.EventStep2.Event_Session1EndTime = #FORM.Event_Session1EndTime#>

				<cfset TimeHours = #ListFirst(FORM.Event_Session2BeginTime, ":")#>
				<cfset TimeMinutes = #Left(ListLast(FORM.Event_Session2BeginTime, ":"), 2)#>
				<cfset TimeAMPM = #Right(ListLast(FORM.Event_Session2BeginTime, ":"), 2)#>
				<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
				<cfset FORM.Event_Session2BeginTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
				<cfset Session.FormInput.EventStep2.Event_Session2BeginTime = #FORM.Event_Session2BeginTime#>

				<cfset TimeHours = #ListFirst(FORM.Event_Session2EndTime, ":")#>
				<cfset TimeMinutes = #Left(ListLast(FORM.Event_Session2EndTime, ":"), 2)#>
				<cfset TimeAMPM = #Right(ListLast(FORM.Event_Session2EndTime, ":"), 2)#>
				<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
				<cfset FORM.Event_Session2EndTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
				<cfset Session.FormInput.EventStep2.Event_Session2EndTime = #FORM.Event_Session2EndTime#>
			</cfif>

			<cfset TimeHours = #ListFirst(FORM.Registration_BeginTime, ":")#>
			<cfset TimeMinutes = #Left(ListLast(FORM.Registration_BeginTime, ":"), 2)#>
			<cfset TimeAMPM = #Right(ListLast(FORM.Registration_BeginTime, ":"), 2)#>
			<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
			<cfset FORM.Registration_BeginTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
			<cfset Session.FormInput.EventStep2.Registration_BeginTime = #FORM.Registration_BeginTime#>

			<cfset TimeHours = #ListFirst(FORM.Event_StartTime, ":")#>
			<cfset TimeMinutes = #Left(ListLast(FORM.Event_StartTime, ":"), 2)#>
			<cfset TimeAMPM = #Right(ListLast(FORM.Event_StartTime, ":"), 2)#>
			<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
			<cfset FORM.Event_StartTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
			<cfset Session.FormInput.EventStep2.Event_StartTime = #FORM.Event_StartTime#>

			<cfset TimeHours = #ListFirst(FORM.Event_EndTime, ":")#>
			<cfset TimeMinutes = #Left(ListLast(FORM.Event_EndTime, ":"), 2)#>
			<cfset TimeAMPM = #Right(ListLast(FORM.Event_EndTime, ":"), 2)#>
			<cfif Variables.TimeAMPM EQ "pm"><cfset TimeHours = Variables.TimeHours + 12></cfif>
			<cfset FORM.Event_EndTime = #CreateTime(Variables.TimeHours, Variables.TimeMinutes, 0)#>
			<cfset Session.FormInput.EventStep2.Event_EndTime = #FORM.Event_EndTime#>

			<cfset EventDate = #CreateDate(ListLast(Session.FormInput.EventStep2.EventDate, '/'), ListFirst(Session.FormInput.EventStep2.EventDate, '/'), ListGetAt(Session.FormInput.EventStep2.EventDate, 2, '/'))#>
			<cfset FORM.EventDate = #Variables.EventDate#>
			<cfset Session.FormInput.EventStep2.EventDate = #Variables.EventDate#>

			<cfset Registration_Deadline = #CreateDate(ListLast(Session.FormInput.EventStep2.Registration_Deadline, '/'), ListFirst(Session.FormInput.EventStep2.Registration_Deadline, '/'), ListGetAt(Session.FormInput.EventStep2.Registration_Deadline, 2, '/'))#>
			<cfset FORM.Registration_Deadline = #Variables.Registration_Deadline#>
			<cfset Session.FormInput.EventStep2.Registration_Deadline = #Variables.Registration_Deadline#>

			<cftry>
				<cfquery name="insertNewEvent" result="InsertNewRecord" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Update p_EventRegistration_Events
					Set EventDate = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.FormInput.EventStep2.EventDate#">,
						Registration_Deadline = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.FormInput.EventStep2.Registration_Deadline#">,
						Registration_BeginTime = <cfqueryparam cfsqltype="cf_sql_time" value="#Session.FormInput.EventStep2.Registration_BeginTime#">,
						Registration_EndTime = <cfqueryparam cfsqltype="cf_sql_time" value="#Session.FormInput.EventStep2.Event_StartTime#">,
						Event_StartTime = <cfqueryparam cfsqltype="cf_sql_time" value="#Session.FormInput.EventStep2.Event_StartTime#">,
						Event_EndTime = <cfqueryparam cfsqltype="cf_sql_time" value="#Session.FormInput.EventStep2.Event_EndTime#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">
				</cfquery>

				<cfif Session.FormInput.EventStep1.Event_DailySessions CONTAINS 1>
					<cfquery name="insertNewEvent" result="InsertNewRecord" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set Event_DailySessions = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
							Event_Session1BeginTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession1_StartTime#" cfsqltype="cf_sql_time">,
							Event_Session1EndTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession1_EndTime#" cfsqltype="cf_sql_time">,
							Event_Session2BeginTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession2_StartTime#" cfsqltype="cf_sql_time">,
							Event_Session2EndTime = <cfqueryparam value="#Session.FormInput.EventStep2.EventSession2_EndTime#" cfsqltype="cf_sql_time">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">
					</cfquery>
				</cfif>

				<cfif Session.FormInput.EventStep1.Event_HasMultipleDates CONTAINS 1>
					<cfquery name="insertNewEvent" result="InsertNewRecord" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Update p_EventRegistration_Events
						Set Event_HasMultipleDates = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
							<cfif Session.FormInput.EventStep2.EventPricePerDay CONTAINS 1>EventPricePerDay = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,</cfif>
							<cfif LEN(FORM.EventDate1)>EventDate1 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.FormInput.EventStep2.EventDate1#">,</cfif>
							<cfif LEN(FORM.EventDate2)>EventDate2 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.FormInput.EventStep2.EventDate2#">,</cfif>
							<cfif LEN(FORM.EventDate3)>EventDate3 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.FormInput.EventStep2.EventDate3#">,</cfif>
							<cfif LEN(FORM.EventDate4)>EventDate4 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.FormInput.EventStep2.EventDate4#">,</cfif>
							<cfif LEN(FORM.EventDate5)>EventDate5 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.FormInput.EventStep2.EventDate5#">,</cfif>
							<cfif LEN(FORM.EventDate6)>EventDate6 = <cfqueryparam cfsqltype="cf_sql_date" value="#Session.FormInput.EventStep2.EventDate6#">,</cfif>
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.EventID#">
					</cfquery>
				</cfif>

				<cfcatch type="any">

				</cfcatch>
			</cftry>		
			<cfset temp = StructDelete(Session, "FormErrors")>
			<cfset temp = StructDelete(Session, "FormInput")>
			
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventDates&EventID=#URL.EventID#&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.updateevent&UserAction=EventDates&EventID=#URL.EventID#&Successful=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfcase>
	</cfswitch>
</cfif>