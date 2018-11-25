<cfif not isDefined("URL.FormRetry")>
	<cfoutput>
		<cfset captcha = #Session.Captcha#>
		<cfset captchaHash = Hash(captcha)>
		<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="CaptchaEncrypted" value="#Variables.CaptchaHash#">
			<cfinput type="hidden" name="InActive" value="1">
			<cfinput type="hidden" name="HumanValidation" value="#Variables.Captcha#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<div class="panel panel-default">
				<div class="panel-heading"><h1>Register New User Account</h1></div>
				<div class="panel-body">
					<div class="well">Please complete the following information to register for a user account on this event registration system. All electric communications from this system will be sent to the email address you provide. Any certificates that will be generated upon successfull completion of an event that issues certificates will use the information on this screen. Please make sure the information listed below is correct.</div>
					<div class="panel-heading"><h2>Your Information</h2></div>
					<div class="form-group">
						<label for="YourFirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="fName" name="fName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourLastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="lName" name="lName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourEmail" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="UserName" name="UserName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourDesiredPassword" class="control-label col-sm-3">Desired Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="Password" name="Password" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="VerifyDesiredPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" required="yes"></div>
					</div>
					<div class="panel-heading"><h2>Optional Information</h2></div>
					<div class="form-group">
						<label for="SchoolDistrict" class="control-label col-sm-3">School District:&nbsp;</label>
						<div class="col-sm-6">
							<cfselect name="Company" class="form-control" Required="Yes" Multiple="No" query="Session.getSchoolDistricts" value="StateDOE_IDNumber" Display="OrganizationName"  queryposition="below">
								<option value="0000">Corporate Business</option>
								<option value="0001">School District Not Listed</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<div class="alert alert-warning" role="alert">Enter a phone number that you will answer in the event that an event or workshop will be registered for that you will be able to receive emergency information about the event or workshop like it is cancelled due to mother nature.</div>
						<label for="ContactNumber" class="control-label col-sm-3">Phone Number:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" required="no"></div>
					</div>
					<div class="panel-heading"><h2>Human Checker</h2></div>
					<div class="form-group">
						<label for="HumanChecker" class="control-label col-sm-3">Enter Text:&nbsp;</label>
						<div class="col-sm-6">
							<cfimage action="captcha" difficulty="medium" text="#captcha#" fonts="arial,times roman, tahoma" height="150" width="500" /><br>
							<cfinput name="ValidateCaptcha" type="text" required="yes" message="Input Captcha Text" />
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="RegisterAccount" class="btn btn-primary pull-right" value="Register Account"><br /><br />
				</div>
			</div>
		</cfform>
	</cfoutput>
<cfelseif isDefined("URL.FormRetry")>
	<cfoutput>
		<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="CaptchaEncrypted" value="#Session.FormData.CaptchaEncrypted#">
			<cfinput type="hidden" name="HumanValidation" value="#Session.FormData.HumanValidation#">
			<cfinput type="hidden" name="InActive" value="1">
			<cfinput type="hidden" name="formSubmit" value="true">
			<div class="panel panel-default">
				<div class="panel-heading"><h1>Register New User Account</h1></div>
				<div class="panel-body">
					<cfif isDefined("Session.FormErrors")>
						<div class="panel-body">
							<cfif ArrayLen(Session.FormErrors) GTE 1>
								<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
							</cfif>
						</div>
						<br />
					</cfif>
					<div class="well">Please complete the following information to register for a user account on this event registration system. All electric communications from this system will be sent to the email address you provide. Any certificates that will be generated upon successfull completion of an event that issues certificates will use the information on this screen. Please make sure the information listed below is correct.</div>
					<div class="panel-heading"><h2>Your Information</h2></div>
					<div class="form-group">
						<label for="YourFirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" value="#Session.FormData.fName#" id="fName" name="fName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourLastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" value="#Session.FormData.lName#" id="lName" name="lName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourEmail" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" value="#Session.FormData.UserName#" id="UserName" name="UserName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourDesiredPassword" class="control-label col-sm-3">Desired Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" value="#Session.FormData.Password#" id="Password" name="Password" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="VerifyDesiredPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" value="#Session.FormData.VerifyPassword#" id="VerifyPassword" name="VerifyPassword" required="yes"></div>
					</div>
					<div class="panel-heading"><h2>Optional Information</h2></div>
					<div class="form-group">
						<label for="SchoolDistrict" class="control-label col-sm-3">School District:&nbsp;</label>
						<div class="col-sm-6">
							<cfselect name="Company" class="form-control" Required="Yes" Multiple="No" selected="#Session.FormData.Company#" query="Session.getSchoolDistricts" value="StateDOE_IDNumber" Display="OrganizationName"  queryposition="below">
								<option value="0000">Corporate Business</option>
								<option value="0001">School District Not Listed</option>
							</cfselect>
						</div>
					</div>
					<div class="form-group">
						<div class="alert alert-warning" role="alert">Enter a phone number that you will answer in the event that an event or workshop will be registered for that you will be able to receive emergency information about the event or workshop like it is cancelled due to mother nature.</div>
						<label for="ContactNumber" class="control-label col-sm-3">Phone Number:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" value="#Session.FormData.mobilePhone#" id="mobilePhone" name="mobilePhone" required="no"></div>
					</div>
					<div class="panel-heading"><h2>Human Checker</h2></div>
					<div class="form-group">
						<label for="HumanChecker" class="control-label col-sm-3">Enter Text:&nbsp;</label>
						<div class="col-sm-6">
							<cfimage action="captcha" difficulty="medium" text="#Session.FormData.HumanValidation#" fonts="arial,times roman, tahoma" height="150" width="500" /><br>
							<cfinput name="ValidateCaptcha" type="text" required="yes" message="Input Captcha Text" />
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="RegisterAccount" class="btn btn-primary pull-right" value="Register Account"><br /><br />
				</div>
			</div>
		</cfform>
	</cfoutput>
</cfif>