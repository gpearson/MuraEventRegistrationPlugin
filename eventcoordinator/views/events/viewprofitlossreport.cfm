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
		<cfform action="" method="post" id="VerifyIncomeRevenue" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#$.siteConfig('siteid')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<fieldset>
				<legend><h2>Event Profit/Loss Statement Report: #Session.getSelectedEvent.ShortTitle#</h2></legend>
			</fieldset>
						
			<div class="panel-body">
				<cfset TotalParticipants = 0>

				<table border="0" class="table table-striped" cellspacing="0" cellpadding="0" width="100%">
					<thead>
						<tr>
							<th style="font-family: Arial; font-size: 12px; text-align: left"></th>
						</tr>
					</thead>
					<tbody>
						<tr>
							<td><embed src="#Session.ReportLocation#" width="100%" height="650"></td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="5"></td>
						</tr>
					</tfoot>
				</table>
			</div>
			<div class="panel-footer">
				<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Events Menu">
				<br /><br />
			</div>
		</cfform>
	</div>
</cfoutput>