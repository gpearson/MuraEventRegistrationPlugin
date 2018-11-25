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
			<div class="panel-heading"><h1>Add Membership Information</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="alert alert-info">Please complete the following information to add information regarding this Organization's Membership</div>
					<div class="form-group">
						<label for="OrganizationName" class="control-label col-sm-3">Organization Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="OrganizationName" name="OrganizationName"  required="yes"></div>
					</div>
					<div class="form-group">
						<label for="OrganizationDomainName" class="control-label col-sm-3">Organization Domain Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="OrganizationDomainName" name="OrganizationDomainName"  required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Active Membership:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="Active" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" Display="OptionName" queryposition="below">
							<option value="----">Active Membership?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="StateDOEIDNumber" class="control-label col-sm-3">State DOE ID Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="StateDOEIDNumber" name="StateDOEIDNumber" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="StateDOEState" class="control-label col-sm-3">State DOE State:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="StateDOEState" name="StateDOEState" required="yes"></div>
					</div>

					<div class="panel-heading"><h1>Mailing Address Information</h1></div>
					<div class="form-group">
						<label for="MailingAddress" class="control-label col-sm-3">Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingAddress" name="MailingAddress" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingCity" class="control-label col-sm-3">City:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingCity" name="MailingCity" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingState" class="control-label col-sm-3">State:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingState" name="MailingState" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingZipCode" class="control-label col-sm-3">ZipCode:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingZipCode" name="MailingZipCode" required="yes"></div>
					</div>
					<div class="panel-heading"><h1>Physical Address Information</h1></div>
					<div class="form-group">
						<label for="PhysicalAddress" class="control-label col-sm-3">Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="control-label col-sm-3">City:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="control-label col-sm-3">State:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="control-label col-sm-3">ZipCode:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" required="no"></div>
					</div>
					<div class="panel-heading"><h1>Phone Information</h1></div>
					<div class="form-group">
						<label for="PrimaryPhoneNumber" class="control-label col-sm-3">Voice Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryPhoneNumber" name="PrimaryPhoneNumber" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryFaxNumber" class="control-label col-sm-3">Fax Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryFaxNumber" name="PrimaryFaxNumber" required="no"></div>
					</div>
					<div class="panel-heading"><h1>Accounts Payable Contact Information</h1></div>
					<div class="form-group">
						<label for="AccountsPayableContactName" class="control-label col-sm-3">Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="AccountsPayableContactName" name="AccountsPayableContactName" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="AccountsPayableEmailAddress" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="AccountsPayableEmailAddress" name="AccountsPayableEmailAddress" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Send Invoices Electronically:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="ReceiveInvoicesByEmail" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below">
							<option value="----">Send Invoices Electronically?</option>
						</cfselect></div>
					</div>

				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Membership Information"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Add Membership Information</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif isDefined("Session.FormErrors")>
					<div class="panel-body">
						<cfif ArrayLen(Session.FormErrors) GTE 1>
							<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
						</cfif>
					</div>
				</cfif>
				<div class="panel-body">
					<div class="alert alert-info">Please complete the following information to edit information regarding this Organization's Membership</div>
					<div class="form-group">
						<label for="OrganizationName" class="control-label col-sm-3">Organization Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="OrganizationName" name="OrganizationName" value="#Session.FormInput.OrganizationName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="OrganizationDomainName" class="control-label col-sm-3">Organization Domain Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="OrganizationDomainName" name="OrganizationDomainName" value="#Session.FormInput.OrganizationDomainName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Active Membership:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="Active" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.FormInput.Active#" Display="OptionName" queryposition="below">
							<option value="----">Active Membership?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="StateDOEIDNumber" class="control-label col-sm-3">State DOE ID Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="StateDOEIDNumber" name="StateDOEIDNumber" value="#Session.FormInput.StateDOEIDNumber#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="StateDOEState" class="control-label col-sm-3">State DOE State:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="StateDOEState" name="StateDOEState" value="#Session.FormInput.StateDOEState#" required="yes"></div>
					</div>

					<div class="panel-heading"><h1>Mailing Address Information</h1></div>
					<div class="form-group">
						<label for="MailingAddress" class="control-label col-sm-3">Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingAddress" name="MailingAddress" value="#Session.FormInput.MailingAddress#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingCity" class="control-label col-sm-3">City:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingCity" name="MailingCity" value="#Session.FormInput.MailingCity#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingState" class="control-label col-sm-3">State:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingState" name="MailingState" value="#Session.FormInput.MailingState#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="MailingZipCode" class="control-label col-sm-3">ZipCode:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="MailingZipCode" name="MailingZipCode" value="#Session.FormInput.MailingZipCode#" required="yes"></div>
					</div>
					<div class="panel-heading"><h1>Physical Address Information</h1></div>
					<div class="form-group">
						<label for="PhysicalAddress" class="control-label col-sm-3">Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.FormInput.PhysicalAddress#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="control-label col-sm-3">City:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.FormInput.PhysicalCity#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="control-label col-sm-3">State:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.FormInput.PhysicalState#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="control-label col-sm-3">ZipCode:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.FormInput.PhysicalZipCode#" required="no"></div>
					</div>
					<div class="panel-heading"><h1>Phone Information</h1></div>
					<div class="form-group">
						<label for="PrimaryPhoneNumber" class="control-label col-sm-3">Voice Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryPhoneNumber" name="PrimaryPhoneNumber" value="#Session.FormInput.PrimaryPhoneNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryFaxNumber" class="control-label col-sm-3">Fax Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryFaxNumber" name="PrimaryFaxNumber" value="#Session.FormInput.PrimaryFaxNumber#" required="no"></div>
					</div>
					<div class="panel-heading"><h1>Accounts Payable Contact Information</h1></div>
					<div class="form-group">
						<label for="AccountsPayableContactName" class="control-label col-sm-3">Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="AccountsPayableContactName" name="AccountsPayableContactName" value="#Session.FormInput.AccountsPayableContactName#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="AccountsPayableEmailAddress" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="AccountsPayableEmailAddress" name="AccountsPayableEmailAddress" value="#Session.FormInput.AccountsPayableEmailAddress#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Send Invoices Electronically:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="ReceiveInvoicesByEmail" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.FormInput.ReceiveInvoicesByEmail#" Display="OptionName" queryposition="below">
							<option value="----">Send Invoices Electronically?</option>
						</cfselect></div>
					</div>

				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Membership Information"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
