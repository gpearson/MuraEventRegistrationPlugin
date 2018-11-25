<cfset BestContactMethodQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(BestContactMethodQuery, 1)>
<cfset temp = #QuerySetCell(BestContactMethodQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(BestContactMethodQuery, "OptionName", "By Email")#>
<cfset temp = QueryAddRow(BestContactMethodQuery, 1)>
<cfset temp = #QuerySetCell(BestContactMethodQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(BestContactMethodQuery, "OptionName", "By Telephone")#>

<cfoutput>
	<div class="panel panel-default">
		<div class="panel-heading"><h1>Contact Us</h1></div>
		<cfif not isDefined("URL.FormRetry")>
			<cfset captcha = #Session.Captcha#>
			<cfset captchaHash = Hash(captcha)>
			<cfform action="" method="post" id="ContactUsForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="CaptchaEncrypted" value="#Variables.CaptchaHash#">
				<cfinput type="hidden" name="HumanValidation" value="#Variables.Captcha#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<!--- <cfinput type="hidden" name="captchaHash" id="captchaHash" value="#captchaHash#"> --->
				<div class="panel-body">
					<div class="well">Please complete the following information to send us your inquiry</div>
					<div class="panel-heading"><h2>Your Contact Information</h2></div>
					<div class="form-group">
						<label for="YourFirstName" class="control-label col-sm-2">First Name:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.Mura.IsLoggedIn EQ true>
								<cfinput type="text" class="form-control" value="#Session.Mura.FName#" id="ContactFirstName" name="ContactFirstName" required="yes" placeholder="Enter Your First Name" disabled="true">
							<cfelse>
								<cfinput type="text" class="form-control" id="ContactFirstName" name="ContactFirstName" required="yes" placeholder="Enter Your First Name">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="YourLastName" class="control-label col-sm-2">Last Name:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.Mura.IsLoggedIn EQ True>
								<cfinput type="text" class="form-control" value="#Session.Mura.LName#" id="ContactLastName" name="ContactLastName" required="yes" placeholder="Enter Your Last Name" disabled="true">
							<cfelse>
								<cfinput type="text" class="form-control" id="ContactLastName" name="ContactLastName" required="yes" placeholder="Enter Your Last Name">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="YourEmail" class="control-label col-sm-2">Your Email:&nbsp;</label>
						<div class="col-sm-9">
							<cfif Session.Mura.IsLoggedIn EQ True>
								<cfinput type="text" class="form-control" value="#Session.Mura.Email#" id="ContactEmail" name="ContactEmail" required="yes" placeholder="Enter Your Email Address" disabled="true">
							<cfelse>
								<cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" required="yes" placeholder="Enter Your Email Address">
							</cfif>


						</div>
					</div>
					<div class="form-group">
						<label for="YourTelephone" class="control-label col-sm-2">Your Phone:&nbsp;</label>
						<div class="col-sm-9"><cfinput type="text" class="form-control" id="ContactPhone" name="ContactPhone" required="yes" placeholder="Enter Your Best Contact Number"></div>
					</div>
					<div class="form-group">
						<label for="BestContactMethod" class="control-label col-sm-2">Best Contact Method:&nbsp;</label>
						<div class="col-sm-9">
							<cfselect name="BestContactMethod" class="form-control" Required="Yes" Multiple="No" query="BestContactMethodQuery" value="ID" Display="OptionName"  queryposition="below">
								<option value="----">Select Best Contact Method</option>
							</cfselect>
						</div>
					</div>
					<br /><br />
					<div class="panel-heading"><h2>Your Inquiry</h2></div>
					<div class="form-group">
						<label for="InquiryMessage" class="control-label col-sm-2">Inquiry:&nbsp;</label>
						<div class="col-sm-9">
							<textarea class="form-control" name="InquiryMessage" id="InquiryMessage" height="45" required="true"></textarea>
						</div>
					</div>
					<div class="panel-heading"><h2>Human Checker</h2></div>
					<div class="form-group">
						<label for="HumanChecker" class="control-label col-sm-2">Enter Text:&nbsp;</label>
						<div class="col-sm-9">
							<cfimage action="captcha" difficulty="medium" text="#captcha#" fonts="arial,times roman, tahoma" height="150" width="500" /><br>
							<cfinput name="ValidateCaptcha" type="text" required="yes" message="Input Captcha Text" />
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-right" value="Send Inquiry"><br /><br />
				</div>
			</cfform>
		<cfelse>
			<cfif isDefined("Session.FormErrors")>
				<div class="panel-body">
					<cfif ArrayLen(Session.FormErrors) GTE 1>
						<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
					</cfif>
				</div>
			</cfif>
			<cfform action="" method="post" id="ContactUsForm" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="CaptchaEncrypted" value="#Session.FormData.CaptchaEncrypted#">
				<cfinput type="hidden" name="HumanValidation" value="#Session.FormData.HumanValidation#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="well">Please complete the following information to send us your inquiry</div>
					<div class="panel-heading"><h2>Your Contact Information</h2></div>
					<div class="form-group">
						<label for="YourFirstName" class="control-label col-sm-2">First Name:&nbsp;</label>
						<div class="col-sm-9"><cfinput type="text" class="form-control" id="ContactFirstName" name="ContactFirstName" required="yes" value="#Session.FormData.ContactFirstName#" placeholder="Enter Your First Name"></div>
					</div>
					<div class="form-group">
						<label for="YourLastName" class="control-label col-sm-2">Last Name:&nbsp;</label>
						<div class="col-sm-9"><cfinput type="text" class="form-control" id="ContactLastName" value="#Session.FormData.ContactLastName#" name="ContactLastName" required="yes" placeholder="Enter Your Last Name"></div>
					</div>
					<div class="form-group">
						<label for="YourEmail" class="control-label col-sm-2">Your Email:&nbsp;</label>
						<div class="col-sm-9"><cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" value="#Session.FormData.ContactEmail#" required="yes" placeholder="Enter Your Email Address"></div>
					</div>
					<div class="form-group">
						<label for="YourTelephone" class="control-label col-sm-2">Your Phone:&nbsp;</label>
						<div class="col-sm-9"><cfinput type="text" class="form-control" id="ContactPhone" name="ContactPhone" value="#Session.FormData.ContactPhone#" required="yes" placeholder="Enter Your Best Contact Number"></div>
					</div>
					<div class="form-group">
						<label for="BestContactMethod" class="control-label col-sm-2">Best Contact Method:&nbsp;</label>
						<div class="col-sm-9">
							<cfselect name="BestContactMethod" class="form-control" Required="Yes" Multiple="No" query="BestContactMethodQuery" value="ID" Display="OptionName" selected="#Session.FormData.BestContactMethod#"  queryposition="below">
								<option value="----">Select Best Contact Method</option>
							</cfselect>
						</div>
					</div>
					<br /><br />
					<div class="panel-heading"><h2>Your Inquiry</h2></div>
					<div class="form-group">
						<label for="InquiryMessage" class="control-label col-sm-2">Inquiry:&nbsp;</label>
						<div class="col-sm-9">
							<textarea class="form-control" name="InquiryMessage" id="InquiryMessage" height="45" required="true">#Session.FormData.InquiryMessage#</textarea>
						</div>
					</div>
					<div class="panel-heading"><h2>Human Checker</h2></div>
					<div class="form-group">
						<label for="HumanChecker" class="control-label col-sm-2">Enter Text:&nbsp;</label>
						<div class="col-sm-9">
							<cfimage action="captcha" difficulty="medium" text="#Session.FormData.HumanValidation#" fonts="arial,times roman, tahoma" height="150" width="500" /><br>
							<cfinput name="ValidateCaptcha" type="text" required="yes" message="Input Captcha Text" />
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="SendInquiry" class="btn btn-primary pull-right" value="Send Inquiry"><br /><br />
				</div>
			</cfform>
		</cfif>
	</div>
</cfoutput>