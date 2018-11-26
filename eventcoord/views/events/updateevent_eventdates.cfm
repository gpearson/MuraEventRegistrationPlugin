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
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate" name="EventDate" value="#DateFormat(Session.getSelectedEvent.EventDate, 'mm/dd/yyyy')#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate1" class="control-label col-sm-3">Second Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#DateFormat(Session.getSelectedEvent.EventDate1, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventDate2" class="control-label col-sm-3">Third Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#DateFormat(Session.getSelectedEvent.EventDate2, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventDate3" class="control-label col-sm-3">Fourth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#DateFormat(Session.getSelectedEvent.EventDate3, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventDate4" class="control-label col-sm-3">Fifth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#DateFormat(Session.getSelectedEvent.EventDate4, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventDate5" class="control-label col-sm-3">Sixth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate5" name="EventDate5" value="#DateFormat(Session.getSelectedEvent.EventDate5, 'mm/dd/yyyy')#" required="no"></div>
					</div>
				</div>
				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Review">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	<cfelseif isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#Session.FormData.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<fieldset>
						<legend><h2>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h2></legend>
					</fieldset>
					<div class="form-group">
						<label for="EventDate" class="control-label col-sm-3">Primary Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate" name="EventDate" value="#DateFormat(Session.getSelectedEvent.EventDate, 'mm/dd/yyyy')#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="EventDate1" class="control-label col-sm-3">Second Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate1" name="EventDate1" value="#DateFormat(Session.getSelectedEvent.EventDate1, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventDate2" class="control-label col-sm-3">Third Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate2" name="EventDate2" value="#DateFormat(Session.getSelectedEvent.EventDate2, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventDate3" class="control-label col-sm-3">Fourth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate3" name="EventDate3" value="#DateFormat(Session.getSelectedEvent.EventDate3, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventDate4" class="control-label col-sm-3">Fifth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate4" name="EventDate4" value="#DateFormat(Session.getSelectedEvent.EventDate4, 'mm/dd/yyyy')#" required="no"></div>
					</div>
					<div class="form-group">
						<label for="EventDate5" class="control-label col-sm-3">Sixth Event Date:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="EventDate5" name="EventDate5" value="#DateFormat(Session.getSelectedEvent.EventDate5, 'mm/dd/yyyy')#" required="no"></div>
					</div>
				</div>

				<div class="panel-footer">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Event Review">
					<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Update Event Section"><br /><br />
				</div>
			</cfform>
		</div>
	</cfif>
</cfoutput>
