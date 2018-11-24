<cfsilent>
<!---

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

<cfset GetAllUserGroups = #$.getBean( 'userManager' ).getUserGroups( rc.$.siteConfig('siteID'), 1 )#>

--->
</cfsilent>
<cfoutput>
	<h2>Welcome back, #Session.Mura.FName# #Session.Mura.LName#</h2>
	<p>Please click on one of the navigation menu items above to proceed with your task regarding this system.</p>
</cfoutput>