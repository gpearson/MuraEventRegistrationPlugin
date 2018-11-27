/*

This file is part of MuraFW1

Copyright 2010-2016 Stephen J. Withington, Jr.
Licensed under the Apache License, Version v2.0
http://www.apache.org/licenses/LICENSE-2.0

*/
<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfquery name="SiteConfigSettings" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
			From p_EventRegistration_SiteConfig
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>


		<cfif isDefined("URL.ShortURL")>
			<cfquery name="GetFullLinkFromShortURL" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select FullLink
				From p_EventRegistration_ShortURL
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> and
					ShortLink = <cfqueryparam value="#URL.ShortURL#" cfsqltype="cf_sql_varchar"> and
					Active = <cfqueryparam cfsqltype="cf_sql_bit" value="1">
			</cfquery>

			<cfif GetFullLinkFromShortURL.RecordCount>
				<cfquery name="UpdateShortURLAccess" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					Update p_EventRegistration_ShortURL
					Set Active = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam value="System" cfsqltype="cf_sql_varchar">,
						lastUpdateByID = <cfqueryparam value="System" cfsqltype="cf_sql_varchar">
					Where ShortLink = <cfqueryparam value="#URL.ShortURL#" cfsqltype="cf_sql_varchar">
				</cfquery>
				<cflocation url="#GetFullLinkFromShortURL.FullLink#" addtoken="false">
			<cfelse>
				<cfscript>
					errormsg = {property="EmailMsg",message="The ShortLink is either invalid or is not active because someone else has clicked on the link to change the status of the Short Link. Please check your email and if you have issues please utilize the Contact Us section of the website."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=ShortLinkInvalid" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=public:main.default&UserAction=ShortLinkInvalid" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>
</cfcomponent>