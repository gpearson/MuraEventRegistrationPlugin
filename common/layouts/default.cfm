<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

--->
<cfparam name="EventCoordinatorRole" default="0" type="boolean">
<cfparam name="EventPresenterRole" default="0" type="boolean">

<!--- <cfif Session.Mura.IsLoggedIn EQ "True">
	<!--- <cfif ListGetAt(GetAuthUser(), 5, "^") EQ "admin">
		<cflocation url="/plugins/EventRegistration/" addtoken="false">
	</cfif> --->
</cfif> --->

<!--- Section of Code is for when a user submits an inquiry successfully it will display a message. --->
<cfif isDefined("URL.CancelRegistrationSuccessfull")>
	<cfif URL.CancelRegistrationSuccessfull EQ "true">
		<cfif isDefined("URL.SingleRegistration")>
			<cfif URL.SingleRegistration EQ "true">
				<cfoutput>
					<div class="alert-box success">Your have successfully cancelled this registration. Within the next few minutes you will receive an email confirmation regarding the cancellation of this registration.</div>
				</cfoutput>
			</cfif>
		</cfif>
	</cfif>
</cfif>
<cfoutput>
	#body#
</cfoutput>