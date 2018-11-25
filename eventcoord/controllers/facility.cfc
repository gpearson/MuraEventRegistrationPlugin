<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="Session.getFacilities" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
			From p_EventRegistration_Facility
			Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
			Order by FacilityName ASC
		</cfquery>
	</cffunction>

	<cffunction name="getAllFacilities" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrCaterers = ArrayNew(1)>
		<cfquery name="getFacilities" dbtype="Query">
			Select TContent_ID, FacilityName, PhysicalState, PrimaryVoiceNumber, Active
			From Session.getFacilities
			<cfif Arguments.sidx NEQ "">
				Order By #Arguments.sidx# #Arguments.sord#
			<cfelse>
				Order by FacilityName #Arguments.sord#
			</cfif>
		</cfquery>

		<!--- Calculate the Start Position for the loop query. So, if you are on 1st page and want to display 4 rows per page, for first page you start at: (1-1)*4+1 = 1.
				If you go to page 2, you start at (2-)1*4+1 = 5 --->
		<cfset start = ((arguments.page-1)*arguments.rows)+1>

		<!--- Calculate the end row for the query. So on the first page you go from row 1 to row 4. --->
		<cfset end = (start-1) + arguments.rows>

		<!--- When building the array --->
		<cfset i = 1>

		<cfloop query="getFacilities" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfif #Active# EQ 1>
				<cfset strActive = "Yes">
			<cfelse>
				<cfset strActive = "No">
			</cfif>
			<cfset arrCaterers[i] = [#TContent_ID#,#FacilityName#,#PhysicalState#,#PrimaryVoiceNumber#,#strActive#]>
			<cfset i = i + 1>
		</cfloop>

		<!--- Calculate the Total Number of Pages for your records. --->
		<cfset totalPages = Ceiling(getFacilities.recordcount/arguments.rows)>

		<!--- The JSON return.
			Total - Total Number of Pages we will have calculated above
			Page - Current page user is on
			Records - Total number of records
			rows = our data
		--->
		<cfset stcReturn = {total=#totalPages#,page=#Arguments.page#,records=#getFacilities.recordcount#,rows=arrCaterers}>
		<cfreturn stcReturn>
	</cffunction>

</cfcomponent>