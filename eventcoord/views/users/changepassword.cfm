<cfsilent>
<!---

--->
</cfsilent>
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
<cfoutput>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Change Account Holder Password</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="UserID" value="#Session.FormInput.UserID#">
				<cfinput type="hidden" name="UserName" value="#Session.getSelectedUser.UserName#">
				<div class="panel-body">
					<div class="alert alert-info">Please complete the following information to edit information regarding this Account Holder</div>
					<div class="form-group">
						<label for="FirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FName" name="FName" value="#Session.getSelectedUser.FName#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="LName" name="LName" value="#Session.getSelectedUser.LName#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Email" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Email" name="Email" value="#Session.getSelectedUser.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Username" class="control-label col-sm-3">Username:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="UserName" name="UserName" value="#Session.getSelectedUser.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Company" class="control-label col-sm-3">Company:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Company" name="Company" value="#Session.getSelectedUser.Company#" disabled="No"></div>
					</div>
					<div class="form-group">
						<label for="JobTitle" class="control-label col-sm-3">Job Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="JobTitle" name="JobTitle" value="#Session.getSelectedUser.JobTitle#" disabled="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-3">Mobile Phone:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" value="#Session.getSelectedUser.mobilePhone#" disabled="no"></div>
					</div>
					<div class="form-group">
						<label for="InActive" class="control-label col-sm-3">Account InActive:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="InActive" class="form-control" disabled="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedUser.InActive#" Display="OptionName" queryposition="below">
							<option value="----">Account InActive?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="Password" class="control-label col-sm-3">Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="Password" name="Password" required="no"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" required="no"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Change Account Password"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Change Account Holder Password</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfinput type="hidden" name="UserID" value="#Session.FormInput.UserID#">
				<cfinput type="hidden" name="UserName" value="#Session.getSelectedUser.UserName#">
				<cfif isDefined("Session.FormErrors")>
					<div class="panel-body">
						<cfif ArrayLen(Session.FormErrors) GTE 1>
							<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
						</cfif>
					</div>
				</cfif>
				<div class="panel-body">
					<div class="alert alert-info">Please complete the following information to edit information regarding this Account Holder</div>
					<div class="form-group">
						<label for="FirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FName" name="FName" value="#Session.getSelectedUser.FName#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="LastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="LName" name="LName" value="#Session.getSelectedUser.LName#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Email" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Email" name="Email" value="#Session.getSelectedUser.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Username" class="control-label col-sm-3">Username:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="UserName" name="UserName" value="#Session.getSelectedUser.Email#" disabled="yes"></div>
					</div>
					<div class="form-group">
						<label for="Company" class="control-label col-sm-3">Company:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Company" name="Company" value="#Session.getSelectedUser.Company#" disabled="No"></div>
					</div>
					<div class="form-group">
						<label for="JobTitle" class="control-label col-sm-3">Job Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="JobTitle" name="JobTitle" value="#Session.getSelectedUser.JobTitle#" disabled="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-3">Mobile Phone:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" value="#Session.getSelectedUser.mobilePhone#" disabled="no"></div>
					</div>
					<div class="form-group">
						<label for="InActive" class="control-label col-sm-3">Account InActive:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="InActive" class="form-control" disabled="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.getSelectedUser.InActive#" Display="OptionName" queryposition="below">
							<option value="----">Account InActive?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="Password" class="control-label col-sm-3">Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="Password" name="Password" value="#Session.FormInput.Password#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" value="#Session.FormInput.VerifyPassword#" required="no"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Change Account Password"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
