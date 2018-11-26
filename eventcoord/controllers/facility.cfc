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
		<cfif isDefined("URL._search")>
			<cfif URL._search EQ "false">
				<cfquery name="getFacilities" dbtype="Query">
					Select TContent_ID, FacilityName, PhysicalCity, PhysicalState, PrimaryVoiceNumber, Active
					From Session.getFacilities
					<cfif Arguments.sidx NEQ "">
						Order By #Arguments.sidx# #Arguments.sord#
					<cfelse>
						Order by OrganizationName ASC
					</cfif>
				</cfquery>
			<cfelse>
				<cfquery name="getFacilities" dbtype="Query">
					Select TContent_ID, FacilityName, PhysicalCity, PhysicalState, PrimaryVoiceNumber, Active
					From Session.getFacilities
					<cfif Arguments.sidx NEQ "">
						Where #URL.searchField# LIKE '%#URL.searchString#'
						Order By #Arguments.sidx# #Arguments.sord#
					</cfif>
				</cfquery>
			</cfif>
		<cfelse>
			<cfquery name="getFacilities" dbtype="Query">
				Select TContent_ID, FacilityName, PhysicalCity, PhysicalState, PrimaryVoiceNumber, Active
				From Session.getFacilities
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

		<cfloop query="getFacilities" startrow="#start#" endrow="#end#">
			<!--- Array that will be passed back needed by jqGrid JSON implementation --->
			<cfif #Active# EQ 1>
				<cfset strActive = "Yes">
			<cfelse>
				<cfset strActive = "No">
			</cfif>
			<cfset arrCaterers[i] = [#TContent_ID#,#FacilityName#,#PhysicalCity#,#PhysicalState#,#PrimaryVoiceNumber#,#strActive#]>
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

	<cffunction name="editfacility" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
				From p_EventRegistration_Facility
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">  and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
				Order by FacilityName ASC
			</cfquery>

			<cfquery name="Session.getSelectedFacilityRooms" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, RoomName, Capacity, RoomFees, Active
				From p_EventRegistration_FacilityRooms
				Where Facility_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#"> and Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">
				Order by RoomName ASC
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
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.default" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Catering Facility is active in the database or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&FormRetry=True&FacilityID=#URL.FacilityID#" addtoken="false">
			</cfif>

			<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/SmartyStreets").init(apitoken="O7Oqgg8yl1gV8bJ8572g", apiid="665cc2f2-cacd-6406-3cdc-6bb580e4ac78", verbose=true)>

			<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
				<cfscript>
					PassedAddress = {
						street = #FORM.PhysicalAddress#,
						city = #FORM.PhysicalCity#,
						state = #FORM.PhysicalState#,
						zipcode = #FORM.PhysicalZipCode#
					};
					PhysicalAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
				</cfscript>
				<cfif LEN(PhysicalAddressGeoCoded.Result.errordetail) GT 0>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&FormRetry=True&FacilityID=#URL.FacilityID#" addtoken="false">
				<cfelseif ArrayLen(Variables.PhysicalAddressGeoCoded.Data) GT 0>
					<cfquery name="updateCatererInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						update p_EventRegistration_Facility
						Set FacilityName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.FacilityName#">,
							PhysicalAddress = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.PhysicalAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
							PhysicalCity = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].city_name)#">,
							PhysicalState = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
							PhysicalZipCode = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].zipcode)#">,
							PhysicalZip4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].plus4_code)#">,
							PrimaryVoiceNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryVoiceNumber#">,
							BusinessWebsite = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BusinessWebsite#">,
							ContactName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactName#">,
							ContactPhoneNumber = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactPhoneNumber#">,
							ContactEmail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactEmail#">,
							lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
							Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
							GeoCode_Latitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].latitude)#">,
							GeoCode_Longitude = <cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].longitude)#">
						Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
					</cfquery>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.default&UserAction=InformationUpdated&Successful=True" addtoken="false">
				</cfif>
			</cfif>
 		</cfif>
	</cffunction>

	<cffunction name="editfacilityroom" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
				From p_EventRegistration_Facility
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">  and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
				Order by FacilityName ASC
			</cfquery>

			<cfquery name="Session.getSelectedFacilityRoom" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, RoomName, Capacity, RoomFees, Active
				From p_EventRegistration_FacilityRooms
				Where Facility_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#"> and Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#"> and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityRoomID#">
				Order by RoomName ASC
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
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&FacilityID=#URL.FacilityID#" addtoken="false">
			</cfif>


			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Meeting Room is active or not in the database."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacilityroom&FormRetry=True&FacilityID=#URL.FacilityID#&FacilityRoomID=#URL.FacilityRoomID#" addtoken="false">
			</cfif>

			<cfquery name="updateFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				update p_EventRegistration_FacilityRooms
				Set RoomName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.RoomName#">,
					Capacity = <cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.RoomCapacity#">,
					RoomFees = <cfqueryparam cfsqltype="cf_sql_double" value="#FORM.RoomFees#">,
					Active = <cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
					lastUpdated = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					lastUpdateBy = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">
				Where TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityRoomID#">
			</cfquery>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&UserAction=RoomUpdated&Successful=True&FacilityID=#URL.FacilityID#" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="addfacilityroom" returntype="any" output="false">
		<cfargument name="rc" required="true" type="struct" default="#StructNew()#">

		<cfif not isDefined("FORM.formSubmit")>
			<cfquery name="Session.getSelectedFacility" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				Select TContent_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, lastUpdated, lastUpdateBy, isAddressVerified, GeoCode_Latitude, GeoCode_Longitude, GeoCode_Township, GeoCode_StateLongName, GeoCode_CountryShortName, GeoCode_Neighborhood, Active
				From p_EventRegistration_Facility
				Where Site_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">  and
					TContent_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
				Order by FacilityName ASC
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
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&FacilityID=#URL.FacilityID#" addtoken="false">
			</cfif>


			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Meeting Room is active or not in the database."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacilityroom&FormRetry=True&FacilityID=#URL.FacilityID#&FacilityRoomID=#URL.FacilityRoomID#" addtoken="false">
			</cfif>

			<cfquery name="updateFacilityInformation" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
				insert into p_EventRegistration_FacilityRooms(Site_ID, RoomName, Capacity, RoomFees, Active, dateCreated, lastUpdated, lastUpdateBy, Facility_ID)
				values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.RoomName#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#FORM.RoomCapacity#">,
				<cfqueryparam cfsqltype="cf_sql_double" value="#FORM.RoomFees#">,
				<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.Fname# #Session.Mura.Lname#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#URL.FacilityID#">
				)
			</cfquery>
			<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.editfacility&UserAction=RoomCreated&Successful=True&FacilityID=#URL.FacilityID#" addtoken="false">
		</cfif>
	</cffunction>

	<cffunction name="addfacility" returntype="any" output="false">
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
				<cfset temp = StructDelete(Session, "FormInput")>
				<cfif isDefined("Session.FormInput")><cfset temp = StructDelete(Session, "FormInput")></cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.default" addtoken="false">
			</cfif>

			<cfif FORM.Active EQ "----">
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select if this Facility is active in the database or not."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.addfacility&FormRetry=True" addtoken="false">
			</cfif>

			<cfif LEN(FORM.FacilityName) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please Select which ESC/ESA Membership Affiliation this organization is with."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.addfacility&FormRetry=True" addtoken="false">
			</cfif>

			<cfif LEN(FORM.PhysicalAddress) EQ 0 or LEN(FORM.PhysicalCity) EQ 0 OR LEN(FORM.PhysicalState) EQ 0 OR LEN(FORM.PhysicalZipCode) EQ 0>
				<cfscript>
					errormsg = {property="EmailMsg",message="Please enter the physical address of this organization."};
					arrayAppend(Session.FormErrors, errormsg);
				</cfscript>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.addfacility&FormRetry=True" addtoken="false">
			</cfif>

			<cfset GeoCodeCFC = createObject("component","plugins/#HTMLEditFormat(rc.pc.getPackage())#/library/components/SmartyStreets").init(apitoken="O7Oqgg8yl1gV8bJ8572g", apiid="665cc2f2-cacd-6406-3cdc-6bb580e4ac78", verbose=true)>

			<cfif LEN(FORM.PhysicalAddress) and LEN(FORM.PhysicalCity) and LEN(FORM.PhysicalState) and LEN(FORM.PhysicalZipCode)>
				<cfscript>
					PassedAddress = {
						street = #FORM.PhysicalAddress#,
						city = #FORM.PhysicalCity#,
						state = #FORM.PhysicalState#,
						zipcode = #FORM.PhysicalZipCode#
					};
					PhysicalAddressGeoCoded = GeoCodeCFC.invoke(argumentCollection = PassedAddress);
				</cfscript>
				<cfif LEN(PhysicalAddressGeoCoded.Result.errordetail) GT 0>
					<cflock timeout="60" scope="SESSION" type="Exclusive">
						<cfscript>
							address = {property="BusinessAddress",message="#Variables.AddressGeoCoded[1].ErrorMessageText#"};
							arrayAppend(Session.FormErrors, address);
						</cfscript>
					</cflock>
					<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.addfacility&FormRetry=True" addtoken="false">
				<cfelseif ArrayLen(Variables.PhysicalAddressGeoCoded.Data) GT 0>
					<cfquery name="updateCatererInformation" result="InsertNewRecord" Datasource="#rc.$.globalConfig('datasource')#" username="#rc.$.globalConfig('dbusername')#" password="#rc.$.globalConfig('dbpassword')#">
						insert into p_EventRegistration_Facility(Site_ID, FacilityName, PhysicalAddress, PhysicalCity, PhysicalState, PhysicalZipCode, PhysicalZip4, PrimaryVoiceNumber, BusinessWebsite, ContactName, ContactPhoneNumber, ContactEmail, dateCreated, Active, lastUpdateBy, GeoCode_Latitude, GeoCode_Longitude)
						Values(
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rc.$.siteConfig('siteID')#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.FacilityName#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Variables.PhysicalAddressGeoCoded.Data[1]['Delivery_Line_1']#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].city_name)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].state_abbreviation)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].zipcode)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['components'].plus4_code)#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.PrimaryVoiceNumber#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.BusinessWebsite#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactName#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactPhoneNumber#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.ContactEmail#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="#FORM.Active#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Mura.UserID#">,
							<cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].latitude)#">,
							<cfqueryparam cfsqltype="cf_sql_decimal" value="#Trim(Variables.PhysicalAddressGeoCoded.Data[1]['metadata'].longitude)#">
						)
					</cfquery>
				</cfif>
				<cflocation url="#CGI.Script_name##CGI.path_info#?#HTMLEditFormat(rc.pc.getPackage())#action=eventcoord:facility.default&UserAction=InformationAdded&Successful=True" addtoken="false">
			</cfif>
		</cfif>
	</cffunction>

</cfcomponent>
