<!--- Variables.Framework.Package --->
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
				<h3 class="t">Request New Event or Workshop</h3>
			</div>
			<div class="art-blockcontent"><div class="alert-box notice">Please complete the following information regarding your request for an event or workshop that you would like us to have. We will contact you with any additional information that might be needed from you. Please be detailed as possible to make sure we bring you the event you would like to attend.</div>
				<hr>
				<uForm:form action="" method="Post" id="RegisterEvent" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/plugins/EventRegistration/library/uniForm/"
					showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm?EventRegistrationaction=public:events.viewavailableevents&Return=True"
					submitValue="Send Event Request" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
					<input type="hidden" name="formSubmit" value="true">
					<uForm:fieldset legend="Required Fields">
						<cfif Session.Mura.IsLoggedIn EQ "True">
							<uForm:field label="Your Name" name="CommentFormName" isRequired="True" isDisabled="False" value="#Session.Mura.FName# #Session.Mura.LName#" maxFieldLength="50" type="text" hint="Your Name" />
						<cfelse>
							<uForm:field label="Your Name" name="CommentFormName" isRequired="True" isDisabled="False" maxFieldLength="50" type="text" hint="Your Name" />
						</cfif>
						<cfif Session.Mura.IsLoggedIn EQ "True">
							<uForm:field label="Your Email Address" name="ContactFormEmail" isRequired="True" isDisabled="False" value="#Session.Mura.EMail#" maxFieldLength="50" type="text" hint="Your Email Address" />
						<cfelse>
							<uForm:field label="Your Email Address" name="ContactFormEmail" isRequired="True" isDisabled="False"  maxFieldLength="50" type="text" hint="Your Email Address" />
						</cfif>
						<uForm:field label="Your Contact Number" name="ContactFormNumber" isRequired="True" isDisabled="False"  maxFieldLength="50" mask="(999) 999-9999" type="text" hint="Your Contact Phone Number" />
					</uForm:fieldset>
					<uForm:fieldset legend="Best Contact Method">
						<uForm:field label="Contact Me via" name="ContactBy" type="select" isRequired="true" hint="How would you like to receive a response to your inquiry?">
							<uform:option display="Email" value="Reply By Email" isSelected="true" />
							<uform:option display="Phone" value="Reply By Telephone" />
						</uForm:field>
					</uForm:fieldset>
					<uForm:fieldset legend="Event Information">
						<uform:field label="Woprkshop Description" name="WorkshopDescription" isRequired="true" type="textarea" hint="Detailed Information about Workshop Request?" />
						<uForm:field label="Possible Workshop Presenter" name="WorkshopPresenter" isRequired="False" isDisabled="False" maxFieldLength="50" type="text" hint="Name of Presenter that can present requested topic (if known)" />
						<uForm:field label="Workshop Presenter Email" name="WorkshopPresenterEmail" isRequired="False" isDisabled="False" maxFieldLength="50" type="text" hint="Email of Presenter that can present requested topic (if known)" />
						<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
					</uForm:fieldset>
				</uForm:form>
			</div>
		</div>
	<cfelse>
		<div class="art-block clearfix">
			<div class="art-blockheader">
				<h3 class="t">Request New Event or Workshop</h3>
			</div>
			<div class="art-blockcontent"><div class="alert-box notice">Please complete the following information regarding your request for an event or workshop that you would like us to have. We will contact you with any additional information that might be needed from you. Please be detailed as possible to make sure we bring you the event you would like to attend.</div>
				<hr>
				<uForm:form action="" method="Post" id="RegisterEvent" errors="#Session.FormErrors#" errorMessagePlacement="both" commonassetsPath="/plugins/EventRegistration/library/uniForm/"
					showCancel="yes" cancelValue="<--- Return to Main Page" cancelName="cancelButton" cancelAction="/index.cfm?EventRegistrationaction=public:events.viewavailableevents&Return=True"
					submitValue="Send Event Request" loadValidation="true" loadMaskUI="true" loadDateUI="true" loadTimeUI="true">
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

					<uForm:fieldset legend="Event Information">
						<cfif isDefined("Session.FormData.WorkshopDescription")>
							<cfif LEN(Session.FormData.WorkshopDescription)>
								<uform:field label="Woprkshop Description" name="WorkshopDescription" isRequired="true" value="#Session.FormData.WorkshopDescription#" type="textarea" hint="Detailed Information about Workshop Request?" />
							<cfelse>
								<uform:field label="Woprkshop Description" name="WorkshopDescription" isRequired="true" type="textarea" hint="Detailed Information about Workshop Request?" />
							</cfif>
						<cfelse>
							<uform:field label="Woprkshop Description" name="WorkshopDescription" isRequired="true" type="textarea" hint="Detailed Information about Workshop Request?" />
						</cfif>

						<cfif isDefined("Session.FormData.WorkshopPresenter")>
							<cfif LEN(Session.FormData.WorkshopPresenter)>
								<uForm:field label="Workshop Presenter" name="WorkshopPresenter" isRequired="false" value="#Session.FormData.WorkshopPresenter#" isDisabled="False" maxFieldLength="50" type="text" hint="Name of Presenter that can present requested topic" />
							<cfelse>
								<uForm:field label="Workshop Presenter" name="WorkshopPresenter" isRequired="false" isDisabled="False" maxFieldLength="50" type="text" hint="Name of Presenter that can present requested topic" />
							</cfif>
						<cfelse>
							<uForm:field label="Workshop Presenter" name="WorkshopPresenter" isRequired="false" isDisabled="False" maxFieldLength="50" type="text" hint="Name of Presenter that can present requested topic" />
						</cfif>

						<cfif isDefined("Session.FormData.WorkshopPresenterEmail")>
							<cfif LEN(Session.FormData.WorkshopPresenterEmail)>
								<uForm:field label="Workshop Presenter Email" name="WorkshopPresenterEmail" isRequired="false" value="#Session.FormData.WorkshopPresenterEmail#" isDisabled="False" maxFieldLength="50" type="text" hint="Email of Presenter that can present requested topic" />
							<cfelse>
								<uForm:field label="Workshop Presenter Email" name="WorkshopPresenterEmail" isRequired="false" isDisabled="False" maxFieldLength="50" type="text" hint="Email of Presenter that can present requested topic" />
							</cfif>
						<cfelse>
							<uForm:field label="Workshop Presenter Email" name="WorkshopPresenterEmail" isRequired="false" isDisabled="False" maxFieldLength="50" type="text" hint="Email of Presenter that can present requested topic" />
						</cfif>
						<uform:field name="HumanChecker" isRequired="true" label="Please enter the characters you see below" type="captcha" captchaWidth="800" captchaMinChars="5" captchaMaxChars="8" />
					</uForm:fieldset>
				</uForm:form>
			</div>
		</div>
	</cfif>
</cfoutput>