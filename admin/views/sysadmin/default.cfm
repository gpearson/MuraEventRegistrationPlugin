<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>

<cflock timeout="60" scope="SESSION" type="Exclusive">
	<cfset Session.FormData = #StructNew()#>
	<cfset Session.FormErrors = #ArrayNew()#>
	<cfset Session.UserSuppliedInfo = #structNew()#>
</cflock>

<cfoutput>
	<br />
	<h2>System Administration Tools</h2>
	<p>Below are links to procedures that only a system administrator can perform.</p>
	<p><table class="art-article" style="width:100%;">
		<tbody>
			<tr>
				<td><a href="">CSV Data Import</a></td>
				<td><a href="/plugins/EventRegistration/index.cfm?EventRegistrationaction=admin:sysadmin.yearendreport">Year End Report</a></td>
			</tr>
		</tbody>
	</table></p>
</cfoutput>