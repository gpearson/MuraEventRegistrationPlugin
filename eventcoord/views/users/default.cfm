<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<script>
		$.jgrid.defaults.responsive = true;
		$.jgrid.defaults.styleUI = 'Bootstrap';
	</script>
	<div class="panel panel-default">
		<div class="panel-body">
			<fieldset>
				<legend><h2>Available Users</h2></legend>
			</fieldset>
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="ActivatedAccount">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>User Account Activated</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully activated a users account and they are able to login to this system.</p>
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
					<cfcase value="AccountUpdated">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>User Account Updated</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully updated a users account in the database.</p>
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
					<cfcase value="AccountCreated">
						<cfif URL.Successful EQ "true">
							<div id="modelWindowDialog" class="modal fade">
								<div class="modal-dialog">
									<div class="modal-content">
										<div class="modal-header">
											<button type="button" class="close" data-dismiss="modal" aria-hidden="true"><i class="fa fa-times-circle"></i></button>
											<h3>User Account Created</h3>
										</div>
										<div class="modal-body">
											<p class="alert alert-success">You have successfully created a new user account in the database.</p>
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
			<table id="jqGrid"></table>
			<div id="jqGridPager"></div>
			<div id="dialog" title="Feature not supported" style="display:none"><p>That feature is not supported.</p></div>
		</div>
	</div>
	<script type="text/javascript">
		$(document).ready(function () {
			var selectedRow = 0;
			$("##jqGrid").jqGrid({
				url: "/plugins/#rc.pc.getPackage()#/eventcoord/controllers/users.cfc?method=getAllUsers",
				// we set the changes to be made at client side using predefined word clientArray
				datatype: "json",
				colNames: ["Rec No", "Last Name","First Name","UserName","Company","Last Login","Created","InActive"],
				colModel: [
					{ label: 'Rec ##', name: 'UserID', width: 75, key: true, hidden: true, editable: false },
					{ label: 'Last Name', name: 'LName', width: 75, editable: false },
					{ label: 'First Name', name: 'FName', width: 75, editable: false },
					{ label: 'UserName', name: 'UserName', width: 75, editable: false },
					{ label: 'Company', name: 'Company', width: 75, editable: false },
					{ label: 'Last Login', name: 'lastLogin', width: 75, editable: false },
					{ label: 'Created', name: 'Created', width: 75, editable: false },
					{ label: 'InActive', name: 'InActive', width: 75, editable: false }
				],
				sortname: 'LName',
				sortorder : 'asc',
				viewrecords: true,
				height: 500,
				autowidth: true,
				rowNum: 60,
				rowList : [20,30,50],
				rowTotal: 2000,
				pgText: " of ",
				pager: "##jqGridPager",
				jsonReader: {
					root: "ROWS",
					page: "PAGE",
					total: "TOTAL",
					records: "RECORDS",
					cell: "",
					id: "0"
				},
				onSelectRow: function(id){
					//We verify a valid new row selection
					if(id && id!==selectedRow) {
						//If a previous row was selected, but the values were not saved, we restore it to the original data.
						$('##jqGrid').restoreRow(selectedRow);
						selectedRow=id;
					}
				}
			});
			$('##jqGrid').navGrid('##jqGridPager', {edit: false, add: false, del:false, search:true});

			$('##jqGrid').navButtonAdd('##jqGridPager',
				{
					caption: "",
					buttonicon: "glyphicon-plus",
					onClickButton: function(id) {
						var urlToGo = "http://" + window.location.hostname + "#cgi.script_name#" + "#cgi.path_info#?#rc.pc.getPackage()#action=eventcoord:users.adduser";
						window.open(urlToGo,"_self");
					},
					position: "last"
				}
			)

			$('##jqGrid').navButtonAdd('##jqGridPager',
				{
					caption: "",
					buttonicon: "glyphicon-pencil",
					onClickButton: function(id) {
						if (selectedRow == 0) {
							alert("Please Select a Row first then the Edit Icon to make changes to a Users Account");
						} else {
							var grid = $('##jqGrid');
							var RowIDValue = grid.getCell(selectedRow, 'UserID');
							var urlToGo = "http://" + window.location.hostname + "#cgi.script_name#" + "#cgi.path_info#?#rc.pc.getPackage()#action=eventcoord:users.edituser&UserID="+ RowIDValue;
							window.open(urlToGo,"_self");
						}
						},
					position: "last"
				}
			)
		});
	</script>
</cfoutput>