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
		<div class="panel-heading"><h1>Available Event Expenses</h1></div>
		<div class="panel-body">
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="GroupCreated">
						<cfif URL.Successful EQ "true">
							<div class="alert alert-success">
								You have successfully created a new group that you will be able to put subscribers into.
							</div>
						<cfelse>
							<div class="alert alert-danger">
								An error has occurred and the group information was not added to the database.
							</div>
						</cfif>
					</cfcase>
				</cfswitch>
			</cfif>
			<table id="jqGrid"></table>
			<div id="jqGridPager"></div>
			<div id="dialog" title="Feature not supported" style="display:none"><p>That feature is not supported.</p></div>
		</div>
		<div class="panel-footer">

		</div>
	</div>
	<script type="text/javascript">
		$(document).ready(function () {
			var selectedRow = 0;
			$("##jqGrid").jqGrid({
				url: "/plugins/#rc.pc.getPackage()#/eventcoord/controllers/events.cfc?method=getAllEventExpenses",
				// we set the changes to be made at client side using predefined word clientArray
				datatype: "json",
				colNames: ["Rec No","Expense Name","Active","DateCreated","lastUpdated"],
				colModel: [
					{ label: 'Rec ##', name: 'TContent_ID', width: 75, key: true, editable: false },
					{ label: 'Expense Name', name: 'Expense_Name', editable: true },
					{ label: 'Active', name: 'Active', width: 75, editable: true },
					{ label: 'Date Created', name: 'dateCreated', width: 75, editable: true },
					{ label: 'Last Updated', name: 'lastUpdated', width: 75, editable: true }
				],
				sortname: 'TContent_ID',
				sortorder : 'asc',
				viewrecords: true,
				height: 500,
				autowidth: true,
				rowNum: 30,
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
			$('##jqGrid').navGrid('##jqGridPager', {edit: false, add: false, del:false, search:false});

			$('##jqGrid').navButtonAdd('##jqGridPager',
				{
					caption: "",
					buttonicon: "glyphicon-plus",
					onClickButton: function(id) {
						var urlToGo = "http://" + window.location.hostname + "#cgi.script_name#" + "#cgi.path_info#?#rc.pc.getPackage()#action=eventcoord:events.addeventexpense";
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
							alert("Please Select a Row to edit an Expense in the database");
						} else {
							var grid = $('##jqGrid');
							var RowIDValue = grid.getCell(selectedRow, 'TContent_ID');
							var urlToGo = "http://" + window.location.hostname + "#cgi.script_name#" + "#cgi.path_info#?#rc.pc.getPackage()#action=eventcoord:events.editeventexpense&ExpenseID="+ RowIDValue;
							window.open(urlToGo,"_self");
						}
						},
					position: "last"
				}
			)
		});
	</script>
</cfoutput>