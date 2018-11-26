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
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif isDefined("URL.UserAction")>
					<cfswitch expression="#URL.UserAction#">
					<cfcase value="PasswordChanged">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>User Account Activated</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully changed the account holder's password in the database. If account is Activated, the user will be able to login with Username and the password which was just set</p>
										</div>
										<div class="modal-footer">
											<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
										</div>
									</div>
								</div>
							</div>
							<script type='text/javascript'>
								(function() {
									'use strict';
									function remoteModal(idModal){
										var vm = this;
										vm.modal = $(idModal);
										if( vm.modal.length == 0 ) { return false; } else { openModal(); }
										if( window.location.hash == idModal ){ openModal(); }
										var services = { open: openModal, close: closeModal };
										return services;
										function openModal(){
											vm.modal.modal('show');
										}
										function closeModal(){
											vm.modal.modal('hide');
										}
									}
									Window.prototype.remoteModal = remoteModal;
								})();
								$(function(){
									window.remoteModal('##modelWindowDialog');
								});
							</script>
						<cfelse>
							<div class="alert alert-danger">
							</div>
						</cfif>
					</cfcase>
				</cfswitch>
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Add User Account Holder</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Account Holder</div>
					<div class="form-group">
						<label for="FirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FName" name="FName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="LName" name="LName" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Email" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Email" name="Email" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Company" class="control-label col-sm-3">Company:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Company" name="Company" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="JobTitle" class="control-label col-sm-3">Job Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="JobTitle" name="JobTitle" required="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-3">Mobile Phone:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Password" class="control-label col-sm-3">Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="Password" name="Password" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="InActive" class="control-label col-sm-3">Account InActive:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="InActive" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" value="ID" Display="OptionName" queryposition="below">
							<option value="----">Account InActive?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="Membership" class="control-label col-sm-3">Account Membership:&nbsp;</label>
						<div class="col-sm-8">
							<table class="table table-striped table-bordered">
								<thead class="thead-default">
									<tr>
										<th width="40%">Group Name</th>
										<th width="40%">Assign Group</th>
									</tr>
								</thead>
								<tbody>
									<cfloop query="Session.getEventGroups">
										<tr>
											<td>#Session.getEventGroups.GroupName#</td>
											<td><input type="checkbox" name="MemberGroup" value="#Session.getEventGroups.UserID#"></td>
										</tr>
									</cfloop>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Account Information"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif isDefined("Session.FormErrors")>
					<div id="modelWindowDialog" class="modal fade">
						<div class="modal-dialog">
							<div class="modal-content">
								<div class="modal-header">
									<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
									<h3>Missing Information</h3>
								</div>
								<div class="modal-body">
									<p class="alert alert-danger">#Session.FormErrors[1].Message#</p>
								</div>
								<div class="modal-footer">
									<button class="btn btn-default" data-dismiss="modal" aria-hidden="true">Close</button>
								</div>
							</div>
						</div>
					</div>
					<script type='text/javascript'>
						(function() {
							'use strict';
							function remoteModal(idModal){
								var vm = this;
								vm.modal = $(idModal);
								if( vm.modal.length == 0 ) { return false; } else { openModal(); }
								if( window.location.hash == idModal ){ openModal(); }
								var services = { open: openModal, close: closeModal };
								return services;
								function openModal(){
									vm.modal.modal('show');
								}
								function closeModal(){
									vm.modal.modal('hide');
								}
							}
							Window.prototype.remoteModal = remoteModal;
						})();
						$(function(){
							window.remoteModal('##modelWindowDialog');
						});
					</script>
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Add User Account Holder</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to edit information regarding this Account Holder</div>
					<div class="form-group">
						<label for="FirstName" class="control-label col-sm-3">First Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="FName" name="FName" value="#Session.FormInput.Fname#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LastName" class="control-label col-sm-3">Last Name:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="LName" name="LName" value="#Session.FormInput.Lname#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Email" class="control-label col-sm-3">Email Address:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Email" name="Email" value="#Session.FormInput.Email#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="Company" class="control-label col-sm-3">Company:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Company" name="Company" value="#Session.FormInput.Company#" Required="No"></div>
					</div>
					<div class="form-group">
						<label for="JobTitle" class="control-label col-sm-3">Job Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="JobTitle" name="JobTitle" value="#Session.FormInput.JobTitle#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="mobilePhone" class="control-label col-sm-3">Mobile Phone:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="mobilePhone" name="mobilePhone" value="#Session.FormInput.mobilePhone#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="Password" class="control-label col-sm-3">Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="Password" name="Password" value="#Session.FormInput.Password#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="VerifyPassword" class="control-label col-sm-3">Verify Password:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="password" class="form-control" id="VerifyPassword" name="VerifyPassword" value="#Session.FormInput.VerifyPassword#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="InActive" class="control-label col-sm-3">Account InActive:&nbsp;</label>
						<div class="col-sm-8"><cfselect name="InActive" class="form-control" Required="Yes" Multiple="No" query="YesNoQuery" selected="#Session.FormInput.InActive#" value="ID" Display="OptionName" queryposition="below">
							<option value="----">Account InActive?</option>
						</cfselect></div>
					</div>
					<div class="form-group">
						<label for="Membership" class="control-label col-sm-3">Account Membership:&nbsp;</label>
						<div class="col-sm-8">
							<table class="table table-striped table-bordered">
								<thead class="thead-default">
									<tr>
										<th width="40%">Group Name</th>
										<th width="40%">Assign Group</th>
									</tr>
								</thead>
								<tbody>
									<cfloop query="Session.getEventGroups">
										<cfquery name="getUserMembership" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
											Select UserID, GroupID
											From tusersmemb
											Where UserID = <cfqueryparam value="#URL.UserID#" cfsqltype="cf_sql_varchar"> and
												GroupID = <cfqueryparam value="#Session.getEventGroups.UserID#" cfsqltype="cf_sql_varchar">
										</cfquery>
										<tr>
											<td>#Session.getEventGroups.GroupName#</td>
											<td><cfif getUserMembership.RecordCount>
													<input type="checkbox" name="MemberGroup" value="#Session.getEventGroups.UserID#" checked>
												<cfelse>
													<input type="checkbox" name="MemberGroup" value="#Session.getEventGroups.UserID#">
												</cfif>
											</td>
										</tr>
									</cfloop>
								</tbody>
							</table>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">&nbsp;
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Account Information"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
