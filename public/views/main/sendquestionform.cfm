<cfif not isDefined("URL.EventID")><cflocation addtoken="true" url="/index.cfm"></cfif>

<cfif not isDefined("Session.FormData")>
	<cflock scope="Session" timeout="60" type="Exclusive">
		<cfset Session.FormErrors = #ArrayNew()#>
		<cfset Session.FormData = #StructNew()#>
	</cflock>
</cfif>

<cfquery name="getSelectedEvent" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select ShortTitle, Presenters, Facilitator
	From eEvents
	Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
		TContent_ID = <cfqueryparam value="#URL.EventID#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="getFacilitator" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
	Select FName, Lname, Email
	From tusers
	Where UserID = <cfqueryparam value="#getSelectedEvent.Facilitator#" cfsqltype="cf_sql_varchar">
</cfquery>

<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cfoutput>
	<p class="alert-box notice" style="font-family: arial; font-size: 14px; font-weight: bold;">Do you have questions regarding #getSelectedEvent.ShortTitle#? Complete this form to send us an email about this event which you would like answered.</p>
	<uForm:form action="" method="Post" id="EventInqiryForm" errors="#Session.FormErrors#" errorMessagePlacement="both"
		commonassetsPath="/properties/uniForm/" showCancel="yes" cancelValue="<--- Return to Menu" cancelName="cancelButton"
		cancelAction="?#HTMLEditFormat(rc.pc.getPackage())#action=public:main.eventinfo&EventID=#URL.EventID#"
		submitValue="Send Email" loadValidation="true" loadMaskUI="true" loadDateUI="false" loadTimeUI="false">
		<input type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
		<input type="hidden" name="EventID" value="#URL.EventID#">
		<input type="hidden" name="FacilitatorID" value="#getSelectedEvent.Facilitator#">
		<input type="hidden" name="formSubmit" value="true">
		<uForm:fieldset legend="Your Contact Information">
			<cfif isDefined("Session.FormData.Fname")>
				<cfif LEN(Session.FormData.Fname)>
					<uForm:field label="First Name" name="Fname" isRequired="true" value="#Session.FormData.Fname#" maxFieldLength="35" type="text" hint="Your First Name" />
				<cfelse>
					<uForm:field label="First Name" name="Fname" isRequired="true" maxFieldLength="35" type="text" hint="Your First Name" />
				</cfif>
			<cfelse>
				<uForm:field label="First Name" name="Fname" isRequired="true" maxFieldLength="35" type="text" hint="Your First Name" />
			</cfif>

			<cfif isDefined("Session.FormData.Lname")>
				<cfif LEN(Session.FormData.Lname)>
					<uForm:field label="Last Name" name="Lname" isRequired="true" value="#Session.FormData.Lname#" maxFieldLength="70" type="text" hint="Your Last Name" />
				<cfelse>
					<uForm:field label="Last Name" name="Lname" isRequired="true" maxFieldLength="70" type="text" hint="Your Last Name" />
				</cfif>
			<cfelse>
				<uForm:field label="Last Name" name="Lname" isRequired="true" maxFieldLength="70" type="text" hint="Your Last Name" />
			</cfif>

			<cfif isDefined("Session.FormData.EmailAddr")>
				<cfif LEN(Session.FormData.EmailAddr)>
					<uForm:field label="Email Address" name="EmailAddr" value="#Session.FormData.EmailAddr#" maxFieldLength="70" type="text" hint="Your Email Address" />
				<cfelse>
					<uForm:field label="Email Address" name="EmailAddr" maxFieldLength="70" type="text" hint="Your Email Address" />
				</cfif>
			<cfelse>
				<uForm:field label="Email Address" name="EmailAddr" maxFieldLength="70" type="text" hint="Your Email Address" />
			</cfif>

			<cfif isDefined("Session.FormData.ContactNumber")>
				<cfif LEN(Session.FormData.ContactNumber)>
					<uForm:field label="Contact Phone Number" name="ContactNumber" value="#Session.FormData.ContactNumber#" isRequired="false" maxFieldLength="70" mask="(999) 999-9999" type="text" hint="Your Contact Phone Number" />
				<cfelse>
					<uForm:field label="Contact Phone Number" name="ContactNumber" isRequired="false" maxFieldLength="70" mask="(999) 999-9999" type="text" hint="Your Contact Phone Number" />
				</cfif>
			<cfelse>
				<uForm:field label="Contact Phone Number" name="ContactNumber" isRequired="false" maxFieldLength="70" mask="(999) 999-9999" type="text" hint="Your Contact Phone Number" />
			</cfif>
		</uForm:fieldset>
		<uForm:fieldset legend="Best Contact Method">
			<uForm:field label="Contact Me via" name="ContactBy" type="select" isRequired="true" hint="How would you like to receive a response to your inquiry?">
				<cfif isDefined("Session.FormData.ContactBy")>
					<cfswitch expression="#Session.FormData.ContactBy#">
						<cfcase value="Email">
							<uform:option display="Email" value="Reply By Email" isSelected="true" />
							<uform:option display="Phone" value="Reply By Telephone" />
						</cfcase>
						<cfcase value="Phone">
							<uform:option display="Email" value="Reply By Email" />
							<uform:option display="Phone" value="Reply By Telephone" isSelected="true" />
						</cfcase>
						<cfdefaultcase>
							<uform:option display="Email" value="Reply By Email" isSelected="true" />
							<uform:option display="Phone" value="Reply By Telephone" />
						</cfdefaultcase>
					</cfswitch>
				<cfelse>
					<uform:option display="Email" value="Reply By Email" isSelected="true" />
					<uform:option display="Phone" value="Reply By Telephone" />
				</cfif>
			</uForm:field>
		</uForm:fieldset>
		<uForm:fieldset legend="Question Regarding #getSelectedEvent.ShortTitle#">
			<cfif isDefined("Session.FormData.EventQuestion")>
				<cfif LEN(Session.FormData.EventQuestion)>
					<uform:field label="Event Inquiry" name="EventQuestion" isRequired="true" value="#Session.FormData.EventQuestion#" type="textarea" hint="Your Question about this event?" />
				<cfelse>
					<uform:field label="Event Inquiry" name="EventQuestion" isRequired="true" type="textarea" hint="Your Question about this event?" />
				</cfif>
			<cfelse>
				<uform:field label="Event Inquiry" name="EventQuestion" isRequired="true" type="textarea" hint="Your Question about this event?" />
			</cfif>
			<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
		</uForm:fieldset>
	</uForm:form>
</cfoutput>