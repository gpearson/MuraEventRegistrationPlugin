<cfif not isDefined("URL.EventID") and not isDefined("URL.RegistrationID") and Session.Mura.IsLoggedIn EQ "False">
	<cflocation addtoken="true" url="?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.viewavailableevents">
<cfelseif not isDefined("URL.EventID") and not isDefined("URL.RegistrationID") and Session.Mura.IsLoggedIn EQ "True">
	<cflocation addtoken="true" url="?#HTMLEditFormat(rc.pc.getPackage())#action=public:usermenu.default">
<cfelseif isDefined("URL.EventID") and isDefined("URL.RegistrationID") and Session.Mura.IsLoggedIn EQ "True">
	<cfquery name="GetRegisteredEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
		SELECT eEvents.ShortTitle, eEvents.EventDate, eRegistrations.AttendedEvent, eRegistrations.RegistrationID,  eRegistrations.OnWaitingList, eRegistrations.EventID, eEvents.PGPAvailable, eEvents.PGPPoints
		FROM eRegistrations INNER JOIN eEvents ON eEvents.TContent_ID = eRegistrations.EventID
		WHERE eRegistrations.RegistrationID = <cfqueryparam value="#URL.RegistrationID#" cfsqltype="cf_sql_varchar"> AND eRegistrations.EventID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
		ORDER BY eRegistrations.RegistrationDate DESC
	</cfquery>
	<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
	<cfif not isDefined("URL.CancelEventConfirmation") and not isDefined("URL.FormRetry")>
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfoutput>
			<h2>Cancel Registration</h2>
			<hr>
			<uForm:form action="" method="Post" id="CancelEvent" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/properties/uniForm/"
				showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:main.viewavailableevents&Return=True"
				submitValue="Cancel Event" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="RegistrationID" value="#URL.RegistrationID#">
				<input type="hidden" name="EventID" value="#URL.EventID#">
				<uForm:fieldset legend="Event Information">
					<uForm:field label="Event Title" name="ShortTitle" isRequired="False" isDisabled="True" value="#GetRegisteredEvent.ShortTitle#" maxFieldLength="50" type="text" hint="Title of the Event" />
					<uForm:field label="Event Datae" name="EventDate" isRequired="False" isDisabled="True"  value="#DateFormat(GetRegisteredEvent.EventDate, 'Full')#" maxFieldLength="50" type="text" hint="Date of the Event" />
					<uForm:field label="Really Cancel Event" name="CancelEventOption" type="select" isRequired="true" hint="Would you really like to cancel this registration?">
						<uform:option display="Yes, Cancel Registration" value="Yes" isSelected="true" />
						<uform:option display="No" value="No" />
					</uForm:field>
				</uForm:fieldset>
				<uForm:fieldset legend="Captcha Code">
					<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
				</uForm:fieldset>
			</uForm:form>
		</cfoutput>
	<cfelseif isDefined("URL.FormRetry")>
		<cfoutput>
			<h2>Cancel Registration</h2>
			<hr>
			<uForm:form action="" method="Post" id="CancelEvent" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/properties/uniForm/"
				showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/plugins/EventRegistration/index.cfm?EventRegistrationaction=public:main.viewavailableevents&Return=True"
				submitValue="Cancel Event" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
				<input type="hidden" name="formSubmit" value="true">
				<input type="hidden" name="RegistrationID" value="#URL.RegistrationID#">
				<input type="hidden" name="EventID" value="#URL.EventID#">
				<uForm:fieldset legend="Event Information">
					<uForm:field label="Event Title" name="ShortTitle" isRequired="False" isDisabled="True" value="#GetRegisteredEvent.ShortTitle#" maxFieldLength="50" type="text" hint="Title of the Event" />
					<uForm:field label="Event Datae" name="EventDate" isRequired="False" isDisabled="True"  value="#DateFormat(GetRegisteredEvent.EventDate, 'Full')#" maxFieldLength="50" type="text" hint="Date of the Event" />
					<uForm:field label="Really Cancel Event" name="CancelEventOption" type="select" isRequired="true" hint="Would you really like to cancel this registration?">
						<cfif isDefined("Session.FormData.CancelEventOption")>
							<cfswitch expression="#Session.FormData.CancelEventOption#">
								<cfcase value="No">
									<uform:option display="No" value="No"  isSelected="true" />
									<uform:option display="Yes, Cancel Registration" value="Yes" />
								</cfcase>
								<cfcase value="Yes">
									<uform:option display="Yes, Cancel Registration" value="Yes" isSelected="true" />
									<uform:option display="No" value="No" />
								</cfcase>
							</cfswitch>
						</cfif>
					</uForm:field>
				</uForm:fieldset>
				<uForm:fieldset legend="Captcha Code">
					<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
				</uForm:fieldset>
			</uForm:form>
		</cfoutput>
	</cfif>
</cfif>