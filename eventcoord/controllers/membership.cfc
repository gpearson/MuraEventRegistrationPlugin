<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="Session.getMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active, Physical_Address, Physical_City, Physical_State, Physical_ZipCode, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, AccountsPayable_EmailAddress, AccountsPayable_ContactName
			From p_EventRegistration_Membership
			Order by OrganizationName ASC
		</cfquery>
		<cfquery name="Session.getSiteConfig" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select ProcessPayments_Stripe, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, Google_ReCaptchaSiteKey, Google_ReCaptchaSecretKey, SmartyStreets_Enabled, SmartyStreets_ApiID, SmartyStreets_APIToken
			From p_EventRegistration_SiteConfig
			Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
		</cfquery>
	</cffunction>

	<cffunction name="getAllMembership" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrCaterers = ArrayNew(1)>
		<cfif isDefined("URL._search")>
			<cfif URL._search EQ "false">
				<cfquery name="getFacilities" dbtype="Query">
					Select TContent_ID, OrganizationName, Physical_City, Physical_State, Primary_PhoneNumber, Active
					From Session.getMemberships
					<cfif Arguments.sidx NEQ "">
						Order By #Arguments.sidx# #Arguments.sord#
					<cfelse>
						Order by OrganizationName ASC
					</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="getFacilities" dbtype="Query">
					Select TContent_ID, OrganizationName, Physical_City, Physical_State, Primary_PhoneNumber, Active
					From Session.getMemberships
					<cfif Arguments.sidx NEQ "">
						<cfswitch expression="#URL.searchOper#">
							<cfcase value="eq">
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="ne">
								<!--- Not Equal --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="bw">
								<!--- Begin With --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="bn">
								<!--- Does Not Begin With  --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="ew">
								<!--- Ends With --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="en">
								<!--- Does Not End With --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="cn">
								<!--- Contains --->
								Where #URL.searchField# LIKE '%#URL.searchString#%'
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
			<cfquery name="getFacilities" dbtype="Query">
				Select TContent_ID, OrganizationName, Physical_City, Physical_State, Primary_PhoneNumber, Active
				From Session.getMemberships
				<cfif Arguments.sidx NEQ "">
					Order By #Arguments.sidx# #Arguments.sord#
				<cfelse>
					Order by OrganizationName ASC
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

		<cfloop query="getFacilities" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfif #Active# EQ 1>
				<cfset strActive = "Yes">
			<cfelse>
				<cfset strActive = "No">
			</cfif>
			<cfset arrCaterers[i] = [#TContent_ID#,#OrganizationName#,#Physical_City#,#Physical_State#,#Primary_PhoneNumber#,#strActive#]>
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

	<cffunction name="editmembership" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedMembership" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, StateDOE_ESCESAMembership, Active, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Mailing_ZipPlus4, Mailing_DeliveryPointBarcode, Primary_PhoneNumber, Primary_FaxNumber, Physical_Address, Physical_City, Physical_State, Physical_ZipCode, Physical_ZipPlus4, Physical_DeliveryPointBarcode, Physical_Latitude, Physical_Longitude, Physical_TimeZone, Physical_DST, Physical_UTCOffset, Physical_CountyName, Physical_CongressionalDistrict, Physical_CarrierRoute, AccountsPayable_EmailAddress, AccountsPayable_ContactName, ReceiveInvoicesByEmail
				From p_EventRegistration_Membership
				Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.MembershipID#">
				Order by OrganizationName ASC
			</cfquery>
			<cfquery name="Session.getESCESAAgencies" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, Physical_Address, Physical_City, Physical_State, Physical_ZipCode
				From p_EventRegistration_StateESCOrganizations
				Order by Physical_State ASC, OrganizationName ASC
			</cfquery>
			<cfquery name="Session.getSiteConfig" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ProcessPayments_Stripe, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, Google_ReCaptchaSiteKey, Google_ReCaptchaSecretKey, SmartyStreets_Enabled, SmartyStreets_ApiID, SmartyStreets_APIToken
				From p_EventRegistration_SiteConfig
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getCaterers")>
				<cfset temp = StructDelete(Session, "getSelectedCaterer")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.default" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select which ESC/ESA Membership Affiliation this organization is with."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationDomainName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select which ESC/ESA Membership Affiliation this organization is with."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) EQ 0 or LEN(FORM.PhysicalCity) EQ 0 OR LEN(FORM.PhysicalState) EQ 0 OR LEN(FORM.PhysicalZipCode) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the physical address of this organization."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Organization has active membership with your organization or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
			</cfif>

			<cfif FORM.ReceiveInvoicesByEmail EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Organization will receive invoices electronically or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
			</cfif>

			<cfquery name="InsertMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				update p_EventRegistration_Membership
				Set OrganizationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
					OrganizationDomainName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
					Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
					lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
				Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
			</cfquery>

			<cfif Session.getSiteConfig.SmartyStreets_Enabled EQ true>
				<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/SmartyStreets").init(apitoken="#Session.getSiteConfig.SmartyStreets_APIToken#", apiid="#Session.getSiteConfig.SmartyStreets_APIID#", verbose=true)>

				<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
					<cfscript>
						PassedAddress = { street = #FORM.MailingAddress#, city = #FORM.MailingCity#, state = #FORM.MailingState#, zipcode = #FORM.MailingZipCode# };
						MailingAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
					</cfscript>

					<cfif LEN(MailingAddressGeoCoded.Result.errordetail) GT 0>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								address = {property="BusinessAddress",message="#MailingAddressGeoCoded.Result.errordetail#"};
								arrayAppend(Session.FormErrors, address);
							</cfscript>
						</cflock>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
					<cfelseif ArrayLen(Variables.MailingAddressGeoCoded.Data) GT 0>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.MailingAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].city_name)#">,
								Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].zipcode)#">,
								Mailing_ZipPlus4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								Mailing_DeliveryPointBarcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['delivery_point_barcode'])#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
						</cfquery>
					<cfelse>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingAddress)#">,
								Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingCity)#">,
								Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingState)#">,
								Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingZipCode)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
						</cfquery>
					</cfif>
				</cfif>

				<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
					<cfscript>
						PassedAddress = { street = #FORM.PhysicalAddress#, city = #FORM.PhysicalCity#, state = #FORM.PhysicalState#, zipcode = #FORM.PhysicalZipCode# };
						PhysicalAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
					</cfscript>

					<cfif LEN(PhysicalAddressGeoCoded.Result.errordetail) GT 0>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								address = {property="BusinessAddress",message="#PhysicalAddressGeoCoded.Result.errordetail#"};
								arrayAppend(Session.FormErrors, address);
							</cfscript>
						</cflock>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
					<cfelseif ArrayLen(Variables.PhysicalAddressGeoCoded.Data) GT 0>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.PhysicalAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].city_name)#">,
								Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].zipcode)#">,
								Physical_ZipPlus4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								Physical_DeliveryPointBarcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['delivery_point_barcode'])#">,
								Physical_Latitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].latitude)#">,
								Physical_Longitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].longitude)#">,
								Physical_DST = <cfqueryparam cfsqltype="cf_sql_bit" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].dst)#">,
								Physical_UTCOffset = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].utc_offset)#">,
								Physical_CountyName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].county_name)#">,
								Physical_CarrierRoute = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].carrier_route)#">,
								Physical_CongressionalDistrict = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].congressional_district)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
						</cfquery>
					<cfelse>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalAddress)#">,
								Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalCity)#">,
								Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalState)#">,
								Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalZipCode)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
						</cfquery>
					</cfif>
				</cfif>
			<cfelse>
				<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingAddress)#">,
							Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingCity)#">,
							Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingState)#">,
							Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingZipCode)#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>

				<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalAddress)#">,
							Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalCity)#">,
							Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalState)#">,
							Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalZipCode)#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.PrimaryPhoneNumber")>
				<cfif LEN(FORM.PrimaryPhoneNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set Primary_PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.PrimaryFaxNumber")>
				<cfif LEN(FORM.PrimaryFaxNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set Primary_FaxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.StateDOEIDNumber")>
				<cfif LEN(FORM.StateDOEIDNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set StateDOE_IDNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.StateDOEState")>
				<cfif LEN(FORM.StateDOEState)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set StateDOE_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.StateESCMembership")>
				<cfif LEN(FORM.StateESCMembership)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set StateDOE_ESCESAMembership = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.StateESCMembership#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.AccountsPayableEmailAddress")>
				<cfif LEN(FORM.AccountsPayableEmailAddress)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set AccountsPayable_EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableEmailAddress#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.AccountsPayableContactName")>
				<cfif LEN(FORM.AccountsPayableContactName)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set AccountsPayable_ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableContactName#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.ReceiveInvoicesByEmail")>
				<cfif LEN(FORM.ReceiveInvoicesByEmail)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set ReceiveInvoicesByEmail = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ReceiveInvoicesByEmail#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.default&UserAction=InformationUpdated&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="addmembership" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getESCESAAgencies" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, Physical_Address, Physical_City, Physical_State, Physical_ZipCode
				From p_EventRegistration_StateESCOrganizations
				Order by Physical_State ASC, OrganizationName ASC
			</cfquery>
			<cfquery name="Session.getSiteConfig" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select ProcessPayments_Stripe, Stripe_TestMode, Stripe_TestAPIKey, Stripe_LiveAPIKey, Facebook_Enabled, Facebook_AppID, Facebook_AppSecretKey, Facebook_PageID, Facebook_AppScope, Google_ReCaptchaSiteKey, Google_ReCaptchaSecretKey, SmartyStreets_Enabled, SmartyStreets_ApiID, SmartyStreets_APIToken
				From p_EventRegistration_SiteConfig
				Where Site_ID = <cfqueryparam value="#rc.$.siteConfig('siteID')#" cfsqltype="cf_sql_varchar">
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getCaterers")>
				<cfset temp = StructDelete(Session, "getSelectedCaterer")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.default" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select which ESC/ESA Membership Affiliation this organization is with."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationDomainName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select which ESC/ESA Membership Affiliation this organization is with."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) EQ 0 or LEN(FORM.PhysicalCity) EQ 0 OR LEN(FORM.PhysicalState) EQ 0 OR LEN(FORM.PhysicalZipCode) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the physical address of this organization."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.StateESCMembership EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select which ESC/ESA Membership Affiliation this organization is with."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Organization has active membership with your organization or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.ReceiveInvoicesByEmail EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Organization will receive invoices electronically or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfquery name="InsertMembershipInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				insert into p_EventRegistration_Membership(Site_ID, OrganizationName, OrganizationDomainName, Active, dateCreated, lastUpdateBy, lastUpdated)
				Values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="NIESCEvents">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
					<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
			</cfquery>

			<cfif Session.getSiteConfig.SmartyStreets_Enabled EQ true>
				<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/SmartyStreets").init(apitoken="#Session.getSiteConfig.SmartyStreets_APIToken#", apiid="#Session.getSiteConfig.SmartyStreets_APIID#", verbose=true)>

				<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
					<cfscript>
						PassedAddress = { street = #FORM.MailingAddress#, city = #FORM.MailingCity#, state = #FORM.MailingState#, zipcode = #FORM.MailingZipCode# };
						MailingAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
					</cfscript>

					<cfif LEN(MailingAddressGeoCoded.Result.errordetail) GT 0>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								address = {property="BusinessAddress",message="#MailingAddressGeoCoded.Result.errordetail#"};
								arrayAppend(Session.FormErrors, address);
							</cfscript>
						</cflock>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
					<cfelseif ArrayLen(Variables.MailingAddressGeoCoded.Data) GT 0>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.MailingAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].city_name)#">,
								Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].zipcode)#">,
								Mailing_ZipPlus4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								Mailing_DeliveryPointBarcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['delivery_point_barcode'])#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					<cfelse>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingAddress)#">,
								Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingCity)#">,
								Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingState)#">,
								Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingZipCode)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					</cfif>
				</cfif>

				<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
					<cfscript>
						PassedAddress = { street = #FORM.PhysicalAddress#, city = #FORM.PhysicalCity#, state = #FORM.PhysicalState#, zipcode = #FORM.PhysicalZipCode# };
						PhysicalAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
					</cfscript>

					<cfif LEN(PhysicalAddressGeoCoded.Result.errordetail) GT 0>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								address = {property="BusinessAddress",message="#PhysicalAddressGeoCoded.Result.errordetail#"};
								arrayAppend(Session.FormErrors, address);
							</cfscript>
						</cflock>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
					<cfelseif ArrayLen(Variables.PhysicalAddressGeoCoded.Data) GT 0>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.PhysicalAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].city_name)#">,
								Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].zipcode)#">,
								Physical_ZipPlus4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								Physical_DeliveryPointBarcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['delivery_point_barcode'])#">,
								Physical_Latitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].latitude)#">,
								Physical_Longitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].longitude)#">,
								Physical_DST = <cfqueryparam cfsqltype="cf_sql_bit" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].dst)#">,
								Physical_UTCOffset = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].utc_offset)#">,
								Physical_CountyName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].county_name)#">,
								Physical_CarrierRoute = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].carrier_route)#">,
								Physical_CongressionalDistrict = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].congressional_district)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					<cfelse>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalAddress)#">,
								Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalCity)#">,
								Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalState)#">,
								Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalZipCode)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					</cfif>
				</cfif>
			<cfelse>
				<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingAddress)#">,
							Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingCity)#">,
							Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingState)#">,
							Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingZipCode)#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>

				<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalAddress)#">,
							Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalCity)#">,
							Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalState)#">,
							Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalZipCode)#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.PrimaryPhoneNumber")>
				<cfif LEN(FORM.PrimaryPhoneNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set Primary_PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.PrimaryFaxNumber")>
				<cfif LEN(FORM.PrimaryFaxNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set Primary_FaxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.StateDOEIDNumber")>
				<cfif LEN(FORM.StateDOEIDNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set StateDOE_IDNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.StateDOEState")>
				<cfif LEN(FORM.StateDOEState)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set StateDOE_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.StateESCMembership")>
				<cfif LEN(FORM.StateESCMembership)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set StateDOE_ESCESAMembership = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.StateESCMembership#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.AccountsPayableEmailAddress")>
				<cfif LEN(FORM.AccountsPayableEmailAddress)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set AccountsPayable_EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableEmailAddress#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.AccountsPayableContactName")>
				<cfif LEN(FORM.AccountsPayableContactName)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set AccountsPayable_ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableContactName#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.ReceiveInvoicesByEmail")>
				<cfif LEN(FORM.ReceiveInvoicesByEmail)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set ReceiveInvoicesByEmail = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ReceiveInvoicesByEmail#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.default&UserAction=InformationUpdated&Successful=True" addtoken="false">
		</cfif>

	</cffunction>

	<cffunction name="listescesa" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="Session.getStateESCESAs" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Mailing_Address, Mailing_City, Mailing_State, Physical_City, Physical_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber
			From p_EventRegistration_StateESCOrganizations
			Order by OrganizationName ASC
		</cfquery>
	</cffunction>

	<cffunction name="getAllESCESA" access="remote" returnformat="json">
		<cfargument name="page" required="no" default="1" hint="Page user is on">
		<cfargument name="rows" required="no" default="10" hint="Number of Rows to display per page">
		<cfargument name="sidx" required="no" default="" hint="Sort Column">
		<cfargument name="sord" required="no" default="ASC" hint="Sort Order">

		<cfset var arrCaterers = ArrayNew(1)>
		<cfif isDefined("URL._search")>
			<cfif URL._search EQ "false">
				<cfquery name="getFacilities" dbtype="Query">
					Select TContent_ID, OrganizationName, Physical_City, Physical_State, Primary_PhoneNumber
					From Session.getStateESCESAs
					<cfif Arguments.sidx NEQ "">
						Order By #Arguments.sidx# #Arguments.sord#
					<cfelse>
						Order by OrganizationName ASC
					</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="getFacilities" dbtype="Query">
					Select TContent_ID, OrganizationName, Physical_City,  Physical_State, Primary_PhoneNumber
					From Session.getStateESCESAs
					<cfif Arguments.sidx NEQ "">
						<cfswitch expression="#URL.searchOper#">
							<cfcase value="eq">
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="ne">
								<!--- Not Equal --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="bw">
								<!--- Begin With --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="bn">
								<!--- Does Not Begin With  --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="ew">
								<!--- Ends With --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="en">
								<!--- Does Not End With --->
								Where #URL.searchField# = '#URL.searchString#'
							</cfcase>
							<cfcase value="cn">
								<!--- Contains --->
								Where #URL.searchField# LIKE '%#URL.searchString#%'
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
			<cfquery name="getFacilities" dbtype="Query">
				Select TContent_ID, OrganizationName, Physical_City, Physical_State, Primary_PhoneNumber
				From Session.getStateESCESAs
				<cfif Arguments.sidx NEQ "">
					Order By #Arguments.sidx# #Arguments.sord#
				<cfelse>
					Order by OrganizationName ASC
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

		<cfloop query="getFacilities" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfset arrCaterers[i] = [#TContent_ID#,#OrganizationName#,#Physical_City#,#Physical_State#,#Primary_PhoneNumber#]>
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

	<cffunction name="addstateesc" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>

		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getCaterers")>
				<cfset temp = StructDelete(Session, "getSelectedCaterer")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.listescesa" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter Organization Name"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addstateesc&FormRetry=True" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationDomainName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the organizations domain name for this organization"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addstateesc&FormRetry=True" addtoken="false">
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) EQ 0 or LEN(FORM.PhysicalCity) EQ 0 OR LEN(FORM.PhysicalState) EQ 0 OR LEN(FORM.PhysicalZipCode) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the physical address of this organization."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addstateesc&FormRetry=True" addtoken="false">
			</cfif>

			<cfquery name="InsertStateESCESAInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				insert into p_EventRegistration_StateESCOrganizations(Site_ID, OrganizationName, OrganizationDomainName, dateCreated, lastUpdateBy, lastUpdated)
				Values(
					<cfqueryparam cfsqltype="cf_sql_varchar" value="NIESCEvents">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
			</cfquery>

			<cfif Session.getSiteConfig.SmartyStreets_Enabled EQ true>
				<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/SmartyStreets").init(apitoken="#Session.getSiteConfig.SmartyStreets_APIToken#", apiid="#Session.getSiteConfig.SmartyStreets_APIID#", verbose=true)>

				<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
					<cfscript>
						PassedAddress = { street = #FORM.MailingAddress#, city = #FORM.MailingCity#, state = #FORM.MailingState#, zipcode = #FORM.MailingZipCode# };
						MailingAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
					</cfscript>

					<cfif LEN(MailingAddressGeoCoded.Result.errordetail) GT 0>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								address = {property="BusinessAddress",message="#MailingAddressGeoCoded.Result.errordetail#"};
								arrayAppend(Session.FormErrors, address);
							</cfscript>
						</cflock>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
					<cfelseif ArrayLen(Variables.MailingAddressGeoCoded.Data) GT 0>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_StateESCOrganizations
							Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.MailingAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].city_name)#">,
								Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].zipcode)#">,
								Mailing_ZipPlus4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								Mailing_DeliveryPointBarcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['delivery_point_barcode'])#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					<cfelse>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_StateESCOrganizations
							Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingAddress)#">,
								Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingCity)#">,
								Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingState)#">,
								Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingZipCode)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					</cfif>
				</cfif>

				<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
					<cfscript>
						PassedAddress = { street = #FORM.PhysicalAddress#, city = #FORM.PhysicalCity#, state = #FORM.PhysicalState#, zipcode = #FORM.PhysicalZipCode# };
						PhysicalAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
					</cfscript>

					<cfif LEN(PhysicalAddressGeoCoded.Result.errordetail) GT 0>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								address = {property="BusinessAddress",message="#PhysicalAddressGeoCoded.Result.errordetail#"};
								arrayAppend(Session.FormErrors, address);
							</cfscript>
						</cflock>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
					<cfelseif ArrayLen(Variables.PhysicalAddressGeoCoded.Data) GT 0>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_StateESCOrganizations
							Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.PhysicalAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].city_name)#">,
								Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].zipcode)#">,
								Physical_ZipPlus4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								Physical_DeliveryPointBarcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['delivery_point_barcode'])#">,
								Physical_Latitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].latitude)#">,
								Physical_Longitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].longitude)#">,
								Physical_DST = <cfqueryparam cfsqltype="cf_sql_bit" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].dst)#">,
								Physical_UTCOffset = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].utc_offset)#">,
								Physical_CountyName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].county_name)#">,
								Physical_CarrierRoute = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].carrier_route)#">,
								Physical_CongressionalDistrict = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].congressional_district)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					<cfelse>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_StateESCOrganizations
							Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalAddress)#">,
								Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalCity)#">,
								Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalState)#">,
								Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalZipCode)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					</cfif>
				</cfif>
			<cfelse>
				<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingAddress)#">,
							Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingCity)#">,
							Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingState)#">,
							Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingZipCode)#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>

				<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalAddress)#">,
							Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalCity)#">,
							Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalState)#">,
							Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalZipCode)#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.PrimaryPhoneNumber")>
				<cfif LEN(FORM.PrimaryPhoneNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set Primary_PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.PrimaryFaxNumber")>
				<cfif LEN(FORM.PrimaryFaxNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set Primary_FaxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.StateDOEIDNumber")>
				<cfif LEN(FORM.StateDOEIDNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set StateDOE_IDNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.StateDOEState")>
				<cfif LEN(FORM.StateDOEState)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set StateDOE_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
					</cfquery>
				</cfif>
			</cfif>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.listescesa&UserAction=InformationAdded&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="editstateesc" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedESC" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Mailing_ZipPlus4, Primary_PhoneNumber, Primary_FaxNumber, Physical_Address, Physical_City, Physical_State, Physical_ZipCode, Physical_ZipPlus4, Physical_DeliveryPointBarcode, Physical_Latitude, Physical_Longitude, Physical_TimeZone, Physical_DST, Physical_UTCOffset, Physical_CountyName, Physical_CarrierRoute, Physical_CongressionalDistrict
				From p_EventRegistration_StateESCOrganizations
				Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.MembershipID#">
				Order by Physical_State ASC, OrganizationName ASC
			</cfquery>
		<cfelseif isDefined("FORM.formSubmit")>
			<cflock timeout="60" scope="Session" type="Exclusive">
				<cfset Session.FormErrors = #ArrayNew()#>
				<cfset Session.FormInput = #StructCopy(FORM)#>
			</cflock>
			<cfif FORM.UserAction EQ "Back to Main Menu">
				<cfset temp = StructDelete(Session, "getSelectedESC")>
				<cfset temp = StructDelete(Session, "FormErrors")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.listescesa" addtoken="false">
			</cfif>

			<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				update p_EventRegistration_StateESCOrganizations
				Set OrganizationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
					OrganizationDomainName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
					StateDOE_IDNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
					StateDOE_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
					lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
				Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
			</cfquery>

			<cfif Session.getSiteConfig.SmartyStreets_Enabled EQ true>
				<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/SmartyStreets").init(apitoken="#Session.getSiteConfig.SmartyStreets_APIToken#", apiid="#Session.getSiteConfig.SmartyStreets_APIID#", verbose=true)>

				<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
					<cfscript>
						PassedAddress = { street = #FORM.MailingAddress#, city = #FORM.MailingCity#, state = #FORM.MailingState#, zipcode = #FORM.MailingZipCode# };
						MailingAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
					</cfscript>

					<cfif LEN(MailingAddressGeoCoded.Result.errordetail) GT 0>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								address = {property="BusinessAddress",message="#MailingAddressGeoCoded.Result.errordetail#"};
								arrayAppend(Session.FormErrors, address);
							</cfscript>
						</cflock>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
					<cfelseif ArrayLen(Variables.MailingAddressGeoCoded.Data) GT 0>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_StateESCOrganizations
							Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.MailingAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].city_name)#">,
								Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].zipcode)#">,
								Mailing_ZipPlus4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								Mailing_DeliveryPointBarcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded.Data[1]['delivery_point_barcode'])#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
						</cfquery>
					<cfelse>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_StateESCOrganizations
							Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingAddress)#">,
								Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingCity)#">,
								Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingState)#">,
								Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingZipCode)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
						</cfquery>
					</cfif>
				</cfif>

				<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
					<cfscript>
						PassedAddress = { street = #FORM.PhysicalAddress#, city = #FORM.PhysicalCity#, state = #FORM.PhysicalState#, zipcode = #FORM.PhysicalZipCode# };
						PhysicalAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
					</cfscript>

					<cfif LEN(PhysicalAddressGeoCoded.Result.errordetail) GT 0>
						<cflock timeout="60" scope="SESSION" type="Exclusive">
							<cfscript>
								address = {property="BusinessAddress",message="#PhysicalAddressGeoCoded.Result.errordetail#"};
								arrayAppend(Session.FormErrors, address);
							</cfscript>
						</cflock>
						<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.addmembership&FormRetry=True" addtoken="false">
					<cfelseif ArrayLen(Variables.PhysicalAddressGeoCoded.Data) GT 0>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_StateESCOrganizations
							Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.PhysicalAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
								Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].city_name)#">,
								Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
								Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].zipcode)#">,
								Physical_ZipPlus4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].plus4_code)#">,
								Physical_DeliveryPointBarcode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['delivery_point_barcode'])#">,
								Physical_Latitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].latitude)#">,
								Physical_Longitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].longitude)#">,
								Physical_DST = <cfqueryparam cfsqltype="cf_sql_bit" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].dst)#">,
								Physical_UTCOffset = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].utc_offset)#">,
								Physical_CountyName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].county_name)#">,
								Physical_CarrierRoute = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].carrier_route)#">,
								Physical_CongressionalDistrict = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].congressional_district)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
						</cfquery>
					<cfelse>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_StateESCOrganizations
							Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalAddress)#">,
								Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalCity)#">,
								Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalState)#">,
								Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalZipCode)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
						</cfquery>
					</cfif>
				</cfif>
			<cfelse>
				<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingAddress)#">,
							Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingCity)#">,
							Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingState)#">,
							Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.MailingZipCode)#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>

				<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalAddress)#">,
							Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalCity)#">,
							Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalState)#">,
							Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(FORM.PhysicalZipCode)#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.PrimaryPhoneNumber")>
				<cfif LEN(FORM.PrimaryPhoneNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set Primary_PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.PrimaryFaxNumber")>
				<cfif LEN(FORM.PrimaryFaxNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set Primary_FaxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.StateDOEIDNumber")>
				<cfif LEN(FORM.StateDOEIDNumber)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set StateDOE_IDNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>

			<cfif isDefined("FORM.StateDOEState")>
				<cfif LEN(FORM.StateDOEState)>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set StateDOE_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.listescesa&UserAction=InformationUpdated&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

</cfcomponent>
