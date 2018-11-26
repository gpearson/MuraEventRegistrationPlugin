<cfif not isDefined("URL.FormRetry")>
	<cfoutput>
		<cfscript>
			lang = 'en';
		</cfscript>
		<script src='https://www.google.com/recaptcha/api.js?h1=#lang#'></script>
		<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="InActive" value="1">
			<cfinput type="hidden" name="formSubmit" value="true">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<legend>Register New User Account</legend>
					</fieldset>
					<div class="well">Please complete the following information to register for a user account on this event registration system. All electric communications from this system will be sent to the email address you provide. Any certificates that will be generated upon successfull completion of an event that issues certificates will use the information on this screen. Please make sure the information listed below is correct.</div>
					<fieldset>
						<legend>Your Information</legend>
					</fieldset>
					<div class="form-group">
						<label for="YourFirstName" class="control-label col-sm-3">First Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="fName" name="fName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourLastName" class="control-label col-sm-3">Last Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="lName" name="lName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourEmail" class="control-label col-sm-3">School/Business Email:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="UserName" name="UserName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourDesiredPassword" class="control-label col-sm-3">Desired Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="Password" name="Password" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="VerifyDesiredPassword" class="control-label col-sm-3">Verify Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="ContactNumber" class="control-label col-sm-3">Phone Number:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" required="no"><div class="alert alert-warning small" role="alert"><em>This phone number will be used if an event needs to be cancelled or postponed</em></div></div>
					</div>
					<div class="form-group">
						<label for="GradeLevel" class="control-label col-sm-3">Teaching Grade Level:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeLevel" class="form-control" Required="No" Multiple="No" query="Session.getGradeLevels" value="TContent_ID" Display="GradeLevel"  queryposition="below"><option value="----">Select Grade Level you Teach</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="GradeSubjects" class="control-label col-sm-3">Teaching Subject:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeSubjects" class="form-control" Required="No" Multiple="No" query="Session.getGradeSubjects" value="TContent_ID" Display="GradeSubject"  queryposition="below"><option value="----">Select Subject you Teach</option></cfselect></div>
					</div>
					<fieldset>
						<legend>Account Security</legend>
					</fieldset>
					<div class="form-group">
						<div class="col-sm-6"><div class="g-recaptcha" data-sitekey="6Le6hw0UAAAAAHty8-RZLBzpnHjc348j7U0nrxdh"></div></div>
						<!---
						<label for="HumanChecker" class="control-label col-sm-3">In order to prevent abuse from automatic systems, please type the letters or numbers in the box below:&nbsp;</label>
						<div class="col-sm-6">
							<cfimage action="captcha" difficulty="medium" text="#captcha#" fonts="arial,times roman, tahoma" height="150" width="500" /><br><br />
							<cfinput name="ValidateCaptcha" type="text" required="yes" message="Input Captcha Text" />
						</div>
						--->
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
		<cfscript>
			lang = 'en';
		</cfscript>
		<script src='https://www.google.com/recaptcha/api.js?h1=#lang#'></script>
		<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="InActive" value="1">
			<cfinput type="hidden" name="formSubmit" value="true">
			<div class="panel panel-default">
				<div class="panel-body">
					<fieldset>
						<legend>Register New User Account</legend>
					</fieldset>
					<cfif isDefined("Session.FormErrors")>
						<div class="panel-body">
							<cfif ArrayLen(Session.FormErrors) GTE 1>
								<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
							</cfif>
						</div>
						<br />
					</cfif>
					<div class="well">Please complete the following information to register for a user account on this event registration system. All electric communications from this system will be sent to the email address you provide. Any certificates that will be generated upon successfull completion of an event that issues certificates will use the information on this screen. Please make sure the information listed below is correct.</div>
					<fieldset>
						<legend>Your Information</legend>
					</fieldset>
					<div class="form-group">
						<label for="YourFirstName" class="control-label col-sm-3">First Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" value="#Session.FormData.fName#" id="fName" name="fName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourLastName" class="control-label col-sm-3">Last Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" value="#Session.FormData.lName#" id="lName" name="lName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourEmail" class="control-label col-sm-3">Email Address:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" value="#Session.FormData.UserName#" id="UserName" name="UserName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="YourDesiredPassword" class="control-label col-sm-3">Desired Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" value="#Session.FormData.Password#" id="Password" name="Password" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="VerifyDesiredPassword" class="control-label col-sm-3">Verify Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" value="#Session.FormData.VerifyPassword#" id="VerifyPassword" name="VerifyPassword" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="ContactNumber" class="control-label col-sm-3">Phone Number:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="mobilePhone" value="#Session.FormData.mobilePhone#" name="mobilePhone" required="no"><div class="alert alert-warning small" role="alert"><em>This phone number will be used if an event needs to be cancelled or postponed</em></div></div>
					</div>
					<div class="form-group">
						<label for="GradeLevel" class="control-label col-sm-3">Teaching Grade Level:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeLevel" class="form-control" Required="No" selected="#Session.FormData.GradeLevel#" Multiple="No" query="Session.getGradeLevels" value="TContent_ID" Display="GradeLevel"  queryposition="below"><option value="----">Select Grade Level you Teach</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="GradeSubjects" class="control-label col-sm-3">Teaching Subject:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeSubjects" class="form-control" Required="No" selected="#Session.FormData.GradeSubjects#" Multiple="No" query="Session.getGradeSubjects" value="TContent_ID" Display="GradeSubject"  queryposition="below"><option value="----">Select Subject you Teach</option></cfselect></div>
					</div>
					<fieldset>
						<legend>Account Security</legend>
					</fieldset>
					<div class="form-group">
						<div class="col-sm-6"><div class="g-recaptcha" data-sitekey="6Le6hw0UAAAAAHty8-RZLBzpnHjc348j7U0nrxdh"></div></div>
						<!---
						<label for="HumanChecker" class="control-label col-sm-3">In order to prevent abuse from automatic systems, please type the letters or numbers in the box below:&nbsp;</label>
						<div class="col-sm-6">
							<cfimage action="captcha" difficulty="medium" text="#captcha#" fonts="arial,times roman, tahoma" height="150" width="500" /><br><br />
							<cfinput name="ValidateCaptcha" type="text" required="yes" message="Input Captcha Text" />
						</div>
						--->
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="RegisterAccount" class="btn btn-primary pull-right" value="Register Account"><br /><br />
				</div>
			</div>
		</cfform>
	</cfoutput>
</cfif>