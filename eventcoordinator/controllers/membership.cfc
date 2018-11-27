<cfcomponent extends="controller" output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="getMembership" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, OrganizationName, OrganizationDomainName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_TimeZone, MailingAddress, MailingCity, MailingState, MailingZipCode, MailingZip4, Mailing_isAddressVerified, Mailing_USPSDeliveryPoint, Mailing_USPSCheckDigit, Mailing_USPSCarrierRoute, PrimaryVoiceNumber, PrimaryFaxNumber, BusinessWebsite, StateDOE_IDNumber, StateDOE_State, StateDOE_ESCESAMembership, AccountsPayable_ContactName, AccountsPayable_EmailAddress, ReceiveInvoicesByEmail, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active
			From p_EventRegistration_Membership
			Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
			Order by OrganizationName
		</cfquery>
		<cfquery name="SiteConfigSettings" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
			Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
			From p_EventRegistration_SiteConfig
			Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
		</cfquery>
		<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>
		<cfset Session.getMembership = StructCopy(getMembership)>
	</cffunction>

	<cffunction name="getAllMembers" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrCaterers = ArrayNew(1)>
		<cfif isDefined("URL._search")>
			<cfif URL._search EQ "true">
				<cfquery name="getmembership" dbtype="Query">
					Select TContent_ID, OrganizationName, PhysicalAddress, PhysicalCity, PhysicalState, PrimaryVoiceNumber, lastUpdated, Active
					From Session.getMembership
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
				<cfquery name="getMembership" dbtype="Query">
					Select TContent_ID, OrganizationName, PhysicalAddress, PhysicalCity, PhysicalState, PrimaryVoiceNumber, lastUpdated, Active
					From Session.getMembership
					Order By #Arguments.sidx# #Arguments.sord#
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="getMembership" dbtype="Query">
				Select TContent_ID, OrganizationName, PhysicalAddress, PhysicalCity, PhysicalState, PrimaryVoiceNumber, lastUpdated, Active
					From Session.getMembership
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

		<cfloop query="getMembership" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfif #Active# EQ 1>
				<cfset strActive = "Yes">
			<cfelse>
				<cfset strActive = "No">
			</cfif>
			<cfset arrCaterers[i] = [#TContent_ID#,#OrganizationName#,#PhysicalAddress#,#PhysicalCity#,#PhysicalState#,#PrimaryVoiceNumber#,#lastUpdated#,#strActive#]>
			<cfset i = i + 1>
		</cfloop>

		<!--- Calculate the Total Number of Pages for your records. --->
		<cfset totalPages = Ceiling(getMembership.recordcount/arguments.rows)>

		<!--- The JSON return.
			Total - Total Number of Pages we will have calculated above
			Page - Current page user is on
			Records - Total number of records
			rows = our data
		--->
		<cfset stcReturn = {total=#totalPages#,page=#Arguments.page#,records=#getMembership.recordcount#,rows=arrCaterers}>
		<cfreturn stcReturn>
	</cffunction>

	<cffunction name="addmember" returntype="any" output="false">
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
			<cfif FORM.UserAction EQ "Back to Membership Listing">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "SiteConfigSettings")>
				<cfset temp = StructDelete(Session, "getMembership")>
				<cfif isDefined("Session.getFacilities")><cfset temp = StructDelete(Session, "getFacilities")></cfif>
				<cfif isDefined("Session.getCaterers")><cfset temp = StructDelete(Session, "getCaterers")></cfif>
				<cfif isDefined("Session.getUsers")><cfset temp = StructDelete(Session, "getUsers")></cfif>
				<cfif isDefined("Session.GetEventGroups")><cfset temp = StructDelete(Session, "GetEventGroups")></cfif>				
				
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.default" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.default" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationName) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the registered organization name for this member facility."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.addmember&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.addmember&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationDomainName) LT 7>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the registered organization's domain name for this member facility."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.addmember&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.addmember&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) LT 5 or LEN(FORM.PhysicalCity) LT 4 or LEN(FORM.PhysicalState) LT 2>>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the physical address for this member facility."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.addmember&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.addmember&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter if this member organizataion has active membership with you?."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.addmember&FormRetry=True" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.addmember&FormRetry=True" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.ReceiveInvoicesByEmail EQ "----"><cfset Form.ReceiveInvoicesByEmail = 0></cfif>

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
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.addmember&FormRetry=True" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.addmember&FormRetry=True" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					<cfelseif ArrayLen(Variables.PhysicalAddressGeoCoded.Data) GT 0>
						<cfquery name="InsertMemberInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							insert into p_EventRegistration_Membership(Site_ID, OrganizationName, OrganizationDomainName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active, Physical_Latitude, Physical_Longitude, Physical_isAddressVerified, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_TimeZone)
							Values(
								<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
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
					insert into p_EventRegistration_Membership(Site_ID, OrganizationName, OrganizationDomainName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active, Physical_isAddressVerified)
					Values(
						<cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PhysicalAddress#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PhysicalCity#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PhysicalState#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PhysicalZipCode#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="0">
					)
				</cfquery>
			</cfif>

			<cfif LEN(FORM.PrimaryVoiceNumber) or LEN(FORM.PrimaryFaxNumber) or LEN(FORM.BusinessWebsite) or LEN(FORM.APContactName) or LEN(FORM.APContactEmail) or LEN(FORM.ReceiveInvoicesByEmail)>
				<cfswitch expression="#application.configbean.getDBType()#">
					<cfcase value="mysql">
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set
								<cfif LEN(FORM.PrimaryVoiceNumber)>PrimaryVoiceNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PrimaryVoiceNumber)#">,</cfif>
								<cfif LEN(FORM.PrimaryFaxNumber)>PrimaryFaxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PrimaryFaxNumber)#">,</cfif>
								<cfif LEN(FORM.BusinessWebsite)>BusinessWebsite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.BusinessWebsite)#">,</cfif>
								<cfif LEN(FORM.APContactEmail)>AccountsPayable_EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.APContactEmail)#">,</cfif>
								<cfif LEN(FORM.APContactName)>AccountsPayable_ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.APContactName)#">,</cfif>
								<cfif LEN(FORM.ReceiveInvoicesByEmail)>ReceiveInvoicesByEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.ReceiveInvoicesByEmail)#">,</cfif>
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					</cfcase>
					<cfcase value="mssql">
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set
								<cfif LEN(FORM.PrimaryVoiceNumber)>PrimaryVoiceNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PrimaryVoiceNumber)#">,</cfif>
								<cfif LEN(FORM.PrimaryFaxNumber)>PrimaryFaxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PrimaryFaxNumber)#">,</cfif>
								<cfif LEN(FORM.BusinessWebsite)>BusinessWebsite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.BusinessWebsite)#">,</cfif>
								<cfif LEN(FORM.APContactEmail)>AccountsPayable_EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.APContactEmail)#">,</cfif>
								<cfif LEN(FORM.APContactName)>AccountsPayable_ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.APContactName)#">,</cfif>
								<cfif LEN(FORM.ReceiveInvoicesByEmail)>ReceiveInvoicesByEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.ReceiveInvoicesByEmail)#">,</cfif>
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATEDKEY#">
						</cfquery>
					</cfcase>
				</cfswitch>
			</cfif>
			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.default&UserAction=MemberFacilityAdded&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.default&UserAction=MemberFacilityAdded&Successful=True">
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">				
		</cfif>
	</cffunction>

	<cffunction name="editmember" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="SiteConfigSettings" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, Site_ID, Stripe_ProcessPayments, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, GoogleReCaptcha_Enabled, GoogleReCaptcha_SiteKey, GoogleReCaptcha_SecretKey, SmartyStreets_Enabled, SmartyStreets_APIID, SmartyStreets_APIToken, BillForNoShowRegistrations, RequireSurveyToGetCertificate, GitHub_URL, Twitter_URL, Facebook_URL, GoogleProfile_URL, LinkedIn_URL, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID
				From p_EventRegistration_SiteConfig
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar"> 
			</cfquery>
			<cfquery name="getSelectedMember" Datasource="#$.globalConfig('datasource')#" username="#$.globalConfig('dbusername')#" password="#$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, Physical_isAddressVerified, Physical_Latitude, Physical_Longitude, Physical_USPSDeliveryPoint, Physical_USPSCheckDigit, Physical_USPSCarrierRoute, Physical_DST, Physical_UTCOffset, Physical_TimeZone, MailingAddress, MailingCity, MailingState, MailingZipCode, MailingZip4, Mailing_isAddressVerified, Mailing_USPSDeliveryPoint, Mailing_USPSCheckDigit, Mailing_USPSCarrierRoute, PrimaryVoiceNumber, PrimaryFaxNumber, BusinessWebsite, StateDOE_IDNumber, StateDOE_State, StateDOE_ESCESAMembership, AccountsPayable_ContactName, AccountsPayable_EmailAddress, ReceiveInvoicesByEmail, dateCreated, lastUpdated, lastUpdateBy, lastUpdateByID, Active
				From p_EventRegistration_Membership
				Where Site_ID = <cfqueryparam value="#$.siteConfig('siteid')#" cfsqltype="cf_sql_varchar">  and
					TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
				Order by OrganizationName
			</cfquery>
			<cfset Session.SiteConfigSettings = StructCopy(SiteConfigSettings)>
			<cfset Session.getSelectedMember = StructCopy(getSelectedMember)>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Membership Listing">
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfset temp = StructDelete(Session, "SiteConfigSettings")>
				<cfset temp = StructDelete(Session, "getMembership")>
				<cfset temp = StructDelete(Session, "getSelectedMember")>				
				<cfif isDefined("Session.getFacilities")><cfset temp = StructDelete(Session, "getFacilities")></cfif>
				<cfif isDefined("Session.getCaterers")><cfset temp = StructDelete(Session, "getCaterers")></cfif>
				<cfif isDefined("Session.getUsers")><cfset temp = StructDelete(Session, "getUsers")></cfif>
				<cfif isDefined("Session.GetEventGroups")><cfset temp = StructDelete(Session, "GetEventGroups")></cfif>				
				
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.default" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.default" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationName) LT 5>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the registered organization name for this member facility."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationDomainName) LT 7>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the registered organization's domain name for this member facility."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinatormembership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) LT 5 or LEN(FORM.PhysicalCity) LT 4 or LEN(FORM.PhysicalState) LT 2>>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the physical address for this member facility."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinatormembership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter if this member organizataion has active membership with you?."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cfif LEN(cgi.path_info)>
					<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
				<cfelse>
					<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
				</cfif>
				<cflocation url="#variables.newurl#" addtoken="false">
			</cfif>

			<cfif FORM.ReceiveInvoicesByEmail EQ "----"><cfset Form.ReceiveInvoicesByEmail = 0></cfif>

			<cfset Variables.UpdateRecord = StructNew()>
			<cfparam name="Variables.UpdateRecord.OrganizationName" default="0">
			<cfparam name="Variables.UpdateRecord.OrganizationDomainName" default="0">
			<cfparam name="Variables.UpdateRecord.PhysicalAddress" default="0">
			<cfparam name="Variables.UpdateRecord.PhysicalCity" default="0">
			<cfparam name="Variables.UpdateRecord.PhysicalState" default="0">
			<cfparam name="Variables.UpdateRecord.PhysicalZipCode" default="0">
			<cfparam name="Variables.UpdateRecord.PrimaryVoiceNumber" default="0">
			<cfparam name="Variables.UpdateRecord.PrimaryFaxNumber" default="0">
			<cfparam name="Variables.UpdateRecord.BusinessWebsite" default="0">
			<cfparam name="Variables.UpdateRecord.Active" default="0">
			<cfparam name="Variables.UpdateRecord.MailingAddress" default="0">
			<cfparam name="Variables.UpdateRecord.MailingCity" default="0">
			<cfparam name="Variables.UpdateRecord.MailingState" default="0">
			<cfparam name="Variables.UpdateRecord.MailingZipCode" default="0">
			<cfparam name="Variables.UpdateRecord.APContactName" default="0">
			<cfparam name="Variables.UpdateRecord.APContactEmail" default="0">
			<cfparam name="Variables.UpdateRecord.ReceiveInvoicesByEmail" default="0">

			<cfif FORM.OrganizationName NEQ Session.getSelectedMember.OrganizationName><cfset Variables.UpdateRecord.OrganizationName = 1></cfif>
			<cfif FORM.OrganizationDomainName NEQ Session.getSelectedMember.OrganizationDomainName><cfset Variables.UpdateRecord.OrganizationDomainName = 1></cfif>
			<cfif FORM.PhysicalAddress NEQ Session.getSelectedMember.PhysicalAddress><cfset Variables.UpdateRecord.PhysicalAddress = 1></cfif>
			<cfif FORM.PhysicalCity NEQ Session.getSelectedMember.PhysicalCity><cfset Variables.UpdateRecord.PhysicalCity = 1></cfif>
			<cfif FORM.PhysicalState NEQ Session.getSelectedMember.PhysicalState><cfset Variables.UpdateRecord.PhysicalState = 1></cfif>
			<cfif FORM.PhysicalZipCode NEQ Session.getSelectedMember.PhysicalZipCode><cfset Variables.UpdateRecord.PhysicalZipCode = 1></cfif>
			<cfif FORM.PrimaryVoiceNumber NEQ Session.getSelectedMember.PrimaryVoiceNumber><cfset Variables.UpdateRecord.PrimaryVoiceNumber = 1></cfif>
			<cfif FORM.PrimaryFaxNumber NEQ Session.getSelectedMember.PrimaryFaxNumber><cfset Variables.UpdateRecord.PrimaryFaxNumber = 1></cfif>
			<cfif FORM.BusinessWebsite NEQ Session.getSelectedMember.BusinessWebsite><cfset Variables.UpdateRecord.BusinessWebsite = 1></cfif>
			<cfif FORM.Active NEQ Session.getSelectedMember.Active><cfset Variables.UpdateRecord.Active = 1></cfif>
			<cfif FORM.MailingAddress NEQ Session.getSelectedMember.MailingAddress><cfset Variables.UpdateRecord.MailingAddress = 1></cfif>
			<cfif FORM.MailingCity NEQ Session.getSelectedMember.MailingCity><cfset Variables.UpdateRecord.MailingCity = 1></cfif>
			<cfif FORM.MailingState NEQ Session.getSelectedMember.MailingState><cfset Variables.UpdateRecord.MailingState = 1></cfif>
			<cfif FORM.MailingZipCode NEQ Session.getSelectedMember.MailingZipCode><cfset Variables.UpdateRecord.MailingZipCode = 1></cfif>
			<cfif FORM.APContactName NEQ Session.getSelectedMember.AccountsPayable_ContactName><cfset Variables.UpdateRecord.APContactName = 1></cfif>
			<cfif FORM.APContactEmail NEQ Session.getSelectedMember.AccountsPayable_EmailAddress><cfset Variables.UpdateRecord.APContactEmail = 1></cfif>
			<cfif FORM.ReceiveInvoicesByEmail NEQ Session.getSelectedMember.ReceiveInvoicesByEmail><cfset Variables.UpdateRecord.ReceiveInvoicesByEmail = 1></cfif>

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
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					<cfelseif ArrayLen(Variables.PhysicalAddressGeoCoded.Data) GT 0>
						<cfquery name="UpdateCatererAddressInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set PhysicalAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.PhysicalAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								PhysicalCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].city_name)#">,
								PhysicalState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								PhysicalZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].zipcode)#">,
								PhysicalZip4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								GeoCode_Latitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].latitude)#">,
								GeoCode_Longitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].longitude)#">,
								Physical_isAddressVerified = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
								Physical_USPSDeliveryPoint = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].delivery_point)#">,
								Physical_USPSCheckDigit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].delivery_point_check_digit)#">,
								Physical_USPSCarrierRoute = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].carrier_route)#">,
								Physical_DST = <cfqueryparam cfsqltype="cf_sql_bit" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].dst)#">,
								Physical_UTCOffset = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].utc_offset)#">,
								Physical_TimeZone = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].time_zone)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				<cfelse>
					<cfquery name="UpdateCatererAddressInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set PhysicalAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PhysicalAddress)#">,
							PhysicalCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PhysicalCity)#">,
							PhysicalState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PhysicalState)#">,
							PhysicalZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PhysicalZipCode)#">,
							Physical_isAddressVerified = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
			</cfif>

			<cfif variables.UpdateRecord.MailingAddress EQ 1 OR variables.UpdateRecord.MailingCity EQ 1 OR variables.UpdateRecord.MailingState EQ 1 OR variables.UpdateRecord.MailingZipCode EQ 1>
				<cfif Session.SiteConfigSettings.SmartyStreets_Enabled EQ true>
					<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/SmartyStreets").init(apitoken="#Trim(Session.SiteConfigSettings.SmartyStreets_APIToken)#", apiid="#Trim(Session.SiteConfigSettings.SmartyStreets_APIID)#", verbose=true)>
					<cfscript>
						PassedAddress = { street = #FORM.MailingAddress#, city = #FORM.MailingCity#, state = #FORM.MailingState#, zipcode = #FORM.MailingZipCode# };
						PhysicalAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
					</cfscript>
					<cfif LEN(PhysicalAddressGeoCoded.Result.errordetail) GT 0>
						<cfscript>
							errormsg = {property="EmailMsg",message="#PhysicalAddressGeoCoded.Result.errordetail#"};
							arrayAppend(Session.FormErrors, errormsg);
						</cfscript>
						<cfif LEN(cgi.path_info)>
							<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
						<cfelse>
							<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.editmember&FormRetry=True&MemberID=#URL.MemberID#" >
						</cfif>
						<cflocation url="#variables.newurl#" addtoken="false">
					<cfelseif ArrayLen(Variables.PhysicalAddressGeoCoded.Data) GT 0>
						<cfquery name="UpdateCatererAddressInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set MailingAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.PhysicalAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								MailingCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].city_name)#">,
								MailingState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								MailingZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].zipcode)#">,
								MailingZip4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								Mailing_isAddressVerified = <cfqueryparam cfsqltype="cf_sql_bit" value="1">,
								Mailing_USPSDeliveryPoint = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].delivery_point)#">,
								Mailing_USPSCheckDigit = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].delivery_point_check_digit)#">,
								Mailing_USPSCarrierRoute = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].carrier_route)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
								lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
						</cfquery>
					</cfif>
				<cfelse>
					<cfquery name="UpdateCatererAddressInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set MailingAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.MailingAddress)#">,
							MailingCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.MailingCity)#">,
							MailingState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.MailingState)#">,
							MailingZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.MailingZipCode)#">,
							Mailing_isAddressVerified = <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
							lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
					</cfquery>
				</cfif>
			</cfif>

			<cfif Variables.UpdateRecord.OrganizationName EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Membership
					Set OrganizationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.OrganizationName)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.OrganizationDomainName EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Membership
					Set OrganizationDomainName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.OrganizationDomainName)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.APContactName EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Membership
					Set AccountsPayable_ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.APContactName)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.APContactEmail EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Membership
					Set AccountsPayable_EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.APContactEmail)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.ReceiveInvoicesByEmail EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Membership
					Set ReceiveInvoicesByEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.ReceiveInvoicesByEmail)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.PrimaryVoiceNumber EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Membership
					Set PrimaryVoiceNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PrimaryVoiceNumber)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.PrimaryFaxNumber EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Membership
					Set PrimaryFaxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.PrimaryFaxNumber)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.BusinessWebsite EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Membership
					Set BusinessWebsite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(FORM.BusinessWebsite)#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif Variables.UpdateRecord.Active EQ 1>
				<cfquery name="UpdateCatererInfo" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Membership
					Set Active = <cfqueryparam value="#FORM.Active#" cfsqltype="cf_sql_bit">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.LName#">,
						lastUpdateByID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam value="#URL.MemberID#" cfsqltype="cf_sql_integer">
				</cfquery>
			</cfif>

			<cfif LEN(cgi.path_info)>
				<cfset newurl = #cgi.script_name# & #cgi.path_info# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.default&UserAction=MemberFacilityUpdated&Successful=True" >
			<cfelse>
				<cfset newurl = #cgi.script_name# & "?" & #Session.PluginFramework.Action# & "=eventcoordinator:membership.default&UserAction=MemberFacilityUpdated&Successful=True">
			</cfif>
			<cflocation url="#variables.newurl#" addtoken="false">

		</cfif>
	</cffunction>
</cfcomponent>