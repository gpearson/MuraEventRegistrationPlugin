<cfimport taglib="/plugins/EventRegistration/library/uniForm/tags/" prefix="uForm">
<cfif not isDefined("Session.FormData")>
	<cflock scope="Session" timeout="60" type="Exclusive">
		<cfset Session.FormData = #StructNew()#>
	</cflock>
</cfif>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<cfset Session.FormErrors = #ArrayNew()#>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Contact Us</h3>
			</div>
			<div class="art-blockcontent"><div class="alert-box notice">Please complete the following information to send us feedback regarding your comments about this website.</div>
				<uForm:form action="" method="Post" id="RegisterEvent" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/plugins/EventRegistration/library/uniForm/"
					showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm?EventRegistrationaction=public:events.viewavailableevents&Return=True"
					submitValue="Send Comments" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true"
					class="form-horizontal">
					<input type="hidden" name="formSubmit" value="true">
					<uForm:fieldset legend="Required Fields">
						<cfif Session.Mura.IsLoggedIn EQ "True">
							<uForm:field label="Your Name" name="CommentFormName" isRequired="True" isDisabled="False" value="#Session.Mura.FName# #Session.Mura.LName#" maxFieldLength="50" type="text" hint="Your Name" />
						<cfelse>
							<uForm:field label="Your Name" name="CommentFormName" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="Your Name"  />
						</cfif>
						<cfif Session.Mura.IsLoggedIn EQ "True">
							<uForm:field label="Your Email Address" name="ContactFormEmail" isRequired="True" isDisabled="False" value="#Session.Mura.EMail#" maxFieldLength="50" type="text" hint="Your Email Address" />
						<cfelse>
							<uForm:field label="Your Email Address" name="ContactFormEmail" isRequired="True" isDisabled="False"  maxFieldLength="50" type="text" hint="Your Email Address" />
						</cfif>
						<uForm:field label="Your Contact Number" name="ContactFormNumber" isRequired="True" isDisabled="False"  maxFieldLength="50" mask="(999) 999-9999" type="text" hint="Your Contact Phone Number" />
					</uForm:fieldset>
					<uForm:fieldset legend="Best Contact Method">
						<uForm:field label="Contact Me via" name="ContactBy" type="select" isRequired="true">
							<uform:option display="Email" value="Reply By Email" isSelected="true" />
							<uform:option display="Phone" value="Reply By Telephone" />
						</uForm:field>
					</uForm:fieldset>
					<uForm:fieldset legend="Your Comments">
						<uform:field label="Event Inquiry" name="EventQuestion" isRequired="true" type="textarea" />
						<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
					</uForm:fieldset>
				</uForm:form>
			</div>
		</div>
	<cfelse>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Contact Us</h3>
			</div>
			<div class="art-blockcontent"><div class="alert-box notice">Please complete the following information to send us feedback regarding your comments about this website.</div>
				<uForm:form action="" method="Post" id="RegisterEvent" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/plugins/EventRegistration/library/uniForm/"
					showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm?EventRegistrationaction=public:events.viewavailableevents&Return=True"
					submitValue="Send Comments" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
					<input type="hidden" name="formSubmit" value="true">
					<uForm:fieldset legend="Required Fields">
						<cfif isDefined("Session.FormData.CommentFormName")>
							<uForm:field label="Your Name" name="CommentFormName" isRequired="True" isDisabled="False" value="#Session.FormData.CommentFormName#" maxFieldLength="50" type="text" hint="Your Name" />
						<cfelse>
							<uForm:field label="Your Name" name="CommentFormName" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="Your Name" />
						</cfif>
						<cfif isDefined("Session.FormData.ContactFormEmail")>
							<uForm:field label="Your Email Address" name="ContactFormEmail" isRequired="True" isDisabled="False" value="#Session.FormData.ContactFormEmail#"  maxFieldLength="50" type="text" hint="Your Email Address" />
						<cfelse>
							<uForm:field label="Your Email Address" name="ContactFormEmail" isRequired="True" isDisabled="False"  maxFieldLength="50" type="text" hint="Your Email Address" />
						</cfif>
						<cfif isDefined("Session.FormData.ContactFormNumber")>
							<uForm:field label="Your Contact Number" name="ContactFormNumber" isRequired="True" isDisabled="False" value="#Session.FormData.ContactFormNumber#"  maxFieldLength="50" mask="(999) 999-9999" type="text" hint="Your Contact Phone Number" />
						<cfelse>
							<uForm:field label="Your Contact Number" name="ContactFormNumber" isRequired="True" isDisabled="False"  maxFieldLength="50" mask="(999) 999-9999" type="text" hint="Your Contact Phone Number" />
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
					<uForm:fieldset legend="Your Comments">
						<cfif isDefined("Session.FormData.EventQuestion")>
							<cfif LEN(Session.FormData.EventQuestion)>
								<uform:field label="Event Inquiry" name="EventQuestion" isRequired="true" value="#Session.FormData.EventQuestion#" type="textarea" hint="Your Comment?" />
							<cfelse>
								<uform:field label="Event Inquiry" name="EventQuestion" isRequired="true" type="textarea" hint="Your Comment?" />
							</cfif>
						<cfelse>
							<uform:field label="Event Inquiry" name="EventQuestion" isRequired="true" type="textarea" hint="Your Comment?" />
						</cfif>
						<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
					</uForm:fieldset>
				</uForm:form>
			</div>
		</div>
	</cfif>
</cfoutput>