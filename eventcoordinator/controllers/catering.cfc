<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="getCaterers" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, DeliveryInfo, GuaranteeInformation, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_Timezone, Active
			From p_EventRegistration_Caterers
			Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
			Order by FacilityName
		</cfquery>
		<cfquery name="SiteConfigSettings" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, Twitter_Enabled, Twitter_ConsumerKey, Twitter_ConsumerSecret, Twitter_AccessToken, Twitter_AccessTokenSecret, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, CFServerJarFiles
			From p_EventRegistration_SiteConfig
			Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>
		<cfset Session.getCaterers = StructCopy(getCaterers)>
	</cffunction>

	<cffunction name="getAllCaterers" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrCaterers = ArrayNew(1)>
		<cfif isDefined("URL._search")>
			<cfif URL._search EQ "true">
				<cfquery name="getCaterers" dbtype="Query">
					Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PrimaryVoiceNumber, lastUpdated, Active
					From Session.getCaterers
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
			<cfelse>
				<cfquery name="getCaterers" dbtype="Query">
					Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PrimaryVoiceNumber, lastUpdated, Active
					From Session.getCaterers
					Order By #Arguments.sidx# #Arguments.sord#
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="getCaterers" dbtype="Query">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PrimaryVoiceNumber, lastUpdated, Active
				From Session.getCaterers
				<cfif Arguments.sidx NEQ "">
					Order By #Arguments.sidx# #Arguments.sord#
				<cfelse>
					Order by FacilityName #Arguments.sord#
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

		<cfloop query="getCaterers" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfif #Active# EQ 1>
				<cfset strActive = "Yes">
			<cfelse>
				<cfset strActive = "No">
			</cfif>
			<cfset arrCaterers[i] = [#TContent_ID#,#FacilityName#,#PhysicalAddress#,#PhysicalCity#,#PhysicalState#,#PrimaryVoiceNumber#,#lastUpdated#,#strActive#]>
			<cfset i = i + 1>
		</cfloop>

		<!--- Calculate the Total Number of Pages for your records. --->
		<cfset totalPages = Ceiling(getCaterers.recordcount/arguments.rows)>

		<!--- The JSON return.
			Total - Total Number of Pages we will have calculated above
			Page - Current page user is on
			Records - Total number of records
			rows = our data
		--->
		<cfset stcReturn = {total=#totalPages#,page=#Arguments.page#,records=#getCaterers.recordcount#,rows=arrCaterers}>
		<cfreturn stcReturn>
	</cffunction>

	<cffunction name="addcaterer" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="SiteConfigSettings" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
				From p_EventRegistration_SiteConfig
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
			</cfquery>
			<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>

			</cflock>
			<cfif FORM.UserAction EQ "Back to Catering Listing">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "SiteConfigSettings")>
				<cfset temp = StructDelete(Session, "getCaterers")>
				<cfif isDefined("Session.getMembership")><cfset temp = StructDelete(Session, "getMembership")></cfif>
				<cfif isDefined("Session.getFacilities")><cfset temp = StructDelete(Session, "getFacilities")></cfif>
				<cfif isDefined("Session.getUsers")><cfset temp = StructDelete(Session, "getUsers")></cfif>
				<cfif isDefined("Session.GetEventGroups")><cfset temp = StructDelete(Session, "GetEventGroups")></cfif>
				
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.default" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.default" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.FacilityName) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the facility name for this catering facility."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.addcaterer&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.addcaterer&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) LT 5 or LEN(FORM.PhysicalCity) LT 4 or LEN(FORM.PhysicalState) LT 2>>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the physical address for this catering facility."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.addcaterer&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.addcaterer&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter if this catering facility will display when entering an event?."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.addcaterer&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.addcaterer&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif Session.SiteConfigSettings.SmartyStreets_Enabled EQ true>
				<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/SmartyStreets").init(apitoken="#Trim(Session.SiteConfigSettings.SmartyStreets_APIToken)#", apiid="#Trim(Session.SiteConfigSettings.SmartyStreets_APIID)#", verbose=true)>
				<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
					<cfscript>
						PassedAddress = { street = #FORM.PhysicalAddress#, city = #FORM.PhysicalCity#, state = #FORM.PhysicalState#, zipcode = #FORM.PhysicalZipCode# };
						PhysicalAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
					</cfscript>
					<cfif LEN(PhysicalAddressGeoCoded.Result.errordetail) GT 0>
						<cfscript>
							errormsg = {property="EmailMsg",message="#PhysicalAddressGeoCoded.Result.errordetail#"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.addcaterer&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.addcaterer&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					<cfelseif ArrayLen(Variables.PhysicalAddressGeoCoded.Data) GT 0>
						<cfquery name="InsertCatererInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							insert into p_EventRegistration_Caterers(Site_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active, GeoCode_Latitude, GeoCode_Longitude, isAddressVerified, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_TimeZone)
							Values(
								<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.FacilityName#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.PhysicalAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].city_name)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].zipcode)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
								<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
								<cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].latitude)#">,
								<cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].longitude)#">,
								<cfqueryparam cfsqltype="cf_sql_bit" value="1">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].delivery_point)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].delivery_point_check_digit)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].carrier_route)#">,
								<cfqueryparam cfsqltype="cf_sql_bit" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].dst)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].utc_offset)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].time_zone)#">
							)
						</cfquery>
					</cfif>
				</cfif>
			<cfelse>
				<cfquery name="InsertCatererInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					insert into p_EventRegistration_Caterers(Site_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active, isAddressVerified)
					Values(
						<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.FacilityName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PhysicalAddress#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PhysicalCity#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PhysicalState#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PhysicalZipCode#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="0">
					)
				</cfquery>
			</cfif>

			<cfif LEN(FORM.BusinessWebsite) or LEN(FORM.PrimaryVoiceNumber) or LEN(FORM.ContatName) or LEN(FORM.ContactPhoneNumber) or LEN(FORM.ContactEmail) or LEN(FORM.PaymentTerms) or LEN(FORM.GuaranteeInformation) or LEN(FORM.AdditioanlNotes)>
				<cfswitch expression="#application.configbean.getDBType()#">
					<cfcase value="mysql">
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Caterers
							Set
								<cfif LEN(FORM.PrimaryVoiceNumber)>PrimaryVoiceNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PrimaryVoiceNumber)#">,</cfif>
								<cfif LEN(FORM.BusinessWebsite)>BusinessWebsite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.BusinessWebsite)#">,</cfif>
								<cfif LEN(FORM.ContactName)>ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.ContactName)#">,</cfif>
								<cfif LEN(FORM.ContactEmail)>ContactEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.ContactEmail)#">,</cfif>
								<cfif LEN(FORM.ContactPhoneNumber)>ContactPhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.ContactPhoneNumber)#">,</cfif>
								<cfif LEN(FORM.PaymentTerms)>PaymentTerms = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PaymentTerms)#">,</cfif>
								<cfif LEN(FORM.GuaranteeInformation)>GuaranteeInformation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.GuaranteeInformation)#">,</cfif>
								<cfif LEN(FORM.AdditionalNotes)>AdditionalNotes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.AdditionalNotes)#">,</cfif>
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					</cfcase>
					<cfcase value="mssql">
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Caterers
							Set
								<cfif LEN(FORM.PrimaryVoiceNumber)>PrimaryVoiceNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PrimaryVoiceNumber)#">,</cfif>
								<cfif LEN(FORM.BusinessWebsite)>BusinessWebsite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.BusinessWebsite)#">,</cfif>
								<cfif LEN(FORM.ContactName)>ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.ContactName)#">,</cfif>
								<cfif LEN(FORM.ContactEmail)>ContactEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.ContactEmail)#">,</cfif>
								<cfif LEN(FORM.ContactPhoneNumber)>ContactPhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.ContactPhoneNumber)#">,</cfif>
								<cfif LEN(FORM.PaymentTerms)>PaymentTerms = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PaymentTerms)#">,</cfif>
								<cfif LEN(FORM.GuaranteeInformation)>GuaranteeInformation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.GuaranteeInformation)#">,</cfif>
								<cfif LEN(FORM.AdditionalNotes)>AdditionalNotes = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.AdditionalNotes)#">,</cfif>
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
						</cfquery>
					</cfcase>
				</cfswitch>
			</cfif>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.default&UserAction=CateringFacilityAdded&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.default&UserAction=CateringFacilityAdded&Successful=True">
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">				
		</cfif>
	</cffunction>

	<cffunction name="editcaterer" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="getSelectedCaterer" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, PaymentTerms, DeliveryInfo, GuaranteeInformation, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_Timezone, Active
				From p_EventRegistration_Caterers
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">  and
					TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
				Order by FacilityName
			</cfquery>
			
			<cfquery name="SiteConfigSettings" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
				From p_EventRegistration_SiteConfig
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
			</cfquery>
			<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>
			<cfset Session.getSelectedCaterer = StructCopy(getSelectedCaterer)>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Catering Listing">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "SiteConfigSettings")>
				<cfset temp = StructDelete(Session, "getSelectedCaterer")>
				
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.default" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.default" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.FacilityName) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the facility name for this catering facility."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.editcaterer&FormRetry=True&CatererID=#URL.CatererID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.editcaterer&FormRetry=True&CatererID=#URL.CatererID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) LT 5 or LEN(FORM.PhysicalCity) LT 4 or LEN(FORM.PhysicalState) LT 2>>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the physical address for this catering facility."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.editcaterer&FormRetry=True&CatererID=#URL.CatererID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.editcaterer&FormRetry=True&CatererID=#URL.CatererID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter if this catering facility will display when entering an event?."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.editcaterer&FormRetry=True&CatererID=#URL.CatererID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.editcaterer&FormRetry=True&CatererID=#URL.CatererID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfset Variables.UpdateRecord = StructNew()>
			<cfparam name="Variables.UpdateRecord.FacilityName" default="0">
			<cfparam name="Variables.UpdateRecord.PhysicalAddress" default="0">
			<cfparam name="Variables.UpdateRecord.PhysicalCity" default="0">
			<cfparam name="Variables.UpdateRecord.PhysicalState" default="0">
			<cfparam name="Variables.UpdateRecord.PhysicalZipCode" default="0">
			<cfparam name="Variables.UpdateRecord.PrimaryVoiceNumber" default="0">
			<cfparam name="Variables.UpdateRecord.BusinessWebsite" default="0">
			<cfparam name="Variables.UpdateRecord.ContactName" default="0">
			<cfparam name="Variables.UpdateRecord.ContactPhoneNumber" default="0">
			<cfparam name="Variables.UpdateRecord.ContactEmail" default="0">
			<cfparam name="Variables.UpdateRecord.PaymentTerms" default="0">
			<cfparam name="Variables.UpdateRecord.DeliveryInfo" default="0">
			<cfparam name="Variables.UpdateRecord.GuaranteeInformation" default="0">
			<cfparam name="Variables.UpdateRecord.AdditionalNotes" default="0">
			<cfparam name="Variables.UpdateRecord.Active" default="0">

			<cfif FORM.FacilityName NEQ Session.getSelectedCaterer.FacilityName><cfset Variables.UpdateRecord.FacilityName = 1></cfif>
			<cfif FORM.PhysicalAddress NEQ Session.getSelectedCaterer.PhysicalAddress><cfset Variables.UpdateRecord.PhysicalAddress = 1></cfif>
			<cfif FORM.PhysicalCity NEQ Session.getSelectedCaterer.PhysicalCity><cfset Variables.UpdateRecord.PhysicalCity = 1></cfif>
			<cfif FORM.PhysicalState NEQ Session.getSelectedCaterer.PhysicalState><cfset Variables.UpdateRecord.PhysicalState = 1></cfif>
			<cfif FORM.PhysicalZipCode NEQ Session.getSelectedCaterer.PhysicalZipCode><cfset Variables.UpdateRecord.PhysicalZipCode = 1></cfif>
			<cfif FORM.PrimaryVoiceNumber NEQ Session.getSelectedCaterer.PrimaryVoiceNumber><cfset Variables.UpdateRecord.PrimaryVoiceNumber = 1></cfif>
			<cfif FORM.BusinessWebsite NEQ Session.getSelectedCaterer.BusinessWebsite><cfset Variables.UpdateRecord.BusinessWebsite = 1></cfif>
			<cfif FORM.ContactName NEQ Session.getSelectedCaterer.ContactName><cfset Variables.UpdateRecord.ContactName = 1></cfif>
			<cfif FORM.ContactPhoneNumber NEQ Session.getSelectedCaterer.ContactPhoneNumber><cfset Variables.UpdateRecord.ContactPhoneNumber = 1></cfif>
			<cfif FORM.ContactEmail NEQ Session.getSelectedCaterer.ContactEmail><cfset Variables.UpdateRecord.ContactEmail = 1></cfif>
			<cfif FORM.PaymentTerms NEQ Session.getSelectedCaterer.PaymentTerms><cfset Variables.UpdateRecord.PaymentTerms = 1></cfif>
			<cfif FORM.GuaranteeInformation NEQ Session.getSelectedCaterer.GuaranteeInformation><cfset Variables.UpdateRecord.GuaranteeInformation = 1></cfif>
			<cfif FORM.DeliveryInfo NEQ Session.getSelectedCaterer.DeliveryInfo><cfset Variables.UpdateRecord.DeliveryInfo = 1></cfif>
			<cfif FORM.Active NEQ Session.getSelectedCaterer.Active><cfset Variables.UpdateRecord.Active = 1></cfif>

			<cfif variables.UpdateRecord.PhysicalAddress EQ 1 OR variables.UpdateRecord.PhysicalCity EQ 1 OR variables.UpdateRecord.PhysicalState EQ 1 OR variables.UpdateRecord.PhysicalZipCode EQ 1>
				<cfif Session.SiteConfigSettings.SmartyStreets_Enabled EQ true>
					<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/SmartyStreets").init(apitoken="#Trim(Session.SiteConfigSettings.SmartyStreets_APIToken)#", apiid="#Trim(Session.SiteConfigSettings.SmartyStreets_APIID)#", verbose=true)>
					<cfscript>
						PassedAddress = { street = #FORM.PhysicalAddress#, city = #FORM.PhysicalCity#, state = #FORM.PhysicalState#, zipcode = #FORM.PhysicalZipCode# };
						PhysicalAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
					</cfscript>
					<cfif LEN(PhysicalAddressGeoCoded.Result.errordetail) GT 0>
						<cfscript>
							errormsg = {property="EmailMsg",message="#PhysicalAddressGeoCoded.Result.errordetail#"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.editcaterer&FormRetry=True&CatererID=#URL.CatererID#" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.editcaterer&FormRetry=True&CatererID=#URL.CatererID#" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					<cfelseif ArrayLen(Variables.PhysicalAddressGeoCoded.Data) GT 0>
						<cfquery name="UpdateCatererAddressInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Caterers
							Set PhysicalAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.PhysicalAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								PhysicalCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].city_name)#">,
								PhysicalState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								PhysicalZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].zipcode)#">,
								PhysicalZip4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								GeoCode_Latitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].latitude)#">,
								GeoCode_Longitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].longitude)#">,
								isAddressVerified = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
								Physical_USPSDeliveryPoint = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].delivery_point)#">,
								Physical_USPSCheckDigit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].delivery_point_check_digit)#">,
								Physical_USPSCarrierRoute = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].carrier_route)#">,
								Physical_DST = <cfqueryparam cfsqltype="cf_sql_bit" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].dst)#">,
								Physical_UTCOffset = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].utc_offset)#">,
								Physical_TimeZone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].time_zone)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				<cfelse>
					<cfquery name="UpdateCatererAddressInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Caterers
						Set PhysicalAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PhysicalAddress)#">,
							PhysicalCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PhysicalCity)#">,
							PhysicalState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PhysicalState)#">,
							PhysicalZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PhysicalZipCode)#">,
							isAddressVerified = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
			</cfif>

			<cfif Variables.UpdateRecord.FacilityName EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Caterers
					Set FacilityName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.FacilityName)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.PrimaryVoiceNumber EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Caterers
					Set PrimaryVoiceNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PrimaryVoiceNumber)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.BusinessWebsite EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Caterers
					Set BusinessWebsite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.BusinessWebsite)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.ContactName EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Caterers
					Set ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.ContactName)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.ContactPhoneNumber EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Caterers
					Set ContactPhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.ContactPhoneNumber)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.ContactEmail EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Caterers
					Set ContactEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.ContactEmail)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.PaymentTerms EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Caterers
					Set PaymentTerms = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PaymentTerms)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.DeliveryInfo EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Caterers
					Set DeliveryInfo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.DeliveryInfo)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.GuaranteeInformation EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Caterers
					Set GuaranteeInformation = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.GuaranteeInformation)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.Active EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Caterers
					Set Active = <cfqueryparam cfsqltype="cf_sql_boolean" value="#FORM.Active#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.CatererID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.default&UserAction=CateringFacilityUpdated&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:catering.default&UserAction=CateringFacilityUpdated&Successful=True" >
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">

		</cfif>
	</cffunction>
</cfcomponent>