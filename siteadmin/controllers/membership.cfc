<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="Session.getMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active, Physical_Address, Physical_City, Physical_State, Physical_ZipCode, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, AccountsPayable_EmailAddress, AccountsPayable_ContactName
			From p_EventRegistration_Membership
			Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
			Order by OrganizationName ASC
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
						Where #URL.searchField# LIKE '%#URL.searchString#'
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
				Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, StateDOE_ESCESAMembership, Active, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, Physical_Address, Physical_City, Physical_State, Physical_ZipCode, AccountsPayable_EmailAddress, AccountsPayable_ContactName, ReceiveInvoicesByEmail
				From p_EventRegistration_Membership
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">  and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.MembershipID#">
				Order by OrganizationName ASC
			</cfquery>
			<cfquery name="Session.getESCESAAgencies" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, Physical_Address, Physical_City, Physical_State, Physical_ZipCode
				From p_EventRegistration_StateESCOrganizations
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
				Order by Physical_State ASC, OrganizationName ASC
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
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.default" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select which ESC/ESA Membership Affiliation this organization is with."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationDomainName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select which ESC/ESA Membership Affiliation this organization is with."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) EQ 0 or LEN(FORM.PhysicalCity) EQ 0 OR LEN(FORM.PhysicalState) EQ 0 OR LEN(FORM.PhysicalZipCode) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the physical address of this organization."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Organization has active membership with your organization or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
			</cfif>

			<cfif FORM.ReceiveInvoicesByEmail EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Organization will receive invoices electronically or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
			</cfif>

			<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/GoogleGeoCoder")>

			<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
				<cfset MailingAddressGeoCoded = #GeoCodeCFC.GeoCodeAddress(Form.MailingAddress, FORM.MailingCity, FORM.MailingState, FORM.MailingZipCode)#>

				<cfif MailingAddressGeoCoded[1].ErrorMessage NEQ "OK">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
				<cfelse>
					<cfset CombinedPhysicalAddress = #MailingAddressGeoCoded[1].AddressStreetNumber# & " " & #MailingAddressGeoCoded[1].AddressStreetNameShort#>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set OrganizationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
							Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
							Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressCityName)#">,
							Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressStateNameShort)#">,
							Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressZipCode)#">,
							Primary_PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
							Primary_FaxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
							OrganizationDomainName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
							StateDOE_IDNUmber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
							StateDOE_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
							StateDOE_ESCESAMembership = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.StateESCMembership#">,
							Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
							AccountsPayable_EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableEmailAddress#">,
							AccountsPayable_ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableContactName#">,
							ReceiveInvoicesByEmail = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ReceiveInvoicesByEmail#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			<cfelse>
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_Membership
					Set OrganizationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
						Primary_PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
						Primary_FaxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
						OrganizationDomainName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
						StateDOE_IDNUmber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
						StateDOE_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
						StateDOE_ESCESAMembership = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.StateESCMembership#">,
						Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
						AccountsPayable_EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableEmailAddress#">,
						AccountsPayable_ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableContactName#">,
						ReceiveInvoicesByEmail = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ReceiveInvoicesByEmail#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
				</cfquery>
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
				<cfset PhysicalAddressGeoCoded = #GeoCodeCFC.GeoCodeAddress(Form.PhysicalAddress, FORM.PhysicalCity, FORM.PhysicalState, FORM.PhysicalZipCode)#>

				<cfif PhysicalAddressGeoCoded[1].ErrorMessage NEQ "OK">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
				<cfelse>
					<cfset CombinedPhysicalAddress = #PhysicalAddressGeoCoded[1].AddressStreetNumber# & " " & #PhysicalAddressGeoCoded[1].AddressStreetNameShort#>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
							Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressCityName)#">,
							Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressStateNameShort)#">,
							Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressZipCode)#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.default&UserAction=InformationUpdated&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="addmembership" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getESCESAAgencies" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, Physical_Address, Physical_City, Physical_State, Physical_ZipCode
				From p_EventRegistration_StateESCOrganizations
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
				Order by Physical_State ASC, OrganizationName ASC
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
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.default" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select which ESC/ESA Membership Affiliation this organization is with."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationDomainName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select which ESC/ESA Membership Affiliation this organization is with."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) EQ 0 or LEN(FORM.PhysicalCity) EQ 0 OR LEN(FORM.PhysicalState) EQ 0 OR LEN(FORM.PhysicalZipCode) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the physical address of this organization."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.StateESCMembership EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select which ESC/ESA Membership Affiliation this organization is with."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Organization has active membership with your organization or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfif FORM.ReceiveInvoicesByEmail EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Organization will receive invoices electronically or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addmembership&FormRetry=True" addtoken="false">
			</cfif>

			<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/GoogleGeoCoder")>

			<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
				<cfset MailingAddressGeoCoded = #GeoCodeCFC.GeoCodeAddress(Form.MailingAddress, FORM.MailingCity, FORM.MailingState, FORM.MailingZipCode)#>

				<cfif MailingAddressGeoCoded[1].ErrorMessage NEQ "OK">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addmembership&FormRetry=True" addtoken="false">
				<cfelse>
					<cfset CombinedPhysicalAddress = #MailingAddressGeoCoded[1].AddressStreetNumber# & " " & #MailingAddressGeoCoded[1].AddressStreetNameShort#>
					<cfquery name="updateMembershipInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						insert into p_EventRegistration_Membership(Site_ID, OrganizationName, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, OrganizationDomainName, StateDOE_IDNUmber, StateDOE_State, StateDOE_ESCESAMembership, Active, AccountsPayable_EmailAddress, AccountsPayable_ContactName, ReceiveInvoicesByEmail, dateCreated, lastUpdated, lastUpdateBy)
						Values(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressCityName)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressStateNameShort)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressZipCode)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.StateESCMembership#">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableEmailAddress#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableContactName#">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ReceiveInvoicesByEmail#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						)
					</cfquery>
				</cfif>
			<cfelse>
				<cfquery name="updateMembershipInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					insert into p_EventRegistration_Membership(Site_ID, OrganizationName, Primary_PhoneNumber, Primary_FaxNumber, OrganizationDomainName, StateDOE_IDNUmber, StateDOE_State, StateDOE_ESCESAMembership, Active, AccountsPayable_EmailAddress, AccountsPayable_ContactName, ReceiveInvoicesByEmail, dateCreated, lastUpdated, lastUpdateBy)
					Values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.StateESCMembership#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableEmailAddress#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableContactName#">,
						<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ReceiveInvoicesByEmail#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					)
				</cfquery>
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
				<cfset PhysicalAddressGeoCoded = #GeoCodeCFC.GeoCodeAddress(Form.PhysicalAddress, FORM.PhysicalCity, FORM.PhysicalState, FORM.PhysicalZipCode)#>

				<cfif PhysicalAddressGeoCoded[1].ErrorMessage NEQ "OK">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addmembership&FormRetry=True" addtoken="false">
				<cfelse>
					<cfset CombinedPhysicalAddress = #PhysicalAddressGeoCoded[1].AddressStreetNumber# & " " & #PhysicalAddressGeoCoded[1].AddressStreetNameShort#>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Membership
								Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
									Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressCityName)#">,
									Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressStateNameShort)#">,
									Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressZipCode)#">,
									lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_Membership
								Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
									Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressCityName)#">,
									Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressStateNameShort)#">,
									Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressZipCode)#">,
									lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.IdentityCol#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>
			</cfif>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.default&UserAction=InformationUpdated&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="listescesa" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="Session.getStateESCESAs" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Mailing_Address, Mailing_City, Mailing_State, Physical_City, Physical_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber
			From p_EventRegistration_StateESCOrganizations
			Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
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
						Where #URL.searchField# LIKE '%#URL.searchString#'
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
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.listescesa" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter Organization Name"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addstateesc&FormRetry=True" addtoken="false">
			</cfif>

			<cfif LEN(FORM.OrganizationDomainName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the organizations domain name for this organization"};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addstateesc&FormRetry=True" addtoken="false">
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) EQ 0 or LEN(FORM.PhysicalCity) EQ 0 OR LEN(FORM.PhysicalState) EQ 0 OR LEN(FORM.PhysicalZipCode) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the physical address of this organization."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addstateesc&FormRetry=True" addtoken="false">
			</cfif>


			<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/GoogleGeoCoder")>

			<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
				<cfset MailingAddressGeoCoded = #GeoCodeCFC.GeoCodeAddress(Form.MailingAddress, FORM.MailingCity, FORM.MailingState, FORM.MailingZipCode)#>

				<cfif MailingAddressGeoCoded[1].ErrorMessage NEQ "OK">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addstateesc&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
				<cfelse>
					<cfset CombinedPhysicalAddress = #MailingAddressGeoCoded[1].AddressStreetNumber# & " " & #MailingAddressGeoCoded[1].AddressStreetNameShort#>
					<cfquery name="updateMembershipInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						insert into p_EventRegistration_StateESCOrganizations(Site_ID, OrganizationName, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, OrganizationDomainName, StateDOE_IDNUmber, StateDOE_State, dateCreated, lastUpdated, lastUpdateBy)
						Values(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressCityName)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressStateNameShort)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressZipCode)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">
						)
					</cfquery>
				</cfif>
			<cfelse>
				<cfquery name="updateMembershipInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					insert into p_EventRegistration_StateESCOrganizations(Site_ID, OrganizationName, Primary_PhoneNumber, Primary_FaxNumber, OrganizationDomainName, StateDOE_IDNUmber, StateDOE_State, dateCreated, lastUpdated, lastUpdateBy)
					Values(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">
					)
				</cfquery>
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
				<cfset PhysicalAddressGeoCoded = #GeoCodeCFC.GeoCodeAddress(Form.PhysicalAddress, FORM.PhysicalCity, FORM.PhysicalState, FORM.PhysicalZipCode)#>

				<cfif PhysicalAddressGeoCoded[1].ErrorMessage NEQ "OK">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.addstateesc&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
				<cfelse>
					<cfset CombinedPhysicalAddress = #PhysicalAddressGeoCoded[1].AddressStreetNumber# & " " & #PhysicalAddressGeoCoded[1].AddressStreetNameShort#>
					<cfswitch expression="#application.configbean.getDBType()#">
						<cfcase value="mysql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_StateESCOrganizations
								Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
									Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressCityName)#">,
									Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressStateNameShort)#">,
									Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressZipCode)#">,
									lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
							</cfquery>
						</cfcase>
						<cfcase value="mssql">
							<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
								update p_EventRegistration_StateESCOrganizations
								Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
									Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressCityName)#">,
									Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressStateNameShort)#">,
									Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressZipCode)#">,
									lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
									lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">
								Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.IdentityCol#">
							</cfquery>
						</cfcase>
					</cfswitch>
				</cfif>
			</cfif>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.listescesa&UserAction=InformationAdded&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="editstateesc" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedESC" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, Physical_Address, Physical_City, Physical_State, Physical_ZipCode
				From p_EventRegistration_StateESCOrganizations
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">  and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.MembershipID#">
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
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.listescesa" addtoken="false">
			</cfif>
			<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/GoogleGeoCoder")>

			<cfif LEN(FORM.MailingAddress) and LEN(FORM.MailingCity) and LEN(FORM.MailingState) and LEN(FORM.MailingZipCode)>
				<cfset MailingAddressGeoCoded = #GeoCodeCFC.GeoCodeAddress(Form.MailingAddress, FORM.MailingCity, FORM.MailingState, FORM.MailingZipCode)#>

				<cfif MailingAddressGeoCoded[1].ErrorMessage NEQ "OK">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
				<cfelse>
					<cfset CombinedPhysicalAddress = #MailingAddressGeoCoded[1].AddressStreetNumber# & " " & #MailingAddressGeoCoded[1].AddressStreetNameShort#>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set OrganizationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
							Mailing_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
							Mailing_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressCityName)#">,
							Mailing_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressStateNameShort)#">,
							Mailing_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.MailingAddressGeoCoded[1].AddressZipCode)#">,
							Primary_PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
							Primary_FaxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
							OrganizationDomainName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
							StateDOE_IDNUmber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
							StateDOE_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			<cfelse>
				<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
					update p_EventRegistration_StateESCOrganizations
					Set OrganizationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
						Primary_PhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
						Primary_FaxNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
						OrganizationDomainName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
						StateDOE_IDNUmber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
						StateDOE_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
						lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
					Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
				</cfquery>
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
				<cfset PhysicalAddressGeoCoded = #GeoCodeCFC.GeoCodeAddress(Form.PhysicalAddress, FORM.PhysicalCity, FORM.PhysicalState, FORM.PhysicalZipCode)#>

				<cfif PhysicalAddressGeoCoded[1].ErrorMessage NEQ "OK">
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
				<cfelse>
					<cfset CombinedPhysicalAddress = #PhysicalAddressGeoCoded[1].AddressStreetNumber# & " " & #PhysicalAddressGeoCoded[1].AddressStreetNameShort#>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_StateESCOrganizations
						Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
							Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressCityName)#">,
							Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressStateNameShort)#">,
							Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressZipCode)#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
			</cfif>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=siteadmin:membership.listescesa&UserAction=InformationUpdated&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

</cfcomponent>
