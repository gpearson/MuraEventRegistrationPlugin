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
	<cfif not isDefined("URL.FormRetry")>
		<div class="panel panel-default">
			<div class="panel-heading"><h1>Update Existing Event or Workshop - #Session.getSelectedEvent.ShortTitle#</h1></div>
			<cfform action="" method="post" id="AddEvent" class="form-horizontal">
				<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
				<cfinput type="hidden" name="EventID" value="#URL.EventID#">
				<cfinput type="hidden" name="formSubmit" value="true">
				<div class="panel-body">
					<div class="form-group">
						<label for="ShortTitle" class="control-label col-sm-3">Event Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" value="#Session.getSelectedEvent.ShortTitle#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LongDescription" class="control-label col-sm-3">Description of Event:&nbsp;</label>
						<div class="col-sm-8"><textarea name="LongDescription" id="LongDescription" class="form-control">#Session.getSelectedEvent.LongDescription#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventAgenda" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventAgenda" id="EventAgenda" class="form-control">#Session.getSelectedEvent.EventAgenda#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventTargetAudience" class="control-label col-sm-3">Target Audience of Event:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control">#Session.getSelectedEvent.EventTargetAudience#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventStrategies" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventStrategies" id="EventStrategies" class="form-control">#Session.getSelectedEvent.EventStrategies#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventSpecialInstructions" class="control-label col-sm-3">Special Instructions to Participants:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control">#Session.getSelectedEvent.EventSpecialInstructions#</textarea></div>
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
						<label for="ShortTitle" class="control-label col-sm-3">Event Title:&nbsp;</label>
						<div class="col-sm-8"><cfinput type="text" class="form-control" id="ShortTitle" name="ShortTitle" value="#Session.getSelectedEvent.ShortTitle#" required="yes"></div>
					</div>
					<div class="form-group">
						<label for="LongDescription" class="control-label col-sm-3">Description of Event:&nbsp;</label>
						<div class="col-sm-8"><textarea name="LongDescription" id="LongDescription" class="form-control">#Session.getSelectedEvent.LongDescription#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventAgenda" class="control-label col-sm-3">Event Agenda:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventAgenda" id="EventAgenda" class="form-control">#Session.getSelectedEvent.EventAgenda#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventTargetAudience" class="control-label col-sm-3">Target Audience of Event:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventTargetAudience" id="EventTargetAudience" class="form-control">#Session.getSelectedEvent.EventTargetAudience#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventStrategies" class="control-label col-sm-3">Event Strategies:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventStrategies" id="EventStrategies" class="form-control">#Session.getSelectedEvent.EventStrategies#</textarea></div>
					</div>
					<div class="form-group">
						<label for="EventSpecialInstructions" class="control-label col-sm-3">Special Instructions to Participants:&nbsp;</label>
						<div class="col-sm-8"><textarea name="EventSpecialInstructions" id="EventSpecialInstructions" class="form-control">#Session.getSelectedEvent.EventSpecialInstructions#</textarea></div>
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
