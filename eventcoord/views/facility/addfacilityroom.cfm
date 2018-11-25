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
			<div class="panel-heading"><h1>Add Facility Room Information</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="alert alert-info">Please complete the following information to edit information regarding the Facility Room</div>
					<div class="form-group">
						<label for="RoomName" class="control-label col-sm-3">Room Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="RoomName" name="RoomName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomCapacity" class="control-label col-sm-3">Seating Capacity:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="RoomCapacity" name="RoomCapacity" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomFees" class="control-label col-sm-3">Room Fee:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="RoomFees" name="RoomFees" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Active:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="Active" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below">
							<option value="----">Is Room Active?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Facility Room Information"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Add Facility Room Information</h1></div>
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
					<div class="alert alert-info">Please complete the following information to edit information regarding the Facility Room</div>
					<div class="form-group">
						<label for="RoomName" class="control-label col-sm-3">Room Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="RoomName" name="RoomName" value="#Session.FormInput.RoomName#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomCapacity" class="control-label col-sm-3">Seating Capacity:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="RoomCapacity" name="RoomCapacity" value="#Session.FormInput.RoomCapacity#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="RoomFees" class="control-label col-sm-3">Room Fee:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="RoomFees" name="RoomFees" value="#Session.FormInput.RoomFees#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Active" class="control-label col-sm-3">Active:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="Active" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" selected="#Session.FormInput.Active#" Display="OptionName" queryposition="below">
							<option value="----">Is Room Active?</option>
						</cfselect></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Facility Room Information"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
