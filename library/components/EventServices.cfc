<cfcomponent>
	<cffunction name="generateShortLink" returntype="string">
		<cfargument name="length" type="Numeric" required="true" default="6">
		<cfset var local=StructNew()>

		<!--- create a list of all allowable characters for our short URL link --->
		<cfset local.chars="A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z,0,1,2,3,4,5,6,7,8,9,-">
		<!--- our radix is the total number of possible characters --->
		<cfset local.radix=listlen(local.chars)>
		<!--- initialise our return variable --->
		<cfset local.shortlink="">

		<!--- loop from 1 until the number of characters our URL should be, adding a random character from our master list on each iteration  --->
		<cfloop from="1" to="#arguments.length#" index="i">
			<!--- generate a random number in the range of 1 to the total number of possible characters we have defined --->
			<cfset local.randnum=RandRange(1,local.radix)>
			<!--- add the character from a random position in our list to our short link --->
			<cfset local.shortlink=local.shortlink & listGetAt(local.chars,local.randnum)>
		</cfloop>

		<!--- return the generated random short link --->
		<cfreturn local.shortlink>
	</cffunction>

	<cffunction name="insertShortURLContent" returntype="any">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="link" type="String" required="true">
		<cfset var result=StructNew()>

		<!--- begin our error-catching block --->
		<cftry>
			<!--- try to insert the new link into the database --->
			<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="result.qry" result="result.stats">
				INSERT INTO p_EventRegistration_ShortURL(Site_ID, FullLink, ShortLink, Active, dateCreated, lastUpdated)
				VALUES(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.link#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#generateShortLink()#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
			</cfquery>

			<!--- try to return the new shortlink value, referencing the last returned identifier --->
			<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="result.inserted">
				SELECT ShortLink
				FROM p_EventRegistration_ShortURL
				WHERE
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result.stats.GENERATED_KEY#">
			</cfquery>

			<cfcatch>
				<!--- insert was not successful - the shortlink generated was not unqiue, so set the return variable to an empty string --->
				<cfset result.inserted.cfdump = #CFCATCH#>
				<cfset result.inserted.shortlink="">
				<cfreturn result.inserted>
			</cfcatch> 
		</cftry>		

		<!--- return either the newly created shortlink, or an empty string if an error occurred --->
		<cfreturn result.inserted.ShortLink> 
	</cffunction>
	
	<cffunction name="getFullLinkFromShortURL" returntype="string">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfargument name="shortlink" type="string" required="true">
		<cfset var result="">
		<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#" name="result">
			SELECT TContent_ID, FullLink
			FROM p_EventRegistration_ShortURL
			WHERE ShortLink = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.shortlink#"> and Active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
		</cfquery>

		<cfif Result.RecordCount>
			<cfquery Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Update p_EventRegistration_ShortURL
				Set Active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
					LastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#result.TContent_ID#">
			</cfquery>
			<cfreturn result.FullLink>
		<cfelse>
			<cfreturn "The ShortURL Link is not valid">
		</cfif>
	</cffunction>
</cfcomponent>