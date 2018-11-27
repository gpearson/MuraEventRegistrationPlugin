<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
<cfset YesNoQuery = QueryNew("ID,OptionName", "Integer,VarChar")>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 0)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "No")#>
<cfset temp = QueryAddRow(YesNoQuery, 1)>
<cfset temp = #QuerySetCell(YesNoQuery, "ID", 1)#>
<cfset temp = #QuerySetCell(YesNoQuery, "OptionName", "Yes")#>
</cfsilent>
<cfoutput>
	<cfif isDefined("URL.UserAction")>
		<cfswitch expression="#URL.UserAction#">
			<cfcase value="EventExpenseAdded">
				<div id="modelWindowDialog" class="modal fade">
					<div class="modal-dialog">
						<div class="modal-content">
							<div class="modal-header">
								<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
								<h3>Event Expense Added</h3>
							</div>
							<div class="modal-body">
								<p class="alert alert-success">You have successfully added a new event expense to the system.</p>
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
			</cfcase>
		</cfswitch>
	</cfif>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Add Event Expenses</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new expense to the list.</div>
					<div class="form-group">
						<label for="ExpenseName" class="col-lg-5 col-md-5">Expense Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfinput type="text" class="form-control" id="ExpenseName" name="ExpenseName" required="no">
						</div>
					</div>
					<div class="form-group">
						<label for="ExpenseActive" class="col-lg-5 col-md-5">Expense Active:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfselect name="ExpenseActive" class="form-control" Required="Yes" Multiple="No" query="Variables.YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Select whether Event Expense is Active or not</option></cfselect>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Events Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Enter Event Expense"><br /><br />
				</div>
			</cfform>
		</div>
		<hr>
		<div class="panel panel-default">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Event Expenses Entered In System</h2></legend>
				</fieldset>
				<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
					<thead>
						<tr>
							<td width="75%" style="Font-Family: Arial; Font-Size: 12px;">Expense Name</td>
							<td width="25%" style="Font-Family: Arial; Font-Size: 12px;">Active</td>
						</tr>
					</thead>
					<tbody>
						<cfloop query="Session.getExpenseList">
							<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
								<td width="75%">#Session.getExpenseList.Expense_Name#</td>
								<td width="25%"><cfswitch expression="#Session.getExpenseList.Active#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif isDefined("Session.FormErrors")>
					<cfif ArrayLen(Session.FormErrors)>
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
				</cfif>
				<div class="panel-body">
					<fieldset>
						<legend><h2>Add Event Expenses</h2></legend>
					</fieldset>
					<div class="alert alert-info">Please complete the following information to add a new expense to the list.</div>
					<div class="form-group">
						<label for="ExpenseName" class="col-lg-5 col-md-5">Expense Name:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.ExpenseName")>
								<cfinput type="text" class="form-control" id="ExpenseName" name="ExpenseName" value="#Session.FormInput.ExpenseName#" required="no">
							<cfelse>
								<cfinput type="text" class="form-control" id="ExpenseName" name="ExpenseName" required="no">
							</cfif>
						</div>
					</div>
					<div class="form-group">
						<label for="ExpenseActive" class="col-lg-5 col-md-5">Expense Active:&nbsp;</label>
						<div class="col-lg-7 col-md-7">
							<cfif isDefined("Session.FormInput.ExpenseActive")>
								<cfselect name="ExpenseActive" class="form-control" Required="Yes" Multiple="No" query="Variables.YesNoQuery" value="ID" selected="#Session.FormInput.ExpenseActive#" Display="OptionName" queryposition="below"><option value="----">Select whether Event Expense is Active or not</option></cfselect>
							<cfelse>
								<cfselect name="ExpenseActive" class="form-control" Required="Yes" Multiple="No" query="Variables.YesNoQuery" value="ID" Display="OptionName" queryposition="below"><option value="----">Select whether Event Expense is Active or not</option></cfselect>
							</cfif>
						</div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Events Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Enter Event Expense"><br /><br />
				</div>
			</cfform>
		</div>
		<hr>
		<div class="panel panel-default">
			<div class="panel-body">
				<fieldset>
					<legend><h2>Event Expenses Entered In System</h2></legend>
				</fieldset>
				<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
					<thead>
						<tr>
							<td width="75%" style="Font-Family: Arial; Font-Size: 12px;">Expense Name</td>
							<td width="25%" style="Font-Family: Arial; Font-Size: 12px;">Active</td>
						</tr>
					</thead>
					<tbody>
						<cfloop query="Session.getExpenseList">
							<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
								<td width="75%">#Session.getExpenseList.Expense_Name#</td>
								<td width="25%"><cfswitch expression="#Session.getExpenseList.Active#"><cfcase value="1">Yes</cfcase><cfcase value="0">No</cfcase></cfswitch></td>
							</tr>
						</cfloop>
					</tbody>
				</table>
			</div>
		</div>
	</cfif>
</cfoutput>