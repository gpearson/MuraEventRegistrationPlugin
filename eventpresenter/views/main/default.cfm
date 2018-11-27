<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2016 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
</cfsilent>
<cfoutput>
	<cfif isDefined("URL.SiteConfigUpdated")>
		<cfswitch expression="#URL.SiteConfigUpdated#">
			<cfcase value="True">
				<div class="panel panel-default">
					<div class="panel-heading"><h3>Site Configuration Updated</h3></div>
					<div class="panel-body alert alert-success">
						<p>You have successfully updated site configuration settings of this plugin</p>
					</div>
				</div>
			</cfcase>
			<cfcase value="False">

			</cfcase>
		</cfswitch>
	</cfif>
	<h2>Event Presenter's Administration Menu</h2>
	<p>Hello there! Welcome to the Home view of the FW/1's Main section.</p>
	<p>This is just a FW/1 sub-application. You could create your own admin interface here, or simply provide instructions on how to use your plugin. It's entirely up to you.</p>
</cfoutput>
