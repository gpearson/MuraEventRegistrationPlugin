<cfcomponent output="false" persistent="false" accessors="true">
	<cffunction name="default" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfquery name="Session.getMemberships" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
			Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, AccountsPayable_EmailAddress, AccountsPayable_ContactName
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
		<cfquery name="getFacilities" dbtype="Query">
			Select TContent_ID, OrganizationName, Mailing_State, Primary_PhoneNumber, Active
			From Session.getMemberships
			<cfif Arguments.sidx NEQ "">
				Order By #Arguments.sidx# #Arguments.sord#
			<cfelse>
				Order by OrganizationName ASC
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
			<cfset arrCaterers[i] = [#TContent_ID#,#OrganizationName#,#Mailing_State#,#Primary_PhoneNumber#,#strActive#]>
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
				Select TContent_ID, OrganizationName, OrganizationDomainName, StateDOE_IDNumber, StateDOE_State, Active, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, Physical_Address, Physical_City, Physical_State, Physical_ZipCode, AccountsPayable_EmailAddress, AccountsPayable_ContactName, ReceiveInvoicesByEmail
				From p_EventRegistration_Membership
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">  and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.MembershipID#">
				Order by OrganizationName ASC
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
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
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
							Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
							AccountsPayable_EmailAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableEmailAddress#">,
							AccountsPayable_ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableContactName#">,
							ReceiveInvoicesByEmail = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ReceiveInvoicesByEmail#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.MembershipID#">
					</cfquery>
				</cfif>
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
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
				<cfelse>
					<cfset CombinedPhysicalAddress = #PhysicalAddressGeoCoded[1].AddressStreetNumber# & " " & #PhysicalAddressGeoCoded[1].AddressStreetNameShort#>
					<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Membership
						Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
							Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressCityName)#">,
							Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressStateNameShort)#">,
							Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressZipCode)#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">
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
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
				<cfelse>
					<cfset CombinedPhysicalAddress = #MailingAddressGeoCoded[1].AddressStreetNumber# & " " & #MailingAddressGeoCoded[1].AddressStreetNameShort#>
					<cfquery name="updateMembershipInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						insert into p_EventRegistration_Membership(Site_ID, OrganizationName, Mailing_Address, Mailing_City, Mailing_State, Mailing_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, OrganizationDomainName, StateDOE_IDNUmber, StateDOE_State, Active, AccountsPayable_EmailAddress, AccountsPayable_ContactName, ReceiveInvoicesByEmail, dateCreated, lastUpdated, lastUpdateBy)
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
							<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableEmailAddress#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableContactName#">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ReceiveInvoicesByEmail#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">
						)
					</cfquery>
				</cfif>
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
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.editmembership&FormRetry=True&MembershipID=#URL.MembershipID#" addtoken="false">
				<cfelse>
					<cfset CombinedPhysicalAddress = #PhysicalAddressGeoCoded[1].AddressStreetNumber# & " " & #PhysicalAddressGeoCoded[1].AddressStreetNameShort#>
					<cfif isDefined("InsertNewRecord.GENERATED_KEY")>
						<cfquery name="updateMembershipInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							update p_EventRegistration_Membership
							Set Physical_Address = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
								Physical_City = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressCityName)#">,
								Physical_State = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressStateNameShort)#">,
								Physical_ZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressZipCode)#">,
								lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">
							Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#InsertNewRecord.GENERATED_KEY#">
						</cfquery>
					<cfelse>
						<cfquery name="updateMembershipInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
							insert into p_EventRegistration_Membership(OrganizationName, Physical_Address, Physical_City, Physical_State, Physical_ZipCode, Primary_PhoneNumber, Primary_FaxNumber, OrganizationDomainName, StateDOE_IDNUmber, StateDOE_State, Active, AccountsPayable_EmailAddress, AccountsPayable_ContactName, ReceiveInvoicesByEmail, dateCreated, lastUpdateBy)
							Values(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationName#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.CombinedPhysicalAddress#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressCityName)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressStateNameShort)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded[1].AddressZipCode)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryPhoneNumber#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryFaxNumber#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.OrganizationDomainName#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEIDNumber#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.StateDOEState#">,
								<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableEmailAddress#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.AccountsPayableContactName#">,
								<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.ReceiveInvoicesByEmail#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">
							)
						</cfquery>
					</cfif>
				</cfif>
			</cfif>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:membership.default&UserAction=InformationUpdated&Successful=True" addtoken="false">
		</cfif>
	</cffunction>

</cfcomponent>