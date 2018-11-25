/*

This file is part of MuraFW1

Copyright 2010-2013 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
	</cffunction>
	
	<cffunction name="GetRoles" returntype="any" output="false">
		<cfargument name="RoleName" required="true" type="string" default="">
		<cfquery name="GetRole" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select UserID From tusers
			Where GroupName = <cfqueryparam value="#Arguments.RoleName#" cfsqltype="cf_sql_varchar"> and SiteID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
		</cfquery>
		<cfreturn GetRole.UserID>		
	</cffunction>
	
</cfcomponent>
