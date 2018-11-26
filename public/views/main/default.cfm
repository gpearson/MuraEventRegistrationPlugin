<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2016 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
	<cfscript>
		request.layout = true;
	</cfscript>
</cfsilent>
<cfoutput>
	<cfif isDefined("URL.SentInquiry")>
		<cfswitch expression="#URL.SentInquiry#">
			<cfcase value="True">
				<div class="panel panel-success">
					<div class="panel-heading"><h3>Your Inquiry has been sent</h3></div>
					<div class="panel-body alert alert-success">
						<p>Your Inquiry has been sent to someone that is able to answer it. Depending on your contact method, you should receive a repsonse to your inquiry within 3 business days.</p>
					</div>
				</div>
			</cfcase>
			<cfcase value="False">

			</cfcase>
		</cfswitch>
	</cfif>
	<div class="panel panel-default">
		<div class="panel-heading"><h3>Available Events</h3></div>
		<div class="panel-body">
		</div>
	</div>
</cfoutput>