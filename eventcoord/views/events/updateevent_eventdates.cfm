<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

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
	<script>
		$(function() {
			$("##EventDate").datepicker();
			$("##EventDate1").datepicker();
			$("##EventDate2").datepicker();
			$("##EventDate3").datepicker();
			$("##EventDate4").datepicker();
			$("##EventDate5").datepicker();
		});
	</script>
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#Session.getSelectedEvent.Registration_Deadline#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate1" class="control-label col-sm-3">Second Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#Session.getSelectedEvent.EventDate1#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate2" class="control-label col-sm-3">Third Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#Session.getSelectedEvent.EventDate2#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate3" class="control-label col-sm-3">Fourth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#Session.getSelectedEvent.EventDate3#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate4" class="control-label col-sm-3">Fifth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#Session.getSelectedEvent.EventDate4#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate5" class="control-label col-sm-3">Sixth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate5" name="EventDate5" value="#Session.getSelectedEvent.EventDate5#" required="yes"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#Session.FormData.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="Registration_Deadline" name="Registration_Deadline" value="#Session.getSelectedEvent.Registration_Deadline#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate1" class="control-label col-sm-3">Second Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#Session.getSelectedEvent.EventDate1#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate2" class="control-label col-sm-3">Third Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#Session.getSelectedEvent.EventDate2#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate3" class="control-label col-sm-3">Fourth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#Session.getSelectedEvent.EventDate3#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate4" class="control-label col-sm-3">Fifth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#Session.getSelectedEvent.EventDate4#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate5" class="control-label col-sm-3">Sixth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate5" name="EventDate5" value="#Session.getSelectedEvent.EventDate5#" required="yes"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
