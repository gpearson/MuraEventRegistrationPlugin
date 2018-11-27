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
	<cfif not isDefined("URL.FormRetry") and not isDefined("URL.EventRecID")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<cfif isDefined("URL.UserAction")>
					<cfswitch expression="#URL.UserAction#">
						<cfcase value="ExpenseDeleted">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Event Expense Deleted</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have deleted an existing event expense successfully.</p>
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
						<cfcase value="ExpenseUpdated">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Event Expense Updated</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have updated and existing event expense successfully.</p>
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
						<cfcase value="ExpenseAdded">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>Event Expense Added</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have added an event expense successfully.</p>
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
				<div class="panel-body">
					<fieldset>
						<legend><h2>Event Expenses - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<cfif Session.getEventExpenses.RecordCount>
						<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
					<cfelse>
						<table class="table" width="100%" cellspacing="0" cellpadding="0">
					</cfif>
					<thead>
						<tr>
							<td width="50%" style="Font-Family: Arial; Font-Size: 12px;">Expense Name</td>
							<td width="15%" style="Font-Family: Arial; Font-Size: 12px;">Cost</td>
							<td style="Font-Family: Arial; Font-Size: 12px;">Actions</td>
						</tr>
					</thead>
					<cfif Session.getEventExpenses.RecordCount>
						<tfoot>
							<tr>
								<td colspan="3">
									<div class="form-group"><hr><h2>Add New Event Expense</h2>
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
							<cfloop query="Session.getEventExpenses">
								<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
									<td width="50%">#Session.getEventExpenses.Expense_Name#</td>
									<td width="15%">#DollarFormat(Session.getEventExpenses.Cost_Amount)#</td>
									<td><cfif Session.getEventExpenses.Cost_Verified EQ 0><A href="#buildURL('eventcoordinator:events.enterexpenses')#&EventID=#URL.EventID#&EventRecID=#Session.getEventExpenses.TContent_ID#&UserAction=UpdateExpense" class="btn btn-primary">Update</a> <A href="#buildURL('eventcoordinator:events.enterexpenses')#&EventID=#URL.EventID#&EventRecID=#Session.getEventExpenses.TContent_ID#&UserAction=DeleteExpense" class="btn btn-primary">Delete</a></cfif></td>
								</tr>
							</cfloop>
						</tbody>
					<cfelse>
						<tbody>
							<tr>
								<td colspan="3"><hr><h2>Add New Event Expense</h2>
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
					</table>
					<p class="alert alert-info">When all expenses for this event have been entered and the amounts verified, click the All Expenses Entered Button below. Otherwise click the Back to Events Menu button until all expenses have been recorded for this event.</p>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Events Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Expenses Entered and Verified"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry") and not isDefined("URL.EventRecID")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
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
						<legend><h2>Event Expenses - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<cfif not isDefined("URL.UserAction")>
						<cfif Session.getEventExpenses.RecordCount>
							<table class="table table-striped" width="100%" cellspacing="0" cellpadding="0">
						<cfelse>
							<table class="table" width="100%" cellspacing="0" cellpadding="0">
						</cfif>
						<thead>
							<tr>
								<td width="50%" style="Font-Family: Arial; Font-Size: 12px;">Expense Name</td>
								<td width="15%" style="Font-Family: Arial; Font-Size: 12px;">Cost</td>
								<td style="Font-Family: Arial; Font-Size: 12px;">Actions</td>
							</tr>
						</thead>
						<cfif Session.getEventExpenses.RecordCount>
							<tfoot>
								<tr>
									<td colspan="3">
										<div class="form-group"><hr><h2>Add New Event Expense</h2>
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
								<cfloop query="Session.getEventExpenses">
								<tr bgcolor="###iif(currentrow MOD 2,DE('ffffff'),DE('efefef'))#">
									<td width="50%">#Session.getEventExpenses.Expense_Name#</td>
									<td width="15%">#DollarFormat(Session.getEventExpenses.Cost_Amount)#</td>
									<td><cfif Session.getEventExpenses.Cost_Verified EQ 0><A href="#buildURL('eventcoordinator:events.enterexpenses')#&EventID=#URL.EventID#&EventRecID=#Session.getEventExpenses.TContent_ID#&UserAction=UpdateExpense" class="btn btn-primary">Update</a> <A href="#buildURL('eventcoordinator:events.enterexpenses')#&EventID=#URL.EventID#&EventRecID=#Session.getEventExpenses.TContent_ID#&UserAction=DeleteExpense" class="btn btn-primary">Delete</a></cfif></td>
								</tr>
							</cfloop>
							</tbody>
						<cfelse>
							<tbody>
								<tr>
									<td colspan="3"><hr><h2>Add New Event Expense</h2>
										<div class="form-group">
											<label for="ExpenseName" class="control-label col-sm-1">Type:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star"></label>
											<div class="col-sm-4">
												<cfselect name="ExpenseID" class="form-control" Required="Yes" Multiple="No" query="Session.getAvailableExpenseList" selected="#Session.FormInput.ExpenseID#" value="TContent_ID" Display="Expense_Name"  queryposition="below">
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
						</table>
					</cfif>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Events Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Expenses Entered and Verified"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif not isDefined("URL.FormRetry") and isDefined("URL.EventRecID")>
		<cfswitch expression="#URL.UserAction#">
			<cfcase value="DeleteExpense">
				<cfquery name="deleteSelectedEventExpense" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Delete From p_EventRegistration_EventExpenses
					Where TContent_ID = <cfqueryparam value="#URL.EventRecID#" cfsqltype="cf_sql_integer">
				</cfquery>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.enterexpenses&EventID=#URL.EventID#&UserAction=ExpenseDeleted&Successful=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:events.enterexpenses&EventID=#URL.EventID#&UserAction=ExpenseDeleted&Successful=True">
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfcase>
			<cfcase value="UpdateExpense">
				<div class="panel panel-default">
					<cfform action="" method="post" id="AddEvent" class="form-horizontal">
						<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
						<cfinput type="hidden" name="EventID" value="#URL.EventID#">
						<cfinput type="hidden" name="EventRecID" value="#URL.EventRecID#">
						<cfinput type="hidden" name="formSubmit" value="true">
						<div class="panel-body">
							<fieldset>
								<legend><h2>Event Expenses - #Session.getSelectedEvent.ShortTitle#</h2></legend>
							</fieldset>
							<div class="form-group">
								<label for="ExpenseName" class="col-lg-5 col-md-5">Expense Name:&nbsp;</label>
								<div class="col-lg-7 form-control-static">#Session.getSelectedEventExpense.Expense_Name#</div>
							</div>
							<div class="form-group">
								<label for="ExpenseAmount" class="col-lg-5 col-md-5">Amount:&nbsp;<span style="Color: Red;" class="glyphicon glyphicon-star" /></label>
								<div class="col-lg-7"><cfinput type="text" class="form-control" id="ExpenseAmount" name="ExpenseAmount" Value="#NumberFormat(Session.getSelectedEventExpense.Cost_Amount, '999999.99')#" required="no"></div>
							</div>
						</div>
						<div class="panel-footer">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Expenses">
							<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Expense"><br /><br />
						</div>
					</cfform>
				</div>
			</cfcase>
		</cfswitch>
	</cfif>
</cfoutput>