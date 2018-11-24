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

	<cffunction name="addorganization" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and not isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.UserSuppliedInfo.MemberOrganization = StructNew()>
			</cflock>
		</cfif>

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.UserSuppliedInfo.MemberOrganization = StructNew()>
			</cflock>

			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif isDefined("FORM.OrganizationName")><cfset Session.UserSuppliedInfo.MemberOrganization.OrganizationName = #FORM.OrganizationName#></cfif>
				<cfif isDefined("FORM.OrganizationDomainName")><cfset Session.UserSuppliedInfo.MemberOrganization.OrganizationDomainName = #FORM.OrganizationDomainName#></cfif>
				<cfif isDefined("FORM.StateDOE_IDNumber")><cfset Session.UserSuppliedInfo.MemberOrganization.StateDOE_IDNumber = #FORM.StateDOE_IDNumber#></cfif>
				<cfif isDefined("FORM.Active")><cfset Session.UserSuppliedInfo.MemberOrganization.Active = #FORM.Active#></cfif>
			</cflock>

			<cfif LEN(FORM.OrganizationDomainName) EQ 0>
				<cfscript>
					eventdate = {property="OrganizationDomainName",message="Please enter the domain name for this Member Organization. Enter everything after the @ sign in a member's organization email address.'"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
			</cfif>

			<cfif LEN(FORM.OrganizationName) EQ 0>
				<cfscript>
					eventdate = {property="OrganizationName",message="Please enter the name for the Member Organization"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
			</cfif>

			<cfif LEN(FORM.StateDOE_IDNumber) EQ 0>
				<cfscript>
					eventdate = {property="StateDOE_IDNumber",message="Please enter the State Assigned ID Number for the Member Organization"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
			</cfif>

			<cfif ArrayLen(Session.FormErrors) EQ 0>
				<cfquery name="insertNewOrganization" result="insertRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Insert into eMembership(Site_ID, OrganizationName, OrganizationDomainName, Active, dateCreated, lastUpdateBy, lastUpdated, StateDOE_IDNumber)
					Values("#rc.$.siteConfig('siteID')#", "#Session.UserSuppliedInfo.MemberOrganization.OrganizationName#", "#Session.UserSuppliedInfo.MemberOrganization.OrganizationDomainName#", #Session.UserSuppliedInfo.MemberOrganization.Active#, #Now()#, "#Session.Mura.UserID#", #Now()#, "#Session.UserSuppliedInfo.MemberOrganization.StateDOE_IDNumber#")
				</cfquery>
			</cfif>

			<cfif ArrayLen(Session.FormErrors)>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addorganization&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership&UserAction=AddedOrganization&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
			</cfif>

		</cfif>
	</cffunction>

	<cffunction name="updateorganization_deactivate" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and not isDefined("FORM.PerformAction") and isDefined("URL.OrgID")>
			<cfquery name="getSelectedOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, OrganizationName, OrganizationDomainName, Active, dateCreated, lastUpdateBy, lastUpdated
				From eMembership
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.OrgID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif getSelectedOrganization.RecordCount>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset Session.UserSuppliedInfo.MemberOrganization = StructNew()>
					<cfset Session.UserSuppliedInfo.MemberOrganization.OrganizationName = #getSelectedOrganization.OrganizationName#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.OrganizationDomainName = #getSelectedOrganization.OrganizationDomainName#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.Active = #getSelectedOrganization.Active#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.dateCreated = #getSelectedOrganization.dateCreated#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.lastUpdateBy = #getSelectedOrganization.lastUpdateBy#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.lastUpdated = #getSelectedOrganization.lastUpdated#>
				</cflock>
			<cfelse>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			</cfif>

		</cfif>

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cfif isNumeric(FORM.OrgID)>
				<cftry>
					<cfquery name="DeActivateOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eMembership
						Set Active = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="CF_SQL_VARCHAR">
						Where TContent_ID = <cfqueryparam value="#FORM.OrgID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfcatch type="database">
						<cfdump var="#cfcatch#">
						<cfabort>
					</cfcatch>
				</cftry>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership&UserAction=DeactivatedOrganization&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateorganization_activate" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and not isDefined("FORM.PerformAction") and isDefined("URL.OrgID")>
			<cfquery name="getSelectedOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, OrganizationName, OrganizationDomainName, Active, dateCreated, lastUpdateBy, lastUpdated
				From eMembership
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.OrgID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif getSelectedOrganization.RecordCount>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset Session.UserSuppliedInfo.MemberOrganization = StructNew()>
					<cfset Session.UserSuppliedInfo.MemberOrganization.OrganizationName = #getSelectedOrganization.OrganizationName#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.OrganizationDomainName = #getSelectedOrganization.OrganizationDomainName#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.Active = #getSelectedOrganization.Active#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.dateCreated = #getSelectedOrganization.dateCreated#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.lastUpdateBy = #getSelectedOrganization.lastUpdateBy#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.lastUpdated = #getSelectedOrganization.lastUpdated#>
				</cflock>
			<cfelse>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			</cfif>

		</cfif>

		<cfif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cfif isNumeric(FORM.OrgID)>
				<cftry>
					<cfquery name="ActivateOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						Update eMembership
						Set Active = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,
							lastUpdated = #Now()#,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="CF_SQL_VARCHAR">
						Where TContent_ID = <cfqueryparam value="#FORM.OrgID#" cfsqltype="cf_sql_integer">
					</cfquery>
					<cfcatch type="database">
						<cfdump var="#cfcatch#">
						<cfabort>
					</cfcatch>
				</cftry>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership&UserAction=ActivatedOrganization&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="updateorganization" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit") and not isDefined("FORM.PerformAction") and isDefined("URL.OrgID")>
			<cfquery name="getSelectedOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, OrganizationName, OrganizationDomainName, Active, dateCreated, lastUpdateBy, lastUpdated, StateDOE_IDNUmber
				From eMembership
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
					TContent_ID = <cfqueryparam value="#URL.OrgID#" cfsqltype="cf_sql_integer">
			</cfquery>
			<cfif getSelectedOrganization.RecordCount>
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset Session.UserSuppliedInfo.MemberOrganization = StructNew()>
					<cfset Session.UserSuppliedInfo.MemberOrganization.OrganizationName = #getSelectedOrganization.OrganizationName#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.OrganizationDomainName = #getSelectedOrganization.OrganizationDomainName#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.Active = #getSelectedOrganization.Active#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.StateDOE_IDNumber = #getSelectedOrganization.StateDOE_IDNUmber#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.dateCreated = #getSelectedOrganization.dateCreated#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.lastUpdateBy = #getSelectedOrganization.lastUpdateBy#>
					<cfset Session.UserSuppliedInfo.MemberOrganization.lastUpdated = #getSelectedOrganization.lastUpdated#>
				</cflock>
			<cfelse>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			</cfif>
		<cfelseif isDefined("FORM.formSubmit") and isDefined("FORM.PerformAction")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormData = #StructCopy(FORM)#>
				<cfset Session.FormErrors = #ArrayNew()#>
			</cflock>
			<cfset UpdateInfo = #StructNew()#>
			<cfparam name="UpdateInfo.NameUpdated" type="boolean" default="0">
			<cfparam name="UpdateInfo.DomainNameUpdated" type="boolean" default="0">
			<cfparam name="UpdateInfo.StateDOEIDNumberUpdated" type="boolean" default="0">
			<cfparam name="UpdateInfo.ActiveUpdated" type="boolean" default="0">


			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfif FORM.OrganizationName NEQ Session.UserSuppliedInfo.MemberOrganization.OrganizationName><cfset UpdateInfo.NameUpdated = 1></cfif>
				<cfif FORM.OrganizationDomainName NEQ Session.UserSuppliedInfo.MemberOrganization.OrganizationDomainName><cfset UpdateInfo.DomainNameUpdated = 1></cfif>
				<cfif FORM.Active NEQ Session.UserSuppliedInfo.MemberOrganization.Active><cfset UpdateInfo.ActiveUpdated = 1></cfif>
				<cfif FORM.StateDOE_IDNumber NEQ Session.UserSuppliedInfo.MemberOrganization.StateDOE_IDNumber><cfset UpdateInfo.StateDOEIDNumberUpdated = 1></cfif>
			</cflock>

			<cfif UpdateInfo.DomainNameUpdated EQ 1>
				<cfif LEN(FORM.OrganizationDomainName) EQ 0>
					<cfscript>
						eventdate = {property="OrganizationDomainName",message="Please enter the domain name for this Member Organization. Enter everything after the @ sign in a member's organization email address.'"};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
				</cfif>
			</cfif>

			<cfif UpdateInfo.NameUpdated EQ 1>
				<cfif LEN(FORM.OrganizationName) EQ 0>
					<cfscript>
						eventdate = {property="OrganizationName",message="Please enter the name for the Member Organization"};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
				</cfif>
			</cfif>

			<cfif UpdateInfo.StateDOEIDNumberUpdated EQ 1>
				<cfif LEN(FORM.StateDOE_IDNumber) EQ 0>
					<cfscript>
						eventdate = {property="StateDOE_IDNumber",message="Please enter the State Assigned ID Number for the Member Organization"};
						arrayAppend(Session.FormErrors, eventdate);
					</cfscript>
				</cfif>
			</cfif>



			<cfif UpdateInfo.NameUpdated EQ 0 and  UpdateInfo.DomainNameUpdated EQ 0 and UpdateInfo.ActiveUpdated EQ 0 and UpdateInfo.StateDOEIDNumberUpdated EQ 0>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership&SiteID=#rc.$.siteConfig('siteID')#" addtoken="false">
			<cfelse>
				<cftry>
					<cfif UpdateInfo.NameUpdated EQ 1>
						<cfquery name="updateOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eMembership
							Set OrganizationName = <cfqueryparam value="#FORM.OrganizationName#" cfsqltype="cf_sql_varchar">,
								lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
								lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
								TContent_ID = <cfqueryparam value="#URL.OrgID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfif  UpdateInfo.DomainNameUpdated EQ 1>
						<cfquery name="updateOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eMembership
							Set OrganizationDomainName = <cfqueryparam value="#FORM.OrganizationDomainName#" cfsqltype="cf_sql_varchar">,
							lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
								TContent_ID = <cfqueryparam value="#URL.OrgID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfif UpdateInfo.ActiveUpdated EQ 1>
						<cfquery name="updateOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eMembership
							Set Active = <cfqueryparam value="#FORM.Active#" cfsqltype="cf_sql_bit">,
							lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
								TContent_ID = <cfqueryparam value="#URL.OrgID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfif UpdateInfo.StateDOEIDNumberUpdated EQ 1>
						<cfquery name="updateOrganization" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							Update eMembership
							Set StateDOE_IDNUmber = <cfqueryparam value="#FORM.StateDOE_IDNumber#" cfsqltype="cf_sql_varchar">,
							lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">
							Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar"> and
								TContent_ID = <cfqueryparam value="#URL.OrgID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>

					<cfcatch type="database"><cfdump var="#CFCatch#"><cfabort></cfcatch>
				</cftry>
				<cflocation url="?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership&UserAction=UpdatedOrganization&SiteID=#rc.$.siteConfig('siteID')#&Successful=true" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

</cfcomponent>
