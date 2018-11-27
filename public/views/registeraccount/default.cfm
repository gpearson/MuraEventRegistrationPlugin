<cfsilent>
	<cfset BestContactMethodQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
	<cfset temp = QueryAddRow(BestContactMethodQuery, 1)>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "ID", 0)#>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "OptionName", "By Email")#>
	<cfset temp = QueryAddRow(BestContactMethodQuery, 1)>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "ID", 1)#>
	<cfset temp = #QuerySetCell(BestContactMethodQuery, "OptionName", "By Telephone")#>
	<cfif not isDefined("Session.PluginFramework")>
		<cflock timeout="60" scope="Session" type="Exclusive">
			<cfset Session.PluginFramework = StructCopy(Variables.Framework)>
		</cflock>
	</cfif>
</cfsilent>
<cfoutput>
	<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
		<cfscript>lang = 'en';</cfscript>
		<cfsavecontent variable="htmlhead"><cfoutput><script src='https://www.google.com/recaptcha/api.js?h1=#lang#'></script></cfoutput></cfsavecontent>
		<cfhtmlhead text="#htmlhead#" />
	</cfif>
	<cfform action="" method="post" id="RegisterAccountForm" class="form-horizontal">
		<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
		<cfinput type="hidden" name="InActive" value="1">
		<cfinput type="hidden" name="formSubmit" value="true">
		<div class="panel panel-default">
			<cfif not isDefined("URL.FormRetry")>
				<div class="panel-body">
					<fieldset>
						<legend>Register New User Account</legend>
					</fieldset>
					<div class="well">Please complete the following information to register for a user account on this event registration system. All electric communications from this system will be sent to the email address you provide. Any certificates that will be generated upon successfull completion of an event that issues certificates will use the information on this screen. Please make sure the information listed below is correct.</div>
					<fieldset>
						<legend>Your Information</legend>
					</fieldset>
					<div class="form-group">
						<label for="fName" class="control-label col-sm-4">First Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="fName" name="fName" required="no"></div>
					</div>
					<div class="form-group">
						<label for="lName" class="control-label col-sm-4">Last Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="lName" name="lName" required="no"></div>
					</div>
					<div class="form-group">
						<label for="UserName" class="control-label col-sm-4">School/Business Email:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="UserName" name="UserName" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Password" class="control-label col-sm-4">Desired Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="Password" name="Password" required="no"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-4">Verify Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" required="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-4">Phone Number:&nbsp;</label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" required="no"><div class="alert alert-warning small" role="alert"><em>This phone number will be used if an event needs to be cancelled or postponed</em></div></div>
					</div>
					<!--- 
					<div class="form-group">
						<label for="GradeLevel" class="control-label col-sm-3">Teaching Grade Level:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeLevel" class="form-control" Required="No" Multiple="No" query="Session.getGradeLevels" value="TContent_ID" Display="GradeLevel"  queryposition="below"><option value="----">Select Grade Level you Teach</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="GradeSubjects" class="control-label col-sm-3">Teaching Subject:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeSubjects" class="form-control" Required="No" Multiple="No" query="Session.getGradeSubjects" value="TContent_ID" Display="GradeSubject"  queryposition="below"><option value="----">Select Subject you Teach</option></cfselect></div>
					</div>
					--->
					<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
						<fieldset>
							<legend><h2>Human Detection</h2></legend>
						</fieldset>
						<div class="form-group">
							<div class="col-sm-12">
								<div class="g-recaptcha" data-sitekey="#Session.SiteConfigSettings.GoogleReCaptcha_SiteKey#"></div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-left" value="Back to Current Events">&nbsp;
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-right" value="Create Account"><br /><br />
				</div>
			<cfelse>
				<div class="panel-body">
					<fieldset>
						<legend>Register New User Account</legend>
					</fieldset>
					<div class="well">Please complete the following information to register for a user account on this event registration system. All electric communications from this system will be sent to the email address you provide. Any certificates that will be generated upon successfull completion of an event that issues certificates will use the information on this screen. Please make sure the information listed below is correct.</div>
					<fieldset>
						<legend>Your Information</legend>
					</fieldset>
					<div class="form-group">
						<label for="fName" class="control-label col-sm-4">First Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="fName" name="fName" value="#Session.FormInput.fName#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="lName" class="control-label col-sm-4">Last Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="lName" name="lName" value="#Session.FormInput.lName#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="UserName" class="control-label col-sm-4">School/Business Email:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6"><cfinput type="text" class="form-control" id="UserName" name="UserName" value="#Session.FormInput.UserName#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Password" class="control-label col-sm-4">Desired Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="Password" name="Password" value="#Session.FormInput.Password#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-4">Verify Password:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-sm-6"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" value="#Session.FormInput.VerifyPassword#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-4">Phone Number:&nbsp;</label>
						<div class="col-sm-6">
							<cfif isDefined("Session.FormInput.mobilePhone")>
								<cfif LEN(Session.FormInput.mobilePhone)>
									<cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" value="#Session.FormInput.mobilePhone#" required="no">
								<cfelse>
									<cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" required="no">
								</cfif>
							<cfelse>
								<cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" required="no">
							</cfif>
							<div class="alert alert-warning small" role="alert"><em>This phone number will be used if an event needs to be cancelled or postponed</em></div>
						</div>
					</div>
					<!--- 
					<div class="form-group">
						<label for="GradeLevel" class="control-label col-sm-3">Teaching Grade Level:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeLevel" class="form-control" Required="No" Multiple="No" query="Session.getGradeLevels" value="TContent_ID" Display="GradeLevel"  queryposition="below"><option value="----">Select Grade Level you Teach</option></cfselect></div>
					</div>
					<div class="form-group">
						<label for="GradeSubjects" class="control-label col-sm-3">Teaching Subject:&nbsp;</label>
						<div class="col-sm-6"><cfselect name="GradeSubjects" class="form-control" Required="No" Multiple="No" query="Session.getGradeSubjects" value="TContent_ID" Display="GradeSubject"  queryposition="below"><option value="----">Select Subject you Teach</option></cfselect></div>
					</div>
					--->
					<cfif Session.SiteConfigSettings.GoogleReCaptcha_Enabled EQ 1>
						<fieldset>
							<legend><h2>Human Detection</h2></legend>
						</fieldset>
						<div class="form-group">
							<div class="col-sm-12">
								<div class="g-recaptcha" data-sitekey="#Session.SiteConfigSettings.GoogleReCaptcha_SiteKey#"></div>
							</div>
						</div>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-left" value="Back to Current Events">&nbsp;
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-right" value="Create Account"><br /><br />
				</div>
			</cfif>
		</div>
	</cfform>
</cfoutput>