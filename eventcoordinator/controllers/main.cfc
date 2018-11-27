<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">
		<cfquery name="SiteConfigSettings" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, ProcessPayments_Stripe, Stripe_TestMode, Stripe_testAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, Google_ReCaptchaEnabled, Google_ReCaptchaSiteKey, Google_ReCaptchaSecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, BillForNoShowRegistrations, RequireEventSurveyToGetCertificate
				From p_EventRegistration_SiteConfig
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>
	</cffunction>
</cfcomponent>