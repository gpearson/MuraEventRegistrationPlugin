<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<cfif isDefined("URL.FormRetry")>
			<div id="modelWindowDialog" class="modal fade">
				<div class="modal-dialog">
					<div class="modal-content">
						<div class="modal-header">
							<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
							<h3>Missing Information to Enter Expenses</h3>
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
		<cfform action="" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="EventID" value="#URL.EventID#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<div class="panel-body">
				<cfif isDefined("URL.UserAction")>
					<cfif URL.UserAction EQ "UpdateExpense">
						<fieldset>
							<legend><h2>Update Expense for: #Session.getSelectedEvent.ShortTitle#</h2></legend>
						</fieldset>
					<cfelse>
						<fieldset>
						<legend><h2>Event Expenses - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					</cfif>
				<cfelse>
					<fieldset>
						<legend><h2>Event Expenses - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
				</cfif>

				<cfif not isDefined("URL.UserAction")>
					<cfif Session.getAvailableEventExpenses.RecordCount><table class="table table-striped" width="100%" cellspacing="0" cellpadding="0"><cfelse><table class="table" width="100%" cellspacing="0" cellpadding="0"></cfif>
					<thead>
						<tr>
							<td width="50%" style="Font-Family: Arial; Font-Size: 12px;">Expense Name</td>
							<td width="15%" style="Font-Family: Arial; Font-Size: 12px;">Cost</td>
							<td style="Font-Family: Arial; Font-Size: 12px;">Actions</td>
						</tr>
					</thead>
					<cfif Session.getAvailableEventExpenses.RecordCount>
						<tfoot>
							<tr>
								<td colspan="3">
									<div class="form-group">
										<label for="ExpenseName" class="control-label col-sm-1">Type:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
										<div class="col-sm-4">
											<cfselect name="ExpenseID" class="form-control" Required="Yes" Multiple="No" query="Session.getAvailableExpenseList" value="TContent_ID" Display="Expense_Name"  queryposition="below">
												<option value="----">Select Expense Name from List?</option>
											</cfselect>
										</div>
										<label for="ExpenseAmount" class="control-label col-sm-1">Amount:&nbsp;</label>
										<div class="col-sm-3"><cfinput type="text" class="form-control" id="ExpenseAmount" name="ExpenseAmount" required="no"></div>
										<div class="col-sm-3"><cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Expense"></div>
									</div>
								</td>
							</tr>
						</tfoot>
						<tbody>
							<cfloop query="Session.getAvailableEventExpenses">
							<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
								<td width="50%">#Session.getAvailableEventExpenses.Expense_Name#</td>
								<td width="15%">#DollarFormat(Session.getAvailableEventExpenses.Cost_Amount)#</td>
								<td><A href="#buildURL('eventcoord:events.enterexpenses')#&EventID=#URL.EventID#&EventRecID=#Session.getAvailableEventExpenses.TContent_ID#&UserAction=UpdateExpense" class="btn btn-primary">Update</a> <A href="#buildURL('eventcoord:events.enterexpenses')#&EventID=#URL.EventID#&EventRecID=#Session.getAvailableEventExpenses.TContent_ID#&UserAction=DeleteExpense" class="btn btn-primary">Delete</a></td>
							</tr>
							</cfloop>
						</tbody>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="3">
									<div class="form-group">
										<label for="ExpenseName" class="control-label col-sm-1">Type:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
										<div class="col-sm-4">
											<cfselect name="ExpenseID" class="form-control" Required="Yes" Multiple="No" query="Session.getAvailableExpenseList" value="TContent_ID" Display="Expense_Name"  queryposition="below">
												<option value="----">Select Expense Name from List?</option>
											</cfselect>
										</div>
										<label for="ExpenseAmount" class="control-label col-sm-1">Amount:&nbsp;</label>
										<div class="col-sm-3"><cfinput type="text" class="form-control" id="ExpenseAmount" name="ExpenseAmount" required="no"></div>
										<div class="col-sm-3"><cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Add Expense"></div>
									</div>
								</td>
							</tr>
						</tbody>
					</cfif>
				<cfelse>
					<cfif URL.UserAction EQ "UpdateExpense">
						<cfinput type="Hidden" name="EventRecID" value="#URL.EventRecID#">
						<cfif Session.getAvailableEventExpenses.RecordCount><table class="table table-striped" width="100%" cellspacing="0" cellpadding="0"><cfelse><table class="table" width="100%" cellspacing="0" cellpadding="0"></cfif>
						<thead>
							<tr>
								<td width="50%" style="Font-Family: Arial; Font-Size: 12px;">Expense Name</td>
								<td width="15%" style="Font-Family: Arial; Font-Size: 12px;">Cost</td>
								<td style="Font-Family: Arial; Font-Size: 12px;">Actions</td>
							</tr>
						</thead>
						<tbody>
							<tr>
								<td colspan="3">
									<div class="form-group">
										<label for="ExpenseName" class="control-label col-sm-3">Expense Type:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
										<div class="col-sm-8">
											<cfselect name="ExpenseID" class="form-control" Required="Yes" Multiple="No" selected="#Session.getSelectedEventExpenses.Expense_ID#" query="Session.getAvailableExpenseList" value="TContent_ID" Display="Expense_Name"  queryposition="below">
												<option value="----">Select Expense Name from List?</option>
											</cfselect>
										</div>
									<!--- <div align="center" class="alert-box notice">No Event Expenses have been located within the database. Please click <a href="#buildURL('eventcoord:events.addeventexpenses')#&EventID=#URL.EventID#" class="art-button">here</a> to add a new expense for this event.</div> --->
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<div class="form-group">
										<label for="ExpenseAmount" class="control-label col-sm-3">Expense Amount:&nbsp;</label>
										<div class="col-sm-8"><cfinput type="text" class="form-control" id="ExpenseAmount" value="#Session.getSelectedEventExpenses.Cost_Amount#" name="ExpenseAmount" required="no"></div>
										<!--- <div align="center" class="alert-box notice">No Event Expenses have been located within the database. Please click <a href="#buildURL('eventcoord:events.addeventexpenses')#&EventID=#URL.EventID#" class="art-button">here</a> to add a new expense for this event.</div> --->
								</td>
							</tr>
						</tbody>
					<cfelse>
						<cfif Session.getAvailableEventExpenses.RecordCount><table class="table table-striped" width="100%" cellspacing="0" cellpadding="0"><cfelse><table class="table" width="100%" cellspacing="0" cellpadding="0"></cfif>
					<thead>
						<tr>
							<td width="50%" style="Font-Family: Arial; Font-Size: 12px;">Expense Name</td>
							<td width="15%" style="Font-Family: Arial; Font-Size: 12px;">Cost</td>
							<td style="Font-Family: Arial; Font-Size: 12px;">Actions</td>
						</tr>
					</thead>
					<cfif Session.getAvailableEventExpenses.RecordCount>
						<tfoot>
							<tr>
								<td colspan="3">
									<div class="form-group">
										<label for="ExpenseName" class="control-label col-sm-3">Expense Type:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
										<div class="col-sm-8">
											<cfselect name="ExpenseID" class="form-control" Required="Yes" Multiple="No" query="Session.getAvailableExpenseList" value="TContent_ID" Display="Expense_Name"  queryposition="below">
												<option value="----">Select Expense Name from List?</option>
											</cfselect>
										</div>
										<!--- <div align="center" class="alert-box notice">No Event Expenses have been located within the database. Please click <a href="#buildURL('eventcoord:events.addeventexpenses')#&EventID=#URL.EventID#" class="art-button">here</a> to add a new expense for this event.</div>--->
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<div class="form-group">
										<label for="ExpenseAmount" class="control-label col-sm-3">Expense Amount:&nbsp;</label>
										<div class="col-sm-8"><cfinput type="text" class="form-control" id="ExpenseAmount" name="ExpenseAmount" required="no"></div>
										<!--- <div align="center" class="alert-box notice">No Event Expenses have been located within the database. Please click <a href="#buildURL('eventcoord:events.addeventexpenses')#&EventID=#URL.EventID#" class="art-button">here</a> to add a new expense for this event.</div> --->
								</td>
							</tr>
						</tfoot>
						<tbody>
							<cfloop query="Session.getAvailableEventExpenses">
							<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
								<td width="50%">#Session.getAvailableEventExpenses.Expense_Name#</td>
								<td width="15%">#DollarFormat(Session.getAvailableEventExpenses.Cost_Amount)#</td>
								<td><A href="#buildURL('eventcoord:events.enterexpenses')#&EventID=#URL.EventID#&EventRecID=#Session.getAvailableEventExpenses.TContent_ID#&UserAction=UpdateExpense" class="btn btn-primary">Update</a> <A href="#buildURL('eventcoord:events.enterexpenses')#&EventID=#URL.EventID#&EventRecID=#Session.getAvailableEventExpenses.TContent_ID#&UserAction=DeleteExpense" class="btn btn-primary">Delete</a></td>
							</tr>
							</cfloop>
						</tbody>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="3">
									<div class="form-group">
										<label for="ExpenseName" class="control-label col-sm-3">Expense Type:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
										<div class="col-sm-8">
											<cfselect name="ExpenseID" class="form-control" Required="Yes" Multiple="No" query="Session.getAvailableExpenseList" value="TContent_ID" Display="Expense_Name"  queryposition="below">
												<option value="----">Select Expense Name from List?</option>
											</cfselect>
										</div>
										<!--- <div align="center" class="alert-box notice">No Event Expenses have been located within the database. Please click <a href="#buildURL('eventcoord:events.addeventexpenses')#&EventID=#URL.EventID#" class="art-button">here</a> to add a new expense for this event.</div> --->
								</td>
							</tr>
							<tr>
								<td colspan="3">
									<div class="form-group">
										<label for="ExpenseAmount" class="control-label col-sm-3">Expense Amount:&nbsp;</label>
										<div class="col-sm-8"><cfinput type="text" class="form-control" id="ExpenseAmount" name="ExpenseAmount" required="no"></div>
										<!--- <div align="center" class="alert-box notice">No Event Expenses have been located within the database. Please click <a href="#buildURL('eventcoord:events.addeventexpenses')#&EventID=#URL.EventID#" class="art-button">here</a> to add a new expense for this event.</div> --->
								</td>
							</tr>
						</tbody>
					</cfif>
					</cfif>
				</cfif>
			</table>
		</div>
		<div class="panel-footer">
			<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Listing">
			<cfif isDefined("URL.UserAction")>
				<cfif URL.UserAction EQ "UpdateExpense">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Expenses"><br /><br />
				<cfelse>
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Enter Revenue">
					<br /><br />
				</cfif>
			<cfelse>
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Enter Revenue">
				<br /><br />
			</cfif>
		</div>
		</cfform>
	</div>
</cfoutput>