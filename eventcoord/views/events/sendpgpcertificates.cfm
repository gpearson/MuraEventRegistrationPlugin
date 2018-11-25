<cfsilent>
<!---
This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0
--->
</cfsilent>
<cfoutput>
	<div class="panel panel-default">
		<div class="panel-heading"><h1>Send PGP Certificate to Participant who attended event titled:<br>#Session.getSelectedEvent.ShortTitle#</h1><br><p>Number of Attended Participants Receiving Certificate: #Session.EventNumberRegistrations#</p></div>
		<cfform action="" method="post" id="AddEvent" class="form-horizontal">
			<cfinput type="hidden" name="SiteID" value="#rc.$.siteConfig('siteID')#">
			<cfinput type="hidden" name="formSubmit" value="true">
			<cfinput type="hidden" name="EventID" value="#URL.EventID#">
			<div class="panel-body">
				<div class="alert alert-info"><p>PGP Certificates will be attached to the Email message sent as a PDF Document.</p></div>
				<div class="form-group">
					<label for="MsgToparticipants" class="control-label col-sm-3">Message to Attended Participants:&nbsp;</label>
					<div class="col-sm-8">
					<textarea height="15" width="250" class="form-control" id="EmailMsg" name="EmailMsg"></textarea><br>
				</div>
			</div>
		</div>
		<div class="panel-footer">
			<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-left" value="Back to Main Menu">
			<cfinput type="Submit" name="UserAction" class="btn btn-primary pull-right" value="Send PGP Certificates"><br /><br />
		</div>
	</cfform>
</div>
</cfoutput>