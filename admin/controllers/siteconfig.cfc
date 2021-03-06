<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="CheckEventGroups" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select UserID, GroupName
			From tusers
			where GroupName LIKE '%Event%'
		</cfquery>

		<cfif CheckEventGroups.RecordCount EQ 0>
			<cfset EventFacilitatorGroup = #$.getBean('group').loadBy(groupname="Event Facilitator")#>
			<cfif not EventFacilitatorGroup.exists()>
				<cfset setField = EventFacilitatorGroup.setGroupName('Event Facilitator')>
				<cfset setField = EventFacilitatorGroup.setSiteID(Session.SiteID)>
				<cfset setField = EventFacilitatorGroup.setIsPublic(1)>
				<cfset setField = EventFacilitatorGroup.setType(1)>
				<cfset saveRecord = EventFacilitatorGroup.save()>
			</cfif>

			<cfset EventPresenterGroup = #$.getBean('group').loadBy(groupname="Event Presenter")#>
			<cfif not EventPresenterGroup.exists()>
				<cfset setField = EventPresenterGroup.setGroupName('Event Presenter')>
				<cfset setField = EventPresenterGroup.setSiteID(Session.SiteID)>
				<cfset setField = EventPresenterGroup.setIsPublic(1)>
				<cfset setField = EventPresenterGroup.setType(1)>
				<cfset saveRecord = EventPresenterGroup.save()>
			</cfif>
		</cfif>

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="SiteConfigSettings" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, Twitter_Enabled, Twitter_ConsumerKey, Twitter_ConsumerSecret, Twitter_AccessToken, Twitter_AccessTokenSecret, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, CFServerJarFiles
				From p_EventRegistration_SiteConfig
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
			</cfquery>
			<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "SiteConfigSettings")>
				
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:main.default" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:main.default" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.ProcessPaymentsStripe EQ "----">
				<cfset FORM.ProcessPaymentsStripe = 0>
				<cfset FORM.StripeTestMode = 1>
			<cfelseif FORM.ProcessPaymentsStripe EQ 1 and LEN(FORM.StripeTestAPIKey) EQ 0 or FORM.ProcessPaymentsStripe EQ 1 and LEN(FORM.StripeLiveAPIKey) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="If you would like to enable Stripe Processing of Payments, please enter your Stripe API Keys for both the Live Processing and the Test Processing of this payment processor."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			<cfelse>
				<cfif FORM.StripeTestMode EQ "----" and LEN(FORM.StripeTestAPIKey) EQ 0 and LEN(FORM.StripeLiveAPIKey) EQ 0>
					<cfset FORM.StripeTestMode = 1>
				<cfelseif FORM.ProcessPaymentsStripe EQ 1 and FORM.StripeTestMode EQ 1 and LEN(FORM.StripeTestAPIKey) EQ 0>
					<cfscript>
						errormsg = {property="EmailMsg",message="Please Enter the Stripe API Key for the Stripe Testing Server so you can process test payments through the stripe server."};
						arrayAppend(Session.FormErrors, errormsg);
					</cfscript>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				</cfif>
			</cfif>

			<cfif FORM.BillForNoShowRegistration EQ "----">
				<cfset FORM.BillForNoShowRegistration = 0>
			</cfif>

			<cfif FORM.RequireEventSurveyToGetCertificate EQ "----">
				<cfset FORM.RequireEventSurveyToGetCertificate = 0>
			</cfif>

			<cfif FORM.FacebookEnabled EQ "----">
				<cfset FORM.FacebookEnabled = 0>
			<cfelseif FORM.FacebookEnabled EQ 1 and LEN(FORM.FacebookAppID) EQ 0 or FORM.FacebookEnabled EQ 1 and LEN(FORM.FacebookAppSecretKey) EQ 0 or FORM.FacebookEnabled EQ 1 and LEN(FORM.FacebookPageID) EQ 0 or FORM.FacebookEnabled EQ 1 and LEN(FORM.FacebookAppScope) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Enter the Facebook Application Credientials to allow this plugin to post to the companies profile page."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.TwitterEnabled EQ "----">
				<cfset FORM.TwitterEnabled = 0>
			<cfelseif FORM.TwitterEnabled EQ 1 and LEN(FORM.TwitterConsumerKey) EQ 0 or FORM.TwitterEnabled EQ 1 and LEN(FORM.TwitterConsumerSecretKey) EQ 0 or FORM.TwitterEnabled EQ 1 and LEN(FORM.TwitterAccessToken) EQ 0 or FORM.TwitterEnabled EQ 1 and LEN(FORM.TwitterAccessTokenSecret) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Enter the Twitter Application Credientials to allow this plugin to post to the companies handle."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.GoogleReCaptchaEnabled EQ "----">
				<cfset FORM.GoogleReCaptchaEnabled = 0>
			<cfelseif FORM.GoogleReCaptchaEnabled EQ 1 and LEN(FORM.GoogleReCaptchaSiteKey) EQ 0 or FORM.GoogleReCaptchaEnabled EQ 1 and LEN(FORM.GoogleReCaptchaSecretKey) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Enter the Google Captcha Site Key and Secret Key for this to work properly."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.SmartyStreetsEnabled EQ "----">
				<cfset FORM.SmartyStreetsEnabled = 0>
			<cfelseif FORM.SmartyStreetsEnabled EQ 1 and LEN(FORM.SmartyStreetsAPIID) EQ 0 or FORM.SmartyStreetsEnabled EQ 1 and LEN(FORM.SmartyStreetsAPITOKEN) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Enter the Smarty Streets API ID and API Token from your account to enable address verification through this API Service."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif FORM.SmartyStreetsEnabled EQ "----">
				<cfset FORM.SmartyStreetsEnabled = 0>
			</cfif>

			<cfif isDefined("FORM.InstallJarFiles")>
				<cfif FORM.InstallJarFiles EQ 1>
					<cfswitch expression="#Server.Coldfusion.ProductName#">
						<cfcase value="Lucee">
							<cfset ReportLibraryJarsLocation = #ExpandPath("*")#>
							<cfset ReportLibraryJarsLocation = #Left(Variables.ReportLibraryJarsLocation, LEN(Variables.ReportLibraryJarsLocation) - 1)# & "library/jars">
						</cfcase>
					</cfswitch>

					<cfset FileNewLocation1 = #Session.ReportLibraryJars# & "/itextpdf-5.3.3.jar">
					<cfset FileOldLocation1 = #Variables.ReportLibraryJarsLocation# & "/itextpdf-5.3.3.jar">
					<cfset FileNewLocation2 = #Session.ReportLibraryJars# & "/itext-pdfa-5.3.3.jar">
					<cfset FileOldLocation2 = #Variables.ReportLibraryJarsLocation# & "/itext-pdfa-5.3.3.jar">
					<cfset FileNewLocation3 = #Session.ReportLibraryJars# & "/itext-xtra-5.3.3.jar">
					<cfset FileOldLocation3 = #Variables.ReportLibraryJarsLocation# & "/itext-xtra-5.3.3.jar">
					<cfset FileNewLocation4 = #Session.ReportLibraryJars# & "/twitter4j.jar">
					<cfset FileOldLocation4 = #Variables.ReportLibraryJarsLocation# & "/twitter4j-core-4.0.7.jar">

					<cffile action="copy" source="#Variables.FileOldLocation1#" destination="#Variables.FileNewLocation1#" attributes="normal" mode="644">
					<cffile action="copy" source="#Variables.FileOldLocation2#" destination="#Variables.FileNewLocation2#" attributes="normal" mode="644">
					<cffile action="copy" source="#Variables.FileOldLocation3#" destination="#Variables.FileNewLocation3#" attributes="normal" mode="644">
					<cffile action="copy" source="#Variables.FileOldLocation4#" destination="#Variables.FileNewLocation4#" attributes="normal" mode="644">
				</cfif>
			</cfif>

			<cfif Session.SiteConfigSettings.recordcount EQ 0>
				<cftry>
					<cfquery name="insertSiteConfigSettings" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						insert into p_EventRegistration_SiteConfig(Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Twitter_Enabled, Twitter_ConsumerKey, Twitter_ConsumerSecret, Twitter_AccessToken, Twitter_AccessTokenSecret, CFServerJarFiles)
						values(
							<cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.ProcessPaymentsStripe#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#FORM.StripeTestMode#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#FORM.StripeTestAPIKey#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.StripeLiveAPIKey#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.FacebookEnabled#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#FORM.FacebookAppID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.FacebookAppSecretKey#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.FacebookPageID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.FacebookAppScope#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.GoogleReCaptchaEnabled#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#FORM.GoogleReCaptchaSiteKey#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.GoogleReCaptchaSecretKey#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.SmartyStreetsEnabled#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#FORM.SmartyStreetsAPIID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.SmartyStreetsAPITOKEN#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.BillForNoShowRegistration#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#FORM.RequireEventSurveyToGetCertificate#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#FORM.GitHubProfileURL#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.TwitterProfileURL#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.FacebookProfileURL#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.GoogleProfileURL#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.LinkedInProfileURL#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">, 
							<cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">, 
							<cfqueryparam value="#Session.Mura.Fname# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">, 
							<cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.TwitterEnabled#" cfsqltype="cf_sql_bit">,
							<cfqueryparam value="#FORM.TwitterConsumerKey#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.TwitterConsumerSecretKey#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.TwitterAccessToken#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.TwitterAccessTokenSecret#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#FORM.JavaLibraryJars#" cfsqltype="cf_sql_varchar">
						)
					</cfquery>
					<cfcatch type="Any">
						<cfscript>
							eventdate = {property="Registration_Deadline",message="Event was not added to the database due to an error: " & cfcatch.detail};
							arrayAppend(Session.FormErrors, eventdate);
							arrayAppend(Session.FormErrors, cfcatch);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfcatch>
				</cftry>
				<cfif LEN(cgi.path_info)>
					<cfif isDefined("FORM.InstallJarFiles")>
						<cfif FORM.InstallJarFiles EQ 1>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?appreload&reload=appreload">
						<cfelse>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:main.default&SiteConfigUpdated=True" >
						</cfif>
					<cfelse>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:main.default&SiteConfigUpdated=True" >
					</cfif>
				<cfelse>
					<cfif isDefined("FORM.InstallJarFiles")>
						<cfif FORM.InstallJarFiles EQ 1>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?appreload&reload=appreload">
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:main.default&SiteConfigUpdated=True" >
						</cfif>
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:main.default&SiteConfigUpdated=True" >
					</cfif>
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			<cfelse>
				<cftry>
					<cfquery name="uppdateSiteConfigSettings" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Update p_EventRegistration_SiteConfig
						Set lastUpdated = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
							lastUpdateBy = <cfqueryparam value="#Session.Mura.Fname# #Session.Mura.LName#" cfsqltype="cf_sql_varchar">,
							lastUpdateByID = <cfqueryparam value="#Session.Mura.UserID#" cfsqltype="cf_sql_varchar">,
							Stripe_ProcessPayments = <cfqueryparam value="#FORM.ProcessPaymentsStripe#" cfsqltype="cf_sql_bit">,
							Stripe_TestMode = <cfqueryparam value="#FORM.StripeTestMode#" cfsqltype="cf_sql_bit">,
							Stripe_testAPIKey = <cfqueryparam value="#FORM.StripeTestAPIKey#" cfsqltype="cf_sql_varchar">,
							Stripe_LiveAPIKey = <cfqueryparam value="#FORM.StripeLiveAPIKey#" cfsqltype="cf_sql_varchar">,
							Facebook_Enabled = <cfqueryparam value="#FORM.FacebookEnabled#" cfsqltype="cf_sql_bit">,
							Facebook_AppID = <cfqueryparam value="#FORM.FacebookAppID#" cfsqltype="cf_sql_varchar">,
							Facebook_AppSecretKey = <cfqueryparam value="#FORM.FacebookAppSecretKey#" cfsqltype="cf_sql_varchar">,
							Facebook_PageID = <cfqueryparam value="#FORM.FacebookPageID#" cfsqltype="cf_sql_varchar">,
							Facebook_AppScope = <cfqueryparam value="#FORM.FacebookAppScope#" cfsqltype="cf_sql_varchar">,
							GoogleReCaptcha_Enabled = <cfqueryparam value="#FORM.GoogleReCaptchaEnabled#" cfsqltype="cf_sql_bit">,
							GoogleReCaptcha_SiteKey = <cfqueryparam value="#FORM.GoogleReCaptchaSiteKey#" cfsqltype="cf_sql_varchar">,
							GoogleReCaptcha_SecretKey = <cfqueryparam value="#FORM.GoogleReCaptchaSecretKey#" cfsqltype="cf_sql_varchar">,
							SmartyStreets_Enabled = <cfqueryparam value="#FORM.SmartyStreetsEnabled#" cfsqltype="cf_sql_bit">,
							SmartyStreets_APIID = <cfqueryparam value="#FORM.SmartyStreetsAPIID#" cfsqltype="cf_sql_varchar">,
							SmartyStreets_APIToken = <cfqueryparam value="#FORM.SmartyStreetsAPITOKEN#" cfsqltype="cf_sql_varchar">,
							GitHub_URL = <cfqueryparam value="#FORM.GitHubProfileURL#" cfsqltype="cf_sql_varchar">,
							Twitter_URL = <cfqueryparam value="#FORM.TwitterProfileURL#" cfsqltype="cf_sql_varchar">,
							Facebook_URL = <cfqueryparam value="#FORM.FacebookProfileURL#" cfsqltype="cf_sql_varchar">,
							GoogleProfile_URL = <cfqueryparam value="#FORM.GoogleProfileURL#" cfsqltype="cf_sql_varchar">,
							LinkedIn_URL = <cfqueryparam value="#FORM.LinkedInProfileURL#" cfsqltype="cf_sql_varchar">,
							BillForNoShowRegistrations = <cfqueryparam value="#FORM.BillForNoShowRegistration#" cfsqltype="cf_sql_bit">,
							RequireSurveyToGetCertificate = <cfqueryparam value="#FORM.RequireEventSurveyToGetCertificate#" cfsqltype="cf_sql_bit">,
							Twitter_Enabled = <cfqueryparam value="#FORM.TwitterEnabled#" cfsqltype="cf_sql_bit">,
							Twitter_ConsumerKey = <cfqueryparam value="#FORM.TwitterConsumerKey#" cfsqltype="cf_sql_varchar">,
							Twitter_ConsumerSecret = <cfqueryparam value="#FORM.TwitterConsumerSecretKey#" cfsqltype="cf_sql_varchar">,
							Twitter_AccessToken = <cfqueryparam value="#FORM.TwitterAccessToken#" cfsqltype="cf_sql_varchar">,
							Twitter_AccessTokenSecret = <cfqueryparam value="#FORM.TwitterAccessTokenSecret#" cfsqltype="cf_sql_varchar">,
							CFServerJarFiles = <cfqueryparam value="#FORM.JavaLibraryJars#" cfsqltype="cf_sql_varchar">
						Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfcatch type="Any">
						<cfscript>
							eventdate = {property="Registration_Deadline",message="Event was not added to the database due to an error: " & cfcatch.detail};
							arrayAppend(Session.FormErrors, eventdate);
							arrayAppend(Session.FormErrors, cfcatch);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.default&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					</cfcatch>
				</cftry>
				<cfif LEN(cgi.path_info)>
					<cfif isDefined("FORM.InstallJarFiles")>
						<cfif FORM.InstallJarFiles EQ 1>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?appreload&reload=appreload">
						<cfelse>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:main.default&SiteConfigUpdated=True" >
						</cfif>
					<cfelse>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:main.default&SiteConfigUpdated=True" >
					</cfif>
				<cfelse>
					<cfif isDefined("FORM.InstallJarFiles")>
						<cfif FORM.InstallJarFiles EQ 1>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?appreload&reload=appreload">
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:main.default&SiteConfigUpdated=True" >
						</cfif>
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:main.default&SiteConfigUpdated=True" >
					</cfif>
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="usermain" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfswitch expression="#application.configbean.getDBType()#">
			<cfcase value="mysql">
				<cfquery name="getUsers" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Select UserID, FName, LName, UserName, Company, LastLogin, LastUpdate, InActive, Created
					From tusers
					Where GroupName is null and Username is not null
					Order by LName ASC, FName ASC
				</cfquery>
			</cfcase>
			<cfcase value="mssql">
				<cfquery name="getUsers" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
					Select UserID, FName, LName, UserName, Company, LastLogin, LastUpdate, InActive, Created
					From tusers
					Where GroupName is null and Username is not null
					Order by LName ASC, FName ASC
				</cfquery>
			</cfcase>
		</cfswitch>
		<cfset Session.getUsers = StructCopy(getUsers)>
	</cffunction>

	<cffunction name="getAllUsers" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrUsers = ArrayNew(1)>

		<cfif isDefined("URL._search")>
			<cfif URL._search EQ "false">
				<cfquery name="getUsers" dbtype="Query">
					Select UserID, LName, FName, UserName, Company, LastLogin, Created, InActive
					From Session.getUsers
					<cfif Arguments.sidx NEQ "">
						Order By #Arguments.sidx# #Arguments.sord#
					<cfelse>
						Order by LName ASC, FName ASC
					</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="getUsers" dbtype="Query">
					Select UserID, LName, FName, UserName, Company, LastLogin, Created, InActive
					From Session.getUsers
					<cfif Arguments.sidx NEQ "">
						<cfswitch expression="#URL.searchOper#">
							<cfcase value="eq">
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="cn">
								<!--- Contains --->
								Where #URL.searchField# LIKE '%#URL.searchString#%'
							</cfcase>
							<cfcase value="ne">
								<!--- Not Equal --->
								Where #URL.searchField# <> '#URL.searchString#'
							</cfcase>
							<cfcase value="bw">
								<!--- Begin With --->
								Where #URL.searchField# LIKE '#URL.searchString#%'
							</cfcase>
							<cfcase value="ew">
								<!--- Ends With --->
								Where #URL.searchField# LIKE '%#URL.searchString#'
							</cfcase>
							<cfcase value="cn">
								<!--- Contains --->
								Where #URL.searchField# LIKE '%#URL.searchString#%'
							</cfcase>


							<cfcase value="bn">
								<!--- Does Not Begin With  --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="en">
								<!--- Does Not End With --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="nc">
								<!--- Does Not Contain --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="nu">
								<!--- Is Null --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="nn">
								<!--- Is Not Null --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="in">
								<!--- Is In --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="ni">
								<!--- Is Not In --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
						</cfswitch>
						Order By #Arguments.sidx# #Arguments.sord#
					</cfif>
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="getUsers" dbtype="Query">
				Select UserID, LName, FName, UserName, Company, LastLogin, Created, InActive
				From Session.getUsers
				<cfif Arguments.sidx NEQ "">
					Order By #Arguments.sidx# #Arguments.sord#
				<cfelse>
					Order by LName ASC, FName ASC
				</cfif>
			</cfquery>
		</cfif>

		<!--- Calculate the Start Position for the loop query. So, if you are on 1st page and want to display 4 rows per page, for first page you start at: (1-1)*4+1 = 1.
				If you go to page 2, you start at (2-)1*4+1 = 5 --->
		<cfset start = ((arguments.page-1)*arguments.rows)+1>

		<!--- Calculate the end row for the query. So on the first page you go from row 1 to row 4. --->
		<cfset end = (start-1) + arguments.rows>

		<!--- When building the array --->
		<cfset i = 1>

		<cfloop query="getUsers" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfif #InActive# EQ 1>
				<cfset strActive = "Yes">
			<cfelse>
				<cfset strActive = "No">
			</cfif>
			<cfif getUsers.UserName NEQ "admin">
				<cfset arrUsers[i] = [#UserID#,#LName#,#FName#,#UserName#,#Company#,#LastLogin#,#Created#,#strActive#]>
				<cfset i = i + 1>
			</cfif>
		</cfloop>

		<!--- Calculate the Total Number of Pages for your records. --->
		<cfset totalPages = Ceiling(getUsers.recordcount/arguments.rows)>

		<!--- The JSON return.
			Total - Total Number of Pages we will have calculated above
			Page - Current page user is on
			Records - Total number of records
			rows = our data
		--->
		<cfset stcReturn = {total=#totalPages#,page=#Arguments.page#,records=#getUsers.recordcount#,rows=arrUsers}>
		<cfreturn stcReturn>
	</cffunction>

	<cffunction name="newuser" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getEventGroups" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select UserID, GroupName
				From tusers
				Where InActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> and GroupName Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%Event%">
				Order by GroupName ASC
			</cfquery>
			<cfset Session.getEventGroups = StructCopy(getEventGroups)>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to User Management">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "GetEventGroups")>
				<cfset temp = StructDelete(Session, "GetUsers")>

				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.usermain" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.usermain" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.InActive EQ "----">
				<cfscript>
					eventdate = {property="Registration_Deadline",message="Please select if this account holder's account is active or not"};
					arrayAppend(Session.FormErrors, eventdate);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.Password) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.VerifyPassword) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Verify Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif FORM.Password NEQ FORM.VerifyPassword>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field and the Verify Password Field did not match. Please check these fields and try to submit this request again."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif not isValid("email", FORM.Email)>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid email address for this user account."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.FName) LT 3>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the users first name for their account. This will be used on all emails, certificates, signin sheets, etc."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.LName) LT 3>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the users last name for their account. This will be used on all emails, certificates, signin sheets."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.newuser&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<!--- Initiates the User Bean --->
			<cfset userRecord = $.getBean('user').loadBy(username='#FORM.Email#', siteid='#$.siteConfig("siteid")#')>
			<cfset temp = #userRecord.set('siteid', $.siteConfig("siteid"))#>
			<cfset temp = #userRecord.set('fname', '#Trim(FORM.FName)#')#>
			<cfset temp = #userRecord.set('lname', '#Trim(FORM.LName)#')#>
			<cfset temp = #userRecord.set('username', '#Trim(FORM.Email)#')#>
			<cfset temp = #userRecord.set('email', '#Trim(FORM.Email)#')#>
			<cfset temp = #userRecord.set('InActive', FORM.InActive)#>
			<cfset temp = #userRecord.set('jobtitle', '#Trim(FORM.JobTitle)#')#>
			<cfset temp = #userRecord.set('organization', '#Trim(FORM.Company)#')#>
			<cfset temp = #userRecord.set('mobilePhone', '#Trim(FORM.mobilePhone)#')#>
			<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
			<cfset temp = #userRecord.set('lastupdateby', '#Session.Mura.Fname# #Session.Mura.LName#')#>
			<cfset temp = #userRecord.set('lastupdatebyid', '#Session.Mura.UserID#')#>
			<cfset temp = #userRecord.setPasswordNoCache('#FORM.VerifyPassword#')#>

			<cfif userRecord.checkUsername() EQ "false">
			 	<cfdump var="#Variables.userRecord#" abort="true">
          	<cfelse>
          		<cfset AddNewAccount = #userRecord.save()#>
          		<cfif LEN(AddNewAccount.getErrors()) EQ 0>
          			<cfif isDefined("FORM.MemberGroup")>
          				<cfloop list="#FORM.MemberGroup#" index="i" delimiters=",">
          					<cfquery name="insertUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
          						Insert into tusersmemb(UserID, GroupID)
          						Values('#AddNewAccount.getUserID()#', '#i#')
          					</cfquery>
          				</cfloop>
          			</cfif>
          		<cfelse>
          			<cfdump var="#AddNewAccount.getErrors()#"><cfabort>
          		</cfif>
          	</cfif>
          	<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.usermain&UserAction=AccountCreated&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.usermain&UserAction=AccountCreated&Successful=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="edituser" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getSelectedUser" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select Fname, Lname, UserName, Email, Company, JobTitle, mobilePhone, Website, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, InActive
				From tusers
				Where UserID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#URL.UserID#">
			</cfquery>
			<cfquery name="getEventGroups" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select UserID, GroupName
				From tusers
				Where InActive = <cfqueryparam cfsqltype="cf_sql_bit" value="0"> and GroupName Like <cfqueryparam cfsqltype="cf_sql_varchar" value="%Event%">
				Order by GroupName ASC
			</cfquery>
			<cfset Session.getSelectedUser = StructCopy(getSelectedUser)>
			<cfset Session.getEventGroups = StructCopy(getEventGroups)>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to User Management">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "GetEventGroups")>
				<cfset temp = StructDelete(Session, "GetSelectedUser")>
				<cfset temp = StructDelete(Session, "GetUsers")>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.usermain" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.usermain" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif FORM.UserAction EQ "Change Password">
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.userchangepswd" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.userchangepswd" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.UserAction EQ "Activate Account">
				<cfset userRecord = $.getBean('user').loadBy(username='#FORM.UserName#', siteid='#$.siteConfig("siteid")#')>
				<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
				<cfset temp = #userRecord.set('lastupdateby', '#Session.Mura.Fname# #Session.Mura.LName#')#>
				<cfset temp = #userRecord.set('lastupdatebyid', '#Session.Mura.UserID#')#>
				<cfset temp = #userRecord.set('InActive', 0)#>
				<cfset AddNewAccount = #userRecord.save()#>
				<cfif LEN(AddNewAccount.getErrors()) EQ 0>
					<cfif LEN(cgi.path_info)>
						<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&UserID=#Session.FormInput.UserID#&UserAction=UserAccountActivated&Successful=True" >
					<cfelse>
						<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&UserID=#Session.FormInput.UserID#&UserAction=UserAccountActivated&Successful=True" >
					</cfif>
					<cflocation url="#variables.newurl#" addtoken="false">
				<cfelse>
          			<cfdump var="#AddNewAccount.getErrors()#"><cfabort>
          		</cfif>
			</cfif>

			<cfif FORM.UserAction EQ "Login As User">
				<!--- 
				<cflock timeout="60" scope="Session" type="Exclusive">
					<cfset Session.MuraPreviousUser = #StructNew()#>
					<cfset Session.MuraPreviousUser = #StructCopy(Session.Mura)#>
					<cfset userLogin = application.serviceFactory.getBean("userUtility").loginByUserID("#URL.UserID#", "#rc.$.siteConfig('siteID')#")>

					<cfif userLogin EQ true>
						<cflocation addtoken="true" url="/index.cfm">
					</cfif>
				</cflock>
				--->
			</cfif>
			<cfif FORM.InActive EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Account Holder's Account is InActive or Not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.FName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the First Name of this new user account."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.LName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the Last Name of this new user account."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif not isValid("email", FORM.EMail)>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter a valid email address for this user account."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&FormRetry=True&UserID=#Session.FormInput.UserID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfset userRecord = $.getBean('user').loadBy(username='#FORM.UserName#', siteid='#$.siteConfig("siteid")#')>
			<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
			<cfset temp = #userRecord.set('lastupdateby', '#Session.Mura.Fname# #Session.Mura.LName#')#>
			<cfset temp = #userRecord.set('lastupdatebyid', '#Session.Mura.UserID#')#>
			<cfset temp = #userRecord.set('InActive', FORM.Inactive)#>
			<cfset temp = #userRecord.set('fname', '#Trim(FORM.FName)#')#>
			<cfset temp = #userRecord.set('lname', '#Trim(FORM.LName)#')#>
			<cfset temp = #userRecord.set('email', '#Trim(FORM.Email)#')#>
			<cfset temp = #userRecord.set('organization', '#Trim(FORM.Company)#')#>
			<cfset temp = #userRecord.set('mobilePhone', '#Trim(FORM.mobilePhone)#')#>
			<cfset temp = #userRecord.set('jobtitle', '#Trim(FORM.JobTitle)#')#>
			<cfset AddNewAccount = #userRecord.save()#>
			<cfif LEN(AddNewAccount.getErrors()) EQ 0>
				<cfif isDefined("FORM.MemberGroup")>
					<cfquery name="getUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Select GroupID
						From tusersmemb
						Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif getUserMemberships.RecordCount NEQ ListLen(FORM.MemberGroup, ",")>
						<cfquery name="deleteUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Delete from tusersmemb
							Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
						</cfquery>
						<cfloop list="#FORM.MemberGroup#" index="i" delimiters=",">
							<cfquery name="insertUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Insert into tusersmemb(UserID, GroupID)
								Values('#FORM.UserID#', '#i#')
							</cfquery>
						</cfloop>
					<cfelse>
						<cfloop list="#FORM.MemberGroup#" index="i" delimiters=",">
							<cfquery name="checkUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
								Select GroupID
								From tusersmemb
								Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar"> and
									GroupID = <cfqueryparam value="#i#" cfsqltype="cf_sql_varchar">
							</cfquery>
							<cfif checkUserMemberships.RecordCount EQ 0>
								<cfquery name="insertUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
									Insert into tusersmemb(UserID, GroupID)
									Values('#FORM.UserID#', '#i#')
								</cfquery>
							</cfif>
						</cfloop>
					</cfif>
				<cfelse>
          			<cfquery name="getUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
						Select GroupID
						From tusersmemb
						Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
					</cfquery>
					<cfif getUserMemberships.RecordCount>
						<cfquery name="deleteUserMemberships" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
							Delete from tusersmemb
							Where UserID = <cfqueryparam value="#FORM.UserID#" cfsqltype="cf_sql_varchar">
						</cfquery>
					</cfif>
				</cfif>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.usermain&UserID=#Session.FormInput.UserID#&UserAction=UserAccountUpdated&Successful=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.usermain&UserID=#Session.FormInput.UserID#&UserAction=UserAccountUpdated&Successful=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
          	<cfelse>
          		<cfdump var="#AddNewAccount.getErrors()#"><cfabort>
          	</cfif>
		</cfif>
	</cffunction>

	<cffunction name="userchangepswd" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getSelectedUser" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select Fname, Lname, UserName, Email, Company, JobTitle, mobilePhone, Website, LastLogin, LastUpdate, LastUpdateBy, LastUpdateByID, InActive
				From tusers
				Where UserID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.FormInput.UserID#">
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to User Management">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&UserID=#Session.FormInput.UserID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&UserID=#Session.FormInput.UserID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.Password) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.userchangepswd&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.userchangepswd&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif LEN(FORM.VerifyPassword) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Verify Password Field must be longer than 5 characters."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.userchangepswd&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.userchangepswd&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<cfif FORM.Password NEQ FORM.VerifyPassword>
				<cfscript>
					errormsg = {property="EmailMsg",message="The Password Field and the Verify Password Field did not match. Please check these fields and try to submit this request again."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.userchangepswd&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.userchangepswd&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>
			<!--- Initiates the User Bean --->
			<cfset userRecord = $.getBean('user').loadBy(username='#FORM.UserName#', siteid='#$.siteConfig("siteid")#')>
			<cfset temp = #userRecord.set('lastupdate', '#Now()#')#>
			<cfset temp = #userRecord.set('lastupdateby', '#Session.Mura.Fname# #Session.Mura.LName#')#>
			<cfset temp = #userRecord.set('lastupdatebyid', '#Session.Mura.UserID#')#>
			<cfset temp = #userRecord.setPasswordNoCache('#FORM.VerifyPassword#')#>
			<cfset AddNewAccount = #userRecord.save()#>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&UserID=#Session.FormInput.UserID#&UserAction=AccountPasswordChanged&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=admin:siteconfig.edituser&UserID=#Session.FormInput.UserID#&UserAction=AccountPasswordChanged&Successful=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">
		</cfif>
	</cffunction>


</cfcomponent>
