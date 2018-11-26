<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2015 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-body">
			<fieldset>
				<legend><h2>Welcome #Session.Mura.FName# #Session.Mura.LName# (Event Facilitator)</h2></legend>
			</fieldset>
			<div>Please use the navigation toolbar above to complete the task you logged in to do.</div>
			<cfif isDefined("URL.UserAction")>
				<cfswitch expression="#URL.UserAction#">
					<cfcase value="EventAdded">
						<cfif URL.Successful EQ "False">
							<cfif ArrayLen(Session.FormErrors) GTE 1>
								<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
							</cfif>
						</cfif>
					</cfcase>
					<cfcase value="EventCopied">
						<cfif URL.Successful EQ "False">
							<cfif ArrayLen(Session.FormErrors) GTE 1>
								<div class="alert alert-danger"><p>#Session.FormErrors[1].Message#</p></div>
								<cfdump var="#Session.FormErrors#">
							</cfif>
						</cfif>
					</cfcase>
				</cfswitch>
			</cfif>
		</div>
	</div>
</cfoutput>