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
<cfif LEN(cgi.path_info)><cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# ><cfelse><cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action#></cfif>
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<cfform action="#Variables.newurl#=eventcoordinator:events.default" method="post" id="AddEvent" class="form-horizontal">
			<fieldset>
				<legend><h2>Event Signin Sheet: #Session.getSelectedEvent.ShortTitle#</h2></legend>
			</fieldset>
			<div class="alert alert-info">Below is the PDF Document with Registered Participants who are currently signed up for this event.</div>
			<div class="panel-body">
				<cfif Len(Session.getSelectedEvent.EventDate1) or Len(Session.getSelectedEvent.EventDate2) or Len(Session.getSelectedEvent.EventDate3) or Len(Session.getSelectedEvent.EventDate4) or Len(Session.getSelectedEvent.EventDate5) or Len(Session.getSelectedEvent.EventDate6)>
					<table class="table" width="100%" cellspacing="0" cellpadding="0">
						<tr>
							<cfif Len(Session.getSelectedEvent.EventDate1) and Len(Session.getSelectedEvent.EventDate2) EQ 0 and Len(Session.getSelectedEvent.EventDate3) EQ 0 and Len(Session.getSelectedEvent.EventDate4) EQ 0and Len(Session.getSelectedEvent.EventDate5) EQ 0 and Len(Session.getSelectedEvent.EventDate6) EQ 0>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
							<cfelseif Len(Session.getSelectedEvent.EventDate1) and Len(Session.getSelectedEvent.EventDate2) and Len(Session.getSelectedEvent.EventDate3) EQ 0 and Len(Session.getSelectedEvent.EventDate4) EQ 0 and Len(Session.getSelectedEvent.EventDate5) EQ 0 and Len(Session.getSelectedEvent.EventDate6) EQ 0>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td>
							<cfelseif Len(Session.getSelectedEvent.EventDate1) and Len(Session.getSelectedEvent.EventDate2) and Len(Session.getSelectedEvent.EventDate3) and Len(Session.getSelectedEvent.EventDate4) EQ 0 and Len(Session.getSelectedEvent.EventDate5) EQ 0 and Len(Session.getSelectedEvent.EventDate6) EQ 0>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td>
							<cfelseif Len(Session.getSelectedEvent.EventDate1) and Len(Session.getSelectedEvent.EventDate2) and Len(Session.getSelectedEvent.EventDate3) and Len(Session.getSelectedEvent.EventDate4) and Len(Session.getSelectedEvent.EventDate5) EQ 0 and Len(Session.getSelectedEvent.EventDate6) EQ 0>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=4">SignIn Sheet Day 4</a></td>
							<cfelseif Len(Session.getSelectedEvent.EventDate1) and Len(Session.getSelectedEvent.EventDate2) and Len(Session.getSelectedEvent.EventDate3) and Len(Session.getSelectedEvent.EventDate4) and Len(Session.getSelectedEvent.EventDate5) and Len(Session.getSelectedEvent.EventDate6) EQ 0>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=4">SignIn Sheet Day 4</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=5">SignIn Sheet Day 5</a></td>
							<cfelse>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=1">SignIn Sheet Day 1</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=2">SignIn Sheet Day 2</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=3">SignIn Sheet Day 3</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=4">SignIn Sheet Day 4</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=5">SignIn Sheet Day 5</a></td>
								<td><a href="#buildURL('eventcoordinator:events.generatenametags')#&EventID=#URL.EventID#&EventDatePos=6">SignIn Sheet Day 6</a></td>
							</cfif>
						</tr>
					</table>
				</cfif>
				<embed src="#Session.NameTagReport#" width="100%" height="650">
			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Return to Event Listing"><br /><br />
			</div>
		</cfform>
	</div>
</cfoutput>