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
			<div class="panel-heading"><h1>Add New Facility Information</h1></div>
			<cfif isDefined("URL.UserAction")>
				<div class="panel-body">
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="RoomCreated">
							<cfif URL.Successful EQ "true">
								<div class="alert alert-success">
									You have successfully created a new room within Facility for upcoming meetings or events.
								</div>
							<cfelse>
								<div class="alert alert-danger">
								</div>
							</cfif>
						</cfcase>
						<cfcase value="RoomUpdated">
							<cfif URL.Successful EQ "true">
								<div class="alert alert-success">
									You have successfully updated a room within Facility for upcoming meetings or events.
								</div>
							<cfelse>
								<div class="alert alert-danger">
								</div>
							</cfif>
						</cfcase>
					</cfswitch>
				</div>
			</cfif>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="alert alert-info">Please complete the following information to edit information regarding this Facility</div>
					<div class="form-group">
						<label for="FacilityName" class="control-label col-sm-3">Facility Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FacilityName" name="FacilityName" required="yes"></div>
					</div>
					<div class="panel-heading"><h1>Physical Location Information</h1></div>
					<div class="form-group">
						<label for="PhysicalAddress" class="control-label col-sm-3">Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="control-label col-sm-3">City:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="control-label col-sm-3">State:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="control-label col-sm-3">ZipCode:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="control-label col-sm-3">Voice Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="control-label col-sm-3">Website:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" required="NO"></div>
					</div>
					<div class="panel-heading"><h1>Contact Information</h1></div>
					<div class="form-group">
						<label for="ContactName" class="control-label col-sm-3">Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactName" name="ContactName" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneNumber" class="control-label col-sm-3">Phone Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactPhoneNumber" name="ContactPhoneNumber" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Active:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="Active" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below">
							<option value="----">Is facility Active?</option>
						</cfselect></div>
					</div>

				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Facility"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Edit Caterer Information</h1></div>
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
					<div class="alert alert-info">Please complete the following information to edit information regarding this Caterering Facility</div>
					<div class="form-group">
						<label for="FacilityName" class="control-label col-sm-3">Business Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FacilityName" name="FacilityName" value="#Session.FormInput.FacilityName#" required="yes"></div>
					</div>
					<div class="panel-heading"><h1>Physical Location Information</h1></div>
					<div class="form-group">
						<label for="PhysicalAddress" class="control-label col-sm-3">Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalAddress" name="PhysicalAddress" value="#Session.FormInput.PhysicalAddress#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalCity" class="control-label col-sm-3">City:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalCity" name="PhysicalCity" value="#Session.FormInput.PhysicalCity#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalState" class="control-label col-sm-3">State:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalState" name="PhysicalState" value="#Session.FormInput.PhysicalState#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PhysicalZipCode" class="control-label col-sm-3">ZipCode:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PhysicalZipCode" name="PhysicalZipCode" value="#Session.FormInput.PhysicalZipCode#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="PrimaryVoiceNumber" class="control-label col-sm-3">Voice Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="PrimaryVoiceNumber" name="PrimaryVoiceNumber" value="#Session.FormInput.PrimaryVoiceNumber#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="BusinessWebsite" class="control-label col-sm-3">Website:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="BusinessWebsite" name="BusinessWebsite" value="#Session.FormInput.BusinessWebsite#" required="NO"></div>
					</div>
					<div class="panel-heading"><h1>Contact Information</h1></div>
					<div class="form-group">
						<label for="ContactName" class="control-label col-sm-3">Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactName" name="ContactName" value="#Session.FormInput.ContactName#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactPhoneNumber" class="control-label col-sm-3">Phone Number:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactPhoneNumber" name="ContactPhoneNumber" value="#Session.FormInput.ContactPhoneNumber#" required="NO"></div>
					</div>
					<div class="form-group">
						<label for="ContactEmail" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ContactEmail" name="ContactEmail" value="#Session.FormInput.ContactEmail#" required="NO"></div>
					</div>
					<div class="panel-heading"><h1>Optional Information</h1></div>
					<div class="form-group">
						<label for="PaymentTerms" class="control-label col-sm-3">Payment Terms:&nbsp;</label>
						<div class="col-sm-8"><textarea name="PaymentTerms" id="PaymentTerms" class="form-control" >#Session.FormInput.PaymentTerms#</textarea></div>
					</div>
					<div class="form-group">
						<label for="DeliveryInfo" class="control-label col-sm-3">Delivery Information:&nbsp;</label>
						<div class="col-sm-8"><textarea name="DeliveryInfo" id="DeliveryInfo" class="form-control" >#Session.FormInput.DeliveryInfo#</textarea></div>
					</div>
					<div class="form-group">
						<label for="GuaranteeInformation" class="control-label col-sm-3">Guarantee Information:&nbsp;</label>
						<div class="col-sm-8"><textarea name="GuaranteeInformation" id="GuaranteeInformation" class="form-control" >#Session.FormInput.GuaranteeInformation#</textarea></div>
					</div>
					<div class="form-group">
						<label for="AdditionalNotes" class="control-label col-sm-3">Additional Notes:&nbsp;</label>
						<div class="col-sm-8"><textarea name="AdditionalNotes" id="AdditionalNotes" class="form-control" >#Session.FormInput.AdditionalNotes#</textarea></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Active:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="Active" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.FormInput.Active#" Display="OptionName" queryposition="below">
							<option value="----">Is Caterer Active?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Facility"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
